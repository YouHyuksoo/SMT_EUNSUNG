// 설비별 검사실적관리 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/inspect-result
//   불량원인 목록은 설비별 작업 실적관리와 같은 GET /oee/work-result/bad-reasons 를 쓴다.
import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { InspectResultCancelDto, InspectResultCreateDto } from './inspect-result.dto';
import { InspectResultService } from './inspect-result.service';

@UseGuards(JwtAuthGuard)
@Controller('oee/inspect-result')
export class InspectResultController {
  constructor(private readonly service: InspectResultService) {}

  /** 작업지시별 검사실적 이력 */
  @Get('results')
  async results(@Query('runNo') runNo: string, @OrganizationId() organizationId?: number) {
    return { list: await this.service.results(runNo, organizationId) };
  }

  /** 검사실적 등록 */
  @Post('results')
  async create(
    @Body() dto: InspectResultCreateDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.create(dto, organizationId, userId);
  }

  /** 검사실적 취소 — 오늘 업무일 건만 */
  @Post('results/cancel')
  async cancel(
    @Body() dto: InspectResultCancelDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.cancel(dto, organizationId, userId);
  }
}
