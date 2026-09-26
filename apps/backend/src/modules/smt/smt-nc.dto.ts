/**
 * @file src/modules/smt/smt-nc.dto.ts
 * @description SMT 피더레이아웃 등록 DTO — PB w_smt_upload_nc_master
 *
 * **벤더별 NC 파일 파싱은 이관 범위 밖이다.** 아래 DTO 는 이미 적재된
 * IB_MNT_PLANDATA(마운터 배치 적재표)를 조회·검증·대조하는 쪽만 다룬다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, Length } from 'class-validator';

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
