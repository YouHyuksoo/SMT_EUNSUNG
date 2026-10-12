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
  IsBoolean,
  IsDateString,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
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

// ───────────────────────────────── 477 자재소요량

export class MasterPlanQueryDto {
  /** 소요전개 기준일자. PB 는 이 하나로 기준계획을 묶는다. */
  @IsDateString() requirementPlanDate!: string;
}

export class RequirementPlanQueryDto extends MasterPlanQueryDto {
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  /** 공통코드 `LINE TYPE`. */
  @IsOptional() @IsString() lineType?: string;
}

export class MasterPlanRowDto {
  @IsDateString() requirementPlanDate!: string;
  @IsDateString() planDate!: string;
  @IsString() @IsNotEmpty() itemCode!: string;
  @Type(() => Number) @IsNumber() @Min(0) orderQty!: number;
  /** `'Y'`/`'N'`. 비우면 기존 값을 둔다 (새 행은 `'Y'`). */
  @IsOptional() @IsString() applyYn?: string;
}

export class MasterPlanKeyDto {
  @IsDateString() requirementPlanDate!: string;
  @IsDateString() planDate!: string;
  @IsString() @IsNotEmpty() itemCode!: string;
}

export class MasterPlanDeleteDto {
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(500)
  @ValidateNested({ each: true })
  @Type(() => MasterPlanKeyDto)
  rows!: MasterPlanKeyDto[];
}

export class RequirementRunDto {
  @IsDateString() requirementPlanDate!: string;
}

// ───────────────────────────────── 478 자재발주계획

/** PB 라디오버튼(계획 원천)에 대응한다. */
export const PLAN_SOURCE_VALUES = [
  'manual',
  'productionPlan',
  'productionPlanByTime',
  'salePlan',
  'salePlanByTime',
] as const;

/** PB 체크박스(재고 반영 대상)에 대응한다. */
export const INVENTORY_ARM_VALUES = [
  'inventory',
  'order',
  'arrival',
  'workstageInventory',
  'freeInventory',
] as const;

export class OrderPlanQueryDto {
  @IsOptional() @IsDateString() dateFrom?: string;
  @IsOptional() @IsDateString() dateTo?: string;
  @IsOptional() @IsString() supplierCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() lineType?: string;
  /** 발주할 수량이 남은 계획만 본다. */
  @IsOptional() @Type(() => Boolean) pendingOnly?: boolean;
}

export class OrderPlanGenerateDto {
  /** 어느 계획에서 펼지. PB 는 라디오버튼이었다. */
  @IsIn([...PLAN_SOURCE_VALUES]) source!: string;
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  /** 발주일. 만들어지는 계획의 `PURCHASE_ORDER_DATE` 가 된다. */
  @IsDateString() orderDate!: string;
  @IsOptional() @IsString() itemCode?: string;
  /**
   * 소요량에서 뺄 재고 원천. PB 체크박스 다섯과 1:1 이고, 켜진 것만 합산된다.
   * 비우면 아무것도 빼지 않는다 (소요량이 그대로 발주량이 된다).
   */
  @IsArray() @IsIn([...INVENTORY_ARM_VALUES], { each: true })
  inventorySources!: string[];
  /**
   * PB Apply Auto Order Rule. 켜면 발주규칙 A(자동) 품목만 계획하고 최소주문량·포장단위·
   * 불량율을 반영한다. 끄면 전 품목을 소요량 그대로 계획한다.
   */
  @IsBoolean() applyOrderRule!: boolean;
  /** 품목·거래유형당 한 줄로 합친다 (납기는 가장 이른 날, PB Distinct MFS). */
  @IsBoolean() distinctMfs!: boolean;
  /** 발주량을 소수 4자리로 반올림한다 (PB Round). */
  @IsBoolean() roundQty!: boolean;
  /** 제조 리드타임만큼 납기를 **앞으로 당긴다** (자재가 생산 시작 전에 들어와야 한다). */
  @IsBoolean() applyLeadTime!: boolean;
  /** 당긴 납기가 휴무일이면 일하는 날로 옮긴다 (PB cbx_apply_calendar). */
  @IsBoolean() applyCalendar!: boolean;
}

export class PriceResetDto {
  @IsOptional() @IsString() supplierCode?: string;
}

export class OrderPlanKeyDto {
  @IsString() @IsNotEmpty() itemCode!: string;
  @IsString() @IsNotEmpty() lineType!: string;
}

export class OrderPlanPurchaseDto {
  @IsDateString() orderDate!: string;
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(500)
  @ValidateNested({ each: true })
  @Type(() => OrderPlanKeyDto)
  itemCodes!: OrderPlanKeyDto[];
}
