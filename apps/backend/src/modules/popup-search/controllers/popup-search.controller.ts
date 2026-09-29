/**
 * @file src/modules/popup-search/controllers/popup-search.controller.ts
 * @description 공용 팝업조회 엔드포인트 — 팝업 하나마다 라우트를 만들지 않는다
 *
 * 필터 이름은 팝업마다 다르므로 쿼리스트링을 DTO 로 고정할 수 없다.
 * 대신 원본 쿼리스트링을 받아 **카탈로그 선언과 정확히 대조**한다
 * (전역 ValidationPipe 의 whitelist 보다 엄격하다 — 모르는 키를 지우지 않고 거부한다).
 */
import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { PopupSearchService } from '../services/popup-search.service';

@ApiTags('공용 - 팝업조회')
@UseGuards(JwtAuthGuard)
@Controller('popup-search')
export class PopupSearchController {
  constructor(private readonly service: PopupSearchService) {}

  @Get(':query')
  @ApiOperation({ summary: '화이트리스트 쿼리명으로 팝업 목록 조회 (SELECT 전용)' })
  async search(
    @Param('query') queryName: string,
    @Query() params: Record<string, string>,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.search(queryName, params, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
}
