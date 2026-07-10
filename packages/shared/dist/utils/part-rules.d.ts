/**
 * @file packages/shared/src/utils/part-rules.ts
 * @description 품목마스터 공통 업무 규칙
 */
export declare const IQC_NO_INSPECTION_METHOD_VALUES: readonly ["SKIP", "NONE"];
export type IqcNoInspectionMethodValue = typeof IQC_NO_INSPECTION_METHOD_VALUES[number];
export declare function isIqcNoInspectionMethod(inspectMethod?: string | null): boolean;
//# sourceMappingURL=part-rules.d.ts.map