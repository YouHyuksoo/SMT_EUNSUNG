/**
 * @file src/modules/purchase/purchase.controllers.ts
 * @description 자재 구매·발주 컨트롤러.
 *
 *   /purchase/order     481 자재주문관리 (쓰기)
 *   /purchase/forecast  480 자재주문예정관리 (쓰기)
 *   /purchase/arrival   483 자재출발관리 · 484 자재도착관리 (쓰기)
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
  DepartureCreateDto,
  ForecastConfirmDto,
  ForecastOrderQueryDto,
  OrderForArrivalQueryDto,
  PurchaseOrderDeleteDto,
  PurchaseOrderQueryDto,
  PurchaseOrderSaveDto,
} from './purchase.dto';
import { PurchaseOrderService } from './purchase-order.service';

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
