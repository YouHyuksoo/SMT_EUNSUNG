import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmtPlanDeleteDto,
  SmtPlanDeployDto,
  SmtPlanQueryDto,
  SmtPlanSetActiveDto,
} from './smt-plan.dto';
import { SmtPlanService } from './smt-plan.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('SMT - 계획배포관리')
@UseGuards(JwtAuthGuard)
@Controller('smt/plan')
export class SmtPlanController {
  constructor(private readonly service: SmtPlanService) {}

  @Get()
  @ApiOperation({ summary: '배포계획 조회 (PB w_smt_plan_master). 모델명 필수' })
  async find(@Query() query: SmtPlanQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('lines')
  @ApiOperation({
    summary: '라인별 배포 요약 (PB d_ib_line_master_distinct_4_plan_lst. IP_PRODUCT_LINE 이다)',
  })
  async findLineSummary(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findLineSummary(organizationId));
  }

  @Post('deploy')
  @ApiOperation({
    summary: 'BOM → 계획 배포 (PKG_MES_SMT.SP_SMT_PLAN_DEPLOY). 활성계획·기존행이 있으면 거부',
  })
  async deploy(
    @Body() dto: SmtPlanDeployDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.deploy(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('active')
  @ApiOperation({
    summary: '계획 활성/비활성 전환. 한 라인에 두 모델이 동시에 활성일 수 없다',
  })
  async setActive(
    @Body() dto: SmtPlanSetActiveDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.setActive(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({
    summary: '배포 취소 — 비활성 행만 지우고 IB_PRODUCT_PLANDATA_BACKUP 으로 옮긴다',
  })
  async remove(@Body() dto: SmtPlanDeleteDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}
