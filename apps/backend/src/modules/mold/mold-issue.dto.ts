import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** S-PARTS 출고 조회 — PB d_mcn_mold_issue_lst 의 retrieve 인자와 1:1 */
export class MoldIssueQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 출고 대상 재고 목록 — PB d_mcn_mold_inventory_4_issue_lst */
export class MoldIssueTargetQueryDto {
  @IsOptional() @IsString() moldCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() moldUseStatus?: string;
}

/** 출고 가능한 청구 목록 — PB d_mcn_mold_request_4_issue_lst */
export class MoldIssueRequestQueryDto {
  @IsOptional() @IsString() moldCode?: string;
}

/**
 * 재고 직접출고 등록.
 * 출고항번은 받지 않는다 — PB 와 같이 SEQ_MAT_ISSUE 로 서버가 채번한다.
 * 출고구분='3'(3출고), 출고상태='N'(정상) 도 PB 기본값이다.
 */
export class MoldIssueCreateDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @Type(() => Number) @IsNumber() issueQty!: number;
  /** PB 는 출고계정을 반드시 고르게 한다 (빈 값·'%' 면 진행하지 않았다) */
  @IsString() @Length(1, 10) moldIssueAccount!: string;

  @IsOptional() @Type(() => Number) @IsNumber() moldVersion?: number;
  @IsOptional() @Type(() => Number) @IsNumber() moldSetSerial?: number;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() machineCode?: string;
  @IsOptional() @IsString() locationCode?: string;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() lineType?: string;
  @IsOptional() @IsString() supplierCode?: string;
  /** 비우면 유효한 구매단가를 끌어온다 (PB f_get_mold_unit_price) */
  @IsOptional() @Type(() => Number) @IsNumber() issuePrice?: number;
}

/**
 * 청구건 출고 등록 — PB 는 이 경로에서만 SEQ_MOLD_ISSUE_SEQUENCE 로 채번하고
 * 청구를 완료('C')로 바꾼다. 두 시퀀스를 섞어 쓰는 것도 PB 그대로다.
 */
export class MoldIssueFromRequestDto {
  @IsString() @Length(1, 30) moldCode!: string;
  @IsDateString() requestDate!: string;
  @Type(() => Number) @IsNumber() requestSequence!: number;
  @Type(() => Number) @IsNumber() issueQty!: number;
  @IsString() @Length(1, 10) moldIssueAccount!: string;

  @IsOptional() @Type(() => Number) @IsNumber() moldVersion?: number;
  @IsOptional() @Type(() => Number) @IsNumber() moldSetSerial?: number;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() machineCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
}

/** 출고 취소 — PB f_mcn_mold_issue_cancel 과 같은 키 */
export class MoldIssueCancelDto {
  @IsDateString() issueDate!: string;
  @Type(() => Number) @IsNumber() issueSequence!: number;
}
