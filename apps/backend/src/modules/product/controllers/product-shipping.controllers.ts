/**
 * @file src/modules/product/controllers/product-shipping.controllers.ts
 * @description 출하현황(M_SHIPPING) 컨트롤러.
 *
 *   /product/pack       299 제품포장관리(PID) · 311 제품패킹이력 (쓰기)
 *   /product/fg         302 입고(PID) · 304 입고(모델단위) ·
 *                       307 출하 · 308 출고(모델단위) (쓰기)
 */
import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../../shared/row-limit';
import {
  FgIssuableQueryDto,
  FgIssueDto,
  FgIssueQueryDto,
  FgModelIssueDto,
  FgModelReceiptDto,
  FgReceiptDto,
  FgReceiptQueryDto,
} from '../dto/product-fg.dto';
import {
  PackCompleteDto,
  PackCreateDto,
  PackHistoryQueryDto,
  PackQueryDto,
  PackScanDto,
  PackSerialQueryDto,
} from '../dto/product-pack.dto';
import { ProductFgService } from '../services/product-fg.service';
import { ProductPackService } from '../services/product-pack.service';

/** 로그인 정보가 없는 호출에 남기는 표시. 원장에 빈 작성자를 남기지 않는다. */
const DEFAULT_USER = 'SYSTEM';

const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('출하현황 - 제품포장')
@UseGuards(JwtAuthGuard)
@Controller('product/pack')
export class ProductPackController {
  constructor(private readonly service: ProductPackService) {}

  @Get()
  @ApiOperation({
    summary: '299 박스 목록. PB 와 같이 분할된 박스(DIVIDE_FLAG=Y)는 빼고 본다.',
  })
  async find(
    @Query() query: PackQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findPacks(query, organizationId));
  }

  @Get('serials')
  @ApiOperation({ summary: '299 박스 하나에 담긴 PID 목록.' })
  async serials(
    @Query() query: PackSerialQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSerials(query, organizationId));
  }

  @Get('history')
  @ApiOperation({
    summary: '311 제품패킹이력 — 어느 PID 가 어느 박스에 들어갔는지. 표가 950만'
      + ' 건이라 PID 나 박스 바코드 중 하나는 반드시 받는다.',
  })
  async history(
    @Query() query: PackHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findPackHistory(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '299 박스 바코드 생성 (**쓰기**). 번호는 DB 함수'
      + ' F_GET_CREATE_CELLBIZ_BARCODE 가 만든다. 그 안의 프로시저가'
      + ' AUTONOMOUS_TRANSACTION 이라 **만든 박스는 즉시 확정된다** (PB 와 같다).',
  })
  async create(
    @Body() dto: PackCreateDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.createPack(dto, organizationId));
  }

  @Post('scan')
  @ApiOperation({
    summary: '299 PID 한 건을 박스에 담는다 (**쓰기**). 2D바코드의 BOX_NO 와'
      + ' 패킹행·박스수량이 한 트랜잭션에서 같이 움직인다. 이미 담긴 PID 는 거절한다.',
  })
  async scan(
    @Body() dto: PackScanDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.scanPid(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('unpack')
  @ApiOperation({
    summary: '299 잘못 담은 PID 를 뺀다 (**쓰기**). 포장완료·입고된 박스는'
      + ' 건드리지 않는다 (PB 는 막지 않았다).',
  })
  async unpack(
    @Body() dto: PackScanDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.unpackPid(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('complete')
  @ApiOperation({
    summary: '299 포장완료 (**쓰기**). 수량을 실제 담긴 개수로 다시 세어 넣는다.',
  })
  async complete(
    @Body() dto: PackCompleteDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.completePack(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('reprint')
  @ApiOperation({
    summary: '299 재출력 횟수를 올린다 (**쓰기**). 인쇄 자체는 옮기지 않았다.',
  })
  async reprint(
    @Body() dto: PackCompleteDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.markReprint(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({
    summary: '299 빈 박스를 지운다 (**쓰기**). 박스 바코드는 즉시 확정되므로'
      + ' 만들고 담지 않으면 빈 박스가 남는다. 담긴 PID 가 있으면 지우지 않는다.',
  })
  async remove(
    @Body() dto: PackCompleteDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.deleteEmptyPack(dto, organizationId));
  }
}

@ApiTags('출하현황 - 제품입고·출하')
@UseGuards(JwtAuthGuard)
@Controller('product/fg')
export class ProductFgController {
  constructor(private readonly service: ProductFgService) {}

  @Get('receipts')
  @ApiOperation({ summary: '302·304 제품입고 이력. 취소분은 수량이 음수로 나온다.' })
  async receipts(
    @Query() query: FgReceiptQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findReceipts(query, organizationId));
  }

  @Get('issues')
  @ApiOperation({ summary: '307·308 제품출하 이력. 취소분은 수량이 음수로 나온다.' })
  async issues(
    @Query() query: FgIssueQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssues(query, organizationId));
  }

  @Get('issues/summary')
  @ApiOperation({ summary: '307 고객별 출하 요약.' })
  async issueSummary(
    @Query() query: FgIssueQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssueSummary(query, organizationId));
  }

  @Get('issuable')
  @ApiOperation({
    summary: '307 출하할 수 있는 제품재고. PB 고정조건(파렛트 미적재 · 제품창고 P01)을'
      + ' 그대로 둔다.',
  })
  async issuable(
    @Query() query: FgIssuableQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssuable(query, organizationId));
  }

  @Post('receipt')
  @ApiOperation({
    summary: '302 박스 입고 / 입고취소 (**쓰기**). DB 프로시저'
      + ' P_PRODUCT_FG_RECEIPT 를 그대로 부른다 (p_txn 1=입고 2=취소).'
      + ' p_commit 에 N 을 넘겨 트랜잭션은 웹이 쥔다.',
  })
  async receipt(
    @Body() dto: FgReceiptDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.receipt(dto, organizationId));
  }

  @Post('model-receipt')
  @ApiOperation({
    summary: '304 모델단위 입고 / 취소 (**쓰기**). P_PRODUCT_FG_MODEL_RECEIPT.',
  })
  async modelReceipt(
    @Body() dto: FgModelReceiptDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.modelReceipt(dto, organizationId));
  }

  @Post('issue')
  @ApiOperation({
    summary: '307 박스 출하 / 출하취소 (**쓰기**). P_PRODUCT_FG_ISSUE'
      + ' (p_txn 3=출하 4=취소).',
  })
  async issue(
    @Body() dto: FgIssueDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.issue(dto, organizationId));
  }

  @Post('model-issue')
  @ApiOperation({
    summary: '308 모델단위 출고 / 취소 (**쓰기**). P_PRODUCT_FG_MODEL_ISSUE.',
  })
  async modelIssue(
    @Body() dto: FgModelIssueDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.modelIssue(dto, organizationId));
  }
}
