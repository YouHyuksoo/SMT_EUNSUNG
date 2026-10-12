/**
 * @file src/modules/purchase/purchase.controllers.ts
 * @description 자재 구매·발주 컨트롤러.
 *
 *   /purchase/order     481 자재주문관리 (쓰기)
 *   /purchase/forecast  480 자재주문예정관리 (쓰기)
 *   /purchase/arrival   483 자재출발관리 · 484 자재도착관리 (쓰기)
 *   /purchase/requirement 477 자재소요량관리 (쓰기)
 *   /purchase/order-plan  478 자재발주계획 (쓰기)
 */
import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { ArrivalService } from './arrival.service';
import {
  ArrivalConfirmDto,
  ArrivalQueryDto,
  MasterPlanDeleteDto,
  OrderPlanGenerateDto,
  OrderPlanPurchaseDto,
  OrderPlanQueryDto,
  PriceResetDto,
  MasterPlanQueryDto,
  MasterPlanRowDto,
  RequirementPlanQueryDto,
  RequirementRunDto,
  DepartureCreateDto,
  ForecastConfirmDto,
  ForecastOrderQueryDto,
  OrderForArrivalQueryDto,
  PurchaseOrderDeleteDto,
  PurchaseOrderQueryDto,
  PurchaseOrderSaveDto,
} from './purchase.dto';
import { PurchaseOrderService } from './purchase-order.service';
import { OrderPlanService } from './order-plan.service';
import { RequirementPlanService } from './requirement-plan.service';

const DEFAULT_USER = 'SYSTEM';

const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('자재구매 - 주문관리')
@UseGuards(JwtAuthGuard)
@Controller('purchase/order')
export class PurchaseOrderController {
  constructor(private readonly service: PurchaseOrderService) {}

  @Get()
  @ApiOperation({
    summary: '481 주문 목록. PB 의 옛 조인 문법과 달리 LEFT JOIN 이라 품목·협력사'
      + ' 기준정보가 없어도 주문이 사라지지 않는다.',
  })
  async find(
    @Query() query: PurchaseOrderQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findOrders(query, organizationId));
  }

  @Get('groups')
  @ApiOperation({ summary: '481 발주그룹별 합계.' })
  async groups(
    @Query() query: PurchaseOrderQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findOrderGroups(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '481 주문 등록·수정 (**쓰기**). orderNo 가 있으면 수정이다.'
      + ' 도착분이 잡힌 주문은 고치지 않는다.',
  })
  async save(
    @Body() dto: PurchaseOrderSaveDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.saveOrder(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({
    summary: '481 주문 삭제 (**쓰기**). 도착분이 잡혔거나 출발·도착 기록이 붙었으면'
      + ' 지우지 않는다.',
  })
  async remove(
    @Body() dto: PurchaseOrderDeleteDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.deleteOrder(dto, organizationId));
  }
}

@ApiTags('자재구매 - 주문예정관리')
@UseGuards(JwtAuthGuard)
@Controller('purchase/forecast')
export class ForecastOrderController {
  constructor(private readonly service: PurchaseOrderService) {}

