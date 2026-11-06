/**
 * @file src/modules/smt/smt-nc.dto.ts
 * @description SMT 피더레이아웃 등록 DTO — PB w_smt_upload_nc_master
 *
 * 삼성 마운터 NC 파일로 피더 배치(IB_MNT_PLANDATA)를 만들고, 조회·검증·대조한 뒤 SMT BOM 에 반영한다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsIn, IsOptional, IsString, Length } from 'class-validator';

export class SmtNcQueryDto {
  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;

  @ApiPropertyOptional({ description: '설비코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  modelName?: string;

  @ApiPropertyOptional({ description: 'LOT명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  lotName?: string;

  @ApiPropertyOptional({ description: '테이블문자 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  tableId?: string;
}

/** 피더 ↔ BOM 대조. BOM 쪽은 PKG_DESIGN.BOM_QUERY 로 전개한다. */
export class SmtNcCompareQueryDto {
  @ApiProperty({ description: '전개할 SET 품목코드 (= 모델명)' })
  @IsString() @Length(1, 50)
  setItemCode!: string;

  @ApiPropertyOptional({ description: "PCB 면(품목분류 기준). 비우면 양면('%')" })
  @IsOptional() @IsIn(['T', 'B'])
  pcbItem?: 'T' | 'B';

  @ApiPropertyOptional({ description: '피더 쪽을 좁힐 라인코드' })
  @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;
}

/**
 * NC 파일로 피더 배치 생성 (PB cb_1 Generate · 삼성 형식).
 * 파일은 multipart `files` 로 받고, 설비그룹별 시작 테이블과 몇 번째 파일인지는 `groups`(JSON 문자열)로 받는다.
 */
export class SmtNcGenerateDto {
  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty({ description: 'PCB 면 T/B' })
  @IsIn(['T', 'B'])
  pcbItem!: 'T' | 'B';

  @ApiProperty({ description: 'SMT 모델명 (IP_PRODUCT_MODEL_MASTER.SMT_MODEL_NAME)' })
  @IsString() @Length(1, 100)
  smtModelName!: string;

  @ApiProperty({ description: '레이아웃 모델명 — SMT BOM 의 상위품목이 된다. 보통 SMT 모델명과 같다' })
  @IsString() @Length(1, 100)
  layoutModelName!: string;

  @ApiPropertyOptional({ description: '공급처 — 마운터 품번을 이 공급처의 품목코드로 바꾼다' })
  @IsOptional() @IsString() @Length(0, 30)
  supplierCode?: string;

  @ApiProperty({ description: '[{ machineGroup, startTableId, fileIndex }] JSON' })
  @IsString()
  groups!: string;
}

/** 피더 배치 품번 교체 (PB cb_7 Replace PartNo) */
export class SmtNcReplacePartDto {
  @ApiProperty() @IsString() @Length(1, 30)
  supplierCode!: string;
}

/** 피더 배치 → SMT BOM 반영 (PB cb_2 Apply) */
export class SmtNcApplyDto {
  @ApiProperty({ description: '적재표가 이 라인의 것인지 확인한다' })
  @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty({ description: '적재표가 이 레이아웃 모델의 것인지 확인한다' })
  @IsString() @Length(1, 100)
  layoutModelName!: string;

  @ApiProperty({ description: 'SMT 모델명 — MASTER_MODEL_NAME·MODEL_NAME·SMT_MODEL_NAME 에 들어간다' })
  @IsString() @Length(1, 100)
  smtModelName!: string;

  @ApiProperty({ description: '리비전 (필수)' })
  @IsString() @Length(1, 30)
  revision!: string;

  @ApiPropertyOptional({ description: 'Line Mixed — 같은 자리(테이블·번지)만 바꾸고 나머지 자리는 둔다' })
  @IsOptional() @IsBoolean()
  mixed?: boolean;
}
