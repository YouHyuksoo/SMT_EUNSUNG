import { Body, Controller, Get, HttpCode, HttpStatus, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { CreateSalePriceDto, CustomerQueryDto, SalePriceImpactQueryDto, SalePriceQueryDto, UpdateSalePriceDto } from '../dto/sale-price.dto';
import { SalePriceService } from '../services/sale-price.service';

@ApiTags('기준정보 - 제품판매단가')
@UseGuards(JwtAuthGuard)
@Controller('master')
export class SalePriceController {
  constructor(private readonly service: SalePriceService) {}
  @Get('sale-prices') async findAll(@Query() query: SalePriceQueryDto, @OrganizationId() organizationId: number) { const result = await this.service.findAll(query, organizationId); return ResponseUtil.paged(result.data, result.total, result.page, result.limit); }
  @Get('sale-prices/impact') async impact(@Query() query: SalePriceImpactQueryDto, @OrganizationId() organizationId: number) { return ResponseUtil.success(await this.service.getImpact(query, organizationId)); }
  @Get('customers') async customers(@Query() query: CustomerQueryDto, @OrganizationId() organizationId: number) { return ResponseUtil.success(await this.service.findCustomers(query, organizationId)); }
  @Post('sale-prices') @HttpCode(HttpStatus.CREATED) async create(@Body() dto: CreateSalePriceDto, @OrganizationId() organizationId: number) { return ResponseUtil.success(await this.service.create(dto, organizationId), '제품판매단가가 등록되었습니다.'); }
  @Put('sale-prices') async update(@Body() dto: UpdateSalePriceDto, @OrganizationId() organizationId: number) { return ResponseUtil.success(await this.service.update(dto, organizationId), '제품판매단가가 수정되었습니다.'); }
}
