/**
 * @file src/modules/smt/smt-bom.dto.ts
 * @description SMT BOM 관리 + BOM 관리리포트 DTO
 *              PB w_smt_bom_create_master / w_smt_bom_master_rpt
 *
 * ID_ENG_BOM_SMT 는 28,417행이고 모델 지정 없이 훑으면 전부 끌어온다.
 * PB retrieve 도 `PARENT_ITEM_CODE = :ARG_PARENT_ITEM` 로 모델을 필수로 받았다.
 * 그 계약을 유지한다 — modelName 은 옵션이 아니다.
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

export class SmtBomQueryDto {
  @ApiProperty({ description: '모델명 (= PARENT_ITEM_CODE). 필수 — 28,417행 전체조회를 막는다.' })
  @IsString() @Length(1, 50)
  modelName!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '설비코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  machine?: string;

  @ApiPropertyOptional({ description: '기준일 (YYYY-MM-DD). 비우면 오늘' })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  dateSet?: string;

  @ApiPropertyOptional({ description: '리비전 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  revision?: string;

  @ApiPropertyOptional({ description: '피더축 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 1)
  feederShaft?: string;

  @ApiPropertyOptional({ description: 'PCB 면 (T/B). 비우면 양면' })
  @IsOptional() @IsString() @Length(0, 30)
  pcbItem?: string;
}

/** 키 — XPKID_ENG_BOM_SMT (PARENT+CHILD+DATESET+LOCATION+LINE+MACHINE+PCB_ITEM+ORG). */
export class SmtBomKeyDto {
  @ApiProperty() @IsString() @Length(1, 50)
  parentItemCode!: string;

  @ApiProperty() @IsString() @Length(1, 50)
  childItemCode!: string;

  @ApiProperty({ description: '적용 시작일 (YYYY-MM-DD) — 키의 일부다' })
  @IsString() @Matches(DATE_ONLY)
  dateSet!: string;

  @ApiProperty() @IsString() @Length(1, 30)
  locationCode!: string;

  @ApiProperty() @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 20)
  machine!: string;

  @ApiProperty({ description: 'PCB 면 (NOT NULL)' })
  @IsString() @Length(1, 30)
  pcbItem!: string;
}

export class SmtBomUpsertDto extends SmtBomKeyDto {
  @ApiProperty({ description: '적용 종료일 (YYYY-MM-DD, NOT NULL)' })
  @IsString() @Matches(DATE_ONLY)
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

  @ApiProperty({ description: 'SMT 모델명 (NOT NULL)' })
  @IsString() @Length(1, 50)
  smtModelName!: string;

  @ApiPropertyOptional({ description: '테이블문자 (생성값 — 코드표가 없다)' })
  @IsOptional() @IsString() @Length(0, 10)
  tableId?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 10)
  revision?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 1)
  feederShaft?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 50)
  feederType?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 2000)
  locationInfo?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 1000)
  comments?: string;

  @ApiPropertyOptional() @IsOptional() @Type(() => Number) @IsInt()
  bomLevel?: number;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;
}

/** 라인 교체 — PKG_MES_SMT.SP_SMT_BOM_LINE_SWAP. */
export class SmtBomLineSwapDto {
  @ApiProperty() @IsString() @Length(1, 20)
  lineCode1!: string;

  @ApiProperty() @IsString() @Length(1, 20)
  lineCode2!: string;
}

/** 모델명 변경 — PKG_MES_SMT.SP_SMT_BOM_MODEL_RENAME. */
export class SmtBomModelRenameDto {
  @ApiProperty() @IsString() @Length(1, 50)
  oldModelName!: string;

  @ApiProperty() @IsString() @Length(1, 50)
  newModelName!: string;
}

/** 범위 삭제 — PKG_MES_SMT.SP_SMT_BOM_DELETE_SCOPE. */
export class SmtBomDeleteScopeDto {
  @ApiProperty() @IsString() @Length(1, 50)
  modelName!: string;

  @ApiProperty() @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiPropertyOptional({ description: "PCB 면. 비우면 양면 ('%')" })
  @IsOptional() @IsIn(['T', 'B'])
  pcbItem?: 'T' | 'B';
}

/** BOM 관리리포트 — PB w_smt_bom_master_rpt (배포계획 기준 라벨·바코드 목록). */
export class SmtBomReportQueryDto {
  @ApiProperty({ description: '모델명. 필수 — 18,607행 전체조회를 막는다.' })
  @IsString() @Length(1, 100)
  modelName!: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;

  @ApiPropertyOptional({ description: 'PCB 면 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  pcbItem?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 10)
  revision?: string;
}
