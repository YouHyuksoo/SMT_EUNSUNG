/**
 * @file src/modules/query/query.dto.ts
 * @description 조회(M_QUERY) 9화면 DTO
 *
 * 이 대분류는 이름이 '조회' 지만 절반이 쓰기 화면이다 (PB 버튼 실측):
 *   323 X-OUT Repair · 327 NG사유·메모 저장 · 328 검사플래그 저장 ·
 *   329 NSNP 제어 + 피더 잔량 세팅 · 330 실적 보정 · 335 NSNP 제어 + 이력 초기화
 * 그래서 조회 DTO 와 저장 DTO 를 한 파일에 두고 무엇이 쓰기인지 주석에 적는다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  IsArray,
  IsIn,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  Length,
  Matches,
  Min,
  ValidateNested,
} from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;
/** TO_CHAR(..., 'YYYYMMDDHH24MISS') 로 주고받는 불투명 시각 키 */
const TS14 = /^\d{14}$/;

// ───────────────────────────────── 323 PID 정보조회

/**
 * PID 정보조회 조건.
 *
 * **IP_PRODUCT_2D_BARCODE 는 1.8억행이고 이 화면에는 날짜 조건이 없다.**
 * PB 는 빈 조건을 `'%'` 로 보내 전체를 훑을 수 있었다. 서비스가
 * checkTrackingFilter 로 Run No·PID·매거진 중 하나를 요구한다 — 모델·라인만으로는
 * 열리지 않는다 (그 둘은 선택도가 낮다).
 */
