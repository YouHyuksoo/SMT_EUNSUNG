/**
 * @file consumable-label.controller.ts
 * @description 소모품 라벨 발행 컨트롤러 — conUid 채번, PENDING 조회, 입고 확정
 *
 * 초보자 가이드:
 * 1. GET  /consumables/label/masters       라벨 발행 가능 마스터 목록
 * 2. POST /consumables/label/create        conUid 채번 + PENDING 생성
 * 3. GET  /consumables/label/pending       미입고 UID 목록
 * 4. POST /consumables/label/confirm       단건 입고 확정 (바코드 스캔)
 * 5. POST /consumables/label/confirm-bulk  다건 입고 확정
 */
import { Controller, Get, Post, Body } from '@nestjs/common';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { ConsumableLabelService } from '../services/consumable-label.service';
import {
  CreateConLabelsDto,
  ConfirmConReceivingDto,
  BulkConfirmConReceivingDto,
  ReturnConReceivingDto,
  IssueConDto,
  IssueReturnConDto,
} from '../dto/consumable-label.dto';
@Controller('consumables/label')
export class ConsumableLabelController {
  constructor(private readonly labelService: ConsumableLabelService) {}

  /** 라벨 발행 가능 마스터 목록 */
  @Get('masters')
  async getMasters(@OrganizationId() organizationId: number) {
    const data = await this.labelService.findLabelableConsumables(organizationId);
    return ResponseUtil.success(data);
  }

  /** conUid 채번 + PENDING 생성 */
  @Post('create')
  async createLabels(@Body() dto: CreateConLabelsDto, @OrganizationId() organizationId: number) {
    const data = await this.labelService.createConLabels(dto, organizationId);
    return ResponseUtil.success(data);
  }

  /** 미입고 UID 목록 */
  @Get('pending')
  async getPending(@OrganizationId() organizationId: number) {
    const data = await this.labelService.findPendingStocks(organizationId);
    return ResponseUtil.success(data);
  }

  /** 단건 입고 확정 (바코드 스캔) */
  @Post('confirm')
  async confirmReceiving(@Body() dto: ConfirmConReceivingDto, @OrganizationId() organizationId: number) {
    const data = await this.labelService.confirmReceiving(dto, organizationId);
    return ResponseUtil.success(data);
  }

  /** 단건 반납입고 (바코드 스캔) */
  @Post('return')
  async returnReceiving(@Body() dto: ReturnConReceivingDto, @OrganizationId() organizationId: number) {
    const data = await this.labelService.returnByScan(dto, organizationId);
    return ResponseUtil.success(data);
  }

  /** 단건 출고 (바코드 스캔) */
  @Post('issue')
  async issueByScan(@Body() dto: IssueConDto, @OrganizationId() organizationId: number) {
    const data = await this.labelService.issueByScan(dto, organizationId);
    return ResponseUtil.success(data);
  }

  /** 단건 출고취소 (바코드 스캔) */
  @Post('issue-return')
  async issueReturnByScan(@Body() dto: IssueReturnConDto, @OrganizationId() organizationId: number) {
    const data = await this.labelService.issueReturnByScan(dto, organizationId);
    return ResponseUtil.success(data);
  }

  /** 다건 입고 확정 */
  @Post('confirm-bulk')
  async confirmBulk(@Body() dto: BulkConfirmConReceivingDto, @OrganizationId() organizationId: number) {
    const data = await this.labelService.bulkConfirmReceiving(dto, organizationId);
    return ResponseUtil.success(data);
  }
}
