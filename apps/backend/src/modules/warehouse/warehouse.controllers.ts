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
 */
import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { BarcodeReceiptService } from './barcode-receipt.service';
import { ChamberStockService } from './chamber-stock.service';
import { RecycleCheckService } from './recycle-check.service';
import { ReceiptSlipService } from './receipt-slip.service';
import { SolderService } from './solder.service';
import {
  BarcodeCompareQueryDto,
  BarcodeCompareReceiveDto,
  BarcodeReceiptHistoryQueryDto,
  BarcodeScanLookupDto,
  ChamberStockDetailQueryDto,
  ChamberStockQueryDto,
  ReceiptSlipBarcodeQueryDto,
  ReceiptSlipIssueDto,
  ReceiptSlipQueryDto,
  RecycleCheckQueryDto,
  SolderInputHistoryQueryDto,
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
