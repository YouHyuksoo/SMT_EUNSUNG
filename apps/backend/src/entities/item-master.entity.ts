/**
 * @file item-master.entity.ts
 * @description 품목 마스터(ItemMaster) 엔티티 - 은성전장 ID_ITEM 테이블 매핑.
 *
 * ID_ITEM 109개 컬럼을 모두 매핑한다. 앞쪽 36개의 속성 이름은 다른 화면·모듈이 읽고 있어
 * 그대로 둔다 — 이름과 실제 컬럼 뜻이 다른 것이 있다 (rev=ABC_GRADE, markingText=BARCODE,
 * isSplittable=SET_ITEM_YN, imageUrl=FEEDER_LAYOUT_COMMENTS, tactTime=CAPACITY 등).
 * 컬럼 뜻은 packages/shared 의 ITEM_MASTER_COLUMNS 라벨을 본다.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
  Index,
} from 'typeorm';

@Entity({ name: 'ID_ITEM' })
@Index(['itemType'])
export class ItemMaster {
  @PrimaryColumn({ name: 'ITEM_CODE', length: 20 })
  itemCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ name: 'ITEM_NAME', length: 300 })
  itemName: string;

  @Column({ name: 'PART_NO', type: 'varchar2', length: 200, nullable: true })
  itemNo: string;

  @Column({ type: 'varchar2', name: 'CUSTOMER_PART_NO', length: 50, nullable: true })
  custPartNo: string | null;

  @Column({ name: 'ITEM_TYPE', length: 10 })
  itemType: string;

  @Column({ type: 'varchar2', name: 'ITEM_CLASS', length: 20 })
  itemClass: string;

  @Column({ type: 'varchar2', name: 'LINE_TYPE', length: 10 })
  lineType: string;

  @Column({ type: 'varchar2', name: 'ITEM_DIVISION', length: 30 })
  itemDivision: string;

  @Column({ type: 'varchar2', name: 'MODEL_NAME', length: 100, nullable: true })
  modelName: string | null;

  @Column({ type: 'varchar2', name: 'MODEL_SUFFIX', length: 50, nullable: true })
  modelSuffix: string | null;

  @Column({ type: 'varchar2', name: 'ITEM_SPEC', length: 300 })
  spec: string | null;

  @Column({ type: 'varchar2', name: 'ABC_GRADE', length: 1 })
  rev: string | null;

  @Column({ type: 'varchar2', name: 'BARCODE', length: 100, nullable: true })
  markingText: string | null;

  @Column({ name: 'ITEM_UOM', length: 3, default: 'EA' })
  itemUom: string;

  @Column({ type: 'varchar2', name: 'MODEL_COLOR', length: 20, nullable: true })
  color: string | null;

  @Column({ type: 'varchar2', name: 'DRAWING_NO', length: 30, nullable: true })
  drawNo: string | null;

  @Column({ name: 'MANUFACTURE_LEADTIME', type: 'number', nullable: true })
  leadTime: number;

  @Column({ name: 'SAFETY_INVENTORY', type: 'number', nullable: true })
  safetyStock: number;

  @Column({ name: 'MATERIAL_QTY', type: 'number', nullable: true })
  lotUnitQty: number | null;

  @Column({ name: 'ISSUE_PACKING_QTY', type: 'number', nullable: true })
  boxQty: number;

  @Column({ name: 'MATERIAL_QTY2', type: 'number', nullable: true })
  minPackQty: number;

  @Column({ name: 'CAPACITY', type: 'number', nullable: true })
  tactTime: number;

  @Column({ name: 'LIFE_CYCLE', type: 'number', nullable: true })
  expiryDate: number;

  @Column({ name: 'MSL_MAX_TIME', type: 'number', nullable: true })
  expiryExtDays: number;

  @Column({ name: 'WORK_BAD_RATE', type: 'number', nullable: true })
  toleranceRate: number; // 작업불량율 (%) — NUMBER(3,1)

  @Column({ name: 'SET_ITEM_YN', length: 1, nullable: true })
  isSplittable: string; // 세트품목구분 — 기준코드 SET ITEM YN (M MATERIAL / N 부품 / Y 세트)

  @Column({ type: 'number', name: 'CARRIER_SIZE', nullable: true })
  packUnit: number | null; // 연배열수 (1 / 2 / 4 / 8)

  @Column({ type: 'varchar2', name: 'LOCATION_ADDRESS', length: 20, nullable: true })
  storageLocation: string | null;

  @Column({ type: 'varchar2', name: 'FEEDER_LAYOUT_COMMENTS', length: 2000, nullable: true })
  imageUrl: string | null;

  @Column({ type: 'varchar2', name: 'COMMENTS', length: 1000, nullable: true })
  remark: string | null;

  @Column({ name: 'MES_DISPLAY_YN', length: 1, nullable: true })
  mesDisplayYn: string;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  createdAt: Date;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  updatedAt: Date;

  // ── 아래는 품목마스터 화면이 모든 컬럼을 다루도록 추가한 컬럼 (packages/shared master/item-master-columns.ts) ──

  /** 가입고 */
  @Column({ type: 'varchar2', name: 'VIRTUAL_RECEIPT_YN', length: 1, nullable: true })
  virtualReceiptYn: string | null;

  /** 라우팅번호 */
  @Column({ type: 'varchar2', name: 'ROUTE_NO', length: 20, nullable: true })
  routeNo: string | null;

  /** 재료 */
  @Column({ type: 'varchar2', name: 'RAW_MATERIAL', length: 20, nullable: true })
  rawMaterial: string | null;

  /** 인수인계단위 */
  @Column({ type: 'varchar2', name: 'TRANSFER_UOM', length: 20, nullable: true })
  transferUom: string | null;

  /** 발주주기 */
  @Column({ type: 'varchar2', name: 'ORDER_CYCLE', length: 10, nullable: true })
  orderCycle: string | null;

  /** 발주조건 */
  @Column({ type: 'varchar2', name: 'ORDER_RULE', length: 10, nullable: true })
  orderRule: string | null;

  /** 세관 HS코드 */
  @Column({ type: 'varchar2', name: 'HS_CODE', length: 20, nullable: true })
  hsCode: string | null;

  /** 서비스코드 */
  @Column({ type: 'varchar2', name: 'SVC_CODE', length: 10, nullable: true })
  svcCode: string | null;

  /** 길이 */
  @Column({ type: 'number', name: 'LENGTH', nullable: true })
  length: number | null;

  /** 시작일자 */
  @Column({ type: 'date', name: 'DATESET', nullable: true })
  dateset: Date | null;

  /** 종료일자 */
  @Column({ type: 'date', name: 'DATEEND', nullable: true })
  dateend: Date | null;

  /** 특성 */
  @Column({ type: 'varchar2', name: 'SPECIAL_PROPERTY', length: 30, nullable: true })
  specialProperty: string | null;

  /** 겹치기 */
  @Column({ type: 'number', name: 'LAYER', nullable: true })
  layer: number | null;

  /** 높이 */
  @Column({ type: 'number', name: 'HEIGHT', nullable: true })
  height: number | null;

  /** 중량 */
  @Column({ type: 'number', name: 'WEIGHT', nullable: true })
  weight: number | null;

  /** 경사도 */
  @Column({ type: 'number', name: 'GRADIENT', nullable: true })
  gradient: number | null;

  /** 밀도 */
  @Column({ type: 'number', name: 'DENSITY', nullable: true })
  density: number | null;

  /** 내경 */
  @Column({ type: 'number', name: 'INNER_DIAMETER', nullable: true })
  innerDiameter: number | null;

  /** 외경 */
  @Column({ type: 'number', name: 'OUTER_DIAMETER', nullable: true })
  outerDiameter: number | null;

  /** 폭 */
  @Column({ type: 'number', name: 'WIDTH', nullable: true })
  width: number | null;

  /** 세관품목명 */
  @Column({ type: 'varchar2', name: 'HS_NAME', length: 100, nullable: true })
  hsName: string | null;

  /** 세관규격 */
  @Column({ type: 'varchar2', name: 'HS_SPEC', length: 100, nullable: true })
  hsSpec: string | null;

  /** 세관 스크랩 HS코드 */
  @Column({ type: 'varchar2', name: 'HS_CODE_SCRAP', length: 20, nullable: true })
  hsCodeScrap: string | null;

  /** 세관 스크랩명 */
  @Column({ type: 'varchar2', name: 'HS_NAME_SCRAP', length: 100, nullable: true })
  hsNameScrap: string | null;

  /** 세관 스크랩규격 */
  @Column({ type: 'varchar2', name: 'HS_SPEC_SCRAP', length: 100, nullable: true })
  hsSpecScrap: string | null;

  /** 이동여부 */
  @Column({ type: 'varchar2', name: 'TRANSFER_YN', length: 1, nullable: true })
  transferYn: string | null;

  /** 라인 */
  @Column({ type: 'varchar2', name: 'LINE_CODE', length: 20, nullable: true })
  lineCode: string | null;

  /** 세율 */
  @Column({ type: 'number', name: 'TARIFF_RATE', nullable: true })
  tariffRate: number | null;

  /** 공급상/제작처 */
  @Column({ type: 'varchar2', name: 'SUPPLIER_CODE', length: 20, nullable: true })
  supplierCode: string | null;

  /** 고객 */
  @Column({ type: 'varchar2', name: 'CUSTOMER_CODE', length: 20, nullable: true })
  customerCode: string | null;

  /** 자동출고 */
  @Column({ type: 'varchar2', name: 'AUTO_ISSUE_YN', length: 1, nullable: true })
  autoIssueYn: string | null;

  /** 자동입고 */
  @Column({ type: 'varchar2', name: 'AUTO_RECEIPT_YN', length: 1, nullable: true })
  autoReceiptYn: string | null;

  /** 자동출고계획 */
  @Column({ type: 'varchar2', name: 'AUTO_ISSUE_PLAN_YN', length: 1, nullable: true })
  autoIssuePlanYn: string | null;

  /** 구매단가 */
  @Column({ type: 'number', name: 'BUY_PRICE', nullable: true })
  buyPrice: number | null;

  /** 판매단가 */
  @Column({ type: 'number', name: 'SALE_PRICE', nullable: true })
  salePrice: number | null;

  /** 판매단가 적용유형 */
  @Column({ type: 'varchar2', name: 'SALE_PRICE_APPLY_TYPE', length: 1, nullable: true })
  salePriceApplyType: string | null;

  /** 총중량 */
  @Column({ type: 'number', name: 'GROSS_WEIGHT', nullable: true })
  grossWeight: number | null;

  /** CBM */
  @Column({ type: 'number', name: 'CBM', nullable: true })
  cbm: number | null;

  /** 바코드2 */
  @Column({ type: 'varchar2', name: 'BARCODE2', length: 100, nullable: true })
  barcode2: string | null;

  /** EHMS 대상 */
  @Column({ type: 'varchar2', name: 'EHMS_YN', length: 1, nullable: true })
  ehmsYn: string | null;

  /** EHMS 상태 */
  @Column({ type: 'varchar2', name: 'EHMS_STATUS', length: 1, nullable: true })
  ehmsStatus: string | null;

  /** 자재유형 */
  @Column({ type: 'varchar2', name: 'MATERIAL_TYPE', length: 10, nullable: true })
  materialType: string | null;

  /** 구매그룹 */
  @Column({ type: 'varchar2', name: 'PURCHASE_GROUP', length: 10, nullable: true })
  purchaseGroup: string | null;

  /** 팬텀코드 */
  @Column({ type: 'varchar2', name: 'PHANTOM_CODE', length: 1, nullable: true })
  phantomCode: string | null;

  /** 공급유형 */
  @Column({ type: 'varchar2', name: 'SUPPLY_TYPE', length: 1, nullable: true })
  supplyType: string | null;

  /** 세관 판매모델명 */
  @Column({ type: 'varchar2', name: 'HS_NAME_SALE', length: 100, nullable: true })
  hsNameSale: string | null;

  /** 밴더코드 */
  @Column({ type: 'varchar2', name: 'VENDOR_CODE', length: 20, nullable: true })
  vendorCode: string | null;

  /** MSL 레벨 */
  @Column({ type: 'varchar2', name: 'MSL_LEVEL', length: 10, nullable: true })
  mslLevel: string | null;

  /** 거래처 바코드 체크 */
  @Column({ type: 'varchar2', name: 'CHECK_SUPPLIER_BARCODE', length: 1, nullable: true })
  checkSupplierBarcode: string | null;

  /** 신규품목 */
  @Column({ type: 'varchar2', name: 'IS_NEW_YN', length: 1, nullable: true })
  isNewYn: string | null;

  /** 솔더타입 */
  @Column({ type: 'varchar2', name: 'SOLDER_TYPE', length: 1, nullable: true })
  solderType: string | null;

  /** 솔더 개봉 제한시간 */
  @Column({ type: 'number', name: 'SOLDER_OPEN_LIMIT_TIME', nullable: true })
  solderOpenLimitTime: number | null;

  /** 솔더 교반시간 */
  @Column({ type: 'number', name: 'SOLDER_AGITATION_TIME', nullable: true })
  solderAgitationTime: number | null;

  /** 시방 체크 */
  @Column({ type: 'varchar2', name: 'ECO_CHECK_YN', length: 1, nullable: true })
  ecoCheckYn: string | null;

  /** 시방 체크 설명 */
  @Column({ type: 'varchar2', name: 'ECO_CHECK_COMMENTS', length: 1000, nullable: true })
  ecoCheckComments: string | null;

  /** 고객 모델명 */
  @Column({ type: 'varchar2', name: 'CUSTOMER_MODEL_NAME', length: 100, nullable: true })
  customerModelName: string | null;

  /** 피더 사이즈 */
  @Column({ type: 'varchar2', name: 'FEEDER_SIZE', length: 50, nullable: true })
  feederSize: string | null;

  /** 입고 롯트 체크 */
  @Column({ type: 'varchar2', name: 'RECEIPT_LOT_CHECK_YN', length: 1, nullable: true })
  receiptLotCheckYn: string | null;

  /** 자재수량3 */
  @Column({ type: 'number', name: 'MATERIAL_QTY3', nullable: true })
  materialQty3: number | null;

  /** 주요품목 */
  @Column({ type: 'varchar2', name: 'KEYITEM_YN', length: 1, nullable: true })
  keyitemYn: string | null;

  /** 밴더코드1 */
  @Column({ type: 'varchar2', name: 'VENDOR_CODE1', length: 15, nullable: true })
  vendorCode1: string | null;

  /** 밴더코드2 */
  @Column({ type: 'varchar2', name: 'VENDOR_CODE2', length: 15, nullable: true })
  vendorCode2: string | null;

  /** 밴더코드3 */
  @Column({ type: 'varchar2', name: 'VENDOR_CODE3', length: 15, nullable: true })
  vendorCode3: string | null;

  /** 원공급상 체크 안 함 */
  @Column({ type: 'varchar2', name: 'NO_CHECK_ORIGIN_SUPPLIER', length: 1, nullable: true })
  noCheckOriginSupplier: string | null;

  /** 릴 교체 차단 */
  @Column({ type: 'varchar2', name: 'REEL_CHANGE_BLOCKED', length: 1, nullable: true })
  reelChangeBlocked: string | null;

  /** PCB 코팅유형 */
  @Column({ type: 'varchar2', name: 'PCB_COATING_TYPE', length: 20, nullable: true })
  pcbCoatingType: string | null;

  /** PCB 코팅 최대일수 */
  @Column({ type: 'number', name: 'PCB_COATING_MAX_DAY', nullable: true })
  pcbCoatingMaxDay: number | null;

  /** PCB 개봉 후 작업완료 시간 */
  @Column({ type: 'number', name: 'PCB_WORKING_MAX_DAY', nullable: true })
  pcbWorkingMaxDay: number | null;

  /** 베이킹 관리시간 */
  @Column({ type: 'number', name: 'BAKING_TIME', nullable: true })
  bakingTime: number | null;

  /** 품번 구분자 */
  @Column({ type: 'varchar2', name: 'PARTNO_DIVIDE_MARKER', length: 20, nullable: true })
  partnoDivideMarker: string | null;

  /** 품번 시작위치 */
  @Column({ type: 'number', name: 'PARTNO_MARKER_START', nullable: true })
  partnoMarkerStart: number | null;

  /** 품번 끝위치 */
  @Column({ type: 'number', name: 'PARTNO_MARKER_END', nullable: true })
  partnoMarkerEnd: number | null;

  /** 베이킹 온도 */
  @Column({ type: 'number', name: 'BAKING_TEMPERATURE', nullable: true })
  bakingTemperature: number | null;
}
