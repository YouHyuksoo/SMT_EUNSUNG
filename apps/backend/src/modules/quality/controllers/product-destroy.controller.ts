import { Body, Controller, Get, Post, Query, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import {
  ProductDestroyExecuteDto,
  ProductDestroyHistoryQueryDto,
  ProductDestroyIssueDto,
  ProductDestroySerialQueryDto,
} from '../dto/product-destroy.dto';
import { ProductDestroyService } from '../services/product-destroy.service';

@ApiTags('품질관리 - 공정폐기관리')
@UseGuards(JwtAuthGuard)
@Controller('quality/product-destroy')
export class ProductDestroyController {
  constructor(private readonly service: ProductDestroyService) {}

  @Get('history')
  @ApiOperation({ summary: 'PB d_pln_product_destroy_hst 기준 폐기이력 조회' })
  async history(@Query() query: ProductDestroyHistoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findHistory(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('serial')
  @ApiOperation({ summary: 'PB dw_1/dw_2 기준 시리얼 단건 폐기/반품 현황' })
  async serial(@Query() query: ProductDestroySerialQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findBySerial(query.serialNo, organizationId));
  }

  @Post()
  @ApiOperation({ summary: 'PB cb_2(Destroy) 기준 폐기 일괄등록' })
  async destroy(
    @Body() dto: ProductDestroyExecuteDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    return ResponseUtil.success(await this.service.destroy(dto, organizationId, userId));
  }

  @Post('issue')
  @ApiOperation({ summary: 'PB cb_4(Issue) — RECEIPT_DEFICIT 를 2(반품)로 변경' })
  async issue(@Body() dto: ProductDestroyIssueDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.issue(dto, organizationId));
  }

  @Post('issue-cancel')
  @ApiOperation({ summary: 'PB cb_5(Issue Cancel) — RECEIPT_DEFICIT 를 1(입고)로 복귀' })
  async issueCancel(@Body() dto: ProductDestroyIssueDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.issueCancel(dto, organizationId));
  }
}
