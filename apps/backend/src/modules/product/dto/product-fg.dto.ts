/**
 * @file src/modules/product/dto/product-fg.dto.ts
 * @description 302 · 304 · 307 · 308 제품 입고·출하 입력 규칙.
 *
 * **`cancel` 이 `p_txn` 을 정한다.** 입고 1/2, 출고 3/4 — 정상과 취소가 같은
 * 프로시저의 다른 코드다. 화면은 참/거짓만 보내고 코드는 서비스가 붙인다.
 */
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsDateString,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

export class FgReceiptQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() barcode?: string;
  /** `'1'` 입고 · `'2'` 입고취소. 비우면 전체. */
  @IsOptional() @IsString() txnDeficit?: string;
}

export class FgIssueQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() barcode?: string;
  @IsOptional() @IsString() customerCode?: string;
}

export class FgIssuableQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() barcode?: string;
  @IsOptional() @IsString() modelName?: string;
  /** PB 고정값은 제품창고 `'P01'` 이다. */
  @IsOptional() @IsString() locationCode?: string;
}

export class FgReceiptDto {
  /** 박스 바코드. */
  @IsString() @IsNotEmpty() barcode!: string;
  @IsString() @IsNotEmpty() locationCode!: string;
  @IsOptional() @IsBoolean() cancel?: boolean;
}

export class FgModelReceiptDto {
  /** 모델 바코드. */
  @IsString() @IsNotEmpty() barcode!: string;
  @Type(() => Number) @IsInt() @Min(1) qty!: number;
  @IsString() @IsNotEmpty() locationCode!: string;
  @IsOptional() @IsBoolean() cancel?: boolean;
}

export class FgIssueDto {
  @IsString() @IsNotEmpty() barcode!: string;
  /** PB `p_bar_type` — `'I'` 개별 박스 · `'P'` 파렛트. 이 현장은 파렛트를 쓰지 않는다. */
  @IsOptional() @IsIn(['I', 'P']) barType?: 'I' | 'P';
  @IsString() @IsNotEmpty() customerCode!: string;
  @IsString() @IsNotEmpty() locationCode!: string;
  @IsOptional() @IsBoolean() cancel?: boolean;
}

export class FgModelIssueDto {
  @IsString() @IsNotEmpty() barcode!: string;
  @Type(() => Number) @IsInt() @Min(1) qty!: number;
  @IsString() @IsNotEmpty() locationCode!: string;
  @IsOptional() @IsBoolean() cancel?: boolean;
}
