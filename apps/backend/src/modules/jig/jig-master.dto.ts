import { Type } from 'class-transformer';
import {
  IsDateString, IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** 지그마스터 조회 — PB d_mcn_jig_lst 의 retrieve 인자와 1:1 */
export class JigMasterQueryDto {
  @IsOptional() @IsString() jigCode?: string;
  @IsOptional() @IsString() jigLotNo?: string;
  @IsOptional() @IsString() jigType?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() jigStatus?: string;
  /** PB d_mcn_feeder_lst 의 arg_model_name — 피더관리 화면이 쓴다 */
  @IsOptional() @IsString() jigModelName?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 지그 등록·수정 본문.
 * 감사컬럼(ORGANIZATION_ID / ENTER_BY / ENTER_DATE / LAST_MODIFY_BY / LAST_MODIFY_DATE)은
 * 본문으로 받지 않는다 — PB f_set_security_row 가 하던 일을 서버가 대신 채운다.
 */
export class JigMasterUpsertDto {
  @IsString() @Length(1, 30) jigCode!: string;
  @IsString() @Length(1, 30) jigLotNo!: string;
  @IsString() @Length(1, 100) jigName!: string;
  @IsString() @Length(1, 10) jigType!: string;

  @IsOptional() @IsString() jigStatus?: string;
  @IsOptional() @IsString() useStatus?: string;
  @IsOptional() @IsString() acquisitionType?: string;
  @IsOptional() @IsDateString() acquisitionDate?: string;
  @IsOptional() @IsString() jigModelName?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() machineCode?: string;
  @IsOptional() @IsString() customerCode?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() nationCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() jigSpec?: string;
  @IsOptional() @IsString() pcbItem?: string;
  @IsOptional() @IsString() solderType?: string;
  @IsOptional() @IsString() capacityUom?: string;
  @IsOptional() @IsString() locationAddress?: string;
  @IsOptional() @IsString() manualLocationComment?: string;
  @IsOptional() @IsString() managementCommnets?: string;
  @IsOptional() @IsString() useTpmYn?: string;
  @IsOptional() @IsString() useNsnpYn?: string;
  @IsOptional() @IsString() tensionCheckYn?: string;

  @IsOptional() @Type(() => Number) @IsNumber() capacity?: number;
  @IsOptional() @Type(() => Number) @IsNumber() reservedCapacity?: number;
  @IsOptional() @Type(() => Number) @IsNumber() useRate?: number;
  @IsOptional() @Type(() => Number) @IsNumber() uphValue?: number;
  @IsOptional() @Type(() => Number) @IsNumber() breakValue?: number;
  @IsOptional() @Type(() => Number) @IsNumber() hitValue?: number;
  @IsOptional() @Type(() => Number) @IsNumber() minTension?: number;
  @IsOptional() @Type(() => Number) @IsNumber() maxTension?: number;

  @IsOptional() @IsDateString() receiptDate?: string;
  @IsOptional() @IsDateString() lastInspectDate?: string;
  @IsOptional() @IsDateString() issueDate?: string;
  @IsOptional() @IsDateString() destroyDate?: string;
}

/** 적용모델 목록 조회 */
export class JigApplyModelQueryDto {
  @IsString() jigCode!: string;
  @IsString() jigLotNo!: string;
}

/** 적용모델 복사 — PB cb_9(Apply Model Copy) */
export class JigApplyModelCopyDto {
  /** 복사 원본 지그 LOT */
  @IsString() @Length(1, 30) fromJigLotNo!: string;
  /** 복사 대상 지그 (선택 행) */
  @IsString() @Length(1, 30) toJigCode!: string;
  @IsString() @Length(1, 30) toJigLotNo!: string;
  /** 원본 존재 검증에 쓰는 지그유형 (PB 는 선택 행의 jig_type 을 넘긴다) */
  @IsString() @Length(1, 10) jigType!: string;
}
