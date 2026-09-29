import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { MoldInventoryDetailQueryDto, MoldInventoryQueryDto } from './mold-inventory.dto';
import { MoldInventoryService } from './mold-inventory.service';

@ApiTags('S-PARTS관리 - S-PARTS재고')
@UseGuards(JwtAuthGuard)
@Controller('mold/inventory')
export class MoldInventoryController {
  constructor(private readonly service: MoldInventoryService) {}

  @Get()
  @ApiOperation({ summary: 'S-PARTS 재고 조회 (PB w_mcn_mold_inventory_master)' })
  async find(@Query() query: MoldInventoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('issue-history')
  @ApiOperation({ summary: '선택 S-PARTS 의 최근 30일 출고이력 (PB 조건 그대로)' })
  async findIssueHistory(
    @Query() query: MoldInventoryDetailQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findIssueHistory(query, organizationId));
  }

  @Get('requests')
  @ApiOperation({ summary: '선택 S-PARTS 의 미처리 청구목록' })
  async findRequests(
    @Query() query: MoldInventoryDetailQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findRequests(query, organizationId));
  }
}
