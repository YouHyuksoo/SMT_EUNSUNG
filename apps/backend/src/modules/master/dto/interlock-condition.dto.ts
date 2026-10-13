/**
 * @file src/modules/master/dto/interlock-condition.dto.ts
 * @description 인터락조건관리 DTO — IQ_INTERLOCK_CHECK_CONDITION
 */
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsNotEmpty, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';

export class InterlockConditionQueryDto {
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() interlockCheckType?: string;
  @IsOptional() @IsIn(['Y', 'N']) useYn?: string;
}

export class SaveInterlockConditionDto {
  @IsString() @IsNotEmpty() @MaxLength(10) lineCode!: string;
  @IsString() @IsNotEmpty() @MaxLength(10) workstageCode!: string;
  /** 설비코드 — 비우면 설비 구분 없이 적용 */
  @IsOptional() @IsString() @MaxLength(20) machineCode?: string;
  /** 공통코드 INTERLOCK CHECK TYPE */
  @IsString() @IsNotEmpty() @MaxLength(30) interlockCheckType!: string;
  /** 검사한계시간 */
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0) checkLimitTime?: number;
  /** 검사 순서 (같은 라인·공정 안에서 이 순서대로 검사) */
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) checkSequence?: number;
  /** 품목코드 — '*' 는 전 품목 */
  @IsOptional() @IsString() @MaxLength(30) itemCode?: string;
  @IsIn(['Y', 'N']) useYn!: string;
}

export class CopyInterlockConditionDto {
  @IsString() @IsNotEmpty() fromLineCode!: string;
  @IsString() @IsNotEmpty() toLineCode!: string;
}
