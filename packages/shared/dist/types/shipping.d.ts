/**
 * @file packages/shared/src/types/shipping.ts
 * @description 출하/포장 관련 타입 정의
 *
 * 초보자 가이드:
 * 1. **박스**: 제품을 담는 최소 포장 단위
 * 2. **팔레트**: 여러 박스를 적재하는 단위
 * 3. **출하**: 고객에게 제품을 보내는 프로세스
 */
import { ShipmentStatus, QualityJudgment } from './enums';
/** 박스 마스터 */
export interface BoxMaster {
    id: string;
    boxNo: string;
    boxType: string;
    itemCode: string;
    itemName: string;
    lotNo: string;
    qty: number;
    unit: string;
    packingDate: string;
    lineId: string;
    lineCode: string;
    operatorId: string;
    operatorName: string;
    jobOrderId?: string;
    jobOrderNo?: string;
    prodResultNo?: string;
    palletId?: string;
    palletNo?: string;
    oqcStatus?: QualityJudgment;
    oqcDate?: string;
    oqcBy?: string;
    isShipped: boolean;
    shippedDate?: string;
    shipmentId?: string;
    serialNumbers?: string[];
    weight?: number;
    weightUnit?: string;
    description?: string;
    createdAt: string;
    updatedAt: string;
}
/** 팔레트 마스터 */
export interface PalletMaster {
    id: string;
    palletNo: string;
    palletType: string;
    maxBoxCount: number;
    currentBoxCount: number;
    itemCode?: string;
    itemName?: string;
    totalQty: number;
    unit: string;
    packingDate: string;
    packingCompleteDate?: string;
    warehouseId?: string;
    locationId?: string;
    operatorId: string;
    operatorName: string;
    oqcStatus?: QualityJudgment;
    oqcDate?: string;
    oqcBy?: string;
    isShipped: boolean;
    shippedDate?: string;
    shipmentId?: string;
    isClosed: boolean;
    closedDate?: string;
    closedBy?: string;
    weight?: number;
    weightUnit?: string;
    boxes?: BoxMaster[];
    description?: string;
    createdAt: string;
    updatedAt: string;
}
/** 출하 지시 */
export interface ShipmentOrder {
    id: string;
    shipmentOrderNo: string;
    orderDate: string;
    customerCode: string;
    customerName: string;
    customerOrderNo?: string;
    deliveryDate: string;
    deliveryAddress?: string;
    deliveryContact?: string;
    status: ShipmentStatus;
    priority: number;
    description?: string;
    createdBy: string;
    createdAt: string;
    updatedAt: string;
}
/** 출하 지시 상세 */
export interface ShipmentOrderDetail {
    id: string;
    shipmentOrderId: string;
    seq: number;
    itemCode: string;
    itemName: string;
    orderQty: number;
    pickedQty: number;
    shippedQty: number;
    unit: string;
    lotNo?: string;
    status: 'PENDING' | 'PICKING' | 'PICKED' | 'SHIPPED';
}
/** 출하 로그 */
export interface ShipmentLog {
    id: string;
    shipmentNo: string;
    shipmentDate: string;
    shipmentOrderId?: string;
    shipmentOrderNo?: string;
    customerCode: string;
    customerName: string;
    customerOrderNo?: string;
    vehicleNo?: string;
    driverName?: string;
    driverContact?: string;
    totalBoxCount: number;
    totalPalletCount: number;
    totalQty: number;
    totalWeight?: number;
    weightUnit?: string;
    status: ShipmentStatus;
    departureTime?: string;
    arrivalTime?: string;
    deliveryConfirmedAt?: string;
    deliveryConfirmedBy?: string;
    deliveryNote?: string;
    shippedBy: string;
    shippedByName: string;
    description?: string;
    createdAt: string;
    updatedAt: string;
}
/** 출하 로그 상세 */
export interface ShipmentLogDetail {
    id: string;
    shipmentLogId: string;
    seq: number;
    itemCode: string;
    itemName: string;
    lotNo: string;
    boxNo?: string;
    palletNo?: string;
    qty: number;
    unit: string;
    serialNumbers?: string[];
}
/** 피킹 지시 */
export interface PickingOrder {
    id: string;
    pickingNo: string;
    pickingDate: string;
    shipmentOrderId: string;
    shipmentOrderNo: string;
    itemCode: string;
    itemName: string;
    lotNo?: string;
    requestQty: number;
    pickedQty: number;
    unit: string;
    fromWarehouseId: string;
    fromLocationId?: string;
    assignedTo?: string;
    assignedToName?: string;
    status: 'PENDING' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELED';
    startTime?: string;
    endTime?: string;
    description?: string;
    createdAt: string;
    updatedAt: string;
}
/** 반품 */
export interface ReturnOrder {
    id: string;
    returnNo: string;
    returnDate: string;
    customerCode: string;
    customerName: string;
    originalShipmentNo?: string;
    returnReason: string;
    returnType: 'DEFECT' | 'OVER_SHIPMENT' | 'WRONG_ITEM' | 'CUSTOMER_REQUEST' | 'OTHER';
    status: 'REQUESTED' | 'APPROVED' | 'RECEIVED' | 'INSPECTED' | 'COMPLETED' | 'REJECTED';
    approvedBy?: string;
    approvedAt?: string;
    receivedBy?: string;
    receivedAt?: string;
    description?: string;
    createdBy: string;
    createdAt: string;
    updatedAt: string;
}
/** 반품 상세 */
export interface ReturnOrderDetail {
    id: string;
    returnOrderId: string;
    seq: number;
    itemCode: string;
    itemName: string;
    lotNo?: string;
    boxNo?: string;
    returnQty: number;
    receivedQty?: number;
    unit: string;
    defectCode?: string;
    inspectionResult?: QualityJudgment;
    disposition?: 'RESTOCK' | 'REPAIR' | 'SCRAP' | 'RETURN_TO_CUSTOMER';
    description?: string;
}
/** 라벨 정보 */
export interface LabelInfo {
    labelType: 'BOX' | 'PALLET' | 'PRODUCT';
    barcode: string;
    qrCode: string;
    itemCode: string;
    itemName: string;
    lotNo: string;
    qty: number;
    unit: string;
    customerCode?: string;
    customerName?: string;
    customerItemCode?: string;
    productionDate: string;
    expiryDate?: string;
    plantCode: string;
    lineCode: string;
    serialNo?: string;
    additionalInfo?: Record<string, string>;
}
/** 출하 일일 현황 */
export interface DailyShipmentSummary {
    shipmentDate: string;
    customerCode?: string;
    customerName?: string;
    itemCode?: string;
    itemName?: string;
    planQty: number;
    shippedQty: number;
    achievementRate: number;
    boxCount: number;
    palletCount: number;
    returnQty: number;
}
/** 재고 가용성 체크 결과 */
export interface StockAvailabilityCheck {
    itemCode: string;
    itemName: string;
    requestQty: number;
    availableQty: number;
    reservedQty: number;
    shortageQty: number;
    isAvailable: boolean;
    availableLots?: {
        lotNo: string;
        warehouseCode: string;
        locationCode?: string;
        qty: number;
        expiryDate?: string;
    }[];
}
//# sourceMappingURL=shipping.d.ts.map
