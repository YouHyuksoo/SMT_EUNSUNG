/**
 * @file src/app/(authenticated)/production/planning-types.ts
 * @description 생산(M_PLANNING) 화면들이 공유하는 행 타입.
 *
 * 백엔드가 내리는 키 이름을 그대로 쓴다. 키 컬럼은 수정 폼에서 잠기므로
 * 어느 것이 키인지 주석으로 적어 둔다.
 */

/** 시간대 10칸. PB DataWindow 가 10칸 고정이다. */
export const TIME_SLOTS = 10;

/** 시간대 칸 번호 1..10 */
export const SLOT_INDEXES = Array.from({ length: TIME_SLOTS }, (_, i) => i + 1);

/**
 * 계획 한 줄 — 제품생산계획(MI)·반제품생산계획(SMD) 공용.
 * 키 = planDate + planSequence + 조직.
 *
 * 시간대 필드는 planTime1..10 / time1Desc..10 / actualTime1..10 으로 펼쳐져 있다.
 * 인덱스 접근을 위해 문자열 인덱스 시그니처를 함께 둔다 — 그리드가 칸 번호로 돈다.
 */
export interface PlanRow {
  planDate: string;
  planSequence: number;
  planPriority: number | null;
  lineCode: string;
  lineName: string | null;
  /** 롯트카드번호. '*' 면 아직 롯트카드가 붙지 않은 계획이다. */
  mfs: string | null;
  modelName: string;
  modelSuffix: string | null;
  masterModelName: string | null;
  parentItemCode: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemClass: string | null;
  workOrderNo: string | null;
  planQty: number | null;
  actualQty: number | null;
  /** 시간대 10칸의 합. PB 의 PLAN_QTY_CALC. */
  planTimeSum: number | null;
  planQtyD1: number | null;
  planQtyD2: number | null;
  planQtyD3: number | null;
  planCapaQty: number | null;
  mcTime: number | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  planStatus: string | null;
  planStatusName: string | null;
  planTransferYn: string | null;
  lotDivideYn: string | null;
  confirmYn: string | null;
  confirmBy: string | null;
  confirmDate: string | null;
  customerCode: string | null;
  comments: string | null;
  carrierSize: number | null;
  /** MI 전용 */
  workstageCode?: string | null;
  /** SMD 전용 */
  shiftCode?: string | null;
  productionType?: string | null;
  mfsGroupNo?: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
  /** planTime1..10 · time1Desc..10 · actualTime1..10 */
  [key: string]: unknown;
}

/** PB d_pln_product_sensor_actual_time_modify */
export interface SmdActualRow {
  receiptDate: string | null;
  /** 수정·삭제가 쓰는 불투명 키 (YYYYMMDDHH24MISS). ISO 로 왕복시키면 9시간 밀린다. */
  receiptDateKey: string;
  receiptSequence: number;
  lineCode: string | null;
  lineName: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  workstageCode: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  productActualQty: number | null;
  productActualSum: number | null;
  productActualLostQty: number | null;
  originCount: number | null;
  adjustQty: number | null;
  actualType: string | null;
  timeDivision: string | null;
  isLastYn: string | null;
  lastReceiptDate: string | null;
  carrierSize: number | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 라인·모델별 실적 합계 */
export interface SmdActualSummaryRow {
  lineCode: string | null;
  lineName: string | null;
  modelName: string | null;
  rowCount: number;
  productActualQty: number | null;
  adjustQty: number | null;
  productActualLostQty: number | null;
  firstDate: string | null;
  lastDate: string | null;
}

/** PB d_ip_product_run_card_4_kitting_lst */
export interface KittingRunCardRow {
  runNo: string;
  runDate: string | null;
  lotNo: string | null;
  itemCode: string | null;
  modelName: string | null;
  masterModelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  markingNo: string | null;
  lotSize: number | null;
  carrierSize: number | null;
  arrayType: string | null;
  runStatus: string | null;
  runStatusName: string | null;
  productRunType: string | null;
  productRunTypeName: string | null;
  kittingDate: string | null;
  mfsGroupNo: string | null;
  comments: string | null;
  pidCount: number;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_pln_product_2d_barcode_4_kitting */
export interface KittingPidRow {
  runNo: string;
  serialNo: string;
  /** PID 7~11번째 다섯 글자. PB 가 모델매칭 확인용으로 보여줬다. */
  modelCode: string | null;
  labelText: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  runDate: string | null;
  magazineNo: string | null;
  lotNo: string | null;
  lotQty: number | null;
  arrayType: string | null;
  carrierSize: number | null;
  barcodeStatus: string | null;
  barcodeStatusName: string | null;
  qcScanYn: string | null;
  qcScanDate: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** PB d_pln_product_pcb_result_lst — 기간 집계 */
export interface ResultPeriodRow {
  modelName: string | null;
  runNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  lotQty: number | null;
  resultQty: number | null;
  rowCount: number;
  firstDate: string | null;
  lastDate: string | null;
}

/** PB d_pln_product_pcb_run_result_lst — 작업지시별 공정 집계 */
export interface ResultRunRow {
  runNo: string;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  resultQty: number | null;
  rowCount: number;
  firstDate: string | null;
  lastDate: string | null;
}

/** PB d_pln_product_pcb_serial_lst — 그 공정을 지난 PID */
export interface ResultSerialRow {
  ioDate: string | null;
  serialNo: string | null;
  ioQty: number | null;
}

/** PB d_pln_product_pcb_result_report — 생산일보 (OEE) */
export interface DailyReportRow {
  lineCode: string | null;
  lineName: string | null;
  runDate: string | null;
  runNo: string | null;
  pcbItem: string | null;
  modelName: string | null;
  lotSize: number | null;
  carrierSize: number | null;
  solderType: string | null;
  solderTypeName: string | null;
  resultQty: number | null;
  badQty: number | null;
  badPpm: number | null;
  productStart: string | null;
  productEnd: string | null;
  /** 분 단위 */
  productTime: number | null;
  restTime: number | null;
  lossTime: number | null;
  availableTime: number | null;
  actualTime: number | null;
  /** 퍼센트 */
  timeWorkingRate: number | null;
  performanceWorkingRate: number | null;
  goodProductRate: number | null;
  overallEfficiency: number | null;
}
