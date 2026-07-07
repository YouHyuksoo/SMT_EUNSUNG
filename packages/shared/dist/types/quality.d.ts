/**
 * @file packages/shared/src/types/quality.ts
 * @description 품질 관련 타입 정의
 *
 * 초보자 가이드:
 * 1. **IQC**: Incoming Quality Control (수입검사)
 * 2. **PQC**: Process Quality Control (공정검사)
 * 3. **FQC**: Final Quality Control (최종검사)
 * 4. **OQC**: Outgoing Quality Control (출하검사)
 */
import { QualityJudgment, DefectDisposition, InspectionType, RepairStatus } from './enums';
/** 검사 결과 */
export interface InspectResult {
    id: string;
    inspectNo: string;
    inspectDate: string;
    inspectType: InspectionType;
    targetType: 'LOT' | 'JOB_ORDER' | 'PRODUCT';
    targetId: string;
    itemCode: string;
    itemName: string;
    lotNo?: string;
    sampleQty: number;
    passQty: number;
    failQty: number;
    judgment: QualityJudgment;
    inspectorId: string;
    inspectorName: string;
    inspectStartTime: string;
    inspectEndTime?: string;
    equipmentId?: string;
    standardId?: string;
    description?: string;
    createdAt: string;
    updatedAt: string;
}
/** 검사 결과 상세 (검사 항목별) */
export interface InspectResultDetail {
    id: string;
    inspectResultId: string;
    seq: number;
    inspectItemCode: string;
    inspectItemName: string;
    specMin?: number;
    specMax?: number;
    specTarget?: number;
    unit?: string;
    measuredValue?: number;
    measuredText?: string;
    judgment: QualityJudgment;
    defectCode?: string;
    description?: string;
}
/** 불량 로그 */
export interface DefectLog {
    id: string;
    defectNo: string;
    defectDate: string;
    processCode: string;
    processName: string;
    jobOrderId?: string;
    jobOrderNo?: string;
    prodResultNo?: string;
    itemCode: string;
    itemName: string;
    lotNo?: string;
    defectCode: string;
    defectName: string;
    defectQty: number;
    unit: string;
    defectCause?: string;
    detectedBy: string;
    detectedByName: string;
    disposition?: DefectDisposition;
    dispositionDate?: string;
    dispositionBy?: string;
    equipmentId?: string;
    operatorId?: string;
    operatorName?: string;
    shiftCode?: string;
    description?: string;
    imageUrls?: string[];
    createdAt: string;
    updatedAt: string;
}
/** 수리 로그 */
export interface RepairLog {
    id: string;
    repairNo: string;
    defectLogId: string;
    defectNo: string;
    repairDate: string;
    itemCode: string;
    itemName: string;
    lotNo?: string;
    defectCode: string;
    defectName: string;
    defectQty: number;
    repairQty: number;
    scrapQty: number;
    unit: string;
    repairMethod?: string;
    repairOperatorId: string;
    repairOperatorName: string;
    repairStartTime: string;
    repairEndTime?: string;
    status: RepairStatus;
    reinspectRequired: boolean;
    reinspectResult?: QualityJudgment;
    reinspectBy?: string;
    reinspectAt?: string;
    usedMaterials?: RepairMaterial[];
    description?: string;
    createdAt: string;
    updatedAt: string;
}
/** 수리 사용 자재 */
export interface RepairMaterial {
    itemCode: string;
    itemName: string;
    lotNo?: string;
    usedQty: number;
    unit: string;
}
/** MRB (Material Review Board) - 불량 심의 */
export interface MrbRecord {
    id: string;
    mrbNo: string;
    mrbDate: string;
    defectLogId: string;
    defectNo: string;
    itemCode: string;
    itemName: string;
    lotNo?: string;
    defectQty: number;
    unit: string;
    defectCode: string;
    defectName: string;
    defectDescription?: string;
    requestedBy: string;
    requestedByName: string;
    reviewers?: string[];
    decision?: DefectDisposition;
    decisionDate?: string;
    decisionBy?: string;
    decisionReason?: string;
    conditionOfUse?: string;
    customerApproval?: boolean;
    customerApprovalNo?: string;
    status: 'REQUESTED' | 'IN_REVIEW' | 'DECIDED' | 'CLOSED';
    createdAt: string;
    updatedAt: string;
}
/** 검사 기준서 */
export interface InspectionStandard {
    id: string;
    standardCode: string;
    standardName: string;
    inspectType: InspectionType;
    itemCode?: string;
    processCode?: string;
    revision: string;
    effectiveFrom: string;
    effectiveTo?: string;
    isActive: boolean;
    items: InspectionStandardItem[];
    description?: string;
    createdBy: string;
    createdAt: string;
    updatedAt: string;
}
/** 검사 기준 항목 */
export interface InspectionStandardItem {
    seq: number;
    inspectItemCode: string;
    inspectItemName: string;
    inspectMethod?: string;
    specMin?: number;
    specMax?: number;
    specTarget?: number;
    unit?: string;
    sampleSize?: string;
    isMandatory: boolean;
    equipmentType?: string;
}
/** 통전검사 결과 */
export interface ElectricalTestResult {
    id: string;
    testNo: string;
    testDate: string;
    prodResultNo?: string;
    jobOrderId?: string;
    itemCode: string;
    itemName: string;
    lotNo?: string;
    boxNo?: string;
    testType: 'CONTINUITY' | 'INSULATION' | 'HI_POT' | 'COMBINED';
    testedQty: number;
    passQty: number;
    failQty: number;
    testVoltage?: number;
    testCurrent?: number;
    testTime?: number;
    equipmentId: string;
    equipmentName: string;
    operatorId: string;
    operatorName: string;
    judgment: QualityJudgment;
    failDetails?: ElectricalTestFail[];
    createdAt: string;
}
/** 통전검사 불량 상세 */
export interface ElectricalTestFail {
    cavityNo?: number;
    pinNo?: string;
    failType: 'OPEN' | 'SHORT' | 'MISWIRE' | 'HI_RESISTANCE';
    measuredValue?: number;
    standardValue?: number;
}
/** 품질 일일 현황 */
export interface DailyQualitySummary {
    workDate: string;
    plantId: string;
    processCode?: string;
    itemCode?: string;
    totalInputQty: number;
    totalOutputQty: number;
    totalDefectQty: number;
    defectRate: number;
    defectByCode: {
        defectCode: string;
        defectName: string;
        qty: number;
        rate: number;
    }[];
    repairQty: number;
    scrapQty: number;
    reworkQty: number;
}
/** SPC 데이터 */
export interface SpcData {
    id: string;
    measureDate: string;
    itemCode: string;
    processCode: string;
    characteristicCode: string;
    characteristicName: string;
    subgroupNo: number;
    sampleNo: number;
    measuredValue: number;
    ucl?: number;
    lcl?: number;
    usl?: number;
    lsl?: number;
    target?: number;
    equipmentId?: string;
    operatorId?: string;
    isOutOfControl: boolean;
}
//# sourceMappingURL=quality.d.ts.map