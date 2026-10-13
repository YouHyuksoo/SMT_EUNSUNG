// 롯트카드관리 (PB w_product_run_card_duckil) 입력 DTO
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Matches, Max, MaxLength, Min } from 'class-validator';

const YMD = /^\d{4}-\d{2}-\d{2}$/;

/** 계획 선택 — 라인 구분(D=SMD 계획, 그 외=조립 계획)으로 볼 계획 테이블이 정해진다 */
export class LotCardPlanQueryDto {
  @IsString() @MaxLength(10) lineCode!: string;
  @IsOptional() @IsString() modelName?: string;
  @Matches(YMD) dateFrom!: string;
  @Matches(YMD) dateTo!: string;
}

/** 계획으로 롯트카드 생성 — 계획 키만 받고 나머지는 서버가 계획에서 다시 읽는다 */
export class LotCardFromPlanDto {
  @IsIn(['SMD', 'MI']) planType!: 'SMD' | 'MI';
  @Matches(YMD) planDate!: string;
  @Type(() => Number) @IsInt() planSequence!: number;
  @IsString() @MaxLength(30) mfs!: string;
  /** 제조유형 (공통코드 PRODUCT RUN TYPE) — PB 도 필수였다 */
  @IsString() @MaxLength(1) productRunType!: string;
  @IsOptional() @IsString() @MaxLength(20) modelClass?: string;
  @IsOptional() @IsString() @MaxLength(20) pcbWeek?: string;
}

/** 상세 생성 — BOM(설계 BOM 전개) 또는 FEEDER(피더 레이아웃 IB_PRODUCT_PLANDATA) */
export class LotCardDetailDto {
  @IsIn(['BOM', 'FEEDER']) source!: 'BOM' | 'FEEDER';
}

/** PID(2D 바코드) 생성 */
export class LotCardPidDto {
  /** 이미 PID 가 있을 때 지우고 다시 만든다 (공정에 투입된 PID 가 있으면 거부) */
  @IsOptional() regenerate?: boolean;
  /** 시작 일련번호 — 0/미입력이면 같은 날 마지막 번호 다음부터 (KI 고객은 쓰지 않는다) */
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) @Max(9999) startSerial?: number;
}

/** 출력용 — 롯트카드 여러 장 (쉼표 구분) */
export class LotCardRunNosDto {
  @IsString() runNos!: string;
}
