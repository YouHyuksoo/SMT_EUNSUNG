/**
 * @file src/modules/product/dto/product-pack.dto.ts
 * @description 299 제품포장관리(PID) · 311 제품패킹이력 입력 규칙.
 */
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsDateString,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

export class PackQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() packBarcode?: string;
  @IsOptional() @IsString() modelName?: string;
  /** `'C'` Cell/Biz · `'M'` 매거진. 비우면 전체 (실측은 전부 `'C'`). */
  @IsOptional() @IsString() packType?: string;
}

export class PackSerialQueryDto {
  @IsString() @IsNotEmpty() packBarcode!: string;
}

export class PackHistoryQueryDto {
  /** PID 나 박스 바코드 중 하나는 반드시 넣는다 — 서비스가 막는다. */
  @IsOptional() @IsString() serialNo?: string;
  @IsOptional() @IsString() packBarcode?: string;
}

export class PackCreateDto {
  @IsString() @IsNotEmpty() modelName!: string;
  @IsOptional() @IsString() modelSuffix?: string;
  @IsString() @IsNotEmpty() itemCode!: string;
  @IsString() @IsNotEmpty() lineCode!: string;
  @IsString() @IsNotEmpty() workstageCode!: string;
  /** 박스 하나에 담을 개수. 바코드 번호에 들어간다. */
  @Type(() => Number) @IsInt() @Min(1) packUnitQty!: number;
}

export class PackScanDto {
  @IsString() @IsNotEmpty() packBarcode!: string;
  /** 기판 일련번호(PID). */
  @IsString() @IsNotEmpty() serialNo!: string;
  @IsString() @IsNotEmpty() lineCode!: string;
  @IsString() @IsNotEmpty() workstageCode!: string;
  @IsOptional() @IsString() masterBarcode?: string;
  /** PB `attr7` — 포장 담당자. */
  @IsOptional() @IsString() packCharger?: string;
  /** PB `attr8` — 검사 담당자. */
  @IsOptional() @IsString() qcCharger?: string;
}

export class PackCompleteDto {
  @IsString() @IsNotEmpty() packBarcode!: string;
  @IsOptional() @IsBoolean() confirm?: boolean;
}
