// 설비 운영 현황 화면의 공용 타입 — 모니터링 탭과 비가동 처리 탭이 함께 쓴다

/** GET /oee/equip-ops/machines 한 행 */
export interface OpsMachine {
  machineCode: string;
  machineName: string | null;
  machineType: string | null;
  machineTypeName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  modelName: string | null;
  lineCode: string | null;
  /** 진행중 비가동의 DT_SEQ. null이면 정상 가동 */
  openDtSeq: number | null;
}

/** GET /oee/equip-ops/lines 한 행 */
export interface OpsLine {
  lineCode: string;
  lineName: string | null;
  lineDivision: string | null;
  machineCount: number;
}

/** GET /oee/equip-ops/monthly 한 행 */
export interface MonthlyRow {
  dtSeq: number;
  machineCode: string;
  machineName: string | null;
  reasonCode: string | null;
  reasonName: string | null;
  startTime: string | null;
  endTime: string | null;
  durationMin: number;
}

/** 자동갱신 주기(초). 0이면 끄기 */
export const REFRESH_INTERVALS = [0, 10, 30, 60] as const;
export type RefreshInterval = (typeof REFRESH_INTERVALS)[number];
