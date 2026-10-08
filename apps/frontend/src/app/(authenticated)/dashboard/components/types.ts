/**
 * @file src/app/(authenticated)/dashboard/components/types.ts
 * @description 대시보드 뷰모델 타입 — API 5개(dashboard/summary·insights + monitoring 보드 3종)를 합친 형태
 *
 * 초보자 가이드:
 * 1. `DashboardSummary` = GET /dashboard/summary (설비·생산·솔더/MSL·불량 판정 수치)
 * 2. `DashboardInsights` = GET /dashboard/insights (7일 추이 + 라인별 계획/실적)
 * 3. 생산/품질/재고 보드 타입은 모니터링 화면의 타입을 그대로 재사용한다 (단일 출처)
 * 4. `AttentionItem` 은 buildAttention 이 만드는 "조치 필요" 큐 한 줄
 */
import type { ProductionBoardData } from "@/app/(authenticated)/monitoring/production-board/components/types";
import type { QualityBoardData } from "@/app/(authenticated)/monitoring/quality-board/components/types";
import type { InventoryBoardData } from "@/app/(authenticated)/monitoring/inventory-board/components/types";

export type { ProductionBoardData, QualityBoardData, InventoryBoardData };

/** 설비: 사용중 / 비가동(진행중 비가동 실적 있음) / 미사용 / 전체 — IMCN_MACHINE 기준 */
export interface EquipStats {
  inUse: number;
  down: number;
  notUsed: number;
  total: number;
}

/** 오늘 생산 계획 대비 실적 — SMD / 제품(MI) */
export interface ProductionStats {
  smdPlan: number;
  smdActual: number;
  miPlan: number;
  miActual: number;
}

/** 솔더·MSL 관리 현황 */
export interface MaterialStats {
  solderInUse: number;
  solderNg: number;
  mslLots: number;
  mslNg: number;
}

/** 오늘 불량 판정 — 대기 / 진성 / 가성 / 진성 중 미수리 */
export interface DefectStats {
  pending: number;
  genuine: number;
  pseudo: number;
  unrepaired: number;
}

export interface DashboardSummary {
  equip: EquipStats;
  production: ProductionStats;
  material: MaterialStats;
  defect: DefectStats;
}

export interface InsightsTrend {
  date: string;
  smdPlan: number;
  smdActual: number;
  miPlan: number;
  miActual: number;
}

export interface InsightsLine {
  lineCode: string;
  lineName?: string | null;
  /** 'SMD' | 'MI' */
  productionType: string;
  planQty: number;
  actualQty: number;
}

export interface DashboardInsights {
  date: string;
  trend: InsightsTrend[];
  lines: InsightsLine[];
}

/** 5개 API 를 합친 대시보드 원천 데이터 (실패하거나 아직 못 받은 API 는 null) */
export interface DashboardData {
  summary: DashboardSummary | null;
  insights: DashboardInsights | null;
  production: ProductionBoardData | null;
  quality: QualityBoardData | null;
  inventory: InventoryBoardData | null;
}

export type AttentionSeverity = "critical" | "high" | "medium" | "low";

/** 조치 필요 한 줄을 펼쳤을 때 보이는 개별 항목 (라인/LOT/품목 단위) */
export interface AttentionDetail {
  /** 식별자 — 라인코드 · matUid · 품목코드 등 */
  code: string;
  /** 사람이 읽는 이름 — 라인명 · 품목명 */
  name: string;
  /** 보조 정보 — 실적/계획 · 잔여일 · 보류 사유 · 재고/안전재고 */
  meta?: string;
}

export interface AttentionItem {
  /** i18n 키 접미사 (dashboard.attention.{key}) */
  key: string;
  severity: AttentionSeverity;
  count: number;
  /** 대표 항목 최대 3개 — 접힌 상태의 한 줄 요약 */
  samples: string[];
  /** 펼쳤을 때 보이는 전체 목록. 건수만 집계되는 항목(설비 비가동·솔더/MSL NG·불량 판정)은 빈 배열 */
  details: AttentionDetail[];
  /** 이동할 화면 경로 (menuConfig.ts 에 실제 존재하는 화면) */
  href: string;
}
