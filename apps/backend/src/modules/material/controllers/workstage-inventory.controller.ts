import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { WorkstageInventoryQueryDto } from '../dto/workstage-inventory.dto';
import { WorkstageInventoryService } from '../services/workstage-inventory.service';

@ApiTags('자재관리 - 공정재고조회')
@UseGuards(JwtAuthGuard)
@Controller('material/workstage-inventory')
export class WorkstageInventoryController {
  constructor(private readonly service: WorkstageInventoryService) {}

  @Get()
  @ApiOperation({ summary: 'PB W_MAT_WORKSTAGE_INVENTORY_QUERY 기준 공정재고 조회' })
  async find(@Query() query: WorkstageInventoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
