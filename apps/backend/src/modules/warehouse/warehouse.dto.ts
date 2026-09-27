/**
 * @file src/modules/warehouse/warehouse.dto.ts
 * @description 자재창고(M_WAREHOUSE) DTO — 1단계: 챔버 재고조회 3화면 + SMT 공릴체크
 *
 * 초보자 가이드:
 * 1. **자재창고는 바코드 스캔 업무다.** 리포트처럼 "기간이 유일한 방어선" 이 아니라
 *    바코드·롯트·전표번호 같은 **키**가 있다. 조건 설계가 리포트와 다르다.
 * 2. **262·263·264 는 같은 화면이다.** 베이킹실·진공포장·제습함 세 화면의
 *    DataWindow SQL 이 **글자까지 동일**하고 `chamber_type` 인자만 'B'/'V'/'D' 로
 *    다르다 (실측). 그래서 서비스는 하나이고 갈래 인자로 가른다.
 * 3. **'재고' 의 정의는 `넣었고 아직 안 꺼낸 것` 이다**
 *    (`INPUT_SCAN_DATE IS NOT NULL AND OUTPUT_SCAN_DATE IS NULL` — PB 고정조건).
 *    이 두 조건을 빠뜨리면 지나간 이력이 전부 재고로 잡힌다.
 *    실측 재고: 베이킹 4건 · 진공포장 0건 · 제습함 55건 (전체 이력 18,352건 중 59건).
 * 4. **266 SMT 공릴체크는 조회 전용이다.** PB 에 `dw_1.update()` + commit 이 있지만
 *    12개 컬럼이 **모두 `tabsequence=32766`(편집 불가)** 이라 바뀔 값이 없다 —
 *    무동작이다 (340 라인설비바코드와 같은 유형).
 */
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, Length, Matches } from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

/**
 * 챔버 종류. PB 가 화면마다 고정으로 넘기던 값이다 (실측 분포):
 *   'B' 베이킹실 233건 · 'V' 진공포장 9,343건 · 'D' 제습함 8,776건
 *
 * `ISYS_BASECODE` 에 'CHAMBER TYPE' 코드표는 **없다** — 화면마다 고정값이라
 * 코드표가 필요 없었다. 그래서 여기서도 문자 상수로 둔다.
 */
export const CHAMBER_TYPES = ['B', 'V', 'D'] as const;
export type ChamberType = (typeof CHAMBER_TYPES)[number];

/** 262·263·264 — 챔버에 들어가 있는 자재 (요약·상세 공통 조건). */
export class ChamberStockQueryDto {
  @ApiProperty({
    description: "챔버 종류. 'B' 베이킹실 · 'V' 진공포장 · 'D' 제습함."
      + ' 화면마다 고정이며 이 값으로 세 화면이 갈린다.',
    enum: CHAMBER_TYPES,
  })
  @IsIn(CHAMBER_TYPES as unknown as string[])
  chamberType!: ChamberType;

  @ApiPropertyOptional({ description: '품목코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 50)
  itemCode?: string;

  @ApiPropertyOptional({ description: '자재 롯트(LOT_NO, 앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 60)
  lotNo?: string;

  @ApiPropertyOptional({ description: '챔버(설비)코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 30)
  chamberCode?: string;
}

/**
 * 262·263·264 상세 — 요약에서 고른 (챔버, 품목) 한 묶음의 자재 목록.
 *
 * PB 는 요약 그리드에서 행을 고르면 상세를 다시 조회한다 (마스터-디테일).
 * 상세의 품목·챔버 조건은 **등호**다 — 요약이 돌려준 값을 그대로 넘긴다.
 */
export class ChamberStockDetailQueryDto {
  @ApiProperty({ description: "챔버 종류 ('B'·'V'·'D')", enum: CHAMBER_TYPES })
  @IsIn(CHAMBER_TYPES as unknown as string[])
  chamberType!: ChamberType;

  @ApiProperty({ description: '품목코드 (요약이 돌려준 값 그대로 — 등호로 걸린다)' })
  @IsString() @Length(1, 50)
  itemCode!: string;

  @ApiProperty({ description: '챔버(설비)코드 (요약이 돌려준 값 그대로 — 등호로 걸린다)' })
  @IsString() @Length(1, 30)
  chamberCode!: string;
}

/**
 * 266 SMT 공릴체크.
 *
 * `IB_RECYCLE_CHECKHIST` 는 577행이고 **CHECK_DATE 인덱스가 없다**
 * (SCAN_PARTNAME 단독 인덱스뿐 — 실측). 표가 작아 전체 스캔이어도 무관하지만,
 * 기간을 필수로 두는 이유는 성능이 아니라 화면의 뜻이다 (언제의 체크인가).
 */
export class RecycleCheckQueryDto {
  @ApiProperty({ description: '체크일 시작 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  dateFrom!: string;

  @ApiProperty({ description: '체크일 종료 (YYYY-MM-DD, 이 날짜 포함)' })
  @IsString() @Matches(DATE_ONLY)
  dateTo!: string;

  @ApiPropertyOptional({ description: '라인코드 (앞부분 일치)' })
  @IsOptional() @IsString() @Length(0, 10)
  lineCode?: string;

  @ApiPropertyOptional({
    description: "체크상태 (앞부분 일치). 실측 분포 'P' 통과 419건 · 'E' 오류 158건.",
  })
  @IsOptional() @IsString() @Length(0, 5)
  checkStatus?: string;

  @ApiPropertyOptional({ description: '스캔 바코드 (앞부분 일치). 이 표의 유일한 인덱스 컬럼이다.' })
  @IsOptional() @IsString() @Length(0, 60)
  scanPartName?: string;
}
