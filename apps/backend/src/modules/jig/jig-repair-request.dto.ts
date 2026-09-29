/**
 * @file src/modules/jig/jig-repair-request.dto.ts
 * @description 187 지그수리신청 입력 규칙.
 */
import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsNotEmpty, IsOptional, IsString, Min,
} from 'class-validator';

export class JigRepairRequestQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() jigCode?: string;
  @IsOptional() @IsString() repairStatus?: string;
}

export class RepairableJigQueryDto {
  @IsOptional() @IsString() jigCode?: string;
  @IsOptional() @IsString() jigType?: string;
  @IsOptional() @IsString() lineCode?: string;
}

export class JigRepairRequestCreateDto {
  @IsString() @IsNotEmpty() jigCode!: string;
  @IsString() @IsNotEmpty() repairReasonCode!: string;
  @IsDateString() repairRequestDate!: string;
  @IsOptional() @IsString() repairVendorCode?: string;
  /** `CURRENCY` 는 NOT NULL 이다. 비우면 서비스가 'KRW' 를 넣는다. */
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() comments?: string;
  @IsOptional() @IsString() jigLotNo?: string;
}

export class JigRepairRequestUpdateDto extends JigRepairRequestCreateDto {
  @Type(() => Number) @IsInt() @Min(1) repairSequence!: number;
}

export class JigRepairRequestDeleteDto {
  @IsString() @IsNotEmpty() jigCode!: string;
  @Type(() => Number) @IsInt() @Min(1) repairSequence!: number;
}
