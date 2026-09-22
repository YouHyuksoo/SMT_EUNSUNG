import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { RepairHistoryQueryDto } from '../dto/repair-history.dto';
import { RepairHistoryService } from '../services/repair-history.service';

@ApiTags('품질관리 - 공정수리이력조회')
@UseGuards(JwtAuthGuard)
@Controller('quality/repair-history')
export class RepairHistoryController {
  constructor(private readonly service: RepairHistoryService) {}

  @Get()
  @ApiOperation({ summary: 'PB d_pln_product_work_qc_hst 기준 공정수리이력 조회' })
  async find(@Query() query: RepairHistoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