  @Get()
  @ApiOperation({ summary: '480 주문예정 목록. 승인단계(N/W/Y)로 거를 수 있다.' })
  async find(
    @Query() query: ForecastOrderQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findForecasts(query, organizationId));
  }

  @Post('confirm')
  @ApiOperation({
    summary: '480 승인단계 변경 (**쓰기**). W 요청 · N 취소 · **Y 확정**.'
      + ' Y 면 INSERT … SELECT 로 주문표에 행을 만들면서 예정에 확정 표시를 남긴다'
      + ' (예정 기록은 지우지 않는다 — 어디서 넘어온 주문인지 되짚어야 한다).',
  })
  async confirm(
    @Body() dto: ForecastConfirmDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.setForecastConfirm(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재구매 - 출발·도착관리')
@UseGuards(JwtAuthGuard)
@Controller('purchase/arrival')
export class ArrivalController {
  constructor(private readonly service: ArrivalService) {}

  @Get()
  @ApiOperation({
    summary: '483·484 출발·도착 목록. 같은 표를 ARRIVAL_TYPE 으로 가른다'
      + ' (D 출발 · A 도착 · R 입고).',
  })
  async find(
    @Query() query: ArrivalQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findArrivals(query, organizationId));
  }

  @Get('orders')
  @ApiOperation({
    summary: '483 출발로 잡을 수 있는 주문. 주문수량에서 이미 잡힌 출발·도착을 뺀'
      + ' 잔량이 0보다 큰 것만 낸다 (취소분은 빼고 센다).',
  })
  async orders(
    @Query() query: OrderForArrivalQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findOrdersForDeparture(query, organizationId));
  }

  @Post('departure')
  @ApiOperation({
    summary: '483 출발 등록 (**쓰기**). 주문 잔량을 INSERT 문 안에서 다시 세어'
      + ' 동시에 잡아도 넘지 않게 막는다 (PB 는 막지 않았다).',
  })
  async departure(
    @Body() dto: DepartureCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createDeparture(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('confirm')
  @ApiOperation({
    summary: '484 도착 확인 (**쓰기**). 출발 행의 ARRIVAL_TYPE 을 D → A 로 바꾼다.'
      + ' **새 행을 만들지 않는다** — 늘리면 도착수량이 두 배가 된다.'
      + ' 주문의 도착 누계도 같은 트랜잭션에서 다시 계산한다.',
  })
  async confirm(
    @Body() dto: ArrivalConfirmDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.confirmArrival(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('cancel')
  @ApiOperation({
    summary: '483·484 취소 (**쓰기**). 지우지 않고 ARRIVAL_STATUS 를 C 로 바꾼다 —'
      + ' 협력사와 맞춰볼 근거가 남아야 한다. 입고로 넘어간 건은 손대지 않는다.',
  })
  async cancel(
    @Body() dto: ArrivalConfirmDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.cancelArrival(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재구매 - 소요량관리')
@UseGuards(JwtAuthGuard)
@Controller('purchase/requirement')
export class RequirementPlanController {
  constructor(private readonly service: RequirementPlanService) {}

  @Get('master-plan')
  @ApiOperation({ summary: '477 기준계획 목록 (dw_1).' })
  async masterPlan(
    @Query() query: MasterPlanQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMasterPlan(query, organizationId));
  }

  @Get('explode-failures')
  @ApiOperation({ summary: '477 전개 실패내역 — 기준계획 중 BOM 이 없어 전개에서 빠지는 행.' })
  async explodeFailures(
    @Query() query: MasterPlanQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findExplodeFailures(query, organizationId));
  }

  @Post('master-plan')
  @ApiOperation({ summary: '477 기준계획 등록·수정 (**쓰기**).' })
  async saveMasterPlan(
    @Body() dto: MasterPlanRowDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.saveMasterPlan(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('master-plan')
  @ApiOperation({ summary: '477 기준계획 삭제 (**쓰기**). PB 는 체크한 줄을 한 번에 지웠다.' })
  async deleteMasterPlan(
    @Body() dto: MasterPlanDeleteDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.deleteMasterPlan(dto, organizationId));
  }

  @Post('explode')
  @ApiOperation({
    summary: '477 소요량 전개 (**쓰기**). 기준계획을 BOM 으로 펴서 소요량표를 만든다.'
      + ' 전개는 `PKG_DESIGN.BOM_EXPLOSION` 이 하고, 공급처는'
      + ' `F_GET_MAX_SUPPLIER_BY_ITEM` 이 정한다 — 둘 다 PB 와 같은 DB 오브젝트다.',
  })
  async explode(
    @Body() dto: RequirementRunDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.explode(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('inventory')
  @ApiOperation({
    summary: '477 재고 반영 (**쓰기**). 계획일 순서로 앞에서부터 재고를 배정한다.'
      + ' PB 에서 실재고를 읽는 UPDATE 가 주석 처리돼 있어 재고 풀은 0 이고'
      + ' 안전재고만 채워진다 — PB 동작 그대로다.',
  })
  async applyInventory(
    @Body() dto: RequirementRunDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.applyInventory(dto, organizationId));
  }

  @Get()
  @ApiOperation({ summary: '477 소요량 목록 (dw_2).' })
  async requirement(
    @Query() query: RequirementPlanQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findRequirementPlan(query, organizationId));
  }

  @Get('matrix')
  @ApiOperation({
    summary: '477 소요량 매트릭스 (dw_3). 계획일을 가로로 편다 —'
      + ' 열 목록은 `planDates` 로 함께 내보낸다.',
  })
  async matrix(
    @Query() query: RequirementPlanQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findRequirementMatrix(query, organizationId);
    const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
    return {
      ...base,
      meta: {
        ...base.meta,
        planDates: result.planDates,
        truncated: result.truncated,
        rowLimit: ROW_LIMIT,
      },
    };
  }
}

@ApiTags('자재구매 - 발주계획')
@UseGuards(JwtAuthGuard)
@Controller('purchase/order-plan')
export class OrderPlanController {
  constructor(private readonly service: OrderPlanService) {}

  @Get()
  @ApiOperation({ summary: '478 발주계획 목록 (dw_1).' })
  async find(
    @Query() query: OrderPlanQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findOrderPlans(query, organizationId));
  }

  @Get('requirements')
  @ApiOperation({ summary: '478 발주계획을 만들기 전 단계인 소요량.' })
  async requirements(@OrganizationId() organizationId: number) {
    return paged(await this.service.findRequirementOrders(organizationId));
  }

  @Post('preview')
  @ApiOperation({
    summary: '478 발주량 미리보기 (읽기). 생성과 같은 계산을 하고 저장하지 않는다.'
      + ' 줄마다 소요량·재고 가지별 수량·차감·불량가산·올림·발주량·단가·상태를 준다.',
  })
  async preview(
    @Body() dto: OrderPlanGenerateDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.preview(dto, organizationId));
  }

  @Post('generate')
  @ApiOperation({
    summary: '478 발주계획 생성 (**쓰기**). 미리보기와 같은 계산 결과로 소요량표와'
      + ' 발주계획을 조직 단위로 갈아끼운다 — PB 와 같다. 작업 테이블은 쓰지 않는다.',
  })
  async generate(
    @Body() dto: OrderPlanGenerateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.generate(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('price-reset')
  @ApiOperation({
    summary: '478 단가 재설정 (**쓰기**). 단가 기준정보에서 납품구분·단가·통화를'
      + ' 다시 붙인다 (유효기간 안의 단가만).',
  })
  async resetPrice(
    @Body() dto: PriceResetDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.resetPrice(dto, organizationId));
  }

  @Post('purchase')
  @ApiOperation({
    summary: '478 발주 확정 (**쓰기**). 고른 계획을 실제 주문으로 넘기고, 넘어간'
      + ' 계획은 지운다 — PB 도 그렇게 한다 (두 번 발주되지 않게).',
  })
  async purchase(
    @Body() dto: OrderPlanPurchaseDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.purchase(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
