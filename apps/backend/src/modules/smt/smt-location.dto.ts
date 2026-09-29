/**
 * @file src/modules/smt/smt-location.dto.ts
 * @description 라인별 테이블 관리 DTO — PB w_smt_location_master
 *
 * 키는 LINE_CODE + LOCATION_CODE + ORGANIZATION_ID 다 (XPKIB_MACHINE_LOCATION).
 * **MACHINE 은 키가 아니다.** 같은 라인에서 위치코드가 겹치면 설비가 달라도
 * 같은 행이므로, 등록할 때 설비만 바꿔 같은 위치코드를 또 넣을 수 없다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, Length } from 'class-validator';

export class SmtLocationQueryDto {
  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  lineCode?: string;

  @ApiPropertyOptional({ description: '설비코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  machine?: string;

  @ApiPropertyOptional({ description: '테이블문자 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  tableId?: string;

  @ApiPropertyOptional({ description: '위치코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  locationCode?: string;
}

export class SmtLocationUpsertDto {
  @ApiProperty({ description: '라인코드 (키)' })
  @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty({ description: '위치코드 (키)' })
  @IsString() @Length(1, 100)
  locationCode!: string;

  @ApiProperty({ description: '설비코드 (NOT NULL, 키는 아니다)' })
  @IsString() @Length(1, 30)
  machine!: string;

  @ApiProperty({ description: '테이블문자 (NOT NULL)' })
  @IsString() @Length(1, 10)
  tableId!: string;

  @ApiPropertyOptional({ description: '테이블번호' })
  @IsOptional() @IsString() @Length(0, 10)
  tableNo?: string;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(0, 100)
  comments?: string;
}

export class SmtLocationKeyDto {
  @ApiProperty() @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty() @IsString() @Length(1, 100)
  locationCode!: string;
}
