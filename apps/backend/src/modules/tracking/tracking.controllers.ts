/**
 * @file src/modules/tracking/tracking.controllers.ts
 * @description 추적 7화면 컨트롤러
 *
 * 화면별로 컨트롤러를 나누지 않고 세 갈래로 묶었다 —
 *   /tracking/material   자재 추적 (313 · 314 · 315)
 *   /tracking/pid        생산이력 추적 (317 · 318 · 319)
 *   /tracking/dashboard  생산현황데쉬보드 (321)
 * 318·319 는 롯트카드 목록을 공유하므로 라우트도 공유한다.
 */
import { Body, Controller, Get, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { LineDashboardService } from './line-dashboard.service';
import { MaterialTrackingService } from './material-tracking.service';
import { PID_STAGE_COUNTS, PidTrackingService } from './pid-tracking.service';
import {
  DynamicMaterialQueryDto,
  LineDashboardDetailQueryDto,
  LineDashboardQueryDto,
  LotNoQueryDto,
  MaterialLotSpiQueryDto,
  NsnpLockDto,
  RunCardListQueryDto,
  RunNoQueryDto,
  SerialNoQueryDto,
} from './tracking.dto';

const DEFAULT_USER = 'ADMIN';

/**
 * 목록 응답에 화면이 필요한 부가정보를 meta 에 덧붙인다.
 *
 * ResponseUtil.paged 의 meta 는 페이지 정보만 담는다. 추적 화면은 그것 말고도
 * '무엇으로 찾았는지'(바코드→제조번호), '라인을 어떻게 펼쳤는지', '잘렸는지' 를
 * 알아야 한다 — 화면이 사용자에게 그대로 말해줘야 하는 값들이다.
 * 공용 ResponseUtil 을 건드리지 않고 이 대분류에서만 덧붙인다.
 */
function pagedWith<T>(
  result: { data: T[]; total: number },
  extra: Record<string, unknown>,
) {
  const paged = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return { ...paged, meta: { ...paged.meta, ...extra } };
}

@ApiTags('추적 - 자재추적')
@UseGuards(JwtAuthGuard)
@Controller('tracking/material')
export class MaterialTrackingController {
  constructor(private readonly service: MaterialTrackingService) {}

  @Get('feeding-windows')
  @ApiOperation({
    summary: '313 자재 제조번호 기준 추적 — 투입 구간 목록 (바코드를 넣어도 제조번호로 바꿔 찾는다)',
  })
  async feedingWindows(
    @Query() query: LotNoQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findFeedingWindows(query, organizationId);
    return pagedWith(result, { resolvedLotNo: result.resolvedLotNo });
  }

  @Get('lot-spi')
  @ApiOperation({ summary: '313 고른 투입 구간·라인의 SPI 검사데이터' })
  async lotSpi(@Query() query: MaterialLotSpiQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findLotSpiData(query, organizationId);
    return pagedWith(result, { expandedLines: result.expandedLines });
  }

  @Get('stage-timeline')
  @ApiOperation({ summary: '314 자재추적조회(동적) — 이 PID 가 지나간 공정 시점' })
  async stageTimeline(@Query() query: SerialNoQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findStageTimeline(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('dynamic')
  @ApiOperation({ summary: '314 고른 시점에 라인에 세팅돼 있던 자재 (기준시각 전 최신 + 이후 N분)' })
  async dynamic(
    @Query() query: DynamicMaterialQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findDynamicMaterials(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('usage')
  @ApiOperation({ summary: '315 자재사용이력조회 — 제조번호 하나의 입고·출고·SMT투입 전 이력' })
  async usage(@Query() query: LotNoQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findMaterialUsage(query, organizationId);
    return pagedWith(result, { resolvedLotNo: result.resolvedLotNo });
  }
}

@ApiTags('추적 - 생산이력추적')
@UseGuards(JwtAuthGuard)
@Controller('tracking/pid')
export class PidTrackingController {
  constructor(private readonly service: PidTrackingService) {}

  @Get('stage-columns')
  @ApiOperation({
    summary: '공정 매트릭스 컬럼 정의. 값은 F_GET_PID_* 가 돌려주는 **건수**다 (값이 아니다).',
  })
  stageColumns() {
    return ResponseUtil.success(
      PID_STAGE_COUNTS.map((s) => ({ key: s.key, label: s.label, dbFunction: s.fn })),
    );
  }

  @Get('run-cards')
  @ApiOperation({ summary: '318·319 공용 롯트카드 목록' })
  async runCards(@Query() query: RunCardListQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findRunCards(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('header')
  @ApiOperation({ summary: '317 PID 머리글 — Run No · 모델명 · 바코드 상태' })
  async header(@Query() query: SerialNoQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findPidHeader(query, organizationId));
  }

  @Get('stage-counts-by-run')
  @ApiOperation({ summary: '318 이 롯트의 PID 별 공정 데이터 건수 매트릭스' })
  async stageCountsByRun(
    @Query() query: RunNoQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findStageCounts({ runNo: query.runNo }, organizationId);
    return pagedWith(result, { truncated: result.truncated, limit: result.limit });
  }

  @Get('stage-counts-by-serial')
  @ApiOperation({ summary: '317 이 PID 하나의 공정 데이터 건수' })
  async stageCountsBySerial(
    @Query() query: SerialNoQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findStageCounts({ serialNo: query.serialNo }, organizationId);
    return pagedWith(result, { truncated: result.truncated, limit: result.limit });
  }

  @Get('lot-detail')
  @ApiOperation({ summary: '319 이 롯트의 PID 별 전 공정 시각 (은성판 45컬럼)' })
  async lotDetail(@Query() query: RunNoQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findLotDetail(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('materials')
  @ApiOperation({ summary: '317·319 이 PID 가 속한 롯트에 투입된 자재' })
  async materials(@Query() query: SerialNoQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findPidMaterials(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }
}

@ApiTags('추적 - 생산현황데쉬보드')
@UseGuards(JwtAuthGuard)
@Controller('tracking/dashboard')
export class LineDashboardController {
  constructor(private readonly service: LineDashboardService) {}

  @Get('line')
  @ApiOperation({ summary: '321 라인 현황 요약 (IRPT_PRODUCT_LINE_DASHBOARD 뷰 — 실시간)' })
  async line(@Query() query: LineDashboardQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.findLineStatus(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('pickup-rate')
  @ApiOperation({ summary: '321 오늘 업무일의 픽업률 (업무일 판정은 DB 함수가 한다)' })
  async pickupRate(
    @Query() query: LineDashboardQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findPickupRate(query, organizationId);
    return pagedWith(result, { workDate: result.workDate });
  }

  @Get('detail')
  @ApiOperation({ summary: '321 상세 8개 탭 일괄 조회 (솔더·마스크·스퀴지·MSL·PCB·샘플·릴·인터록)' })
  async detail(
    @Query() query: LineDashboardDetailQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findDetailTabs(query, organizationId));
  }

  @Put('nsnp')
  @ApiOperation({ summary: '321 NSNP 잠금·해제 (사용자 레벨 8 이상 — PB 가드 유지)' })
  async nsnp(
    @Body() dto: NsnpLockDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.setNsnpLock(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
