/**
 * @file src/modules/warehouse/warehouse.controllers.ts
 * @description 자재창고(M_WAREHOUSE) 컨트롤러 — 1단계
 *
 *   /warehouse/chamber-stock   262 베이킹재고 · 263 진공포장재고 · 264 제습함재고
 *                              (chamberType 'B'·'V'·'D' 로 갈린다)
 *   /warehouse/recycle-check   266 SMT 공릴체크
 *   /warehouse/solder          244 솔더입출고조회 (입고·출고 — 쓰기)
 *   /warehouse/solder-input    245 솔더라인투입이력조회
 *   /warehouse/receipt-slip    235 자재입고전표관리 (바코드 발행 — 쓰기)
 *   /warehouse/barcode-receipt 237 자재바코드입고관리 (입고대조 — 쓰기)
 *   /warehouse/solder-label    243 솔더라벨 발행 (전표+라벨 — 쓰기)
 *   /warehouse/receipt-manage  253 자재입고관리 (조회) · 254 자재기타입고관리 (쓰기)
 *   /warehouse/issue-manage    257 자재기타출고 · 258 자재출고취소 (쓰기)
 *   /warehouse/issue-return    250 출고바코드반품 (쓰기)
 *   /warehouse/barcode-issue   238 자재바코드출고관리 (출고대조 — 쓰기)
 */
import {
  Body, Controller, Delete, Get, Patch, Post, Query, UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { BarcodeIssueService } from './barcode-issue.service';
import { BarcodeReceiptService } from './barcode-receipt.service';
import { ChamberStockService } from './chamber-stock.service';
import { RecycleCheckService } from './recycle-check.service';
import { IssueManageService } from './issue-manage.service';
import { IssueReturnService } from './issue-return.service';
import { ReceiptManageService } from './receipt-manage.service';
import { ReceiptSlipService } from './receipt-slip.service';
import { SolderLabelService } from './solder-label.service';
import { SolderService } from './solder.service';
import {
  BarcodeCompareQueryDto,
  BarcodeIssueDto,
  BarcodeIssueHistoryQueryDto,
  BarcodeIssueScanDto,
  BarcodeIssueWaitingQueryDto,
  KittingBomQueryDto,
  BarcodeCompareReceiveDto,
  BarcodeReceiptHistoryQueryDto,
  BarcodeScanLookupDto,
  ChamberStockDetailQueryDto,
  ChamberStockQueryDto,
  EtcIssueCreateDto,
  EtcReceiptCreateDto,
  EtcReceiptKeyDto,
  EtcReceiptUpdateDto,
  IssueCancelDto,
  IssueHistoryQueryDto,
  IssueInventoryQueryDto,
  IssueReturnDto,
  IssueReturnLookupDto,
  IssueReturnQueryDto,
  ReceiptHistoryQueryDto,
  ReceiptInventoryQueryDto,
  ReceiptSlipBarcodeQueryDto,
  ReceiptSlipIssueDto,
  ReceiptSlipQueryDto,
  RecycleCheckQueryDto,
  SolderInputHistoryQueryDto,
  SolderLabelBarcodeQueryDto,
  SolderLabelIssueDto,
  SolderLabelSlipQueryDto,
  SolderListQueryDto,
  SolderScanDto,
  SolderStageCountQueryDto,
} from './warehouse.dto';

const DEFAULT_USER = 'ADMIN';

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

@ApiTags('자재창고 - 솔더 입출고')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/solder')
export class SolderController {
  constructor(private readonly service: SolderService) {}

  @Get('stage-counts')
  @ApiOperation({
    summary: '244 단계별 대기 수량 — 냉장고·해동중·교반중·점도대기·투입대기.'
      + ' 라인에 들어갔거나 버린 통은 세지 않는다 (PB 고정조건).'
      + ' 실측 진행중 115통 (냉장고 105 · 해동중 10).',
  })
  async stageCounts(
    @Query() query: SolderStageCountQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findStageCounts(query, organizationId));
  }

  @Get()
  @ApiOperation({
    summary: '244 솔더 통 목록. runningOnly 를 켜면 PB Running 탭과 같아진다'
      + ' (꺼냈고 아직 버리지 않은 통). 단계별 경과시간을 함께 낸다 —'
      + ' 교반시간은 PB 가 24시간을 버리던 것을 고쳤다 (실측 최대 163.2시간).',
  })
  async find(
    @Query() query: SolderListQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSolders(query, organizationId));
  }

  @Post('scan')
  @ApiOperation({
    summary: "244 입고·출고 스캔 (**쓰기**). scanType 'R' 입고 (새 통 등록) ·"
      + " 'I' 출고 (냉장고에서 꺼냄). 이미 입고된 롯트를 다시 입고하면 거절한다"
      + ' — 그 판정을 빼면 같은 통이 두 번 등록돼 단계 집계가 두 배가 된다.',
  })
  async scan(
    @Body() dto: SolderScanDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.scan(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재창고 - 솔더 라인투입이력')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/solder-input')
export class SolderInputHistoryController {
  constructor(private readonly service: SolderService) {}

  @Get()
  @ApiOperation({
    summary: '245 솔더가 어느 라인·설비에 언제 투입됐는지. 조회 전용이다 —'
      + ' PB 에 244 에서 복붙한 저장 함수가 남아 있지만 호출부가 없고'
      + ' dw.update() 도 주석 처리돼 있다 (실측).',
  })
  async find(
    @Query() query: SolderInputHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findInputHistory(query, organizationId));
  }
}

