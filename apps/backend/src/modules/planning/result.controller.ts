import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  DailyReportQueryDto,
  ResultByRunQueryDto,
  ResultQueryDto,
  ResultSerialQueryDto,
} from './result.dto';
import { ResultService } from './result.service';

@ApiTags('생산 - 생산실적 조회·일보')
@UseGuards(JwtAuthGuard)
@Controller('production')
export class ResultController {
  constructor(private readonly service: ResultService) {}

  @Get('pcb-result')
  @ApiOperation({ summary: '기간별 생산실적 집계 (PB w_pln_product_pcb_result_query)' })
  async findByPeriod(
    @Query() query: ResultQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findByPeriod(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('pcb-result/by-run')
  @ApiOperation({ summary: '작업지시별 공정 실적 집계' })
  async findByRun(
    @Query() query: ResultByRunQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findByRun(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('pcb-result/serials')
  @ApiOperation({ summary: '그 공정을 지난 PID 목록 (상한 5,000건, 잘리면 알려준다)' })
  async findSerials(
    @Query() query: ResultSerialQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findSerials(query, organizationId));
  }

  @Get('daily-report')
  @ApiOperation({
    summary: '생산일보 — OEE (시간가동률 × 성능가동률 × 양품률)',
  })
  async findDailyReport(
    @Query() query: DailyReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findDailyReport(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }
}
