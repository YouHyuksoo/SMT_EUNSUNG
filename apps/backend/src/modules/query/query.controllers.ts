/**
 * @file src/modules/query/query.controllers.ts
 * @description 조회(M_QUERY) 9화면 컨트롤러
 *
 * 화면별로 라우트를 나눈다 —
 *   /query/pid-info        323 PID 정보조회 (+ X-OUT 해제)
 *   /query/marking         324 마킹이력조회
 *   /query/pcb-input       325 PCB 투입 리스트조회
 *   /query/pda-scan        327 SMT 오장착 스캔 현황 조회 (+ NG사유·메모 저장)
 *   /query/pda-ng          328 PDA 검사오류내역조회 (+ 검사플래그 저장)
 *   /query/feeder-monitor  329 SMT 피더별 모니터링 (+ 잔량 세팅 · NSNP 제어)
 *   /query/sensor-actual   330 SMT 제품실적센서이력조회 (+ 실적 보정)
 *   /query/material-barcode 333 자재 바코드 상태 조회
 *   /query/nsnp-history    335 NSNP 처리이력조회 (+ NSNP 제어 · 이력 초기화)
 *
 * NSNP 제어는 329·335 가 같은 서비스를 쓴다 (추적 모듈의 NsnpControlService).
 * 321 생산현황데쉬보드도 같은 서비스다 — PB 는 세 창에 같은 코드를 복붙해 뒀다.
 */
import { Body, Controller, Delete, Get, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { NsnpControlService } from '../tracking/nsnp-control.service';
import { FeederMonitorService } from './feeder-monitor.service';
import { NsnpHistoryService } from './nsnp-history.service';
import { PidQueryService } from './pid-query.service';
import {
  BarcodeHistoryQueryDto,
  CheckHistNoteBulkDto,
  FeederMonitorQueryDto,
  FeederSlotQueryDto,
  LineCodeQueryDto,
  MarkingQueryDto,
  MaterialBarcodeQueryDto,
  NsnpControlDto,
  NsnpHistoryQueryDto,
  PcbInputQueryDto,
  PdaScanQueryDto,
  PidInfoQueryDto,
  PlanCheckFlagBulkDto,
  PlanDataQueryDto,
  SensorActualAdjustDto,
  SensorActualQueryDto,
  XOutRepairDto,
} from './query.dto';
import { ROW_LIMIT } from './row-limit';
import { SensorActualService } from './sensor-actual.service';
import { SmtCheckQueryService } from './smt-check-query.service';

const DEFAULT_USER = 'ADMIN';

/**
 * 목록 응답. 상한(ROW_LIMIT)에서 잘렸으면 `meta.truncated` 로 알린다 —
 * 알리지 않으면 화면이 잘린 목록을 전체처럼 보여준다. 상한이 없는 목록은 false.
 */
const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('조회 - PID 정보조회')
@UseGuards(JwtAuthGuard)
@Controller('query/pid-info')
export class PidInfoController {
  constructor(private readonly service: PidQueryService) {}

  @Get()
  @ApiOperation({
    summary: '323 PID 정보조회. Run No · PID · 매거진 중 하나가 반드시 있어야 한다'
      + ' (표가 1.8억행이고 이 화면에는 날짜 조건이 없다).',
  })
  async find(@Query() query: PidInfoQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findPidInfo(query, organizationId));
  }

  @Delete('x-out')
  @ApiOperation({ summary: "323 X-OUT 불량 해제 (PB 'X-OUT Repair'). 지운 건수를 돌려준다." })
  async repairXOut(
    @Body() dto: XOutRepairDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.repairXOut(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('조회 - 마킹이력조회')
@UseGuards(JwtAuthGuard)
@Controller('query/marking')
export class MarkingQueryController {
  constructor(private readonly service: PidQueryService) {}

  @Get('detail')
  @ApiOperation({ summary: '324 마킹 상세 — PID 한 줄씩' })
  async detail(@Query() query: MarkingQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findMarkingDetail(query, organizationId));
  }

  @Get('summary')
  @ApiOperation({ summary: '324 마킹 요약 — 롯트·설비·판정별 집계' })
  async summary(@Query() query: MarkingQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findMarkingSummary(query, organizationId));
  }
}

@ApiTags('조회 - PCB 투입 리스트조회')
@UseGuards(JwtAuthGuard)
@Controller('query/pcb-input')
export class PcbInputQueryController {
  constructor(private readonly service: PidQueryService) {}

  @Get()
  @ApiOperation({ summary: '325 PCB 투입 스캔 목록' })
  async find(@Query() query: PcbInputQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findPcbInput(query, organizationId));
  }
}

