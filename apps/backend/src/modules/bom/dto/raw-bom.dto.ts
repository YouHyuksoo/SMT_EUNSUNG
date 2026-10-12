import { Type } from 'class-transformer';
import {
  IsIn, IsNotEmpty, IsNumber, IsOptional, IsString, Matches, MaxLength, Min,
} from 'class-validator';

const YMD = /^\d{4}-\d{2}-\d{2}$/;

/** 원단위BOM 목록 — PB d_des_raw_bom_lst (모/자품목코드 앞부분 일치) */
export class RawBomListQueryDto {
  @IsOptional() @IsString() parentItemCode?: string;
  @IsOptional() @IsString() childItemCode?: string;
}

/** 순환 검사 — itemCode 가 없으면 조직 전체를 검사한다 */
export class RawBomLoopCheckQueryDto {
  @IsOptional() @IsString() itemCode?: string;
}

/**
 * 원단위BOM 수정 — ID_ENG_BOM (PK: PARENT, CHILD, DATESET, ORG).
 * PB 화면은 등록·삭제가 없고 수정만 한다. 아래 NOT NULL 컬럼은 모두 필수다.
 */
export class RawBomUpdateDto {
  @IsString() @IsNotEmpty() parentItemCode!: string;
  @IsString() @IsNotEmpty() childItemCode!: string;
  /** 키 — 'YYYY-MM-DD' (DATESET 은 시각 없이 저장돼 있다) */
  @Matches(YMD, { message: '시작일자는 YYYY-MM-DD 형식이어야 합니다.' }) dateset!: string;

  @IsIn(['Y', 'N'], { message: '반제품전개는 Y 또는 N 입니다.' }) assyExplosionYn!: string;
  @IsString() @IsNotEmpty({ message: '품목유형은 필수입니다.' }) @MaxLength(10) itemType!: string;
  @IsString() @IsNotEmpty({ message: '구입유형은 필수입니다.' }) @MaxLength(10) lineType!: string;
  @Type(() => Number) @IsNumber() @Min(0, { message: '단위수량은 0 이상이어야 합니다.' }) itemUnitQty!: number;
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0, { message: '단위수량(기타)은 0 이상이어야 합니다.' })
  itemUnitQtyExt?: number | null;
  @IsString() @IsNotEmpty({ message: '공정은 필수입니다.' }) @MaxLength(10) workstageCode!: string;
  @Type(() => Number) @IsNumber() sortSequence!: number;
  @Matches(YMD, { message: '종료일자는 YYYY-MM-DD 형식이어야 합니다.' }) dateend!: string;
}
