import { Type } from 'class-transformer';
import {
  IsDateString, IsIn, IsInt, IsNumber, IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** 기간 + 지그LOT 을 공통으로 쓰는 검사이력 조회 */
class CheckQueryBase {
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @IsString() jigLotNo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 스퀴즈검사관리 — PB d_mcn_jig_squeze_check_mlst */
export class SqueezeCheckQueryDto extends CheckQueryBase {
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() jigCheckStatus?: string;
}

/**
 * 메탈마스크 텐션검사 — PB d_mcn_jig_mask_check_lst / d_mcn_jig_check_4_tension_lst
 * modelName 이 있으면 PB 처럼 IMCN_JIG_APPLY_MODEL 서브쿼리로 적용모델을 걸러낸다.
 */
export class MaskCheckQueryDto extends CheckQueryBase {
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() jigCheckStatus?: string;
  @IsOptional() @IsString() modelName?: string;
}

/** 지그수리 (신청/관리 공용) — PB d_mcn_jig_repair_lst */
export class JigRepairQueryDto {
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @IsString() jigCode?: string;
  @IsOptional() @IsString() repairStatus?: string;
  @IsOptional() @IsString() repairVendorCode?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 지그출고관리 — PB d_mcn_jig_issue_lst */
export class JigIssueQueryDto {
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @IsString() jigCode?: string;
  @IsOptional() @IsString() jigType?: string;
  @IsOptional() @IsString() issueStatus?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 지그자주보전관리 — PB d_mcn_jig_pm_plan_lst */
export class JigPmQueryDto {
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() jigCode?: string;
  @IsOptional() @IsString() jigLotNo?: string;
  @IsOptional() @IsString() pmType?: string;
  @IsOptional() @IsString() confirmYn?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 샘플마스터 관리 — PB d_mcn_sample_lst */
export class SampleMasterQueryDto {
  @IsOptional() @IsString() sampleCode?: string;
  @IsOptional() @IsString() sampleName?: string;
  @IsOptional() @IsString() sampleType?: string;
  @IsOptional() @IsString() sampleStatus?: string;
  @IsOptional() @IsString() useStatus?: string;
  @IsOptional() @IsString() locationAddress?: string;
  /** PB arg_remain_days — 잔여일이 이 값 이하인 것만 (미지정 시 10000) */
  @IsOptional() @Type(() => Number) @IsInt() remainDays?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 샘플별 적용모델 — PB d_mcn_sample_apply_model_lst */
export class SampleApplyModelQueryDto {
  @IsString() sampleCode!: string;
  @IsString() sampleLotNo!: string;
}

/** 스퀴즈 바코드 스캔 등록 — PB sle_barcode.modified 한 번에 조회·판정·등록이 돈다 */
export class SqueezeScanDto {
  @IsString() jigLotNo!: string;
}

/** 메탈마스크 장력검사 등록 — 스캔 후 장력 5개를 입력해 저장한다 */
export class MaskTensionSaveDto {
  @IsString() jigLotNo!: string;
  /** 'P' 합격 / 'N' 불합격 — 화면이 기준치와 비교해 판정한다 */
  @IsIn(['P', 'N']) checkStatus!: 'P' | 'N';
  @IsOptional() @IsIn(['Y', 'N']) cleanYn?: 'Y' | 'N';
  @IsOptional() @Type(() => Number) @IsNumber() tension1?: number;
  @IsOptional() @Type(() => Number) @IsNumber() tension2?: number;
  @IsOptional() @Type(() => Number) @IsNumber() tension3?: number;
  @IsOptional() @Type(() => Number) @IsNumber() tension4?: number;
  @IsOptional() @Type(() => Number) @IsNumber() tension5?: number;
  @IsOptional() @IsString() comments?: string;
}

/** 바코드 스캔 시 지그 기준정보 조회 (등록 전 화면 표시용) */
export class JigScanLookupDto {
  @IsString() jigLotNo!: string;
  /** 'S' 스퀴즈 / 'M' 메탈마스크 */
  @IsIn(['S', 'M']) jigType!: 'S' | 'M';
}

/** 지그 수리신청 접수 — PB w_mcn_jig_repair_request_master 'INSERT' */
export class JigRepairRequestDto {
  @IsString() jigCode!: string;
  @IsString() jigLotNo!: string;
  @IsOptional() @IsString() repairReasonCode?: string;
  @IsOptional() @IsString() repairVendorCode?: string;
  @IsOptional() @IsString() comments?: string;
  @IsOptional() @IsString() currency?: string;
}

/** 수리 상태 전이 — PB cb_ok('P' 수리중) / cb_complete('C' 수리완료) */
export class JigRepairStatusDto {
  @IsString() jigCode!: string;
  @IsString() jigLotNo!: string;
  @Type(() => Number) @IsInt() repairSequence!: number;
  @IsString() repairStatus!: string;
  @IsOptional() @IsDateString() repairDate?: string;
  @IsOptional() @IsString() repairBy?: string;
  @IsOptional() @Type(() => Number) @IsNumber() repairTime?: number;
  @IsOptional() @Type(() => Number) @IsNumber() repairAmt?: number;
  @IsOptional() @IsString() repairComments?: string;
}

/**
 * 샘플마스터 등록·수정 — PB w_mcn_sample_master 의 dw_2(d_mcn_sample_mst).
 * 감사컬럼은 본문으로 받지 않는다 (PB f_set_security_row 가 하던 일을 서버가 한다).
 */
export class SampleMasterUpsertDto {
  @IsString() @Length(1, 30) sampleCode!: string;
  @IsString() @Length(1, 30) sampleLotNo!: string;
  @IsString() @Length(1, 100) sampleName!: string;
  @IsString() @Length(1, 10) sampleType!: string;

  @IsOptional() @IsString() sampleSpec?: string;
  @IsOptional() @IsString() sampleStatus?: string;
  @IsOptional() @IsString() sampleSection?: string;
  @IsOptional() @IsString() sampleGrade?: string;
  @IsOptional() @IsString() useStatus?: string;
  @IsOptional() @IsDateString() sampleApplyDate?: string;
  @IsOptional() @Type(() => Number) @IsInt() validMonths?: number;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() sampleBarcode?: string;
  @IsOptional() @IsString() locationAddress?: string;
  @IsOptional() @IsString() managementCommnets?: string;
  @IsOptional() @IsString() useNsnpYn?: string;
}

/** 샘플마스터 삭제 — PB 'DELETE' 분기 */
export class SampleMasterDeleteDto {
  @IsString() sampleCode!: string;
  @IsString() sampleLotNo!: string;
}
