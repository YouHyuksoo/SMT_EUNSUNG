/**
 * @file src/modules/report/purchase-daily.controller.ts
 * @description 구매팀 일보 — /report/purchase-daily (summary, detail)
 */
import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiPropertyOptional, ApiTags } from '@nestjs/swagger';
import { IsOptional, IsString, Length } from 'class-validator';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { DateRangeReportQueryDto } from './material-report.dto';
import { PurchaseDailyService } from './purchase-daily.service';

export class PurchaseDailyDetailQueryDto extends DateRangeReportQueryDto {
  @ApiPropertyOptional({ description: '거래처 묶음 (요약의 거래처명과 정확히 일치)' })
  @IsOptional() @IsString() @Length(0, 100)
  bookGroup?: string;
}

const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('리포트 - 구매팀일보')
@UseGuards(JwtAuthGuard)
@Controller('report/purchase-daily')
export class PurchaseDailyController {
  constructor(private readonly service: PurchaseDailyService) {}

  @Get('summary')
  @ApiOperation({ summary: '구매팀 일보 — 거래처 묶음별 원자재 장부 수불 요약' })
  async summary(@Query() query: DateRangeReportQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findSummary(query, organizationId));
  }

  @Get('detail')
  @ApiOperation({ summary: '구매팀 일보 — 품목별 원자재 장부 수불 상세' })
  async detail(@Query() query: PurchaseDailyDetailQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findDetail(query, organizationId));
  }
}
