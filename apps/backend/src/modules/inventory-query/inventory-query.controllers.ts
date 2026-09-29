/**
 * @file src/modules/inventory-query/inventory-query.controllers.ts
 * @description 재고(M_INVENTORY) 컨트롤러
 *
 *   /inventory-query/total        269 총재고조회
 *   /inventory-query/close        271 자재재고마감 (수불명세)
 *   /inventory-query/check        272 자재재고조사 (조정 — 쓰기)
 *   /inventory-query/barcode      274 자재바코드스캔실사 (조회)
 */
import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { InventoryCheckService } from './inventory-check.service';
import { InventoryCloseService } from './inventory-close.service';
import { TotalInventoryService } from './total-inventory.service';
import {
  BarcodeCheckQueryDto,
  InventoryAdjustDto,
  InventoryCheckQueryDto,
  InventoryCloseQueryDto,
  ReceiptIssueLedgerQueryDto,
  TotalInventoryDetailQueryDto,
  TotalInventoryLotQueryDto,
  TotalInventoryQueryDto,
} from './inventory-query.dto';

const DEFAULT_USER = 'ADMIN';

/** 자재창고와 같은 규칙: 잘렸는지를 meta 에 실어 보낸다. */
const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('재고 - 총재고조회')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/total')
export class TotalInventoryController {
  constructor(private readonly service: TotalInventoryService) {}

  @Get()
  @ApiOperation({
    summary: '269 품목별 총재고. 자재창고·공정·조립품·완제품 네 군데를 DB 함수로'
      + ' 합쳐 낸다. 품목 2,560건에 함수 4개씩 부르지만 실측 0.13초다.',
  })
  async find(
    @Query() query: TotalInventoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findTotals(query, organizationId));
  }

  @Get('by-location')
  @ApiOperation({
    summary: '269 자리별 상세 (자재창고 + 공정). **수량 0 은 뺀다** —'
      + ' 빼지 않으면 1,837,704행이 그대로 나온다 (0 이 아닌 것 4,690행).',
  })
  async byLocation(
    @Query() query: TotalInventoryDetailQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findByLocation(query, organizationId));
  }

  @Get('by-lot')
  @ApiOperation({
    summary: '269 롯트별 상세. 공정 재고는 라인별 수량을 DB 함수가 다시 계산한다 —'
      + ' 공정 재고표가 이동 이력이라 행을 그대로 더하면 값이 맞지 않는다.',
  })
  async byLot(
    @Query() query: TotalInventoryLotQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findByLot(
      query.itemCode, query.lang ?? 'KOR', organizationId,
    ));
  }
}

@ApiTags('재고 - 자재재고마감')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/close')
export class InventoryCloseController {
  constructor(private readonly service: InventoryCloseService) {}

  @Get('ledger')
  @ApiOperation({
    summary: '271 월 수불명세. (1)전월말 → (2)입고 → (3)출고 → (4)당월말 을 한 목록으로'
      + ' 낸다. **(1)과 (4)는 월마감을 돌려야 생긴다** —'
      + ' IM_ITEM_INVENTORY_CLOSE_MFS 가 0행이라 지금은 (2)(3)만 나온다 (실측).',
  })
  async ledger(
    @Query() query: ReceiptIssueLedgerQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findLedger(query, organizationId));
  }

  @Get('summary')
  @ApiOperation({
    summary: '271 품목 단위 월마감. **이 표도 0행이다** (IM_ITEM_INVENTORY_CLOSE).'
      + ' 현재고를 함께 내어 마감값과 견줘 볼 수 있게 한다.',
  })
  async summary(
    @Query() query: InventoryCloseQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findCloseSummary(query, organizationId));
  }
}

@ApiTags('재고 - 자재재고조사')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/check')
export class InventoryCheckController {
  constructor(private readonly service: InventoryCheckService) {}

  @Get()
  @ApiOperation({
    summary: '272 실사 대상·결과 (장부수량 · 실사수량 · 차이).'
      + ' **이 표는 0행이다** — 실사를 돌린 적이 없다 (실측).',
  })
  async find(
    @Query() query: InventoryCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findCheckList(query, organizationId));
  }

  @Get('adjust-history')
  @ApiOperation({
    summary: "272 조정 이력 (계정 M009 인 출고만). **실측 0건**이다 —"
      + ' 원장에 M001 1,897,372 · M016 722,578 뿐이고 M009 는 없다.',
  })
  async adjustHistory(
    @Query() query: InventoryCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findAdjustHistory(query, organizationId));
  }

  @Post('adjust')
  @ApiOperation({
    summary: '272 재고 조정 (**쓰기**). 차이의 부호가 방향을 정한다 (양수 3 · 음수 4).'
      + ' 조정 출고는 계정 M009 · 비고 INVENTORY ADJUST 로 남고, 날짜는'
      + ' F_GET_INVENTORY_CLOSE_DATE 가 정하는 **마감월의 마지막 날**이다 —'
      + ' SYSDATE 를 쓰면 다음 달 수불로 새어 나간다.',
  })
  async adjust(
    @Body() dto: InventoryAdjustDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.adjustInventory(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('재고 - 자재바코드스캔실사')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/barcode')
export class BarcodeCheckController {
  constructor(private readonly service: InventoryCheckService) {}

  @Get()
  @ApiOperation({
    summary: '274 바코드 실사 목록. **실측 1행(2020-10)** — 6년 동안 쓰이지 않았다.'
      + ' 쓰기(무전표 바코드를 가상 입고로 만드는 경로)는 옮기지 않았다.',
  })
  async find(
    @Query() query: BarcodeCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findBarcodeCheck(query, organizationId));
  }

  @Get('summary')
  @ApiOperation({ summary: '274 품목별 요약 (찍은 수량 · 장부 수량 · 차이).' })
  async summary(
    @Query() query: BarcodeCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findBarcodeCheckSummary(query, organizationId));
  }
}
