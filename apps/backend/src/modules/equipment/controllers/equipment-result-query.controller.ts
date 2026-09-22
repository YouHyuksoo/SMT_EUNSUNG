import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { EquipmentResultQueryDto } from '../dto/equipment-result-query.dto';
import { EquipmentResultQueryService } from '../services/equipment-result-query.service';

@ApiTags('설비관리 - 작업·검사결과 조회')
@UseGuards(JwtAuthGuard)
@Controller('equipment/result-queries')
export class EquipmentResultQueryController {
  constructor(private readonly service: EquipmentResultQueryService) {}

  @Get(':type')
  @ApiOperation({ summary: '설비 작업·검사결과 조회' })
  async findAll(
    @Param('type') type: string,
    @Query() query: EquipmentResultQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findAll(type, organizationId, query);
    return ResponseUtil.paged(result.data, result.total, 1, query.limit ?? 1000);
  }
}
