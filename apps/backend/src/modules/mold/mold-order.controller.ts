import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  MoldOrderCreateDto,
  MoldOrderKeyDto,
  MoldOrderQueryDto,
  MoldOrderUpdateDto,
} from './mold-order.dto';
import { MoldOrderService } from './mold-order.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('S-PARTS관리 - S-PARTS주문')
@UseGuards(JwtAuthGuard)
@Controller('mold/order')
export class MoldOrderController {
  constructor(private readonly service: MoldOrderService) {}

  @Get()
  @ApiOperation({ summary: 'S-PARTS 주문 조회 (PB w_mcn_mold_purchase_order_master)' })
  async find(@Query() query: MoldOrderQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('groups')
  @ApiOperation({ summary: '주문그룹 집계 조회' })
  async findGroups(@Query() query: MoldOrderQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findGroups(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '주문 등록 (주문번호·단가는 PB 규칙으로 서버가 채운다)' })
  async create(
    @Body() dto: MoldOrderCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '주문 수정 (주문금액은 수량 × 단가로 재계산)' })
  async update(
    @Body() dto: MoldOrderUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '주문 삭제 (입고된 주문은 막는다)' })
  async remove(@Body() dto: MoldOrderKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}