export class PidInfoQueryDto {
  @ApiPropertyOptional({ description: 'Run No (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;

  @ApiPropertyOptional({ description: 'PID = 2D 바코드 일련번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  serialNo?: string;

  @ApiPropertyOptional({ description: '매거진 번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  magazineNo?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치). 이것만으로는 조회할 수 없다.' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치). 이것만으로는 조회할 수 없다.' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;
}

/**
 * X-OUT 불량 해제 (PB 'X-OUT Repair' — **쓰기**).
 *
 * IP_PRODUCT_WORK_QC 에서 그 PID 의 BAD_REASON_CODE='X-OUT' 행을 지운다.
 * 불량으로 잡혔던 PID 를 수리해 되살리는 동작이라 누가 했는지 남겨야 한다.
 */
export class XOutRepairDto {
  @ApiProperty({ description: 'PID = 2D 바코드 일련번호' })
  @IsString() @Length(1, 30)
  serialNo!: string;

  @ApiPropertyOptional({ description: '수리자 메모. PB sle_message 에 해당한다.' })
  @IsOptional() @IsString() @Length(0, 200)
  comments?: string;
}

// ───────────────────────────────── 324 마킹이력조회

export class MarkingQueryDto {
  @ApiPropertyOptional({ description: 'Run No (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;

  @ApiPropertyOptional({ description: 'PID (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  serialNo?: string;

  @ApiProperty({ description: '마킹일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '마킹일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;
}

// ───────────────────────────────── 325 PCB 투입 리스트조회

export class PcbInputQueryDto {
  @ApiPropertyOptional({ description: 'Run No (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: 'PCB 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  itemBarcode?: string;

  @ApiPropertyOptional({ description: '제조주차 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 20)
  manufactureWeek?: string;

  @ApiProperty({ description: '스캔일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '스캔일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;
}

// ───────────────────────────────── 327 SMT 오장착 스캔 현황

/**
 * PDA 스캔 이력 조건. 기간이 필수다 — IB_SMT_CHECKHIST 는
 * (CHECK_DATE, SCAN_PARTNAME) 인덱스가 있어 구간이 닫혀 있어야 인덱스를 탄다.
 */
export class PdaScanQueryDto {
  @ApiProperty({ description: '스캔일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '스캔일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: 'SMT 모델명 = 설비 롯트명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '피더 위치 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  locationCode?: string;

  @ApiPropertyOptional({ description: "체크 상태. 'P' 합격 · 'E' 오류 · 'W' 대기 · 'C' 처리중 · 'R' 대체" })
  @IsOptional() @IsString() @Length(0, 5)
  checkStatus?: string;

  @ApiPropertyOptional({ description: "체크 유형. '1' CCS · '2' 릴교환 · '3' 풀체크 · '4' 릴체크" })
  @IsOptional() @IsString() @Length(0, 10)
  checkType?: string;

  @ApiPropertyOptional({ description: '스캔 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  scanBarcode?: string;
}

/** 바코드 하나로 세 컬럼(자사·공급처·이전)을 한꺼번에 찾는다. PB 와 같은 OR 조건이다. */
export class BarcodeHistoryQueryDto {
  @ApiProperty({ description: '바코드 (앞부분 일치). 자사·공급처·이전 바코드를 모두 본다.' })
  @IsString() @Length(1, 60)
  barcode!: string;
}

/**
 * 오장착 건에 NG 사유·메모를 적는다 (**쓰기**).
 * PB `d_smt_checklist_lst` 의 update=yes 컬럼은 NG_REASON·COMMENTS 둘뿐이다 (실측).
 */
export class CheckHistNoteDto {
  @ApiProperty({ description: '체크 이력 키 — 라인코드' })
  @IsString() @Length(1, 30)
  lineCode!: string;

  @ApiProperty({ description: '체크 이력 키 — 설비 롯트명' })
  @IsString() @Length(1, 60)
  lotName!: string;

  @ApiProperty({ description: '체크 이력 키 — 체크 순번' })
  @Type(() => Number) @IsInt()
  checkSequence!: number;

  @ApiProperty({ description: '체크 이력 키 — 체크 시각 (YYYYMMDDHH24MISS)' })
  @IsString() @Matches(TS14)
  checkDateKey!: string;

  @ApiPropertyOptional({ description: 'NG 사유' })
  @IsOptional() @IsString() @Length(0, 200)
  ngReason?: string;

  @ApiPropertyOptional({ description: '메모' })
  @IsOptional() @IsString() @Length(0, 500)
  comments?: string;
}

export class CheckHistNoteBulkDto {
  @ApiProperty({ description: '저장할 행 목록', type: [CheckHistNoteDto] })
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(500)
  @ValidateNested({ each: true }) @Type(() => CheckHistNoteDto)
  rows!: CheckHistNoteDto[];
}

// ───────────────────────────────── 328 PDA 검사오류내역조회

export class PlanDataQueryDto {
  @ApiProperty({ description: '모델명 (상위 품목). PB 는 등호로 걸었다.' })
  @IsString() @Length(1, 60)
  modelName!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: "PCB 면. 'T' 상 · 'B' 하. 비우면 전부" })
  @IsOptional() @IsString() @Length(0, 5)
  pcbItem?: string;

  @ApiPropertyOptional({ description: '리비전. 비우면 전부' })
  @IsOptional() @IsString() @Length(0, 20)
  revision?: string;
}

/** 라인 단위 NG 체크 목록 (PB d_smt_plandata_ng_check_4_plan) */
export class LineCodeQueryDto {
  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 10)
  lineCode!: string;
}

/**
 * 계획데이터의 검사 플래그를 조정한다 (**쓰기**).
 * PB `d_smt_plandata_ng_check_4_plan` 의 update=yes 컬럼은
 * CHECK_YN · CHECK_STATUS · CCS_YN 셋이다 (실측).
 */
export class PlanCheckFlagDto {
  // 실측 유일인덱스 XPKIB_PRODUCT_PLANDATA =
  //   MODEL_NAME + LINE_CODE + LOCATION_CODE + ITEM_CODE + MACHINE + TABLE_ID + PCB_ITEM
  // 7컬럼이다. 일부만 WHERE 에 넣으면 같은 위치의 다른 설비·테이블 계획까지 바뀐다.
  @ApiProperty({ description: '계획 키 — 라인코드' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiProperty({ description: '계획 키 — 모델명' })
  @IsString() @Length(1, 60)
  modelName!: string;

  @ApiProperty({ description: '계획 키 — 피더 위치' })
  @IsString() @Length(1, 30)
  locationCode!: string;

  @ApiProperty({ description: '계획 키 — 품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({ description: '계획 키 — 설비' })
  @IsString() @Length(1, 30)
  machine!: string;

  @ApiProperty({ description: '계획 키 — 테이블' })
  @IsString() @Length(1, 10)
  tableId!: string;

  @ApiProperty({ description: '계획 키 — PCB 면' })
  @IsString() @Length(1, 5)
  pcbItem!: string;

  @ApiPropertyOptional({ description: "검사 사용 여부 'Y'/'N'" })
  @IsOptional() @IsIn(['Y', 'N'])
  checkYn?: 'Y' | 'N';

  @ApiPropertyOptional({ description: '검사 상태' })
  @IsOptional() @IsString() @Length(0, 10)
  checkStatus?: string;

  @ApiPropertyOptional({ description: "CCS 사용 여부 'Y'/'N'" })
  @IsOptional() @IsIn(['Y', 'N'])
  ccsYn?: 'Y' | 'N';
}

export class PlanCheckFlagBulkDto {
  @ApiProperty({ description: '저장할 행 목록', type: [PlanCheckFlagDto] })
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(500)
  @ValidateNested({ each: true }) @Type(() => PlanCheckFlagDto)
  rows!: PlanCheckFlagDto[];
}

// ───────────────────────────────── 329 SMT 피더별 모니터링

export class FeederMonitorQueryDto {
  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;
}

/** 피더 한 자리의 최근 투입 이력 (PB 'Show Change History') */
export class FeederSlotQueryDto {
  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiProperty({ description: '설비 롯트명 (IB_SMT_CHECKHIST.LOT_NAME)' })
  @IsString() @Length(1, 60)
  lotName!: string;

  @ApiProperty({ description: '피더 위치' })
  @IsString() @Length(1, 30)
  locationCode!: string;

  @ApiProperty({ description: '품목코드' })
  @IsString() @Length(1, 50)
  itemCode!: string;
}

// ───────────────────────────────── 330 SMT 제품실적센서이력조회

export class SensorActualQueryDto {
  @ApiProperty({ description: '라인코드 (앞부분 일치)' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치). 시간대·시간 이력에만 쓴다.' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '기준일 (YYYY-MM-DD). 시간대·시간 이력에만 쓴다.' })
  @IsOptional() @IsString() @Matches(DATE_ONLY)
  dateFrom?: string;
}

/**
 * 실적 보정 (PB 'Actual Adjust' — **쓰기**).
 * `d_pln_product_sensor_actual_lst` 의 update=yes 컬럼은
 * PRODUCT_ACTUAL_QTY · ADJUST_QTY 둘뿐이다 (실측).
 */
export class SensorActualAdjustDto {
  // 실측 PK XPKIP_PRODUCT_SENSOR_ACTUAL = RECEIPT_DATE + RECEIPT_SEQUENCE + ORGANIZATION_ID.
  // 라인·공정으로 잡으면 같은 라인의 다른 시점 실적까지 바뀐다.
  @ApiProperty({ description: '실적 키 — 수집시각 (YYYYMMDDHH24MISS). 목록이 그대로 돌려준다.' })
  @IsString() @Matches(TS14)
  receiptDateKey!: string;

  @ApiProperty({ description: '실적 키 — 수집 순번' })
  @Type(() => Number) @IsInt()
  receiptSequence!: number;

  @ApiPropertyOptional({ description: '보정 후 실적수량' })
  @IsOptional() @Type(() => Number) @IsNumber() @Min(0)
  productActualQty?: number;

  @ApiPropertyOptional({ description: '보정 수량 (가감분)' })
  @IsOptional() @Type(() => Number) @IsNumber()
  adjustQty?: number;
}

// ───────────────────────────────── 333 자재 바코드 상태 조회

export class MaterialBarcodeQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 제조번호 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  lotNo?: string;

  @ApiPropertyOptional({ description: '자재 바코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  itemBarcode?: string;
}

// ───────────────────────────────── 335 NSNP 처리이력조회

export class NsnpHistoryQueryDto {
  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiProperty({ description: '발생일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '발생일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;
}

/** NSNP 제어 (**쓰기**) — 329·335 공용. 구현은 NsnpControlService 한 곳에 있다. */
export class NsnpControlDto {
  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiProperty({
    description: "동작. 'lock' 잠금 · 'unlock' 강제해제 · 'use' 사용 · 'noUse' 미사용(해제 포함)",
    enum: ['lock', 'unlock', 'use', 'noUse'],
  })
  @IsIn(['lock', 'unlock', 'use', 'noUse'])
  action!: 'lock' | 'unlock' | 'use' | 'noUse';
}
