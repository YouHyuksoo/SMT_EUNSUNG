"use strict";
/**
 * @file packages/shared/src/master/item-master-columns.ts
 * @description 품목마스터(ID_ITEM) 컬럼 목록 — 백엔드 저장·검증과 화면 그리드·필터·등록창이 함께 쓴다.
 *
 * 초보자 가이드:
 * 1. **ID_ITEM 의 109개 컬럼이 빠짐없이 한 줄씩 있다.** 컬럼을 늘리거나 바꾸면 여기 한 곳만 고친다.
 *    itemMasterColumns.test.ts 가 컬럼 수·키 중복을 확인한다.
 * 2. **key 는 API 필드 이름이다.** 예전부터 쓰던 36개는 다른 화면이 읽고 있어 이름을 그대로 둔다
 *    (예: ABC_GRADE → rev, BARCODE → markingText). 라벨은 DB 의미대로 적는다.
 * 3. **edit**: always = 등록·수정 / create = 등록 때만(키) / never = 표시 전용.
 *    ROUTE_NO 는 바꾸면 DB 트리거(ID_ITEM_UPD_MANUAL)가 재고 행을 지워서 never 다.
 * 4. **LINE_TYPE·SUPPLIER_CODE·CUSTOMER_CODE 는 바꾸면 DB 트리거(TRG_ID_ITEM_UPD)가 연결 테이블을 고친다.**
 *    화면은 저장 전에 알리고, 서버는 값이 실제로 바뀐 컬럼만 UPDATE 한다
 *    (Oracle 의 UPDATE OF 트리거는 SET 에 들어가기만 해도 돈다).
 * 5. **defaultValue 는 최근 등록 데이터가 쓰는 값이다.** "today" 는 등록하는 날이다.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.ITEM_MASTER_EDITABLE_COLUMNS = exports.ITEM_MASTER_CASCADE_COLUMNS = exports.ITEM_MASTER_COLUMNS = exports.ITEM_MASTER_SECTIONS = void 0;
exports.itemMasterDefaults = itemMasterDefaults;
/** 등록창 구역 순서와 이름 */
exports.ITEM_MASTER_SECTIONS = [
    { key: 'basic', label: '기본정보' },
    { key: 'class', label: '분류·구매' },
    { key: 'stock', label: '재고·발주' },
    { key: 'material', label: '자재·MSL·솔더·PCB' },
    { key: 'size', label: '치수·중량' },
    { key: 'price', label: '단가' },
    { key: 'trade', label: '세관(HS)' },
    { key: 'etc', label: '기타' },
    { key: 'audit', label: '등록·수정 이력' },
];
/** ID_ITEM 전체 컬럼 (DB 컬럼 순서) */
exports.ITEM_MASTER_COLUMNS = [
    { column: "ITEM_CODE", key: "itemCode", label: "품목코드", type: "string", maxLength: 20, required: true, input: "text", section: "basic", edit: "create", help: "품목을 구분하는 키입니다. 등록 후에는 바꿀 수 없습니다." },
    { column: "ORGANIZATION_ID", key: "organizationId", label: "조직ID", type: "number", required: true, input: "none", section: "audit", edit: "never", help: "로그인한 조직으로 자동 저장됩니다." },
    { column: "ITEM_SPEC", key: "spec", label: "규격", type: "string", maxLength: 300, required: true, input: "text", section: "basic", edit: "always", defaultValue: "*", help: "품목 규격입니다. 규격이 없으면 '*' 를 넣습니다." },
    { column: "ITEM_UOM", key: "itemUom", label: "단위", type: "string", maxLength: 3, required: true, input: "code", codeGroup: "ITEM UOM", section: "basic", edit: "always", defaultValue: "EA", help: "기준코드 ITEM UOM." },
    { column: "ITEM_CLASS", key: "itemClass", label: "품목분류", type: "string", maxLength: 20, required: true, input: "code", codeGroup: "ITEM CLASS", section: "class", edit: "always", defaultValue: "*", help: "기준코드 ITEM CLASS." },
    { column: "ITEM_TYPE", key: "itemType", label: "품목유형", type: "string", maxLength: 10, required: true, input: "code", codeGroup: "ITEM TYPE", section: "class", edit: "always", defaultValue: "T", help: "기준코드 ITEM TYPE (M 무상 / S·Y 유상 / T 자작)." },
    { column: "VIRTUAL_RECEIPT_YN", key: "virtualReceiptYn", label: "가입고", type: "string", maxLength: 1, required: false, input: "code", codeGroup: "VIRTUAL RECEIPT YN", section: "stock", edit: "always", defaultValue: "N", help: "기준코드 VIRTUAL RECEIPT YN (N 정상 / Y 가입고)." },
    { column: "ITEM_NAME", key: "itemName", label: "품명", type: "string", maxLength: 300, required: true, input: "text", section: "basic", edit: "always", help: "품목 이름입니다." },
    { column: "LINE_TYPE", key: "lineType", label: "구입유형", type: "string", maxLength: 10, required: true, input: "code", codeGroup: "LINE TYPE", section: "class", edit: "always", help: "기준코드 LINE TYPE. 바꾸면 DB 트리거가 BOM·공급처 단가 정보를 함께 바꿉니다." },
    { column: "ROUTE_NO", key: "routeNo", label: "라우팅번호", type: "string", maxLength: 20, required: false, input: "text", section: "class", edit: "never", defaultValue: "*", help: "바꾸면 DB 트리거가 재고 행을 지우고 입출고 구입유형을 고쳐 써서 이 화면에서는 고칠 수 없습니다." },
    { column: "BARCODE", key: "markingText", label: "바코드", type: "string", maxLength: 100, required: false, input: "text", section: "basic", edit: "always", help: "품목 바코드 값입니다." },
    { column: "ABC_GRADE", key: "rev", label: "ABC 등급", type: "string", maxLength: 1, required: true, input: "abc", section: "class", edit: "always", defaultValue: "C", help: "A / B / C 등급입니다." },
    { column: "ENTER_DATE", key: "createdAt", label: "등록일시", type: "date", required: false, input: "none", section: "audit", edit: "never", help: "등록할 때 자동 저장됩니다." },
    { column: "RAW_MATERIAL", key: "rawMaterial", label: "재료", type: "string", maxLength: 20, required: false, input: "code", codeGroup: "RAW MATERIAL", section: "material", edit: "always", defaultValue: "*", help: "기준코드 RAW MATERIAL." },
    { column: "SAFETY_INVENTORY", key: "safetyStock", label: "안전재고", type: "number", required: false, input: "number", section: "stock", edit: "always", defaultValue: 0, help: "재고 부족 판단에 쓰는 수량입니다." },
    { column: "WORK_BAD_RATE", key: "toleranceRate", label: "작업불량율(%)", type: "number", precision: 3, scale: 1, required: false, input: "number", section: "stock", edit: "always", help: "소수 한 자리까지, 99.9 이하입니다." },
    { column: "TRANSFER_UOM", key: "transferUom", label: "인수인계단위", type: "string", maxLength: 20, required: false, input: "code", codeGroup: "TRANSFER UOM", section: "stock", edit: "always", defaultValue: "EA", help: "기준코드 TRANSFER UOM." },
    { column: "MANUFACTURE_LEADTIME", key: "leadTime", label: "제조리드타임", type: "number", required: false, input: "number", section: "stock", edit: "always", defaultValue: 0, help: "제조에 걸리는 기간입니다." },
    { column: "ORDER_CYCLE", key: "orderCycle", label: "발주주기", type: "string", maxLength: 10, required: false, input: "code", codeGroup: "ORDER CYCLE", section: "stock", edit: "always", defaultValue: "0", help: "기준코드 ORDER CYCLE (D 매일 / M 매월 / S 안전재고 / X 수시)." },
    { column: "ORDER_RULE", key: "orderRule", label: "발주조건", type: "string", maxLength: 10, required: false, input: "code", codeGroup: "ORDER RULE", section: "stock", edit: "always", defaultValue: "A", help: "기준코드 ORDER RULE (A 자동 / E PO제외 / M 수동 / O 직주문)." },
    { column: "HS_CODE", key: "hsCode", label: "세관 HS코드", type: "string", maxLength: 20, required: false, input: "text", section: "trade", edit: "always", defaultValue: "*", help: "세관 신고용 HS 코드입니다." },
    { column: "ENTER_BY", key: "createdBy", label: "등록자", type: "string", maxLength: 20, required: false, input: "none", section: "audit", edit: "never", help: "등록한 사용자입니다." },
    { column: "SVC_CODE", key: "svcCode", label: "서비스코드", type: "string", maxLength: 10, required: false, input: "code", codeGroup: "SVC CODE", section: "etc", edit: "always", defaultValue: "*", help: "기준코드 SVC CODE." },
    { column: "CAPACITY", key: "tactTime", label: "용량", type: "number", required: false, input: "number", section: "size", edit: "always", defaultValue: 0, help: "품목 용량입니다." },
    { column: "LAST_MODIFY_DATE", key: "updatedAt", label: "수정일시", type: "date", required: false, input: "none", section: "audit", edit: "never", help: "마지막으로 고친 시각입니다." },
    { column: "LENGTH", key: "length", label: "길이", type: "number", required: false, input: "number", section: "size", edit: "always", help: "품목 길이입니다." },
    { column: "LAST_MODIFY_BY", key: "updatedBy", label: "수정자", type: "string", maxLength: 20, required: false, input: "none", section: "audit", edit: "never", help: "마지막으로 고친 사용자입니다." },
    { column: "DATESET", key: "dateset", label: "시작일자", type: "date", required: false, input: "date", section: "class", edit: "always", defaultValue: "today", help: "품목 사용 시작일입니다. 등록할 때 구매 품목 정보의 시작일로도 쓰입니다." },
    { column: "DATEEND", key: "dateend", label: "종료일자", type: "date", required: false, input: "date", section: "class", edit: "always", defaultValue: "9999-12-31", help: "품목 사용 종료일입니다." },
    { column: "SET_ITEM_YN", key: "isSplittable", label: "세트품목구분", type: "string", maxLength: 1, required: true, input: "code", codeGroup: "SET ITEM YN", section: "class", edit: "always", defaultValue: "N", help: "기준코드 SET ITEM YN (M MATERIAL / N 부품 / Y 세트)." },
    { column: "SPECIAL_PROPERTY", key: "specialProperty", label: "특성", type: "string", maxLength: 30, required: false, input: "text", section: "etc", edit: "always", defaultValue: "*", help: "품목 특성입니다." },
    { column: "LAYER", key: "layer", label: "겹치기", type: "number", required: false, input: "number", section: "size", edit: "always", help: "겹치기 수입니다." },
    { column: "PART_NO", key: "itemNo", label: "품번", type: "string", maxLength: 200, required: false, input: "text", section: "basic", edit: "always", help: "고객사 품번입니다." },
    { column: "HEIGHT", key: "height", label: "높이", type: "number", required: false, input: "number", section: "size", edit: "always", help: "품목 높이입니다." },
    { column: "WEIGHT", key: "weight", label: "중량", type: "number", required: false, input: "number", section: "size", edit: "always", help: "품목 중량입니다." },
    { column: "DRAWING_NO", key: "drawNo", label: "도면번호", type: "string", maxLength: 30, required: false, input: "text", section: "etc", edit: "always", help: "도면번호입니다." },
    { column: "GRADIENT", key: "gradient", label: "경사도", type: "number", required: false, input: "number", section: "size", edit: "always", help: "경사도입니다." },
    { column: "DENSITY", key: "density", label: "밀도", type: "number", required: false, input: "number", section: "size", edit: "always", help: "밀도입니다." },
    { column: "ITEM_DIVISION", key: "itemDivision", label: "품목구분", type: "string", maxLength: 1, required: true, input: "code", codeGroup: "ITEM DIVISION", section: "class", edit: "always", help: "기준코드 ITEM DIVISION (F 제품 / W 반제품 / R 원자재). 제품(F)은 라인이 있어야 등록됩니다." },
    { column: "ISSUE_PACKING_QTY", key: "boxQty", label: "포장수량", type: "number", required: false, input: "number", section: "stock", edit: "always", defaultValue: 0, help: "출고 포장 단위 수량입니다." },
    { column: "INNER_DIAMETER", key: "innerDiameter", label: "내경", type: "number", required: false, input: "number", section: "size", edit: "always", help: "내경입니다." },
    { column: "OUTER_DIAMETER", key: "outerDiameter", label: "외경", type: "number", required: false, input: "number", section: "size", edit: "always", help: "외경입니다." },
    { column: "WIDTH", key: "width", label: "폭", type: "number", required: false, input: "number", section: "size", edit: "always", help: "폭입니다." },
    { column: "HS_NAME", key: "hsName", label: "세관품목명", type: "string", maxLength: 100, required: false, input: "text", section: "trade", edit: "always", help: "세관 신고 품목명입니다." },
    { column: "HS_SPEC", key: "hsSpec", label: "세관규격", type: "string", maxLength: 100, required: false, input: "text", section: "trade", edit: "always", help: "세관 신고 규격입니다." },
    { column: "HS_CODE_SCRAP", key: "hsCodeScrap", label: "세관 스크랩 HS코드", type: "string", maxLength: 20, required: false, input: "text", section: "trade", edit: "always", defaultValue: "*", help: "스크랩 신고용 HS 코드입니다." },
    { column: "HS_NAME_SCRAP", key: "hsNameScrap", label: "세관 스크랩명", type: "string", maxLength: 100, required: false, input: "text", section: "trade", edit: "always", help: "스크랩 신고 품목명입니다." },
    { column: "HS_SPEC_SCRAP", key: "hsSpecScrap", label: "세관 스크랩규격", type: "string", maxLength: 100, required: false, input: "text", section: "trade", edit: "always", help: "스크랩 신고 규격입니다." },
    { column: "TRANSFER_YN", key: "transferYn", label: "이동여부", type: "string", maxLength: 1, required: false, input: "code", codeGroup: "TRANSFER YN", section: "stock", edit: "always", defaultValue: "N", help: "기준코드 TRANSFER YN." },
    { column: "LINE_CODE", key: "lineCode", label: "라인", type: "string", maxLength: 20, required: false, input: "line", section: "class", edit: "always", defaultValue: "*", help: "생산라인입니다. 제품(F)은 라인이 있어야 등록됩니다. '*' 는 미지정입니다." },
    { column: "TARIFF_RATE", key: "tariffRate", label: "세율", type: "number", required: false, input: "number", section: "trade", edit: "always", help: "관세율입니다." },
    { column: "SUPPLIER_CODE", key: "supplierCode", label: "공급상/제작처", type: "string", maxLength: 20, required: false, input: "supplier", section: "class", edit: "always", defaultValue: "*", help: "공급상입니다. 바꾸면 DB 트리거가 구매 품목·단가의 공급상을 함께 바꿉니다." },
    { column: "CUSTOMER_CODE", key: "customerCode", label: "고객", type: "string", maxLength: 20, required: false, input: "customer", section: "class", edit: "always", help: "고객입니다. 바꾸면 DB 트리거가 연결 정보를 함께 고칩니다." },
    { column: "MODEL_NAME", key: "modelName", label: "모델명", type: "string", maxLength: 100, required: false, input: "text", section: "basic", edit: "always", help: "모델명입니다." },
    { column: "MODEL_SUFFIX", key: "modelSuffix", label: "모델서픽스", type: "string", maxLength: 50, required: false, input: "text", section: "basic", edit: "always", help: "모델 사양 구분값입니다." },
    { column: "AUTO_ISSUE_YN", key: "autoIssueYn", label: "자동출고", type: "string", maxLength: 1, required: false, input: "code", codeGroup: "AUTO ISSUE YN", section: "stock", edit: "always", defaultValue: "N", help: "기준코드 AUTO ISSUE YN (N 수동출고 / Y 자동출고)." },
    { column: "AUTO_RECEIPT_YN", key: "autoReceiptYn", label: "자동입고", type: "string", maxLength: 1, required: false, input: "code", codeGroup: "AUTO RECEIPT YN", section: "stock", edit: "always", help: "기준코드 AUTO RECEIPT YN." },
    { column: "AUTO_ISSUE_PLAN_YN", key: "autoIssuePlanYn", label: "자동출고계획", type: "string", maxLength: 1, required: false, input: "code", codeGroup: "AUTO ISSUE PLAN YN", section: "stock", edit: "always", help: "기준코드 AUTO ISSUE PLAN YN." },
    { column: "BUY_PRICE", key: "buyPrice", label: "구매단가", type: "number", required: false, input: "number", section: "price", edit: "always", defaultValue: 0, help: "등록할 때 구매 단가 정보의 첫 단가로도 쓰입니다." },
    { column: "SALE_PRICE", key: "salePrice", label: "판매단가", type: "number", required: false, input: "number", section: "price", edit: "always", defaultValue: 0, help: "판매단가입니다." },
    { column: "SALE_PRICE_APPLY_TYPE", key: "salePriceApplyType", label: "판매단가 적용유형", type: "string", maxLength: 1, required: false, input: "text", section: "price", edit: "always", defaultValue: "*", help: "판매단가 적용유형입니다." },
    { column: "GROSS_WEIGHT", key: "grossWeight", label: "총중량", type: "number", required: false, input: "number", section: "size", edit: "always", help: "포장 포함 중량입니다." },
    { column: "CBM", key: "cbm", label: "CBM", type: "number", required: false, input: "number", section: "size", edit: "always", help: "부피(CBM)입니다." },
    { column: "BARCODE2", key: "barcode2", label: "바코드2", type: "string", maxLength: 100, required: false, input: "text", section: "basic", edit: "always", help: "보조 바코드입니다." },
    { column: "EHMS_YN", key: "ehmsYn", label: "EHMS 대상", type: "string", maxLength: 1, required: false, input: "yn", section: "etc", edit: "always", help: "EHMS 대상 여부입니다." },
    { column: "EHMS_STATUS", key: "ehmsStatus", label: "EHMS 상태", type: "string", maxLength: 1, required: false, input: "text", section: "etc", edit: "always", help: "EHMS 상태값입니다." },
    { column: "MATERIAL_TYPE", key: "materialType", label: "자재유형", type: "string", maxLength: 10, required: false, input: "text", section: "etc", edit: "always", help: "자재유형입니다." },
    { column: "PURCHASE_GROUP", key: "purchaseGroup", label: "구매그룹", type: "string", maxLength: 10, required: false, input: "text", section: "etc", edit: "always", help: "구매그룹입니다." },
    { column: "PHANTOM_CODE", key: "phantomCode", label: "팬텀코드", type: "string", maxLength: 1, required: false, input: "text", section: "etc", edit: "always", help: "팬텀 품목 구분값입니다." },
    { column: "SUPPLY_TYPE", key: "supplyType", label: "공급유형", type: "string", maxLength: 1, required: false, input: "text", section: "etc", edit: "always", help: "공급유형입니다." },
    { column: "MES_DISPLAY_YN", key: "mesDisplayYn", label: "MES 사용", type: "string", maxLength: 1, required: false, input: "yn", section: "basic", edit: "always", defaultValue: "Y", help: "N 이면 MES 화면의 품목 선택 목록에서 빠집니다." },
    { column: "LOCATION_ADDRESS", key: "storageLocation", label: "자재위치", type: "string", maxLength: 20, required: false, input: "text", section: "stock", edit: "always", help: "자재 보관 위치(예: P-H-1-2)입니다." },
    { column: "MATERIAL_QTY", key: "lotUnitQty", label: "자재수량", type: "number", required: false, input: "number", section: "stock", edit: "always", help: "자재 기준 수량입니다." },
    { column: "HS_NAME_SALE", key: "hsNameSale", label: "세관 판매모델명", type: "string", maxLength: 100, required: false, input: "text", section: "trade", edit: "always", help: "수출 신고 판매모델명입니다." },
    { column: "VENDOR_CODE", key: "vendorCode", label: "밴더코드", type: "string", maxLength: 20, required: false, input: "text", section: "etc", edit: "always", help: "밴더코드입니다." },
    { column: "MATERIAL_QTY2", key: "minPackQty", label: "자재수량2", type: "number", required: false, input: "number", section: "stock", edit: "always", help: "자재 보조 수량입니다." },
    { column: "MSL_LEVEL", key: "mslLevel", label: "MSL 레벨", type: "string", maxLength: 10, required: false, input: "code", codeGroup: "MSL LEVEL", section: "material", edit: "always", help: "기준코드 MSL LEVEL." },
    { column: "CHECK_SUPPLIER_BARCODE", key: "checkSupplierBarcode", label: "거래처 바코드 체크", type: "string", maxLength: 1, required: false, input: "yn", section: "material", edit: "always", help: "Y 이면 입고 때 거래처 바코드를 확인합니다." },
    { column: "MSL_MAX_TIME", key: "expiryExtDays", label: "MSL 자재관리시간", type: "number", required: false, input: "number", section: "material", edit: "always", help: "MSL 자재를 개봉 후 쓸 수 있는 시간입니다." },
    { column: "IS_NEW_YN", key: "isNewYn", label: "신규품목", type: "string", maxLength: 1, required: false, input: "yn", section: "etc", edit: "always", defaultValue: "Y", help: "신규 품목 여부입니다." },
    { column: "FEEDER_LAYOUT_COMMENTS", key: "imageUrl", label: "피더 배치 설명", type: "string", maxLength: 2000, required: false, input: "textarea", section: "material", edit: "always", help: "피더 배치 관련 설명입니다." },
    { column: "SOLDER_TYPE", key: "solderType", label: "솔더타입", type: "string", maxLength: 1, required: false, input: "code", codeGroup: "SOLDER TYPE", section: "material", edit: "always", help: "기준코드 SOLDER TYPE (F 무연 / P 유연)." },
    { column: "SOLDER_OPEN_LIMIT_TIME", key: "solderOpenLimitTime", label: "솔더 개봉 제한시간", type: "number", required: false, input: "number", section: "material", edit: "always", help: "솔더 개봉 후 사용 제한시간입니다." },
    { column: "SOLDER_AGITATION_TIME", key: "solderAgitationTime", label: "솔더 교반시간", type: "number", required: false, input: "number", section: "material", edit: "always", help: "솔더 교반시간입니다." },
    { column: "LIFE_CYCLE", key: "expiryDate", label: "유효수명", type: "number", required: false, input: "number", section: "material", edit: "always", defaultValue: 0, help: "유효수명입니다." },
    { column: "ECO_CHECK_YN", key: "ecoCheckYn", label: "시방 체크", type: "string", maxLength: 1, required: false, input: "yn", section: "etc", edit: "always", help: "시방 체크 여부입니다." },
    { column: "ECO_CHECK_COMMENTS", key: "ecoCheckComments", label: "시방 체크 설명", type: "string", maxLength: 1000, required: false, input: "textarea", section: "etc", edit: "always", help: "시방 체크 설명입니다." },
    { column: "CUSTOMER_MODEL_NAME", key: "customerModelName", label: "고객 모델명", type: "string", maxLength: 100, required: false, input: "text", section: "basic", edit: "always", help: "고객사(LG) 모델명입니다." },
    { column: "CARRIER_SIZE", key: "packUnit", label: "연배열수", type: "number", required: false, input: "number", section: "material", edit: "always", help: "PCB 연배열 수(1 / 2 / 4 / 8)입니다." },
    { column: "FEEDER_SIZE", key: "feederSize", label: "피더 사이즈", type: "string", maxLength: 50, required: false, input: "text", section: "material", edit: "always", help: "피더 사이즈입니다." },
    { column: "RECEIPT_LOT_CHECK_YN", key: "receiptLotCheckYn", label: "입고 롯트 체크", type: "string", maxLength: 1, required: false, input: "code", codeGroup: "RECEIPT LOT CHECK YN", section: "material", edit: "always", help: "기준코드 RECEIPT LOT CHECK YN." },
    { column: "COMMENTS", key: "remark", label: "설명", type: "string", maxLength: 1000, required: false, input: "textarea", section: "etc", edit: "always", help: "품목 설명입니다." },
    { column: "MATERIAL_QTY3", key: "materialQty3", label: "자재수량3", type: "number", required: false, input: "number", section: "stock", edit: "always", help: "자재 보조 수량입니다." },
    { column: "KEYITEM_YN", key: "keyitemYn", label: "주요품목", type: "string", maxLength: 1, required: false, input: "yn", section: "etc", edit: "always", defaultValue: "N", help: "주요 품목 여부입니다." },
    { column: "VENDOR_CODE1", key: "vendorCode1", label: "밴더코드1", type: "string", maxLength: 15, required: false, input: "text", section: "etc", edit: "always", help: "밴더코드입니다." },
    { column: "VENDOR_CODE2", key: "vendorCode2", label: "밴더코드2", type: "string", maxLength: 15, required: false, input: "text", section: "etc", edit: "always", help: "밴더코드입니다." },
    { column: "VENDOR_CODE3", key: "vendorCode3", label: "밴더코드3", type: "string", maxLength: 15, required: false, input: "text", section: "etc", edit: "always", help: "밴더코드입니다." },
    { column: "NO_CHECK_ORIGIN_SUPPLIER", key: "noCheckOriginSupplier", label: "원공급상 체크 안 함", type: "string", maxLength: 1, required: false, input: "yn", section: "material", edit: "always", help: "Y 이면 입고 때 원공급상을 확인하지 않습니다." },
    { column: "REEL_CHANGE_BLOCKED", key: "reelChangeBlocked", label: "릴 교체 차단", type: "string", maxLength: 1, required: false, input: "yn", section: "material", edit: "always", help: "릴 교체 차단 여부입니다." },
    { column: "MODEL_COLOR", key: "color", label: "모델 색상", type: "string", maxLength: 20, required: false, input: "text", section: "basic", edit: "always", help: "모델 색상입니다." },
    { column: "PCB_COATING_TYPE", key: "pcbCoatingType", label: "PCB 코팅유형", type: "string", maxLength: 20, required: false, input: "code", codeGroup: "PCB COATING TYPE", section: "material", edit: "always", help: "기준코드 PCB COATING TYPE." },
    { column: "PCB_COATING_MAX_DAY", key: "pcbCoatingMaxDay", label: "PCB 코팅 최대일수", type: "number", required: false, input: "number", section: "material", edit: "always", help: "PCB 코팅 후 쓸 수 있는 최대 일수입니다." },
    { column: "CUSTOMER_PART_NO", key: "custPartNo", label: "고객 품번", type: "string", maxLength: 50, required: false, input: "text", section: "basic", edit: "always", help: "고객이 쓰는 품번입니다." },
    { column: "PCB_WORKING_MAX_DAY", key: "pcbWorkingMaxDay", label: "PCB 개봉 후 작업완료 시간", type: "number", required: false, input: "number", section: "material", edit: "always", help: "PCB 개봉 후 작업을 끝내야 하는 시간입니다." },
    { column: "BAKING_TIME", key: "bakingTime", label: "베이킹 관리시간", type: "number", required: false, input: "number", section: "material", edit: "always", help: "베이킹 관리시간입니다." },
    { column: "PARTNO_DIVIDE_MARKER", key: "partnoDivideMarker", label: "품번 구분자", type: "string", maxLength: 20, required: false, input: "text", section: "material", edit: "always", help: "바코드에서 품번을 잘라낼 때 쓰는 구분자입니다." },
    { column: "PARTNO_MARKER_START", key: "partnoMarkerStart", label: "품번 시작위치", type: "number", required: false, input: "number", section: "material", edit: "always", help: "바코드에서 품번이 시작하는 위치입니다." },
    { column: "PARTNO_MARKER_END", key: "partnoMarkerEnd", label: "품번 끝위치", type: "number", required: false, input: "number", section: "material", edit: "always", help: "바코드에서 품번이 끝나는 위치입니다." },
    { column: "BAKING_TEMPERATURE", key: "bakingTemperature", label: "베이킹 온도", type: "number", required: false, input: "number", section: "material", edit: "always", help: "베이킹 온도입니다." },
];
/** 바꾸면 DB 트리거가 다른 테이블을 고치는 컬럼 — 수정 저장 전에 알린다 */
exports.ITEM_MASTER_CASCADE_COLUMNS = ['LINE_TYPE', 'SUPPLIER_CODE', 'CUSTOMER_CODE'];
/** 등록·수정 화면에서 값을 받는 컬럼 */
exports.ITEM_MASTER_EDITABLE_COLUMNS = exports.ITEM_MASTER_COLUMNS.filter((c) => c.edit !== 'never');
/** 등록 기본값. today 는 YYYY-MM-DD. */
function itemMasterDefaults(today) {
    const out = {};
    for (const c of exports.ITEM_MASTER_EDITABLE_COLUMNS) {
        if (c.defaultValue === undefined)
            continue;
        out[c.key] = c.defaultValue === 'today' ? today : c.defaultValue;
    }
    return out;
}
