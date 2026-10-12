import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmtBomReplaceKeyDto,
  SmtBomReplaceQueryDto,
  SmtBomReplaceUpsertDto,
} from './smt-bom-replace.dto';
import { SmtBomReplaceService } from './smt-bom-replace.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('SMT - BOM 대체관리')
@UseGuards(JwtAuthGuard)
@Controller('smt/bom-replace')
export class SmtBomReplaceController {
  constructor(private readonly service: SmtBomReplaceService) {}

  @Get()
  @ApiOperation({ summary: 'SMT 대체 BOM 조회 (PB w_smt_bom_replace_master)' })
  async find(@Query() query: SmtBomReplaceQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Post()
  @ApiOperation({ summary: '대체 BOM 등록' })
  async create(
    @Body() dto: SmtBomReplaceUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '대체 BOM 수정 (키 여섯 컬럼은 바꿀 수 없다)' })
  async update(
    @Body() dto: SmtBomReplaceUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '대체 BOM 삭제' })
  async remove(@Body() dto: SmtBomReplaceKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}
