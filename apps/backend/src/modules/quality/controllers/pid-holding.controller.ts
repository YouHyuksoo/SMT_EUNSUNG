import { Body, Controller, Get, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  PidHoldingQueryDto,
  PidHoldingUpdateDto,
  PidIssueScanByPidDto,
  PidIssueScanHistoryQueryDto,
} from '../dto/pid-holding.dto';
import { PidHoldingService } from '../services/pid-holding.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('품질관리 - PID 홀딩 / PCB 이슈스캔')
@UseGuards(JwtAuthGuard)
@Controller('quality/pid')
export class PidHoldingController {
  constructor(private readonly service: PidHoldingService) {}

  @Get('holding')
  @ApiOperation({
    summary: 'PID 홀딩 대상 조회 (PB w_pln_product_barcode_holding) — '
      + 'PID·RUN·매거진·BOX 중 최소 하나 필수 (1.8억 행 테이블)',
  })
  async find(@Query() query: PidHoldingQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Put('holding')
  @ApiOperation({ summary: 'PID 홀딩 / 홀딩해제 — 여러 PID 를 한 번에' })
  async updateStatus(
    @Body() dto: PidHoldingUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.updateStatus(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Get('issue-scans')
  @ApiOperation({ summary: 'PCB 이슈발생 스캔 이력 (PB w_pln_product_pid_issue_scan_master)' })
  async findIssueScans(
    @Query() query: PidIssueScanHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findIssueScans(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('issue-scans/by-pid')
  @ApiOperation({ summary: '선택 PID 의 이슈 스캔 내역' })
  async findIssueScansByPid(
    @Query() query: PidIssueScanByPidDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.findIssueScansByPid(query, organizationId),
    );
  }
}
