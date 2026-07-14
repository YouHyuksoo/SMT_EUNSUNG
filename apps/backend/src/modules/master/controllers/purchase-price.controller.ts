import { Body, Controller, Get, HttpCode, HttpStatus, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import {
  CreatePurchasePriceDto,
  PurchasePriceImpactQueryDto,
  PurchasePriceQueryDto,
  SupplierQueryDto,
  UpdatePurchasePriceDto,
} from '../dto/purchase-price.dto';
import { PurchasePriceService } from '../services/purchase-price.service';

@ApiTags('기준정보 - 구매단가관리')
@UseGuards(JwtAuthGuard)
@Controller('master')
export class PurchasePriceController {
  constructor(private readonly service: PurchasePriceService) {}

  @Get('purchase-prices')
  @ApiOperation({ summary: '구매단가 목록 조회' })
  async findAll(@Query() query: PurchasePriceQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('purchase-prices/impact')
  @ApiOperation({ summary: '구매단가 저장 영향도 조회' })
  async getImpact(@Query() query: PurchasePriceImpactQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.getImpact(query, organizationId));
  }

  @Get('suppliers')
  @ApiOperation({ summary: '공급사 목록 조회' })
  async findSuppliers(@Query() query: SupplierQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findSuppliers(query, organizationId));
  }

  @Post('purchase-prices')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: '구매단가 등록' })
  async create(@Body() dto: CreatePurchasePriceDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId),
      '구매단가가 등록되었습니다.',
    );
  }

  @Put('purchase-prices')
  @ApiOperation({ summary: '구매단가 수정' })
  async update(@Body() dto: UpdatePurchasePriceDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId),
      '구매단가가 수정되었습니다.',
    );
  }
}
