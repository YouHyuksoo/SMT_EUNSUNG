import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  JigInputHistoryQueryDto,
  SampleBcrHistoryQueryDto,
  SampleInputHistoryQueryDto,
} from './jig-history.dto';
import { JigHistoryService } from './jig-history.service';

@ApiTags('지그관리 - 이력조회')
@UseGuards(JwtAuthGuard)
@Controller('jig')
export class JigHistoryController {
  constructor(private readonly service: JigHistoryService) {}

  @Get('input-history')
  @ApiOperation({ summary: '지그 투입이력 조회 (PB w_mcn_jig_input_history_master)' })
  async jigInputHistory(
    @Query() query: JigInputHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findJigInputHistory(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('sample-input-history')
  @ApiOperation({ summary: '샘플마스터 장착이력 조회 (PB w_mcn_sample_input_history_master)' })
  async sampleInputHistory(
    @Query() query: SampleInputHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findSampleInputHistory(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('sample-bcr-history')
  @ApiOperation({ summary: '샘플마스터 투입이력 조회 (PB w_mcn_sample_bcr_input_history_master)' })
  async sampleBcrHistory(
    @Query() query: SampleBcrHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findSampleBcrHistory(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
