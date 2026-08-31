// 설비별 작업 실적관리 — IP_PRODUCT_RUN_CARD 기준 실적/불량/비가동 실 구현
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductWorkResult } from '../../entities/product-work-result.entity';
import {
  DowntimeBulkDto,
  DowntimeUpsertDto,
  PlanDowntimeCreateDto,
  WorkResultUpsertDto,
} from './work-result.dto';

const DEFAULT_USER = 'ADMIN';

@Injectable()
export class WorkResultService {
  constructor(
    @InjectRepository(ProductWorkResult)
    private readonly repo: Repository<ProductWorkResult>,
  ) {}

  private q<T = Record<string, unknown>>(
    sql: string,
    params: unknown[] = [],
  ): Promise<T[]> {
    return this.repo.manager.query(sql, params);
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
  ) {
    const organization = this.requireOrganization(organizationId);
    const params: unknown[] = [organization, fromDate, toDate];
    let where = `r.ORGANIZATION_ID = :1
      AND r.RUN_DATE >= TO_DATE(:2,'YYYY-MM-DD') AND r.RUN_DATE < TO_DATE(:3,'YYYY-MM-DD') + 1`;
    if (lineCode) {
      params.push(lineCode);
      where += ` AND r.LINE_CODE = :${params.length}`;
    }
    if (keyword) {
      const kw = `%${keyword.toUpperCase()}%`;
      params.push(kw);
      const i = params.length;
      where += ` AND (UPPER(r.ITEM_CODE) LIKE :${i} OR UPPER(r.MODEL_NAME) LIKE :${i} OR UPPER(r.MACHINE_CODE) LIKE :${i}
        OR EXISTS (SELECT 1 FROM IMCN_MACHINE mk WHERE mk.MACHINE_CODE = r.MACHINE_CODE AND mk.ORGANIZATION_ID = r.ORGANIZATION_ID AND UPPER(mk.MACHINE_NAME) LIKE :${i}))`;
    }
    return this.q(
      `SELECT * FROM (
        SELECT r.RUN_NO AS "runNo",
          r.MACHINE_CODE AS "machineCode",
          (SELECT MAX(m.MACHINE_NAME) FROM IMCN_MACHINE m WHERE m.MACHINE_CODE=r.MACHINE_CODE AND m.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "machineName",
          r.WORKSTAGE_CODE AS "workstageCode",
          (SELECT MAX(w.WORKSTAGE_NAME) FROM IP_PRODUCT_WORKSTAGE w WHERE w.WORKSTAGE_CODE=r.WORKSTAGE_CODE AND w.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "workstageName",
          (SELECT MAX(w.WORKSTAGE_CODE_GROUP) FROM IP_PRODUCT_WORKSTAGE w WHERE w.WORKSTAGE_CODE=r.WORKSTAGE_CODE AND w.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "workstageGroup",
          TO_CHAR(r.RUN_DATE,'YYYY-MM-DD') AS "runDate",
          r.LINE_CODE AS "lineCode", r.SHIFT_CODE AS "shiftCode",
          r.ITEM_CODE AS "itemCode", r.REVISION AS "revision", r.MODEL_NAME AS "modelName",
          (SELECT MAX(i.ITEM_UOM) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "unit",
          (SELECT MAX(i.ITEM_CLASS) FROM ID_ITEM i WHERE i.ITEM_CODE=r.ITEM_CODE AND i.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "itemClass",
          (SELECT MAX(bc.CODE_MEAN_KOR) FROM ISYS_BASECODE bc WHERE bc.CODE_TYPE='PRODUCT CLASS'
             AND bc.CODE_NAME = (SELECT MAX(mm.PRODUCT_CLASS) FROM IP_PRODUCT_MODEL_MASTER mm WHERE mm.ITEM_CODE=r.ITEM_CODE AND mm.ORGANIZATION_ID=r.ORGANIZATION_ID)) AS "carModel",
          (SELECT MAX(st.CT_VALUE) FROM IP_PRODUCT_ST_MASTER st WHERE st.ITEM_CODE=r.ITEM_CODE AND st.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "ct",
          r.LOT_SIZE AS "planQty",
          NVL((SELECT SUM(wr.RESULT_QTY) FROM IP_PRODUCT_WORK_RESULT wr WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID),0) AS "resultQty",
          (SELECT COUNT(*) FROM IP_PRODUCT_WORK_RESULT wc WHERE wc.RUN_NO=r.RUN_NO AND wc.ORGANIZATION_ID=r.ORGANIZATION_ID) AS "resultCount",
          (SELECT COUNT(*) FROM IP_PRODUCT_WORK_RESULT ww WHERE ww.RUN_NO=r.RUN_NO AND ww.ORGANIZATION_ID=r.ORGANIZATION_ID AND NVL(ww.RESULT_STATUS,'WIP')='WIP') AS "wipCount",
          NVL((SELECT df.BAD_QTY FROM IP_PRODUCT_WORK_DEFECT df WHERE df.RUN_NO=r.RUN_NO AND df.ORGANIZATION_ID=r.ORGANIZATION_ID),0) AS "defectQty",
          (SELECT COUNT(*) FROM IP_EQUIP_DOWNTIME_RESULT dr WHERE dr.MACHINE_CODE=r.MACHINE_CODE AND dr.ORGANIZATION_ID=r.ORGANIZATION_ID AND dr.END_TIME IS NULL) AS "openDowntime"
        FROM IP_PRODUCT_RUN_CARD r
        WHERE ${where}
        ORDER BY r.RUN_DATE DESC, r.RUN_NO
      ) WHERE ROWNUM <= 500`,
      params,
    );
  }

