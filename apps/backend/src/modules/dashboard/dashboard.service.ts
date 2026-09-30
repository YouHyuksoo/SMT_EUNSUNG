/**
 * @file src/modules/dashboard/dashboard.service.ts
 * @description 대시보드 서비스 — summary는 은성 테이블 직접 조회, KPI/최근생산은 Oracle 패키지 호출
 *
 * 초보자 가이드:
 * 0. getSummary() 카드 4개의 출처
 *    - 설비: IMCN_MACHINE (온도계 TEMP 제외) + 진행중 비가동 IP_EQUIP_DOWNTIME_RESULT(END_TIME 없음)
 *    - 생산: 당일 계획 IP_PRODUCT_SMD_PLAN / IP_PRODUCT_MI_PLAN 의 PLAN_QTY 합
 *            vs 당일 실적 뷰 IP_ASSEMBLY_ACTUAL_TIME_V / IP_PRODUCT_ACTUAL_TIME_V 시간대 합
 *            (계획 테이블 ACTUAL_QTY 는 갱신되지 않아 0 이다)
 *    - 자재: 사용중 솔더(IM_ITEM_SOLDER_MASTER) · MSL 관리 LOT(IM_ITEM_MSL_CHECK_VIEW 2A 이상)
 *            + NG 건수는 display 31/29 와 같은 @smt/shared SQL
 *    - 불량: 당일 IP_PRODUCT_WORK_QC — QC_RESULT W=대기 N=진성 O=가성, 진성 중 REPAIR_RESULT_CODE≠G 는 미수리
 *    일상/정기점검·PM 은 은성 DB에 데이터가 없어(EQUIP_INSPECT_*, IMCN_PM_RESULT 0행) 제공하지 않는다.
 * 1. OracleService.callProc()로 PKG_DASHBOARD 패키지의 프로시저를 호출
 * 2. callProcMultiCursor()로 다중 커서(요약+아이템) 반환 프로시저 호출
 * 3. 기존 API 응답 구조를 그대로 유지하여 프론트엔드 변경 없음
 *
 * 현재 호출하는 패키지 프로시저:
 * - SP_KPI: KPI 4대 지표
 * - SP_RECENT_PRODUCTIONS: 최근 작업지시 10건
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { sqlMslNgCount, sqlSolderNgCount } from '@smt/shared';
import { OracleService } from '../../common/services/oracle.service';

const PKG = 'PKG_DASHBOARD';
const ORG = 1;

/** 실적 뷰의 시간대 10칸(A~J) 합 */
const ACTUAL_SUM = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
  .map((p) => `NVL(v.${p}_TIME_ACTUAL, 0)`)
  .join(' + ');

type CountRow = Record<string, number | string | null>;

type KpiRow = {
  todayProd?: number;
  prodChange?: number;
  inventoryTotal?: number;
  invChange?: number;
  passRate?: string;
  rateChange?: number;
  defectCnt?: number;
  defectChange?: number;
};

type RecentProductionRow = Record<string, unknown>;

@Injectable()
export class DashboardService {
  constructor(
    private readonly oracle: OracleService,
    private readonly dataSource: DataSource,
  ) {}

  private async one(sql: string, binds: Record<string, unknown> = {}): Promise<Record<string, number>> {
    // 이름 바인드(:day)는 같은 이름이 여러 번 나와도 한 값으로 묶인다
    const rows = (await this.dataSource.query(sql, binds as unknown as unknown[])) as CountRow[];
    const row = rows[0] ?? {};
    return Object.fromEntries(Object.entries(row).map(([k, v]) => [k, Number(v ?? 0)]));
  }

  private tenantParams(company?: string, plant?: string) {
    return {
      p_company: company ?? null,
      p_plant: plant ?? null,
    };
  }

