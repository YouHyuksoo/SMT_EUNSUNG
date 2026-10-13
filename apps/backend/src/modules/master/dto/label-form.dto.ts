/**
 * @file src/modules/master/dto/label-form.dto.ts
 * @description 제품별 라벨양식 관리 DTO — ISYS_LABEL_FORM
 */
import { Type } from 'class-transformer';
import { ArrayNotEmpty, IsArray, IsIn, IsInt, IsNotEmpty, IsOptional, IsString, MaxLength, Min, ValidateNested } from 'class-validator';

/** 라벨 값 칸 V1~V20 */
export const LABEL_VALUE_KEYS = Array.from({ length: 20 }, (_, i) => `v${i + 1}`) as readonly string[];

export class LabelFormQueryDto {
  @IsOptional() @IsString() modelName?: string;
}

export class LabelFormKeyDto {
  @IsString() @IsNotEmpty() modelName!: string;
  @Type(() => Number) @IsInt() @Min(1) labelFormNo!: number;
}

export class SaveLabelFormDto extends LabelFormKeyDto {
  @IsOptional() @IsString() @MaxLength(100) labelFormName?: string;
  /** 공통코드 LABEL FORM TYPE (B 박스 / P 팔레트 / R 입고전표) */
  @IsString() @IsIn(['B', 'P', 'R']) labelFormType!: string;
  /** 공통코드 USE FLAG */
  @IsOptional() @IsIn(['Y', 'N']) useFlag?: string;
  @IsOptional() @IsString() @MaxLength(1000) comments?: string;
  /** V1~V20 값 칸 (공통코드 LABEL STEP 또는 고정 문자) — 키는 v1..v20 */
  @IsOptional() values?: Record<string, string | null>;
}

export class UpdateLabelFormDto extends SaveLabelFormDto {
  /** 수정 전 키 (모델명·양식번호를 바꿀 때) */
  @IsString() @IsNotEmpty() originalModelName!: string;
  @Type(() => Number) @IsInt() @Min(1) originalLabelFormNo!: number;
}

export class LabelFileQueryDto extends LabelFormKeyDto {
  /** syntax = BarTender 양식 파일(.btw), image = 미리보기 이미지 */
  @IsIn(['syntax', 'image']) kind!: 'syntax' | 'image';
}

export class CopyLabelFormDto {
  @IsArray() @ArrayNotEmpty() @ValidateNested({ each: true }) @Type(() => LabelFormKeyDto) sources!: LabelFormKeyDto[];
  @IsString() @IsNotEmpty() @MaxLength(100) targetModelName!: string;
}
