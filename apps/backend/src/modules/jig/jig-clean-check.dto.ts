/**
 * @file src/modules/jig/jig-clean-check.dto.ts
 * @description 195 스퀴지검사관리(세척) 입력 규칙.
 */
import { Type } from 'class-transformer';
import {
  IsBoolean, IsDateString, IsNotEmpty, IsNumber, IsOptional, IsString,
} from 'class-validator';

export class JigCleanCheckQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() jigLotNo?: string;
}

export class JigCleanCheckLookupDto {
  @IsString() @IsNotEmpty() jigLotNo!: string;
}

export class JigCleanCheckSaveDto {
  @IsString() @IsNotEmpty() jigLotNo!: string;
  /** 종합 합격 여부. 합격이면 지그가 사용가능이 된다. */
  @IsBoolean() pass!: boolean;
  /** 세척 판정. */
  @IsBoolean() cleanOk!: boolean;
  /** 외관(핀홀) 판정. */
  @IsBoolean() visualOk!: boolean;
  @IsOptional() @Type(() => Number) @IsNumber() breakValue?: number;
  @IsOptional() @Type(() => Number) @IsNumber() hitValue?: number;
  @IsOptional() @Type(() => Number) @IsNumber() airPressValue?: number;
  @IsOptional() @IsString() comments?: string;
}
