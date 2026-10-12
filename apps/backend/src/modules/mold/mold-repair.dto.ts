import { Type } from 'class-transformer';
import {
  IsDateString, IsIn, IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** 수리 대상 S-PARTS 목록 — PB d_mcn_mold_inventory_4_repair_lst */
export class MoldRepairTargetQueryDto {
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() moldGroup?: string;
}

/**
 * 수리 목록 — PB d_mcn_mold_repair_change_request_lst 의 retrieve 인자와 1:1.
 * 수리신청관리·수리관리 두 화면이 같은 테이블을 본다. 상태로 갈라 쓴다.
 */
export class MoldRepairQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() moldGroup?: string;
  @IsOptional() @IsString() repairStatus?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 수리 접수(신청) — PB w_mcn_mold_repair_request_master.
 * 신청일=오늘, 항번=SEQ_MOLD_REPAIR_SEQUENCE, 상태='R'(신청) 은 서버가 채운다.
 */
export class MoldRepairRequestDto {
  @IsString() @Length(1, 30) moldCode!: string;

  @IsOptional() @Type(() => Number) @IsNumber() moldVersion?: number;
  @IsOptional() @Type(() => Number) @IsNumber() moldSetSerial?: number;
  @IsOptional() @IsString() repairReasonCode?: string;
  @IsOptional() @IsString() repairVendorCode?: string;
  @IsOptional() @IsString() repairType?: string;
  @IsOptional() @IsString() applyMachineCode?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() comments?: string;
  @IsOptional() @Type(() => Number) @IsNumber() repairQty?: number;
}

/**
 * 수리 처리 내용 저장 — PB w_mcn_mold_repair_master.
 * 상태는 'P'(수리중)로 바뀌고 수리일이 오늘로 찍힌다.
 */
export class MoldRepairUpdateDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @Type(() => Number) @IsNumber() repairSequence!: number;

  @IsOptional() @IsString() repairBy?: string;
  @IsOptional() @IsString() repairVendorCode?: string;
  @IsOptional() @IsString() repairReasonCode?: string;
  @IsOptional() @IsString() repairComments?: string;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() applyMachineCode?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @Type(() => Number) @IsNumber() repairQty?: number;
  @IsOptional() @Type(() => Number) @IsNumber() repairAmt?: number;
  @IsOptional() @Type(() => Number) @IsNumber() repairTime?: number;
  @IsOptional() @IsDateString() repairReceiptDate?: string;
  @IsOptional() @IsDateString() repairIssueDate?: string;
}

/**
 * 상태 전환 — PB cb_process('Confirm' → 'C') / pb_cancel('Cancel' → 'R').
 * 상태값 자체를 받지 않고 어느 버튼인지만 받는다. 임의 상태를 넣지 못하게 한다.
 */
export class MoldRepairStatusDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @Type(() => Number) @IsNumber() repairSequence!: number;
  @IsIn(['confirm', 'revert']) action!: 'confirm' | 'revert';
}

/** 수리품목 조회 — PB d_mcn_mold_repair_item_lst */
export class MoldRepairItemQueryDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @Type(() => Number) @IsNumber() repairSequence!: number;
}

/** 수리품목 등록·수정 */
export class MoldRepairItemUpsertDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @Type(() => Number) @IsNumber() repairSequence!: number;
  @IsString() @Length(1, 30) repairItemCode!: string;

  @IsOptional() @Type(() => Number) @IsNumber() repairItemQty?: number;
  @IsOptional() @IsString() comments?: string;
}
