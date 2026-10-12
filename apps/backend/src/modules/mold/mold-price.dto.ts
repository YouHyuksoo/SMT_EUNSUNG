import { Type } from 'class-transformer';
import {
  IsDateString, IsIn, IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** S-PARTS 구매단가 조회 — PB d_mcn_mold_buy_price_lst_tree 의 retrieve 인자와 1:1 */
export class MoldPriceQueryDto {
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
  /** PB 트리의 그룹 기준(FUTURE/RUNNING/EXPIRED)으로 좁힌다 */
  @IsOptional() @IsIn(['FUTURE', 'RUNNING', 'EXPIRED']) status?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 구매단가 등록·수정 본문.
 * 키는 적용일 + S-PARTS 코드 + 공급처 + ORGANIZATION_ID 다(XPKIMCN_MOLD_UNIT_PRICE).
 * 승인 관련 컬럼(CONFIRM_BY / CONFIRM_DATE / PRICE_CHANGE_CONFIRM_YN)은 본문으로 받지 않는다 —
 * 승인은 별도 화면(S-PARTS구매단가승인)의 일이다.
 */
export class MoldPriceUpsertDto {
  @IsDateString() dateset!: string;
  @IsString() @Length(1, 30) moldCode!: string;
  @IsString() @Length(1, 20) supplierCode!: string;

  @IsOptional() @IsDateString() dateend?: string;
  @IsOptional() @IsString() lineType?: string;
  @IsOptional() @IsString() delivery?: string;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() priceType?: string;
  @IsOptional() @IsString() approvalNo?: string;
  @IsOptional() @IsString() priceChangeReason?: string;

  @IsOptional() @Type(() => Number) @IsNumber() unitPrice?: number;
  @IsOptional() @Type(() => Number) @IsNumber() standardUnitPrice?: number;
  @IsOptional() @Type(() => Number) @IsNumber() taxRate?: number;
}

/** 단건 지정 (삭제) */
export class MoldPriceKeyDto {
  @IsDateString() dateset!: string;
  @IsString() @Length(1, 30) moldCode!: string;
  @IsString() @Length(1, 20) supplierCode!: string;
}

/** 단가행 일괄생성 — PB cb_1 */
export class MoldPriceGenerateDto {
  /** PB 는 로그인 세션의 기준통화를 썼다. 웹은 명시로 받는다. */
  @IsString() @Length(1, 10) currency!: string;
}

/** 공급처 일괄변경 — PB cb_2('Supplier Change') */
export class MoldPriceSupplierChangeDto {
  @IsString() @Length(1, 20) beforeSupplierCode!: string;
  @IsString() @Length(1, 20) afterSupplierCode!: string;
}
