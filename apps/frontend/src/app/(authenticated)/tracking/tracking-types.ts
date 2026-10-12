/**
 * @file src/app/(authenticated)/tracking/tracking-types.ts
 * @description 추적(M_TRACKING) 7화면이 공유하는 행 타입.
 *
 * 날짜는 두 벌로 온다 — 보여줄 문자열(`checkDateStart`)과 다음 조회에 그대로
 * 돌려줄 불투명 키(`checkDateStartKey`, YYYYMMDDHH24MISS). Oracle DATE 를 JSON 으로
 * 내보내면 UTC 로 바뀌는데 DB 는 KST 를 담고 있어 9시간이 틀어지기 때문이다.
 */

/** 313 위쪽 — 이 제조번호가 라인에 물려 있던 구간 */
export interface FeedingWindowRow {
  checkDateStart: string | null;
  checkDateStartKey: string | null;
  checkDateEnd: string | null;
  checkDateEndKey: string | null;
  lotName: string | null;
  partName: string | null;
  lineCode: string | null;
  lineName: string | null;
  lotNo: string;
  pcbItem: string | null;
  locationCode: string | null;
  checkType: string | null;
  checkTypeName: string | null;
  traceCode: string | null;
  vendorLotNo: string | null;
  vendorCode: string | null;
  ourBarcodeOrigin: string | null;
  supplierBarcodeOrigin: string | null;
  ccsEndDate: string | null;
}

/** 313 아래쪽 — 그 구간의 SPI 검사데이터 */
export interface LotSpiRow {
  workstageName: string;
  cstId: string | null;
  seqNo: string | null;
  pid: string | null;
  inspectRunNo: string | null;
  equipmentId: string | null;
  /** IQ_MACHINE_INSPECT_SPI.INSPECT_DATE 는 VARCHAR2 다 ('YYYY/MM/DD HH24:MI:SS') */
  inspectDate: string | null;
  result: string | null;
  defectCode: string | null;
  lineCode: string | null;
  lineName: string | null;
  runNo: string | null;
  magazineNo: string | null;
  boxNo: string | null;
  palleteNo: string | null;
  customerModelName: string | null;
  magazineDate: string | null;
  shiftCode: string | null;
  maskLotNo: string | null;
  squeezeLotNo: string | null;
  solderLotNo: string | null;
  longtermYn: string | null;
  qcScanDate: string | null;
  modelName: string | null;
  lotQty: number | null;
  runDate: string | null;
  workstageCode: string | null;
  isProgress: string | null;
  currentWorkstageCode: string | null;
}

/** 314 위쪽 — 이 PID 가 지나간 공정 시점 */
export interface StageTimelineRow {
  /** 'SPI' | 'AOI' | 'START' */
  workstageName: string;
  serialNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  equipmentId: string | null;
  cstId: string | null;
  seqNo: string | null;
  result: string | null;
  defectCode: string | null;
  fileName: string | null;
  runNo: string | null;
  modelName: string | null;
  smtModelName: string | null;
  itemCode: string | null;
  magazineNo: string | null;
  boxNo: string | null;
  palleteNo: string | null;
  carrierBarcode: string | null;
  qcScanYn: string | null;
  lotNo: string | null;
  lotQty: number | null;
  barcodeStatus: string | null;
  barcodeStatusName: string | null;
  runDate: string | null;
  inspectDate: string | null;
  /** 이 공정의 최종 검사시각. 아래쪽 자재 조회의 기준시각이 된다. */
  maxDatetime: string | null;
  maxDatetimeKey: string | null;
  /** 그 시각 직전에 라인이 꺼졌던 시각. 탐색 하한이 된다. */
  minDatetime: string | null;
  minDatetimeKey: string | null;
}

/** 314 아래쪽 — 그 시점에 라인에 세팅돼 있던 자재 */
export interface DynamicMaterialRow {
  /** 'MIN' 기준시각 이전의 최신 투입 | 'APPEND' 기준시각 이후 N분 내 추가 투입 */
  branch: 'MIN' | 'APPEND';
  lotName: string | null;
  lineCode: string | null;
  lineName: string | null;
  machine: string | null;
  partName: string | null;
  scanPartName: string | null;
  chipName: string | null;
  itemName: string | null;
  itemSpec: string | null;
  checkDate: string | null;
  tableId: string | null;
  locationCode: string | null;
  checkSequence: number | null;
  checkStatus: string | null;
  checkStatusName: string | null;
  checkMsg: string | null;
  checkType: string | null;
  checkTypeName: string | null;
  ngReason: string | null;
  fullCheckSequence: number | null;
  pcbItem: string | null;
  oldBarcode: string | null;
  itemCode: string | null;
  ccsEndDate: string | null;
  lotNo: string | null;
  validDate: string | null;
  lotSerial: string | null;
  traceCode: string | null;
  supplierBarcodeOrigin: string | null;
  vendorLotNo: string | null;
  smtModelName: string | null;
}

