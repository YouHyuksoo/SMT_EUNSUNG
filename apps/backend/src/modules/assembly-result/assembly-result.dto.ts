// 조립실적(생산실적) 조회·보정 DTO
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsIn, IsNumber, IsOptional, IsString, Length, Matches, NotEquals } from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

export class AssemblyResultQueryDto {
  @ApiProperty({ description: '작업일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '작업일 끝 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: '런카드 번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  runNo?: string;

  @ApiPropertyOptional({ description: '구분: AOI_JOB 자동 · WORK_RESULT 수기 · ASSY_ADJUST 보정' })
  @IsOptional() @IsIn(['', 'AOI_JOB', 'WORK_RESULT', 'ASSY_ADJUST'])
  source?: string;
}

export class AssemblyAdjustDto {
  @ApiProperty({ description: '런카드 번호' })
  @IsString() @Length(1, 50)
  runNo!: string;

  @ApiPropertyOptional({ description: '라인 (비우면 런카드 라인)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiProperty({ description: '실적 시각 (YYYY-MM-DD HH:mm, KST) — 작업일·시간대가 이 시각으로 정해진다' })
  @IsString() @Matches(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/)
  actualTime!: string;

  @ApiProperty({ description: '보정 수량 (늘리면 +, 줄이면 −)' })
  @Type(() => Number) @IsNumber() @NotEquals(0)
  qty!: number;

  @ApiProperty({ description: '보정 사유' })
  @IsString() @Length(1, 200)
  reason!: string;
}
