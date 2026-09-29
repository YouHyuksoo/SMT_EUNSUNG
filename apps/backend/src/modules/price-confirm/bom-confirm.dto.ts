/**
 * @file src/modules/price-confirm/bom-confirm.dto.ts
 * @description 설계BOM승인 DTO — PB w_des_bom_confirm_master
 *
 * ID_ENG_BOM_WORKSPACE 는 확정 전 BOM 을 담는 작업공간이다.
 * 작업번호(BOM_WORK_NO) 단위로 묶여 있고, 승인하면 PKG_DESIGN.BOM_TRANSLATION 이
 * 실제 BOM(ID_ENG_BOM)으로 옮긴다.
 *
 * **이 표는 이 DB 에서 0행이다** — 은성이 아직 설계BOM 승인 절차를 쓰지 않는다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Length, Min } from 'class-validator';

export class BomConfirmQueryDto {
  @ApiPropertyOptional({
    description: '작업번호. 비우면 전부 (이 표는 0행이라 전체조회가 위험하지 않다)',
  })
  @IsOptional() @Type(() => Number) @IsInt() @Min(0)
  bomWorkNo?: number;

  @ApiPropertyOptional({ description: 'SET 품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '상위 품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  parentItemCode?: string;
}

/**
 * 승인(반영) — PB cb_2('Translation').
 * PKG_DESIGN.BOM_TRANSLATION 이 작업공간의 BOM 을 실제 BOM 으로 옮긴다.
 */
export class BomConfirmApplyDto {
  @ApiProperty({ description: '작업번호' })
  @Type(() => Number) @IsInt() @Min(1)
  bomWorkNo!: number;

  @ApiProperty({ description: 'SET 품목코드. PB 는 작업번호로 조회해 자동 채웠다.' })
  @IsString() @Length(1, 50)
  itemCode!: string;
}

/** 작업공간 비우기 — PB cb('Delete All'). 작업번호 단위로 통째로 지운다. */
export class BomConfirmClearDto {
  @ApiProperty({ description: '작업번호' })
  @Type(() => Number) @IsInt() @Min(1)
  bomWorkNo!: number;
}
