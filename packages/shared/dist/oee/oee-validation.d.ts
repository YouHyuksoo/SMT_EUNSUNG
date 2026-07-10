/**
 * @file packages/shared/src/oee/oee-validation.ts
 * @description 가동일지 구간 검증 순수 함수. 프론트 입력검증과 백엔드 write API가 공유한다(검증식 단일 출처).
 * 근거: docs/specs/2026-07-06-oee-management-design.md §5.3
 */
import type { LogInterval, OeeValidationError } from './types';
/**
 * 가동일지 구간을 검증한다. 위반이 없으면 빈 배열을 반환한다.
 * 검사: ①역전(end<=start) ②겹침 ③합>계획가동 ④DOWN인데 사유없음.
 */
export declare function validateIntervals(intervals: LogInterval[], netLoadMinutes: number): OeeValidationError[];
//# sourceMappingURL=oee-validation.d.ts.map