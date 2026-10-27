import { Body, Controller, Get, Post, Query, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import {
  ProductDestroyCancelDto,
  ProductDestroyExecuteDto,
  ProductDestroyHistoryQueryDto,
  ProductDestroyIssueDto,
  ProductDestroySerialQueryDto,
  ProductDestroySummaryQueryDto,
} from '../dto/product-destroy.dto';
import { ProductDestroyService } from '../services/product-destroy.service';

@ApiTags('품질관리 - 공정폐기관리')
@UseGuards(JwtAuthGuard)
@Controller('quality/product-destroy')
export class ProductDestroyController {
  constructor(private readonly service: ProductDestroyService) {}

  @Get('history')
  @ApiOperation({ summary: '폐기이력 조회 — 공정폐기 원장 IP_PRODUCT_DESTROY (상태 D 폐기보관 / R 반품 / C 취소)' })
  async history(@Query() query: ProductDestroyHistoryQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findHistory(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('summary')
  @ApiOperation({ summary: '팀별 월 폐기 요약 — 불량유형·주야·원인별 수량/금액' })
  async summary(@Query() query: ProductDestroySummaryQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.summary(query, organizationId));
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

  @Post('cancel')
  @ApiOperation({ summary: '폐기 취소 — 상태를 C(취소)로 바꾸고 취소일시·취소자·사유를 남긴다. 행은 지우지 않는다' })
  async cancel(
    @Body() dto: ProductDestroyCancelDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    return ResponseUtil.success(await this.service.cancel(dto, organizationId, userId));
  }

  @Post('issue')
  @ApiOperation({ summary: 'PB cb_4(Issue) — 폐기보관(D)을 반품(R)으로' })
  async issue(
    @Body() dto: ProductDestroyIssueDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    return ResponseUtil.success(await this.service.issue(dto, organizationId, userId));
  }

  @Post('issue-cancel')
  @ApiOperation({ summary: 'PB cb_5(Issue Cancel) — 반품(R)을 폐기보관(D)으로 되돌린다' })
  async issueCancel(
    @Body() dto: ProductDestroyIssueDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    return ResponseUtil.success(await this.service.issueCancel(dto, organizationId, userId));
  }
}
