// 계획 없는 실적 입력 — 모델을 고르고 실적을 넣으면 그 실적이 계획(런카드 LOT_SIZE)이 된다.
//
//   작업지시(IP_PRODUCT_RUN_CARD)는 업무일 · 라인 · 공정 · 모델당 하나를 서버가 만든다 (COMMENTS = FREE_RUN_MARK 로 표시).
//   계획수량(LOT_SIZE)은 취소 제외 실적 합계다. 실적을 넣거나 취소할 때마다 다시 맞춘다 (최소 1, 컬럼 제약 때문).
//   실적 저장 자체는 WorkResultService.upsertResult 를 그대로 쓴다 — 공정재고 반영·취소 규칙이 한 곳에 있다.
//   타임구간(A~J)은 작업시간 관리(ICOM_WORKTIME_RANGES, RANGE_TYPE=WORKTIME)의 구간이다. 실적 저장 때
//   IP_PRODUCT_RESULT.TIME_ZONE 에 함께 저장된다 (WorkResultService.upsertResult).
//   계획(제품생산계획)에서 내려온 지시는 COMMENTS 표시가 없어 이 화면이 건드리지 않는다.
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { FreeResultCancelDto, FreeResultCreateDto } from './work-result-free.dto';
import { WorkResultService } from './work-result.service';

export const FREE_RUN_MARK = '[실적계획]';
const DEFAULT_SHIFT = 'A';
const DEFAULT_USER = 'ADMIN';
/** 2층 조립 후공정이 쓰는 작업시간 구간 종류 (SMT 는 SMTWORKTIME) */
const WORKTIME_RANGE_TYPE = 'WORKTIME';

export interface TimeZoneRow {
  /** A~J */
  code: string;
  /** 'HHMM' */
  startTime: string;
  endTime: string;
}

