// 설비 운영 현황 화면의 공용 타입 — 모니터링 탭과 비가동 처리 탭이 함께 쓴다

/** GET /oee/equip-ops/machines 한 행 */
export interface OpsMachine {
  machineCode: string;
  machineName: string | null;
  machineType: string | null;
  machineTypeName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  /** 공정그룹 (SMT / PBA=후공정 …) */
  workstageGroup: string | null;
  modelName: string | null;
  lineCode: string | null;
  /** 진행중 비가동의 DT_SEQ. null이면 정상 가동 */
  openDtSeq: number | null;
  /** 진행중 비가동을 시작할 때 고른 사유코드. 종료 화면의 기본값이 된다 */
  openReasonCode: string | null;
}

/** GET /oee/equip-ops/lines 한 행 */
export interface OpsLine {
  lineCode: string;
  lineName: string | null;
  lineDivision: string | null;
  machineCount: number;
}

/** GET /oee/equip-ops/summary — 업무일 기준 당일 지표. 비율은 0~1, 계산할 수 없으면 null 과 사유 */
export interface DailySummary {
  workDay: string | null;
  downMinutes: number;
  stopCount: number;
  machineCount: number;
  /** 월력 계획분 (설비 1대 기준) */
  planMinutes: number;
  /** 지금까지의 부하분 합 (설비 대수 × 지난 계획분) */
  loadMinutes: number;
  /** 부하 안에서 센 비가동분 합 */
  lossMinutes: number;
  goodQty: number;
  defectQty: number;
  timeRate: number | null;
  performanceRate: number | null;
  qualityRate: number | null;
  oeeRate: number | null;
  reasons: { timeRate: string | null; performanceRate: string | null; qualityRate: string | null };
}

export const EMPTY_SUMMARY: DailySummary = {
  workDay: null, downMinutes: 0, stopCount: 0, machineCount: 0, planMinutes: 0, loadMinutes: 0, lossMinutes: 0,
  goodQty: 0, defectQty: 0, timeRate: null, performanceRate: null, qualityRate: null, oeeRate: null,
  reasons: { timeRate: null, performanceRate: null, qualityRate: null },
};

/** GET /oee/equip-ops/recent 한 행 (당일 포함 최근 30일) */
export interface RecentRow {
  dtSeq: number;
  machineCode: string;
  machineName: string | null;
  startTime: string | null;
  endTime: string | null;
  durationMin: number;
}

/** 자동갱신 주기(초). 0이면 끄기 */
export const REFRESH_INTERVALS = [0, 10, 30, 60] as const;
export type RefreshInterval = (typeof REFRESH_INTERVALS)[number];
