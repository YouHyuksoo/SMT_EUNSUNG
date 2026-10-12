import { Body, Controller, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  JigApplyModelCopyDto,
  JigApplyModelQueryDto,
  JigMasterQueryDto,
  JigMasterUpsertDto,
} from './jig-master.dto';
import { JigMasterService } from './jig-master.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('지그관리 - 지그마스터')
@UseGuards(JwtAuthGuard)
@Controller('jig/master')
export class JigMasterController {
  constructor(private readonly service: JigMasterService) {}

  @Get()
  @ApiOperation({ summary: '지그마스터 조회 (PB w_mcn_jig_master)' })
  async find(@Query() query: JigMasterQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('apply-models')
  @ApiOperation({ summary: '선택 지그의 적용모델 목록' })
  async applyModels(
    @Query() query: JigApplyModelQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findApplyModels(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '지그 등록 (감사컬럼은 서버가 채운다)' })
  async create(
    @Body() dto: JigMasterUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '지그 수정 (LAST_MODIFY_* 만 갱신)' })
  async update(
    @Body() dto: JigMasterUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('apply-models/copy')
  @ApiOperation({ summary: '적용모델 복사 (PKG_MES_MAC.SP_COPY_APPLY_MODEL)' })
  async copyApplyModels(
    @Body() dto: JigApplyModelCopyDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.copyApplyModels(dto, organizationId));
  }
}
