/**
 * @file src/modules/planning/plan.dto.ts
 * @description 제품생산계획(MI)·반제품생산계획(SMD) 공용 DTO
 *              PB w_pln_product_master_plan_master / w_pln_assembly_master_plan_master
 *
 * 두 화면의 조회조건과 입력 항목이 같다. 다른 것은 SMD 에만 있는
 * SHIFT_CODE·PRODUCTION_TYPE·MFS_GROUP_NO 뿐이라 그 셋만 선택 항목으로 둔다.
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

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

export class PlanQueryDto {
  @ApiProperty({ description: '계획일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY, { message: 'dateFrom 은 YYYY-MM-DD 형식이어야 합니다.' })
  dateFrom!: string;

  @ApiProperty({ description: '계획일 끝 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY, { message: 'dateTo 은 YYYY-MM-DD 형식이어야 합니다.' })
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: '공정코드 (앞부분 일치, MI 전용)' })
  @IsOptional() @IsString() @Length(0, 10)
  workstageCode?: string;

  @ApiPropertyOptional({ description: '계획상태 (ISYS_BASECODE PLAN STATUS)' })
  @IsOptional() @IsString() @Length(0, 1)
  planStatus?: string;
}

/** 키 — PLAN_DATE + PLAN_SEQUENCE + ORGANIZATION_ID. */
export class PlanKeyDto {
  @ApiProperty({ description: '계획일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  planDate!: string;

  @ApiProperty({ description: '계획순번' })
  @Type(() => Number) @IsInt() @Min(0)
  planSequence!: number;
}

/**
 * 시간대 10칸. PB DataWindow 가 10칸 고정이라 필드를 펼쳐 둔다 —
 * 배열로 받으면 길이 검증과 빈 칸 구분이 흐려진다.
 */
class PlanTimeFields {
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime1?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime2?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime3?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime4?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime5?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime6?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime7?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime8?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime9?: number;
  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsNumber() planTime10?: number;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time1Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time2Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time3Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time4Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time5Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time6Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time7Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time8Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time9Desc?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000) time10Desc?: string;
}

export class PlanUpsertDto extends PlanTimeFields {
  @ApiProperty({ description: '계획일 (YYYY-MM-DD, 키)' })
  @IsString() @Matches(DATE_ONLY)
  planDate!: string;

  @ApiPropertyOptional({
    description: '계획순번 (키). 등록 시 비우면 그 날짜의 최대순번 + 1 을 서버가 매긴다.',
  })
  @IsOptional() @Type(() => Number) @IsInt() @Min(0)
  planSequence?: number;

  @ApiProperty({ description: '라인코드 (NOT NULL)' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiProperty({ description: '모델명 (NOT NULL)' })
  @IsString() @Length(1, 100)
  modelName!: string;

  @ApiProperty({ description: '모델 서픽스 (NOT NULL). 없으면 * 를 넣는다.' })
  @IsString() @Length(1, 50)
  modelSuffix!: string;

  @ApiProperty({ description: '계획수량 (NOT NULL)' })
  @Type(() => Number) @IsNumber() @Min(0)
  planQty!: number;

  @ApiPropertyOptional({ description: '계획 우선순위' })
  @IsOptional() @Type(() => Number) @IsInt()
  planPriority?: number;

  @ApiPropertyOptional({ description: '품목코드' })
  @IsOptional() @IsString() @Length(0, 30)
  itemCode?: string;

  @ApiPropertyOptional({ description: '상위 품목코드' })
  @IsOptional() @IsString() @Length(0, 30)
  parentItemCode?: string;

  @ApiPropertyOptional({ description: '작업지시번호' })
  @IsOptional() @IsString() @Length(0, 30)
  workOrderNo?: string;

  @ApiPropertyOptional({ description: '공정코드 (MI 는 NOT NULL, SMD 에는 컬럼이 없다)' })
  @IsOptional() @IsString() @Length(0, 10)
  workstageCode?: string;

  @ApiPropertyOptional({ description: 'PCB 면 (T/B)' })
  @IsOptional() @IsString() @Length(0, 1)
  pcbItem?: string;

  @ApiPropertyOptional({ description: '계획상태 (ISYS_BASECODE PLAN STATUS)' })
  @IsOptional() @IsString() @Length(0, 1)
  planStatus?: string;

  @ApiPropertyOptional({ description: '고객코드' })
  @IsOptional() @IsString() @Length(0, 30)
  customerCode?: string;

  @ApiPropertyOptional({ description: 'LOT 분할 여부' })
  @IsOptional() @IsIn(['Y', 'N'])
  lotDivideYn?: 'Y' | 'N';

  @ApiPropertyOptional({ description: '설비능력 수량' })
  @IsOptional() @Type(() => Number) @IsNumber()
  planCapaQty?: number;

  @ApiPropertyOptional({ description: '기종교체 시간(분)' })
  @IsOptional() @Type(() => Number) @IsNumber()
  mcTime?: number;

  @ApiPropertyOptional({ description: '일차별 계획수량 D1' })
  @IsOptional() @Type(() => Number) @IsNumber()
  planQtyD1?: number;

  @ApiPropertyOptional({ description: '일차별 계획수량 D2' })
  @IsOptional() @Type(() => Number) @IsNumber()
  planQtyD2?: number;

  @ApiPropertyOptional({ description: '일차별 계획수량 D3' })
  @IsOptional() @Type(() => Number) @IsNumber()
  planQtyD3?: number;

  @ApiPropertyOptional({ description: '마스터 모델명 (SMD 는 NOT NULL)' })
  @IsOptional() @IsString() @Length(0, 50)
  masterModelName?: string;

  @ApiPropertyOptional({ description: '교대코드 (SMD 전용)' })
  @IsOptional() @IsString() @Length(0, 20)
  shiftCode?: string;

  @ApiPropertyOptional({ description: '생산유형 (SMD 전용, NOT NULL)' })
  @IsOptional() @IsString() @Length(0, 1)
  productionType?: string;

  @ApiPropertyOptional({ description: 'MFS 그룹번호 (SMD 전용)' })
  @IsOptional() @IsString() @Length(0, 20)
  mfsGroupNo?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000)
  comments?: string;
}

/** 계획 확정/해제 — CONFIRM_YN 을 바꾼다. */
export class PlanConfirmDto extends PlanKeyDto {
  @ApiProperty({ description: "'Y' 확정 / 'N' 해제" })
  @IsIn(['Y', 'N'])
  confirmYn!: 'Y' | 'N';
}
