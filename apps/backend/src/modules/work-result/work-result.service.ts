// 설비별 작업 실적관리 — IP_PRODUCT_RUN_CARD 기준 실적/불량/비가동 실 구현
import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductWorkResult } from '../../entities/product-work-result.entity';
import { DowntimeUpsertDto, WorkResultUpsertDto } from './work-result.dto';

const ORG = 1;
const DEFAULT_USER = 'ADMIN';

@Injectable()
export class WorkResultService {
  constructor(
    @InjectRepository(ProductWorkResult)
    private readonly repo: Repository<ProductWorkResult>,
  ) {}

  private q<T = Record<string, unknown>>(sql: string, params: unknown[] = []): Promise<T[]> {
    return this.repo.manager.query(sql, params);
  }

  /** 작업지시 목록 — 설비/공정/차종/CT/단위/품목분류 + 계획·실적·부적합 수량 + 설비상태 */
  async list(fromDate: string, toDate: string, lineCode?: string, keyword?: string) {
    const params: unknown[] = [fromDate, toDate];
    let where = `r.ORGANIZATION_ID = ${ORG}
      AND r.RUN_DATE >= TO_DATE(:1,'YYYY-MM-DD') AND r.RUN_DATE < TO_DATE(:2,'YYYY-MM-DD') + 1`;
    if (lineCode) { params.push(lineCode); where += ` AND r.LINE_CODE = :${params.length}`; }
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
  results(runNo: string) {
    return this.q(
      `SELECT wr.SEQ_NO AS "seqNo", wr.MACHINE_CODE AS "machineCode", wr.WORKSTAGE_CODE AS "workstageCode",
              wr.RESULT_QTY AS "resultQty", wr.WORK_TIME AS "workTime", wr.WORKER_COUNT AS "workerCount",
              wr.WORKER_NAME AS "workerName", wr.RESULT_STATUS AS "resultStatus",
              (SELECT r.ITEM_CODE FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=wr.RUN_NO AND r.ORGANIZATION_ID=wr.ORGANIZATION_ID AND ROWNUM=1) AS "itemCode",
              (SELECT r.MODEL_NAME FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=wr.RUN_NO AND r.ORGANIZATION_ID=wr.ORGANIZATION_ID AND ROWNUM=1) AS "modelName",
              TO_CHAR(NVL(wr.LAST_MODIFY_DATE, wr.ENTER_DATE),'YYYY-MM-DD HH24:MI') AS "updatedAt"
         FROM IP_PRODUCT_WORK_RESULT wr
        WHERE wr.RUN_NO = :1 AND wr.ORGANIZATION_ID = ${ORG}
        ORDER BY wr.SEQ_NO`,
      [runNo],
    );
  }

  /** 실적 상세 (헤더) */
  async resultDetail(runNo: string, seqNo: string) {
    const header = (await this.q(
      `SELECT RUN_NO AS "runNo", SEQ_NO AS "seqNo", MACHINE_CODE AS "machineCode", WORKSTAGE_CODE AS "workstageCode",
              RESULT_QTY AS "resultQty", WORK_TIME AS "workTime", WORKER_COUNT AS "workerCount",
              WORKER_NAME AS "workerName", RESULT_STATUS AS "resultStatus"
         FROM IP_PRODUCT_WORK_RESULT WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=${ORG}`,
      [runNo, seqNo],
    ))[0] ?? null;
    return { header };
  }

  /** 실적 신규/수정 — 완료(DONE) 실적은 수정 불가. 설비/공정을 run card에 write-back. 불량 detail 전체 교체 */
  async upsertResult(dto: WorkResultUpsertDto): Promise<{ seqNo: string }> {
    const user = dto.userId ?? DEFAULT_USER;
    return this.repo.manager.transaction(async (mgr) => {
      let seqNo = dto.seqNo;
      if (seqNo) {
        const cur = (await mgr.query(
          `SELECT RESULT_STATUS AS "st" FROM IP_PRODUCT_WORK_RESULT WHERE RUN_NO=:1 AND SEQ_NO=:2 AND ORGANIZATION_ID=:3`,
          [dto.runNo, seqNo, ORG],
        )) as Array<{ st: string }>;
        if (!cur.length) throw new BadRequestException('실적을 찾을 수 없습니다');
        if (cur[0].st === 'DONE') throw new BadRequestException('완료된 실적은 수정할 수 없습니다');
        await mgr.query(
          `UPDATE IP_PRODUCT_WORK_RESULT SET MACHINE_CODE=:1, WORKSTAGE_CODE=:2, RESULT_QTY=:3, WORK_TIME=:4,
             WORKER_COUNT=:5, WORKER_NAME=:6, RESULT_STATUS=:7, LAST_MODIFY_BY=:8, LAST_MODIFY_DATE=SYSDATE
           WHERE RUN_NO=:9 AND SEQ_NO=:10 AND ORGANIZATION_ID=:11`,
          [dto.machineCode, dto.workstageCode, dto.resultQty, dto.workTime ?? 0, dto.workerCount ?? 0,
            dto.workerName ?? null, dto.resultStatus, user, dto.runNo, seqNo, ORG],
        );
      } else {
        const mx = (await mgr.query(
          `SELECT NVL(MAX(TO_NUMBER(SEQ_NO)),0) AS "mx" FROM IP_PRODUCT_WORK_RESULT WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`,
          [dto.runNo, ORG],
        )) as Array<{ mx: number }>;
        seqNo = String(Number(mx[0]?.mx ?? 0) + 1).padStart(2, '0');
        await mgr.query(
          `INSERT INTO IP_PRODUCT_WORK_RESULT
             (RUN_NO, SEQ_NO, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, RESULT_QTY, WORK_TIME, WORKER_COUNT, WORKER_NAME, RESULT_STATUS, ENTER_BY, ENTER_DATE)
           VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,SYSDATE)`,
          [dto.runNo, seqNo, ORG, dto.machineCode, dto.workstageCode, dto.resultQty, dto.workTime ?? 0,
            dto.workerCount ?? 0, dto.workerName ?? null, dto.resultStatus, user],
        );
      }
      // run card write-back (설비/공정)
      await mgr.query(
        `UPDATE IP_PRODUCT_RUN_CARD SET MACHINE_CODE=:1, WORKSTAGE_CODE=:2 WHERE RUN_NO=:3 AND ORGANIZATION_ID=:4`,
        [dto.machineCode, dto.workstageCode, dto.runNo, ORG],
      );
      return { seqNo: seqNo! };
    });
  }

  /** 작업지시 대표불량 조회 (단일) */
  async getDefect(runNo: string) {
    return (await this.q(
      `SELECT BAD_CODE AS "badCode", BAD_QTY AS "badQty", REMARK AS "remark"
         FROM IP_PRODUCT_WORK_DEFECT WHERE RUN_NO=:1 AND ORGANIZATION_ID=${ORG}`,
      [runNo],
    ))[0] ?? null;
  }

  /** 작업지시 대표불량 단일 저장 — 계획수량 항상, 실적수량(합>0)일 때 상한 검증. 실적과 독립 */
  async saveDefect(runNo: string, badCode: string, badQty: number, remark: string | undefined, userId?: string): Promise<void> {
    const user = userId ?? DEFAULT_USER;
    const info = (await this.q(
      `SELECT NVL(r.LOT_SIZE,0) AS "planQty",
              NVL((SELECT SUM(wr.RESULT_QTY) FROM IP_PRODUCT_WORK_RESULT wr WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID),0) AS "resultQty"
         FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=:1 AND r.ORGANIZATION_ID=${ORG}`,
      [runNo],
    ))[0] as { planQty: number; resultQty: number } | undefined;
    if (!info) throw new BadRequestException('작업지시를 찾을 수 없습니다');
    const plan = Number(info.planQty ?? 0);
    const result = Number(info.resultQty ?? 0);
    const qty = Number(badQty ?? 0);
    if (!badCode) throw new BadRequestException('대표 불량유형을 선택하세요');
    if (qty > plan) throw new BadRequestException(`불량수량(${qty})이 계획수량(${plan})을 초과할 수 없습니다`);
    if (result > 0 && qty > result) throw new BadRequestException(`불량수량(${qty})이 실적수량(${result})을 초과할 수 없습니다`);
    await this.repo.manager.transaction(async (mgr) => {
      const ex = (await mgr.query(`SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_WORK_DEFECT WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2`, [runNo, ORG])) as Array<{ cnt: number }>;
      if (Number(ex[0]?.cnt ?? 0) > 0) {
        await mgr.query(
          `UPDATE IP_PRODUCT_WORK_DEFECT SET BAD_CODE=:1, BAD_QTY=:2, REMARK=:3, LAST_MODIFY_BY=:4, LAST_MODIFY_DATE=SYSDATE WHERE RUN_NO=:5 AND ORGANIZATION_ID=:6`,
          [badCode, qty, remark ?? null, user, runNo, ORG],
        );
      } else {
        await mgr.query(
          `INSERT INTO IP_PRODUCT_WORK_DEFECT (RUN_NO, ORGANIZATION_ID, BAD_CODE, BAD_QTY, REMARK, ENTER_BY, ENTER_DATE) VALUES (:1,:2,:3,:4,:5,:6,SYSDATE)`,
          [runNo, ORG, badCode, qty, remark ?? null, user],
        );
      }
    });
  }

  /** 부적합 유형 (ISYS_CODE_MASTER WQC BAD REASON CODE) */
  badReasons() {
    return this.q(
      `SELECT CODE_NAME AS "code", NVL(CODE_MEAN_KOR, CODE_MEAN_ENG) AS "name"
         FROM ISYS_CODE_MASTER WHERE CODE_TYPE='WQC BAD REASON CODE' AND ORGANIZATION_ID=${ORG}
        ORDER BY CODE_NAME`,
    );
  }

  /** 후공정(PBA) 설비 콤보 */
  machines() {
    return this.q(
      `SELECT m.MACHINE_CODE AS "machineCode", m.MACHINE_NAME AS "machineName",
              m.WORKSTAGE_CODE AS "workstageCode",
              (SELECT MAX(w2.WORKSTAGE_NAME) FROM IP_PRODUCT_WORKSTAGE w2 WHERE w2.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w2.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "workstageName",
              m.LINE_CODE AS "lineCode"
         FROM IMCN_MACHINE m
         JOIN IP_PRODUCT_WORKSTAGE w ON w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID
        WHERE m.ORGANIZATION_ID=${ORG} AND w.WORKSTAGE_CODE_GROUP='PBA'
        ORDER BY m.MACHINE_CODE`,
    );
  }

  /** 설비 연계 비가동 사유 (없으면 전체 사용중 사유) */
  async downtimeReasons(machineCode?: string) {
    if (machineCode) {
      const mapped = await this.q(
        `SELECT r.REASON_CODE AS "code", r.REASON_NAME AS "name"
           FROM IP_EQUIP_DOWNTIME_MAP_DTL d
           JOIN IP_EQUIP_DOWNTIME_REASON r ON r.REASON_CODE=d.REASON_CODE AND r.ORGANIZATION_ID=d.ORGANIZATION_ID
          WHERE d.MACHINE_CODE=:1 AND d.ORGANIZATION_ID=${ORG} AND r.USE_YN='Y'
          ORDER BY NVL(d.SORT_NO,0), r.DISPLAY_ORDER`,
        [machineCode],
      );
      if (mapped.length) return mapped;
    }
    return this.q(
      `SELECT REASON_CODE AS "code", REASON_NAME AS "name" FROM IP_EQUIP_DOWNTIME_REASON
        WHERE ORGANIZATION_ID=${ORG} AND USE_YN='Y' ORDER BY DISPLAY_ORDER, REASON_CODE`,
    );
  }

  /** 비가동 실적 목록 (설비별 — 작업지시 선택 여부와 무관, ADR 0002)
   *  serverNow(DB SYSDATE)를 함께 반환한다. 경과 타이머가 브라우저 시계로 계산하면
   *  DB 서버와의 시계 차이만큼 어긋나므로 클라이언트에서 이 값으로 보정한다. */
  async downtimes(machineCode: string) {
    const list = await this.q(
      `SELECT DT_SEQ AS "dtSeq", RUN_NO AS "runNo", MACHINE_CODE AS "machineCode", WORKSTAGE_CODE AS "workstageCode",
              REASON_CODE AS "reasonCode",
              (SELECT MAX(r.REASON_NAME) FROM IP_EQUIP_DOWNTIME_REASON r WHERE r.REASON_CODE=d.REASON_CODE AND r.ORGANIZATION_ID=d.ORGANIZATION_ID) AS "reasonName",
              TO_CHAR(START_TIME,'YYYY-MM-DD HH24:MI') AS "startTime",
              TO_CHAR(START_TIME,'YYYY-MM-DD HH24:MI:SS') AS "startAt",
              TO_CHAR(END_TIME,'YYYY-MM-DD HH24:MI') AS "endTime",
              MEMO AS "memo", WORKER AS "worker"
         FROM IP_EQUIP_DOWNTIME_RESULT d
        WHERE MACHINE_CODE=:1 AND ORGANIZATION_ID=${ORG} ORDER BY DT_SEQ`,
      [machineCode],
    );
    const now = await this.q<{ now: string }>(
      `SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS "now" FROM DUAL`,
    );
    return { list, serverNow: now[0]?.now ?? null };
  }

  /** 비가동 시작(신규)/종료·수정 — 식별은 DT_SEQ 단독, RUN_NO는 선택 맥락 (ADR 0002) */
  async upsertDowntime(dto: DowntimeUpsertDto): Promise<{ dtSeq: number }> {
    const user = dto.userId ?? DEFAULT_USER;
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
            [dto.reasonCode ?? null, dto.startTime ?? null, dto.memo ?? null, dto.worker ?? null, user, dtSeq, ORG],
          );
        } else {
          await mgr.query(
            `UPDATE IP_EQUIP_DOWNTIME_RESULT SET REASON_CODE=NVL(:1, REASON_CODE),
               START_TIME=NVL(TO_DATE(:2,'YYYY-MM-DD HH24:MI'), START_TIME),
               END_TIME=NVL(TO_DATE(:3,'YYYY-MM-DD HH24:MI'), END_TIME),
               MEMO=NVL(:4, MEMO), WORKER=NVL(:5, WORKER), LAST_MODIFY_BY=:6, LAST_MODIFY_DATE=SYSDATE
             WHERE DT_SEQ=:7 AND ORGANIZATION_ID=:8`,
            [dto.reasonCode ?? null, dto.startTime ?? null, dto.endTime ?? null, dto.memo ?? null, dto.worker ?? null, user, dtSeq, ORG],
          );
        }
      } else {
        // 같은 설비에 진행중 비가동이 이미 있으면 중복 시작을 막는다 (ADR 0002)
        const open = (await mgr.query(
          `SELECT DT_SEQ AS "dtSeq" FROM IP_EQUIP_DOWNTIME_RESULT
            WHERE MACHINE_CODE=:1 AND ORGANIZATION_ID=:2 AND END_TIME IS NULL`,
          [dto.machineCode, ORG],
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
          [dto.runNo ?? null, dtSeq, ORG, dto.machineCode, dto.workstageCode ?? null, dto.reasonCode ?? null, dto.startTime ?? null, dto.endTime ?? null, dto.memo ?? null, dto.worker ?? null, user],
        );
      }
      return { dtSeq: dtSeq! };
    });
  }
}
