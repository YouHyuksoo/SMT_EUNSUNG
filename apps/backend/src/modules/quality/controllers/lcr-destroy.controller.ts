import {
  Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Query, UnauthorizedException, UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import {
  LcrDestroyCreateDto,
  LcrDestroyListQueryDto,
  LcrDestroyMonthlyQueryDto,
  LcrItemSearchQueryDto,
  LcrPreviewQueryDto,
} from '../dto/lcr-destroy.dto';
import { LcrDestroyService } from '../services/lcr-destroy.service';

@ApiTags('품질관리 - LCR 폐기')
@UseGuards(JwtAuthGuard)
@Controller('quality/lcr-destroy')
export class LcrDestroyController {
  constructor(private readonly service: LcrDestroyService) {}

  @Get('items')
  @ApiOperation({ summary: 'BOM 에 L/C/R 위치 자재가 직접 달린 품번 검색' })
  async items(@Query() query: LcrItemSearchQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.searchItems(query, organizationId));
  }

  @Get('preview')
  @ApiOperation({ summary: '품번 하나의 L/C/R 자재·단가와 1연배 합계' })
  async preview(@Query() query: LcrPreviewQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.preview(query.itemCode.trim(), query.measureDate.slice(0, 10), organizationId));
  }

  @Get('monthly')
  @ApiOperation({ summary: '연간 월별 LCR 폐기 누계' })
  async monthly(@Query() query: LcrDestroyMonthlyQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.monthly(query, organizationId));
  }

  @Get()
  @ApiOperation({ summary: '월 단위 LCR 폐기 목록' })
  async list(@Query() query: LcrDestroyListQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.list(query, organizationId));
  }

  @Get(':lcrSeq/detail')
  @ApiOperation({ summary: 'LCR 폐기 1건의 자재 내역 (등록 시점 스냅샷)' })
  async detail(@Param('lcrSeq', ParseIntPipe) lcrSeq: number, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.detail(lcrSeq, organizationId));
  }

  @Post()
  @ApiOperation({ summary: 'LCR 폐기 등록 — 실장수·단가·금액은 서버가 계산해 남긴다' })
  async create(
    @Body() dto: LcrDestroyCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    return ResponseUtil.success(await this.service.create(dto, organizationId, userId));
  }

  @Delete(':lcrSeq')
  @ApiOperation({ summary: 'LCR 폐기 등록 삭제' })
  async remove(@Param('lcrSeq', ParseIntPipe) lcrSeq: number, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(lcrSeq, organizationId));
  }
}
