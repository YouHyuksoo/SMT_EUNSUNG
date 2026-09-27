/**
 * @file src/modules/planning/kitting.dto.ts
 * @description 롯트카드-PID 매핑관리 DTO — PB w_pln_product_pcb_kitting_scan_master
 *
 * **runNo 는 어디서나 필수다.** IP_PRODUCT_2D_BARCODE 는 약 1.8억 행이고
 * RUN_NO 가 INDXIP_PRODUCT_2D_BARCODE2 의 선두 컬럼이다. 이 조건이 없으면
 * 풀스캔이 된다. PB 도 `RUN_NO = :arg_run_no` 등호였다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, Length } from 'class-validator';

export class KittingRunCardQueryDto {
  @ApiPropertyOptional({ description: '작업지시번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;

  @ApiPropertyOptional({ description: 'MFS 그룹번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  mfsGroupNo?: string;
}

export class KittingPidQueryDto {
  @ApiProperty({ description: '작업지시번호. 필수 — 1.8억 행 풀스캔을 막는다.' })
  @IsString() @Length(1, 30)
  runNo!: string;
}

export class KittingScanDto {
  @ApiProperty({ description: '작업지시번호' })
  @IsString() @Length(1, 30)
  runNo!: string;

  @ApiProperty({ description: '스캔한 PID (제품 시리얼)' })
  @IsString() @Length(1, 100)
  serialNo!: string;

  @ApiPropertyOptional({
    description: "'Y' 면 PID 7~11번째 다섯 글자가 모델명과 같아야 한다 (PB 모델매칭 체크박스)",
  })
  @IsOptional() @IsIn(['Y', 'N'])
  modelMatching?: 'Y' | 'N';
}

export class KittingCancelDto {
  @ApiProperty() @IsString() @Length(1, 30)
  runNo!: string;

  @ApiProperty() @IsString() @Length(1, 100)
  serialNo!: string;
}

export class KittingClearDto {
  @ApiProperty({ description: '작업지시번호. 이 롯트카드의 PID 매핑을 통째로 지운다.' })
  @IsString() @Length(1, 30)
  runNo!: string;
}
