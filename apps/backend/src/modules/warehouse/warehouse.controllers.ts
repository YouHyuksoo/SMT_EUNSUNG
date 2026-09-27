/**
 * @file src/modules/warehouse/warehouse.controllers.ts
 * @description 자재창고(M_WAREHOUSE) 컨트롤러 — 1단계
 *
 *   /warehouse/chamber-stock   262 베이킹재고 · 263 진공포장재고 · 264 제습함재고
 *                              (chamberType 'B'·'V'·'D' 로 갈린다)
 *   /warehouse/recycle-check   266 SMT 공릴체크
 */
import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { ChamberStockService } from './chamber-stock.service';
import { RecycleCheckService } from './recycle-check.service';
import {
  ChamberStockDetailQueryDto,
  ChamberStockQueryDto,
  RecycleCheckQueryDto,
} from './warehouse.dto';

/**
 * 목록 응답. **`truncated` 를 meta 에 실어 보낸다** — 화면이 합계를 잘린 창 안의
 * 값으로 계산해 전체 합계처럼 보여주는 것을 막는다 (리포트에서 정한 규칙).
 */
const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('자재창고 - 챔버 재고')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/chamber-stock')
export class ChamberStockController {
  constructor(private readonly service: ChamberStockService) {}

  @Get('summary')
  @ApiOperation({
    summary: "262·263·264 챔버별·품목별 재고 묶음. chamberType 'B' 베이킹실 ·"
      + " 'V' 진공포장 · 'D' 제습함 (세 화면의 SQL 은 같고 이 값만 다르다)."
      + ' 재고는 넣었고 아직 안 꺼낸 것이다 — 실측 B 4건 · V 0건 · D 55건.',
  })
  async summary(
    @Query() query: ChamberStockQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSummary(query, organizationId));
  }

  @Get('detail')
  @ApiOperation({
    summary: '262·263·264 고른 (챔버, 품목) 묶음의 자재 목록. 경과시간과 품목의'
      + ' 베이킹시간·수명을 함께 내보내 초과를 판단할 수 있게 한다.',
  })
  async detail(
    @Query() query: ChamberStockDetailQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findDetail(query, organizationId));
  }
}

@ApiTags('자재창고 - SMT 공릴체크')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/recycle-check')
export class RecycleCheckController {
  constructor(private readonly service: RecycleCheckService) {}

  @Get()
  @ApiOperation({
    summary: "266 공릴체크 이력. 조회 전용이다 — PB 의 dw.update() 는 편집 가능"
      + ' 컬럼이 없어 무동작이다 (실측). 판정 분포 P 통과 419건 · E 오류 158건.',
  })
  async find(
    @Query() query: RecycleCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.find(query, organizationId));
  }
}
