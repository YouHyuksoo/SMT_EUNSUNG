/**
 * @file src/modules/process-transaction/magazine-label.dto.ts
 * @description 229 매거진라벨 발행 · 230 분할 · 231 PID 매핑 입력 규칙.
 *
 * 초보자 가이드:
 * 1. **수량은 여기서 한 번 거른다.** 음수·소수·빈 값이 서비스까지 내려가면
 *    원장에 이상한 행이 생긴다.
 * 2. **기본값은 DTO 가 아니라 서비스에 둔다.** 컨트롤러를 거치지 않는 호출에서
 *    `undefined` 가 그대로 넘어가 안전한 기본값이 꺼지기 때문이다 (238 에서 겪었다).
 *    여기서는 형태만 막는다.
 */
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsDateString,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

// ───────────────────────────────── 229 발행

export class MagazineRunCardLookupDto {
  /** 런카드번호 또는 매거진 라벨번호. 현장은 둘 다 찍는다. */
  @IsString() @IsNotEmpty() scan!: string;
}

export class MagazineIssuedQueryDto {
  @IsString() @IsNotEmpty() runNo!: string;
}

export class MagazineIssueDto {
  @IsString() @IsNotEmpty() runNo!: string;
  @IsString() @IsNotEmpty() modelName!: string;
  /** 이번에 발행할 정상 수량. */
  @Type(() => Number) @IsInt() @Min(1) okQty!: number;
  /** 발행할 라벨 장수. */
  @Type(() => Number) @IsInt() @Min(1) printQty!: number;
  /** 상자 하나에 담는 수량. 비우면 모델기준정보의 값을 쓴다. */
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) packingPcsQty?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) okIncludeQty?: number;
  /**
   * 라벨을 붙일 공정. **런카드에는 없다** — PB 도 PC 설정에서 읽어 썼고,
   * 실측 런카드 `WORKSTAGE_CODE` 는 전부 NULL 이다. 화면이 반드시 보낸다.
   */
  @IsString() @IsNotEmpty() workstageCode!: string;
  @IsOptional() @IsString() magazineSetNo?: string;
}

export class MagazineDestroyDto {
  @IsString() @IsNotEmpty() magazineLabelNo!: string;
}

// ───────────────────────────────── 230 분할

export class MagazineSplitQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
}

export class MagazineLabelLookupDto {
  @IsString() @IsNotEmpty() magazineLabelNo!: string;
}

export class MagazineSplitDto {
  @IsString() @IsNotEmpty() magazineLabelNo!: string;
  /** 새 정상 라벨로 떼어낼 수량. */
  @Type(() => Number) @IsInt() @Min(0) divideQty!: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) ngQty?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) destroyQty?: number;
}

// ───────────────────────────────── 231 PID 매핑

export class MagazinePidQueryDto {
  @IsString() @IsNotEmpty() magazineLabelNo!: string;
}

export class MagazinePidMapDto {
  @IsString() @IsNotEmpty() magazineLabelNo!: string;
  /** 기판 일련번호(PID). 10자 이상이어야 한다 — 길이는 서비스가 막는다. */
  @IsString() @IsNotEmpty() serialNo!: string;
  /** 수리품이면 `BARCODE_STATUS` 를 'R' 로 넣는다 (PB `rb_repair`). */
  @IsOptional() @IsBoolean() repair?: boolean;
}

export class MagazinePidCancelDto {
  @IsString() @IsNotEmpty() magazineLabelNo!: string;
  @IsString() @IsNotEmpty() serialNo!: string;
}
