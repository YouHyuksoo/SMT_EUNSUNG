import { Type } from 'class-transformer';
import {
  IsDateString, IsIn, IsInt, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/**
 * IQC 대상 목록 조회 — PB d_mat_rceipt_barcode_4_iqc_wait_lst / _cancel_lst 의
 * retrieve 인자와 1:1. 두 목록은 판정여부 조건만 다르므로 `mode` 로 가른다.
 */
export class IqcTargetQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  /** wait = 판정 대기(아직 P/R 아님) · cancel = 판정된 것(P/R, 취소 대상) */
  @IsIn(['wait', 'cancel']) mode!: 'wait' | 'cancel';

  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() itemName?: string;
  @IsOptional() @IsString() itemBarcode?: string;
  @IsOptional() @IsString() receiptSlipNo?: string;
  /** PB 는 이 조건을 = 로 걸었다(대기 목록). 비우면 'N'(입고대기) 이다. */
  @IsOptional() @IsString() receiptCompareYn?: string;

  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** IQC 검사이력 조회 — PB d_qc_iqc_lst */
export class IqcHistoryQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() iqcInspectNo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * IQC 판정 — PB b_ok(합격) / b_ng(불합격).
 * 전표 단위로 판정한다. 불합격이면 불량원인을 반드시 받는다(PB 는 팝업으로 골랐다).
 */
export class IqcJudgeDto {
  @IsString() @Length(1, 30) receiptSlipNo!: string;
  @IsIn(['P', 'R']) inspectResult!: 'P' | 'R';
  /** 합격이면 서버가 'GOOD' 으로 채운다. 불합격이면 필수. */
  @IsOptional() @IsString() @Length(1, 20) badReasonCode?: string;
}

/** IQC 판정취소 — PB b_cancel */
export class IqcCancelDto {
  @IsString() @Length(1, 30) receiptSlipNo!: string;
}

/** ESD 점검 완료 — PB b_esd_check */
export class IqcEsdCheckDto {
  @IsString() @Length(1, 20) supplierCode!: string;
  @IsString() @Length(1, 30) itemCode!: string;
}
