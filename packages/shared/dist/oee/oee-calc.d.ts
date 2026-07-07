/**
 * @file packages/shared/src/oee/oee-calc.ts
 * @description OEE 계산 순수 함수. 프론트/백엔드/집계가 이 정의를 공유한다 (계산식 단일 출처).
 * 분모가 0 이하이면 0을 반환한다. 비율은 clamp하지 않는다(1 초과 = 이상 노출).
 * 근거: docs/specs/2026-07-06-oee-management-design.md §4.1
 */
/** 가동율 = 실제 가동시간 / 계획 가동시간(순부하시간) */
export declare function availability(runMinutes: number, netLoadMinutes: number): number;
/** 성능율 = (이론CT초 × 총생산수량) / (가동분 × 60) */
export declare function performance(idealCtSec: number, totalQty: number, runMinutes: number): number;
/** 양품율 = 양품수량 / 총생산수량 */
export declare function quality(goodQty: number, totalQty: number): number;
/** OEE = 가동율 × 성능율 × 양품율 */
export declare function oee(availabilityRate: number, performanceRate: number, qualityRate: number): number;
//# sourceMappingURL=oee-calc.d.ts.map