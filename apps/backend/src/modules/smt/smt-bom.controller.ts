import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmtBomDeleteScopeDto,
  SmtBomKeyDto,
  SmtBomLineSwapDto,
  SmtBomModelRenameDto,
  SmtBomQueryDto,
  SmtBomReportQueryDto,
  SmtBomUpsertDto,
} from './smt-bom.dto';
import { SmtBomService } from './smt-bom.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('SMT - BOM 관리')
@UseGuards(JwtAuthGuard)
@Controller('smt/bom')
export class SmtBomController {
  constructor(private readonly service: SmtBomService) {}

  @Get()
  @ApiOperation({ summary: 'SMT BOM 조회 (PB w_smt_bom_create_master). 모델명 필수' })
  async find(@Query() query: SmtBomQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('models')
  @ApiOperation({ summary: '모델 셀렉터 목록 (PB d_smt_bom_model_list)' })
  async findModels(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findModels(organizationId));
  }

  @Get('report')
  @ApiOperation({
    summary: 'BOM 관리리포트 — 배포계획 기준 라벨·바코드 목록 (PB w_smt_bom_master_rpt)',
  })
  async findReport(
    @Query() query: SmtBomReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findReport(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Post()
  @ApiOperation({ summary: 'BOM 행 등록' })
  async create(
    @Body() dto: SmtBomUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: 'BOM 행 수정 (키 일곱 컬럼은 바꿀 수 없다)' })
  async update(
    @Body() dto: SmtBomUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: 'BOM 행 삭제' })
  async remove(@Body() dto: SmtBomKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }

  @Post('line-swap')
  @ApiOperation({ summary: '라인 교체 (PKG_MES_SMT.SP_SMT_BOM_LINE_SWAP)' })
  async swapLines(
    @Body() dto: SmtBomLineSwapDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.swapLines(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('model-rename')
  @ApiOperation({
    summary: '모델명 변경 (BOM·대체BOM·배포계획을 함께 갱신. PB 는 대체BOM 을 빠뜨렸다)',
  })
  async renameModel(
    @Body() dto: SmtBomModelRenameDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.renameModel(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('scope')
  @ApiOperation({ summary: '모델·라인·면 범위 일괄삭제 (배포계획이 있으면 거부)' })
  async deleteScope(
    @Body() dto: SmtBomDeleteScopeDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.deleteScope(dto, organizationId));
  }
}
