import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  InventoryHoldApplyDto,
  InventoryHoldListQueryDto,
  InventoryHoldReleaseDto,
  InventoryHoldTargetQueryDto,
  OqcHistoryCreateDto,
  OqcHistoryKeyDto,
  OqcHistoryQueryDto,
  OqcLotQueryDto,
} from '../dto/inventory-hold.dto';
import { InventoryHoldService } from '../services/inventory-hold.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('품질관리 - 재고통제 / OQC')
@UseGuards(JwtAuthGuard)
@Controller('quality')
export class InventoryHoldController {
  constructor(private readonly service: InventoryHoldService) {}

  @Get('inventory-hold/targets')
  @ApiOperation({
    summary: '재고통제 대상 조회 (PB w_qc_inventory_hold_master) — '
      + '품목코드 또는 자재LOT 필수 (180만 행 테이블)',
  })
  async findTargets(
    @Query() query: InventoryHoldTargetQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findTargets(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('inventory-hold')
  @ApiOperation({ summary: '통제된 LOT 목록' })
  async findHolds(
    @Query() query: InventoryHoldListQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findHolds(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post('inventory-hold')
  @ApiOperation({ summary: '재고통제 등록 (이미 통제된 LOT 은 상태만 갱신)' })
  async applyHold(
    @Body() dto: InventoryHoldApplyDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.applyHold(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('inventory-hold')
  @ApiOperation({ summary: '재고통제 해제 — 통제 행을 지운다' })
  async releaseHold(
    @Body() dto: InventoryHoldReleaseDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.releaseHold(dto, organizationId));
  }

  @Get('oqc')
  @ApiOperation({ summary: 'OQC 검사이력 조회 (PID) — PB w_qc_oqc_inspect_history_master' })
  async findOqcHistory(
    @Query() query: OqcHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findOqcHistory(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('oqc/lots')
  @ApiOperation({
    summary: 'OQC 검사대상 조회 (LOT) — PB w_qc_oqc_inspect_history_4_lot_master. '
      + '매거진 포장·미분할 건만',
  })
  async findOqcLots(
    @Query() query: OqcLotQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findOqcLots(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post('oqc')
  @ApiOperation({ summary: 'OQC 검사이력 등록 (항번은 SEQ_QC_OQC_INSPECT_NO)' })
  async createOqc(
    @Body() dto: OqcHistoryCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createOqc(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('oqc')
  @ApiOperation({ summary: 'OQC 검사이력 삭제' })
  async removeOqc(@Body() dto: OqcHistoryKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.removeOqc(dto, organizationId));
  }
}
