// 설비 운영 현황 — 설비마스터 전체 상태 + 라인/설비 기준 당일지표·당월이력 조회
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EquipDowntimeResult } from '../../entities/equip-downtime-result.entity';
import { availability, oee, quality } from '@smt/shared';
import { downtimeTargetMachineSql } from '../../common/utils/downtime-target';
import { DASHBOARD_ACTUAL_SUM } from '../dashboard/dashboard-insights.sql';
import { WORK_DAY_SQL } from '../monitoring/services/production-board.service';

const ORG = 1;

/** 라인/설비 중 무엇을 기준으로 볼지 — 설비↔라인 매핑이 비어 있어도 SQL 형태는 동일하게 유지한다 */
interface ScopeParams {
  machineCode?: string;
  lineCode?: string;
  /** 후공정(ASSY) 설비는 라인이 없어 공정으로 묶는다 */
  workstageCode?: string;
}

@Injectable()
export class EquipOpsService {
  constructor(
    @InjectRepository(EquipDowntimeResult)
    private readonly repo: Repository<EquipDowntimeResult>,
  ) {}

  private q<T = Record<string, unknown>>(sql: string, params: unknown[] = []): Promise<T[]> {
    return this.repo.manager.query(sql, params);
  }

  /** 조회 대상 설비를 좁히는 조건. 설비코드 → 라인코드 → 공정코드 순, 모두 없으면 전체 */
  private scopeClause(scope: ScopeParams, alias: string, params: unknown[]) {
    if (scope.machineCode) {
      params.push(scope.machineCode);
      return ` AND ${alias}.MACHINE_CODE = :${params.length}`;
    }
    if (scope.lineCode) {
      params.push(scope.lineCode);
      return ` AND ${alias}.MACHINE_CODE IN (SELECT MACHINE_CODE FROM IMCN_MACHINE WHERE ORGANIZATION_ID=${ORG} AND LINE_CODE = :${params.length})`;
    }
    if (scope.workstageCode) {
      params.push(scope.workstageCode);
      return ` AND ${alias}.MACHINE_CODE IN (SELECT MACHINE_CODE FROM IMCN_MACHINE WHERE ORGANIZATION_ID=${ORG} AND WORKSTAGE_CODE = :${params.length})`;
    }
    return '';
  }

  /** 설비 목록 + 유형명·공정명·모델 + 진행중 비가동 여부 */
  machines(filter: { machineType?: string; workstageCode?: string; keyword?: string; lineCode?: string; downtimeTarget?: boolean }) {
    const params: unknown[] = [];
    let where = `m.ORGANIZATION_ID = ${ORG}`;
    if (filter.downtimeTarget) where += ` AND ${downtimeTargetMachineSql('m')}`;
    if (filter.machineType) { params.push(filter.machineType); where += ` AND m.MACHINE_TYPE = :${params.length}`; }
    if (filter.workstageCode) { params.push(filter.workstageCode); where += ` AND m.WORKSTAGE_CODE = :${params.length}`; }
    if (filter.lineCode) { params.push(filter.lineCode); where += ` AND m.LINE_CODE = :${params.length}`; }
    if (filter.keyword) {
      params.push(`%${filter.keyword.toUpperCase()}%`);
      const i = params.length;
      where += ` AND (UPPER(m.MACHINE_CODE) LIKE :${i} OR UPPER(m.MACHINE_NAME) LIKE :${i})`;
    }
    return this.q(
      `SELECT m.MACHINE_CODE AS "machineCode", m.MACHINE_NAME AS "machineName",
              m.MACHINE_TYPE AS "machineType",
              (SELECT MAX(b.CODE_MEAN_KOR) FROM ISYS_BASECODE b
                WHERE b.CODE_TYPE='MACHINE TYPE' AND b.CODE_NAME=m.MACHINE_TYPE AND b.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "machineTypeName",
              m.WORKSTAGE_CODE AS "workstageCode",
              (SELECT MAX(w.WORKSTAGE_NAME) FROM IP_PRODUCT_WORKSTAGE w
                WHERE w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "workstageName",
              (SELECT MAX(w.WORKSTAGE_CODE_GROUP) FROM IP_PRODUCT_WORKSTAGE w
                WHERE w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "workstageGroup",
              m.MACHINE_MODEL_NAME AS "modelName",
              m.LINE_CODE AS "lineCode",
              (SELECT MAX(d.DT_SEQ) FROM IP_EQUIP_DOWNTIME_RESULT d
                WHERE d.MACHINE_CODE=m.MACHINE_CODE AND d.ORGANIZATION_ID=m.ORGANIZATION_ID AND d.END_TIME IS NULL) AS "openDtSeq",
              -- 시작 때 고른 사유. openDtSeq와 같은 행(진행중 중 DT_SEQ 최대)의 값이다.
              (SELECT MAX(d.REASON_CODE) KEEP (DENSE_RANK LAST ORDER BY d.DT_SEQ) FROM IP_EQUIP_DOWNTIME_RESULT d
                WHERE d.MACHINE_CODE=m.MACHINE_CODE AND d.ORGANIZATION_ID=m.ORGANIZATION_ID AND d.END_TIME IS NULL) AS "openReasonCode"
         FROM IMCN_MACHINE m
        WHERE ${where}
        ORDER BY m.MACHINE_CODE`,
      params,
    );
  }

