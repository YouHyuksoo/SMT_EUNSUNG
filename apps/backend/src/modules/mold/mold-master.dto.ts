import { Type } from 'class-transformer';
import {
  IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** S-PARTS 마스터 조회 — PB d_mcn_mold_lst_tree 의 retrieve 인자와 1:1 */
export class MoldMasterQueryDto {
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() moldGroup?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * S-PARTS 등록·수정 본문.
 * 감사컬럼(ORGANIZATION_ID / ENTER_BY / ENTER_DATE / LAST_MODIFY_BY / LAST_MODIFY_DATE)은
 * 본문으로 받지 않는다 — PB f_set_security_row 가 하던 일을 서버가 대신 채운다.
 */
export class MoldMasterUpsertDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @IsString() @Length(1, 100) moldName!: string;

  @IsOptional() @IsString() moldGroup?: string;
  @IsOptional() @IsString() moldSpec?: string;
  @IsOptional() @IsString() moldUom?: string;
  @IsOptional() @IsString() moldType?: string;
  @IsOptional() @IsString() moldLineType?: string;
  @IsOptional() @IsString() drawingNo?: string;
  @IsOptional() @IsString() rawMaterial?: string;
  @IsOptional() @IsString() punchNo?: string;
  @IsOptional() @IsString() nationCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() barcode?: string;
  @IsOptional() @IsString() comments?: string;
  @IsOptional() @IsString() gasYn?: string;
  @IsOptional() @IsString() autoReceiptYn?: string;

  @IsOptional() @Type(() => Number) @IsNumber() safetyInventory?: number;
  @IsOptional() @Type(() => Number) @IsNumber() orderLeadtime?: number;
  @IsOptional() @Type(() => Number) @IsNumber() itemUnitQty?: number;
  @IsOptional() @Type(() => Number) @IsNumber() cycleTime?: number;
  @IsOptional() @Type(() => Number) @IsNumber() machineCapacity?: number;
  @IsOptional() @Type(() => Number) @IsNumber() itemGasQty?: number;
}

/** 단건 지정 — 연쇄삭제·BOM·재고 조회에 함께 쓴다 */
export class MoldCodeDto {
  @IsString() @Length(1, 30) moldCode!: string;
}

/** BOM(소요품목) 조회 — PB d_mcn_mold_bill_lst */
export class MoldBillQueryDto {
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() itemCode?: string;
}
