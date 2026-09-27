/**
 * @file src/modules/report/material-report.controllers.ts
 * @description 리포트 B 컨트롤러 — 자재 원장 7화면 + S-PARTS·지그·4M 6화면
 *
 *   /report/material-barcode-slip  362 자재전표바코드리포트
 *   /report/material-receipt       363 자재입고리포트
 *   /report/material-receipt-sum   364 자재입고합계리포트
 *   /report/material-issue         365 자재출고리포트
 *   /report/material-issue-sum     366 자재출고합계리포트
 *   /report/material-rack-move     367 자재랙이동리포트
 *   /report/material-long-term     368 자재장기재고리포트
 *   /report/material-inventory     369 재고리포트
 *   /report/mold-receipt           354 S-PARTS입고리포트
 *   /report/mold-issue             355 S-PARTS출고리포트
 *   /report/jig                    357 지그리포트
 *   /report/mold                   358 S-PARTS관리리포트
 *   /report/four-m                 360 4M 변경이력
 */
import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from './report-rows';
import { MaterialInventoryReportService } from './material-inventory-report.service';
import { MaterialIssueReportService } from './material-issue-report.service';
import { MaterialReceiptReportService } from './material-receipt-report.service';
import { MoldJigReportService } from './mold-jig-report.service';
import {
  FourMHistoryQueryDto,
  FullCheckDateQueryDto,
  JigIssueReportQueryDto,
  JigReportQueryDto,
  MaterialBarcodeSlipQueryDto,
  MaterialDisusedQueryDto,
  MaterialInventoryDailyQueryDto,
  MaterialInventoryQueryDto,
  MaterialIssueReportQueryDto,
  MaterialIssueSumQueryDto,
  MaterialLongTermQueryDto,
  MaterialRackMoveQueryDto,
  MaterialReceiptReportQueryDto,
  MaterialReceiptSumQueryDto,
  MoldIssueReportQueryDto,
  MoldMasterReportQueryDto,
  MoldReceiptReportQueryDto,
  SmtCheckBarcodeQueryDto,
} from './material-report.dto';

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

@ApiTags('리포트 - 자재전표바코드')
@UseGuards(JwtAuthGuard)
@Controller('report/material-barcode-slip')
export class MaterialBarcodeSlipController {
  constructor(private readonly service: MaterialReceiptReportService) {}

  @Get()
  @ApiOperation({
    summary: "362 자재 바코드 스캔 이력. PB 고정조건 LOT_DIVIDE_YN='Y'(롯트 분할분만)를"
      + " 기본으로 켜 둔다 — 'ALL' 로 끄면 193만행이 대상이 된다.",
  })
  async find(
    @Query() query: MaterialBarcodeSlipQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findBarcodeSlips(query, organizationId));
  }
}

@ApiTags('리포트 - 자재입고')
@UseGuards(JwtAuthGuard)
@Controller('report/material-receipt')
export class MaterialReceiptReportController {
  constructor(private readonly service: MaterialReceiptReportService) {}

  @Get('detail')
  @ApiOperation({ summary: '363 입고 상세 (일자별). 기준단가와 비교해 단가 미확인 건을 본다.' })
  async detail(
    @Query() query: MaterialReceiptReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptDetail(query, organizationId));
  }

  @Get('supplier')
  @ApiOperation({ summary: '363 협력사별 입고 (발주유형 조건)' })
  async supplier(
    @Query() query: MaterialReceiptReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptBySupplier(query, organizationId, 'supplier'));
  }

  @Get('return')
  @ApiOperation({ summary: "363 반품 (PB 고정조건 RECEIPT_DEFICIT='2')" })
  async returns(
    @Query() query: MaterialReceiptReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptBySupplier(query, organizationId, 'return'));
  }

  @Get('matrix')
  @ApiOperation({
    summary: '363 매트릭스 원자료 (품목 × 일자 입고수량). DataWindow processing=4 —'
      + ' 진짜 크로스탭이라 열 집합이 기간에 따라 달라진다. 피벗은 화면에서 한다.',
  })
  async matrix(
    @Query() query: MaterialReceiptReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptMatrix(query, organizationId));
  }
}

@ApiTags('리포트 - 자재입고합계')
@UseGuards(JwtAuthGuard)
@Controller('report/material-receipt-sum')
export class MaterialReceiptSumController {
  constructor(private readonly service: MaterialReceiptReportService) {}

