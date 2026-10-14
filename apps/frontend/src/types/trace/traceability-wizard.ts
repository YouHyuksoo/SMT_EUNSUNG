/**
 * @file src/types/trace/traceability-wizard.ts
 * @description 추적성분석 바코드 조회 위자드 — 모드/입력 타입 정의
 *
 * 초보자 가이드:
 * - BarcodeSearchMode: 단일값(바코드·RUN·매거진·박스) + 수리이력(기간+품목코드) + SPI/AOI(기간)
 * - 팔레트·캐리어는 IP_PRODUCT_2D_BARCODE 에 인덱스가 없어(1.8억행 풀스캔) 뺐다
 * - 모든 모드는 {SERIAL_NO, PCB_ITEM} 목록을 반환하므로 반환 타입은 공통
 */

export type BarcodeSearchMode =
  | 'barcode'
  | 'runNo'
  | 'magazine'
  | 'box'
  | 'repair'
  | 'spi'
  | 'aoi';

export type SingleValueMode = 'barcode' | 'runNo' | 'magazine' | 'box';
export type DateRangeMode = 'spi' | 'aoi';

/** 단일 값 입력 모드 (barcode/runNo/magazine/box) */
export interface BarcodeSingleModeInput {
  mode: SingleValueMode;
  value: string;
}

/** 수리이력 모드 입력 */
export interface BarcodeRepairModeInput {
  mode: 'repair';
  dateFrom: string;
  dateTo: string;
  itemCode: string;
}

/** 날짜 구간 전용 모드 (SPI/AOI 설비 로그) */
export interface BarcodeDateRangeModeInput {
  mode: DateRangeMode;
  dateFrom: string;
  dateTo: string;
}

export type BarcodeSearchInput = BarcodeSingleModeInput | BarcodeRepairModeInput | BarcodeDateRangeModeInput;

export interface BarcodeItem {
  SERIAL_NO: string;
  PCB_ITEM: string | null;
}
