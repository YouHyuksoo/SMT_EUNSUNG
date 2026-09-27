/**
 * @file src/modules/tracking/tracking.dto.ts
 * @description 추적 7화면 공용 DTO
 *              PB w_product_pid_tracking_rpt / w_product_material_tracking_rpt
 *                 w_product_material_tracking_msl_rpt / w_product_pid_tracking_fpcb_rpt
 *                 w_pln_product_barcode_tracking / w_pln_product_all_barcode_tracking
 *                 w_com_production_status_dashboard
 *
 * 필수조건 판정은 여기서 하지 않고 `@smt/shared` 의 checkTrackingFilter 가 한다.
 * 프론트도 같은 함수로 조회 버튼을 막는다 — 규칙을 두 곳에 두면 한쪽만 고쳐진다.
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsBoolean,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  Min,
} from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;
/** TO_CHAR(..., 'YYYYMMDDHH24MISS') 로 주고받는 불투명 시각 키 */
const TS14 = /^\d{14}$/;

/** 자재 제조번호 하나. PB 는 바코드를 받아 F_GET_LOT_NO_FROM_BARCODE 로 제조번호를 뽑았다. */
export class LotNoQueryDto {
  @ApiProperty({
    description: '자재 제조번호 또는 자재 바코드. 바코드를 넣으면 서버가'
      + ' F_GET_LOT_NO_FROM_BARCODE 로 제조번호를 뽑는다 (PB 와 같은 함수).',
  })
  @IsString() @Length(1, 60)
  lotNo!: string;
}

/** PID(2D 바코드 일련번호) 하나 */
export class SerialNoQueryDto {
  @ApiProperty({ description: 'PID = 2D 바코드 일련번호 (IP_PRODUCT_2D_BARCODE.SERIAL_NO)' })
  @IsString() @Length(1, 30)
  serialNo!: string;
}

/** 롯트카드 번호 하나 */
export class RunNoQueryDto {
  @ApiProperty({ description: '롯트카드 번호 (IP_PRODUCT_RUN_CARD.RUN_NO)' })
  @IsString() @Length(1, 30)
  runNo!: string;
}

/**
 * 313 SPI 조회. PB 는 위 표에서 고른 투입 구간(check_date_start ~ check_date_end)과
 * 그 라인을 그대로 넘겼다. **기간을 사용자가 자유로 넓힐 수 없다** — 고른 행이 정한다.
 */
export class MaterialLotSpiQueryDto {
  @ApiProperty({ description: '투입 시작 시각 (YYYYMMDDHH24MISS)' })
  @IsString() @Matches(TS14)
  checkDateStart!: string;

  @ApiProperty({ description: '투입 종료 시각 (YYYYMMDDHH24MISS)' })
  @IsString() @Matches(TS14)
  checkDateEnd!: string;

  @ApiProperty({
    description: '라인코드. SMT 통합라인(31~34)은 서버가 SPI 장비라인 2개로 펼친다'
      + ' — PB 가 하드코딩한 매핑이다.',
  })
  @IsString() @Length(1, 10)
  lineCode!: string;
}

/**
 * 314 자재추적(동적) 2단계. 위 표에서 고른 공정 시점으로 그 순간 라인에 세팅돼 있던
 * 자재를 되짚는다.
 */
export class DynamicMaterialQueryDto {
  @ApiPropertyOptional({ description: 'SMT 모델명. 비우면 모델 무시(%)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: '라인코드. 비우면 라인 무시(%)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({
    description: '탐색 하한 시각 (YYYYMMDDHH24MISS). 비우면 기준시각 -30일'
      + ' — PB 의 nvl(:arg_min_datetime, sysdate - 30) 을 그대로 옮긴 것이다.',
  })
  @IsOptional() @IsString() @Matches(TS14)
  minDatetime?: string;

  @ApiProperty({ description: '기준 시각 (YYYYMMDDHH24MISS). 고른 공정의 검사시각이다.' })
  @IsString() @Matches(TS14)
  maxDatetime!: string;

  @ApiPropertyOptional({
    description: '기준시각 이후 몇 분까지 추가 투입을 볼지. PB em_time 기본 0',
    default: 0,
  })
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) @Max(1440)
  timeMinutes?: number;
}

/** 318·319 공용 롯트카드 목록 */
export class RunCardListQueryDto {
  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  modelName?: string;

  @ApiPropertyOptional({ description: 'Run No (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  runNo?: string;

  @ApiProperty({ description: '지시일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '지시일 종료 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;
}

/** 321 대시보드 라인 조회 */
export class LineDashboardQueryDto {
  @ApiProperty({ description: '라인코드. 대시보드는 한 라인씩 본다 (PB ddlb_line).' })
  @IsString() @Length(1, 10)
  lineCode!: string;
}

/**
 * 321 상세 탭 일괄 조회.
 *
 * PB 는 '상세조회' 를 누르면 9개 DataWindow 를 각각 retrieve 했다. 웹에서 9번
 * 왕복하면 라인 하나 고를 때마다 9개 요청이 뜬다 — 한 번에 받아 탭에 나눈다.
 */
export class LineDashboardDetailQueryDto {
  @ApiProperty({ description: '진행 중인 Run No (대시보드 뷰의 RUNNING_RUN_NO)' })
  @IsString() @Length(1, 30)
  runNo!: string;

  @ApiProperty({ description: '라인코드. 인터록 이력은 Run No 가 아니라 라인으로 찾는다.' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiPropertyOptional({ description: '솔더 롯트번호 (솔더 탭)' })
  @IsOptional() @IsString() @Length(0, 60)
  solderLotNo?: string;

  @ApiPropertyOptional({ description: '마스크 지그 롯트번호 (마스크 탭)' })
  @IsOptional() @IsString() @Length(0, 60)
  maskLotNo?: string;

  @ApiPropertyOptional({ description: '스퀴지 지그 롯트번호 1 (스퀴지 탭)' })
  @IsOptional() @IsString() @Length(0, 60)
  squeezeLotNo?: string;

  @ApiPropertyOptional({ description: '스퀴지 지그 롯트번호 2 (스퀴지 탭 — PB 는 둘을 OR 로 본다)' })
  @IsOptional() @IsString() @Length(0, 60)
  squeezeLotNo2?: string;
}

/**
 * 321 NSNP 잠금/해제.
 *
 * PB 는 사용자 레벨 8 미만이면 막았다. 그 가드를 그대로 유지한다 —
 * 잠금은 라인을 세우는 일이라 아무나 누르면 안 된다.
 */
export class NsnpLockDto {
  @ApiProperty({ description: '라인코드' })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiProperty({ description: 'true 면 잠금(LOCK), false 면 해제(UNLOCK)' })
  @Transform(({ value }) => value === true || value === 'true')
  @IsBoolean()
  lock!: boolean;
}