  /** 실적 이력 목록 (작업지시별) */
  results(runNo: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    return this.q(
      `SELECT wr.SEQ_NO AS "seqNo", wr.MACHINE_CODE AS "machineCode", wr.WORKSTAGE_CODE AS "workstageCode",
              wr.RESULT_QTY AS "resultQty", wr.WORK_TIME AS "workTime", wr.WORKER_COUNT AS "workerCount",
              wr.WORKER_NAME AS "workerName", wr.RESULT_STATUS AS "resultStatus",
              (SELECT r.ITEM_CODE FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=wr.RUN_NO AND r.ORGANIZATION_ID=wr.ORGANIZATION_ID AND ROWNUM=1) AS "itemCode",
              (SELECT r.MODEL_NAME FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=wr.RUN_NO AND r.ORGANIZATION_ID=wr.ORGANIZATION_ID AND ROWNUM=1) AS "modelName",
              TO_CHAR(NVL(wr.LAST_MODIFY_DATE, wr.ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt"
         FROM IP_PRODUCT_WORK_RESULT wr
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
          `SELECT RUN_NO AS "runNo", SEQ_NO AS "seqNo", MACHINE_CODE AS "machineCode", WORKSTAGE_CODE AS "workstageCode",
              RESULT_QTY AS "resultQty", WORK_TIME AS "workTime", WORKER_COUNT AS "workerCount",
              WORKER_NAME AS "workerName", RESULT_STATUS AS "resultStatus"
         FROM IP_PRODUCT_WORK_RESULT WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=:3`,
          [runNo, seqNo, organization],
        )
      )[0] ?? null;
    return { header };
  }

  /** 실적 신규/수정 — 완료(DONE) 실적은 수정 불가. 설비/공정을 run card에 write-back. 불량 detail 전체 교체 */
  async upsertResult(
    dto: WorkResultUpsertDto,
    organizationId?: number,
    userId?: string,
  ): Promise<{ seqNo: string }> {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;
    return this.repo.manager.transaction(async (mgr) => {
      let seqNo = dto.seqNo;
      if (seqNo) {
        const cur = (await mgr.query(
          `SELECT RESULT_STATUS AS "st" FROM IP_PRODUCT_WORK_RESULT WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=:3`,
          [dto.runNo, seqNo, organization],
        )) as Array<{ st: string }>;
        if (!cur.length)
          throw new BadRequestException('실적을 찾을 수 없습니다');
        if (cur[0].st === 'DONE')
          throw new BadRequestException('완료된 실적은 수정할 수 없습니다');
        await mgr.query(
          `UPDATE IP_PRODUCT_WORK_RESULT SET MACHINE_CODE=:1, WORKSTAGE_CODE=:2, RESULT_QTY=:3, WORK_TIME=:4,
             WORKER_COUNT=:5, WORKER_NAME=:6, RESULT_STATUS=:7, LAST_MODIFY_BY=:8, LAST_MODIFY_DATE=SYSDATE
           WHERE RUN_NO=:9 AND SEQ_NO=:10 AND ORGANIZATION_ID=:11`,
          [
            dto.machineCode,
            dto.workstageCode,
            dto.resultQty,
            dto.workTime ?? 0,
            dto.workerCount ?? 0,
            dto.workerName ?? null,
            dto.resultStatus,
            user,
            dto.runNo,
            seqNo,
            organization,
          ],
        );
      } else {
        const mx = (await mgr.query(
          `SELECT NVL(MAX(TO_NUMBER(SEQ_NO)),0) AS "mx" FROM IP_PRODUCT_WORK_RESULT WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`,
          [dto.runNo, organization],
        )) as Array<{ mx: number }>;
        seqNo = String(Number(mx[0]?.mx ?? 0) + 1).padStart(2, '0');
        await mgr.query(
          `INSERT INTO IP_PRODUCT_WORK_RESULT
             (RUN_NO, SEQ_NO, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, RESULT_QTY, WORK_TIME, WORKER_COUNT, WORKER_NAME, RESULT_STATUS, ENTER_BY, ENTER_DATE)
           VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,SYSDATE)`,
          [
            dto.runNo,
            seqNo,
            organization,
            dto.machineCode,
            dto.workstageCode,
            dto.resultQty,
            dto.workTime ?? 0,
            dto.workerCount ?? 0,
            dto.workerName ?? null,
            dto.resultStatus,
            user,
          ],
        );
      }
      // run card write-back (설비/공정)
      await mgr.query(
        `UPDATE IP_PRODUCT_RUN_CARD SET MACHINE_CODE=:1, WORKSTAGE_CODE=:2 WHERE RUN_NO=:3 AND ORGANIZATION_ID=:4`,
        [dto.machineCode, dto.workstageCode, dto.runNo, organization],
      );
      return { seqNo: seqNo! };
    });
  }

  /** 작업지시 대표불량 조회 (단일) */
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
              NVL((SELECT SUM(wr.RESULT_QTY) FROM IP_PRODUCT_WORK_RESULT wr WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID),0) AS "resultQty"
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
    await this.repo.manager.transaction(async (mgr) => {
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

  /** 후공정(PBA) 설비 콤보 */
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
        ORDER BY m.MACHINE_CODE`,
      [organization],
    );
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

