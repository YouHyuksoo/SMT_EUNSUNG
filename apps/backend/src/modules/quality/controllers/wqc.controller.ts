import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  WqcByPidQueryDto,
  WqcCancelDto,
  WqcHistoryQueryDto,
  WqcScanDto,
} from '../dto/wqc.dto';
import { WqcService } from '../services/wqc.service';

const DEFAULT_USER = 'ADMIN';
/** PB 는 로그인 세션의 언어로 코드 라벨을 읽었다. 웹은 우선 한국어로 고정한다. */
const DEFAULT_LANG = 'ko';

@ApiTags('품질관리 - 공정품질검사이력')
@UseGuards(JwtAuthGuard)
@Controller('quality/wqc')
export class WqcController {
  constructor(private readonly service: WqcService) {}

  @Get()
  @ApiOperation({ summary: '공정품질검사 이력 조회 (PB w_qc_workstage_inspect_data_master_es)' })
  async findHistory(
    @Query() query: WqcHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findHistory(query, organizationId, DEFAULT_LANG);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('by-pid')
  @ApiOperation({ summary: '선택 PID 의 검사내역' })
  async findByPid(
    @Query() query: WqcByPidQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.findByPid(query, organizationId, DEFAULT_LANG),
    );
  }

  @Post('scan')
  @ApiOperation({ summary: 'PID 스캔 검사등록 (PKG_MES_QC.SP_WQC_SCAN)' })
  async scan(
    @Body() dto: WqcScanDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.scan(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('cancel')
  @ApiOperation({ summary: '검사 취소 — 같은 PID·라인·공정의 최신 1건' })
  async cancel(@Body() dto: WqcCancelDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.cancel(dto, organizationId));
  }
}
