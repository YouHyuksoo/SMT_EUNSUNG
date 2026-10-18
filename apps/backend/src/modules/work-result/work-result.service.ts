// 설비별 작업 실적관리 — IP_PRODUCT_RUN_CARD 기준 실적/불량/비가동 실 구현
//
// 실적 저장 테이블(2026-10-19): 완제품 실적 IP_PRODUCT_RESULT 가 건별 실적 원장이다 (IP_PRODUCT_WORK_RESULT 는 안 쓴다).
//   OEE 화면은 SMT 실적을 받지 않는다 — SMT(반제품) 실적은 AOI 로 IP_ASSEMBLY_RESULT 에 자동으로 쌓인다.
//   조립라인(라인구분 L) 포장 공정(W220) 지시의 완료(DONE) 실적이 완제품 실적이고, P_PRODUCT_RESULT_WIP 로 공정재고를 움직인다
//   (제품 공정입고 + 반제품·자재 소모). 포장은 공정재고를 움직이지 않고, 제품창고 입고 때 제품을 공정출고한다.
//   설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md 5-7
//
//   RUN_NO · SEQ_NO      = 작업지시 · 실적 일련번호 (작업지시별 01~99). 테이블 키는 PRODUCT_DATE · PRODUCT_SEQUENCE
//   PRODUCT_ACTUAL_QTY   = 실적수량
//   RESULT_STATUS        = 처리구분 (WIP=진행, DONE=완료/수정불가, CANCEL=취소 — 취소면 PRODUCT_ACTUAL_STATUS 'C')
//   WORKSTAGE_ISSUE_YN   = 공정재고 반영여부 (API 이름은 예전 그대로 sensorApplyYn). 처리구분이 DONE이 되는 순간
//                          1회 반영하고 결과를 남긴다. WIP는 반영하지 않으므로 'N'이지만 실패가 아니다.
//                          Y 반영 / N 미반영 / X 대상 아님(조립라인 아님·전환 전) / C 취소 되돌림 완료
//   WORK_DIVISION        = 조립라인 포장 공정 → P(생산), REPAIR → R(수리), 그 밖(조립라인 가공 공정 포함) → W(가공).
//                          공정재고는 P 만 움직인다. 지금 조립라인 지시는 포장 공정뿐이고(공정 없이 발행되면
//                          TRG_IP_RUN_CARD_WS_DEFAULT 가 W220), 앞으로 내릴 가공 공정 지시 실적은 실적만 남는다.
import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, EntityManager } from 'typeorm';
import { downtimeTargetMachineSql } from '../../common/utils/downtime-target';
import {
  ApplySensorDto,
  CancelResultDto,
  DowntimeBulkDto,
  PlanDowntimeCreateDto,
  WorkResultUpsertDto,
} from './work-result.dto';
import { SMT_LINE_DIVISIONS } from '@smt/shared';

const DEFAULT_USER = 'ADMIN';

/** 조립라인 라인구분 */
const ASSEMBLY_LINE_DIVISION = 'L';
/** 완제품 실적 공정 — 조립라인의 포장 공정 실적이 완제품 실적이다 */
const PACKING_WORKSTAGE = 'W220';

/**
 * 라인구분·공정 → IP_PRODUCT_RESULT.WORK_DIVISION (기초코드 WORK DIVISION: P 생산 · R 수리 · W 가공).
 * P(조립라인 포장 공정)만 공정재고를 움직인다.
 */
function workDivision(lineDivision: string, workstageCode: string): 'P' | 'R' | 'W' {
  if (lineDivision === ASSEMBLY_LINE_DIVISION && workstageCode === PACKING_WORKSTAGE) return 'P';
  if (lineDivision === 'REPAIR') return 'R';
  return 'W';
}