@Injectable()
export class WorkResultFreeService {
  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly workResult: WorkResultService,
  ) {}

  private requireOrganization(organizationId?: number): number {
    if (organizationId == null || !Number.isInteger(organizationId) || organizationId <= 0) {
      throw new BadRequestException('Authenticated organization is required');
    }
    return organizationId;
  }

  /**
   * 모델 선택 목록 (IP_PRODUCT_MODEL_MASTER).
   *  - 검색어가 없으면 최근 계획에 있는 모델만 준다 — 계획일(IP_PRODUCT_MI_PLAN.PLAN_DATE)이 업무일 기준 3일 전보다 큰 것.
   *  - 검색어가 있으면 모델명·품번 부분 검색(최대 30건)이고, 최근 계획 모델이 먼저 나온다.
   *  모델이 수백 개라 검색어 없이 전체 목록은 주지 않는다.
   */
  async models(keyword: string | undefined, organizationId?: number) {
    const org = this.requireOrganization(organizationId);
    const word = (keyword ?? '').trim().toUpperCase();
    const planned = `EXISTS (SELECT 1 FROM IP_PRODUCT_MI_PLAN p
                              WHERE p.ORGANIZATION_ID = m.ORGANIZATION_ID AND p.MODEL_NAME = m.MODEL_NAME
                                AND p.ITEM_CODE = m.ITEM_CODE
                                AND p.PLAN_DATE > TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')) - 3)`;
    const base = `SELECT m.MODEL_NAME AS "modelName", m.ITEM_CODE AS "itemCode", m.REVISION AS "revision",
                m.CUSTOMER_NAME AS "customerName", m.MODEL_SPEC AS "modelSpec",
                CASE WHEN ${planned} THEN 'Y' ELSE 'N' END AS "planned"
           FROM IP_PRODUCT_MODEL_MASTER m
          WHERE m.ORGANIZATION_ID = :1 AND m.ITEM_CODE IS NOT NULL`;
    if (!word) {
      return this.dataSource.manager.query(
        `SELECT * FROM (${base} AND ${planned} ORDER BY m.MODEL_NAME) WHERE ROWNUM <= 100`,
        [org],
      );
    }
    const kw = `%${word}%`;
    return this.dataSource.manager.query(
      `SELECT * FROM (${base}
            AND (UPPER(m.MODEL_NAME) LIKE :2 OR UPPER(m.ITEM_CODE) LIKE :3)
          ORDER BY CASE WHEN ${planned} THEN 0 ELSE 1 END, m.MODEL_NAME
       ) WHERE ROWNUM <= 30`,
      [org, kw, kw],
    );
  }

  /** 작업시간 관리에 등록된 타임구간 목록 (A~J) */
  private async timeZoneRows(org: number): Promise<TimeZoneRow[]> {
    return this.dataSource.manager.query(
      `SELECT WORK_TYPE AS "code", START_TIME AS "startTime", END_TIME AS "endTime"
         FROM ICOM_WORKTIME_RANGES
        WHERE RANGE_TYPE = :1 AND ORGANIZATION_ID = :2
        ORDER BY WORK_TYPE`,
      [WORKTIME_RANGE_TYPE, org],
    );
  }

  /** 타임구간 목록과 지금(DB 시각)이 속한 구간 — 구간은 업무일 기준이라 자정을 넘는 구간(G~J)도 맞춘다 */
  async timeZones(organizationId?: number) {
    const org = this.requireOrganization(organizationId);
    const list = await this.timeZoneRows(org);
    const cur = (await this.dataSource.manager.query(
      `WITH w AS (SELECT SYSDATE AS NOW, F_GET_WORK_ACTUAL_DATE(SYSDATE,'A') AS WD FROM DUAL),
            r AS (SELECT WORK_TYPE,
                         NVL(TO_NUMBER(ATTRIBUTE01),0) + TO_NUMBER(SUBSTR(START_TIME,1,2))/24 + TO_NUMBER(SUBSTR(START_TIME,3,2))/1440 AS S,
                         NVL(TO_NUMBER(ATTRIBUTE02),0) + TO_NUMBER(SUBSTR(END_TIME,1,2))/24 + TO_NUMBER(SUBSTR(END_TIME,3,2))/1440 AS E
                    FROM ICOM_WORKTIME_RANGES WHERE RANGE_TYPE = :1 AND ORGANIZATION_ID = :2)
       SELECT r.WORK_TYPE AS "code" FROM w JOIN r ON w.NOW >= w.WD + r.S AND w.NOW < w.WD + r.E`,
      [WORKTIME_RANGE_TYPE, org],
    )) as Array<{ code: string }>;
    return { list, current: cur.length === 1 ? cur[0].code : null };
  }

  /** 오늘 업무일에 이 화면이 만든 지시 목록 (라인·공정 기준) — 모델별 실적 합계 */
  async todayRuns(lineCode: string, workstageCode: string, organizationId?: number) {
    const org = this.requireOrganization(organizationId);
    return this.dataSource.manager.query(
      `SELECT r.RUN_NO AS "runNo", r.MODEL_NAME AS "modelName", r.ITEM_CODE AS "itemCode",
              r.LOT_SIZE AS "planQty",
              NVL((SELECT SUM(wr.PRODUCT_ACTUAL_QTY) FROM IP_PRODUCT_RESULT wr
                    WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID
                      AND NVL(wr.RESULT_STATUS,'WIP')<>'CANCEL'),0) AS "resultQty"
         FROM IP_PRODUCT_RUN_CARD r
        WHERE r.ORGANIZATION_ID = :1 AND r.LINE_CODE = :2 AND r.WORKSTAGE_CODE = :3
          AND r.COMMENTS = :4 AND r.RUN_DATE = TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A'))
        ORDER BY r.RUN_NO`,
      [org, lineCode, workstageCode, FREE_RUN_MARK],
    );
  }

  /** 계획수량을 취소 제외 실적 합계로 맞춘다 */
  private async syncPlan(runNo: string, org: number) {
    await this.dataSource.manager.query(
      `UPDATE IP_PRODUCT_RUN_CARD r
          SET LOT_SIZE = GREATEST(1, NVL((SELECT SUM(wr.PRODUCT_ACTUAL_QTY) FROM IP_PRODUCT_RESULT wr
                                           WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID
                                             AND NVL(wr.RESULT_STATUS,'WIP')<>'CANCEL'),0)),
              LAST_MODIFY_DATE = SYSDATE
        WHERE r.RUN_NO = :1 AND r.ORGANIZATION_ID = :2 AND r.COMMENTS = :3`,
      [runNo, org, FREE_RUN_MARK],
    );
  }

  /** 실적 저장 — 오늘 업무일의 같은 라인·공정·모델 지시를 쓰고, 없으면 만든다 */
  async createResult(dto: FreeResultCreateDto, organizationId?: number, userId?: string) {
    const org = this.requireOrganization(organizationId);
    const user = userId ?? DEFAULT_USER;

    const zone = (await this.timeZoneRows(org)).find((z) => z.code === dto.timeZone);
    if (!zone) throw new BadRequestException('작업시간 관리에 등록되지 않은 타임구간입니다');

    const model = (await this.dataSource.manager.query(
      `SELECT MAX(REVISION) AS "revision" FROM IP_PRODUCT_MODEL_MASTER
        WHERE MODEL_NAME = :1 AND ITEM_CODE = :2 AND ORGANIZATION_ID = :3 HAVING COUNT(*) > 0`,
      [dto.modelName, dto.itemCode, org],
    )) as Array<{ revision: string | null }>;
    if (!model.length) throw new BadRequestException('모델 마스터에 없는 모델·품번입니다');

    const found = (await this.dataSource.manager.query(
      `SELECT MIN(RUN_NO) AS "runNo" FROM IP_PRODUCT_RUN_CARD
        WHERE ORGANIZATION_ID = :1 AND LINE_CODE = :2 AND WORKSTAGE_CODE = :3 AND MODEL_NAME = :4
          AND ITEM_CODE = :5 AND COMMENTS = :6 AND RUN_DATE = TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A'))`,
      [org, dto.lineCode, dto.workstageCode, dto.modelName, dto.itemCode, FREE_RUN_MARK],
    )) as Array<{ runNo: string | null }>;

    let runNo = found[0]?.runNo ?? null;
    let created = false;
    if (!runNo) {
      runNo = await this.dataSource.manager.transaction(async (mgr) => {
        const no = (await mgr.query(
          `SELECT F_GET_NEW_RUN_NO(TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')), :1, :2, :3, :4) AS "runNo" FROM DUAL`,
          [dto.modelName, dto.lineCode, DEFAULT_SHIFT, org],
        )) as Array<{ runNo: string }>;
        const newNo = no[0]?.runNo;
        if (!newNo) throw new BadRequestException('작업지시번호 채번에 실패했습니다');
        await mgr.query(
          `INSERT INTO IP_PRODUCT_RUN_CARD
             (ORGANIZATION_ID, RUN_NO, RUN_DATE, LOT_NO, ITEM_CODE, MODEL_NAME, LINE_CODE, WORKSTAGE_CODE,
              LOT_SIZE, CHARGER, SHIFT_CODE, REVISION, ACTIVE_YN, COMMENTS,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           VALUES (:1, :2, TRUNC(F_GET_WORK_ACTUAL_DATE(SYSDATE,'A')), :3, :4, :5, :6, :7,
              1, :8, :9, :10, 'N', :11, :12, SYSDATE, :13, SYSDATE)`,
          [org, newNo, newNo, dto.itemCode, dto.modelName, dto.lineCode, dto.workstageCode,
           dto.workerName, DEFAULT_SHIFT, model[0].revision, FREE_RUN_MARK, user, user],
        );
        return newNo;
      });
      created = true;
    }

    try {
      const saved = await this.workResult.upsertResult(
        {
          runNo, machineCode: dto.machineCode, workstageCode: dto.workstageCode,
          resultQty: dto.resultQty, workTime: dto.workTime, workerCount: dto.workerCount,
          workerName: dto.workerName, resultStatus: 'DONE', timeZone: zone.code,
        },
        org, userId,
      );
      await this.syncPlan(runNo, org);
      return { runNo, ...saved };
    } catch (e: unknown) {
      // 방금 만든 지시에 실적이 하나도 없으면 빈 지시를 남기지 않는다
      if (created) {
        await this.dataSource.manager.query(
          `DELETE FROM IP_PRODUCT_RUN_CARD r WHERE r.RUN_NO=:1 AND r.ORGANIZATION_ID=:2 AND r.COMMENTS=:3
             AND NOT EXISTS (SELECT 1 FROM IP_PRODUCT_RESULT wr WHERE wr.RUN_NO=r.RUN_NO AND wr.ORGANIZATION_ID=r.ORGANIZATION_ID)`,
          [runNo, org, FREE_RUN_MARK],
        );
      }
      throw e;
    }
  }

  /** 실적 취소 — 기존 취소 규칙을 쓰고 계획수량을 다시 맞춘다 */
  async cancelResult(dto: FreeResultCancelDto, organizationId?: number, userId?: string) {
    const org = this.requireOrganization(organizationId);
    const own = (await this.dataSource.manager.query(
      `SELECT 1 AS "x" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO=:1 AND ORGANIZATION_ID=:2 AND COMMENTS=:3`,
      [dto.runNo, org, FREE_RUN_MARK],
    )) as unknown[];
    if (!own.length) throw new NotFoundException('이 화면에서 만든 작업지시가 아닙니다');
    const res = await this.workResult.cancelResult(dto, org, userId);
    await this.syncPlan(dto.runNo, org);
    return res;
  }
}
