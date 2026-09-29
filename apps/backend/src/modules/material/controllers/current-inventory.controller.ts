import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { CurrentInventoryQueryDto } from '../dto/current-inventory.dto';
import { CurrentInventoryService } from '../services/current-inventory.service';

@ApiTags('자재관리 - 현재고조회')
@UseGuards(JwtAuthGuard)
@Controller('material/current-inventory')
export class CurrentInventoryController {
  constructor(private readonly service: CurrentInventoryService) {}

  @Get()
  @ApiOperation({ summary: 'PB d_mat_current_inventory_detail_lst 기준 현재고 조회' })
  async find(@Query() query: CurrentInventoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
