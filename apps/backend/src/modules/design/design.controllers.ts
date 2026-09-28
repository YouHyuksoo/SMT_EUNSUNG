/**
 * @file src/modules/design/design.controllers.ts
 * @description 설계(M_DESIGN) 컨트롤러 — 149 적용모델관리.
 */
import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { ApplyItemQueryDto, ApplyModelQueryDto } from './apply-item.dto';
import { ApplyItemService } from './apply-item.service';

const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('설계 - 적용모델관리')
@UseGuards(JwtAuthGuard)
@Controller('design/apply-item')
export class ApplyItemController {
  constructor(private readonly service: ApplyItemService) {}

  @Get()
  @ApiOperation({
    summary: '149 이 자재를 쓰는 상위 품목을 BOM 을 거꾸로 타고 끝까지 찾는다.'
      + ' 오늘 유효한 BOM 만 본다 (PB 고정조건). 자재코드는 필수다.',
  })
  async find(
    @Query() query: ApplyItemQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findApplyItems(query, organizationId));
  }

  @Get('models')
  @ApiOperation({ summary: '149 고른 품목의 제품모델 기준정보.' })
  async models(
    @Query() query: ApplyModelQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findApplyModels(query, organizationId));
  }
}
