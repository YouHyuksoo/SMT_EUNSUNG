import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { MagazineLabelHistoryQueryDto } from './magazine-label-history.dto';
import { MagazineLabelHistoryService } from './magazine-label-history.service';

@ApiTags('공정수불관리 - 매거진발행이력')
@UseGuards(JwtAuthGuard)
@Controller('process-transaction/magazine-label-history')
export class MagazineLabelHistoryController {
  constructor(private readonly service: MagazineLabelHistoryService) {}

  @Get()
  @ApiOperation({ summary: 'PB W_PLN_PRODUCT_MAGAZINE_LABEL_QUERY 기준 매거진발행이력 조회' })
  async find(@Query() query: MagazineLabelHistoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