  /** 라인 목록 (라인코드·라인명·라인구분) + 배정 설비 수 */
  lines() {
    return this.q(
      `SELECT l.LINE_CODE AS "lineCode", l.LINE_NAME AS "lineName", l.LINE_DIVISION AS "lineDivision",
              (SELECT COUNT(*) FROM IMCN_MACHINE m WHERE m.LINE_CODE=l.LINE_CODE AND m.ORGANIZATION_ID=l.ORGANIZATION_ID) AS "machineCount"
         FROM IP_PRODUCT_LINE l
        WHERE l.ORGANIZATION_ID = ${ORG}
        ORDER BY l.LINE_CODE`,
    );
  }

  /**
   * 당일 지표 — 업무일(작업 시작 시각 ~ 다음날 같은 시각, 생산 현황판과 같은 정의) 기준.
   *
   * 시간 가동율 = (부하 − 비가동) / 부하. 부하는 설비마다 월력 계획분(라인 월력 우선, 없으면 전사 월력)을
   *   지금까지 지난 시간으로 자른 값이고, 비가동은 업무일 안으로 자른 뒤 그 부하를 넘지 않게 한다.
   * 양품율 = AOI 양품 / (AOI 양품 + QC 불량). 생산수량이 라인에만 있어 라인에 속한 설비만 계산한다.
   * 성능 가동율은 당일 생산 모델의 표준시간(S/T)이 등록돼 있지 않아 계산하지 않는다.
   * 셋 중 하나라도 없으면 종합(OEE)도 없다.
   */
  async summary(scope: ScopeParams) {
    const [wd] = await this.q<{ day: string; startFrac: number }>(WORK_DAY_SQL);
    const day = wd.day;
    const startFrac = Number(wd.startFrac);

    const params: unknown[] = [day, startFrac];
    const scopeSql = this.scopeClause(scope, 'm', params);
    const rows = await this.q<{ machineCode: string; lineCode: string | null; planMin: number; downMin: number; stops: number; elapsedMin: number }>(
      `WITH b AS (SELECT x.DAY, x.DAY + x.F AS DS FROM (SELECT TO_DATE(:1, 'YYYY-MM-DD') AS DAY, :2 AS F FROM DUAL) x),
       mc AS (
         SELECT m.MACHINE_CODE, m.LINE_CODE FROM IMCN_MACHINE m
          WHERE m.ORGANIZATION_ID = ${ORG} AND ${downtimeTargetMachineSql('m')}${scopeSql}
       ),
       dt AS (
         SELECT d.MACHINE_CODE,
                SUM((LEAST(NVL(d.END_TIME, SYSDATE), SYSDATE, b.DS + 1) - GREATEST(d.START_TIME, b.DS)) * 24 * 60) AS DOWN_MIN,
                COUNT(*) AS STOPS
           FROM IP_EQUIP_DOWNTIME_RESULT d, b
          WHERE d.ORGANIZATION_ID = ${ORG}
            AND d.START_TIME < LEAST(SYSDATE, b.DS + 1) AND NVL(d.END_TIME, SYSDATE) > b.DS
            AND d.MACHINE_CODE IN (SELECT MACHINE_CODE FROM mc)
          GROUP BY d.MACHINE_CODE
       )
       SELECT mc.MACHINE_CODE AS "machineCode", mc.LINE_CODE AS "lineCode",
              NVL(NVL((SELECT c.WORK_MINUTES + c.OT_MINUTES FROM IP_PRODUCT_LINE_CALENDAR c
                        WHERE c.ORGANIZATION_ID = ${ORG} AND c.LINE_CODE = mc.LINE_CODE AND c.PLAN_DATE = b.DAY),
                      (SELECT c.WORK_MINUTES + c.OT_MINUTES FROM IP_PRODUCT_COMPANY_CALENDAR c
                        WHERE c.ORGANIZATION_ID = ${ORG} AND c.PLAN_DATE = b.DAY)), 0) AS "planMin",
              NVL(dt.DOWN_MIN, 0) AS "downMin", NVL(dt.STOPS, 0) AS "stops",
              GREATEST(0, LEAST(SYSDATE, b.DS + 1) - b.DS) * 24 * 60 AS "elapsedMin"
         FROM mc CROSS JOIN b LEFT JOIN dt ON dt.MACHINE_CODE = mc.MACHINE_CODE`,
      params,
    );

    let loadMin = 0, lossMin = 0, downMin = 0, stopCount = 0, planMin = 0;
    for (const r of rows) {
      const load = Math.min(Number(r.planMin), Number(r.elapsedMin));
      loadMin += load;
      lossMin += Math.min(Number(r.downMin), load);
      downMin += Number(r.downMin);
      stopCount += Number(r.stops);
      planMin = Math.max(planMin, Number(r.planMin));
    }
    const timeRate = loadMin > 0 ? availability(loadMin - lossMin, loadMin) : null;

    // 양품율 — 대상 설비가 속한 라인. 후공정 공정·미배정 설비는 라인이 없어 계산하지 않는다.
    const lineCodes = [...new Set(rows.map((r) => r.lineCode).filter((c): c is string => !!c && c !== '*'))];
    let goodQty = 0, defectQty = 0;
    if (lineCodes.length) {
      // 위치 바인드라 같은 자리표시자를 두 번 쓰지 않는다 — 날짜·라인 목록은 CTE 로 한 번만 받는다
      const lineRows = lineCodes.map((_, i) => `SELECT :${i + 3} AS LINE_CODE FROM DUAL`).join(' UNION ALL ');
      const [qty] = await this.q<{ goodQty: number; defectQty: number }>(
        `WITH b AS (SELECT x.DAY, x.DAY + x.F AS DS FROM (SELECT TO_DATE(:1, 'YYYY-MM-DD') AS DAY, :2 AS F FROM DUAL) x),
              ln AS (${lineRows})
         SELECT (SELECT NVL(SUM(${DASHBOARD_ACTUAL_SUM}), 0) FROM IP_ASSEMBLY_ACTUAL_TIME_V v, b
                  WHERE v.RECEIPT_DATE >= b.DAY AND v.RECEIPT_DATE < b.DAY + 1
                    AND v.LINE_CODE IN (SELECT LINE_CODE FROM ln)) AS "goodQty",
                (SELECT COUNT(*) FROM IP_PRODUCT_WORK_QC q, b
                  WHERE q.ORGANIZATION_ID = ${ORG} AND q.QC_RESULT = 'N'
                    AND q.QC_DATE >= b.DS AND q.QC_DATE < b.DS + 1
                    AND q.LINE_CODE IN (SELECT LINE_CODE FROM ln)) AS "defectQty"
           FROM DUAL`,
        [day, startFrac, ...lineCodes],
      );
      goodQty = Number(qty?.goodQty ?? 0);
      defectQty = Number(qty?.defectQty ?? 0);
    }
    const qualityRate = goodQty + defectQty > 0 ? quality(goodQty, goodQty + defectQty) : null;
    const performanceRate: number | null = null;

    return {
      workDay: day,
      downMinutes: Math.round(downMin),
      stopCount,
      machineCount: rows.length,
      planMinutes: planMin,
      loadMinutes: Math.round(loadMin),
      lossMinutes: Math.round(lossMin),
      goodQty,
      defectQty,
      timeRate,
      performanceRate,
      qualityRate,
      oeeRate: timeRate != null && performanceRate != null && qualityRate != null
        ? oee(timeRate, performanceRate, qualityRate) : null,
      reasons: {
        timeRate: timeRate == null ? (rows.length ? '계획 가동시간 없음' : '대상 설비 없음') : null,
        performanceRate: '표준시간(S/T) 미등록',
        qualityRate: qualityRate == null ? (lineCodes.length ? '당일 생산 없음' : '라인 단위 생산수량만 있음') : null,
      },
    };
  }

