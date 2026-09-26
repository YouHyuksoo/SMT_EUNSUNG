import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { TemperatureCheckQueryDto, TemperatureRawQueryDto } from '../dto/temperature.dto';
import { TemperatureService } from '../services/temperature.service';

@ApiTags('품질관리 - 온도상태')
@UseGuards(JwtAuthGuard)
@Controller('quality/temperature')
export class TemperatureController {
  constructor(private readonly service: TemperatureService) {}

  @Get('nodes')
  @ApiOperation({ summary: '온도 노드 목록 — 최근값과 기준범위 포함' })
  async findNodes(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findNodes(organizationId));
  }

  @Get('raw')
  @ApiOperation({ summary: '온습도 원시데이터 (노드·기간 필수 — 1,700만 행 테이블)' })
  async findRaw(
    @Query() query: TemperatureRawQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findRaw(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('checks')
  @ApiOperation({ summary: '온도 점검이력 조회' })
  async findChecks(
    @Query() query: TemperatureCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findChecks(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
