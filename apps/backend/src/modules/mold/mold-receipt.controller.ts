import { Body, Controller, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  MoldReceiptCancelDto,
  MoldReceiptCreateDto,
  MoldReceiptQueryDto,
  MoldReceiptTargetQueryDto,
} from './mold-receipt.dto';
import { MoldReceiptService } from './mold-receipt.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('S-PARTS관리 - S-PARTS입고')
@UseGuards(JwtAuthGuard)
@Controller('mold/receipt')
export class MoldReceiptController {
  constructor(private readonly service: MoldReceiptService) {}

  @Get()
  @ApiOperation({ summary: 'S-PARTS 입고 조회 (PB w_mcn_mold_receipt_master)' })
  async find(@Query() query: MoldReceiptQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('targets')
  @ApiOperation({ summary: '입고 대상 S-PARTS 목록 (승인단가 포함)' })
  async findTargets(
    @Query() query: MoldReceiptTargetQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findTargets(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '입고 등록 (항번은 SEQ_MAT_RECEIPT, 단가는 승인단가)' })
  async create(
    @Body() dto: MoldReceiptCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('cancel')
  @ApiOperation({ summary: '입고 취소 — 역분개 (PKG_MES_MAC.SP_MOLD_RECEIPT_CANCEL)' })
  async cancel(
    @Body() dto: MoldReceiptCancelDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.cancel(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