  @Get('item')
  @ApiOperation({ summary: '364 품목별 입고합계 (단가는 PB 와 같이 단순 평균)' })
  async item(
    @Query() query: MaterialReceiptSumQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptSumByItem(query, organizationId));
  }

  @Get('item-with-contact')
  @ApiOperation({
    summary: "364 품목별 입고합계 + 협력사 연락처 (PB '협력사용' DataWindow)."
      + ' 협력사에 보내는 인쇄물용이라 주소·전화·팩스를 함께 묶는다.',
  })
  async itemWithContact(
    @Query() query: MaterialReceiptSumQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptSumByItem(query, organizationId, true));
  }

  @Get('supplier')
  @ApiOperation({ summary: '364 협력사별 입고합계' })
  async supplier(
    @Query() query: MaterialReceiptSumQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptSumBySupplier(query, organizationId));
  }

  @Get('warehouse')
  @ApiOperation({ summary: '364 창고별 입고합계' })
  async warehouse(
    @Query() query: MaterialReceiptSumQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptSumByWarehouse(query, organizationId));
  }

  @Get('matrix')
  @ApiOperation({
    summary: '364 입출고 매트릭스 원자료 (입고 + 출고 UNION ALL).'
      + ' DataWindow processing=4 — 피벗은 화면에서 한다.',
  })
  async matrix(
    @Query() query: MaterialReceiptSumQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptIssueMatrix(query, organizationId));
  }
}

@ApiTags('리포트 - 자재출고')
@UseGuards(JwtAuthGuard)
@Controller('report/material-issue')
export class MaterialIssueReportController {
  constructor(private readonly service: MaterialIssueReportService) {}

  @Get('detail')
  @ApiOperation({
    summary: '365 출고 상세. 기간은 **등록일(ENTER_DATE)** 이다 — PB 그대로다.'
      + ' 풀체크 시각은 목록에 넣지 않는다 (1만행에 367초 — 실측). 행을 고르면'
      + ' /full-check 로 그 한 건만 조회한다.',
  })
  async detail(
    @Query() query: MaterialIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssueDetail(query, organizationId));
  }

  @Get('simple')
  @ApiOperation({
    summary: '365 출고 상세(간이) — 단가 하한을 건다 (PB 간이 DataWindow).'
      + ' 단가는 DB 함수가 계산하므로 이 조건은 인덱스와 무관하다.',
  })
  async simple(
    @Query() query: MaterialIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssueDetail(query, organizationId, true));
  }

  @Get('full-check')
  @ApiOperation({
    summary: '365 고른 출고 한 건의 풀체크 시각. 비어 있으면 출고만 되고 라인에'
      + ' 안 올라갔다는 뜻이다. 값의 정의는 PB 목록 열과 같다.',
  })
  async fullCheck(@Query() query: FullCheckDateQueryDto) {
    return ResponseUtil.success(await this.service.findFullCheckDate(
      query.itemCode, query.materialMfs, query.issueDateKey,
    ));
  }

  @Get('not-issued')
  @ApiOperation({
    summary: '365 미출고 (지시 − 출고 ≠ 0). IM_ITEM_WORK_ORDER 는 현재 0행이다.',
  })
  async notIssued(
    @Query() query: MaterialIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findNotIssued(query, organizationId));
  }

  @Get('smt-check')
  @ApiOperation({
    summary: '365 SMT 풀체크 이력 (바코드 하나). 스캔·협력사·이전 바코드 세 컬럼을'
      + ' OR 로 훑는다 — 312만행이고 기간 조건이 없어 바코드가 필수다.',
  })
  async smtCheck(@Query() query: SmtCheckBarcodeQueryDto) {
    return paged(await this.service.findSmtCheckHistory(query));
  }
}

@ApiTags('리포트 - 자재출고합계')
@UseGuards(JwtAuthGuard)
@Controller('report/material-issue-sum')
export class MaterialIssueSumController {
  constructor(private readonly service: MaterialIssueReportService) {}

  @Get('item')
  @ApiOperation({ summary: '366 품목별 출고합계' })
  async item(
    @Query() query: MaterialIssueSumQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssueSumByItem(query, organizationId));
  }

  @Get('account')
  @ApiOperation({ summary: '366 출고계정별 합계' })
  async account(
    @Query() query: MaterialIssueSumQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssueSumByAccount(query, organizationId));
  }
}

@ApiTags('리포트 - 자재랙이동')
@UseGuards(JwtAuthGuard)
@Controller('report/material-rack-move')
export class MaterialRackMoveController {
  constructor(private readonly service: MaterialIssueReportService) {}

  @Get()
  @ApiOperation({
    summary: '367 랙 이동 이력. IM_ITEM_LOCATION_MOVE_HIST 는 현재 0행이다.',
  })
  async find(
    @Query() query: MaterialRackMoveQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findRackMoves(query, organizationId));
  }
}

@ApiTags('리포트 - 자재장기재고')
@UseGuards(JwtAuthGuard)
@Controller('report/material-long-term')
export class MaterialLongTermController {
  constructor(private readonly service: MaterialInventoryReportService) {}

  @Get()
  @ApiOperation({
    summary: '368 장기재고 — 기준일에서 N개월 이전에 마지막 입고된 재고.'
      + ' 기간이 아니라 기준일 + 개월수다.',
  })
  async find(
    @Query() query: MaterialLongTermQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findLongTermInventory(query, organizationId));
  }
}

