/**
 * @file src/app/(authenticated)/report/report-types.ts
 * @description 리포트(M_REPORT) A그룹 행 타입 — 기준정보·바코드·설비·제품·공정.
 *
 * 리포트는 대부분 조회 전용이다. 341 캐리어바코드만 쓰기다 (바코드 발행).
 * 시각은 서버가 'YYYY-MM-DD HH24:MI:SS' 문자열로 만들어 보낸다 (KST 보존).
 */

/** 338 품목마스터 한 줄 */
export interface ItemMasterRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  itemType: string | null;
  itemTypeName: string | null;
  itemClass: string | null;
  itemClassName: string | null;
  itemDivision: string | null;
  /** 라인이 아니라 **구매유형**이다 (F 무상구매 · G 국내구매 · T 자작 · Y 유상사급) */
  lineType: string | null;
  lineTypeName: string | null;
  setItemYn: string | null;
  barcode: string | null;
  partNo: string | null;
  drawingNo: string | null;
  /**
   * 유효기간 상태. **ID_ITEM 에 STATUS 컬럼은 없다** — 적용시작·종료일로 계산한다.
   * 'RUNNING' 적용중 · 'FUTURE' 적용전 · 'EXPIRED' 만료.
   */
  status: 'RUNNING' | 'FUTURE' | 'EXPIRED' | null;
  abcGrade: string | null;
  specialProperty: string | null;
  width: number | null;
  height: number | null;
  weight: number | null;
  innerDiameter: number | null;
  outerDiameter: number | null;
  dateSet: string | null;
  dateEnd: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 340 라인설비바코드 한 줄 */
export interface LineBarcodeRow {
  lineCode: string;
  lineName: string | null;
  machine: string;
  machineName: string | null;
  machineType: string | null;
  machineModelName: string | null;
  useStatus: string | null;
  /** 라벨에 찍는 값. 라벨 지오메트리는 이관 대상이 아니라 CSV 로 내보낸다. */
  barcodeText: string;
}

