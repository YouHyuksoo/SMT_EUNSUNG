import { Body, Controller, Get, Post, Query, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { ReceiptCancelExecuteDto, ReceiptCancelQueryDto } from '../dto/receipt-cancel.dto';
import { ReceiptCancelService } from '../services/receipt-cancel.service';

@ApiTags('자재관리 - 자재입고취소')
@UseGuards(JwtAuthGuard)
@Controller('material/receipt-cancel')
export class ReceiptCancelController {
  constructor(private readonly service: ReceiptCancelService) {}

  @Get()
  @ApiOperation({ summary: 'PB d_mat_receipt_cancel_lst / d_mat_receipt_hst 기준 입고 조회' })
  async find(@Query() query: ReceiptCancelQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post()
  @ApiOperation({ summary: 'PB f_mat_receipt_cancel 기준 입고 일괄취소 (상계행 생성)' })
  async cancel(
    @Body() dto: ReceiptCancelExecuteDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    const result = await this.service.cancel(dto, organizationId, userId);
    return ResponseUtil.success(result);
  }
}
