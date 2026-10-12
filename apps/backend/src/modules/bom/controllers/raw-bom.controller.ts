import { Body, Controller, Get, Put, Query, UnauthorizedException, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { ROW_LIMIT } from '../../../shared/row-limit';
import { RawBomListQueryDto, RawBomLoopCheckQueryDto, RawBomUpdateDto } from '../dto/raw-bom.dto';
import { RawBomService } from '../services/raw-bom.service';

@ApiTags('BOM관리 - 원단위BOM마스터')
@UseGuards(JwtAuthGuard)
@Controller('bom/raw-bom')
export class RawBomController {
  constructor(private readonly service: RawBomService) {}

  @Get('loop-check')
  @ApiOperation({ summary: 'ID_ENG_BOM 순환 구조 검사 (유효기간 무관, 읽기 전용)' })
  async loopCheck(@Query() query: RawBomLoopCheckQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findLoops(query, organizationId));
  }

  @Get()
  @ApiOperation({ summary: 'PB d_des_raw_bom_lst 기준 원단위BOM 목록 조회' })
  async list(@Query() query: RawBomListQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findList(query, organizationId);
    const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
    return { ...base, meta: { ...base.meta, truncated: result.truncated, rowLimit: ROW_LIMIT } };
  }

  @Put()
  @ApiOperation({ summary: '원단위BOM 수정 (ID_ENG_BOM)' })
  async update(
    @Body() dto: RawBomUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!userId) throw new UnauthorizedException('사용자 정보를 확인할 수 없습니다.');
    return ResponseUtil.success(await this.service.update(dto, organizationId, userId));
  }
}