@ApiTags('자재창고 - 자재입고전표')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/receipt-slip')
export class ReceiptSlipController {
  constructor(private readonly service: ReceiptSlipService) {}

  @Get()
  @ApiOperation({
    summary: "235 입고전표 목록. PB 고정조건 RECEIPT_TYPE NOT IN ('B','T') 를 유지한다"
      + " (실측 전표 215,672건 전부 'N' 이라 지금은 아무것도 걸러내지 않는다)."
      + ' 전표마다 이미 발행된 바코드 장수를 함께 낸다 — 0 이면 아직 발행 전이다.',
  })
  async find(
    @Query() query: ReceiptSlipQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSlips(query, organizationId));
  }

  @Get('barcodes')
  @ApiOperation({
    summary: "235 고른 전표로 발행된 바코드 목록 (PB 고정조건 BARCODE_STATUS <> 'C' —"
      + ' 취소된 바코드는 뺀다).',
  })
  async barcodes(
    @Query() query: ReceiptSlipBarcodeQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSlipBarcodes(query, organizationId));
  }

  @Post('issue')
  @ApiOperation({
    summary: '235 바코드 발행 + 입고 기록 (**쓰기**). 장수·수량 규칙은 @smt/shared 가'
      + ' 갖고 있고 단위테스트로 못 박혀 있다. 채번은 PB 와 같은 Oracle 시퀀스를 쓴다.'
      + ' 전표 수량과 발행 수량 합이 다르면 거절한다 — PB 는 이 검사를 하지 않아'
      + ' 잘못 넣으면 입고 원장이 전표와 어긋났다.',
  })
  async issue(
    @Body() dto: ReceiptSlipIssueDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.issueBarcodes(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재창고 - 자재바코드입고')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/barcode-receipt')
export class BarcodeReceiptController {
  constructor(private readonly service: BarcodeReceiptService) {}

  @Get('waiting')
  @ApiOperation({
    summary: '237 입고대조 대기 목록. PB 고정조건 3개를 유지한다 —'
      + " LOT_DIVIDE_YN='N'(분할 조각 제외) · RETURN_YN='N'(반품 제외) ·"
      + " BARCODE_STATUS<>'C'(취소 제외). 빼면 대조할 수 없는 바코드가 섞인다.",
  })
  async waiting(
    @Query() query: BarcodeCompareQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findCompareWaiting(query, organizationId));
  }

  @Get('barcodes')
  @ApiOperation({
    summary: '237 바코드 전체 이력. 대기 목록과 달리 고정조건이 없어 취소·분할·반품된'
      + ' 것까지 보인다 — "왜 대기 목록에 없나" 를 여기서 확인한다.',
  })
  async barcodes(
    @Query() query: BarcodeCompareQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findBarcodeHistory(query, organizationId));
  }

  @Get('receipts')
  @ApiOperation({
    summary: '237 대조 결과로 들어간 입고 원장. IM_ITEM_RECEIPT 는 22만행/년 규모라'
      + ' 기간이 필수다.',
  })
  async receipts(
    @Query() query: BarcodeReceiptHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceiptHistory(query, organizationId));
  }

  @Get('no-receipt')
  @ApiOperation({
    summary: '237 발행됐지만 아직 입고대조되지 않은 바코드 (PB 우측 버튼).'
      + ' 협력사 바코드는 스캔 이력에서 끌어온다 — 대조 전이라 바코드 표에는 없다.',
  })
  async noReceipt(@OrganizationId() organizationId: number) {
    return paged(await this.service.findNoReceiptIssued(organizationId));
  }

  @Post('lookup')
  @ApiOperation({
    summary: '237 스캔한 바코드를 풀어 본다 (읽기 전용). 품목·롯트·수량은 PB 와 같은'
      + ' DB 함수로 뽑고, 품목 기준정보로 협력사 롯트 입력 필요 여부를 함께 낸다.'
      + ' 판정은 하지 않는다 — 실제 거절은 대조 요청에서 다시 한다.',
  })
  async lookup(
    @Body() dto: BarcodeScanLookupDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.lookupScan(dto, organizationId));
  }

  @Post('compare')
  @ApiOperation({
    summary: '237 입고대조 + 입고 기록 (**쓰기**). PB 와 달리 대조 표시를 UPDATE 조건에'
      + " 넣었다 (NVL(RECEIPT_COMPARE_YN,'N') <> 'Y') — PB 는 SELECT 로 먼저 보고"
      + ' 조건 없이 UPDATE 해서, 같은 바코드를 동시에 스캔하면 입고가 두 건 들어갔다.',
  })
  async compare(
    @Body() dto: BarcodeCompareReceiveDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.compareAndReceive(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재창고 - 솔더라벨 발행')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/solder-label')
export class SolderLabelController {
  constructor(private readonly service: SolderLabelService) {}

  @Get()
  @ApiOperation({
    summary: '243 솔더 전표 목록. 솔더 품목(ITEM_CLASS=SOLDER)만 본다.'
      + ' 이 표는 편집할 수 없다 — PB 가 dw.update() 를 부르지만 18개 컬럼이 전부'
      + ' tabsequence=32766(편집 불가)이라 바뀔 값이 없다 (실측).',
  })
  async find(
    @Query() query: SolderLabelSlipQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSlips(query, organizationId));
  }

  @Get('barcodes')
  @ApiOperation({
    summary: '243 고른 전표로 발행된 라벨 목록. 라벨 인쇄는 이 목록을 그대로 쓴다 —'
      + ' PB 리포트 DataWindow 는 같은 자료를 종이 모양으로 배치한 것뿐이다.',
  })
  async barcodes(
    @Query() query: SolderLabelBarcodeQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSlipBarcodes(query, organizationId));
  }

  @Get('context')
  @ApiOperation({
    summary: '243 발행 전 확인 (읽기 전용). 품목의 솔더 종류와 그날 이미 찍힌 마지막'
      + ' 일련번호를 낸다 — 화면이 찍힐 바코드를 미리 보여줄 때 쓴다.'
      + ' 발행은 이 값을 다시 읽어서 계산한다 (그 사이에 누가 찍었을 수 있다).',
  })
  async context(
    @Query('itemCode') itemCode: string,
    @Query('factory') factory: string,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.findIssueContext(itemCode, factory || 'A', organizationId),
    );
  }

  @Post('issue')
  @ApiOperation({
    summary: '243 전표 생성 + 솔더 라벨 발행 (**쓰기**). 입고 원장에는 넣지 않는다 —'
      + ' 입고는 237 대조 때 생긴다. 바코드는 11자 고정'
      + " (종류1+YYMMDD6+일련3+공장1). PB 가 검사만 하고 막지 않던 '하루 999장'"
      + ' 을 여기서는 거절한다. 일련번호가 시퀀스가 아니라 그날 최대값+1 이고'
      + ' 유일 인덱스가 복합이라 Oracle 이 막아 주지 않으므로, INSERT 문 안에서'
      + ' 중복을 확인하고 한 장이라도 실패하면 전체를 되돌린다.',
  })
  async issue(
    @Body() dto: SolderLabelIssueDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.issueLabels(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재창고 - 자재입고관리')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/receipt-manage')
export class ReceiptManageController {
  constructor(private readonly service: ReceiptManageService) {}

  @Get('history')
  @ApiOperation({
    summary: '253·254 입고 이력. 두 화면이 PB 에서도 같은 DataWindow 를 쓴다.'
      + " receiptType 으로 'E'(기타입고)만 볼 수 있다.",
  })
  async history(
    @Query() query: ReceiptHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findHistory(query, organizationId));
  }

  @Get('arrivals')
  @ApiOperation({
    summary: '253 입고예정 목록. **이 현장에서는 항상 비어 있다** —'
      + ' IM_ITEM_ARRIVAL 이 0행이고 그 표를 채우는 PB 창(구매발주·반품)이 쓰이지'
      + ' 않는다 (실측). 그래서 253 에는 등록 경로가 없다.',
  })
  async arrivals(
    @Query() query: ReceiptHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findArrivals(query, organizationId));
  }

  @Get('inventory')
  @ApiOperation({
    summary: '254 현재고 목록. 여기서 품목을 골라 기타입고를 만든다.'
      + ' 협력사코드는 PB 와 같이 DB 함수가 붙인다 — 재고 표에는 협력사가 없다.',
  })
  async inventory(
    @Query() query: ReceiptInventoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findInventory(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '254 기타입고 등록 (**쓰기**). **수량이 음수면 차감이다** —'
      + ' PB 가 수량 부호로 RECEIPT_DEFICIT 을 정한다.',
  })
  async create(
    @Body() dto: EtcReceiptCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createEtcReceipt(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Patch()
  @ApiOperation({
    summary: '254 기타입고 수정 (**쓰기**). 고칠 수 있는 열을 화이트리스트로 막았다 —'
      + ' 문장에 없는 열은 요청이 무엇을 보내든 바뀌지 않는다. 수량은 바꿀 수 없다'
      + " (PB DataWindow 도 편집 대상으로 두지 않는다). RECEIPT_TYPE='E' 이고"
      + ' 바코드로 만들어지지 않은 행만 대상이다.',
  })
  async update(
    @Body() dto: EtcReceiptUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.updateEtcReceipt(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({
    summary: '254 기타입고 삭제 (**쓰기**). 수정과 같은 범위 제한을 건다.',
  })
  async remove(
    @Body() dto: EtcReceiptKeyDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.deleteEtcReceipt(dto, organizationId));
  }
}

@ApiTags('자재창고 - 자재출고관리')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/issue-manage')
export class IssueManageController {
  constructor(private readonly service: IssueManageService) {}

  @Get('history')
  @ApiOperation({
    summary: '257·258 출고 이력. 두 화면이 PB 에서도 같은 DataWindow 를 쓴다.'
      + " issueStatus 로 'C'(취소된 건)만 볼 수 있다. 이 목록은 편집할 수 없다 —"
      + ' PB DataWindow 에 갱신 대상 표가 없다 (실측).',
  })
  async history(
    @Query() query: IssueHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findHistory(query, organizationId));
  }

  @Get('inventory')
  @ApiOperation({
    summary: '257 현재고 목록. 여기서 품목을 골라 출고한다. 포장 단위를 함께 내므로'
      + ' 화면이 "실제로 몇 개가 나가나" 를 미리 보여줄 수 있다.',
  })
  async inventory(
    @Query() query: IssueInventoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findInventory(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '257 기타출고 등록 (**쓰기**). 라인·공정·설비는 반드시 있어야 한다'
      + ' (PB 도 같다). **수량이 음수면 반납이다.** 포장 단위 적용은 @smt/shared 의'
      + ' 같은 함수를 화면과 서버가 함께 쓴다 — 음수 수량과 같이 쓰면 PB 가 양수를'
      + ' 내놓아 반납이 출고로 뒤집히므로 그 조합은 거절한다.',
  })
  async create(
    @Body() dto: EtcIssueCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createEtcIssue(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('cancel')
  @ApiOperation({
    summary: '258 출고취소 (**쓰기**). 원장을 지우지 않는 역분개다 — 원래 건을'
      + " 'C' 로 바꾸고 부호를 뒤집은 행을 한 건 넣는다 (구분 3↔4, 수량·금액 음수)."
      + ' 이미 공정으로 이관된 자재는 거절한다. 상태 변경을 UPDATE 조건에 넣어'
      + ' 동시에 두 번 눌러도 한 번만 취소된다.',
  })
  async cancel(
    @Body() dto: IssueCancelDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.cancelIssue(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재창고 - 출고바코드반품')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/issue-return')
export class IssueReturnController {
  constructor(private readonly service: IssueReturnService) {}

  @Get()
  @ApiOperation({
    summary: '250 반품 이력. 이 경로가 만든 마이너스 출고만 본다'
      + " (ISSUE_DEFICIT='4' · ISSUE_ACCOUNT='M001'). 로스 수량을 함께 낸다.",
  })
  async find(
    @Query() query: IssueReturnQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReturns(query, organizationId));
  }

  @Get('losses')
  @ApiOperation({
    summary: '250 로스 목록. 반품할 때 반품 수량과 실사 수량의 차이가 한 줄씩 쌓인다.'
      + ' 반품 목록에 상관 서브쿼리로 붙였더니 실측 10초가 걸려 따로 뗐다.',
  })
  async losses(
    @Query() query: IssueReturnQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findLosses(query, organizationId));
  }

  @Post('lookup')
  @ApiOperation({
    summary: '250 찍은 바코드를 풀어 본다 (읽기 전용). 지금 릴에 있는 수량과'
      + ' 마지막으로 나간 라인을 함께 낸다. 아직 라인으로 나가지 않은 바코드'
      + " (ISSUE_COMPARE_YN='N')는 반품할 수 없다고 알려 준다.",
  })
  async lookup(
    @Body() dto: IssueReturnLookupDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.lookupBarcode(dto, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '250 양산반품 (**쓰기**). 바코드 원장을 되돌리고 마이너스 출고를 넣고'
      + ' 로스를 한 줄 남긴다. **반품하면 그 바코드의 수량이 바뀐다** — 남은 수량으로'
      + ' 바코드를 다시 만든다 (PB 그대로). 반품 표시를 UPDATE 조건에 넣어 같은 릴을'
      + ' 동시에 찍어도 한 번만 반품된다.',
  })
  async submit(
    @Body() dto: IssueReturnDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.returnBarcode(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('자재창고 - 자재바코드출고')
@UseGuards(JwtAuthGuard)
@Controller('warehouse/barcode-issue')
export class BarcodeIssueController {
  constructor(private readonly service: BarcodeIssueService) {}

  @Get()
  @ApiOperation({
    summary: '238 출고 이력 (ISSUE_DEFICIT=3 — 반품은 250 화면이다).'
      + ' 이 목록은 편집할 수 없다 — PB DataWindow 에 갱신 대상 표가 없다 (실측).',
  })
  async find(
    @Query() query: BarcodeIssueHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssues(query, organizationId));
  }

  @Get('waiting')
  @ApiOperation({
    summary: '238 출고 대기 바코드 — 입고대조는 됐고 아직 라인으로 안 나간 릴.'
      + " PB 고정조건 유지: RECEIPT_COMPARE_YN='Y' · ISSUE_COMPARE_YN<>'Y' ·"
      + " BARCODE_STATUS<>'C' · LOT_DIVIDE_YN='N'.",
  })
  async waiting(
    @Query() query: BarcodeIssueWaitingQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findWaiting(query, organizationId));
  }

  @Get('kitting-bom')
  @ApiOperation({
    summary: '238 키팅 BOM — 모델에 들어가는 자재 목록. 대체품을 함께 낸다'
      + ' (대체품으로 찍어도 통과해야 한다).',
  })
  async kittingBom(
    @Query() query: KittingBomQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findKittingBom(query, organizationId));
  }

  @Get('fifo')
  @ApiOperation({
    summary: '238 FIFO 위반 후보 — 지금 찍은 릴보다 먼저 써야 하는 릴 목록.'
      + ' 거절 이유를 눈으로 확인할 수 있어야 하므로 목록으로 낸다.',
  })
  async fifo(
    @Query('itemCode') itemCode: string,
    @Query('lotNo') lotNo: string,
    @Query('inventoryType') inventoryType: string,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findFifoCandidates(
      itemCode, lotNo, inventoryType || null, organizationId,
    ));
  }

  @Post('scan')
  @ApiOperation({
    summary: '238 스캔 판정 (읽기 전용). **PB 와 같은 순서로** 검사를 쌓아 첫 거절'
      + ' 사유를 낸다 — 순서가 뜻을 정한다 (FIFO 경고는 중복 출고 거절 뒤에 와야'
      + ' 현장이 원인을 바로 읽는다). 화면과 쓰기 경로가 이 함수를 함께 쓴다.',
  })
  async scan(
    @Body() dto: BarcodeIssueScanDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.evaluateScan(dto, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '238 출고대조 + 출고 기록 (**쓰기**). 판정을 다시 해서 통과할 때만 넣는다'
      + ' — 미리 본 시점과 실제 출고 시점 사이에 FIFO·MSL 상황이 바뀔 수 있다.'
      + ' 중복 출고는 UPDATE 조건으로 막는다.',
  })
  async issue(
    @Body() dto: BarcodeIssueDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.issueBarcode(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
