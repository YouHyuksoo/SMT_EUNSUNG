import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  JigIssueQueryDto,
  JigPmQueryDto,
  JigRepairQueryDto,
  MaskCheckQueryDto,
  SampleApplyModelQueryDto,
  SampleMasterQueryDto,
  SqueezeCheckQueryDto,
} from './jig-check.dto';
import { JigCheckService } from './jig-check.service';

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
}
