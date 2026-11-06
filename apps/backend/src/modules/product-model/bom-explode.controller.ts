// 제품 모델 BOM 전개 방식 REST (글로벌 prefix /api/v1): /master/product-models/bom-explode
import { Body, Controller, Get, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../common/dto/response.dto';
import { BomExplodeModelQueryDto, ClassifyBomExplodeDto, UpdateBomExplodeDto } from './bom-explode.dto';
import { BomExplodeService } from './bom-explode.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('기준정보 - 제품모델 BOM 전개 방식')
@UseGuards(JwtAuthGuard)
@Controller('master/product-models/bom-explode')
export class BomExplodeController {
  constructor(private readonly service: BomExplodeService) {}

  @Get()
  @ApiOperation({ summary: '모델별 BOM 전개 방식 · 면별 생산 품목 목록' })
  async list(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.list(organizationId));
  }

  @Post('classify')
  @ApiOperation({ summary: 'BOM 전개 방식 자동 분류 (쓰기). 사람이 정한 행은 건너뛴다.' })
  async classify(@Body() dto: ClassifyBomExplodeDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.classify(organizationId, userId || DEFAULT_USER, dto.modelNames));
  }

  // 모델명에 '/'·따옴표가 들어갈 수 있어 경로가 아니라 쿼리·본문으로 받는다.
  @Get('candidates')
  @ApiOperation({ summary: '면별 생산 품목 후보 — 제품 자신과 그 BOM 의 반제품' })
  async candidates(@Query() query: BomExplodeModelQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.candidates(query.modelName, organizationId));
  }

  @Patch()
  @ApiOperation({ summary: 'BOM 전개 방식 저장 (쓰기). 사람이 정한 것으로 표시한다.' })
  async update(@Body() dto: UpdateBomExplodeDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.update(dto, organizationId, userId || DEFAULT_USER));
  }
}
