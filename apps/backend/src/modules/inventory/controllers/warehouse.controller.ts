/**
 * @file controllers/warehouse.controller.ts
 * @description 창고 마스터 REST API 컨트롤러 (ICOM_WAREHOUSE)
 *
 * 초보자 가이드:
 * - GET    /inventory/warehouses      → 목록 (warehouseType 필터)
 * - GET    /inventory/warehouses/:id  → 상세
 * - POST   /inventory/warehouses      → 생성
 * - PUT    /inventory/warehouses/:id  → 수정
 * - DELETE /inventory/warehouses/:id  → 삭제
 *
 * 재고/수불 API는 은성화 대상이 아니므로 InventoryController 대신
 * 창고 라우트만 담은 이 컨트롤러를 WarehouseModule에서 등록한다.
 */
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
} from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { WarehouseService } from '../services/warehouse.service';
import { CreateWarehouseDto, UpdateWarehouseDto } from '../dto/inventory.dto';

@ApiTags('기준정보 - 창고마스터')
@Controller('inventory/warehouses')
export class WarehouseController {
  constructor(private readonly warehouseService: WarehouseService) {}

  @Get()
  @ApiOperation({ summary: '창고 목록 조회' })
  findAll(
    @Query('warehouseType') warehouseType?: string,
    @OrganizationId() organizationId?: number,
  ) {
    return this.warehouseService.findAll(warehouseType, organizationId);
  }

  @Get(':id')
  @ApiOperation({ summary: '창고 상세 조회' })
  findOne(@Param('id') id: string, @OrganizationId() organizationId?: number) {
    return this.warehouseService.findOne(id, organizationId);
  }

  @Post()
  @ApiOperation({ summary: '창고 생성' })
  create(@Body() dto: CreateWarehouseDto, @OrganizationId() organizationId: number) {
    return this.warehouseService.create(dto, organizationId);
  }

  @Put(':id')
  @ApiOperation({ summary: '창고 수정' })
  update(
    @Param('id') id: string,
    @Body() dto: UpdateWarehouseDto,
    @OrganizationId() organizationId?: number,
  ) {
    return this.warehouseService.update(id, dto, organizationId);
  }

  @Delete(':id')
  @ApiOperation({ summary: '창고 삭제' })
  remove(@Param('id') id: string, @OrganizationId() organizationId?: number) {
    return this.warehouseService.remove(id, organizationId);
  }
}
