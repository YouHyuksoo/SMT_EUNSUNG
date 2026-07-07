"use strict";
/**
 * @file packages/shared/src/utils/part-rules.ts
 * @description 품목마스터 공통 업무 규칙
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.IQC_NO_INSPECTION_METHOD_VALUES = void 0;
exports.isIqcNoInspectionMethod = isIqcNoInspectionMethod;
exports.requiresIqcAqlPolicy = requiresIqcAqlPolicy;
exports.IQC_NO_INSPECTION_METHOD_VALUES = ['SKIP', 'NONE'];
function isIqcNoInspectionMethod(inspectMethod) {
    const method = (inspectMethod ?? '').trim().toUpperCase();
    return exports.IQC_NO_INSPECTION_METHOD_VALUES.includes(method);
}
function requiresIqcAqlPolicy(iqcYn, inspectMethod) {
    const isIqcTarget = (iqcYn ?? 'Y').trim().toUpperCase() === 'Y';
    return isIqcTarget && !isIqcNoInspectionMethod(inspectMethod);
}
