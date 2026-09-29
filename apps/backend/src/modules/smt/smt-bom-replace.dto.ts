/**
 * @file src/modules/smt/smt-bom-replace.dto.ts
 * @description SMT BOM 대체관리 DTO — PB w_smt_bom_replace_master
 *
 * 키는 PARENT_ITEM_CODE + CHILD_ITEM_CODE + REPLACE_ITEM_CODE + LINE_CODE
 *      + LOCATION_CODE + ORGANIZATION_ID 다 (XPKID_ENG_BOM_REPLACE).
 * 여섯 컬럼 전부 수정 모드에서 잠긴다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Length,
  Matches,
  Min,
} from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

export class SmtBomReplaceQueryDto {
  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: '원 품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  childItemCode?: string;

  @ApiPropertyOptional({ description: '대체 품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  replaceItemCode?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '설비코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  machine?: string;

  @ApiPropertyOptional({ description: "'Y' 면 오늘 유효한 것만 (PB _4_modify 뷰)" })
  @IsOptional() @IsString() @Matches(/^[YN]$/)
  effectiveOnly?: 'Y' | 'N';
}

/** 키 여섯 컬럼. 수정·삭제가 이 조합으로만 행을 찾는다. */
export class SmtBomReplaceKeyDto {
  @ApiProperty() @IsString() @Length(1, 30)
  parentItemCode!: string;

  @ApiProperty() @IsString() @Length(1, 30)
  childItemCode!: string;

  @ApiProperty() @IsString() @Length(1, 30)
  replaceItemCode!: string;

  @ApiProperty() @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 30)
  locationCode!: string;
}

export class SmtBomReplaceUpsertDto extends SmtBomReplaceKeyDto {
  @ApiProperty({ description: '적용 시작일 (YYYY-MM-DD, NOT NULL)' })
  @IsString() @Matches(DATE_ONLY, { message: 'dateSet 은 YYYY-MM-DD 형식이어야 합니다.' })
  dateSet!: string;

  @ApiProperty({ description: '적용 종료일 (YYYY-MM-DD, NOT NULL)' })
  @IsString() @Matches(DATE_ONLY, { message: 'dateEnd 은 YYYY-MM-DD 형식이어야 합니다.' })
  dateEnd!: string;

  @ApiProperty({ description: '소요량 (NOT NULL)' })
  @Type(() => Number) @IsNumber() @Min(0)
  itemUnitQty!: number;

  @ApiProperty({ description: '정렬순번 (NOT NULL)' })
  @Type(() => Number) @IsInt() @Min(0)
  sortSequence!: number;

  /**
   * 공정코드. 컬럼은 NOT NULL 이지만 이 DB 의 28,453행이 전부 '*' 다 —
   * SMT BOM 은 공정을 나누지 않는다. 화면에서 받지 않고 서버가 '*' 를 넣는다.
   * 'WORKSTAGE CODE' 코드표도 없어서 셀렉터로 두면 빈 목록이 된다.
   */
  @ApiPropertyOptional({ description: "공정코드. 생략하면 '*'" })
  @IsOptional() @IsString() @Length(1, 10)
  workstageCode?: string;

  @ApiProperty({ description: '품목유형 (ISYS_BASECODE ITEM TYPE, NOT NULL)' })
  @IsString() @Length(1, 10)
  itemType!: string;

  @ApiProperty({ description: '라인유형 (ISYS_BASECODE LINE TYPE, NOT NULL)' })
  @IsString() @Length(1, 10)
  lineType!: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 20)
  machine?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: '테이블문자 (생성값이다 — 코드표가 없다)' })
  @IsOptional() @IsString() @Length(0, 10)
  tableId?: string;

  @ApiPropertyOptional({ description: 'PCB 면 (ISYS_BASECODE PCB ITEM)' })
  @IsOptional() @IsString() @Length(0, 30)
  pcbItem?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 10)
  revision?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 1)
  feederShaft?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 50)
  smtModelName?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 1000)
  comments?: string;

  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsInt()
  bomLevel?: number;
}
