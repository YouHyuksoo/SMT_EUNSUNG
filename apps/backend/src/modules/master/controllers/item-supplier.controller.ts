import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { CreateItemSupplierDto, ItemSupplierQueryDto, UpdateItemSupplierDto } from '../dto/item-supplier.dto';
import { ItemSupplierService } from '../services/item-supplier.service';

@Controller('master/item-suppliers')
@UseGuards(JwtAuthGuard)
export class ItemSupplierController {
  constructor(private readonly service: ItemSupplierService) {}
  @Get() async findAll(@Query() query: ItemSupplierQueryDto, @OrganizationId() organizationId: number) { const r = await this.service.findAll(query, organizationId); return ResponseUtil.paged(r.data, r.total, r.page, r.limit); }
  @Post() async create(@Body() dto: CreateItemSupplierDto, @OrganizationId() organizationId: number) { return ResponseUtil.success(await this.service.create(dto, organizationId)); }
  @Put() async update(@Body() dto: UpdateItemSupplierDto, @OrganizationId() organizationId: number) { return ResponseUtil.success(await this.service.update(dto, organizationId)); }
  @Delete() async delete(@Query('supplierCode') supplierCode: string, @Query('itemCode') itemCode: string, @Query('dateset') dateset: string, @OrganizationId() organizationId: number) { await this.service.delete(supplierCode, itemCode, dateset, organizationId); return ResponseUtil.success(null); }
}
