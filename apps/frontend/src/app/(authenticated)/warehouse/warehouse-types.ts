/**
 * @file src/app/(authenticated)/warehouse/warehouse-types.ts
 * @description 자재창고(M_WAREHOUSE) 행 타입 — 1단계: 챔버 재고 3화면 + SMT 공릴체크
 *
 * 시각은 서버가 'YYYY-MM-DD HH24:MI:SS' 문자열로 만들어 보낸다 (KST 보존).
 */

/** 챔버 종류. 화면마다 고정이다 — 세 화면이 이 값으로만 갈린다. */
export type ChamberType = 'B' | 'V' | 'D';

/**
 * 챔버 재고 요약 한 줄 (챔버 × 품목 묶음).
 *
 * `maxLapseHours` 는 그 묶음에서 **가장 오래 들어 있는 것**의 경과시간이다.
 * PB 는 입고시각만 보여줘 몇 시간 됐는지 사람이 세야 했다.
 * `bakingTime`·`lifeCycle` 과 비교해 초과를 판단한다.
 */
export interface ChamberStockSummaryRow {
  chamberType: ChamberType;
  chamberCode: string | null;
  chamberName: string | null;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  supplierCode: string | null;
  countNum: number | null;
  lotQty: number | null;
  minScanDate: string | null;
  maxScanDate: string | null;
  maxLapseHours: number | null;
  /** 품목 기준 베이킹시간(시간). 이 값을 넘으면 꺼내야 한다. */
  bakingTime: number | null;
  /** 품목 수명(시간). MSL 등급과 함께 보관 한도를 정한다. */
  lifeCycle: number | null;
  mslLevel: string | null;
}

/**
 * 챔버 재고 상세 한 줄 (자재 하나).
 *
 * 챔버의 온도 설정값(최소·최대·기준)을 함께 준다 — 규격을 벗어난 챔버에
 * 들어 있는 자재를 찾는 것이 이 화면의 쓸모다.
 */
export interface ChamberStockDetailRow {
  chamberCode: string | null;
  chamberType: ChamberType;
  chamberLocation: string | null;
  itemCode: string;
  itemBarcode: string | null;
  lotNo: string | null;
  lotQty: number | null;
  inputScanDate: string | null;
  /** 아직 안 꺼낸 것만 조회하므로 항상 비어 있다 (재고의 정의다). */
  outputScanDate: string | null;
  /** 넣은 뒤 지난 시간(시간). PB 계산컬럼과 같다. */
  inputLapseTime: number | null;
  scanBy: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemClass: string | null;
  height: number | null;
  lifeCycle: number | null;
  bakingTime: number | null;
  mslLevel: string | null;
  supplierCode: string | null;
  minTempValue: number | null;
  maxTempValue: number | null;
  stdTempValue: number | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/**
 * 266 SMT 공릴체크 한 줄.
 *
 * `checkStatus` 'P' 통과 · 'E' 오류 (실측 419 / 158).
 * 오류면 `checkMsg` 에 사유가 들어 있다.
 */
export interface RecycleCheckRow {
  checkDate: string | null;
  checkSequence: number | null;
  checkStatus: string | null;
  checkMsg: string | null;
  checkBy: string | null;
  scanPartName: string | null;
  lineCode: string | null;
  lineName: string | null;
  modelName: string | null;
  locationCode: string | null;
  feedingDate: string | null;
  enterDate: string | null;
}

/**
 * 244 솔더 한 통.
 *
 * 날짜 컬럼들이 단계를 나타낸다: 입고 → 출고(냉장고에서 꺼냄) → 해동 → 교반
 * → 점도측정 → 라인투입 → 반납/폐기. 솔더는 굳으면 못 쓰므로 **각 단계에 머문
 * 시간**이 핵심이고, 시간 열은 서버가 '몇 시간 몇 분' 문자열로 만들어 보낸다.
 */
export interface SolderRow {
  itemCode: string | null;
  solderLotNo: string;
  itemBarcode: string | null;
  solderType: string | null;
  modelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  machineCode: string | null;
  runNo: string | null;
  receiptDate: string | null;
  issueDate: string | null;
  openDate: string | null;
  unfreezingStartDate: string | null;
  unfreezingEndDate: string | null;
  mixStartDate: string | null;
  mixEndDate: string | null;
  viscosityStartDate: string | null;
  viscosityEndDate: string | null;
  inputDate: string | null;
  firstLineInputDate: string | null;
  returnDate: string | null;
  destroyDate: string | null;
  validDate: string | null;
  /** 유효기한까지 남은 일수. 음수면 이미 지났다. */
  validCount: number | null;
  freezerInTemp: number | null;
  unfreezingStartTemp: number | null;
  unfreezingEndTemp: number | null;
  viscosity: number | null;
  viscosityOperator: string | null;
  viscosityFileName: string | null;
  rpm: number | null;
  mixTime: number | null;
  temp: number | null;
  /** 해동에 걸린 시간 ('1h 20m' 꼴). 아직 끝나지 않았으면 지금까지다. */
  unfreezingWaitTime: string | null;
  /** 교반에 걸린 시간. PB 는 여기서 24시간을 버렸다 (최대 163시간이 19:12 로 보였다). */
  mixWaitTime: string | null;
  afterViscosityTime: string | null;
  /** 냉장고에서 꺼낸 뒤 지난 시간. 이 시간이 솔더 수명을 깎는다. */
  afterIssueTime: string | null;
  afterFirstInputTime: string | null;
  afterOpenTime: string | null;
  /** 이 통이 투입된 라인 목록 (DB 함수가 만든 문자열). */
  solderInputLine: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 244 단계별 대기 수량 한 줄 (설비·라인·종류별). */
export interface SolderStageCountRow {
  machineCode: string | null;
  machineName: string | null;
  lineCode: string | null;
  lineName: string | null;
  solderType: string | null;
  /** 넣었고 아직 안 꺼낸 통 */
  refrigeratorCnt: number | null;
  unfreezingCnt: number | null;
  mixCnt: number | null;
  viscosityWaitCnt: number | null;
  inputWaitCnt: number | null;
}

/** 244 입고·출고 스캔 결과. */
export interface SolderScanResult {
  scanType: 'R' | 'I';
  solderLotNo: string;
  /** 입고일 때만 채워진다 (자재 바코드 표에서 찾은 품목). */
  itemCode: string | null;
  affected: number;
}

/** 245 솔더 라인투입 이력 한 줄. */
export interface SolderInputHistoryRow {
  inputDate: string | null;
  solderLotNo: string;
  runNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  machineCode: string | null;
  machineName: string | null;
  itemCode: string | null;
  solderType: string | null;
  itemBarcode: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}
