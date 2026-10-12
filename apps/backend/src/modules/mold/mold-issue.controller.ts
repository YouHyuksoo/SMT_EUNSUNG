import { Body, Controller, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  MoldIssueCancelDto,
  MoldIssueCreateDto,
  MoldIssueFromRequestDto,
  MoldIssueQueryDto,
  MoldIssueRequestQueryDto,
  MoldIssueTargetQueryDto,
} from './mold-issue.dto';
import { MoldIssueService } from './mold-issue.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('S-PARTS관리 - S-PARTS출고')
@UseGuards(JwtAuthGuard)
@Controller('mold/issue')
export class MoldIssueController {
  constructor(private readonly service: MoldIssueService) {}

  @Get()
  @ApiOperation({ summary: 'S-PARTS 출고 조회 (PB w_mcn_mold_issue_master, 취소건 제외)' })
  async find(@Query() query: MoldIssueQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('targets')
  @ApiOperation({ summary: '출고 대상 재고 목록 (유효 구매단가 포함)' })
  async findTargets(
    @Query() query: MoldIssueTargetQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findTargets(query, organizationId));
  }

  @Get('requests')
  @ApiOperation({ summary: '출고 가능한 미처리 청구 목록' })
  async findRequests(
    @Query() query: MoldIssueRequestQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findRequests(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '재고 직접출고 (항번 SEQ_MAT_ISSUE)' })
  async create(
    @Body() dto: MoldIssueCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('from-request')
  @ApiOperation({ summary: '청구건 출고 (항번 SEQ_MOLD_ISSUE_SEQUENCE, 청구는 완료로)' })
  async createFromRequest(
    @Body() dto: MoldIssueFromRequestDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createFromRequest(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('cancel')
  @ApiOperation({ summary: '출고 취소 — 역분개 (PKG_MES_MAC.SP_MOLD_ISSUE_CANCEL)' })
  async cancel(
    @Body() dto: MoldIssueCancelDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.cancel(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
