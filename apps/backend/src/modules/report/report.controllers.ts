/**
 * @file src/modules/report/report.controllers.ts
 * @description 리포트(M_REPORT) 컨트롤러 — 기준정보·바코드·설비·제품·공정 10화면
 *
 *   /report/item-master        338 품목마스터리포트
 *   /report/line-barcode       340 라인설비바코드
 *   /report/carrier-barcode    341 캐리어바코드 (발행 — 쓰기)
 *   /report/machine            343 설비리포트
 *   /report/pickup-rate        344 SMT PICKUP 리포트
 *   /report/master-plan        346 생산계획리포트
 *   /report/run-card           347 런카드리포트
 *   /report/fg-issue           348 제품 판매실적
 *   /report/workstage-stock    350 공정재공조회
 *   /report/magazine-stock     352 공정매거진조회
 */
import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { CarrierBarcodeService } from './carrier-barcode.service';
import { MasterReportService } from './master-report.service';
import { ProductionReportService } from './production-report.service';
import {
  CarrierBarcodeCreateDto,
  CarrierBarcodeDeleteDto,
  CarrierBarcodeQueryDto,
  FgIssueReportQueryDto,
  ItemMasterReportQueryDto,
  LineBarcodeQueryDto,
  MachineOperationQueryDto,
  MachineReportQueryDto,
  MagazineStockQueryDto,
  MasterPlanReportQueryDto,
  PickupRateQueryDto,
  RunCardReportQueryDto,
  WorkstageStockQueryDto,
} from './report.dto';

const DEFAULT_USER = 'ADMIN';

/**
 * 리포트 응답. **`truncated` 를 meta 에 반드시 실어 보낸다.**
 *
 * 리포트는 행 수에 상한이 있어 조건이 넓으면 잘린다. 잘렸다는 사실을 화면이
 * 모르면 헤더의 합계를 잘린 창 안의 값으로 계산해 전체 합계처럼 보여준다 —
 * 리포트에서는 느린 것보다 이게 위험하다.
 */
const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('리포트 - 품목마스터')
@UseGuards(JwtAuthGuard)
@Controller('report/item-master')
export class ItemMasterReportController {
  constructor(private readonly service: MasterReportService) {}

  @Get()
  @ApiOperation({ summary: '338 품목마스터리포트 (PB 메뉴 라벨의 "폼목" 은 오타다)' })
  async find(
    @Query() query: ItemMasterReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findItemMaster(query, organizationId));
  }
}

@ApiTags('리포트 - 라인설비바코드')
@UseGuards(JwtAuthGuard)
@Controller('report/line-barcode')
export class LineBarcodeReportController {
  constructor(private readonly service: MasterReportService) {}

  @Get()
  @ApiOperation({
    summary: '340 라인설비바코드 목록. 라벨 지오메트리는 이관 대상이 아니고'
      + ' CSV 로 내보내 라벨 소프트웨어가 찍는다.',
  })
  async find(@Query() query: LineBarcodeQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findLineBarcodes(query, organizationId));
  }
}

@ApiTags('리포트 - 캐리어바코드')
@UseGuards(JwtAuthGuard)
@Controller('report/carrier-barcode')
export class CarrierBarcodeController {
  constructor(private readonly service: CarrierBarcodeService) {}

  @Get()
  @ApiOperation({ summary: '341 발행된 캐리어 바코드 목록 (이 표는 현재 0행이다)' })
  async find(@Query() query: CarrierBarcodeQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.find(query, organizationId));
  }

  @Get('count')
  @ApiOperation({ summary: '341 앞부분 일치 건수. 삭제 확인 모달에 넣는다.' })
  async count(@Query() query: CarrierBarcodeQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.count(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: "341 캐리어 바코드 범위 발행 (PB '2D Barcode Create')."
      + ' 새로 넣은 것과 이미 있던 것을 나눠 돌려준다.',
  })
  async create(
    @Body() dto: CarrierBarcodeCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: "341 발행 취소 (PB '2D Barcode Delete'). 앞부분 일치로 지운다." })
  async remove(
    @Body() dto: CarrierBarcodeDeleteDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}

@ApiTags('리포트 - 설비')
@UseGuards(JwtAuthGuard)
@Controller('report/machine')
export class MachineReportController {
  constructor(private readonly service: MasterReportService) {}

