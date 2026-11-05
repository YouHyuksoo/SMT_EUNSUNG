// 계획 없는 검사실적 입력 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/inspect-result-free
//   모델 목록은 생산 화면과 같은 GET /oee/work-result-free/models 를 쓴다.
import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { FreeInspectCancelDto, FreeInspectCreateDto } from './inspect-result-free.dto';
import { InspectResultFreeService } from './inspect-result-free.service';

@UseGuards(JwtAuthGuard)
@Controller('oee/inspect-result-free')
export class InspectResultFreeController {
  constructor(private readonly service: InspectResultFreeService) {}

  /** 오늘 업무일에 만들어진 지시(모델별 검사수량 합계) */
  @Get('runs')
  async runs(
    @Query('lineCode') lineCode: string,
    @Query('workstageCode') workstageCode: string,
    @OrganizationId() organizationId?: number,
  ) {
    return { list: await this.service.todayRuns(lineCode, workstageCode, organizationId) };
  }

  /** 검사실적 저장 — 지시가 없으면 만들고 검사수량을 계획으로 둔다 */
  @Post('results')
  async create(@Body() dto: FreeInspectCreateDto, @OrganizationId() organizationId?: number, @UserId() userId?: string) {
    return await this.service.createResult(dto, organizationId, userId);
  }

  /** 검사실적 취소 */
  @Post('results/cancel')
  async cancel(@Body() dto: FreeInspectCancelDto, @OrganizationId() organizationId?: number, @UserId() userId?: string) {
    return await this.service.cancelResult(dto, organizationId, userId);
  }
}
