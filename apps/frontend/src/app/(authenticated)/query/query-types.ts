/**
 * @file src/app/(authenticated)/query/query-types.ts
 * @description 조회(M_QUERY) 9화면이 공유하는 행 타입.
 *
 * 이 대분류는 이름과 달리 절반이 쓰기 화면이다 — 각 타입에 무엇을 고칠 수 있는지
 * 적어 둔다. 고칠 수 없는 컬럼을 그리드에서 열어 두면 조회 화면이 조용히 원장을
 * 바꾼다.
 *
 * 시각은 서버가 'YYYY-MM-DD HH24:MI:SS' 문자열로 만들어 보낸다 (KST 보존).
 * 다시 조회에 넘겨야 하는 값은 `...Key`(YYYYMMDDHH24MISS) 로 함께 온다.
 */

/** 323 PID 정보조회 한 줄 */
export interface PidInfoRow {
  serialNo: string;
  runNo: string | null;
  labelText: string | null;
  lineCode: string | null;
  lineName: string | null;
  modelName: string | null;
  customerModelName: string | null;
  mappingModelName: string | null;
  mappingLabel: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemClass: string | null;
  customerCode: string | null;
  machineCode: string | null;
  bcrCode: string | null;
  magazineNo: string | null;
  boxNo: string | null;
  palleteNo: string | null;
  carrierBarcode: string | null;
  carrierSize: number | null;
  arrayType: string | null;
  lotNo: string | null;
  lotQty: number | null;
  workstageCode: string | null;
  workOrderNo: string | null;
  ecNo: string | null;
  partNo: string | null;
  barcodeStatus: string | null;
  barcodeStatusName: string | null;
  qcScanYn: string | null;
  longtermYn: string | null;
  comments: string | null;
  runDate: string | null;
  qcScanDate: string | null;
  actualDate: string | null;
  receiptDate: string | null;
  shippingDate: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
  /** X-OUT 불량 건수. 1 이상이면 'X-OUT 해제' 를 누를 수 있다. */
  xOutCount: number;
}