  /**
   * 대시보드 요약 (현황 카드 4개). dateStr(YYYY-MM-DD) 하루 기준, 없으면 오늘.
   * 설비·자재는 조회 시점 현재 상태다.
   */
  async getSummary(dateStr?: string, _company?: string, _plant?: string) {
    const date = dateStr?.trim() || null;
    if (date && !/^\d{4}-\d{2}-\d{2}$/.test(date)) {
      throw new BadRequestException('date 는 YYYY-MM-DD 형식이어야 합니다.');
    }
    const day = `NVL(TO_DATE(:day, 'YYYY-MM-DD'), TRUNC(SYSDATE))`;

    const [equip, production, material, solderNg, mslNg, defect] = await Promise.all([
      this.one(
        `SELECT e."total", e."inUse", e."notUsed",
                (SELECT COUNT(DISTINCT d.MACHINE_CODE) FROM IP_EQUIP_DOWNTIME_RESULT d
                  WHERE d.ORGANIZATION_ID = ${ORG} AND d.END_TIME IS NULL) AS "down"
           FROM (SELECT COUNT(*) AS "total",
                        NVL(SUM(CASE WHEN m.USE_STATUS = 'U' THEN 1 ELSE 0 END), 0) AS "inUse",
                        NVL(SUM(CASE WHEN m.USE_STATUS IN ('S', 'T', 'D') THEN 1 ELSE 0 END), 0) AS "notUsed"
                   FROM IMCN_MACHINE m
                  WHERE m.ORGANIZATION_ID = ${ORG}
                    AND NVL(m.MACHINE_TYPE, '*') <> 'TEMP') e`,
      ),
      this.one(
        `SELECT (SELECT NVL(SUM(p.PLAN_QTY), 0) FROM IP_PRODUCT_SMD_PLAN p
                  WHERE p.ORGANIZATION_ID = ${ORG} AND p.PLAN_DATE = ${day}) AS "smdPlan",
                (SELECT NVL(SUM(${ACTUAL_SUM}), 0) FROM IP_ASSEMBLY_ACTUAL_TIME_V v
                  WHERE v.RECEIPT_DATE = ${day}) AS "smdActual",
                (SELECT NVL(SUM(p.PLAN_QTY), 0) FROM IP_PRODUCT_MI_PLAN p
                  WHERE p.ORGANIZATION_ID = ${ORG} AND p.PLAN_DATE = ${day}) AS "miPlan",
                (SELECT NVL(SUM(${ACTUAL_SUM}), 0) FROM IP_PRODUCT_ACTUAL_TIME_V v
                  WHERE v.ACTUAL_DATE = ${day}) AS "miActual"
           FROM DUAL`,
        { day: date },
      ),
      this.one(
        `SELECT (SELECT COUNT(*) FROM IM_ITEM_SOLDER_MASTER s
                  WHERE s.ORGANIZATION_ID = ${ORG} AND s.ISSUE_DATE IS NOT NULL AND s.DESTROY_DATE IS NULL) AS "solderInUse",
                (SELECT COUNT(*) FROM IM_ITEM_MSL_CHECK_VIEW a WHERE a.MSL_LEVEL >= '2A') AS "mslLots"
           FROM DUAL`,
      ),
      this.one(sqlSolderNgCount()),
      this.one(sqlMslNgCount()),
      this.one(
        `SELECT NVL(SUM(CASE WHEN q.QC_RESULT = 'W' THEN 1 ELSE 0 END), 0) AS "pending",
                NVL(SUM(CASE WHEN q.QC_RESULT = 'N' THEN 1 ELSE 0 END), 0) AS "genuine",
                NVL(SUM(CASE WHEN q.QC_RESULT = 'O' THEN 1 ELSE 0 END), 0) AS "pseudo",
                NVL(SUM(CASE WHEN q.QC_RESULT = 'N' AND NVL(q.REPAIR_RESULT_CODE, '*') <> 'G' THEN 1 ELSE 0 END), 0) AS "unrepaired"
           FROM IP_PRODUCT_WORK_QC q
          WHERE q.ORGANIZATION_ID = ${ORG}
            AND q.QC_DATE >= ${day}
            AND q.QC_DATE < ${day} + 1`,
        { day: date },
      ),
    ]);

    return {
      equip: { inUse: equip.inUse, down: equip.down, notUsed: equip.notUsed, total: equip.total },
      production: {
        smdPlan: production.smdPlan,
        smdActual: production.smdActual,
        miPlan: production.miPlan,
        miActual: production.miActual,
      },
      material: {
        solderInUse: material.solderInUse,
        solderNg: solderNg.NG_COUNT ?? 0,
        mslLots: material.mslLots,
        mslNg: mslNg.NG_COUNT ?? 0,
      },
      defect: {
        pending: defect.pending,
        genuine: defect.genuine,
        pseudo: defect.pseudo,
        unrepaired: defect.unrepaired,
      },
    };
  }

  /** KPI 데이터 (생산량/재고/합격률/불량) */
  async getKpi(company?: string, plant?: string) {
    const rows = await this.oracle.callProc<KpiRow>(PKG, 'SP_KPI', this.tenantParams(company, plant));
    const r = rows[0] || {};
    return {
      todayProduction: { value: r.todayProd ?? 0, change: r.prodChange ?? 0 },
      inventoryStatus: { value: r.inventoryTotal ?? 0, change: r.invChange ?? 0 },
      qualityPassRate: { value: r.passRate ?? '100.0', change: r.rateChange ?? 0 },
      interlockCount: { value: r.defectCnt ?? 0, change: r.defectChange ?? 0 },
    };
  }

  /**
   * 최근 작업지시 10건
   * SP_RECENT_PRODUCTIONS에서 LINE_CODE→LINE alias, progress 계산,
   * WAITING→WAIT 상태 매핑을 PL/SQL에서 처리하므로 그대로 반환
   */
  async getRecentProductions(company?: string, plant?: string) {
    return this.oracle.callProc<RecentProductionRow>(PKG, 'SP_RECENT_PRODUCTIONS', this.tenantParams(company, plant));
  }

}