  /** 이전 30일 비가동 이력 + 합계 요약 — 당일 포함 최근 30일(TRUNC(SYSDATE)-29 ~ 지금) */
  async recent(scope: ScopeParams) {
    const params: unknown[] = [];
    const scopeSql = this.scopeClause(scope, 'd', params);
    const list = await this.q(
      `SELECT d.DT_SEQ AS "dtSeq", d.MACHINE_CODE AS "machineCode",
              (SELECT MAX(m.MACHINE_NAME) FROM IMCN_MACHINE m
                WHERE m.MACHINE_CODE=d.MACHINE_CODE AND m.ORGANIZATION_ID=d.ORGANIZATION_ID) AS "machineName",
              TO_CHAR(d.START_TIME,'MM-DD HH24:MI') AS "startTime",
              TO_CHAR(d.END_TIME,'MM-DD HH24:MI') AS "endTime",
              ROUND((NVL(d.END_TIME, SYSDATE) - d.START_TIME) * 24 * 60) AS "durationMin"
         FROM IP_EQUIP_DOWNTIME_RESULT d
        WHERE d.ORGANIZATION_ID = ${ORG}
          AND d.START_TIME >= TRUNC(SYSDATE) - 29${scopeSql}
        ORDER BY d.DT_SEQ DESC`,
      params,
    );
    const totalMin = list.reduce((s, r) => s + Number((r as { durationMin: number }).durationMin ?? 0), 0);
    return { list, totalCount: list.length, totalMinutes: totalMin };
  }
}
