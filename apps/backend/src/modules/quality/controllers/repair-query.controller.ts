/**
 * @file src/modules/quality/controllers/repair-query.controller.ts
 * @description 281 공정수리이력조회 요약 컨트롤러.
 *
 * 이력 목록은 `/quality/repair-history` 가 이미 낸다 — 여기는 그 화면에 없던
 * 일별·위치별 요약만 더한다.
 */
import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../../shared/row-limit';
import { RepairQueryDto } from '../dto/repair-query.dto';
import { RepairQueryService } from '../services/repair-query.service';

const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('품질관리 - 공정수리 요약')
@UseGuards(JwtAuthGuard)
@Controller('quality/repair-query')
export class RepairQueryController {
  constructor(private readonly service: RepairQueryService) {}

  @Get('daily')
  @ApiOperation({ summary: '281 일별 × 불량사유 요약. 불량사유 이름은 DB 함수가 낸다.' })
  async daily(
    @Query() query: RepairQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findDailySummary(query, organizationId));
  }

  @Get('position')
  @ApiOperation({
    summary: '281 위치별 × 불량사유 요약. 같은 자리에서 같은 불량이 반복되는지 본다.',
  })
  async position(
    @Query() query: RepairQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findPositionSummary(query, organizationId));
  }
}
