import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  JigIssueCancelDto,
  JigIssueCreateDto,
  JigIssueQueryDto,
  JigPmConfirmDto,
  JigPmQueryDto,
  JigRepairQueryDto,
  JigRepairRequestDto,
  JigRepairStatusDto,
  JigScanLookupDto,
  MaskCheckQueryDto,
  MaskTensionSaveDto,
  SampleApplyModelQueryDto,
  SampleMasterDeleteDto,
  SampleMasterQueryDto,
  SampleMasterUpsertDto,
  SqueezeCheckQueryDto,
  SqueezeScanDto,
} from './jig-check.dto';
import { JigCheckService } from './jig-check.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('지그관리 - 검사·수리·출고·보전·샘플')
@UseGuards(JwtAuthGuard)
@Controller('jig')
export class JigCheckController {
  constructor(private readonly service: JigCheckService) {}

  @Get('squeeze-check')
  @ApiOperation({ summary: '스퀴즈검사 조회 (PB w_mcn_jig_squeeze_check_master)' })
  async squeezeChecks(@Query() query: SqueezeCheckQueryDto, @OrganizationId() organizationId: number) {
    const r = await this.service.findSqueezeChecks(query, organizationId);
    return ResponseUtil.paged(r.data, r.total, r.page, r.limit);
  }

  @Get('mask-check')
  @ApiOperation({ summary: '메탈마스크 텐션·세척검사 조회 (PB w_mcn_jig_mask_tension_check_master)' })
  async maskChecks(@Query() query: MaskCheckQueryDto, @OrganizationId() organizationId: number) {
    const r = await this.service.findMaskChecks(query, organizationId);
    return ResponseUtil.paged(r.data, r.total, r.page, r.limit);
  }

  @Get('repair')
  @ApiOperation({ summary: '지그수리 신청·처리 조회 (PB w_mcn_jig_repair_master)' })
  async repairs(@Query() query: JigRepairQueryDto, @OrganizationId() organizationId: number) {
    const r = await this.service.findRepairs(query, organizationId);
    return ResponseUtil.paged(r.data, r.total, r.page, r.limit);
  }

  @Get('issue')
  @ApiOperation({ summary: '지그출고 조회 (PB w_mcn_jig_issue_master)' })
  async issues(@Query() query: JigIssueQueryDto, @OrganizationId() organizationId: number) {
    const r = await this.service.findIssues(query, organizationId);
    return ResponseUtil.paged(r.data, r.total, r.page, r.limit);
  }

  @Get('pm')
  @ApiOperation({ summary: '지그자주보전 계획·실적 조회 (PB w_mcn_jig_pm_master)' })
  async pmPlans(@Query() query: JigPmQueryDto, @OrganizationId() organizationId: number) {
    const r = await this.service.findPmPlans(query, organizationId);
    return ResponseUtil.paged(r.data, r.total, r.page, r.limit);
  }

  @Get('sample')
  @ApiOperation({ summary: '샘플마스터 조회 (PB w_mcn_sample_master)' })
  async samples(@Query() query: SampleMasterQueryDto, @OrganizationId() organizationId: number) {
    const r = await this.service.findSamples(query, organizationId);
    return ResponseUtil.paged(r.data, r.total, r.page, r.limit);
  }

  @Get('sample/apply-models')
  @ApiOperation({ summary: '샘플별 적용모델' })
  async sampleApplyModels(
    @Query() query: SampleApplyModelQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findSampleApplyModels(query, organizationId));
  }

  @Get('scan-lookup')
  @ApiOperation({ summary: '바코드 스캔 시 지그 기준정보 조회 (한계수명·장력기준·최종세척일)' })
  async scanLookup(@Query() query: JigScanLookupDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.lookupByScan(query, organizationId));
  }

  @Post('squeeze-check/scan')
  @ApiOperation({ summary: '스퀴즈 바코드 스캔 검사등록 (PKG_MES_MAC.SP_SQUEEZE_CHECK_SCAN)' })
  async squeezeScan(
    @Body() dto: SqueezeScanDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.registerSqueezeScan(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('mask-check')
  @ApiOperation({ summary: '메탈마스크 장력검사 등록 (PKG_MES_MAC.SP_MASK_TENSION_CHECK)' })
  async maskTension(
    @Body() dto: MaskTensionSaveDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.registerMaskTension(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('repair')
  @ApiOperation({ summary: '지그 수리신청 접수 (PKG_MES_MAC.SP_REPAIR_REQUEST)' })
  async requestRepair(
    @Body() dto: JigRepairRequestDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.requestRepair(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('repair/status')
  @ApiOperation({ summary: '수리 상태 전이 (PB Repair OK = P / Line Issue = C)' })
  async updateRepairStatus(
    @Body() dto: JigRepairStatusDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.updateRepairStatus(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('sample')
  @ApiOperation({ summary: '샘플마스터 등록 (PB 기본값: 사용중/라인*/공정*/유효 12개월)' })
  async createSample(
    @Body() dto: SampleMasterUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createSample(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('sample')
  @ApiOperation({ summary: '샘플마스터 수정 (LAST_MODIFY_* 만 갱신)' })
  async updateSample(
    @Body() dto: SampleMasterUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.updateSample(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('sample')
  @ApiOperation({ summary: '샘플마스터 삭제 (장착이력이 있으면 차단)' })
  async deleteSample(
    @Body() dto: SampleMasterDeleteDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.deleteSample(dto, organizationId));
  }

  @Post('issue')
  @ApiOperation({ summary: '지그 출고 등록 (PKG_MES_MAC.SP_JIG_ISSUE)' })
  async createIssue(
    @Body() dto: JigIssueCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createIssue(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('issue/cancel')
  @ApiOperation({ summary: '지그 출고 취소 (ISSUE_STATUS = C, 행은 남긴다)' })
  async cancelIssue(
    @Body() dto: JigIssueCancelDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.cancelIssue(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('pm/confirm')
  @ApiOperation({ summary: '자주보전 실시 (이력 적재 + 사용횟수 리셋)' })
  async confirmPm(
    @Body() dto: JigPmConfirmDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.confirmPm(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
