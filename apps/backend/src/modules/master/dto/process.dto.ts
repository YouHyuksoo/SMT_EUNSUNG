/**
 * @file src/modules/master/dto/process.dto.ts
 * @description 공정(Workstage)마스터 관련 DTO 정의 - IP_PRODUCT_WORKSTAGE 기준
 *
 * 초보자 가이드:
 * 1. **CreateProcessDto**: 공정 생성 시 필요한 필드
 * 2. **UpdateProcessDto**: 부분 수정 가능 (PartialType)
 * 3. **ProcessQueryDto**: 목록 조회 시 페이징/검색/필터
 *
 * 코드성 값(공정유형, 공정그룹, 교대, 라인 등)은 ISYS_BASECODE 공통코드에서 선택한다.
 * 값 목록이 늘어나도 DTO를 고치지 않도록 길이만 검증하고, Y/N 플래그만 IsIn으로 고정한다.
 */

import { ApiProperty, ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { IsString, IsOptional, IsInt, IsNumber, Min, MaxLength, IsIn } from 'class-validator';
import { Type } from 'class-transformer';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

import { USE_YN_VALUES } from '@smt/shared';

/** 선택 입력 문자열 코드 필드 데코레이터 묶음 */
const YN = [...USE_YN_VALUES];

export class CreateProcessDto {
  @ApiProperty({ description: '공정 코드', example: 'W020' })
  @IsString()
  @MaxLength(10)
  processCode: string;

  @ApiProperty({ description: '공정명', example: 'SP' })
  @IsString()
  @MaxLength(100)
  processName: string;

  @ApiProperty({ description: '공정 유형: I=일반 L=최종 Q=검사', example: 'I' })
  @IsString()
  @MaxLength(1)
  processType: string;

  @ApiProperty({ description: '정렬 순서', example: 20 })
  @Type(() => Number)
  @IsInt()
  @Min(0)
  sortOrder: number;

  /* ── 구분/그룹 ── */

  @ApiPropertyOptional({ description: '시작공정 여부', default: 'N' })
  @IsOptional()
  @IsString()
  @IsIn(YN)
  startYn?: string;

  @ApiPropertyOptional({ description: '공정 그룹 (SMT/PBA/PACKING/REPAIR/WAREHOUSE)' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  codeGroup?: string;

  @ApiPropertyOptional({ description: '공정 상태 코드' })
  @IsOptional()
  @IsString()
  @MaxLength(1)
  workstageStatus?: string;

  @ApiPropertyOptional({ description: '라인 코드', default: '*' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '부서 코드', default: '1100' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  departmentCode?: string;

  @ApiPropertyOptional({ description: '교대 코드' })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  shiftCode?: string;

  @ApiPropertyOptional({ description: '대표 설비 코드' })
  @IsOptional()
  @IsString()
  @MaxLength(30)
  machineCode?: string;

  @ApiPropertyOptional({ description: '코스트센터 코드' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  costCenterCode?: string;

  @ApiPropertyOptional({ description: 'MES 디스플레이 그룹', default: '*' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  mesDisplayGroup?: string;

  @ApiPropertyOptional({ description: '실적 PLC 주소' })
  @IsOptional()
  @IsString()
  @MaxLength(10)
  actualPlcAddress?: string;

  /* ── 표준시간 / 생산성 ── */

  @ApiPropertyOptional({ description: '정상 작업시간(ST)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  stValue?: number;

  @ApiPropertyOptional({ description: '초과 작업시간(OT)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  otValue?: number;

  @ApiPropertyOptional({ description: '표준 수량' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  standardQty?: number;

  @ApiPropertyOptional({ description: '시간당 생산량(UPH)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  uphValue?: number;

  @ApiPropertyOptional({ description: '생산능력(Capacity)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  capacity?: number;

  @ApiPropertyOptional({ description: '생산능력 단위 (ST/KG)' })
  @IsOptional()
  @IsString()
  @MaxLength(3)
  capacityUom?: string;

  @ApiPropertyOptional({ description: '가동률(%)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  useRate?: number;

  @ApiPropertyOptional({ description: '대기 시간' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  waitTime?: number;

  @ApiPropertyOptional({ description: '이동 시간' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  moveTime?: number;

  @ApiPropertyOptional({ description: '준비 시간' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  prepareTime?: number;

  @ApiPropertyOptional({ description: '총 작업시간' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  totalWorkTime?: number;

  @ApiPropertyOptional({ description: '작업자 작업시간' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  workerWorkTime?: number;

  @ApiPropertyOptional({ description: '설비 작업시간' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  machineWorkTime?: number;

  @ApiPropertyOptional({ description: '작업자 수' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  workerQty?: number;

  @ApiPropertyOptional({ description: '설비 대수' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  machineQty?: number;

  @ApiPropertyOptional({ description: '작업 효율(%)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  workingEfficiency?: number;

  @ApiPropertyOptional({ description: '설비 효율(%)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  machineEfficiency?: number;

  /* ── 원가율 ── */

  @ApiPropertyOptional({ description: '임률' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  wageRate?: number;

  @ApiPropertyOptional({ description: '경비율' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  expenseRate?: number;

  @ApiPropertyOptional({ description: '기계경비율' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  machineryRate?: number;

  /* ── 불량관리 ── */

  @ApiPropertyOptional({ description: '불량률 통제 여부' })
  @IsOptional()
  @IsString()
  @IsIn(YN)
  badRateControl?: string;

  @ApiPropertyOptional({ description: '최대 허용 불량률(%)' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  badMaxRate?: number;

  @ApiPropertyOptional({ description: '불량수량 추출 여부' })
  @IsOptional()
  @IsString()
  @IsIn(YN)
  badQtyExtractYn?: string;

  /* ── 기타 ── */

  @ApiPropertyOptional({ description: '하위 반제품 생성 여부' })
  @IsOptional()
  @IsString()
  @IsIn(YN)
  genSubMfsYn?: string;

  @ApiPropertyOptional({ description: '조립비 반영 여부' })
  @IsOptional()
  @IsString()
  @IsIn(YN)
  assyExpYn?: string;
}

export class UpdateProcessDto extends PartialType(CreateProcessDto) {}

export class ProcessQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ description: '공정코드/공정명 검색' })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ description: '공정 유형' })
  @IsOptional()
  @IsString()
  processType?: string;

  @ApiPropertyOptional({ description: '공정 그룹' })
  @IsOptional()
  @IsString()
  codeGroup?: string;

  @ApiPropertyOptional({ description: '라인 코드' })
  @IsOptional()
  @IsString()
  lineCode?: string;
}
