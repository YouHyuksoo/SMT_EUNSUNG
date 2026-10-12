/**
 * @file src/modules/smt/smt-line.dto.ts
 * @description SMT 라인관리 DTO — PB w_smt_line_master
 *
 * 키는 LINE_CODE + MACHINE + ORGANIZATION_ID 다 (XPKIB_LINE_MASTER).
 * 수정할 때 앞 두 개는 바꿀 수 없다 — 바꾸면 UPDATE 의 WHERE 가 다른 행을 가리킨다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  Min,
} from 'class-validator';

export class SmtLineQueryDto {
  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  lineCode?: string;

  @ApiPropertyOptional({ description: '설비코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machine?: string;

  @ApiPropertyOptional({ description: '라인상태 (ISYS_BASECODE LINE STATUS)' })
  @IsOptional() @IsString() @Length(0, 4)
  lineStatus?: string;
}

export class SmtLineUpsertDto {
  @ApiProperty({ description: '라인코드 (키)' })
  @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty({ description: '설비코드 (키)' })
  @IsString() @Length(1, 30)
  machine!: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 100)
  lineName?: string;

  @ApiProperty({ description: '설비명 (NOT NULL)' })
  @IsString() @Length(1, 100)
  machineName!: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 20)
  lineDivision?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 4)
  lineStatus?: string;

  @ApiPropertyOptional({ description: '설비그룹' })
  @IsOptional() @IsString() @Length(0, 10)
  machineGroup?: string;

  @ApiPropertyOptional({ description: '테이블 표시여부' })
  @IsOptional() @IsIn(['Y', 'N'])
  showTableYn?: 'Y' | 'N';
}

export class SmtLineKeyDto {
  @ApiProperty() @IsString() @Length(1, 20)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 30)
  machine!: string;
}

/**
 * 위치 일괄생성 — PB cb_3('Generate').
 * 주소 상한을 99 로 묶는다. LOCATION_CODE 가 `테이블문자 + 2자리 + 위치` 라서
 * 100 이상은 자리수가 밀려 다른 테이블의 코드와 겹친다.
 */
export class SmtLocationGenerateDto extends SmtLineKeyDto {
  @ApiProperty({ description: '테이블문자 (알파벳 한 글자)' })
  @IsString() @Matches(/^[A-Za-z]$/, { message: 'tableId 는 알파벳 한 글자여야 합니다.' })
  tableId!: string;

  @ApiProperty({ description: '주소 시작' })
  @Type(() => Number) @IsInt() @Min(0) @Max(99)
  addrFrom!: number;

  @ApiProperty({ description: '주소 끝' })
  @Type(() => Number) @IsInt() @Min(0) @Max(99)
  addrTo!: number;

  @ApiProperty({ description: "위치: 'L' | 'R' | 'LR' | 'N'(위치문자 없음)" })
  @IsIn(['L', 'R', 'LR', 'N'])
  positions!: 'L' | 'R' | 'LR' | 'N';

  @ApiPropertyOptional({ description: "'Y' 면 A 부터 tableId 까지 전부 생성" })
  @IsOptional() @IsIn(['Y', 'N'])
  allTables?: 'Y' | 'N';
}
