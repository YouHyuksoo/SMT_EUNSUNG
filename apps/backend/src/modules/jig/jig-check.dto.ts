import { Type } from 'class-transformer';
import { IsDateString, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

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
