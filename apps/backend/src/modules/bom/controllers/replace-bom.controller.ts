import { Body, Controller, Delete, Get, Post, Put, Query, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import {
  BomExpandQueryDto,
  ReplaceDeleteDto,
  ReplaceListQueryDto,
  ReplaceUpsertDto,
} from '../dto/replace-bom.dto';
import { ReplaceBomService } from '../services/replace-bom.service';

@ApiTags('BOM관리 - 대체BOM관리')
@UseGuards(JwtAuthGuard)
@Controller('bom/replace')
export class ReplaceBomController {
  constructor(private readonly service: ReplaceBomService) {}

  @Get('expand')
  @ApiOperation({ summary: 'PKG_DESIGN.BOM_QUERY 기준 SET 품목 BOM 전개' })
  async expand(@Query() query: BomExpandQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.expandBom(query, organizationId);
    return ResponseUtil.success(result);
  }

  @Get()
  @ApiOperation({ summary: 'PB d_des_item_replace_lst 기준 대체품 목록 조회' })
  async list(@Query() query: ReplaceListQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findReplaceList(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Put()
  @ApiOperation({ summary: '대체품 등록/수정 (ID_ITEM_REPLACE)' })
  async upsert(
    @Body() dto: ReplaceUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    return ResponseUtil.success(await this.service.upsertReplace(dto, organizationId, userId));
  }

  @Delete()
  @ApiOperation({ summary: '대체품 삭제 (ID_ITEM_REPLACE)' })
  async remove(@Body() dto: ReplaceDeleteDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.deleteReplace(dto, organizationId));
  }
}
