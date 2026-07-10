"use strict";
/**
 * @file packages/shared/src/types/enums.ts
 * @description 공정/상태 Enum 타입 정의
 * Oracle 예약어 회피를 위해 컬럼명 규칙 준수
 *
 * 초보자 가이드:
 * 1. **Enum 사용법**: ProcessType.CUTTING 형태로 사용
 * 2. **확장 시**: 새 값 추가 후 관련 상수(constants/)도 함께 업데이트
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShipmentStatus = exports.InspectionType = exports.JobOrderType = exports.BomType = exports.ItemType = exports.CancelType = exports.EquipmentStatus = exports.InterfaceStatus = exports.RepairStatus = exports.WarehouseType = exports.InventoryMoveType = exports.DefectDisposition = exports.QualityJudgment = exports.Status = exports.WorkStatus = exports.ProcessType = void 0;
/** 공정 유형 */
var ProcessType;
(function (ProcessType) {
    ProcessType["CUTTING"] = "CUTTING";
    ProcessType["CRIMPING"] = "CRIMPING";
    ProcessType["ASSEMBLY"] = "ASSEMBLY";
    ProcessType["INSPECTION"] = "INSPECTION";
    ProcessType["PACKING"] = "PACKING";
})(ProcessType || (exports.ProcessType = ProcessType = {}));
/** 작업 상태 */
var WorkStatus;
(function (WorkStatus) {
    WorkStatus["PENDING"] = "PENDING";
    WorkStatus["IN_PROGRESS"] = "IN_PROGRESS";
    WorkStatus["COMPLETED"] = "COMPLETED";
    WorkStatus["CANCELED"] = "CANCELED";
    WorkStatus["ON_HOLD"] = "ON_HOLD";
})(WorkStatus || (exports.WorkStatus = WorkStatus = {}));
/** 일반 상태 코드 */
var Status;
(function (Status) {
    Status["ACTIVE"] = "ACTIVE";
    Status["INACTIVE"] = "INACTIVE";
    Status["CANCELED"] = "CANCELED";
    Status["COMPLETED"] = "COMPLETED";
    Status["IN_PROGRESS"] = "IN_PROGRESS";
    Status["PENDING"] = "PENDING";
})(Status || (exports.Status = Status = {}));
/** 품질 판정 */
var QualityJudgment;
(function (QualityJudgment) {
    QualityJudgment["PASS"] = "PASS";
    QualityJudgment["FAIL"] = "FAIL";
    QualityJudgment["PENDING"] = "PENDING";
    QualityJudgment["CONDITIONAL"] = "CONDITIONAL";
})(QualityJudgment || (exports.QualityJudgment = QualityJudgment = {}));
/** 불량 처리 유형 */
var DefectDisposition;
(function (DefectDisposition) {
    DefectDisposition["REPAIR"] = "REPAIR";
    DefectDisposition["REWORK"] = "REWORK";
    DefectDisposition["SCRAP"] = "SCRAP";
    DefectDisposition["CONCESSION"] = "CONCESSION";
})(DefectDisposition || (exports.DefectDisposition = DefectDisposition = {}));
/** 재고 이동 유형 */
var InventoryMoveType;
(function (InventoryMoveType) {
    InventoryMoveType["RECEIPT"] = "RECEIPT";
    InventoryMoveType["ISSUE"] = "ISSUE";
    InventoryMoveType["TRANSFER"] = "TRANSFER";
    InventoryMoveType["ADJUSTMENT"] = "ADJUSTMENT";
    InventoryMoveType["SCRAP"] = "SCRAP";
})(InventoryMoveType || (exports.InventoryMoveType = InventoryMoveType = {}));
/** 창고 유형 */
var WarehouseType;
(function (WarehouseType) {
    WarehouseType["RAW_MATERIAL"] = "RAW_MATERIAL";
    WarehouseType["WIP"] = "WIP";
    WarehouseType["FINISHED"] = "FINISHED";
    WarehouseType["MRB"] = "MRB";
    WarehouseType["HOLD"] = "HOLD";
})(WarehouseType || (exports.WarehouseType = WarehouseType = {}));
/** 수리 상태 */
var RepairStatus;
(function (RepairStatus) {
    RepairStatus["WAITING"] = "WAITING";
    RepairStatus["IN_REPAIR"] = "IN_REPAIR";
    RepairStatus["COMPLETED"] = "COMPLETED";
    RepairStatus["SCRAPPED"] = "SCRAPPED";
})(RepairStatus || (exports.RepairStatus = RepairStatus = {}));
/** ERP 인터페이스 상태 */
var InterfaceStatus;
(function (InterfaceStatus) {
    InterfaceStatus["PENDING"] = "PENDING";
    InterfaceStatus["SENT"] = "SENT";
    InterfaceStatus["FAILED"] = "FAILED";
    InterfaceStatus["CONFIRMED"] = "CONFIRMED";
})(InterfaceStatus || (exports.InterfaceStatus = InterfaceStatus = {}));
/** 설비 상태 */
var EquipmentStatus;
(function (EquipmentStatus) {
    EquipmentStatus["RUNNING"] = "RUNNING";
    EquipmentStatus["IDLE"] = "IDLE";
    EquipmentStatus["MAINTENANCE"] = "MAINTENANCE";
    EquipmentStatus["BREAKDOWN"] = "BREAKDOWN";
    EquipmentStatus["SETUP"] = "SETUP";
})(EquipmentStatus || (exports.EquipmentStatus = EquipmentStatus = {}));
/** 트랜잭션 취소 유형 */
var CancelType;
(function (CancelType) {
    CancelType["RECEIPT_CANCEL"] = "RECEIPT_CANCEL";
    CancelType["ISSUE_CANCEL"] = "ISSUE_CANCEL";
    CancelType["PRODUCTION_CANCEL"] = "PRODUCTION_CANCEL";
    CancelType["SHIPMENT_CANCEL"] = "SHIPMENT_CANCEL";
})(CancelType || (exports.CancelType = CancelType = {}));
/** 품목 유형 */
var ItemType;
(function (ItemType) {
    ItemType["RAW_MATERIAL"] = "RAW_MATERIAL";
    ItemType["SEMI_PRODUCT"] = "SEMI_PRODUCT";
    ItemType["FINISHED"] = "FINISHED";
    ItemType["CONSUMABLE"] = "CONSUMABLE";
})(ItemType || (exports.ItemType = ItemType = {}));
/** BOM 유형 */
var BomType;
(function (BomType) {
    BomType["PRODUCTION"] = "PRODUCTION";
    BomType["STANDARD"] = "STANDARD";
    BomType["ENGINEERING"] = "ENGINEERING";
})(BomType || (exports.BomType = BomType = {}));
/** 작업지시 유형 */
var JobOrderType;
(function (JobOrderType) {
    JobOrderType["NORMAL"] = "NORMAL";
    JobOrderType["REWORK"] = "REWORK";
    JobOrderType["SAMPLE"] = "SAMPLE";
    JobOrderType["TRIAL"] = "TRIAL";
})(JobOrderType || (exports.JobOrderType = JobOrderType = {}));
/** 검사 유형 */
var InspectionType;
(function (InspectionType) {
    InspectionType["IQC"] = "IQC";
    InspectionType["PQC"] = "PQC";
    InspectionType["FQC"] = "FQC";
    InspectionType["OQC"] = "OQC";
})(InspectionType || (exports.InspectionType = InspectionType = {}));
/** 출하 상태 */
var ShipmentStatus;
(function (ShipmentStatus) {
    ShipmentStatus["PLANNED"] = "PLANNED";
    ShipmentStatus["PICKING"] = "PICKING";
    ShipmentStatus["PACKED"] = "PACKED";
    ShipmentStatus["SHIPPED"] = "SHIPPED";
    ShipmentStatus["DELIVERED"] = "DELIVERED";
    ShipmentStatus["CANCELED"] = "CANCELED";
})(ShipmentStatus || (exports.ShipmentStatus = ShipmentStatus = {}));