@Injectable()
export class WorkResultService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  private q<T = Record<string, unknown>>(
    sql: string,
    params: unknown[] = [],
  ): Promise<T[]> {
    return this.dataSource.manager.query(sql, params);
  }

  /** 라인구분 (IP_PRODUCT_LINE.LINE_DIVISION) */
  private async lineDivision(mgr: EntityManager, lineCode: string | null, organization: number): Promise<string> {
    if (!lineCode) return '';
    const rows = (await mgr.query(
      `SELECT MAX(LINE_DIVISION) AS "div" FROM IP_PRODUCT_LINE WHERE LINE_CODE=:1 AND ORGANIZATION_ID=:2`,
      [lineCode, organization],
    )) as Array<{ div: string | null }>;
    return rows[0]?.div ?? '';
  }

  private requireOrganization(organizationId?: number): number {
    if (
      organizationId == null ||
      !Number.isInteger(organizationId) ||
      organizationId <= 0
    ) {
      throw new BadRequestException('Authenticated organization is required');
    }
    return organizationId;
  }

  /** 작업지시 목록 — 설비/공정/차종/CT/단위/품목분류 + 계획·실적·부적합 수량 + 설비상태 */
  async list(
    fromDate: string,
    toDate: string,
    lineCode?: string,
    keyword?: string,
    organizationId?: number,
    machineCode?: string,
    excludeSmt?: boolean,
    lineCodes?: string[],
    workstageCode?: string,
  ) {
    const organization = this.requireOrganization(organizationId);
    const params: unknown[] = [organization, fromDate, toDate];
    let where = `r.ORGANIZATION_ID = :1
      AND r.RUN_DATE >= TO_DATE(:2,'YYYY-MM-DD') AND r.RUN_DATE < TO_DATE(:3,'YYYY-MM-DD') + 1`;
    if (lineCodes?.length) {
      const placeholders = lineCodes.map(
        (_, index) => `:${params.length + index + 1}`,
      );
      params.push(...lineCodes);
      where += ` AND r.LINE_CODE IN (${placeholders.join(', ')})`;
    } else if (lineCode) {
      params.push(lineCode);
      where += ` AND r.LINE_CODE = :${params.length}`;
    }
    // 라인구분이 SMT인 라인의 작업지시 제외 (설비별 작업실적관리)
    if (excludeSmt) {
      const binds = SMT_LINE_DIVISIONS.map((d) => {
        params.push(d);
        return `:${params.length}`;
      });
      where += ` AND NOT EXISTS (SELECT 1 FROM IP_PRODUCT_LINE sl WHERE sl.LINE_CODE = r.LINE_CODE
        AND sl.ORGANIZATION_ID = r.ORGANIZATION_ID AND sl.LINE_DIVISION IN (${binds.join(',')}))`;
    }
    // 설비 단위 조회. keyword는 품번·모델명에도 걸려서 설비만 추리는 용도로는 못 쓴다.
    if (machineCode) {
      params.push(machineCode);
      where += ` AND r.MACHINE_CODE = :${params.length}`;
    }
    // 후공정 지시는 공정마다 따로 내린다. 공정이 비어 있는 예전 런카드는 전환 기간 동안 함께 보여준다.
    if (workstageCode) {
      params.push(workstageCode);
      where += ` AND (r.WORKSTAGE_CODE = :${params.length} OR r.WORKSTAGE_CODE IS NULL)`;
    }
    if (keyword) {
      const kw = `%${keyword.toUpperCase()}%`;
      params.push(kw);
      const i = params.length;
      where += ` AND (UPPER(r.ITEM_CODE) LIKE :${i} OR UPPER(r.MODEL_NAME) LIKE :${i} OR UPPER(r.MACHINE_CODE) LIKE :${i}
        OR EXISTS (SELECT 1 FROM IMCN_MACHINE mk WHERE mk.MACHINE_CODE = r.MACHINE_CODE AND mk.ORGANIZATION_ID = r.ORGANIZATION_ID AND UPPER(mk.MACHINE_NAME) LIKE :${i}))`;
    }
    const rowLimit = lineCodes?.length ? 101 : 500;
    return this.q(
      `SELECT * FROM (
        SELECT r.RUN_NO AS "runNo",
          -- 제품생산계획(작업지시, /production/master-plan)의 작업지시번호 — 롯트카드는 LOT_NO = 계획 MFS 로 이어진다
          (SELECT MAX(p.WORK_ORDER_NO) FROM IP_PRODUCT_MI_PLAN p WHERE p.MFS=r.LOT_NO AND p.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "workOrderNo",
          r.MACHINE_CODE AS "machineCode",
          (SELECT MAX(m.MACHINE_NAME) FROM IMCN_MACHINE m WHERE m.MACHINE_CODE=r.MACHINE_CODE AND m.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "machineName",
          r.WORKSTAGE_CODE AS "workstageCode",
          (SELECT MAX(w.WORKSTAGE_NAME) FROM IP_PRODUCT_WORKSTAGE w WHERE w.WORKSTAGE_CODE=r.WORKSTAGE_CODE AND w.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "workstageName",
          (SELECT MAX(w.WORKSTAGE_CODE_GROUP) FROM IP_PRODUCT_WORKSTAGE w WHERE w.WORKSTAGE_CODE=r.WORKSTAGE_CODE AND w.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "workstageGroup",
          TO_CHAR(r.RUN_DATE,'YYYY-MM-DD') AS "runDate",
          r.LINE_CODE AS "lineCode", r.SHIFT_CODE AS "shiftCode",
          r.ITEM_CODE AS "itemCode", r.REVISION AS "revision", r.MODEL_NAME AS "modelName",
          (SELECT MAX(i.ITEM_NAME) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "itemName",
          (SELECT MAX(i.ITEM_UOM) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "unit",
          (SELECT MAX(i.ITEM_CLASS) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "itemClass",
          (SELECT MAX(bc.CODE_MEAN_KOR) FROM ISYS_BASECODE bc WHERE bc.CODE_TYPE='PRODUCT CLASS'
             AND bc.CODE_NAME = (SELECT MAX(mm.PRODUCT_CLASS) FROM IP_PRODUCT_MODEL_MASTER mm WHERE mm.ITEM_CODE=r.ITEM_CODE AND mm.ORGANIZATION_ID=r.ORGANIZATION_ID)) AS "carModel",
          (SELECT MAX(st.CT_VALUE) FROM IP_PRODUCT_ST_MASTER st WHERE st.MODEL_NAME=r.MODEL_NAME AND st.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "ct",
          r.LOT_SIZE AS "planQty",
          NVL((SELECT SUM(wr.PRODUCT_ACTUAL_QTY) FROM IP_PRODUCT_RESULT wr WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID AND NVL(wr.RESULT_STATUS,'WIP')<>'CANCEL'),0) AS "resultQty",
          (SELECT COUNT(*) FROM IP_PRODUCT_RESULT wc WHERE wc.RUN_NO=r.RUN_NO AND wc.ORGANIZATION_ID=r.ORGANIZATION_ID AND NVL(wc.RESULT_STATUS,'WIP')<>'CANCEL') AS "resultCount",
          (SELECT COUNT(*) FROM IP_PRODUCT_RESULT ww WHERE ww.RUN_NO=r.RUN_NO AND ww.ORGANIZATION_ID=r.ORGANIZATION_ID AND NVL(ww.RESULT_STATUS,'WIP') NOT IN ('DONE','CANCEL')) AS "wipCount",
          NVL((SELECT df.BAD_QTY FROM IP_PRODUCT_WORK_DEFECT df WHERE df.RUN_NO=r.RUN_NO AND df.ORGANIZATION_ID=r.ORGANIZATION_ID),0) AS "defectQty",
          (SELECT COUNT(*) FROM IP_EQUIP_DOWNTIME_RESULT dr WHERE dr.MACHINE_CODE=r.MACHINE_CODE AND dr.ORGANIZATION_ID=r.ORGANIZATION_ID AND dr.END_TIME IS NULL) AS "openDowntime"
        FROM IP_PRODUCT_RUN_CARD r
        WHERE ${where}
        ORDER BY r.RUN_DATE DESC, r.RUN_NO
       ) WHERE ROWNUM <= ${rowLimit}`,
      params,
    );
  }

  /** 실적 이력 목록 (작업지시별) */
  results(runNo: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    return this.q(
      `SELECT wr.SEQ_NO AS "seqNo", wr.MACHINE_CODE AS "machineCode", wr.WORKSTAGE_CODE AS "workstageCode",
              wr.PRODUCT_ACTUAL_QTY AS "resultQty", wr.WORK_TIME AS "workTime", wr.WORKER_COUNT AS "workerCount",
              wr.WORKER_NAME AS "workerName",
              NVL(wr.RESULT_STATUS,'WIP') AS "resultStatus",
              NVL(wr.WORKSTAGE_ISSUE_YN,'N') AS "sensorApplyYn", wr.WIP_APPLY_MSG AS "sensorApplyMsg",
              (SELECT r.ITEM_CODE FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=wr.RUN_NO AND r.ORGANIZATION_ID=wr.ORGANIZATION_ID AND ROWNUM=1) AS "itemCode",
              (SELECT r.MODEL_NAME FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=wr.RUN_NO AND r.ORGANIZATION_ID=wr.ORGANIZATION_ID AND ROWNUM=1) AS "modelName",
              TO_CHAR(NVL(wr.LAST_MODIFY_DATE, wr.ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt",
              TO_CHAR(wr.ENTER_DATE,'YYYY-MM-DD HH24:MI:SS') AS "enteredAt"
         FROM IP_PRODUCT_RESULT wr
        WHERE wr.RUN_NO = :1 AND wr.ORGANIZATION_ID = :2
        ORDER BY wr.SEQ_NO`,
      [runNo, organization],
    );
  }

  /** 실적 상세 (헤더) */
  async resultDetail(runNo: string, seqNo: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    const header =
      (
        await this.q(
          `SELECT RUN_NO AS "runNo", SEQ_NO AS "seqNo", MACHINE_CODE AS "machineCode",
              WORKSTAGE_CODE AS "workstageCode",
              PRODUCT_ACTUAL_QTY AS "resultQty", WORK_TIME AS "workTime", WORKER_COUNT AS "workerCount",
              WORKER_NAME AS "workerName",
              NVL(RESULT_STATUS,'WIP') AS "resultStatus",
              NVL(WORKSTAGE_ISSUE_YN,'N') AS "sensorApplyYn", WIP_APPLY_MSG AS "sensorApplyMsg"
         FROM IP_PRODUCT_RESULT WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=:3`,
          [runNo, seqNo, organization],
        )
      )[0] ?? null;
    return { header };
  }

  /**
   * 실적 신규/수정 — 완료(DONE) 실적은 수정 불가. 설비를 run card에 write-back.
   *
   * SMT 라인 지시는 받지 않는다 (SMT 실적은 AOI 로 자동 집계, 보정은 SMD 생산실적 화면).
   * 처리구분이 DONE이면 실적을 커밋한 뒤 공정재고 반영을 1회 한다. 반영이 실패해도 실적은 남기고
   * 경고만 돌려준다(재반영으로 다시 시도).
   */
  async upsertResult(
    dto: WorkResultUpsertDto,
    organizationId?: number,
    userId?: string,
  ): Promise<{ seqNo: string; sensorApplyYn: string; sensorWarning?: string }> {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;
    const machineCode = dto.machineCode?.trim() || null;
    const isDone = dto.resultStatus === 'DONE';

    const { seqNo, workDiv } = await this.dataSource.manager.transaction(async (mgr) => {
      // 라인코드는 작업지시에서 가져온다. 설비의 LINE_CODE는 전부 '*'(미배정)라 쓰지 않는다.
      const runCard = (await mgr.query(
        `SELECT LINE_CODE AS "lineCode", WORKSTAGE_CODE AS "workstageCode", ITEM_CODE AS "itemCode",
                LOT_NO AS "lotNo", TO_CHAR(RUN_DATE,'YYYY-MM-DD') AS "runDate"
           FROM IP_PRODUCT_RUN_CARD
          WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2 FOR UPDATE`,
        [dto.runNo, organization],
      )) as Array<{
        lineCode: string | null; workstageCode: string | null; itemCode: string | null;
        lotNo: string | null; runDate: string | null;
      }>;
      const card = runCard[0];
      if (!card) throw new NotFoundException('작업지시를 찾을 수 없습니다');
      const div = await this.lineDivision(mgr, card.lineCode, organization);
      if ((SMT_LINE_DIVISIONS as readonly string[]).includes(div))
        throw new BadRequestException('SMT 라인 실적은 AOI 로 자동 집계됩니다. 보정은 SMD 생산실적 화면에서 하세요.');
      // 생산지시(런카드)는 공정 단위다. 공정이 정해진 지시에 다른 공정 실적을 넣지 않는다.
      // 공정이 빈 조립라인 지시는 포장 공정 지시다 (발행 트리거가 채우기 전 런카드 대비).
      const fixed = card.workstageCode ?? (div === ASSEMBLY_LINE_DIVISION ? PACKING_WORKSTAGE : null);
      const requested = dto.workstageCode?.trim() || null;
      if (fixed && requested && fixed !== requested) {
        throw new BadRequestException(`이 작업지시는 ${fixed} 공정 지시입니다. 다른 공정 실적은 그 공정 지시로 넣으세요.`);
      }
      const workstage = fixed ?? requested;
      if (!workstage) throw new BadRequestException('공정이 없습니다. 작업지시나 설비의 공정을 확인하세요.');
      const wd = workDivision(div, workstage);
      let seq = dto.seqNo;
      if (seq) {
        const cur = (await mgr.query(
          `SELECT NVL(RESULT_STATUS,'WIP') AS "st" FROM IP_PRODUCT_RESULT
            WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=:3`,
          [dto.runNo, seq, organization],
        )) as Array<{ st: string }>;
        if (!cur.length)
          throw new BadRequestException('실적을 찾을 수 없습니다');
        if (cur[0].st === 'DONE')
          throw new BadRequestException('완료된 실적은 수정할 수 없습니다');
        if (cur[0].st === 'CANCEL')
          throw new BadRequestException('취소된 실적은 수정할 수 없습니다');
        // 실적 시각(PRODUCT_ACTUAL_TIME)은 마지막 저장(완료) 순간으로 둔다 — 공정재고 전환 판정 기준이다
        await mgr.query(
          `UPDATE IP_PRODUCT_RESULT SET MACHINE_CODE=:1, WORKSTAGE_CODE=:2,
             PRODUCT_ACTUAL_QTY=:3, WORK_TIME=:4, WORKER_COUNT=:5, WORKER_NAME=:6, RESULT_STATUS=:7,
             PRODUCT_ACTUAL_TIME=SYSDATE, LAST_MODIFY_BY=:8, LAST_MODIFY_DATE=SYSDATE
           WHERE RUN_NO=:9 AND SEQ_NO=:10 AND ORGANIZATION_ID=:11`,
          [
            machineCode,
            workstage,
            dto.resultQty,
            dto.workTime ?? 0,
            dto.workerCount ?? 0,
            dto.workerName ?? null,
            dto.resultStatus,
            user,
            dto.runNo,
            seq,
            organization,
          ],
        );
      } else {
        // 일련번호는 작업지시별 2자리(01~99)다. 테이블 키는 실적일자(업무일) · SEQ_PRODUCT_ACTUAL.
        const nx = (await mgr.query(
          `SELECT LPAD(TO_CHAR(NVL(MAX(TO_NUMBER(SEQ_NO)),0) + 1),2,'0') AS "seq"
             FROM IP_PRODUCT_RESULT WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`,
          [dto.runNo, organization],
        )) as Array<{ seq: string }>;
        seq = nx[0]?.seq ?? '01';
        // NOT NULL 칸 기본값: 제품구분 T(자작), LQC·OQC W(대기 — 검사 안 함), 입고 N, 실적상태 N(정상)
        await mgr.query(
          `INSERT INTO IP_PRODUCT_RESULT
             (PRODUCT_DATE, PRODUCT_SEQUENCE, ORGANIZATION_ID, PRODUCT_LINE_TYPE, LQC_INSPECT_RESULT, OQC_INSPECT_RESULT,
              PLAN_DATE, WORK_DIVISION, RECEIPT_YN, PRODUCT_ACTUAL_STATUS, ITEM_CODE, MFS, LINE_CODE, WORKSTAGE_CODE,
              MACHINE_CODE, PRODUCT_ACTUAL_QTY, PRODUCT_ACTUAL_TIME, RUN_NO, SEQ_NO, WORK_TIME, WORKER_COUNT, WORKER_NAME,
              RESULT_STATUS, WORKSTAGE_ISSUE_YN, ENTER_BY, ENTER_DATE)
           VALUES (TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')), SEQ_PRODUCT_ACTUAL.NEXTVAL, :1, 'T', 'W', 'W',
              NVL(TO_DATE(:2,'YYYY-MM-DD'), TRUNC(SYSDATE)), :3, 'N', 'N', :4, :5, :6, :7,
              :8, :9, SYSDATE, :10, :11, :12, :13, :14,
              :15, 'N', :16, SYSDATE)`,
          [
            organization,
            card.runDate,
            wd,
            card.itemCode,
            card.lotNo || dto.runNo,
            card.lineCode,
            workstage,
            machineCode,
            dto.resultQty,
            dto.runNo,
            seq,
            dto.workTime ?? 0,
            dto.workerCount ?? 0,
            dto.workerName ?? null,
            dto.resultStatus,
            user,
          ],
        );
      }
      // run card write-back — 설비만 마지막 실적 설비로 둔다. 공정은 발행 때 정해지고 실적이 바꾸지 않는다.
      // 공정이 비어 있는 예전 런카드는 그대로 두어(어느 공정 실적도 받는다) 잘못 넣은 첫 실적에 고정되지 않게 한다.
      await mgr.query(
        `UPDATE IP_PRODUCT_RUN_CARD SET MACHINE_CODE=:1 WHERE RUN_NO=:2 AND ORGANIZATION_ID=:3`,
        [machineCode, dto.runNo, organization],
      );
      return { seqNo: seq!, workDiv: wd };
    });

    if (!isDone) return { seqNo, sensorApplyYn: 'N' };

    // 공정재고는 완제품 실적(조립라인 포장 공정)만 움직인다. 그 밖의 실적은 실적만 남긴다. 'X' = 반영 대상 아님.
    if (workDiv !== 'P') {
      await this.setApply(dto.runNo, seqNo, organization, 'X', null);
      return { seqNo, sensorApplyYn: 'X' };
    }

    // 실적은 위 트랜잭션에서 이미 커밋됐다. 공정재고 반영이 실패해도 실적은 남는다.
    const applied = await this.applyWip(dto.runNo, seqNo, organization, 1);
    return {
      seqNo,
      sensorApplyYn: applied.flag,
      ...(applied.ok ? {} : { sensorWarning: applied.message }),
    };
  }

  private async setApply(runNo: string, seqNo: string, organization: number, flag: string, message: string | null) {
    await this.q(
      `UPDATE IP_PRODUCT_RESULT SET WORKSTAGE_ISSUE_YN=:1, WIP_APPLY_MSG=:2
        WHERE RUN_NO=:3 AND SEQ_NO=:4 AND ORGANIZATION_ID=:5`,
      [flag, message, runNo, seqNo, organization],
    );
  }

  /**
   * 공정재고 반영(sign 1) · 되돌림(sign -1) — P_PRODUCT_RESULT_WIP 와 반영 상태 기록을 한 블록(한 트랜잭션)으로 한다.
   * 프로시저가 'SKIP:...' 을 돌려주면(전환 전 실적 등) 아무것도 넣지 않은 것이고 'X' 로 남긴다.
   */
  private async applyWip(
    runNo: string,
    seqNo: string,
    organization: number,
    sign: 1 | -1,
  ): Promise<{ ok: boolean; flag: string; message: string }> {
    try {
      const rows = await this.dataSource.manager.transaction(async (mgr) => {
        await mgr.query(
          `DECLARE
             v_date DATE;
             v_seq  NUMBER;
             v_res  VARCHAR2(200);
             v_run  VARCHAR2(30) := :1;  -- PL/SQL 위치 바인드는 처음 나오는 순서대로라 여기서 한 번씩만 받는다
             v_no   VARCHAR2(2)  := :2;
             v_org  NUMBER := :3;
             v_sign NUMBER := :4;
           BEGIN
             SELECT PRODUCT_DATE, PRODUCT_SEQUENCE INTO v_date, v_seq FROM IP_PRODUCT_RESULT
              WHERE RUN_NO = v_run AND SEQ_NO = v_no AND ORGANIZATION_ID = v_org;
             P_PRODUCT_RESULT_WIP(v_date, v_seq, v_org, v_sign, v_res);
             UPDATE IP_PRODUCT_RESULT
                SET WORKSTAGE_ISSUE_YN = CASE WHEN v_res LIKE 'SKIP%' THEN 'X' WHEN v_sign < 0 THEN 'C' ELSE 'Y' END,
                    WIP_APPLY_MSG = CASE WHEN v_res LIKE 'SKIP%' THEN v_res END
              WHERE PRODUCT_DATE = v_date AND PRODUCT_SEQUENCE = v_seq AND ORGANIZATION_ID = v_org;
           END;`,
          [runNo, seqNo, organization, sign],
        );
        return (await mgr.query(
          `SELECT WORKSTAGE_ISSUE_YN AS "flag", WIP_APPLY_MSG AS "msg" FROM IP_PRODUCT_RESULT
            WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=:3`,
          [runNo, seqNo, organization],
        )) as Array<{ flag: string; msg: string | null }>;
      });
      return { ok: true, flag: rows[0]?.flag ?? 'N', message: rows[0]?.msg ?? 'OK' };
    } catch (error: unknown) {
      // Oracle·프로시저 원문을 보존한다 — 요약으로 덮지 않는다.
      const message = error instanceof Error ? error.message : String(error);
      const flag = sign < 0 ? 'Y' : 'N';
      await this.setApply(runNo, seqNo, organization, flag, (sign < 0 ? `취소 되돌림 실패: ${message}` : message).slice(0, 1000));
      return { ok: false, flag, message };
    }
  }

  /**
   * 실적 취소 — 행은 지우지 않고 RESULT_STATUS='CANCEL', PRODUCT_ACTUAL_STATUS='C' 로 남긴다(합계에서 빠진다).
   *
   * 오늘 업무일(F_GET_WORK_ACTUAL_DATE) 실적만 취소한다. 지난 업무일 실적이 바뀌면 이미 본 집계가 틀어진다.
   * 공정재고에 반영된 실적이면 같은 수량을 음수로 넣어 되돌린다.
   * 되돌림에 실패해도 취소는 유지하고 경고를 돌려준다(반영여부는 'Y' 로 남아 재확인할 수 있다).
   */
  async cancelResult(
    dto: CancelResultDto,
    organizationId?: number,
    userId?: string,
  ): Promise<{ cancelled: true; sensorWarning?: string }> {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;

    const row = await this.dataSource.manager.transaction(async (mgr) => {
      const rows = (await mgr.query(
        `SELECT NVL(wr.RESULT_STATUS,'WIP') AS "st", NVL(wr.WORKSTAGE_ISSUE_YN,'N') AS "applied",
                CASE WHEN F_GET_WORK_ACTUAL_DATE(wr.ENTER_DATE,'A') = F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')
                     THEN 'Y' ELSE 'N' END AS "today"
           FROM IP_PRODUCT_RESULT wr
          WHERE wr.RUN_NO=:1 AND wr.SEQ_NO=:2 AND wr.ORGANIZATION_ID=:3
          FOR UPDATE`,
        [dto.runNo, dto.seqNo, organization],
      )) as Array<{ st: string; applied: string; today: string }>;
      const cur = rows[0];
      if (!cur) throw new NotFoundException('실적을 찾을 수 없습니다');
      if (cur.st === 'CANCEL') throw new BadRequestException('이미 취소된 실적입니다');
      if (cur.today !== 'Y') throw new BadRequestException('오늘 업무일 실적만 취소할 수 있습니다');
      await mgr.query(
        `UPDATE IP_PRODUCT_RESULT SET RESULT_STATUS='CANCEL', PRODUCT_ACTUAL_STATUS='C', LAST_MODIFY_BY=:1, LAST_MODIFY_DATE=SYSDATE
          WHERE RUN_NO=:2 AND SEQ_NO=:3 AND ORGANIZATION_ID=:4`,
        [user, dto.runNo, dto.seqNo, organization],
      );
      return cur;
    });

    // 공정재고에 반영되지 않은 실적은 되돌릴 것이 없다
    if (row.applied !== 'Y') return { cancelled: true };

    const reverted = await this.applyWip(dto.runNo, dto.seqNo, organization, -1);
    return reverted.ok ? { cancelled: true } : { cancelled: true, sensorWarning: reverted.message };
  }

  /** 공정재고 반영 재시도 — 완료 상태인데 미반영인 실적만 대상이다 */
  async applySensor(
    dto: ApplySensorDto,
    organizationId?: number,
  ): Promise<{ sensorApplyYn: string; sensorWarning?: string }> {
    const organization = this.requireOrganization(organizationId);
    const rows = (await this.q(
      `SELECT NVL(wr.RESULT_STATUS,'WIP') AS "resultStatus", NVL(wr.WORKSTAGE_ISSUE_YN,'N') AS "sensorApplyYn",
              wr.WORK_DIVISION AS "workDiv"
         FROM IP_PRODUCT_RESULT wr
        WHERE wr.RUN_NO=:1 AND wr.SEQ_NO=:2 AND wr.ORGANIZATION_ID=:3`,
      [dto.runNo, dto.seqNo, organization],
    )) as Array<{ resultStatus: string; sensorApplyYn: string; workDiv: string | null }>;
    const row = rows[0];
    if (!row) throw new NotFoundException('실적을 찾을 수 없습니다');
    if (row.resultStatus !== 'DONE')
      throw new BadRequestException('완료된 실적만 공정재고에 반영할 수 있습니다');
    // 이미 반영된 건을 다시 넣으면 수량이 가산된다 — 반드시 막는다.
    if (row.sensorApplyYn === 'Y')
      throw new BadRequestException('이미 공정재고에 반영된 실적입니다');
    if (row.sensorApplyYn === 'X' || row.workDiv !== 'P')
      throw new BadRequestException('완제품 실적(조립라인 포장 공정)이 아니라 공정재고 반영 대상이 아닙니다');

    const applied = await this.applyWip(dto.runNo, dto.seqNo, organization, 1);
    return {
      sensorApplyYn: applied.flag,
      ...(applied.ok ? {} : { sensorWarning: applied.message }),
    };
  }

  async getDefect(runNo: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    return (
      (
        await this.q(
          `SELECT BAD_CODE AS "badCode", BAD_QTY AS "badQty", REMARK AS "remark"
         FROM IP_PRODUCT_WORK_DEFECT WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`,
          [runNo, organization],
        )
      )[0] ?? null
    );
  }

  /** 작업지시 대표불량 단일 저장 — 계획수량 항상, 실적수량(합>0)일 때 상한 검증. 실적과 독립 */
  async saveDefect(
    runNo: string,
    badCode: string,
    badQty: number,
    remark: string | undefined,
    organizationId?: number,
    userId?: string,
  ): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;
    const info = (
      await this.q(
        `SELECT NVL(r.LOT_SIZE,0) AS "planQty",
              NVL((SELECT SUM(wr.PRODUCT_ACTUAL_QTY) FROM IP_PRODUCT_RESULT wr WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID AND NVL(wr.RESULT_STATUS,'WIP')<>'CANCEL'),0) AS "resultQty"
         FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=:1 AND r.ORGANIZATION_ID=:2`,
        [runNo, organization],
      )
    )[0] as { planQty: number; resultQty: number } | undefined;
    if (!info) throw new BadRequestException('작업지시를 찾을 수 없습니다');
    const plan = Number(info.planQty ?? 0);
    const result = Number(info.resultQty ?? 0);
    const qty = Number(badQty ?? 0);
    if (!badCode) throw new BadRequestException('대표 불량유형을 선택하세요');
    if (qty > plan)
      throw new BadRequestException(
        `불량수량(${qty})이 계획수량(${plan})을 초과할 수 없습니다`,
      );
    if (result > 0 && qty > result)
      throw new BadRequestException(
        `불량수량(${qty})이 실적수량(${result})을 초과할 수 없습니다`,
      );
    await this.dataSource.manager.transaction(async (mgr) => {
      const ex = (await mgr.query(
        `SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_WORK_DEFECT WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`,
        [runNo, organization],
      )) as Array<{ cnt: number }>;
      if (Number(ex[0]?.cnt ?? 0) > 0) {
        await mgr.query(
          `UPDATE IP_PRODUCT_WORK_DEFECT SET BAD_CODE=:1, BAD_QTY=:2, REMARK=:3, LAST_MODIFY_BY=:4, LAST_MODIFY_DATE=SYSDATE WHERE RUN_NO=:5 AND ORGANIZATION_ID=:6`,
          [badCode, qty, remark ?? null, user, runNo, organization],
        );
      } else {
        await mgr.query(
          `INSERT INTO IP_PRODUCT_WORK_DEFECT (RUN_NO, ORGANIZATION_ID, BAD_CODE, BAD_QTY, REMARK, ENTER_BY, ENTER_DATE) VALUES (:1,:2,:3,:4,:5,:6,SYSDATE)`,
          [runNo, organization, badCode, qty, remark ?? null, user],
        );
      }
    });
  }

  /** 부적합 유형 (ISYS_CODE_MASTER WQC BAD REASON CODE) */
  badReasons(organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    return this.q(
      `SELECT CODE_NAME AS "code", NVL(CODE_MEAN_KOR, CODE_MEAN_ENG) AS "name"
         FROM ISYS_CODE_MASTER WHERE CODE_TYPE='WQC BAD REASON CODE' AND ORGANIZATION_ID=:1
         ORDER BY CODE_NAME`,
      [organization],
    );
  }

  /** 후공정(PBA) 설비 콤보 — 검사공정(공정유형 Q) 설비는 뺀다 */
  machines(organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    return this.q(
      `SELECT m.MACHINE_CODE AS "machineCode", m.MACHINE_NAME AS "machineName",
              m.WORKSTAGE_CODE AS "workstageCode",
              (SELECT MAX(w2.WORKSTAGE_NAME) FROM IP_PRODUCT_WORKSTAGE w2 WHERE w2.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w2.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "workstageName",
              m.LINE_CODE AS "lineCode"
         FROM IMCN_MACHINE m
         JOIN IP_PRODUCT_WORKSTAGE w ON w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID
        WHERE m.ORGANIZATION_ID=:1 AND w.WORKSTAGE_CODE_GROUP='PBA'
          AND NVL(w.WORKSTAGE_TYPE,'I')<>'Q'  -- 검사공정(ICT·성능검사 등) 설비는 실적 대상이 아니다
        ORDER BY m.MACHINE_CODE`,
      [organization],
    );
  }

  /**
   * 설비비가동 등록용 설비 콤보 — 작업지시 기준
   * 1) 작업지시에 설비가 있으면 그 설비로 고정(fixed)
   * 2) 설비 없이 공정만 있으면 그 공정의 배치 설비(IMCN_MACHINE.WORKSTAGE_CODE)
   * 3) 둘 다 없으면 작업지시 라인코드와 같은 배치 설비(IMCN_MACHINE.LINE_CODE)
   */
  async downtimeMachines(runNo: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    const run = (await this.q<{ machineCode: string | null; workstageCode: string | null; lineCode: string | null }>(
      `SELECT MACHINE_CODE AS "machineCode", WORKSTAGE_CODE AS "workstageCode", LINE_CODE AS "lineCode"
         FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`,
      [runNo, organization],
    ))[0];
    if (!run) throw new NotFoundException(`작업지시를 찾을 수 없습니다: ${runNo}`);

    const select = `SELECT m.MACHINE_CODE AS "machineCode", m.MACHINE_NAME AS "machineName",
              m.WORKSTAGE_CODE AS "workstageCode", m.LINE_CODE AS "lineCode"
         FROM IMCN_MACHINE m WHERE m.ORGANIZATION_ID=:1`;
    let by: 'machine' | 'workstage' | 'line' | 'none';
    let list: Array<Record<string, unknown>> = [];
    if (run.machineCode) {
      by = 'machine';
      list = await this.q(`${select} AND m.MACHINE_CODE=:2`, [organization, run.machineCode]);
      // 설비 마스터에 없어도 작업지시 설비로 고정한다
      if (!list.length) list = [{ machineCode: run.machineCode, machineName: null, workstageCode: run.workstageCode, lineCode: run.lineCode }];
    } else if (run.workstageCode) {
      by = 'workstage';
      list = await this.q(`${select} AND m.WORKSTAGE_CODE=:2 ORDER BY m.MACHINE_CODE`, [organization, run.workstageCode]);
    } else if (run.lineCode) {
      by = 'line';
      list = await this.q(`${select} AND m.LINE_CODE=:2 ORDER BY m.MACHINE_CODE`, [organization, run.lineCode]);
    } else {
      by = 'none';
    }
    return { by, fixed: by === 'machine', list };
  }

  /** 설비 연계 비가동 사유 (없으면 전체 사용중 사유) */
  async downtimeReasons(
    machineCode?: string,
    organizationId?: number,
    reasonType?: string,
  ) {
    const organization = this.requireOrganization(organizationId);
    // 계획 비가동 화면은 설비 매핑과 무관하게 REASON_TYPE='PLAN' 전체를 쓴다.
    if (reasonType) {
      return this.q(
        `SELECT REASON_CODE AS "code", REASON_NAME AS "name" FROM IP_EQUIP_DOWNTIME_REASON
          WHERE ORGANIZATION_ID=:1 AND USE_YN='Y' AND REASON_TYPE=:2
          ORDER BY DISPLAY_ORDER, REASON_CODE`,
        [organization, reasonType],
      );
    }
    if (machineCode) {
      const mapped = await this.q(
        `SELECT r.REASON_CODE AS "code", r.REASON_NAME AS "name"
           FROM IP_EQUIP_DOWNTIME_MAP_DTL d
           JOIN IP_EQUIP_DOWNTIME_REASON r ON r.REASON_CODE=d.REASON_CODE AND r.ORGANIZATION_ID=d.ORGANIZATION_ID
          WHERE d.MACHINE_CODE=:1 AND d.ORGANIZATION_ID=:2 AND r.USE_YN='Y'
          ORDER BY NVL(d.SORT_NO,0), r.DISPLAY_ORDER`,
        [machineCode, organization],
      );
      if (mapped.length) return mapped;
    }
    return this.q(
      `SELECT REASON_CODE AS "code", REASON_NAME AS "name" FROM IP_EQUIP_DOWNTIME_REASON
        WHERE ORGANIZATION_ID=:1 AND USE_YN='Y' ORDER BY DISPLAY_ORDER, REASON_CODE`,
      [organization],
    );
  }

  /** 비가동 실적 목록 (설비별 — 작업지시 선택 여부와 무관, ADR 0002)
   *  serverNow(DB SYSDATE)를 함께 반환한다. 경과 타이머가 브라우저 시계로 계산하면
   *  DB 서버와의 시계 차이만큼 어긋나므로 클라이언트에서 이 값으로 보정한다. */
  async downtimes(machineCode: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    const list = await this.q(
      `SELECT DT_SEQ AS "dtSeq", RUN_NO AS "runNo", MACHINE_CODE AS "machineCode", WORKSTAGE_CODE AS "workstageCode",
              REASON_CODE AS "reasonCode",
              (SELECT MAX(r.REASON_NAME) FROM IP_EQUIP_DOWNTIME_REASON r WHERE r.REASON_CODE=d.REASON_CODE AND r.ORGANIZATION_ID=d.ORGANIZATION_ID) AS "reasonName",
              TO_CHAR(START_TIME,'YYYY-MM-DD HH24:MI') AS "startTime",
              TO_CHAR(START_TIME,'YYYY-MM-DD HH24:MI:SS') AS "startAt",
              TO_CHAR(END_TIME,'YYYY-MM-DD HH24:MI') AS "endTime",
              MEMO AS "memo", WORKER AS "worker"
         FROM IP_EQUIP_DOWNTIME_RESULT d
        WHERE MACHINE_CODE=:1 AND ORGANIZATION_ID=${organization} ORDER BY DT_SEQ`,
      [machineCode],
    );
    const now = await this.q<{ now: string }>(
      `SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS "now" FROM DUAL`,
    );
    return { list, serverNow: now[0]?.now ?? null };
  }

  /* ── 계획 비가동 ──
   * 체크한 일자 x 선택한 설비에 같은 사유·시간을 적용해 IP_EQUIP_DOWNTIME_RESULT에 넣는다.
   * 기존 행과 시간대가 겹치면 그 행이 계획(PLAN)일 때만 지우고 다시 넣는다. 실제 발생한
   * 비가동(UNPLAN)은 건드리지 않고 건너뛴 뒤 사유를 돌려준다.
   */
  async createPlanDowntime(
    dto: PlanDowntimeCreateDto,
    organizationId?: number,
    userId?: string,
  ) {
    const organization = this.requireOrganization(organizationId);
    if (dto.endHm <= dto.startHm) {
      throw new BadRequestException('종료시간은 시작시간보다 늦어야 합니다.');
    }
    const user = userId ?? dto.userId ?? DEFAULT_USER;

    return this.dataSource.manager.transaction(async (mgr) => {
      // 설비의 공정코드·라인코드를 한 번에 확보한다(일자 수만큼 재조회하지 않기 위함).
      const binds = dto.machineCodes.map((_, i) => `:${i + 2}`).join(',');
      const wsRows = (await mgr.query(
        `SELECT MACHINE_CODE AS "machineCode", WORKSTAGE_CODE AS "workstageCode", LINE_CODE AS "lineCode"
           FROM IMCN_MACHINE WHERE ORGANIZATION_ID=:1 AND MACHINE_CODE IN (${binds})`,
        [organization, ...dto.machineCodes],
      )) as Array<{ machineCode: string; workstageCode: string | null; lineCode: string | null }>;
      const wsMap = new Map(wsRows.map((r) => [r.machineCode, r.workstageCode]));
      const lineMap = new Map(wsRows.map((r) => [r.machineCode, r.lineCode]));

      let inserted = 0;
      let replaced = 0;
      const skippedDetail: Array<{ date: string; machineCode: string; reasonName: string | null }> = [];

      for (const date of dto.dates) {
        const startAt = `${date} ${dto.startHm}`;
        const endAt = `${date} ${dto.endHm}`;
        for (const machineCode of dto.machineCodes) {
          // 같은 설비에서 시간대가 겹치는 기존 행. END_TIME이 없으면(진행중) 무한으로 본다.
          const clash = (await mgr.query(
            `SELECT d.DT_SEQ AS "dtSeq", r.REASON_TYPE AS "reasonType", r.REASON_NAME AS "reasonName"
               FROM IP_EQUIP_DOWNTIME_RESULT d
               LEFT JOIN IP_EQUIP_DOWNTIME_REASON r
                 ON r.REASON_CODE = d.REASON_CODE AND r.ORGANIZATION_ID = d.ORGANIZATION_ID
              WHERE d.ORGANIZATION_ID = :1
                AND d.MACHINE_CODE = :2
                AND d.START_TIME < TO_DATE(:3,'YYYY-MM-DD HH24:MI')
                AND NVL(d.END_TIME, DATE '9999-12-31') > TO_DATE(:4,'YYYY-MM-DD HH24:MI')`,
            [organization, machineCode, endAt, startAt],
          )) as Array<{ dtSeq: number; reasonType: string | null; reasonName: string | null }>;

          const blocking = clash.find((c) => c.reasonType !== 'PLAN');
          if (blocking) {
            skippedDetail.push({ date, machineCode, reasonName: blocking.reasonName });
            continue;
          }
          for (const c of clash) {
            await mgr.query(
              `DELETE FROM IP_EQUIP_DOWNTIME_RESULT WHERE ORGANIZATION_ID=:1 AND DT_SEQ=:2`,
              [organization, c.dtSeq],
            );
            replaced += 1;
          }

          const nx = (await mgr.query(
            `SELECT SEQ_IP_EQUIP_DOWNTIME.NEXTVAL AS "seq" FROM DUAL`,
          )) as Array<{ seq: number }>;
          await mgr.query(
            `INSERT INTO IP_EQUIP_DOWNTIME_RESULT
               (RUN_NO, DT_SEQ, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, LINE_CODE, REASON_CODE,
                START_TIME, END_TIME, ENTER_BY, ENTER_DATE)
             VALUES (NULL, :1, :2, :3, :4, :5, :6,
                     TO_DATE(:7,'YYYY-MM-DD HH24:MI'), TO_DATE(:8,'YYYY-MM-DD HH24:MI'), :9, SYSDATE)`,
            [
              Number(nx[0]?.seq),
              organization,
              machineCode,
              wsMap.get(machineCode) ?? null,
              lineMap.get(machineCode) ?? null,
              dto.reasonCode,
              startAt,
              endAt,
              user,
            ],
          );
          inserted += 1;
        }
      }
      return { inserted, replaced, skipped: skippedDetail.length, skippedDetail };
    });
  }

  /** 기간 내 계획 비가동 목록 — 캘린더 뱃지와 일자별 목록 모달이 함께 쓴다. */
  async planDowntimes(from: string, to: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    return this.q(
      `SELECT d.DT_SEQ AS "dtSeq", d.MACHINE_CODE AS "machineCode",
              m.MACHINE_NAME AS "machineName",
              d.REASON_CODE AS "reasonCode", r.REASON_NAME AS "reasonName",
              TO_CHAR(d.START_TIME,'YYYY-MM-DD') AS "planDate",
              TO_CHAR(d.START_TIME,'HH24:MI') AS "startHm",
              TO_CHAR(d.END_TIME,'HH24:MI') AS "endHm"
         FROM IP_EQUIP_DOWNTIME_RESULT d
         JOIN IP_EQUIP_DOWNTIME_REASON r
           ON r.REASON_CODE = d.REASON_CODE AND r.ORGANIZATION_ID = d.ORGANIZATION_ID
         LEFT JOIN IMCN_MACHINE m
           ON m.MACHINE_CODE = d.MACHINE_CODE AND m.ORGANIZATION_ID = d.ORGANIZATION_ID
        WHERE d.ORGANIZATION_ID = ${organization}
          AND r.REASON_TYPE = 'PLAN'
          AND d.START_TIME >= TO_DATE(:1,'YYYY-MM-DD')
          AND d.START_TIME < TO_DATE(:2,'YYYY-MM-DD') + 1
        ORDER BY d.START_TIME, d.MACHINE_CODE`,
      [from, to],
    );
  }

  /** 비가동 1건 삭제 (계획 비가동 취소) */
  async deleteDowntime(dtSeq: number, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    const rows = (await this.q(
      `SELECT DT_SEQ AS "dtSeq" FROM IP_EQUIP_DOWNTIME_RESULT
        WHERE ORGANIZATION_ID=${organization} AND DT_SEQ=:1`,
      [dtSeq],
    )) as Array<{ dtSeq: number }>;
    if (!rows.length) throw new NotFoundException(`비가동 이력을 찾을 수 없습니다: ${dtSeq}`);
    await this.dataSource.manager.query(
      `DELETE FROM IP_EQUIP_DOWNTIME_RESULT WHERE ORGANIZATION_ID=${organization} AND DT_SEQ=:1`,
      [dtSeq],
    );
    return { deleted: 1 };
  }

  /** OEE 비가동 입력 보드 — 공정(SMT/ASSY)의 라인과 그 라인의 비가동 대상 설비, 설비별 진행중 비가동을 한 번에.
   *  라인은 묶음일 뿐이고 상태는 설비 기준이다(ADR 0002). 설비가 없는 라인도 목록에 남긴다(설비 미지정 안내용). */
  async downtimeBoard(processCode: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    if (processCode !== 'SMT' && processCode !== 'ASSY') throw new BadRequestException('지원하지 않는 공정입니다.');
    // 오라클 배열 바인드는 이름이 아니라 등장 순서로 채워진다 — 같은 :n 을 두 번 쓰지 않는다
    const lineFilter = (org: number, proc: number) =>
      `l.ORGANIZATION_ID=:${org} AND l.PROCESS_CODE=:${proc} AND l.RESOURCE_TYPE IN ('LINE','CELL')
                        AND l.LINE_CODE IS NOT NULL AND l.LINE_NAME IS NOT NULL`;
    const lines = await this.q<{ lineCode: string; lineName: string }>(
      `SELECT l.LINE_CODE AS "lineCode", l.LINE_NAME AS "lineName" FROM IP_PRODUCT_LINE l WHERE ${lineFilter(1, 2)} ORDER BY l.LINE_CODE`,
      [organization, processCode],
    );
    const rows = await this.q<{
      machineCode: string; machineName: string | null; lineCode: string; workstageCode: string | null; workstageName: string | null;
      dtSeq: number | null; reasonCode: string | null; reasonName: string | null; startAt: string | null; closedSecToday: number | null;
    }>(
      `SELECT m.MACHINE_CODE AS "machineCode", m.MACHINE_NAME AS "machineName", m.LINE_CODE AS "lineCode",
              m.WORKSTAGE_CODE AS "workstageCode",
              (SELECT MAX(w.WORKSTAGE_NAME) FROM IP_PRODUCT_WORKSTAGE w
                WHERE w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "workstageName",
              d.DT_SEQ AS "dtSeq", d.REASON_CODE AS "reasonCode", r.REASON_NAME AS "reasonName",
              TO_CHAR(d.START_TIME,'YYYY-MM-DD HH24:MI:SS') AS "startAt",
              -- 오늘(달력일) 종료된 비가동 누적 초 — 진행중 분은 화면이 시작시각부터 실시간으로 더한다
              (SELECT NVL(ROUND(SUM((LEAST(x.END_TIME, TRUNC(SYSDATE) + 1) - GREATEST(x.START_TIME, TRUNC(SYSDATE))) * 86400)), 0)
                 FROM IP_EQUIP_DOWNTIME_RESULT x
                WHERE x.ORGANIZATION_ID = m.ORGANIZATION_ID AND x.MACHINE_CODE = m.MACHINE_CODE
                  AND x.END_TIME IS NOT NULL AND x.START_TIME < TRUNC(SYSDATE) + 1 AND x.END_TIME > TRUNC(SYSDATE)) AS "closedSecToday"
         FROM IMCN_MACHINE m
         LEFT JOIN IP_EQUIP_DOWNTIME_RESULT d
           ON d.ORGANIZATION_ID=m.ORGANIZATION_ID AND d.MACHINE_CODE=m.MACHINE_CODE AND d.END_TIME IS NULL
         LEFT JOIN IP_EQUIP_DOWNTIME_REASON r
           ON r.REASON_CODE=d.REASON_CODE AND r.ORGANIZATION_ID=d.ORGANIZATION_ID
        WHERE m.ORGANIZATION_ID=:1 AND ${downtimeTargetMachineSql('m')}
          AND m.LINE_CODE IN (SELECT l.LINE_CODE FROM IP_PRODUCT_LINE l WHERE ${lineFilter(2, 3)})
        ORDER BY m.LINE_CODE, m.WORKSTAGE_CODE, m.MACHINE_CODE, d.DT_SEQ`,
      [organization, organization, processCode],
    );
    // 설비 1대에 진행중 행이 둘 이상이면(정상은 아님) 가장 최근 것을 보인다
    const machines = new Map<string, (typeof rows)[number]>();
    for (const row of rows) machines.set(row.machineCode, row);
    const now = await this.q<{ now: string }>(`SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS "now" FROM DUAL`);
    return {
      serverNow: now[0]?.now ?? null,
      lines: lines.map((line) => ({
        ...line,
        machines: [...machines.values()]
          .filter((m) => m.lineCode === line.lineCode)
          .map((m) => ({
            machineCode: m.machineCode,
            machineName: m.machineName,
            workstageCode: m.workstageCode,
            workstageName: m.workstageName,
            open: m.dtSeq == null ? null : { dtSeq: Number(m.dtSeq), reasonCode: m.reasonCode, reasonName: m.reasonName, startAt: m.startAt },
            closedSecToday: Number(m.closedSecToday ?? 0),
          })),
      })),
    };
  }

  /* ── 설비 비가동 공통 처리 ──
   * 설비정지 모달·설비 운영 현황·현장 운영·OEE 비가동 입력이 모두 bulkDowntime 으로 여기를 지난다.
   * 1) 대상 설비 행을 코드 순서로 잠근다 — 같은 설비를 두 화면이 동시에 시작해도 한쪽만 들어간다.
   * 2) 진행중 판정은 MACHINE_CODE 기준(ADR 0002).
   * 3) 종료는 END_TIME IS NULL 인 행만 닫는다 — 다른 화면에서 이미 닫은 행을 다시 덮어쓰지 않는다.
   */
  private async lockDowntimeMachines(
    mgr: EntityManager,
    organization: number,
    machineCodes: string[],
  ): Promise<Map<string, { workstageCode: string | null; lineCode: string | null }>> {
    const codes = [...new Set(machineCodes)].sort();
    if (!codes.length) return new Map();
    const binds = codes.map((_, i) => `:${i + 2}`).join(',');
    const rows = (await mgr.query(
      `SELECT m.MACHINE_CODE AS "machineCode", m.WORKSTAGE_CODE AS "workstageCode", m.LINE_CODE AS "lineCode"
         FROM IMCN_MACHINE m
        WHERE m.ORGANIZATION_ID=:1 AND m.MACHINE_CODE IN (${binds}) AND ${downtimeTargetMachineSql('m')}
        ORDER BY m.MACHINE_CODE
          FOR UPDATE`,
      [organization, ...codes],
    )) as Array<{ machineCode: string; workstageCode: string | null; lineCode: string | null }>;
    const found = new Map(
      rows.map((r) => [r.machineCode, { workstageCode: r.workstageCode, lineCode: r.lineCode === '*' ? null : r.lineCode }]),
    );
    const missing = codes.filter((code) => !found.has(code));
    if (missing.length) throw new BadRequestException(`비가동 대상 설비가 아닙니다: ${missing.join(', ')}`);
    return found;
  }

  private affectedRows(value: unknown): number {
    if (typeof value === 'number') return value;
    if (Array.isArray(value) && typeof value[1] === 'number') return value[1];
    if (value && typeof value === 'object') {
      const v = value as { rowsAffected?: number; affected?: number };
      return Number(v.rowsAffected ?? v.affected ?? 0);
    }
    return 0;
  }

  /** 진행중 비가동 1건 종료 — 이미 닫혔으면 Conflict */
  private async closeOpenDowntime(
    mgr: EntityManager,
    organization: number,
    dtSeq: number,
    reasonCode: string | null,
    user: string,
  ): Promise<void> {
    const result: unknown = await mgr.query(
      `UPDATE IP_EQUIP_DOWNTIME_RESULT SET REASON_CODE=NVL(:1, REASON_CODE),
         END_TIME=SYSDATE, LAST_MODIFY_BY=:2, LAST_MODIFY_DATE=SYSDATE
       WHERE DT_SEQ=:3 AND ORGANIZATION_ID=:4 AND END_TIME IS NULL`,
      [reasonCode, user, dtSeq, organization],
    );
    if (this.affectedRows(result) !== 1) {
      throw new ConflictException('이미 종료된 비가동입니다. 화면을 새로고침하세요.');
    }
  }

  /** 설비 비가동 시작·종료 — 비가동을 쓰는 유일한 경로다(설비 1대도 이걸로).
   *  비가동 한 건 = 설비 · 사유 · 시작~종료. 라인을 주면 그 라인의 비가동 대상 설비 전부.
   *  이미 그 상태인 설비는 건너뛰고 결과를 요약해 돌려준다 — 한 대 때문에 전체가 막히지 않게. */
  async bulkDowntime(dto: DowntimeBulkDto, organizationId?: number, userId?: string) {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? dto.userId ?? DEFAULT_USER;
    const isEnd = dto.action === 'END';

    return this.dataSource.manager.transaction(async (mgr) => {
      // 대상 설비 확정 — 설비 직접 지정이 우선, 없으면 라인 배정 설비(비가동 대상만)
      let targets: string[];
      if (dto.machineCodes?.length) {
        targets = [...new Set(dto.machineCodes)];
      } else if (dto.lineCode) {
        const rows = (await mgr.query(
          `SELECT m.MACHINE_CODE AS "machineCode" FROM IMCN_MACHINE m
            WHERE m.ORGANIZATION_ID=:1 AND m.LINE_CODE=:2 AND ${downtimeTargetMachineSql('m')} ORDER BY m.MACHINE_CODE`,
          [organization, dto.lineCode],
        )) as Array<{ machineCode: string }>;
        targets = rows.map((r) => r.machineCode);
      } else {
        throw new BadRequestException('대상 라인 또는 설비를 지정하세요');
      }
      if (!targets.length) return { affected: 0, skipped: 0, targets: 0, skippedMachines: [] as string[] };

      const master = await this.lockDowntimeMachines(mgr, organization, targets);

      // 진행중 비가동을 한 번에 조회해 대상/건너뛸 설비를 가른다
      const binds = targets.map((_, i) => `:${i + 2}`).join(',');
      const open = (await mgr.query(
        `SELECT MACHINE_CODE AS "machineCode", DT_SEQ AS "dtSeq", REASON_CODE AS "reasonCode" FROM IP_EQUIP_DOWNTIME_RESULT
          WHERE ORGANIZATION_ID=:1 AND END_TIME IS NULL AND MACHINE_CODE IN (${binds})`,
        [organization, ...targets],
      )) as Array<{ machineCode: string; dtSeq: number; reasonCode: string | null }>;
      const openMap = new Map(open.map((o) => [o.machineCode, o]));

      // 종료 사유: 새로 고르지 않았으면 시작 때 사유를 그대로 쓴다. 둘 다 없으면 막는다.
      if (isEnd && !dto.reasonCode && targets.some((code) => openMap.has(code) && !openMap.get(code)?.reasonCode)) {
        throw new BadRequestException('종료 시 비가동 사유를 선택하세요');
      }

      const acted: string[] = [];
      const skipped: string[] = [];
      for (const machineCode of targets) {
        const openRow = openMap.get(machineCode);
        if (isEnd) {
          if (!openRow) { skipped.push(machineCode); continue; }
          await this.closeOpenDowntime(mgr, organization, openRow.dtSeq, dto.reasonCode ?? null, user);
        } else {
          if (openRow) { skipped.push(machineCode); continue; }
          const nx = (await mgr.query(
            `SELECT SEQ_IP_EQUIP_DOWNTIME.NEXTVAL AS "seq" FROM DUAL`,
          )) as Array<{ seq: number }>;
          const m = master.get(machineCode);
          await mgr.query(
            `INSERT INTO IP_EQUIP_DOWNTIME_RESULT
               (RUN_NO, DT_SEQ, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, LINE_CODE, REASON_CODE, START_TIME, MEMO, WORKER, ENTER_BY, ENTER_DATE)
             VALUES (:1,:2,:3,:4,:5,:6,:7,SYSDATE,:8,:9,:10,SYSDATE)`,
            [dto.runNo ?? null, Number(nx[0]?.seq), organization, machineCode, m?.workstageCode ?? null, m?.lineCode ?? dto.lineCode ?? null, dto.reasonCode ?? null, dto.memo ?? null, dto.worker ?? null, user],
          );
        }
        acted.push(machineCode);
      }
      return { affected: acted.length, skipped: skipped.length, targets: targets.length, skippedMachines: skipped };
    });
  }

}
