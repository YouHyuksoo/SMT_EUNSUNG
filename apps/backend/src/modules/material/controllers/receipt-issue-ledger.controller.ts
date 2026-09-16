/**
 * @file src/modules/material/controllers/receipt-issue-ledger.controller.ts
 * @description 자재입출고수불원장 조회 API (읽기 전용)
 *
 * 레거시 PowerBuilder `w_mat_ledger_report`의 라디오 5모드를 엔드포인트 5개로 옮겼다.
 */

import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import {
  FeederLayoutQueryDto,
  IssueLossQueryDto,
  ReceiptBarcodeQueryDto,
  ReceiptIssueLedgerQueryDto,
  WorkstageLedgerQueryDto,
} from '../dto/receipt-issue-ledger.dto';
import { ReceiptIssueLedgerService } from '../services/receipt-issue-ledger.service';

@ApiTags('자재관리 - 자재입출고수불원장')
@UseGuards(JwtAuthGuard)
@Controller('material/receipt-issue-ledger')
export class ReceiptIssueLedgerController {
  constructor(private readonly service: ReceiptIssueLedgerService) {}

  @Get()
  @ApiOperation({ summary: '수불원장 조회 (자재 입고/출고)' })
  async findLedger(@Query() query: ReceiptIssueLedgerQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findLedger(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('workstage')
  @ApiOperation({ summary: '공정 수불원장 조회' })
  async findWorkstageLedger(@Query() query: WorkstageLedgerQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findWorkstageLedger(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('barcodes')
  @ApiOperation({ summary: '입고 바코드 조회' })
  async findReceiptBarcodes(@Query() query: ReceiptBarcodeQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findReceiptBarcodes(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('feeder-layout')
  @ApiOperation({ summary: '라인 피더 레이아웃 재고 조회 (레거시와 동일하게 조직 필터 없음)' })
  async findFeederLayout(@Query() query: FeederLayoutQueryDto) {
    const result = await this.service.findFeederLayout(query);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('issue-loss')
  @ApiOperation({ summary: '출고 로스 조회 (종료일 당일 제외 — 레거시 동작)' })
  async findIssueLoss(@Query() query: IssueLossQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findIssueLoss(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
