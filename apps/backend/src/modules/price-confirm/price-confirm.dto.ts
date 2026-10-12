/**
 * @file src/modules/price-confirm/price-confirm.dto.ts
 * @description 단가승인 3화면 공용 DTO
 *              PB w_mat_buy_price_confirm / w_sal_sale_price_confirm
 *                 w_mcn_mold_buy_price_confirm
 *
 * 세 화면이 테이블만 다르고 승인 방식이 같다 —
 * PRICE_CHANGE_CONFIRM_YN 을 'Y'/'N' 으로 바꾸고 CONFIRM_BY·CONFIRM_DATE 를
 * 함께 채우거나 비운다. 키 컬럼 구성만 테이블별로 다르다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  IsArray,
  IsIn,
  IsOptional,
  IsString,
  Length,
  Matches,
  ValidateNested,
} from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

export class PriceConfirmQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({
    description: '거래처코드 (구매·S-PARTS 는 공급처, 판매는 고객). 앞부분 일치',
  })
  @IsOptional() @IsString() @Length(0, 30)
  partnerCode?: string;

  @ApiPropertyOptional({
    description: "승인상태: 'Y' 승인됨 | 'N' 미승인 | 비우면 전부. PB arg_confirm_status",
  })
  @IsOptional() @IsIn(['Y', 'N'])
  confirmStatus?: 'Y' | 'N';

  @ApiPropertyOptional({ description: '적용 시작일 이후 (YYYY-MM-DD)' })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  dateFrom?: string;

  @ApiPropertyOptional({ description: '적용 시작일 이전 (YYYY-MM-DD)' })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  dateTo?: string;
}

/**
 * 단가 한 건의 키.
 *
 * 테이블마다 키 컬럼이 다르다 — 실측 유일인덱스:
 *   IM_ITEM_UNIT_PRICE    DATESET + ITEM_CODE + SUPPLIER_CODE + LINE_TYPE + ORG
 *   IS_PRODUCT_SALE_PRICE CUSTOMER_CODE + ITEM_CODE + PRODUCT_LINE_TYPE + DATESET + ORG
 *   IMCN_MOLD_UNIT_PRICE  DATESET + MOLD_CODE + SUPPLIER_CODE + ORG
 * 공통 필드로 받고 서비스가 자기 테이블의 키로 조립한다.
 * **lineType 을 빠뜨리면 같은 품목·공급처의 다른 라인유형 단가까지 승인된다.**
 */
export class PriceConfirmKeyDto {
  @ApiProperty({ description: '품목코드 (S-PARTS 는 S-PARTS 코드)' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({ description: '거래처코드 (공급처 또는 고객)' })
  @IsString() @Length(1, 30)
  partnerCode!: string;

  @ApiProperty({ description: '적용 시작일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateSet!: string;

  @ApiPropertyOptional({
    description: '라인유형. 구매·판매 단가는 키의 일부라 반드시 넘긴다 (S-PARTS 는 키가 아니다).',
  })
  @IsOptional() @IsString() @Length(0, 10)
  lineType?: string;
}

/**
 * 승인·승인취소 — PB 는 체크한 행을 한꺼번에 처리했다 (cb_confirm / cb_cancel).
 * 한 건씩 왕복하면 수십 건을 누르는 동안 화면이 멈춘다.
 */
export class PriceConfirmApplyDto {
  @ApiProperty({ description: '대상 단가 목록 (최대 500건)', type: [PriceConfirmKeyDto] })
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(500)
  @ValidateNested({ each: true }) @Type(() => PriceConfirmKeyDto)
  keys!: PriceConfirmKeyDto[];

  @ApiProperty({ description: "'Y' 승인 / 'N' 승인취소" })
  @IsIn(['Y', 'N'])
  confirmYn!: 'Y' | 'N';
}
