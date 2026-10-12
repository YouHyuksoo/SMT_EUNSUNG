/**
 * @file src/app/(authenticated)/confirm/confirm-types.ts
 * @description 승인(M_CONFIRM) 화면들이 공유하는 행 타입.
 *
 * 반출반입승인 2화면은 사용자 지시로 이관 범위에서 제외했다.
 */

/** 단가승인 한 줄 — 구매·판매·S-PARTS 공용 */
export interface PriceConfirmRow {
  itemCode: string;
  itemName: string | null;
  /** 공급처(구매·S-PARTS) 또는 고객(판매) */
  partnerCode: string;
  partnerName: string | null;
  dateSet: string;
  dateEnd: string | null;
  /** 구매·판매는 키의 일부다. S-PARTS 는 null. */
  lineType: string | null;
  lineTypeName: string | null;
  unitPrice: number | null;
  currency: string | null;
  currencyName: string | null;
  approvalNo: string | null;
  delivery: string | null;
  deliveryName: string | null;
  standardPrice: number | null;
  /** 이전단가. 테이블에 컬럼이 없어 DB 함수로 가져온다. */
  lastPrice: number | null;
  taxRate: number | null;
  priceType: string | null;
  priceTypeName: string | null;
  priceChangeReason: string | null;
  priceChangeReasonName: string | null;
  confirmYn: string;
  confirmBy: string | null;
  confirmDate: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

/** 승인 적용 결과 — 세 갈래를 따로 받는다 */
export interface PriceConfirmResult {
  confirmYn: 'Y' | 'N';
  changed: number;
  alreadySet: number;
  missing: number;
}

/** 설계BOM 작업번호 요약 */
export interface BomWorkNumberRow {
  bomWorkNo: number;
  itemCode: string | null;
  itemName: string | null;
  rowCount: number;
  newRowCount: number;
  enterDate: string | null;
  enterBy: string | null;
}

/** 설계BOM 작업공간 한 줄 */
export interface BomWorkspaceRow {
  bomWorkNo: number;
  itemCode: string | null;
  parentItemCode: string;
  parentItemName: string | null;
  childItemCode: string;
  childItemName: string | null;
  childItemSpec: string | null;
  childItemUom: string | null;
  replaceItemCode: string | null;
  dateSet: string | null;
  dateEnd: string | null;
  sortSequence: number | null;
  itemUnitQty: number | null;
  itemUnitQtyExt: number | null;
  workstageCode: string | null;
  itemType: string | null;
  itemTypeName: string | null;
  lineType: string | null;
  lineTypeName: string | null;
  scrapRate: number | null;
  lossRate: number | null;
  assyExplosionYn: string | null;
  /** 'NEW BOM YN' 코드표가 이 DB 에 없어 Y/N 원시값이다 */
  newBomYn: string;
  requestYn: string | null;
  pcbItem: string | null;
  revision: string | null;
  locationInfo: string | null;
  confirmComment: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}
