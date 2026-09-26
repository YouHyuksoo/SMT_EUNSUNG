/**
 * @file src/modules/smt/smt-pickup.dto.ts
 * @description 마운터 픽업정보관리 DTO — PB w_mcn_feeder_pickup_master
 *
 * PB 는 엑셀 시트를 DataWindow 에 올려 컬럼 위치(C02/C03/C32/C34)로 읽었다.
 * 웹은 파싱을 프론트에서 하고 여기로는 정규화된 행 배열을 받는다 —
 * 저장소에 이미 쓰는 엑셀 업로드 모달 방식과 같다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  IsArray,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Min,
  ValidateNested,
} from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

export class SmtPickupQueryDto {
  @ApiProperty({ description: '생산일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '생산일 끝 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  modelName?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '피더 ID (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  feederId?: string;
}

/** 엑셀 한 줄. PB DataWindow 의 C02/C03/C32/C34 에 해당한다. */
export class SmtPickupRowDto {
  @ApiProperty({ description: '피더 ID (PB C02)' })
  @IsString() @Length(1, 100)
  feederId!: string;

  @ApiPropertyOptional({ description: '피더 유형 (PB C03)' })
  @IsOptional() @IsString() @Length(0, 100)
  feederType?: string;

  @ApiPropertyOptional({ description: '품목코드' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiProperty({ description: '이송 횟수 (PB C32)' })
  @Type(() => Number) @IsInt() @Min(0)
  transferCount!: number;

  @ApiProperty({ description: '흡착 에러 횟수 (PB C34)' })
  @Type(() => Number) @IsInt() @Min(0)
  adsorptionErrorCount!: number;
}

export class SmtPickupUploadDto {
  @ApiProperty({ description: '생산일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  productDate!: string;

  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiPropertyOptional({ description: '모델명' })
  @IsOptional() @IsString() @Length(0, 50)
  modelName?: string;

  @ApiProperty({ description: '엑셀에서 읽은 행 (최대 5000)' })
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(5000)
  @ValidateNested({ each: true }) @Type(() => SmtPickupRowDto)
  rows!: SmtPickupRowDto[];
}

export class SmtPickupDeleteDto {
  @ApiProperty({ description: '생산일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  productDate!: string;

  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 20)
  lineCode!: string;
}
