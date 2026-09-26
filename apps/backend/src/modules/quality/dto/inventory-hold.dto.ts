import { Type } from 'class-transformer';
import {
  ArrayMaxSize, ArrayNotEmpty, IsArray, IsDateString, IsIn, IsInt, IsNumber,
  IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/**
 * 재고통제 대상 조회 — PB d_mat_item_inventory_hold_lst.
 *
 * `IM_ITEM_INVENTORY` 는 180만 행이고 인덱스는 ITEM_CODE · MATERIAL_MFS 다.
 * 조건 없이 훑으면 무겁기 때문에 둘 중 하나를 요구한다.
 */
export class InventoryHoldTargetQueryDto {
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() materialMfs?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 인덱스가 있어 단독으로 조회를 좁힐 수 있는 조건 */
export const INVENTORY_HOLD_REQUIRED_FILTERS = ['itemCode', 'materialMfs'] as const;

/** 통제(홀딩)된 LOT 목록 — PB d_mat_inventory_4_lot_blocking */
export class InventoryHoldListQueryDto {
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() materialMfs?: string;
  @IsOptional() @IsString() inventoryStatus?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 재고통제 등록·해제.
 * 통제하면 IM_ITEM_INVENTORY_HOLD 에 행을 만들고, 해제하면 그 행을 지운다 — PB 와 같다.
 */
export class InventoryHoldApplyDto {
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(1000)
  materialMfsList!: Array<{ itemCode: string; materialMfs: string }>;

  /** 'B' 불량 / 'G' 양품 */
  @IsIn(['B', 'G']) inventoryStatus!: 'B' | 'G';
  @IsOptional() @IsString() comments?: string;
}

export class InventoryHoldReleaseDto {
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(1000)
  materialMfsList!: Array<{ itemCode: string; materialMfs: string }>;
}

/** OQC 검사이력 조회 (PID) — PB d_iq_oqc_insepct_history */
export class OqcHistoryQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() productId?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() inspectResult?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * OQC 검사이력 조회 (LOT) — PB d_prd_cell_biz_pack_4_oqc_master.
 * 매거진 포장 단위(PACK_TYPE='M', DIVIDE_FLAG='N')만 본다 — PB 조건 그대로다.
 */
export class OqcLotQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() packBarcode?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** OQC 검사이력 등록 */
export class OqcHistoryCreateDto {
  @IsString() @Length(1, 60) productId!: string;

  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() modelSuffix?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() defectCode?: string;
  @IsOptional() @IsString() inspectType?: string;
  @IsOptional() @IsString() inspectResult?: string;
  @IsOptional() @IsString() badReasonCode?: string;
  @IsOptional() @IsString() badReasonDivision?: string;
  @IsOptional() @IsString() badReasonResult?: string;
  @IsOptional() @IsString() inspector?: string;
  @IsOptional() @IsString() inspectorName?: string;
  @IsOptional() @IsString() comments?: string;

  @IsOptional() @Type(() => Number) @IsNumber() inspectQty?: number;
  @IsOptional() @Type(() => Number) @IsNumber() defectQty?: number;
}

/** OQC 검사이력 삭제 — PB 도 행을 바로 지웠다 */
export class OqcHistoryKeyDto {
  @IsDateString() inspectDate!: string;
  @Type(() => Number) @IsNumber() inspectSequence!: number;
}
