/**
 * @file src/modules/purchase/purchase.dto.ts
 * @description 480·481·483·484 자재 구매·발주 입력 규칙.
 *
 * 코드값은 전부 공통코드 실측이다:
 *   `CONFIRM YN`    N 아니오 · W 대기 · Y 예
 *   `ARRIVAL TYPE`  D 출발 · A 도착 · R 입고
 *   `ARRIVAL STATUS` N 정상 · C 취소
 */
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  IsArray,
  IsDateString,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

// ───────────────────────────────── 481 주문 · 480 주문예정

export class PurchaseOrderQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() orderGroupNo?: string;
  @IsOptional() @IsString() orderType?: string;
}

export class ForecastOrderQueryDto extends PurchaseOrderQueryDto {
  /** `'N'`·`'W'`·`'Y'`. 비우면 전체. */
  @IsOptional() @IsString() confirmYn?: string;
}

export class PurchaseOrderSaveDto {
  /** 있으면 수정, 없으면 새 주문 (번호는 시퀀스가 준다). */
  @IsOptional() @IsString() orderNo?: string;
  @IsString() @IsNotEmpty() orderGroupNo!: string;
  @IsString() @IsNotEmpty() supplierCode!: string;
  @IsString() @IsNotEmpty() itemCode!: string;
  @IsDateString() purchaseOrderDate!: string;
  @IsDateString() deliveryDate!: string;
  /** `DELIVERY` 는 NOT NULL 이다 (납품처·납기구분). */
  @IsString() @IsNotEmpty() delivery!: string;
  /** `LINE_TYPE` 도 NOT NULL. 공통코드 `LINE TYPE`. */
  @IsString() @IsNotEmpty() lineType!: string;
  @Type(() => Number) @IsInt() @Min(1) orderQty!: number;
  @IsOptional() @Type(() => Number) @IsNumber() unitPrice?: number;
  /** 비우면 수량 × 단가로 채운다 (PB 는 화면에서 계산해 넣었다). */
  @IsOptional() @Type(() => Number) @IsNumber() orderAmt?: number;
  @IsOptional() @IsString() orderType?: string;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsString() deliveryMethod?: string;
  @IsOptional() @IsString() deliveryPlace?: string;
  @IsOptional() @IsString() originNationCode?: string;
  @IsOptional() @IsString() incidentalExpenseCode?: string;
  @IsOptional() @IsString() shipmentComment?: string;
  @IsOptional() @IsString() attnName?: string;
  @IsOptional() @IsString() ccName?: string;
}

export class PurchaseOrderDeleteDto {
  @IsString() @IsNotEmpty() orderNo!: string;
}

export class ForecastConfirmDto {
  /** 한 번에 여러 줄을 처리한다 (PB 는 체크한 줄을 모두 바꿨다). */
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(500)
  @IsString({ each: true })
  orderNos!: string[];
  /** `'Y'` 면 주문표에 행을 만들면서 확정한다. */
  @IsIn(['N', 'W', 'Y']) confirmYn!: 'N' | 'W' | 'Y';
}

// ───────────────────────────────── 483 출발 · 484 도착

export class ArrivalQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  /** `'D'` 출발 · `'A'` 도착 · `'R'` 입고. 비우면 전체. */
  @IsOptional() @IsString() arrivalType?: string;
  /** `'N'` 정상 · `'C'` 취소. 비우면 전체. */
  @IsOptional() @IsString() arrivalStatus?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() orderNo?: string;
}

export class OrderForArrivalQueryDto {
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() orderNo?: string;
  @IsOptional() @IsString() itemCode?: string;
}

export class DepartureCreateDto {
  @IsString() @IsNotEmpty() orderNo!: string;
  @IsDateString() departureDate!: string;
  /** 주문 잔량을 넘을 수 없다 — 서비스가 INSERT 문 안에서 다시 막는다. */
  @Type(() => Number) @IsInt() @Min(1) arrivalQty!: number;
}

export class ArrivalConfirmDto {
  @Type(() => Number) @IsInt() @Min(1) arrivalSeqNo!: number;
  /** 도착 확인에만 쓴다. 취소에는 필요 없다. */
  @IsOptional() @IsDateString() arrivalDate?: string;
}
