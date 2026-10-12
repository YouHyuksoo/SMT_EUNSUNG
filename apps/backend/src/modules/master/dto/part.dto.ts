/**
 * @file src/modules/master/dto/part.dto.ts
 * @description ID_ITEM 품목 API DTO
 */

import { ApiProperty, ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { IsString, IsOptional, IsNumber, Max, MaxLength, IsIn, IsArray, IsNotEmpty, Matches } from 'class-validator';
import { Type, Transform } from 'class-transformer';
import { USE_YN_VALUES } from '@smt/shared';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

/**
 * 품목 등록·수정 — ID_ITEM 의 표시 전용(조직·등록/수정 이력·ROUTE_NO)을 뺀 모든 컬럼.
 * 컬럼 목록은 packages/shared ITEM_MASTER_COLUMNS 와 같다 (part.dto.spec.ts 가 확인).
 * 필수는 NOT NULL 이면서 서버 기본값이 없는 것만이다 (품목코드·품명·구입유형·품목구분).
 */
export class CreatePartDto {
  @ApiProperty({ description: "ID_ITEM.ITEM_CODE — 품목코드" })
  @IsNotEmpty()
  @IsString()
  @MaxLength(20)
  itemCode: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ITEM_SPEC — 규격" })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  spec?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ITEM_UOM — 단위" })
  @IsOptional()
  @IsString()
  @MaxLength(3)
  itemUom?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ITEM_CLASS — 품목분류" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  itemClass?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ITEM_TYPE — 품목유형" })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  itemType?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.VIRTUAL_RECEIPT_YN — 가입고" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  virtualReceiptYn?: string;

  @ApiProperty({ description: "ID_ITEM.ITEM_NAME — 품명" })
  @IsNotEmpty()
  @IsString()
  @MaxLength(300)
  itemName: string;

  @ApiProperty({ description: "ID_ITEM.LINE_TYPE — 구입유형" })
  @IsNotEmpty()
  @IsString()
  @MaxLength(10)
  lineType: string;

  @ApiPropertyOptional({ description: "ID_ITEM.BARCODE — 바코드" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  markingText?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ABC_GRADE — ABC 등급" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  rev?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.RAW_MATERIAL — 재료" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  rawMaterial?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.SAFETY_INVENTORY — 안전재고" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  safetyStock?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.WORK_BAD_RATE — 작업불량율(%)" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber({ maxDecimalPlaces: 1 })
  @Max(99.9)
  toleranceRate?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.TRANSFER_UOM — 인수인계단위" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  transferUom?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MANUFACTURE_LEADTIME — 제조리드타임" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  leadTime?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.ORDER_CYCLE — 발주주기" })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  orderCycle?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ORDER_RULE — 발주조건" })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  orderRule?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.HS_CODE — 세관 HS코드" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  hsCode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.SVC_CODE — 서비스코드" })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  svcCode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.CAPACITY — 용량" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  tactTime?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.LENGTH — 길이" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  length?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.DATESET — 시작일자" })
  @IsOptional()
  @Matches(DATE_ONLY, { message: "dateset 은 YYYY-MM-DD 형식이어야 합니다." })
  dateset?: string | null;

  @ApiPropertyOptional({ description: "ID_ITEM.DATEEND — 종료일자" })
  @IsOptional()
  @Matches(DATE_ONLY, { message: "dateend 은 YYYY-MM-DD 형식이어야 합니다." })
  dateend?: string | null;

  @ApiPropertyOptional({ description: "ID_ITEM.SET_ITEM_YN — 세트품목구분" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  isSplittable?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.SPECIAL_PROPERTY — 특성" })
  @IsOptional()
  @IsString()
  @MaxLength(30)
  specialProperty?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.LAYER — 겹치기" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  layer?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.PART_NO — 품번" })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  itemNo?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.HEIGHT — 높이" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  height?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.WEIGHT — 중량" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  weight?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.DRAWING_NO — 도면번호" })
  @IsOptional()
  @IsString()
  @MaxLength(30)
  drawNo?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.GRADIENT — 경사도" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  gradient?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.DENSITY — 밀도" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  density?: number | null;

  @ApiProperty({ description: "ID_ITEM.ITEM_DIVISION — 품목구분" })
  @IsNotEmpty()
  @IsString()
  @MaxLength(1)
  itemDivision: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ISSUE_PACKING_QTY — 포장수량" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  boxQty?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.INNER_DIAMETER — 내경" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  innerDiameter?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.OUTER_DIAMETER — 외경" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  outerDiameter?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.WIDTH — 폭" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  width?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.HS_NAME — 세관품목명" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  hsName?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.HS_SPEC — 세관규격" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  hsSpec?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.HS_CODE_SCRAP — 세관 스크랩 HS코드" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  hsCodeScrap?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.HS_NAME_SCRAP — 세관 스크랩명" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  hsNameScrap?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.HS_SPEC_SCRAP — 세관 스크랩규격" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  hsSpecScrap?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.TRANSFER_YN — 이동여부" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  transferYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.LINE_CODE — 라인" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.TARIFF_RATE — 세율" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  tariffRate?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.SUPPLIER_CODE — 공급상/제작처" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  supplierCode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.CUSTOMER_CODE — 고객" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  customerCode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MODEL_NAME — 모델명" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  modelName?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MODEL_SUFFIX — 모델서픽스" })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  modelSuffix?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.AUTO_ISSUE_YN — 자동출고" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  autoIssueYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.AUTO_RECEIPT_YN — 자동입고" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  autoReceiptYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.AUTO_ISSUE_PLAN_YN — 자동출고계획" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  autoIssuePlanYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.BUY_PRICE — 구매단가" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  buyPrice?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.SALE_PRICE — 판매단가" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  salePrice?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.SALE_PRICE_APPLY_TYPE — 판매단가 적용유형" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  salePriceApplyType?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.GROSS_WEIGHT — 총중량" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  grossWeight?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.CBM — CBM" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  cbm?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.BARCODE2 — 바코드2" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  barcode2?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.EHMS_YN — EHMS 대상" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  ehmsYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.EHMS_STATUS — EHMS 상태" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  ehmsStatus?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MATERIAL_TYPE — 자재유형" })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  materialType?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.PURCHASE_GROUP — 구매그룹" })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  purchaseGroup?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.PHANTOM_CODE — 팬텀코드" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  phantomCode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.SUPPLY_TYPE — 공급유형" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  supplyType?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MES_DISPLAY_YN — MES 사용" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  mesDisplayYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.LOCATION_ADDRESS — 자재위치" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  storageLocation?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MATERIAL_QTY — 자재수량" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  lotUnitQty?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.HS_NAME_SALE — 세관 판매모델명" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  hsNameSale?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.VENDOR_CODE — 밴더코드" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  vendorCode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MATERIAL_QTY2 — 자재수량2" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  minPackQty?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.MSL_LEVEL — MSL 레벨" })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  mslLevel?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.CHECK_SUPPLIER_BARCODE — 거래처 바코드 체크" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  checkSupplierBarcode?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MSL_MAX_TIME — MSL 자재관리시간" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  expiryExtDays?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.IS_NEW_YN — 신규품목" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  isNewYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.FEEDER_LAYOUT_COMMENTS — 피더 배치 설명" })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  imageUrl?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.SOLDER_TYPE — 솔더타입" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  solderType?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.SOLDER_OPEN_LIMIT_TIME — 솔더 개봉 제한시간" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  solderOpenLimitTime?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.SOLDER_AGITATION_TIME — 솔더 교반시간" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  solderAgitationTime?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.LIFE_CYCLE — 유효수명" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  expiryDate?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.ECO_CHECK_YN — 시방 체크" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  ecoCheckYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.ECO_CHECK_COMMENTS — 시방 체크 설명" })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  ecoCheckComments?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.CUSTOMER_MODEL_NAME — 고객 모델명" })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  customerModelName?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.CARRIER_SIZE — 연배열수" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  packUnit?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.FEEDER_SIZE — 피더 사이즈" })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  feederSize?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.RECEIPT_LOT_CHECK_YN — 입고 롯트 체크" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  receiptLotCheckYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.COMMENTS — 설명" })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  remark?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MATERIAL_QTY3 — 자재수량3" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  materialQty3?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.KEYITEM_YN — 주요품목" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  keyitemYn?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.VENDOR_CODE1 — 밴더코드1" })
  @IsOptional()
  @IsString()
  @MaxLength(15)
  vendorCode1?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.VENDOR_CODE2 — 밴더코드2" })
  @IsOptional()
  @IsString()
  @MaxLength(15)
  vendorCode2?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.VENDOR_CODE3 — 밴더코드3" })
  @IsOptional()
  @IsString()
  @MaxLength(15)
  vendorCode3?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.NO_CHECK_ORIGIN_SUPPLIER — 원공급상 체크 안 함" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  noCheckOriginSupplier?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.REEL_CHANGE_BLOCKED — 릴 교체 차단" })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  reelChangeBlocked?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.MODEL_COLOR — 모델 색상" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  color?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.PCB_COATING_TYPE — PCB 코팅유형" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  pcbCoatingType?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.PCB_COATING_MAX_DAY — PCB 코팅 최대일수" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  pcbCoatingMaxDay?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.CUSTOMER_PART_NO — 고객 품번" })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  custPartNo?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.PCB_WORKING_MAX_DAY — PCB 개봉 후 작업완료 시간" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  pcbWorkingMaxDay?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.BAKING_TIME — 베이킹 관리시간" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  bakingTime?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.PARTNO_DIVIDE_MARKER — 품번 구분자" })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  partnoDivideMarker?: string;

  @ApiPropertyOptional({ description: "ID_ITEM.PARTNO_MARKER_START — 품번 시작위치" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  partnoMarkerStart?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.PARTNO_MARKER_END — 품번 끝위치" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  partnoMarkerEnd?: number | null;

  @ApiPropertyOptional({ description: "ID_ITEM.BAKING_TEMPERATURE — 베이킹 온도" })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  bakingTemperature?: number | null;
}

export class UpdatePartDto extends PartialType(CreatePartDto) {}

export class PartQueryDto extends PaginationQueryDto {


  @ApiPropertyOptional({ description: 'ID_ITEM.ITEM_TYPE' })
  @IsOptional()
  @IsString()
  itemType?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.ITEM_TYPE 다중 필터 (콤마 구분)', example: 'T,S' })
  @IsOptional()
  @Transform(({ value }) =>
    typeof value === 'string'
      ? value.split(',').map((v) => v.trim()).filter(Boolean)
      : value,
  )
  @IsArray()
  itemTypes?: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.ITEM_DIVISION (F 제품 / W 반제품 / R 원자재)' })
  @IsOptional()
  @IsString()
  itemDivision?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.LINE_TYPE 구입유형' })
  @IsOptional()
  @IsString()
  lineType?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.ITEM_CLASS 품목분류' })
  @IsOptional()
  @IsString()
  itemClass?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.SET_ITEM_YN 세트품목구분 (M / N / Y)' })
  @IsOptional()
  @IsString()
  setItemYn?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.SUPPLIER_CODE 공급상' })
  @IsOptional()
  @IsString()
  supplierCode?: string;

  @ApiPropertyOptional({ description: 'ID_ITEM.CUSTOMER_CODE 고객' })
  @IsOptional()
  @IsString()
  customerCode?: string;

  @ApiPropertyOptional({ enum: USE_YN_VALUES })
  @IsOptional()
  @IsString()
  @IsIn([...USE_YN_VALUES])
  mesDisplayYn?: string;

}
