/**
 * @file src/modules/dashboard/dashboard.service.ts
 * @description 대시보드 서비스 — summary는 임시 mock, KPI/최근생산은 Oracle 패키지 호출
 *
 * 초보자 가이드:
 * 1. OracleService.callProc()로 PKG_DASHBOARD 패키지의 프로시저를 호출
 * 2. callProcMultiCursor()로 다중 커서(요약+아이템) 반환 프로시저 호출
 * 3. 기존 API 응답 구조를 그대로 유지하여 프론트엔드 변경 없음
 *
 * 현재 호출하는 패키지 프로시저:
 * - SP_KPI: KPI 4대 지표
 * - SP_RECENT_PRODUCTIONS: 최근 작업지시 10건
 */
import { Injectable } from '@nestjs/common';
import { OracleService } from '../../common/services/oracle.service';

const PKG = 'PKG_DASHBOARD';

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
  constructor(private readonly oracle: OracleService) {}

  private tenantParams(company?: string, plant?: string) {
    return {
      p_company: company ?? null,
      p_plant: plant ?? null,
    };
  }

  /**
   * 대시보드 요약 데이터 (현황판 전용)
   * 기존 API 응답 구조 유지: { equip, job, mat, defect, daily, periodic, pm }
   * TODO: PKG_DASHBOARD 프로시저가 은성 DB에 준비되면 실제 조회로 복구한다.
   */
  async getSummary(_dateStr: string, _company?: string, _plant?: string) {
    const inspect = { total: 0, completed: 0, pass: 0, fail: 0, items: [] };
    return {
      equip: { normal: 0, maint: 0, stop: 0, total: 0 },
      job: { wait: 0, running: 0, done: 0, total: 0 },
      mat: { lowStock: 0, nearExpiry: 0, expired: 0 },
      defect: { wait: 0, repair: 0, rework: 0, done: 0, total: 0 },
      daily: { ...inspect },
      periodic: { ...inspect },
      pm: { ...inspect },
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
