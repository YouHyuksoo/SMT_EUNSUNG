/**
 * @file packages/shared/src/oee/types.ts
 * @description OEE 도메인 공용 타입 (프론트/백엔드 공유).
 * 근거: docs/specs/2026-07-06-oee-management-design.md §5.3
 */

/** 가동일지 구간 (근무조 시작 기준 경과분) */
export interface LogInterval {
  /** 근무조 시작 기준 경과분 */
  startMin: number;
  endMin: number;
  status: 'RUN' | 'DOWN';
  /** DOWN일 때 필수 */
  reasonCode: string | null;
}

/** 가동일지 검증 오류 */
export interface OeeValidationError {
  code: 'REVERSED' | 'OVERLAP' | 'EXCEEDS_LOAD' | 'REASON_REQUIRED';
  /** 해당 구간 index, 전체 위반이면 -1 */
  index: number;
  message: string;
}
