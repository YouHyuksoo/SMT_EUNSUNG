/**
 * @file src/modules/oee/oee.controller.ts
 * @description OEE 입력 API — 리소스/사유 마스터, 가동일지 로드/저장.
 * 라우트(글로벌 prefix api/v1):
 *   GET/POST/PUT/DELETE /oee/resource, /oee/resource/candidates, /oee/reason
 *   GET /oee/smt-close-run/preview?runNo=&ctDate= (read-only)
 *   GET /oee/log?resourceId=&workDate=&shift= , POST /oee/log
 */
import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import {
  OrganizationId,
  UserId,
} from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { OeeMasterService } from './oee-master.service';
import { OeeLogService } from './oee-log.service';
import { OeeDashboardService } from './oee-dashboard.service';
import {
  ResourceCreateDto,
  ResourceUpdateDto,
  ReasonUpsertDto,
  LogSaveDto,
} from './oee.dto';
import { SmtCloseRunPreviewQueryDto } from './smt-close-run-preview.dto';
import { SmtCloseRunPreviewService } from './smt-close-run-preview.service';

@ApiTags('OEE')
@UseGuards(JwtAuthGuard)
@Controller('oee')
export class OeeController {
  constructor(
    private readonly master: OeeMasterService,
    private readonly log: OeeLogService,
    private readonly dashboard: OeeDashboardService,
    private readonly smtCloseRunPreview: SmtCloseRunPreviewService,
  ) {}

  @Get('resource')
  @ApiOperation({ summary: 'OEE 리소스 목록' })
  async listResources(@OrganizationId() organizationId: number | undefined) {
    return { resources: await this.master.listResources(organizationId) };
  }

  @Get('resource/candidates')
  @ApiOperation({ summary: 'OEE 리소스 등록 라인 후보' })
  async listResourceCandidates(
    @OrganizationId() organizationId: number | undefined,
  ) {
    return {
      candidates: await this.master.listResourceCandidates(organizationId),
    };
  }

  @Get('smt-close-run/preview')
  @ApiOperation({ summary: 'SMT 마감 RUN 원천 검증 미리보기(읽기 전용)' })
  async previewSmtCloseRun(
    @Query() query: SmtCloseRunPreviewQueryDto,
    @OrganizationId() organizationId: number | undefined,
  ) {
    return this.smtCloseRunPreview.preview(query, organizationId);
  }

  @Post('resource')
  @ApiOperation({ summary: 'OEE 리소스 신규' })
  async createResource(
    @Body() dto: ResourceCreateDto,
    @OrganizationId() organizationId: number | undefined,
  ) {
    await this.master.createResource(dto, organizationId);
    return { ok: true };
  }

  @Put('resource/:resourceId')
  @ApiOperation({ summary: 'OEE 리소스 수정' })
  async updateResource(
    @Param('resourceId', ParseIntPipe) resourceId: number,
    @Body() dto: ResourceUpdateDto,
    @OrganizationId() organizationId: number | undefined,
  ) {
    await this.master.updateResource(resourceId, dto, organizationId);
    return { ok: true };
  }

  @Delete('resource/:resourceId')
  @ApiOperation({ summary: 'OEE 리소스 삭제' })
  async deleteResource(
    @Param('resourceId', ParseIntPipe) resourceId: number,
    @OrganizationId() organizationId: number | undefined,
  ) {
    await this.master.deleteResource(resourceId, organizationId);
    return { ok: true };
  }

  @Get('reason')
  @ApiOperation({ summary: 'OEE 비가동사유 목록' })
  async listReasons(@OrganizationId() organizationId: number | undefined) {
    return { reasons: await this.master.listReasons(organizationId) };
  }

  @Post('reason')
  @ApiOperation({ summary: 'OEE 비가동사유 신규' })
  async createReason(
    @Body() dto: ReasonUpsertDto,
    @OrganizationId() organizationId: number | undefined,
  ) {
    await this.master.upsertReason(dto, false, organizationId);
    return { ok: true };
  }

  @Put('reason')
  @ApiOperation({ summary: 'OEE 비가동사유 수정' })
  async updateReason(
    @Body() dto: ReasonUpsertDto,
    @OrganizationId() organizationId: number | undefined,
  ) {
    await this.master.upsertReason(dto, true, organizationId);
    return { ok: true };
  }

  @Get('log')
  @ApiOperation({ summary: 'OEE 근무조 가동일지 로드' })
  async loadLog(
    @Query('resourceId') resourceId: string,
    @Query('workDate') workDate: string,
    @Query('shift') shift: string,
    @OrganizationId() organizationId: number | undefined,
  ) {
    return {
      rows: await this.log.loadShift(
        Number(resourceId),
        workDate,
        shift,
        organizationId,
      ),
    };
  }

  @Post('log')
  @ApiOperation({ summary: 'OEE 근무조 가동일지 저장(원자 replace)' })
  async saveLog(
    @Body() dto: LogSaveDto,
    @OrganizationId() organizationId: number | undefined,
    @UserId() userId: string | undefined,
  ) {
    await this.log.saveShift(dto, organizationId, userId);
    return { ok: true };
  }

  // ── 대시보드(당일=실시간, 과거=스냅샷, 미마감 409) ──────────────────────────

  @Get('dashboard/overview')
  @ApiOperation({ summary: '공정별 OEE 종합 + 원자재준비/고객불량 위젯' })
  async dashboardOverview(
    @Query('date') date: string | undefined,
    @OrganizationId() organizationId: number | undefined,
  ) {
    return this.dashboard.overview(date, organizationId);
  }

  @Get('dashboard/drilldown')
  @ApiOperation({ summary: '공정 내 리소스별 OEE 드릴다운' })
  async dashboardDrilldown(
    @Query('processCode') processCode: string,
    @Query('date') date?: string,
    @OrganizationId() organizationId?: number,
  ) {
    return this.dashboard.drilldown(processCode, date, organizationId);
  }

  @Get('dashboard/loss')
  @ApiOperation({ summary: 'OEE 로스 파레토(비가동 사유별 시간)' })
  async dashboardLoss(
    @Query('date') date: string | undefined,
    @OrganizationId() organizationId: number | undefined,
  ) {
    return this.dashboard.lossPareto(date, organizationId);
  }
}