@ApiTags('리포트 - 재고')
@UseGuards(JwtAuthGuard)
@Controller('report/material-inventory')
export class MaterialInventoryReportController {
  constructor(private readonly service: MaterialInventoryReportService) {}

  @Get('detail')
  @ApiOperation({ summary: '369 롯트별 재고 상세 (안전재고 비교)' })
  async detail(
    @Query() query: MaterialInventoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findInventoryDetail(query, organizationId));
  }

  @Get('summary')
  @ApiOperation({ summary: '369 품목별 재고합계 (단가 = 금액 합 ÷ 수량 합)' })
  async summary(
    @Query() query: MaterialInventoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findInventorySummary(query, organizationId));
  }

  @Get('daily')
  @ApiOperation({
    summary: '369 일일 재고 (기준일 입고·출고·재공). 재공수량은 PB 의 INVALID 함수'
      + ' 대신 직접 집계하며 **PB 와 집계 기준이 다르다** (품목+조직 합산).',
  })
  async daily(
    @Query() query: MaterialInventoryDailyQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findInventoryDaily(query, organizationId));
  }

  @Get('disused')
  @ApiOperation({
    summary: '369 불용재고 — 개월수 안 출고가 없거나 출고율이 기준 이하인 재고.'
      + ' PB 가 WHERE 안에서 세 번 부르던 함수를 한 번만 계산한다 (결과는 같다).',
  })
  async disused(
    @Query() query: MaterialDisusedQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findDisusedInventory(query, organizationId));
  }
}

@ApiTags('리포트 - S-PARTS입고')
@UseGuards(JwtAuthGuard)
@Controller('report/mold-receipt')
export class MoldReceiptReportController {
  constructor(private readonly service: MoldJigReportService) {}

  @Get()
  @ApiOperation({
    summary: "354 S-PARTS 입고. PB 고정조건 MOLD_CODE<>'*' · RECEIPT_STATUS='N'."
      + ' IMCN_MOLD_RECEIPT 는 현재 0행이다.',
  })
  async find(
    @Query() query: MoldReceiptReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMoldReceipts(query, organizationId));
  }
}

@ApiTags('리포트 - S-PARTS출고')
@UseGuards(JwtAuthGuard)
@Controller('report/mold-issue')
export class MoldIssueReportController {
  constructor(private readonly service: MoldJigReportService) {}

  @Get()
  @ApiOperation({ summary: '355 S-PARTS 출고. IMCN_MOLD_ISSUE 는 현재 0행이다.' })
  async find(
    @Query() query: MoldIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMoldIssues(query, organizationId));
  }
}

@ApiTags('리포트 - 지그')
@UseGuards(JwtAuthGuard)
@Controller('report/jig')
export class JigReportController {
  constructor(private readonly service: MoldJigReportService) {}

  @Get()
  @ApiOperation({ summary: '357 지그 목록 (바코드 값 포함, 1,944건)' })
  async find(@Query() query: JigReportQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findJigs(query, organizationId));
  }

  @Get('card')
  @ApiOperation({
    summary: '357 지그 이력카드 (수리이력 외부조인 — 수리 기록이 없는 지그도 남는다)',
  })
  async card(@Query() query: JigReportQueryDto, @OrganizationId() organizationId: number) {
    return paged(await this.service.findJigCards(query, organizationId));
  }

  @Get('issue')
  @ApiOperation({ summary: '357 지그 출고 이력. IMCN_JIG_ISSUE 는 현재 0행이다.' })
  async issue(
    @Query() query: JigIssueReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findJigIssues(query, organizationId));
  }
}

@ApiTags('리포트 - S-PARTS관리')
@UseGuards(JwtAuthGuard)
@Controller('report/mold')
export class MoldReportController {
  constructor(private readonly service: MoldJigReportService) {}

  @Get()
  @ApiOperation({
    summary: '358 S-PARTS 마스터 + 재고 (재고가 없는 S-PARTS 도 남긴다 — 외부조인).'
      + ' 두 표 모두 현재 0행이다.',
  })
  async find(
    @Query() query: MoldMasterReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMolds(query, organizationId));
  }

  @Get('card')
  @ApiOperation({ summary: '358 S-PARTS 이력카드 (재고 + 수리이력). 현재 0행이다.' })
  async card(
    @Query() query: MoldMasterReportQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMoldCards(query, organizationId));
  }
}

@ApiTags('리포트 - 4M 변경이력')
@UseGuards(JwtAuthGuard)
@Controller('report/four-m')
export class FourMHistoryController {
  constructor(private readonly service: MoldJigReportService) {}

  @Get()
  @ApiOperation({
    summary: '360 모델별 H/W·S/W 버전. PB 는 모델명을 등호로 걸었지만 앞부분 일치로'
      + ' 넓혔다 (모델 마스터 327행). S/W 두 칸은 원천 표가 0행이라 항상 비어 있다.',
  })
  async find(
    @Query() query: FourMHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findFourMHistory(query, organizationId));
  }
}
