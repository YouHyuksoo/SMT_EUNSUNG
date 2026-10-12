import { Type } from 'class-transformer';
import {
  ArrayMaxSize, ArrayNotEmpty, IsArray, IsDateString, IsIn, IsInt,
  IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/**
 * PID 홀딩 조회 — PB d_pln_product_2d_barcode_4_holding.
 *
 * ⚠ `IP_PRODUCT_2D_BARCODE` 는 1억 8천만 행이다. 쓸 수 있는 인덱스는
 *   SERIAL_NO(유니크) · RUN_NO · MAGAZINE_NO · BOX_NO 뿐이고
 *   MODEL_NAME · LINE_CODE · BARCODE_STATUS 에는 인덱스가 없다.
 *
 * PB 는 조건 없이도 조회가 됐지만(현장에서 늘 PID 를 찍어 썼다) 웹에서 그대로 열어두면
 * 조회 한 번에 운영 DB 를 1억 8천만 행 풀스캔한다. 그래서 **인덱스가 있는 넷 중
 * 최소 하나를 필수로 요구한다.** 결과를 잘라서 주지 않는다 —
 * 찾는 PID 가 없는 것인지 잘린 것인지 구분할 수 없게 되면 홀딩 화면에서는 더 위험하다.
 */
export class PidHoldingQueryDto {
  /** 아래 넷 중 최소 하나는 있어야 한다 (컨트롤러·서비스가 검사한다) */
  @IsOptional() @IsString() serialNo?: string;
  @IsOptional() @IsString() runNo?: string;
  @IsOptional() @IsString() magazineNo?: string;
  @IsOptional() @IsString() boxNo?: string;

  /** 보조 조건 — 위 필수 조건으로 좁힌 뒤에만 걸린다 */
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() barcodeStatus?: string;

  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 인덱스가 있어 단독으로 조회를 좁힐 수 있는 조건 */
export const PID_HOLDING_REQUIRED_FILTERS = [
  'serialNo', 'runNo', 'magazineNo', 'boxNo',
] as const;

/**
 * PID 홀딩 / 홀딩해제 — PB w_pln_product_barcode_holding.
 * 바코드상태(BARCODE_STATUS)를 'H'(홀딩) / 'N'(정상) 으로 바꾼다.
 */
export class PidHoldingUpdateDto {
  /** PB 는 그리드에서 체크한 행을 한 번에 바꿨다. 여러 PID 를 받는다. */
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(1000)
  @IsString({ each: true }) @Length(1, 60, { each: true })
  serialNos!: string[];

  @IsIn(['H', 'N']) barcodeStatus!: 'H' | 'N';
}

/** PCB 이슈발생 스캔 이력 조회 — PB d_qc_pid_issue_scan_hist */
export class PidIssueScanHistoryQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() serialNo?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() pidIssueType?: string;
  /** IP_PRODUCT_ISSUE_PID_SCAN 의 컬럼명은 LOCATION 이다 (LOCATION_CODE 아님) */
  @IsOptional() @IsString() location?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/** 선택 PID 의 이슈 스캔 내역 — PB d_qc_pid_issue_scan_lst */
export class PidIssueScanByPidDto {
  @IsString() @Length(1, 60) serialNo!: string;
}
