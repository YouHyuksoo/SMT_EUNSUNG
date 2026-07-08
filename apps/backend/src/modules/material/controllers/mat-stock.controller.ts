/**
 * @file src/modules/material/controllers/mat-stock.controller.ts
 * @description 재고 관리 API 컨트롤러
 */

import { Controller, Get, Post, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam } from '@nestjs/swagger';
import { MatStockService } from '../services/mat-stock.service';
import { StockQueryDto, StockAdjustDto, StockTransferDto } from '../dto/mat-stock.dto';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';

@ApiTags('자재관리 - 재고')
@Controller('material/stocks')
export class MatStockController {
  constructor(private readonly matStockService: MatStockService) {}

  @Get()
  @ApiOperation({ summary: '재고 목록 조회' })
  async findAll(@Query() query: StockQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.matStockService.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('available')
  @ApiOperation({ summary: '출고 가능 재고 조회 (IQC PASS만)' })
  async findAvailable(@Query() query: StockQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.matStockService.findAvailable(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('summary/:itemCode')
  @ApiOperation({ summary: '품목별 재고 요약' })
  @ApiParam({ name: 'itemCode', description: '품목 ID' })
  async getSummary(@Param('itemCode') itemCode: string, @OrganizationId() organizationId: number) {
    const data = await this.matStockService.getStockSummary(itemCode, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('warehouse/:warehouseCode')
  @ApiOperation({ summary: '창고별 재고 조회' })
  async findByWarehouse(@Param('warehouseCode') warehouseCode: string, @Query() query: StockQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.matStockService.findAll({ ...query, warehouseCode }, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post('adjust')
  @ApiOperation({ summary: '재고 조정' })
  async adjust(@Body() dto: StockAdjustDto, @OrganizationId() organizationId: number) {
    const data = await this.matStockService.adjustStock(dto, organizationId);
    return ResponseUtil.success(data, '재고가 조정되었습니다.');
  }

  @Post('transfer')
  @ApiOperation({ summary: '재고 이동' })
  async transfer(@Body() dto: StockTransferDto, @OrganizationId() organizationId: number) {
    const data = await this.matStockService.transferStock(dto, organizationId);
    return ResponseUtil.success(data, '재고가 이동되었습니다.');
  }
}
