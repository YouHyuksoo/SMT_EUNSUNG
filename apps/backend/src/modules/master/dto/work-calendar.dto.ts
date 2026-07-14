/**
 * @file src/modules/master/dto/work-calendar.dto.ts
 * @description 생산월력(IP_ 모델) DTO
 *
 * 초보자 가이드:
 * 1. lineCode가 없으면 전사 월력(IP_PRODUCT_COMPANY_CALENDAR), 있으면 라인 예외(IP_PRODUCT_LINE_CALENDAR).
 * 2. HOLIDAY_YN은 클라이언트가 보내지 않는다 — dayType에서 서버가 파생시킨다.
 */
import { ApiProperty, ApiPropertyOptional, OmitType, PartialType } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsArray,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateNested,
  IsBoolean,
} from 'class-validator';

export const WORK_DAY_TYPES = ['WORK', 'OFF', 'HALF', 'SPECIAL'] as const;

export class WorkCalendarDaysQueryDto {
  @ApiProperty({ description: '조회 월 (YYYY-MM)', example: '2026-07' })
  @Matches(/^\d{4}-\d{2}$/, { message: 'month는 YYYY-MM 형식이어야 합니다.' })
  month: string;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;
}

export class WorkCalendarDayItemDto {
  @ApiProperty({ description: '일자 (YYYY-MM-DD)', example: '2026-07-14' })
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'workDate는 YYYY-MM-DD 형식이어야 합니다.' })
  workDate: string;

  @ApiProperty({ description: '근무유형', enum: WORK_DAY_TYPES })
  @IsIn(WORK_DAY_TYPES as unknown as string[])
  dayType: string;

  @ApiPropertyOptional({ description: '휴무사유 (dayType=OFF일 때만 유효)' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  offReason?: string | null;

  @ApiPropertyOptional({ description: '근무분. 미지정이면 교대시간 마스터에서 파생' })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(2880)
  workMinutes?: number;

  @ApiPropertyOptional({ description: '잔업분', default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(1440)
  otMinutes?: number;

  @ApiPropertyOptional({ description: '비고' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  comment?: string | null;
}

export class BulkUpdateDaysDto {
  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;

  @ApiProperty({ type: [WorkCalendarDayItemDto] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkCalendarDayItemDto)
  days: WorkCalendarDayItemDto[];
}

export class GenerateCalendarDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '토요일 근무 여부', default: false })
  @IsOptional()
  @IsBoolean()
  saturdayWork?: boolean;

  @ApiPropertyOptional({ description: '일요일 근무 여부', default: false })
  @IsOptional()
  @IsBoolean()
  sundayWork?: boolean;

  @ApiPropertyOptional({ description: '양력 고정공휴일 자동 반영', default: true })
  @IsOptional()
  @IsBoolean()
  applyHolidays?: boolean;
}

export class CopyFromCompanyDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiProperty({ description: '복사 대상 라인코드' })
  @IsString()
  @MaxLength(20)
  lineCode: string;
}

export class ConfirmDaysDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiPropertyOptional({ description: '대상 월 (1~12). 미지정이면 연 전체' })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(12)
  month?: number;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;
}

export class SummaryQueryDto {
  @ApiProperty({ description: '대상 연도 (YYYY)', example: '2026' })
  @Matches(/^\d{4}$/, { message: 'year는 YYYY 형식이어야 합니다.' })
  year: string;

  @ApiPropertyOptional({ description: '라인코드. 미지정이면 전사 월력' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;
}

// ─── 교대시간 마스터 ───

export class CreateShiftTimeDto {
  @ApiProperty({ description: '적용 시작일 (YYYY-MM-DD)', example: '2026-01-01' })
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'dateset은 YYYY-MM-DD 형식이어야 합니다.' })
  dateset: string;

  @ApiPropertyOptional({ description: '적용 종료일 (YYYY-MM-DD). 미지정이면 무기한' })
  @IsOptional()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'dateend는 YYYY-MM-DD 형식이어야 합니다.' })
  dateend?: string;

  @ApiPropertyOptional({ description: '주간 시작 (HH:MM)', example: '08:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'dayTimeStart는 HH:MM 형식이어야 합니다.' })
  dayTimeStart?: string;

  @ApiPropertyOptional({ description: '주간 종료 (HH:MM)', example: '20:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'dayTimeEnd는 HH:MM 형식이어야 합니다.' })
  dayTimeEnd?: string;

  @ApiPropertyOptional({ description: '주간 휴식(분)', default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  dayBreakMinutes?: number;

  @ApiPropertyOptional({ description: '야간 시작 (HH:MM)', example: '20:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'nightTimeStart는 HH:MM 형식이어야 합니다.' })
  nightTimeStart?: string;

  @ApiPropertyOptional({ description: '야간 종료 (HH:MM)', example: '08:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'nightTimeEnd는 HH:MM 형식이어야 합니다.' })
  nightTimeEnd?: string;

  @ApiPropertyOptional({ description: '야간 휴식(분)', default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  nightBreakMinutes?: number;
}

export class UpdateShiftTimeDto extends PartialType(OmitType(CreateShiftTimeDto, ['dateset'] as const)) {}
