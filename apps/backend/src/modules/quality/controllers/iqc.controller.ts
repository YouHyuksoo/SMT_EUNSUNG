import { Body, Controller, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  IqcCancelDto,
  IqcEsdCheckDto,
  IqcHistoryQueryDto,
  IqcJudgeDto,
  IqcTargetQueryDto,
} from '../dto/iqc.dto';
import { IqcService } from '../services/iqc.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('품질관리 - IQC')
@UseGuards(JwtAuthGuard)
@Controller('quality/iqc')
export class IqcController {
  constructor(private readonly service: IqcService) {}

  @Get('targets')
  @ApiOperation({ summary: 'IQC 판정 대상·취소 대상 조회 (PB w_qc_iqc_master)' })
  async findTargets(
    @Query() query: IqcTargetQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findTargets(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('history')
  @ApiOperation({ summary: 'IQC 검사이력 조회' })
  async findHistory(
    @Query() query: IqcHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findHistory(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post('judge')
  @ApiOperation({ summary: 'IQC 판정 — 합격/불합격 (PKG_MES_QC.SP_IQC_JUDGE)' })
  async judge(
    @Body() dto: IqcJudgeDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.judge(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('cancel')
  @ApiOperation({ summary: 'IQC 판정취소 — 검사이력은 남긴다' })
  async cancel(
    @Body() dto: IqcCancelDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.cancel(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('esd-check')
  @ApiOperation({ summary: 'ESD 점검 완료 — 점검주기 카운터 초기화' })
  async esdCheckDone(
    @Body() dto: IqcEsdCheckDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.esdCheckDone(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