@ApiTags('조회 - SMT 오장착 스캔 현황')
@UseGuards(JwtAuthGuard)
@Controller('query/pda-scan')
export class PdaScanQueryController {
  constructor(private readonly service: SmtCheckQueryService) {}

  @Get('detail')
  @ApiOperation({ summary: '327 스캔 상세' })
  async detail(@Query() query: PdaScanQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findScanDetail(query, organizationId));
  }

  @Get('group')
  @ApiOperation({ summary: '327 풀체크 회차별 그룹 (시작·종료 시각 포함)' })
  async group(@Query() query: PdaScanQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findScanGroup(query, organizationId));
  }

  @Get('by-barcode')
  @ApiOperation({ summary: '327 바코드로 찾기 — 자사·공급처·이전 바코드를 한꺼번에' })
  async byBarcode(
    @Query() query: BarcodeHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findByBarcode(query, organizationId));
  }

  @Get('issue-history')
  @ApiOperation({ summary: '327 그 자재 제조번호의 출고 이력' })
  async issueHistory(
    @Query() query: BarcodeHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssueHistory(query, organizationId));
  }

  @Put('notes')
  @ApiOperation({ summary: '327 NG 사유·메모 저장 (그 두 컬럼만 바꾼다)' })
  async saveNotes(
    @Body() dto: CheckHistNoteBulkDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.saveCheckNotes(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('조회 - PDA 검사오류내역조회')
@UseGuards(JwtAuthGuard)
@Controller('query/pda-ng')
export class PdaNgQueryController {
  constructor(private readonly service: SmtCheckQueryService) {}

  @Get()
  @ApiOperation({ summary: '328 모델 하나의 피더 배치 계획' })
  async find(@Query() query: PlanDataQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findPlanData(query, organizationId));
  }

  @Get('line')
  @ApiOperation({ summary: '328 라인 단위 NG 체크 목록' })
  async line(@Query() query: LineCodeQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findLineNgChecks(query, organizationId));
  }

  @Get('workflow')
  @ApiOperation({ summary: '328 피더 배치 이미지와 맞춰 보기' })
  async workflow(@Query() query: PlanDataQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findWorkflow(query, organizationId));
  }

  @Put('flags')
  @ApiOperation({
    summary: '328 검사 플래그 저장 (CHECK_YN · CHECK_STATUS · CCS_YN 만).'
      + ' 키가 7컬럼이다 — 일부만 넣으면 다른 설비·테이블 계획까지 바뀐다.',
  })
  async saveFlags(
    @Body() dto: PlanCheckFlagBulkDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.savePlanCheckFlags(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('조회 - SMT 피더별 모니터링')
@UseGuards(JwtAuthGuard)
@Controller('query/feeder-monitor')
export class FeederMonitorController {
  constructor(
    private readonly service: FeederMonitorService,
    private readonly nsnp: NsnpControlService,
  ) {}

  @Get()
  @ApiOperation({ summary: '329 라인의 피더 자리 목록 (현재 롯트·투입시각·잔량)' })
  async find(@Query() query: FeederMonitorQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findFeederSlots(query, organizationId));
  }

  @Get('slot-history')
  @ApiOperation({ summary: '329 피더 한 자리의 투입 이력 (마지막 CCS 이후)' })
  async slotHistory(
    @Query() query: FeederSlotQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSlotHistory(query, organizationId));
  }

  @Get('line-actual')
  @ApiOperation({ summary: '329 라인의 센서 실적 머리글' })
  async lineActual(
    @Query() query: FeederMonitorQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findLineActual(query, organizationId));
  }

  @Put('feeding-qty')
  @ApiOperation({
    summary: "329 피더 잔량 세팅 (PB 'Set Feeding Qty'). 마지막 CCS 이후 스캔수량 합을"
      + ' FEEDING_QTY 에 적는다. 바뀐 행수를 돌려준다.',
  })
  async setFeedingQty(
    @Body() query: FeederMonitorQueryDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.setFeedingQty(query, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('nsnp')
  @ApiOperation({ summary: '329 NSNP 잠금·해제·사용·미사용 (사용자 레벨 8 이상)' })
  async setNsnp(
    @Body() dto: NsnpControlDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.nsnp.control(dto.action, dto.lineCode, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('조회 - SMT 제품실적센서이력조회')
@UseGuards(JwtAuthGuard)
@Controller('query/sensor-actual')
export class SensorActualController {
  constructor(private readonly service: SensorActualService) {}

  @Get('current')
  @ApiOperation({ summary: '330 현재 실적' })
  async current(@Query() query: SensorActualQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findCurrent(query, organizationId));
  }

  @Get('history')
  @ApiOperation({ summary: '330 실적 이력 (일자 마감 후 백업)' })
  async history(@Query() query: SensorActualQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findHistory(query, organizationId));
  }

  @Get('hourly')
  @ApiOperation({ summary: '330 1시간 단위 실적' })
  async hourly(@Query() query: SensorActualQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findHourly(query, organizationId));
  }

  @Get('time-slot')
  @ApiOperation({ summary: '330 교대 시간대 단위 실적' })
  async timeSlot(@Query() query: SensorActualQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findByTimeSlot(query, organizationId));
  }

  @Put('adjust')
  @ApiOperation({
    summary: "330 실적 보정 (PB 'Actual Adjust'). PRODUCT_ACTUAL_QTY · ADJUST_QTY 만"
      + ' 바꾸고 보정 전후 값을 함께 돌려준다.',
  })
  async adjust(
    @Body() dto: SensorActualAdjustDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.adjust(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('조회 - 자재 바코드 상태 조회')
@UseGuards(JwtAuthGuard)
@Controller('query/material-barcode')
export class MaterialBarcodeController {
  constructor(private readonly service: SensorActualService) {}

  @Get()
  @ApiOperation({ summary: '333 자재 바코드 한 줄의 상태 (입고·출고 대조 · 홀딩 · 릴폐기 · MSL)' })
  async find(
    @Query() query: MaterialBarcodeQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMaterialBarcode(query, organizationId));
  }
}

@ApiTags('조회 - NSNP 처리이력조회')
@UseGuards(JwtAuthGuard)
@Controller('query/nsnp-history')
export class NsnpHistoryController {
  constructor(
    private readonly service: NsnpHistoryService,
    private readonly nsnp: NsnpControlService,
  ) {}

  @Get('lines')
  @ApiOperation({ summary: '335 라인 상태 목록 (이력 건수 포함 — 초기화 확인 모달에 쓴다)' })
  async lines(@OrganizationId() organizationId: number) {
    return paged(await this.service.findLineStatus(organizationId));
  }

  @Get()
  @ApiOperation({ summary: '335 NSNP 이력 + 라인 ON/OFF 이력 (원장 구분 포함)' })
  async find(@Query() query: NsnpHistoryQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findHistory(query, organizationId));
  }

  @Put('control')
  @ApiOperation({ summary: '335 NSNP 잠금·해제·사용·미사용 (사용자 레벨 8 이상)' })
  async control(
    @Body() dto: NsnpControlDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.nsnp.control(dto.action, dto.lineCode, organizationId, userId || DEFAULT_USER),
    );
  }

  @Get('log-count')
  @ApiOperation({ summary: '335 초기화 대상 건수. 삭제 확인 모달에 넣는다.' })
  async logCount(
    @Query() query: LineCodeQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.nsnp.countLog(query.lineCode, organizationId));
  }

  @Delete('log')
  @ApiOperation({
    summary: "335 NSNP 이력 초기화 (PB 'NSNP Log Reset'). 되돌릴 수 없다 —"
      + ' 사용자 레벨 8 이상이고 지운 건수를 돌려준다. 라인 하나에 10만 건 가까이 쌓인다.',
  })
  async resetLog(
    @Body() dto: LineCodeQueryDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.nsnp.resetLog(dto.lineCode, organizationId, userId || DEFAULT_USER),
    );
  }
}