/** 341 캐리어바코드 한 줄 */
export interface CarrierBarcodeRow {
  serialNo: string;
  labelText: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 341 발행 결과 — 새로 넣은 것과 이미 있던 것을 나눠 받는다 */
export interface CarrierBarcodeCreateResult {
  requested: number;
  created: number;
  alreadyExisted: number;
  firstSerial: string;
  lastSerial: string;
}

/** 343 설비 한 줄 */
export interface MachineRow {
  machineCode: string;
  machineName: string | null;
  machineType: string | null;
  machineTypeName: string | null;
  machineModelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  capacity: number | null;
  reservedCapacity: number | null;
  useStatus: string | null;
  customerCode: string | null;
  customerName: string | null;
  nationCode: string | null;
  acquisitionType: string | null;
  acquisitionDate: string | null;
  manualLocationComment: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 343 설비 일일가동 한 줄. 가동 기록이 없는 설비도 남는다 (외부조인). */
export interface MachineOperationRow {
  machineCode: string;
  machineName: string | null;
  machineType: string | null;
  lineCode: string | null;
  lineName: string | null;
  planDate: string | null;
  startTime: string | null;
  endTime: string | null;
  totalOperationTime: number | null;
  machineStatusCode: string | null;
}

/** 344 픽업 상세 한 줄 */
export interface PickupDetailRow {
  lineCode: string | null;
  machineCode: string | null;
  programName: string | null;
  tableNo: string | null;
  address: string | null;
  subAddress: string | null;
  feederZaxis: string | null;
  feederLraxis: string | null;
  itemCode: string | null;
  itemName: string | null;
  abcGrade: string | null;
  purUnitPrice: number | null;
  actualDate: string | null;
  takeupQty: number | null;
  missQty: number | null;
  recogQty: number | null;
  /** (미스 + 인식오류) × 구매단가. 이 화면의 핵심 숫자다. */
  missAmount: number | null;
  createBy: string | null;
  createdDate: string | null;
}

/** 344 픽업 금액 집계 한 줄 */
export interface PickupAmountRow {
  lineCode: string | null;
  lineName: string | null;
  actualDate: string | null;
  takeupQty: number | null;
  missQty: number | null;
  recogQty: number | null;
  missAmount: number | null;
  ppm: number | null;
}

/**
 * 346 생산계획 한 줄. `slot01`~`slot10` 이 시간대 10칸이다
 * (생산 대분류의 MI/SMD 계획과 같은 고정 슬롯 구조 — 크로스탭이 아니다).
 */
export interface MasterPlanRow {
  modelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  mfs: string | null;
  pcbItem: string | null;
  customerCode: string | null;
  customerName: string | null;
  planDate: string | null;
  slot01: number | null;
  slot02: number | null;
  slot03: number | null;
  slot04: number | null;
  slot05: number | null;
  slot06: number | null;
  slot07: number | null;
  slot08: number | null;
  slot09: number | null;
  slot10: number | null;
  planQty: number | null;
}

/** 347 런카드 상세 한 줄 */
export interface RunCardReportRow {
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
  runStatus: string | null;
  runStatusName: string | null;
  productRunType: string | null;
  productRunTypeName: string | null;
  kittingDate: string | null;
}

/**
 * 347 런카드 합계 한 줄.
 *
 * `labelQty`·`inputQty`·`outputQty` 는 **수량 포함을 켰을 때만 채워진다.**
 * 그 셋은 런카드마다 1억행 넘는 표를 한 번씩 세므로 (25일치 523건 = 47초 실측)
 * 기본은 꺼져 있고 null 이다.
 */
export interface RunCardSummaryRow {
  runDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  modelName: string | null;
  markingNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  productRunType: string | null;
  productRunTypeName: string | null;
  runCardCount: number | null;
  lotSize: number | null;
  labelQty: number | null;
  inputQty: number | null;
  outputQty: number | null;
}

/**
 * 348 출하 상세 한 줄.
 *
 * `qty` 에는 **부호가 붙어 있다** — 출고는 +, 출고취소는 − (PB 와 같은 규칙).
 * `rawQty` 는 부호 없는 원값이다. 단가는 컬럼이 아니라 DB 함수가 계산한다.
 */
export interface FgIssueDetailRow {
  issueDate: string | null;
  issueSequence: number | null;
  barcode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  /** 부호 적용 수량 (출고 + / 출고취소 −) */
  qty: number | null;
  /** 부호 없는 원값 */
  rawQty: number | null;
  issuePrice: number | null;
  packType: string | null;
  txnDeficit: string | null;
  customerCode: string | null;
  customerName: string | null;
  locationCode: string | null;
  lineCode: string | null;
  workstageCode: string | null;
  mfs: string | null;
  palletNo: string | null;
  palletDate: string | null;
  shipNo: string | null;
  actualDate: string | null;
  shiftCode: string | null;
  workTimeZone: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

/** 348 출하 합계 한 줄 */
export interface FgIssueSummaryRow {
  modelName: string | null;
  modelSuffix: string | null;
  customerCode: string | null;
  customerName: string | null;
  locationCode: string | null;
  issueCount: number | null;
  qty: number | null;
  issuePrice: number | null;
}

/**
 * 348 크로스탭 원자료 한 줄.
 * 열 집합(일자)이 데이터에 따라 달라지므로 서버가 목록을 주고 **피벗은 화면에서 한다.**
 */
export interface FgIssueCrosstabRow {
  issueDate: string;
  modelName: string | null;
  modelSuffix: string | null;
  customerCode: string | null;
  locationCode: string | null;
  qty: number | null;
}

/** 350 공정재공 한 줄. 이 표는 현재 0행이다. */
export interface WorkstageStockRow {
  modelName: string | null;
  modelSuffix: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  inventoryQty: number | null;
}

/** 352 공정매거진 한 줄. 갈래에 따라 채워지는 칸이 다르다. */
export interface MagazineStockRow {
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  pcbItem: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  /** 재공 갈래에만 있다 */
  inventoryQty?: number | null;
  /** 불량·폐기 갈래에만 있다 — 'IN' 입고 · 'OUT' 출고 */
  receiptDeficit?: string | null;
  workstageInvQty?: number | null;
  modelInvQty?: number | null;
}
