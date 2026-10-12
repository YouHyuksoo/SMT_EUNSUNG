/**
 * @file src/modules/planning/smd-actual.dto.ts
 * @description 반제품생산실적관리 DTO — PB w_pln_assembly_actual_master
 *
 * 키는 RECEIPT_DATE + RECEIPT_SEQUENCE + ORGANIZATION_ID 다
 * (XPK 상당 유일인덱스). RECEIPT_DATE 는 **시각까지 있는 DATE** 라
 * 문자열로 왕복시키면 시간대가 밀린다 — 조회는 날짜 범위로 받고,
 * 수정·삭제는 `YYYYMMDDHH24MISS` 불투명 키로 받는다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Length,
  Matches,
  Min,
} from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;
const TS14 = /^\d{14}$/;

export class SmdActualQueryDto {
  @ApiProperty({ description: '집계일시 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '집계일시 끝 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: '공정코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  workstageCode?: string;
}

export class SmdActualKeyDto {
  @ApiProperty({
    description: '집계일시 불투명 키 (YYYYMMDDHH24MISS). 서버가 내려준 값을 그대로 돌려보낸다.',
  })
  @IsString() @Matches(TS14, { message: 'receiptDateKey 는 14자리 숫자여야 합니다.' })
  receiptDateKey!: string;

  @ApiProperty({ description: '집계순번' })
  @Type(() => Number) @IsInt() @Min(0)
  receiptSequence!: number;
}

/**
 * 수정 — PB 는 실적수량과 보정수량만 고치게 했다.
 * 센서가 올린 원시값(ORIGIN_COUNT)은 바꾸지 않는다 — 그것을 고치면
 * 센서 이력과 화면 값이 갈려 원인 추적이 불가능해진다.
 */
export class SmdActualUpdateDto extends SmdActualKeyDto {
  @ApiProperty({ description: '생산실적수량' })
  @Type(() => Number) @IsNumber() @Min(0)
  productActualQty!: number;

  @ApiPropertyOptional({ description: '보정수량 (음수 가능)' })
  @IsOptional() @Type(() => Number) @IsNumber()
  adjustQty?: number;
}
