import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { WipLedgerQueryDto } from './wip-ledger.dto';
import { WIP_LEDGER_ROW_LIMIT, WipLedgerService } from './wip-ledger.service';

const paged = <T>(result: { data: T[]; total: number; truncated: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return { ...base, meta: { ...base.meta, truncated: result.truncated, rowLimit: WIP_LEDGER_ROW_LIMIT } };
};

@ApiTags('공정수불관리 - 공정입출고내역')
@UseGuards(JwtAuthGuard)
@Controller('process-transaction/wip-ledger')
export class WipLedgerController {
  constructor(private readonly service: WipLedgerService) {}

  @Get()
  @ApiOperation({ summary: '공정 입출고 건별 내역 (입고·생산투입·실사조정)' })
  async findDetail(@Query() query: WipLedgerQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findDetail(query, organizationId));
  }

  @Get('summary')
  @ApiOperation({ summary: '공정 입출고 품목별 기간 합계와 지금 공정재고' })
  async findSummary(@Query() query: WipLedgerQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findSummary(query, organizationId));
  }
}
