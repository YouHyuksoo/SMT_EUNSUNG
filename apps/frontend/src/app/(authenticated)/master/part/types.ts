/**
 * @file src/app/(authenticated)/master/part/types.ts
 * @description ID_ITEM API 계약 타입 — 109개 컬럼 전부.
 *
 * 필드 이름·뜻은 packages/shared ITEM_MASTER_COLUMNS 와 같다. 앞쪽 일부는 예전 이름을 그대로 쓴다
 * (rev=ABC_GRADE, markingText=BARCODE, isSplittable=SET_ITEM_YN, imageUrl=FEEDER_LAYOUT_COMMENTS 등).
 * 날짜는 API 가 ISO 문자열로 내려준다.
 */

/** 품목 한 행 */
export interface Part {
  /** ITEM_CODE — 품목코드 */
  itemCode: string;
  /** ORGANIZATION_ID — 조직ID */
  organizationId: number;
  /** ITEM_SPEC — 규격 */
  spec: string;
  /** ITEM_UOM — 단위 */
  itemUom: string;
  /** ITEM_CLASS — 품목분류 */
  itemClass: string;
  /** ITEM_TYPE — 품목유형 */
  itemType: string;
  /** VIRTUAL_RECEIPT_YN — 가입고 */
  virtualReceiptYn?: string | null;
  /** ITEM_NAME — 품명 */
  itemName: string;
  /** LINE_TYPE — 구입유형 */
  lineType: string;
  /** ROUTE_NO — 라우팅번호 */
  routeNo?: string | null;
  /** BARCODE — 바코드 */
  markingText?: string | null;
  /** ABC_GRADE — ABC 등급 */
  rev: string;
  /** ENTER_DATE — 등록일시 */
  createdAt?: string | null;
  /** RAW_MATERIAL — 재료 */
  rawMaterial?: string | null;
  /** SAFETY_INVENTORY — 안전재고 */
  safetyStock?: number | null;
  /** WORK_BAD_RATE — 작업불량율(%) */
  toleranceRate?: number | null;
  /** TRANSFER_UOM — 인수인계단위 */
  transferUom?: string | null;
  /** MANUFACTURE_LEADTIME — 제조리드타임 */
  leadTime?: number | null;
  /** ORDER_CYCLE — 발주주기 */
  orderCycle?: string | null;
  /** ORDER_RULE — 발주조건 */
  orderRule?: string | null;
  /** HS_CODE — 세관 HS코드 */
  hsCode?: string | null;
  /** ENTER_BY — 등록자 */
  createdBy?: string | null;
  /** SVC_CODE — 서비스코드 */
  svcCode?: string | null;
  /** CAPACITY — 용량 */
  tactTime?: number | null;
  /** LAST_MODIFY_DATE — 수정일시 */
  updatedAt?: string | null;
  /** LENGTH — 길이 */
  length?: number | null;
  /** LAST_MODIFY_BY — 수정자 */
  updatedBy?: string | null;
  /** DATESET — 시작일자 */
  dateset?: string | null;
  /** DATEEND — 종료일자 */
  dateend?: string | null;
  /** SET_ITEM_YN — 세트품목구분 */
  isSplittable: string;
  /** SPECIAL_PROPERTY — 특성 */
  specialProperty?: string | null;
  /** LAYER — 겹치기 */
  layer?: number | null;
  /** PART_NO — 품번 */
  itemNo?: string | null;
  /** HEIGHT — 높이 */
  height?: number | null;
  /** WEIGHT — 중량 */
  weight?: number | null;
  /** DRAWING_NO — 도면번호 */
  drawNo?: string | null;
  /** GRADIENT — 경사도 */
  gradient?: number | null;
  /** DENSITY — 밀도 */
  density?: number | null;
  /** ITEM_DIVISION — 품목구분 */
  itemDivision: string;
  /** ISSUE_PACKING_QTY — 포장수량 */
  boxQty?: number | null;
  /** INNER_DIAMETER — 내경 */
  innerDiameter?: number | null;
  /** OUTER_DIAMETER — 외경 */
  outerDiameter?: number | null;
  /** WIDTH — 폭 */
  width?: number | null;
  /** HS_NAME — 세관품목명 */
  hsName?: string | null;
  /** HS_SPEC — 세관규격 */
  hsSpec?: string | null;
  /** HS_CODE_SCRAP — 세관 스크랩 HS코드 */
  hsCodeScrap?: string | null;
  /** HS_NAME_SCRAP — 세관 스크랩명 */
  hsNameScrap?: string | null;
  /** HS_SPEC_SCRAP — 세관 스크랩규격 */
  hsSpecScrap?: string | null;
  /** TRANSFER_YN — 이동여부 */
  transferYn?: string | null;
  /** LINE_CODE — 라인 */
  lineCode?: string | null;
  /** TARIFF_RATE — 세율 */
  tariffRate?: number | null;
  /** SUPPLIER_CODE — 공급상/제작처 */
  supplierCode?: string | null;
  /** CUSTOMER_CODE — 고객 */
  customerCode?: string | null;
  /** MODEL_NAME — 모델명 */
  modelName?: string | null;
  /** MODEL_SUFFIX — 모델서픽스 */
  modelSuffix?: string | null;
  /** AUTO_ISSUE_YN — 자동출고 */
  autoIssueYn?: string | null;
  /** AUTO_RECEIPT_YN — 자동입고 */
  autoReceiptYn?: string | null;
  /** AUTO_ISSUE_PLAN_YN — 자동출고계획 */
  autoIssuePlanYn?: string | null;
  /** BUY_PRICE — 구매단가 */
  buyPrice?: number | null;
  /** SALE_PRICE — 판매단가 */
  salePrice?: number | null;
  /** SALE_PRICE_APPLY_TYPE — 판매단가 적용유형 */
  salePriceApplyType?: string | null;
  /** GROSS_WEIGHT — 총중량 */
  grossWeight?: number | null;
  /** CBM — CBM */
  cbm?: number | null;
  /** BARCODE2 — 바코드2 */
  barcode2?: string | null;
  /** EHMS_YN — EHMS 대상 */
  ehmsYn?: string | null;
  /** EHMS_STATUS — EHMS 상태 */
  ehmsStatus?: string | null;
  /** MATERIAL_TYPE — 자재유형 */
  materialType?: string | null;
  /** PURCHASE_GROUP — 구매그룹 */
  purchaseGroup?: string | null;
  /** PHANTOM_CODE — 팬텀코드 */
  phantomCode?: string | null;
  /** SUPPLY_TYPE — 공급유형 */
  supplyType?: string | null;
  /** MES_DISPLAY_YN — MES 사용 */
  mesDisplayYn?: string | null;
  /** LOCATION_ADDRESS — 자재위치 */
  storageLocation?: string | null;
  /** MATERIAL_QTY — 자재수량 */
  lotUnitQty?: number | null;
  /** HS_NAME_SALE — 세관 판매모델명 */
  hsNameSale?: string | null;
  /** VENDOR_CODE — 밴더코드 */
  vendorCode?: string | null;
  /** MATERIAL_QTY2 — 자재수량2 */
  minPackQty?: number | null;
  /** MSL_LEVEL — MSL 레벨 */
  mslLevel?: string | null;
  /** CHECK_SUPPLIER_BARCODE — 거래처 바코드 체크 */
  checkSupplierBarcode?: string | null;
  /** MSL_MAX_TIME — MSL 자재관리시간 */
  expiryExtDays?: number | null;
  /** IS_NEW_YN — 신규품목 */
  isNewYn?: string | null;
  /** FEEDER_LAYOUT_COMMENTS — 피더 배치 설명 */
  imageUrl?: string | null;
  /** SOLDER_TYPE — 솔더타입 */
  solderType?: string | null;
  /** SOLDER_OPEN_LIMIT_TIME — 솔더 개봉 제한시간 */
  solderOpenLimitTime?: number | null;
  /** SOLDER_AGITATION_TIME — 솔더 교반시간 */
  solderAgitationTime?: number | null;
  /** LIFE_CYCLE — 유효수명 */
  expiryDate?: number | null;
  /** ECO_CHECK_YN — 시방 체크 */
  ecoCheckYn?: string | null;
  /** ECO_CHECK_COMMENTS — 시방 체크 설명 */
  ecoCheckComments?: string | null;
  /** CUSTOMER_MODEL_NAME — 고객 모델명 */
  customerModelName?: string | null;
  /** CARRIER_SIZE — 연배열수 */
  packUnit?: number | null;
  /** FEEDER_SIZE — 피더 사이즈 */
  feederSize?: string | null;
  /** RECEIPT_LOT_CHECK_YN — 입고 롯트 체크 */
  receiptLotCheckYn?: string | null;
  /** COMMENTS — 설명 */
  remark?: string | null;
  /** MATERIAL_QTY3 — 자재수량3 */
  materialQty3?: number | null;
  /** KEYITEM_YN — 주요품목 */
  keyitemYn?: string | null;
  /** VENDOR_CODE1 — 밴더코드1 */
  vendorCode1?: string | null;
  /** VENDOR_CODE2 — 밴더코드2 */
  vendorCode2?: string | null;
  /** VENDOR_CODE3 — 밴더코드3 */
  vendorCode3?: string | null;
  /** NO_CHECK_ORIGIN_SUPPLIER — 원공급상 체크 안 함 */
  noCheckOriginSupplier?: string | null;
  /** REEL_CHANGE_BLOCKED — 릴 교체 차단 */
  reelChangeBlocked?: string | null;
  /** MODEL_COLOR — 모델 색상 */
  color?: string | null;
  /** PCB_COATING_TYPE — PCB 코팅유형 */
  pcbCoatingType?: string | null;
  /** PCB_COATING_MAX_DAY — PCB 코팅 최대일수 */
  pcbCoatingMaxDay?: number | null;
  /** CUSTOMER_PART_NO — 고객 품번 */
  custPartNo?: string | null;
  /** PCB_WORKING_MAX_DAY — PCB 개봉 후 작업완료 시간 */
  pcbWorkingMaxDay?: number | null;
  /** BAKING_TIME — 베이킹 관리시간 */
  bakingTime?: number | null;
  /** PARTNO_DIVIDE_MARKER — 품번 구분자 */
  partnoDivideMarker?: string | null;
  /** PARTNO_MARKER_START — 품번 시작위치 */
  partnoMarkerStart?: number | null;
  /** PARTNO_MARKER_END — 품번 끝위치 */
  partnoMarkerEnd?: number | null;
  /** BAKING_TEMPERATURE — 베이킹 온도 */
  bakingTemperature?: number | null;
}
