// 계획 없는 실적 입력 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/work-result-free
import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { FreeResultCancelDto, FreeResultCreateDto } from './work-result-free.dto';
import { WorkResultFreeService } from './work-result-free.service';

@UseGuards(JwtAuthGuard)
@Controller('oee/work-result-free')
export class WorkResultFreeController {
  constructor(private readonly service: WorkResultFreeService) {}

  /** 모델 목록 */
  @Get('models')
  async models(@Query('keyword') keyword?: string, @OrganizationId() organizationId?: number) {
    return { list: await this.service.models(keyword || undefined, organizationId) };
  }

  /** 타임구간 목록(A~J, 작업시간 관리)과 지금 속한 구간 */
  @Get('time-zones')
  async timeZones(@OrganizationId() organizationId?: number) {
    return await this.service.timeZones(organizationId);
  }

  /** 오늘 업무일에 만들어진 지시(모델별 실적 합계) */
  @Get('runs')
  async runs(
    @Query('lineCode') lineCode: string,
    @Query('workstageCode') workstageCode: string,
    @OrganizationId() organizationId?: number,
  ) {
    return { list: await this.service.todayRuns(lineCode, workstageCode, organizationId) };
  }

  /** 실적 저장 — 지시가 없으면 만들고 실적을 계획으로 둔다 */
  @Post('results')
  async create(@Body() dto: FreeResultCreateDto, @OrganizationId() organizationId?: number, @UserId() userId?: string) {
    return await this.service.createResult(dto, organizationId, userId);
  }

  /** 실적 취소 */
  @Post('results/cancel')
  async cancel(@Body() dto: FreeResultCancelDto, @OrganizationId() organizationId?: number, @UserId() userId?: string) {
    return await this.service.cancelResult(dto, organizationId, userId);
  }
}
