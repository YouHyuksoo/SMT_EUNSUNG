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

/** GET /oee/equip-ops/recent 한 행 (당일 포함 최근 30일) */
export interface RecentRow {
  dtSeq: number;
  machineCode: string;
  machineName: string | null;
  startTime: string | null;
  endTime: string | null;
  /** 원인설비 여부: 'Y'면 이 설비가 라인 정지의 원인 */
  causeYn: string;
  durationMin: number;
}

/** 자동갱신 주기(초). 0이면 끄기 */
export const REFRESH_INTERVALS = [0, 10, 30, 60] as const;
export type RefreshInterval = (typeof REFRESH_INTERVALS)[number];