  @Get()
  @ApiOperation({ summary: '343 설비 마스터' })
  async find(@Query() query: MachineReportQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findMachines(query, organizationId));
  }

  @Get('operation')
  @ApiOperation({
    summary: '343 설비 일일가동 이력. IMCN_MACHINE_DAILY_OPERATION 은 현재 1행뿐이다.',
  })
  async operation(
    @Query() query: MachineOperationQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMachineOperations(query, organizationId));
  }
}

@ApiTags('리포트 - SMT PICKUP')
@UseGuards(JwtAuthGuard)
@Controller('report/pickup-rate')
export class PickupRateReportController {
  constructor(private readonly service: ProductionReportService) {}

  @Get('detail')
  @ApiOperation({ summary: '344 픽업 상세 — 노즐 자리별 미스와 금액' })
  async detail(@Query() query: PickupRateQueryDto) {
    return paged(await this.service.findPickupDetail(query));
  }

  @Get('amount')
  @ApiOperation({ summary: '344 라인·일자별 미스 금액 집계 (PPM 포함)' })
  async amount(@Query() query: PickupRateQueryDto) {
    return paged(await this.service.findPickupAmount(query));
  }
}

@ApiTags('리포트 - 생산계획')
@UseGuards(JwtAuthGuard)
@Controller('report/master-plan')
export class MasterPlanReportController {
  constructor(private readonly service: ProductionReportService) {}

  @Get()
  @ApiOperation({ summary: '346 MI 생산계획 매트릭스 (시간대 10칸 고정)' })
  async find(
    @Query() query: MasterPlanReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMasterPlan(query, organizationId));
  }
}

@ApiTags('리포트 - 런카드')
@UseGuards(JwtAuthGuard)
@Controller('report/run-card')
export class RunCardReportController {
  constructor(private readonly service: ProductionReportService) {}

  @Get('detail')
  @ApiOperation({ summary: '347 런카드 상세' })
  async detail(
    @Query() query: RunCardReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findRunCardDetail(query, organizationId));
  }

  @Get('summary')
  @ApiOperation({
    summary: '347 런카드 합계 — 라벨/투입/산출 수량은 PB 와 같은 DB 함수가 센다.',
  })
  async summary(
    @Query() query: RunCardReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findRunCardSummary(query, organizationId));
  }
}

@ApiTags('리포트 - 제품 판매실적')
@UseGuards(JwtAuthGuard)
@Controller('report/fg-issue')
export class FgIssueReportController {
  constructor(private readonly service: ProductionReportService) {}

  @Get('detail')
  @ApiOperation({ summary: '348 출하 상세' })
  async detail(
    @Query() query: FgIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findFgIssueDetail(query, organizationId));
  }

  @Get('summary')
  @ApiOperation({ summary: '348 모델·고객·위치별 합계' })
  async summary(
    @Query() query: FgIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findFgIssueSummary(query, organizationId));
  }

  @Get('crosstab')
  @ApiOperation({
    summary: '348 크로스탭 원자료 (일자 × 모델 수량). 열 집합이 데이터에 따라'
      + ' 달라지므로 피벗은 화면에서 한다 — PB 도 표현 계층에서 돌렸다.',
  })
  async crosstab(
    @Query() query: FgIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findFgIssueCrosstab(query, organizationId));
  }
}

@ApiTags('리포트 - 공정재공')
@UseGuards(JwtAuthGuard)
@Controller('report/workstage-stock')
export class WorkstageStockReportController {
  constructor(private readonly service: ProductionReportService) {}

  @Get()
  @ApiOperation({ summary: '350 공정재공조회 (IP_PRODUCT_WORKSTAGE_INV 는 현재 0행이다)' })
  async find(
    @Query() query: WorkstageStockQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findWorkstageStock(query, organizationId));
  }
}

@ApiTags('리포트 - 공정매거진')
@UseGuards(JwtAuthGuard)
@Controller('report/magazine-stock')
export class MagazineStockReportController {
  constructor(private readonly service: ProductionReportService) {}

  @Get()
  @ApiOperation({
    summary: "352 공정매거진조회. kind='workstage' 재공 스냅샷 · 'defect' 불량 ·"
      + " 'destroy' 폐기. 불량·폐기는 입출고 원장을 집계하므로 기간이 필수다.",
  })
  async find(
    @Query() query: MagazineStockQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findMagazineStock(query, organizationId);
    const base = paged(result);
    return { ...base, meta: { ...base.meta, kind: result.kind } };
  }
}
