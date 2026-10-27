import { Type } from 'class-transformer';
import {
  ArrayMaxSize, IsArray, IsIn, IsInt, IsISO8601,
  IsNotEmpty, IsOptional, IsString, Matches, Max, MaxLength, Min, ValidateNested,
} from 'class-validator';

/** 폐기이력 조회 — 공정폐기 원장 IP_PRODUCT_DESTROY */
export class ProductDestroyHistoryQueryDto {
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() serialNo?: string;
  /** 1=생산1팀(SMT), 2=생산2팀(조립). 비우면 팀 구분 없이 */
  @IsOptional() @IsIn(['1', '2']) team?: string;
  /** D=폐기보관, R=반품, C=취소. 비우면 전체 */
  @IsOptional() @IsIn(['D', 'R', 'C']) status?: string;
  @IsOptional() @IsISO8601() dateFrom?: string;
  @IsOptional() @IsISO8601() dateTo?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 시리얼 단건 현황 — PB dw_1(폐기보관 D) / dw_2(반품 R) */
export class ProductDestroySerialQueryDto {
  @IsString() @IsNotEmpty() serialNo!: string;
}

/** 바코드 미각인 제품 — 품번 + 수량으로 폐기한다 */
export class ProductDestroyItemDto {
  @IsString() @IsNotEmpty() itemCode!: string;
  @Type(() => Number) @IsInt() @Min(1) @Max(100000) qty!: number;
}

/**
 * 폐기 등록 — PB cb_2(Destroy) 가 시리얼 목록을 순회하며 실행한다.
 * 10/22 요청으로 팀별 세분화 항목과 품번 + 수량 등록을 더했다.
 */
export class ProductDestroyExecuteDto {
  /** 1=생산1팀(SMT), 2=생산2팀(조립) — 팀마다 입력 양식이 다르다 */
  @IsIn(['1', '2']) team!: string;
  /** 불량유형 (DESTROY BAD TYPE SMT / ASSY) */
  @IsString() @IsNotEmpty() badReasonCode!: string;
  /** 제품구분 (DESTROY PRODUCT TYPE) */
  @IsString() @IsNotEmpty() productType!: string;
  /** 주(A) / 야(B) */
  @IsIn(['A', 'B']) shiftCode!: string;
  /** 원인 (BAD CAUSE BY: M 작업자, S 원자재, E 설비) */
  @IsIn(['M', 'S', 'E']) causeBy!: string;
  /** 검출공정 (DESTROY PROCESS SMT / ASSY) */
  @IsString() @IsNotEmpty() detectProcessCode!: string;
  /** 생산2팀: 발생공정 (DESTROY PROCESS ASSY) */
  @IsOptional() @IsString() occurProcessCode?: string;
  /** 생산2팀: 불량구분1 (DESTROY BAD CATEGORY) */
  @IsOptional() @IsString() badCategory?: string;
  /** 작업자 — 수기 입력 (CHARGER, 20byte) */
  @IsString() @IsNotEmpty() @MaxLength(20) worker!: string;
  /** 폐기를 낸 부서 (ISYS_DEPARTMENT.DEPARTMENT_CODE) */
  @IsString() @IsNotEmpty() departmentCode!: string;
  /** 라인. 고르면 이 값을 쓰고, 비우면 시리얼의 최신 공정이력 라인을 쓴다 */
  @IsOptional() @IsString() lineCode?: string;
  /** IP_PRODUCT_WORKSTAGE_IO 에 이력이 없을 때 쓰는 대체 공정 (PB 드롭다운). 없으면 '*' */
  @IsOptional() @IsString() fallbackWorkstageCode?: string;
  /** 시리얼이 2D 바코드 이력에 없을 때 쓰는 품번 */
  @IsOptional() @IsString() fallbackItemCode?: string;
  @IsOptional() @IsArray() @ArrayMaxSize(1000) @IsString({ each: true })
  serialNos: string[] = [];
  @IsOptional() @IsArray() @ArrayMaxSize(200) @ValidateNested({ each: true }) @Type(() => ProductDestroyItemDto)
  items: ProductDestroyItemDto[] = [];
}

/** 팀별 월 폐기 요약 */
export class ProductDestroySummaryQueryDto {
  @Matches(/^\d{4}-\d{2}$/) month!: string;
  @IsIn(['1', '2']) team!: string;
}

/** 반품처리(Issue) / 반품취소(Issue Cancel) — 상태를 D(폐기보관) ↔ R(반품) 로 바꾼다 */
export class ProductDestroyIssueDto {
  @Type(() => Number) @IsInt() destroySeq!: number;
}

/** 폐기 취소 — 잘못 등록한 폐기를 취소(C)로 바꾼다. 행은 지우지 않는다 */
export class ProductDestroyCancelDto {
  @IsArray() @ArrayMaxSize(500) @Type(() => Number) @IsInt({ each: true })
  destroySeqs!: number[];
  /** 취소 사유 (CANCEL_REASON, 500byte) */
  @IsString() @IsNotEmpty() @MaxLength(150) reason!: string;
}
