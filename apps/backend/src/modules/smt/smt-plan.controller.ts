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
  SmtPlanSummaryQueryDto,
  SmtPlanScopeDto,
  SmtPlanRunCardQueryDto,
  SmtPlanLineOnOffDto,
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

  @Get('summary')
  @ApiOperation({
    summary: '라인·모델·PCB면별 배포 요약 (PB d_smt_plandata_lst, 화면 오른쪽 위 Summary). 라인이나 모델 필수',
  })
  async findSummary(@Query() query: SmtPlanSummaryQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findSummary(query, organizationId));
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

  @Get('layout-print')
  @ApiOperation({ summary: '피더 레이아웃 출력 데이터 (PB d_smt_plandata_list_rpt, 읽기 전용)' })
  async layoutPrint(@Query() query: SmtPlanScopeDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findLayoutPrint(query, organizationId));
  }

  @Get('run-cards')
  @ApiOperation({ summary: '라인 ON/OFF 할 런카드 후보 (그 라인·모델의 최근 60일)' })
  async runCards(@Query() query: SmtPlanRunCardQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findRunCards(query, organizationId));
  }

  @Post('line-onoff')
  @ApiOperation({
    summary: '라인 ON/OFF (**쓰기**) — 현장 PDA 와 같은 P_CHECK_PDA_TB_INOUT_PS_USER 를 런카드로 부른다',
  })
  async lineOnOff(@Body() dto: SmtPlanLineOnOffDto, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.lineOnOff(dto, userId || DEFAULT_USER));
  }

  @Put('restore')
  @ApiOperation({
    summary: 'Restore (**쓰기**) — 활성·CCS 미완료 행을 체크 완료로, 피더 자재 바코드를 체크이력에서 다시 채운다',
  })
  async restore(
    @Body() dto: SmtPlanScopeDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(await this.service.restore(dto, organizationId, userId || DEFAULT_USER));
  }

  @Delete()
  @ApiOperation({
    summary: '배포 취소 — 비활성 행만 지우고 IB_PRODUCT_PLANDATA_BACKUP 으로 옮긴다',
  })
  async remove(@Body() dto: SmtPlanDeleteDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}
