/**
 * @file src/modules/product/controllers/shipping-order.controller.ts
 * @description 제품납품계획(출하지시, IP_PRODUCT_DELIVERY_PLAN) API
 */
import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ShippingOrderQueryDto, ShippingOrderUpsertDto } from '../dto/shipping-order.dto';
import { ShippingOrderService } from '../services/shipping-order.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('제품납품계획')
@UseGuards(JwtAuthGuard)
@Controller('product/shipping-orders')
export class ShippingOrderController {
  constructor(private readonly service: ShippingOrderService) {}

  @Get()
  @ApiOperation({ summary: '제품납품계획(출하지시) 목록 — 납기일·고객·모델, openOnly=Y 면 완료 제외' })
  async list(@Query() query: ShippingOrderQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.list(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '제품납품계획 등록 (**쓰기**). 번호 DLV+YYMMDD+순번' })
  async create(
    @Body() dto: ShippingOrderUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(await this.service.create(dto, organizationId, userId ?? DEFAULT_USER));
  }

  @Put(':shipOrderNo')
  @ApiOperation({ summary: '제품납품계획 수정 (**쓰기**). 출고 수량보다 작게 줄일 수 없다' })
  async update(
    @Param('shipOrderNo') shipOrderNo: string,
    @Body() dto: ShippingOrderUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(await this.service.update(shipOrderNo, dto, organizationId, userId ?? DEFAULT_USER));
  }

  @Delete(':shipOrderNo')
  @ApiOperation({ summary: '제품납품계획 삭제 (**쓰기**). 출고된 박스가 있으면 거부' })
  async remove(@Param('shipOrderNo') shipOrderNo: string, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(shipOrderNo, organizationId));
  }
}
