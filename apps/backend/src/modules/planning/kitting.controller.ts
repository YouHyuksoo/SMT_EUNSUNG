import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  KittingCancelDto,
  KittingClearDto,
  KittingPidQueryDto,
  KittingRunCardQueryDto,
  KittingScanDto,
} from './kitting.dto';
import { KittingService } from './kitting.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('생산 - 롯트카드 PID 매핑관리')
@UseGuards(JwtAuthGuard)
@Controller('production/run-card-pid')
export class KittingController {
  constructor(private readonly service: KittingService) {}

  @Get('run-cards')
  @ApiOperation({ summary: '롯트카드 목록 (PB d_ip_product_run_card_4_kitting_lst)' })
  async findRunCards(
    @Query() query: KittingRunCardQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findRunCards(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('pids')
  @ApiOperation({
    summary: '매핑된 PID 목록. runNo 필수 — 1.8억 행 풀스캔을 막는다',
  })
  async findPids(
    @Query() query: KittingPidQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findPids(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Post('scan')
  @ApiOperation({ summary: 'PID 스캔 매핑 (PKG_MES_PLN.SP_PLN_KITTING_SCAN)' })
  async scan(
    @Body() dto: KittingScanDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.scan(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('cancel')
  @ApiOperation({ summary: 'PID 매핑 취소 (QC 검사된 PID 는 거부)' })
  async cancel(@Body() dto: KittingCancelDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.cancel(dto, organizationId));
  }

  @Delete()
  @ApiOperation({ summary: '이 롯트카드의 PID 매핑 전체 해제' })
  async clear(@Body() dto: KittingClearDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.clear(dto, organizationId));
  }
}