/** 324 마킹 상세 */
export interface MarkingDetailRow {
  lotId: string | null;
  cstId: string | null;
  seq: number | null;
  pid: string | null;
  equipmentId: string | null;
  /** IQ_MACHINE_INSPECT_DATA_MK.DATESET 은 VARCHAR2 다 ('YYYY/MM/DD HH24:MI:SS') */
  markingDate: string | null;
  resultCode: string | null;
  runNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  machineCode: string | null;
  fileName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 324 마킹 요약 — 롯트·설비·판정별 집계 */
export interface MarkingSummaryRow {
  lotId: string | null;
  pidQty: number;
  modelName: string | null;
  seq: number | null;
  minPid: string | null;
  maxPid: string | null;
  equipmentId: string | null;
  markingDate: string | null;
  resultCode: string | null;
  runNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  machineCode: string | null;
  enterDate: string | null;
}

/** 325 PCB 투입 스캔 */
export interface PcbInputRow {
  runNo: string | null;
  modelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  machineCode: string | null;
  workstageCode: string | null;
  scanDate: string | null;
  scanBy: string | null;
  pcbBarcode: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotQty: number | null;
  supplierCode: string | null;
  supplierName: string | null;
  receiptStatus: string | null;
  supplierBarcode: string | null;
  itemBarcode: string | null;
  manufactureWeek: string | null;
  pcbCoatingType: string | null;
  pcbCoatingMaxDay: number | null;
  pcbCoatingDate: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/**
 * 327 스캔 상세.
 * **고칠 수 있는 것은 ngReason · comments 둘뿐이다** (PB DataWindow update=yes 실측).
 */
export interface ScanDetailRow {
  checkDate: string | null;
  /** 저장할 때 키로 그대로 돌려준다 */
  checkDateKey: string | null;
  checkSequence: number | null;
  fullCheckSequence: number | null;
  planDate: string | null;
  planDateSequence: number | null;
  lotName: string | null;
  lineCode: string | null;
  lineName: string | null;
  machine: string | null;
  tableId: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  partName: string | null;
  chipName: string | null;
  scanPartName: string | null;
  scanSupplierPartName: string | null;
  oldBarcode: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  mslLevel: string | null;
  checkType: string | null;
  checkTypeName: string | null;
  checkStatus: string | null;
  checkStatusName: string | null;
  checkMsg: string | null;
  checkBy: string | null;
  /** 수정 가능 */
  ngReason: string | null;
  ngType: string | null;
  /** 수정 가능 */
  comments: string | null;
  lotNo: string | null;
  lotSerial: string | null;
  smtModelName: string | null;
  runNo: string | null;
  feederShaft: string | null;
  validDate: string | null;
  ccsEndDate: string | null;
  unlockBy: string | null;
  unlockDate: string | null;
  scanQty: number | null;
  supplierCode: string | null;
  barcodeStatus: string | null;
  vendorLotNo: string | null;
  lotDivideYn: string | null;
  receiptCompareDate: string | null;
  issueCompareDate: string | null;
}

/** 327 풀체크 회차 그룹 */
export interface ScanGroupRow {
  checkDate: string | null;
  checkSequence: number | null;
  fullCheckSequence: number | null;
  lotName: string | null;
  lineCode: string | null;
  lineName: string | null;
  machine: string | null;
  tableId: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  partName: string | null;
  chipName: string | null;
  scanPartName: string | null;
  scanSupplierPartName: string | null;
  checkType: string | null;
  checkTypeName: string | null;
  checkStatus: string | null;
  checkStatusName: string | null;
  checkMsg: string | null;
  checkBy: string | null;
  ngReason: string | null;
  unlockBy: string | null;
  unlockDate: string | null;
  ccsCheckTime: string | null;
  fullCheckStartTime: string | null;
  fullCheckEndTime: string | null;
}

/** 327 바코드로 찾기 */
export interface BarcodeMatchRow {
  checkDate: string | null;
  lineCode: string | null;
  lineName: string | null;
  lotName: string | null;
  machine: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  partName: string | null;
  scanPartName: string | null;
  scanSupplierPartName: string | null;
  oldBarcode: string | null;
  checkType: string | null;
  checkTypeName: string | null;
  checkStatus: string | null;
  checkStatusName: string | null;
  lotNo: string | null;
  runNo: string | null;
  ngReason: string | null;
  comments: string | null;
  /** '자사' | '공급처' | '이전' — 어느 컬럼에서 걸렸는지 */
  matchedOn: string;
}

/** 327 출고 이력 */
export interface IssueHistoryRow {
  issueDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  lotNo: string | null;
  issueQty: number | null;
  issueDeficit: string | null;
  issueDeficitName: string | null;
  locationCode: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  enterBy: string | null;
}

/**
 * 328 계획데이터.
 * **고칠 수 있는 것은 checkYn · checkStatus · ccsYn 셋뿐이다** (실측).
 * 키가 7컬럼이라 저장할 때 machine·tableId·pcbItem 까지 함께 보낸다.
 */
export interface PlanDataRow {
  modelName: string;
  modelSuffix: string | null;
  lineCode: string;
  lineName: string | null;
  machine: string;
  tableId: string;
  locationCode: string;
  pcbItem: string;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  modelItemName: string | null;
  /** 수정 가능 */
  checkYn: string | null;
  /** 수정 가능 */
  checkStatus: string | null;
  /** 수정 가능 */
  ccsYn: string | null;
  activeYn: string | null;
  revision: string | null;
  replaceYn: string | null;
  feedingQty: number | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 328 워크플로 (피더 배치 이미지) */
export interface WorkflowRow {
  modelName: string | null;
  lineCode: string | null;
  machine: string | null;
  tableId: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  itemCode: string | null;
  checkYn: string | null;
  ccsYn: string | null;
  imageName: string | null;
  imagePath: string | null;
}

/** 329 피더 자리 */
export interface FeederSlotRow {
  lineCode: string;
  lineName: string | null;
  modelName: string;
  modelSuffix: string | null;
  machine: string;
  tableId: string;
  locationCode: string;
  pcbItem: string | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  mslLevel: string | null;
  checkYn: string | null;
  ccsYn: string | null;
  checkStatus: string | null;
  replaceYn: string | null;
  revision: string | null;
  feedingQty: number | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
  /** 지금 그 자리에 물려 있는 제조번호 */
  currentLotNo: string | null;
  lastFeedingDate: string | null;
}

/** 329 피더 자리의 투입 이력 */
export interface SlotHistoryRow {
  checkDate: string | null;
  checkType: string | null;
  checkTypeName: string | null;
  checkStatus: string | null;
  checkStatusName: string | null;
  lotNo: string | null;
  scanPartName: string | null;
  scanSupplierPartName: string | null;
  checkBy: string | null;
  checkMsg: string | null;
  ngReason: string | null;
  scanQty: number | null;
}

/**
 * 330 센서 실적 (현재·이력 공용).
 * **고칠 수 있는 것은 productActualQty · adjustQty 둘뿐이다** (실측).
 * 키는 receiptDateKey + receiptSequence 다.
 */
export interface SensorActualRow {
  lineCode: string;
  lineName: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  workstageCode: string | null;
  pcbItem: string | null;
  runNo: string | null;
  machineCode: string | null;
  actualType: string | null;
  /** 수정 가능 */
  productActualQty: number | null;
  productActualSum: number | null;
  productActualLostQty: number | null;
  /** 수정 가능 */
  adjustQty: number | null;
  originCount: number | null;
  workTime: number | null;
  workerName: string | null;
  workerCount: number | null;
  isLastYn: string | null;
  receiptSequence: number;
  receiptDate: string | null;
  /** 보정할 때 키로 그대로 돌려준다 */
  receiptDateKey: string;
  lastReceiptDate: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 330 시간/시간대 단위 실적 */
export interface SensorBucketRow {
  lineCode: string;
  lineName: string | null;
  modelName: string | null;
  productActualQty: number | null;
  receiptDate: string | null;
  receiptDateKey: string;
  enterBy: string | null;
  enterDate: string | null;
}

/** 333 자재 바코드 상태 */
export interface MaterialBarcodeRow {
  itemBarcode: string;
  originItemBarcode: string | null;
  supplierBarcode: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  supplierItemCode: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  fromSupplierCode: string | null;
  originSupplierCode: string | null;
  lotNo: string | null;
  supplierLotNo: string | null;
  vendorLotNo: string | null;
  scanQty: number | null;
  scanDate: string | null;
  barcodeStatus: string | null;
  barcodeStatusName: string | null;
  labelType: string | null;
  receiptType: string | null;
  issueType: string | null;
  issueDivision: string | null;
  receiptSlipNo: string | null;
  receiptCompareYn: string | null;
  receiptCompareDate: string | null;
  receiptCompareBy: string | null;
  issueCompareYn: string | null;
  issueCompareDate: string | null;
  issueCompareBy: string | null;
  issueReturnYn: string | null;
  returnYn: string | null;
  holdingYn: string | null;
  feedingYn: string | null;
  feedingModel: string | null;
  lotDivideYn: string | null;
  reelDivideCompareYn: string | null;
  reelDestroyYn: string | null;
  reelDestroyDate: string | null;
  checkStatus: string | null;
  locationCode: string | null;
  manufactureWeek: string | null;
  manufactureDate: string | null;
  validDate: string | null;
  mslOpenDate: string | null;
  mslPassedTime: number | null;
  mslRemainTime: number | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 335 라인 상태 (NSNP 제어 대상) */
export interface NsnpLineRow {
  lineCode: string;
  lineName: string | null;
  lineStatus: string | null;
  lineStatusName: string | null;
  nsnpStatus: string | null;
  nsnpStartDate: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  fullCheckDate: string | null;
  ccsDate: string | null;
  reflowCheckDate: string | null;
  pcbScanDate: string | null;
  /** 'U' 사용 · 'S' 미사용 (IMCN_MACHINE.USE_STATUS, MACHINE_TYPE='NSNP') */
  useStatus: string | null;
  ipAddress: string | null;
  /** 이력 초기화가 지울 건수. 확인 모달에 그대로 넣는다. */
  historyRows: number;
}

/** 335 NSNP 이력 (두 원장 합침) */
export interface NsnpHistoryRow {
  /** 'NSNP' 오삽 감지·잠금 · 'LINE_ONOFF' 라인 ON/OFF */
  sourceKind: 'NSNP' | 'LINE_ONOFF';
  lineCode: string | null;
  lineName: string | null;
  machineCode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  actionCode: string | null;
  nsnpReason: string | null;
  nsnpErrorMessage: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** NSNP 제어 결과 — 전후 상태를 함께 받는다 */
export interface NsnpControlResult {
  action: 'lock' | 'unlock' | 'use' | 'noUse';
  lineCode: string;
  userLevel: number;
  before: Partial<NsnpLineRow> | null;
  after: Partial<NsnpLineRow> | null;
}
