import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { ProductInventoryQueryDto } from '../dto/product-inventory.dto';
import { ProductInventoryService } from '../services/product-inventory.service';

@ApiTags('제품재고관리 - 제품재고조회')
@UseGuards(JwtAuthGuard)
@Controller('product/current-inventory')
export class ProductInventoryController {
  constructor(private readonly service: ProductInventoryService) {}

  @Get()
  @ApiOperation({ summary: 'PB d_product_fg_inventory_lst 기준 제품재고 조회' })
  async find(@Query() query: ProductInventoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
