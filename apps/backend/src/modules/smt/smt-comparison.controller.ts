import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { SmtBomExplodeQueryDto, SmtLocationCompareQueryDto } from './smt-comparison.dto';
import { SmtComparisonService } from './smt-comparison.service';

@ApiTags('SMT - 피더레이아웃 비교')
@UseGuards(JwtAuthGuard)
@Controller('smt/comparison')
export class SmtComparisonController {
  constructor(private readonly service: SmtComparisonService) {}

  @Get('locations')
  @ApiOperation({
    summary: '모델별 피더위치 비교 (PB w_smt_bom_comparison_master_rpt). 모델 2~10개',
  })
  async compareLocations(
    @Query() query: SmtLocationCompareQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.compareLocations(query, organizationId);
    return ResponseUtil.success(result);
  }

  @Get('bom-explode')
  @ApiOperation({
    summary: 'BOM 전개 + 피더위치 대조 (PKG_DESIGN.BOM_QUERY. 읽은 세션행은 지운다)',
  })
  async explodeBom(
    @Query() query: SmtBomExplodeQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.explodeBom(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }
}