/** 315 — 제조번호 하나의 전 이력 */
export interface MaterialUsageRow {
  /** 'SMT' 투입 | 'ISSUE' 출고 | 'RECEIPT' 입고 */
  sourceKind: 'SMT' | 'ISSUE' | 'RECEIPT';
  procCode: string | null;
  procName: string | null;
  procDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemClass: string | null;
  lotNo: string | null;
  qty: number | null;
  locationCode: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  runNo: string | null;
  smtModelName: string | null;
  pcbItem: string | null;
  mounterAddress: string | null;
  supplierBarcodeOrigin: string | null;
  oldBarcode: string | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  mslPassedTimeAtEvent: number | null;
  mslPassedTime: number | null;
  mslSavedTime: number | null;
  pcbCoatingType: string | null;
  pcbCoatingMaxDay: number | null;
  pcbCoatingDate: string | null;
  scanDate: string | null;
  scanQty: number | null;
  manufactureWeek: string | null;
  reelDestroyDate: string | null;
  bakingStartDate: string | null;
  bakingEndDate: string | null;
  feedingDate: string | null;
  lifeCycle: number | null;
}

/** 318·319 위쪽 — 롯트카드 */
export interface RunCardRow {
  runNo: string;
  runDate: string | null;
  lotNo: string | null;
  itemCode: string | null;
  itemName: string | null;
  modelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  markingNo: string | null;
  lotSize: number | null;
  pcbItem: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 공정 매트릭스 컬럼 정의. 서버가 준다 (DB 함수 목록이 한 곳에만 있어야 한다). */
export interface StageColumnDef {
  key: string;
  label: string;
  dbFunction: string;
}

/**
 * 317·318 공정 매트릭스 한 줄.
 *
 * 공정별 값은 **건수**다. F_GET_PID_* 는 전부 COUNT(*) 를 돌려준다 — 0 이면
 * 그 공정 데이터가 없다는 뜻이다. 키가 서버 정의(StageColumnDef.key)에 따라
 * 달라지므로 인덱스 접근으로 둔다.
 */
export interface StageCountRow {
  serialNo: string;
  runNo: string | null;
  modelName: string | null;
  lineCode: string | null;
  runDate: string | null;
  [stageKey: string]: string | number | null;
}

/** 317 PID 머리글 */
export interface PidHeaderRow {
  serialNo: string;
  runNo: string | null;
  modelName: string | null;
  customerModelName: string | null;
  itemCode: string | null;
  itemName: string | null;
  lineCode: string | null;
  lineName: string | null;
  runDate: string | null;
  lotNo: string | null;
  lotQty: number | null;
  magazineNo: string | null;
  boxNo: string | null;
  palleteNo: string | null;
  barcodeStatus: string | null;
  barcodeStatusName: string | null;
  workstageCode: string | null;
  currentWorkstageCode: string | null;
  shippingDate: string | null;
  repairYn: string | null;
}

/** 319 가운데 — PID 별 전 공정 시각 */
export interface LotDetailRow {
  serialNo: string;
  runNo: string | null;
  runDate: string | null;
  lineCode: string | null;
  lineName: string | null;
  magazineNo: string | null;
  boxNo: string | null;
  palleteNo: string | null;
  modelName: string | null;
  lotQty: number | null;
  shippingDate: string | null;
  boxScanDate: string | null;
  markingEquipmentId: string | null;
  markingDate: string | null;
  aoiEquipmentId: string | null;
  aoiInspectDate: string | null;
  aoiResult: string | null;
  aoiDefectCode: string | null;
  spiEquipmentId: string | null;
  spiInspectDate: string | null;
  spiResult: string | null;
  spiDefectCode: string | null;
  maskInputDate: string | null;
  maskJigLotNo: string | null;
  maskHitValue: number | null;
  squeezeInputDate: string | null;
  squeezeJigLotNo: string | null;
  squeezeHitValue: number | null;
  solderLotNo: string | null;
  markingToShippingTime: string | null;
  repairYn: string | null;
  firstMarkingDate: string | null;
  lastMarkingDate: string | null;
  minSpiInspectDate: string | null;
  maxSpiInspectDate: string | null;
  minAoiInspectDate: string | null;
  maxAoiInspectDate: string | null;
  spiToAoiTime: string | null;
  markingToAoiTime: string | null;
  sampleInputDate: string | null;
  ccsStartDate: string | null;
  ccsEndDate: string | null;
}

/** 317·319 아래쪽 — 이 PID 가 속한 롯트에 투입된 자재 */
export interface PidMaterialRow {
  lineCode: string | null;
  lineName: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  checkType: string | null;
  checkTypeName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  scanPartName: string | null;
  scanSupplierPartName: string | null;
  scanQty: number | null;
  lotNo: string | null;
  feedingDate: string | null;
  reelDestroyDate: string | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  mslPassedTime: number | null;
}

/** 321 라인 요약. 뷰가 컬럼마다 이름값을 들고 있어 코드 변환이 없다. */
export interface LineStatusRow {
  lineCode: string;
  lineName: string | null;
  organizationName: string | null;
  actualDate: string | null;
  workShiftCode: string | null;
  lineStatus: string | null;
  lineStatusName: string | null;
  lineStatusCode: string | null;
  lineStatusCodeName: string | null;
  nsnpLockType: string | null;
  nsnpLockTypeName: string | null;
  nsnpReason: string | null;
  nsnpStartDate: string | null;
  nsnpStatus: string | null;
  nsnpStatusName: string | null;
  runningRunNo: string | null;
  runningModelName: string | null;
  runningRunDate: string | null;
  runNoChangedBy: string | null;
  planQty: number | null;
  inputQty: number | null;
  actualQty: number | null;
  ngQty: number | null;
  pcbInputQty: number | null;
  itemCode: string | null;
  modelName: string | null;
  customerModelName: string | null;
  customerName: string | null;
  productClass: string | null;
  runStatus: string | null;
  runStatusName: string | null;
  productRunType: string | null;
  productRunTypeName: string | null;
  carrierSize: number | null;
  pcbItem: string | null;
  solderType: string | null;
  solderLotNo: string | null;
  solderCheckDate: string | null;
  solderCheck: string | null;
  solderCheckVal: string | null;
  solderCheckHour: string | null;
  solderRemainTime: string | null;
  maskLotNo: string | null;
  maskLotNo2: string | null;
  maskCheck: string | null;
  maskCheckDate: string | null;
  maskBreakValue: number | null;
  maskHitValue: number | null;
  maskBreakValue2: number | null;
  maskHitValue2: number | null;
  squeezeLotNo: string | null;
  squeezeLotNo2: string | null;
  squeezeCheck: string | null;
  squeezeCheckDate: string | null;
  squeezeBreakValue: number | null;
  squeezeHitValue: number | null;
  squeezeBreakValue2: number | null;
  squeezeHitValue2: number | null;
  ccsCheck: string | null;
  ccsCheckDate: string | null;
  fullCheck: string | null;
  fullCheckDate: string | null;
  xrayCheck: string | null;
  xrayCheckDate: string | null;
  specCheck: string | null;
  specCheckDate: string | null;
  sampleCheck: string | null;
  sampleCheckDate: string | null;
  nozzleCheck: string | null;
  nozzleCheckDate: string | null;
  backupBlockCheck: string | null;
  backupBlockCheckDate: string | null;
  qcComments: string | null;
  aoiPassRate: number | null;
  spiPassRate: number | null;
  spiCount: number | null;
  aoiCount: number | null;
  sensorCount: number | null;
  modelSt: number | null;
  firstSpiDate: string | null;
  firstAoiDate: string | null;
  firstMarkingDate: string | null;
  lastMarkingDate: string | null;
  mesDisplayGroup: string | null;
  mesDisplayYn: string | null;
  mesDisplaySequence: number | null;
  /** 모델 표준택트로 계산한 목표수량. 뷰 컬럼이 아니라 PB DataWindow 의 파생값이다. */
  targetQty: number | null;
  /** 실제 택트(초/개) */
  realSt: number | null;
  /** 이 행을 읽은 시각. 자동갱신이 실제로 돌고 있는지 화면에서 보인다. */
  readAt: string | null;
}

/** 321 픽업률 */
export interface PickupRateRow {
  lineCode: string;
  lineName: string | null;
  totalCount: number | null;
  missCount: number | null;
  rejectCount: number | null;
  goodRate: number | null;
  ppm: number | null;
  /** 'W' 면 라인 양품률 99.60% 이하 */
  lineWarningSign: string | null;
  /** 투입 500개 이상 + 불량률 1% 이상인 노즐 위치 목록 */
  ngPosition: string | null;
  itemWarningSign: string | null;
}

/** 321 상세 탭 — 표시에 쓰는 컬럼만 좁게 잡는다 (탭마다 원본 컬럼이 20~40개다) */
export interface SolderTabRow {
  itemBarcode: string | null;
  solderLotNo: string | null;
  itemCode: string | null;
  solderType: string | null;
  modelName: string | null;
  lineCode: string | null;
  runNo: string | null;
  receiptDate: string | null;
  issueDate: string | null;
  openDate: string | null;
  inputDate: string | null;
  firstLineInputDate: string | null;
  destroyDate: string | null;
  returnDate: string | null;
  validDate: string | null;
  validCount: number | null;
  unfreezingStartDate: string | null;
  unfreezingEndDate: string | null;
  unfreezingWaitTime: string | null;
  mixStartDate: string | null;
  mixEndDate: string | null;
  mixWaitTime: string | null;
  viscosityStartDate: string | null;
  viscosityEndDate: string | null;
  viscosity: number | null;
  viscosityOperator: string | null;
  rpm: number | null;
  mixTime: number | null;
  temp: number | null;
  afterViscosityTime: string | null;
  afterIssueTime: string | null;
  afterFirstLineInputTime: string | null;
}

export interface JigCheckTabRow {
  jigCode: string | null;
  jigLotNo: string | null;
  checkSequence: number | null;
  checkDate: string | null;
  checkStatus: string | null;
  lineCode: string | null;
  cleanYn: string | null;
  confirmYn: string | null;
  confirmDate: string | null;
  comments: string | null;
  breakValue: number | null;
  hitValue: number | null;
  enterBy: string | null;
  enterDate: string | null;
  /** 마스크 전용 */
  usedQty?: number | null;
  actualValue?: number | null;
  usedBy?: string | null;
  tension1?: number | null;
  tension2?: number | null;
  tension3?: number | null;
  tension4?: number | null;
  tension5?: number | null;
  maxTension?: number | null;
  returnBy?: string | null;
  /** 스퀴지 전용 */
  pinHoleYn?: string | null;
}

export interface MslTabRow {
  lineCode: string | null;
  lineName: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  ccsYn: string | null;
  modelName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  partNo: string | null;
  itemBarcode: string | null;
  lotNo: string | null;
  scanQty: number | null;
  newScanQty: number | null;
  issueCompareYn: string | null;
  issueCompareDate: string | null;
  changeDate: string | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  mslPassedHour: number | null;
  mslRemainHour: number | null;
  mslPrePassedTime: number | null;
  passedRate: number | null;
  bakingStartDate: string | null;
  bakingEndDate: string | null;
  checkCount: number | null;
  checkMinTime: string | null;
  checkMaxTime: string | null;
  bakingCount: number | null;
}

export interface PcbInputTabRow {
  runNo: string | null;
  modelName: string | null;
  lineCode: string | null;
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
  receiptStatus: string | null;
  supplierBarcode: string | null;
  itemBarcode: string | null;
  manufactureWeek: string | null;
  pcbCoatingType: string | null;
  pcbCoatingMaxDay: number | null;
  pcbCoatingDate: string | null;
}

export interface SampleTabRow {
  inputDate: string | null;
  lineCode: string | null;
  lineName: string | null;
  sampleType: string | null;
  sampleCode: string | null;
  sampleLotNo: string | null;
  sampleSpec: string | null;
  sampleApplyDate: string | null;
  currentApplyDate: string | null;
  runNo: string | null;
  itemCode: string | null;
  modelName: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export interface ReelChangeTabRow {
  ccsOkCount: number | null;
  checkDate: string | null;
  checkSequence: number | null;
  fullCheckSequence: number | null;
  planDate: string | null;
  planDateSequence: number | null;
  lotName: string | null;
  lineCode: string | null;
  machine: string | null;
  feederShaft: string | null;
  tableId: string | null;
  locationCode: string | null;
  pcbItem: string | null;
  partName: string | null;
  chipName: string | null;
  scanPartName: string | null;
  scanSupplierPartName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  mslLevel: string | null;
  mslMaxTime: number | null;
  checkType: string | null;
  checkTypeName: string | null;
  checkStatus: string | null;
  checkStatusName: string | null;
  checkMsg: string | null;
  checkBy: string | null;
  ngReason: string | null;
  ngType: string | null;
  comments: string | null;
  smtModelName: string | null;
  lotNo: string | null;
  oldBarcode: string | null;
  supplierBarcodeOrigin: string | null;
  ourBarcodeOrigin: string | null;
  validDate: string | null;
  lotSerial: string | null;
  ccsEndDate: string | null;
  unlockBy: string | null;
  unlockDate: string | null;
  scanQty: number | null;
  supplierCode: string | null;
  barcodeStatus: string | null;
  receiptCompareDate: string | null;
  issueCompareDate: string | null;
  lotDivideYn: string | null;
  lotDivideDate: string | null;
}

export interface InterlockTabRow {
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

/** 321 상세 8개 탭 묶음 */
export interface DashboardDetail {
  solder: SolderTabRow[];
  mask: JigCheckTabRow[];
  squeeze: JigCheckTabRow[];
  msl: MslTabRow[];
  pcb: PcbInputTabRow[];
  sample: SampleTabRow[];
  reel: ReelChangeTabRow[];
  interlock: InterlockTabRow[];
}
