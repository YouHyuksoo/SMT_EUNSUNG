/**
 * @file src/modules/smt/smt-plan.dto.ts
 * @description SMT 계획배포관리 DTO — PB w_smt_plan_master
 *
 * IB_PRODUCT_PLANDATA 는 18,607행이다. 모델명을 필수로 받아 전체조회를 막는다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, Length } from 'class-validator';

export class SmtPlanQueryDto {
  @ApiProperty({ description: '모델명. 필수 — 18,607행 전체조회를 막는다.' })
  @IsString() @Length(1, 100)
  modelName!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;

  @ApiPropertyOptional({ description: 'PCB 면 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  pcbItem?: string;

  @ApiPropertyOptional({ description: '피더축 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 1)
  feederShaft?: string;

  @ApiPropertyOptional({ description: '리비전 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  revision?: string;

  @ApiPropertyOptional({ description: "대체품목 여부 'Y'/'N'. 비우면 전부" })
  @IsOptional() @IsIn(['Y', 'N'])
  replaceYn?: 'Y' | 'N';

  @ApiPropertyOptional({ description: "활성 여부 'Y'/'N'. 비우면 전부" })
  @IsOptional() @IsIn(['Y', 'N'])
  activeYn?: 'Y' | 'N';
}

/** 배포 — PKG_MES_SMT.SP_SMT_PLAN_DEPLOY. PCB 면은 등호 조건이라 필수다. */
export class SmtPlanDeployDto {
  @ApiProperty() @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 100)
  modelName!: string;

  @ApiProperty({ description: 'PCB 면 (T/B). 배포 SQL 이 등호로 쓰므로 필수다.' })
  @IsIn(['T', 'B'])
  pcbItem!: 'T' | 'B';

  @ApiPropertyOptional({ description: "피더축. 비우면 전부('%')" })
  @IsOptional() @IsString() @Length(0, 1)
  feederShaft?: string;
}

/** 배포 취소 — PKG_MES_SMT.SP_SMT_PLAN_DELETE. 비활성 행만 지운다. */
export class SmtPlanDeleteDto {
  @ApiProperty() @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 100)
  modelName!: string;

  @ApiPropertyOptional({ description: "PCB 면. 비우면 양면('%')" })
  @IsOptional() @IsIn(['T', 'B'])
  pcbItem?: 'T' | 'B';

  @ApiPropertyOptional({ description: "피더축. 비우면 전부('%')" })
  @IsOptional() @IsString() @Length(0, 1)
  feederShaft?: string;
}

/** 활성/비활성 전환 — PKG_MES_SMT.SP_SMT_PLAN_SET_ACTIVE. */
export class SmtPlanSetActiveDto {
  @ApiProperty() @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 100)
  modelName!: string;

  @ApiPropertyOptional({ description: "PCB 면. 비우면 양면('%')" })
  @IsOptional() @IsIn(['T', 'B'])
  pcbItem?: 'T' | 'B';

  @ApiProperty({ description: "'Y' 활성 / 'N' 비활성" })
  @IsIn(['Y', 'N'])
  activeYn!: 'Y' | 'N';
}
