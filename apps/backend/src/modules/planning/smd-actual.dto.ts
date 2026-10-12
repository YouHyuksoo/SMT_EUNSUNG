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
  IsIn,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Length,
  Matches,
  Min,
} from 'class-validator';
import { SMD_SHIFT_SLOTS, type SmdShiftSlot } from '../../entities/smd-shift-manual.entity';

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

/** 계획별 주야 실적 조회 — 반제품생산계획(IP_PRODUCT_SMD_PLAN) 계획일 기준. */
export class SmdShiftActualQueryDto {
  @ApiProperty({ description: '계획일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '계획일 끝 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;
}

/** 반제품생산계획 키 — PLAN_DATE + PLAN_SEQUENCE (+ ORGANIZATION_ID 는 토큰에서). */
export class SmdShiftPlanKeyDto {
  @ApiProperty({ description: '계획일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  planDate!: string;

  @ApiProperty({ description: '계획순번' })
  @Type(() => Number) @IsInt() @Min(0)
  planSequence!: number;
}

/**
 * 수기실적 저장 — 주간·야간을 한 번에 받는다.
 * 값이 비어 있으면(null/생략) 그 근무조 수기실적을 지워 자동 집계로 돌린다.
 */
export class SmdShiftManualSaveDto extends SmdShiftPlanKeyDto {
  @ApiPropertyOptional({ description: '주간 수기 실적수량. 비우면 주간 수기실적을 지운다.', nullable: true })
  @IsOptional() @Type(() => Number) @IsInt() @Min(0)
  dayManualQty?: number | null;

  @ApiPropertyOptional({ description: '야간 수기 실적수량. 비우면 야간 수기실적을 지운다.', nullable: true })
  @IsOptional() @Type(() => Number) @IsInt() @Min(0)
  nightManualQty?: number | null;
}

/** 수기실적 삭제 — 근무조를 비우면 주간·야간 둘 다 지운다. */
export class SmdShiftManualDeleteDto extends SmdShiftPlanKeyDto {
  @ApiPropertyOptional({ description: '근무조 (DAY=주간, NIGHT=야간). 비우면 둘 다.', enum: SMD_SHIFT_SLOTS })
  @IsOptional() @IsIn(SMD_SHIFT_SLOTS)
  shiftSlot?: SmdShiftSlot;
}
