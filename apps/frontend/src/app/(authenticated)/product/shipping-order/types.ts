/** 제품납품계획(출하지시) 한 줄 — GET /product/shipping-orders */
export interface ShippingOrderRow {
  shipOrderNo: string;
  planDate: string;
  planSequence: number;
  customerCode: string | null;
  customerName: string | null;
  modelName: string;
  modelSuffix: string | null;
  itemCode: string | null;
  planQty: number;
  actualQty: number;
  remainQty: number;
  /** W 대기 / P 진행 / C 완료 (공통코드 PLAN STATUS) */
  planStatus: string;
  comments: string | null;
}
