/**
 * @file src/modules/master/dto/work-calendar.dto.ts
 * @description 생산월력(IP_ 모델) DTO
 *
 * 초보자 가이드:
 * 1. lineCode가 없으면 전사 월력(IP_PRODUCT_COMPANY_CALENDAR), 있으면 라인 예외(IP_PRODUCT_LINE_CALENDAR).
 * 2. HOLIDAY_YN은 클라이언트가 보내지 않는다 — dayType에서 서버가 파생시킨다.
 * 3. shifts/breaks를 보내면 근무분도 서버가 파생시킨다(@smt/shared calendarWorkMinutes).
 *    두 배열은 그 일자의 전체 목록이다 — 보낸 내용으로 자식행을 통째로 교체한다.
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

export class CalendarShiftDto {
  @ApiProperty({ description: "교대조 코드 (공통코드 'SHIFT CODE')", example: 'A' })
  @IsString()
  @MaxLength(10)
  shiftCode: string;

  @ApiProperty({ description: '시작시각 (HH:MM)', example: '08:00' })
  @Matches(/^([01]\d|2[0-3]):[0-5]\d$/, { message: 'startTime은 HH:MM 형식이어야 합니다.' })
  startTime: string;

  @ApiProperty({ description: '종료시각 (HH:MM). 시작보다 이르면 자정을 넘긴 것으로 본다.', example: '20:00' })
  @Matches(/^([01]\d|2[0-3]):[0-5]\d$/, { message: 'endTime은 HH:MM 형식이어야 합니다.' })
  endTime: string;
}

export class CalendarBreakDto {
  @ApiProperty({ description: "비작업 분류 (공통코드 'BREAK TYPE')", example: 'REST' })
  @IsString()
  @MaxLength(20)
  breakType: string;

  @ApiProperty({ description: '비작업 분', example: 30 })
  @IsInt()
  @Min(0)
  @Max(1440)
  breakMinutes: number;
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

  @ApiPropertyOptional({ type: [CalendarShiftDto], description: '교대조별 작업시간. 이 일자의 전체 목록' })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CalendarShiftDto)
  shifts?: CalendarShiftDto[];

  @ApiPropertyOptional({ type: [CalendarBreakDto], description: '비작업 시간. 이 일자의 전체 목록' })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CalendarBreakDto)
  breaks?: CalendarBreakDto[];
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

export class ShiftTimeBreakDto {
  @ApiProperty({ description: "비작업 분류 (공통코드 'BREAK TYPE')", example: 'REST' })
  @IsString()
  @MaxLength(20)
  breakType: string;

  @ApiProperty({ description: '비작업 분', example: 30 })
  @IsInt()
  @Min(0)
  @Max(1440)
  breakMinutes: number;
}

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

  @ApiPropertyOptional({
    description: '주간 휴식(분). dayBreaks를 보내면 그 합으로 서버가 덮어쓴다(롤업).',
    default: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  dayBreakMinutes?: number;

  @ApiPropertyOptional({ type: [ShiftTimeBreakDto], description: '주간 비작업 시간 전체 목록' })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ShiftTimeBreakDto)
  dayBreaks?: ShiftTimeBreakDto[];

  @ApiPropertyOptional({ description: '야간 시작 (HH:MM)', example: '20:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'nightTimeStart는 HH:MM 형식이어야 합니다.' })
  nightTimeStart?: string;

  @ApiPropertyOptional({ description: '야간 종료 (HH:MM)', example: '08:00' })
  @IsOptional()
  @Matches(/^\d{2}:\d{2}$/, { message: 'nightTimeEnd는 HH:MM 형식이어야 합니다.' })
  nightTimeEnd?: string;

  @ApiPropertyOptional({
    description: '야간 휴식(분). nightBreaks를 보내면 그 합으로 서버가 덮어쓴다(롤업).',
    default: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  nightBreakMinutes?: number;

  @ApiPropertyOptional({ type: [ShiftTimeBreakDto], description: '야간 비작업 시간 전체 목록' })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ShiftTimeBreakDto)
  nightBreaks?: ShiftTimeBreakDto[];
}

export class UpdateShiftTimeDto extends PartialType(OmitType(CreateShiftTimeDto, ['dateset'] as const)) {}
