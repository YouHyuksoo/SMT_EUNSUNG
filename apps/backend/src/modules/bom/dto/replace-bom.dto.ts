import { Type } from 'class-transformer';
import {
  IsInt, IsISO8601, IsNotEmpty, IsNumber, IsOptional, IsString, Max, Min,
} from 'class-validator';

/** 관리 모드 — SET 품목의 BOM 전개 (PKG_DESIGN.BOM_QUERY) */
export class BomExpandQueryDto {
  @IsString() @IsNotEmpty() setItemCode!: string;
  /** 기준일자 (PB uo_start). 없으면 오늘 */
  @IsOptional() @IsISO8601() dateset?: string;
}

/** 목록 모드 — 등록된 대체품 조회 (PB d_des_item_replace_lst) */
export class ReplaceListQueryDto {
  @IsOptional() @IsString() setItemCode?: string;
  @IsOptional() @IsString() childItemCode?: string;
  @IsOptional() @IsString() replaceItemCode?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 대체품 등록/수정 — ID_ITEM_REPLACE.
 * PARENT/CHILD/ITEM_UNIT_QTY/WORKSTAGE_CODE 는 PB 에서 선택한 BOM 구성품 행에서 복사된다.
 * 화면이 BOM 전개 행 선택 후에만 등록을 허용하므로 모두 필수다.
 */
export class ReplaceUpsertDto {
  @IsString() @IsNotEmpty() parentItemCode!: string;
  @IsString() @IsNotEmpty() childItemCode!: string;
  @IsString() @IsNotEmpty() replaceItemCode!: string;
  @IsString() @IsNotEmpty() workstageCode!: string;
  @Type(() => Number) @IsNumber() itemUnitQty!: number;
  @IsOptional() @IsISO8601() dateset?: string;
  @IsOptional() @IsISO8601() dateend?: string;
  @IsOptional() @Type(() => Number) @IsNumber() itemUnitQtyExt?: number;
  @IsOptional() @IsString() bomLocationCode?: string;
}

/** 대체품 삭제 — PK(PARENT, CHILD, REPLACE, ORG) */
export class ReplaceDeleteDto {
  @IsString() @IsNotEmpty() parentItemCode!: string;
  @IsString() @IsNotEmpty() childItemCode!: string;
  @IsString() @IsNotEmpty() replaceItemCode!: string;
}