    return this.repo.manager.transaction(async (mgr) => {
      // 설비의 공정코드를 한 번에 확보한다(일자 수만큼 재조회하지 않기 위함).
      const binds = dto.machineCodes.map((_, i) => `:${i + 2}`).join(',');
      const wsRows = (await mgr.query(
        `SELECT MACHINE_CODE AS "machineCode", WORKSTAGE_CODE AS "workstageCode"
           FROM IMCN_MACHINE WHERE ORGANIZATION_ID=:1 AND MACHINE_CODE IN (${binds})`,
        [organization, ...dto.machineCodes],
      )) as Array<{ machineCode: string; workstageCode: string | null }>;
      const wsMap = new Map(wsRows.map((r) => [r.machineCode, r.workstageCode]));

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
               (RUN_NO, DT_SEQ, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, REASON_CODE,
                START_TIME, END_TIME, ENTER_BY, ENTER_DATE)
             VALUES (NULL, :1, :2, :3, :4, :5,
                     TO_DATE(:6,'YYYY-MM-DD HH24:MI'), TO_DATE(:7,'YYYY-MM-DD HH24:MI'), :8, SYSDATE)`,
            [
              Number(nx[0]?.seq),
              organization,
              machineCode,
              wsMap.get(machineCode) ?? null,
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
    await this.repo.manager.query(
      `DELETE FROM IP_EQUIP_DOWNTIME_RESULT WHERE ORGANIZATION_ID=${organization} AND DT_SEQ=:1`,
      [dtSeq],
    );
    return { deleted: 1 };
  }

  /** 라인/설비 일괄 비가동 시작·종료.
   *  이미 요청한 상태인 설비는 건너뛰고 결과를 요약해 돌려준다 — 한 대 때문에 전체가 막히지 않게. */
  async bulkDowntime(dto: DowntimeBulkDto, organizationId?: number, userId?: string) {
    const organization = this.requireOrganization(organizationId);
    const user = userId ?? dto.userId ?? DEFAULT_USER;
    const isEnd = dto.action === 'END';
    if (isEnd && !dto.reasonCode) throw new BadRequestException('종료 시 비가동 사유를 선택하세요');

    return this.repo.manager.transaction(async (mgr) => {
      // 대상 설비 확정 — 설비 직접 지정이 우선, 없으면 라인 배정 설비
      let targets: string[];
      if (dto.machineCodes?.length) {
        targets = dto.machineCodes;
      } else if (dto.lineCode) {
        const rows = (await mgr.query(
          `SELECT MACHINE_CODE AS "machineCode" FROM IMCN_MACHINE
            WHERE ORGANIZATION_ID=:1 AND LINE_CODE=:2 ORDER BY MACHINE_CODE`,
          [organization, dto.lineCode],
        )) as Array<{ machineCode: string }>;
        targets = rows.map((r) => r.machineCode);
      } else {
        throw new BadRequestException('대상 라인 또는 설비를 지정하세요');
      }
      if (!targets.length) return { affected: 0, skipped: 0, targets: 0, skippedMachines: [] as string[] };

      // 진행중 비가동을 한 번에 조회해 대상/건너뛸 설비를 가른다
      const binds = targets.map((_, i) => `:${i + 2}`).join(',');
      const open = (await mgr.query(
        `SELECT MACHINE_CODE AS "machineCode", DT_SEQ AS "dtSeq" FROM IP_EQUIP_DOWNTIME_RESULT
          WHERE ORGANIZATION_ID=:1 AND END_TIME IS NULL AND MACHINE_CODE IN (${binds})`,
        [organization, ...targets],
      )) as Array<{ machineCode: string; dtSeq: number }>;
      const openMap = new Map(open.map((o) => [o.machineCode, o.dtSeq]));

      const acted: string[] = [];
      const skipped: string[] = [];
      for (const machineCode of targets) {
        const openSeq = openMap.get(machineCode);
        if (isEnd) {
          if (openSeq == null) { skipped.push(machineCode); continue; }
          await mgr.query(
            `UPDATE IP_EQUIP_DOWNTIME_RESULT
                SET REASON_CODE=:1, END_TIME=SYSDATE, LAST_MODIFY_BY=:2, LAST_MODIFY_DATE=SYSDATE
              WHERE DT_SEQ=:3 AND ORGANIZATION_ID=:4`,
            [dto.reasonCode, user, openSeq, organization],
          );
        } else {
          if (openSeq != null) { skipped.push(machineCode); continue; }
          const nx = (await mgr.query(
            `SELECT SEQ_IP_EQUIP_DOWNTIME.NEXTVAL AS "seq" FROM DUAL`,
          )) as Array<{ seq: number }>;
          const ws = (await mgr.query(
            `SELECT WORKSTAGE_CODE AS "ws" FROM IMCN_MACHINE WHERE MACHINE_CODE=:1 AND ORGANIZATION_ID=:2`,
            [machineCode, organization],
          )) as Array<{ ws: string | null }>;
          await mgr.query(
            `INSERT INTO IP_EQUIP_DOWNTIME_RESULT
               (RUN_NO, DT_SEQ, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, REASON_CODE, START_TIME, MEMO, WORKER, ENTER_BY, ENTER_DATE)
             VALUES (NULL,:1,:2,:3,:4,:5,SYSDATE,:6,:7,:8,SYSDATE)`,
            [Number(nx[0]?.seq), organization, machineCode, ws[0]?.ws ?? null, dto.reasonCode ?? null, dto.memo ?? null, dto.worker ?? null, user],
          );
        }
        acted.push(machineCode);
      }
      return { affected: acted.length, skipped: skipped.length, targets: targets.length, skippedMachines: skipped };
    });
  }

  /** 비가동 시작(신규)/종료·수정 — 식별은 DT_SEQ 단독, RUN_NO는 선택 맥락 (ADR 0002) */
  async upsertDowntime(
    dto: DowntimeUpsertDto,
    organizationId?: number,
    userId?: string,
  ): Promise<{ dtSeq: number }> {
    const organization = this.requireOrganization(organizationId);
    // userId는 JWT에서 온다 — DowntimeUpsertDto에는 더 이상 본문 필드가 없다.
    const user = userId ?? DEFAULT_USER;
    return this.repo.manager.transaction(async (mgr) => {
      let dtSeq = dto.dtSeq;
      if (dtSeq != null) {
        if (dto.endNow) {
          // 종료시각을 DB 현재시각(SYSDATE)으로 — 시작(SYSDATE)과 동일 시계 사용
          await mgr.query(
            `UPDATE IP_EQUIP_DOWNTIME_RESULT SET REASON_CODE=NVL(:1, REASON_CODE),
               START_TIME=NVL(TO_DATE(:2,'YYYY-MM-DD HH24:MI'), START_TIME),
               END_TIME=SYSDATE,
               MEMO=NVL(:3, MEMO), WORKER=NVL(:4, WORKER), LAST_MODIFY_BY=:5, LAST_MODIFY_DATE=SYSDATE
             WHERE DT_SEQ=:6 AND ORGANIZATION_ID=:7`,
            [dto.reasonCode ?? null, dto.startTime ?? null, dto.memo ?? null, dto.worker ?? null, user, dtSeq, organization],
          );
        } else {
          await mgr.query(
            `UPDATE IP_EQUIP_DOWNTIME_RESULT SET REASON_CODE=NVL(:1, REASON_CODE),
               START_TIME=NVL(TO_DATE(:2,'YYYY-MM-DD HH24:MI'), START_TIME),
               END_TIME=NVL(TO_DATE(:3,'YYYY-MM-DD HH24:MI'), END_TIME),
               MEMO=NVL(:4, MEMO), WORKER=NVL(:5, WORKER), LAST_MODIFY_BY=:6, LAST_MODIFY_DATE=SYSDATE
             WHERE DT_SEQ=:7 AND ORGANIZATION_ID=:8`,
            [dto.reasonCode ?? null, dto.startTime ?? null, dto.endTime ?? null, dto.memo ?? null, dto.worker ?? null, user, dtSeq, organization],
          );
        }
      } else {
        // 같은 설비에 진행중 비가동이 이미 있으면 중복 시작을 막는다 (ADR 0002)
        const open = (await mgr.query(
          `SELECT DT_SEQ AS "dtSeq" FROM IP_EQUIP_DOWNTIME_RESULT
            WHERE MACHINE_CODE=:1 AND ORGANIZATION_ID=:2 AND END_TIME IS NULL`,
          [dto.machineCode, organization],
        )) as Array<{ dtSeq: number }>;
        if (open.length) throw new BadRequestException('이미 진행중인 비가동이 있습니다. 먼저 종료하세요.');

        const nx = (await mgr.query(
          `SELECT SEQ_IP_EQUIP_DOWNTIME.NEXTVAL AS "seq" FROM DUAL`,
        )) as Array<{ seq: number }>;
        dtSeq = Number(nx[0]?.seq);
        await mgr.query(
          `INSERT INTO IP_EQUIP_DOWNTIME_RESULT
             (RUN_NO, DT_SEQ, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, REASON_CODE, START_TIME, END_TIME, MEMO, WORKER, ENTER_BY, ENTER_DATE)
           VALUES (:1,:2,:3,:4,:5,:6,
             NVL(TO_DATE(:7,'YYYY-MM-DD HH24:MI'), SYSDATE),
             TO_DATE(:8,'YYYY-MM-DD HH24:MI'),
             :9,:10,:11,SYSDATE)`,
          [dto.runNo ?? null, dtSeq, organization, dto.machineCode, dto.workstageCode ?? null, dto.reasonCode ?? null, dto.startTime ?? null, dto.endTime ?? null, dto.memo ?? null, dto.worker ?? null, user],
        );
      }
      return { dtSeq: dtSeq! };
    });
  }
}
