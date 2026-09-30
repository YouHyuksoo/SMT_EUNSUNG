import { Body, Controller, Get, Post, Query, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import {
  MfsCopyDto,
  MfsFeederQueryDto,
  MfsGenerateDto,
  MfsKeyDto,
  MfsListQueryDto,
  MfsModelQueryDto,
  MfsUsedDto,
} from '../dto/mfs-bom.dto';
import { MfsBomService } from '../services/mfs-bom.service';

const requireUser = (userId: string | undefined): string => {
  if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
  return userId;
};

@ApiTags('BOM관리 - 제조BOM관리')
@UseGuards(JwtAuthGuard)
@Controller('bom/mfs')
export class MfsBomController {
  constructor(private readonly service: MfsBomService) {}

  @Get('models')
  @ApiOperation({ summary: '제품모델 목록 (IP_PRODUCT_MODEL_MASTER)' })
  async models(@Query() query: MfsModelQueryDto, @OrganizationId() org: number) {
    const r = await this.service.findModels(query, org);
    return ResponseUtil.paged(r.data, r.total, 1, r.total || 1);
  }

  @Get()
  @ApiOperation({ summary: '제품 품목의 MFS 목록 (ID_MFS_BOM 요약)' })
  async list(@Query() query: MfsListQueryDto, @OrganizationId() org: number) {
    const r = await this.service.findMfsList(query, org);
    return ResponseUtil.paged(r.data, r.total, 1, r.total || 1);
  }

  @Get('detail')
  @ApiOperation({ summary: 'MFS 상세 (ID_MFS_BOM)' })
  async detail(@Query() query: MfsKeyDto, @OrganizationId() org: number) {
    const r = await this.service.findDetail(query, org);
    return ResponseUtil.paged(r.data, r.total, 1, r.total || 1);
  }

  @Get('feeder')
  @ApiOperation({ summary: 'MFS 피더 레이아웃 (ID_ENG_BOM_SMT, REVISION = MFS)' })
  async feeder(@Query() query: MfsFeederQueryDto, @OrganizationId() org: number) {
    const r = await this.service.findFeederLayout(query, org);
    return ResponseUtil.paged(r.data, r.total, 1, r.total || 1);
  }

  @Post('generate')
  @ApiOperation({ summary: '설계BOM 전개로 MFS 생성 (PB f_gen_mfs_bom)' })
  async generate(@Body() dto: MfsGenerateDto, @OrganizationId() org: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.generate(dto, org, requireUser(userId)));
  }

  @Post('drop')
  @ApiOperation({ summary: 'MFS 삭제 (승인된 MFS 는 불가)' })
  async drop(@Body() dto: MfsKeyDto, @OrganizationId() org: number, @UserId() userId: string | undefined) {
    requireUser(userId);
    return ResponseUtil.success(await this.service.drop(dto, org));
  }

  @Post('copy')
  @ApiOperation({ summary: 'MFS 복사 (PB f_mfs_bom_copy)' })
  async copy(@Body() dto: MfsCopyDto, @OrganizationId() org: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.copy(dto, org, requireUser(userId)));
  }

  @Post('confirm')
  @ApiOperation({ summary: 'MFS 승인' })
  async confirm(@Body() dto: MfsKeyDto, @OrganizationId() org: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.confirm(dto, org, requireUser(userId)));
  }

  @Post('unconfirm')
  @ApiOperation({ summary: 'MFS 승인취소' })
  async unconfirm(@Body() dto: MfsKeyDto, @OrganizationId() org: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.unconfirm(dto, org, requireUser(userId)));
  }

  @Post('used')
  @ApiOperation({ summary: 'MFS 전체 사용 / 전체 미사용' })
  async used(@Body() dto: MfsUsedDto, @OrganizationId() org: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.setUsed(dto, org, requireUser(userId)));
  }
}
