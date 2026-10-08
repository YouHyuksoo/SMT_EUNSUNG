/**
 * @file src/modules/inventory-query/inventory-query.controllers.ts
 * @description 재고(M_INVENTORY) 컨트롤러
 *
 *   /inventory-query/total        269 총재고조회
 *   /inventory-query/close        271 자재재고마감 (원자재 월마감 — 월총평균법, 쓰기)
 *   /inventory-query/check        272 자재재고실사 (조정 — 쓰기)
 *   /inventory-query/barcode      274 자재바코드스캔실사 (조회)
 *   /inventory-query/stocktake    바코드 실사 시작 · 스캔 · 일괄 조정 (272·274·PDA, 쓰기)
 *   /inventory-query/wip-stocktake 공정 실사 시작 · 입력 · 엑셀 · 일괄 조정 (쓰기)
 *   /inventory-query/fg-stocktake  제품 실사 시작 · 박스 스캔 · 엑셀 · 일괄 조정 (쓰기)
 *   /inventory-query/fg-close      제품 재고마감 (모델 단위 월마감 — 수량, 쓰기)
 */
import {
  BadRequestException, Body, Controller, Get, Post, Query, UploadedFile, UseGuards, UseInterceptors,
} from '@nestjs/common';
import { ApiConsumes, ApiOperation, ApiTags } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { memoryStorage } from 'multer';
import { Request } from 'express';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import { InventoryCheckService } from './inventory-check.service';
import { InventoryCloseService } from './inventory-close.service';
import { StocktakeService } from './stocktake.service';
import { parseStocktakeWorkbook } from './stocktake-excel';
import { WipStocktakeService } from './wip-stocktake.service';
import { FgStocktakeService } from './fg-stocktake.service';
import { FgCloseService } from './fg-close.service';
import { WipCloseService } from './wip-close.service';
import { CloseDateService } from './close-date.service';
import { TotalInventoryService } from './total-inventory.service';
import {
  BarcodeCheckQueryDto,
  InventoryAdjustDto,
  InventoryCheckQueryDto,
  InventoryCloseMonthDto,
  StocktakeCancelDto,
  StocktakeScanDto,
  StocktakeStartDto,
  WipStocktakeCountDto,
  CloseDateGenerateDto,
  CloseDateSaveDto,
  CloseDateYearDto,
  FgStocktakeCountDto,
  FgStocktakeListDto,
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

  @Get('status')
  @ApiOperation({ summary: '271 마감 상태 — 마감 여부, 마지막 마감월, 기초 출처, 마감·취소 가능 여부와 이유.' })
  async status(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.status(query.yyyymm, organizationId));
  }

  @Get('preview')
  @ApiOperation({
    summary: '271 원자재 월마감 계산 (읽기). 저장하지 않는다. 마감한 달이면 저장된 결과를 준다.'
      + ' 월평균단가 = (기초금액 + 입고금액) ÷ (기초수량 + 입고수량), 출고·기말은 그 단가로 평가.',
  })
  async preview(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.preview(query.yyyymm, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '271 원자재 월마감 (**쓰기**). 계산 결과를 IM_ITEM_INVENTORY_CLOSE 에 그 달만 갈아끼우고'
      + ' ISYS_INVENTORY_CLOSE_DATE 에 마감으로 남긴다. 첫 마감이거나 마지막 마감월의 다음 달, 그 달이 끝난 뒤만.',
  })
  async close(
    @Body() dto: InventoryCloseMonthDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(await this.service.close(dto.yyyymm, organizationId, userId || DEFAULT_USER));
  }

  @Post('cancel')
  @ApiOperation({ summary: '271 마감 취소 (**쓰기**). 마지막 마감월만 — 그 달 마감 결과를 지우고 미마감으로 돌린다.' })
  async cancel(
    @Body() dto: InventoryCloseMonthDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(await this.service.cancel(dto.yyyymm, organizationId, userId || DEFAULT_USER));
  }
}

@ApiTags('재고 - 자재재고실사')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/check')
export class InventoryCheckController {
  constructor(private readonly service: InventoryCheckService) {}

  @Get()
  @ApiOperation({
    summary: '272 실사표 (장부수량 · 실사수량 · 차이 · 이미 넣은 조정). 차이 있는 롯트가 먼저 나온다.',
  })
  async find(
    @Query() query: InventoryCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findCheckList(query, organizationId));
  }

  @Get('adjust-history')
  @ApiOperation({
    summary: '272 조정 이력 (계정 M009 인 출고만).',
  })
  async adjustHistory(
    @Query() query: InventoryCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findAdjustHistory(query, organizationId));
  }

  @Post('adjust')
  @ApiOperation({
    summary: '272 한 롯트 재고 조정 (**쓰기**). 차이 = 실사 − 장부 (적으면 구분 3 · 많으면 구분 4).'
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
    summary: '274 바코드 실사 스캔 기록. 스캔은 /inventory-query/stocktake/scan 이 한다.',
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

@ApiTags('재고 - 바코드 실사')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/stocktake')
export class StocktakeController {
  constructor(private readonly service: StocktakeService) {}

  @Get('active')
  @ApiOperation({ summary: '진행 중인 실사 (마감 안 된 가장 최근 실사월과 진행 현황). 없으면 null.' })
  async active(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.active(organizationId));
  }

  @Post('start')
  @ApiOperation({ summary: '실사 시작 (**쓰기**) — 지금 장부(재고 ≠ 0 롯트)를 실사표에 고정한다.' })
  async start(
    @Body() dto: StocktakeStartDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.start(dto.yyyymm, Boolean(dto.regenerate), organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('scan')
  @ApiOperation({ summary: '바코드 스캔 (**쓰기**) — 그 롯트의 실사수량을 바코드 수량(또는 입력 수량)으로 채운다.' })
  async scan(
    @Body() dto: StocktakeScanDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.scan(dto.barcode, dto.qty, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('upload')
  @ApiOperation({
    summary: '실사 엑셀 업로드 (**쓰기**) — 첫 시트의 바코드(또는 롯트번호)·수량 열을 한꺼번에 스캔한다.'
      + ' 이미 찍은 롯트는 엑셀 수량으로 고친다. 반영 못 한 줄은 줄 번호와 사유로 돌려준다.',
  })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file', {
    storage: memoryStorage(),
    limits: { fileSize: 10 * 1024 * 1024 },
    fileFilter: (_req: Request, file: Express.Multer.File, callback: (error: Error | null, accept: boolean) => void) => {
      if (!/\.(xlsx|xls|csv)$/i.test(file.originalname)) {
        return callback(new BadRequestException('.xlsx · .xls · .csv 파일만 올릴 수 있습니다.'), false);
      }
      callback(null, true);
    },
  }))
  async upload(
    @UploadedFile() file: Express.Multer.File,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    if (!file) throw new BadRequestException('파일이 필요합니다.');
    const rows = parseStocktakeWorkbook(file.buffer);
    return ResponseUtil.success(await this.service.upload(rows, organizationId, userId || DEFAULT_USER));
  }

  @Post('scan/cancel')
  @ApiOperation({ summary: '스캔 취소 (**쓰기**).' })
  async cancel(
    @Body() dto: StocktakeCancelDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.cancelScan(dto.barcode, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('adjust-all')
  @ApiOperation({ summary: '일괄 조정 (**쓰기**) — 실사표 차이에서 이미 넣은 조정을 뺀 만큼 M009 로 넣는다.' })
  async adjustAll(
    @Body() dto: InventoryCloseMonthDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.adjustAll(dto.yyyymm, organizationId, userId || DEFAULT_USER),
    );
  }
}

const excelUpload = () => FileInterceptor('file', {
  storage: memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (_req: Request, file: Express.Multer.File, callback: (error: Error | null, accept: boolean) => void) => {
    if (!/.(xlsx|xls|csv)$/i.test(file.originalname)) {
      return callback(new BadRequestException('.xlsx · .xls · .csv 파일만 올릴 수 있습니다.'), false);
    }
    callback(null, true);
  },
});

@ApiTags('재고 - 공정 실사')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/wip-stocktake')
export class WipStocktakeController {
  constructor(private readonly service: WipStocktakeService) {}

  @Get('active')
  @ApiOperation({ summary: '진행 중인 공정 실사 (가장 최근 실사월과 진행 현황). 없으면 null.' })
  async active(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.active(organizationId));
  }

  @Get()
  @ApiOperation({ summary: '공정 실사표 (품목별 장부 · 실사 · 차이 · 이미 넣은 조정).' })
  async list(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.list(query.yyyymm, organizationId));
  }

  @Get('entries')
  @ApiOperation({ summary: '공정 실사 입력 기록 (롯트·품목 입력 한 건씩).' })
  async entries(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.entries(query.yyyymm, organizationId));
  }

  @Post('start')
  @ApiOperation({ summary: '공정 실사 시작 (**쓰기**) — 지금 공정재고(품목 단위)를 실사표에 고정한다.' })
  async start(@Body() dto: StocktakeStartDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(
      await this.service.start(dto.yyyymm, Boolean(dto.regenerate), organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('count')
  @ApiOperation({ summary: '공정 실사 입력 한 건 (**쓰기**) — 바코드나 품목코드·수량. 이미 센 롯트는 거절한다.' })
  async count(@Body() dto: WipStocktakeCountDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.record([dto], 'scan', organizationId, userId || DEFAULT_USER));
  }

  @Post('count/cancel')
  @ApiOperation({ summary: '공정 실사 입력 취소 (**쓰기**).' })
  async cancel(@Body() dto: WipStocktakeCountDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.cancel(dto, organizationId, userId || DEFAULT_USER));
  }

  @Post('upload')
  @ApiOperation({
    summary: '공정 실사 엑셀 업로드 (**쓰기**) — 바코드·롯트번호·품목코드 중 하나와 수량·라인 열.'
      + ' 이미 넣은 롯트·품목은 엑셀 수량으로 고친다.',
  })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(excelUpload())
  async upload(
    @UploadedFile() file: Express.Multer.File,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    if (!file) throw new BadRequestException('파일이 필요합니다.');
    const rows = parseStocktakeWorkbook(file.buffer, { itemOnly: true });
    return ResponseUtil.success(await this.service.record(rows, 'upload', organizationId, userId || DEFAULT_USER));
  }

  @Post('adjust-all')
  @ApiOperation({ summary: '공정 실사 일괄 조정 (**쓰기**) — 품목별 차이에서 이미 넣은 조정을 뺀 만큼 공정출고로 넣는다.' })
  async adjustAll(@Body() dto: InventoryCloseMonthDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.adjustAll(dto.yyyymm, organizationId, userId || DEFAULT_USER));
  }
}

@ApiTags('재고 - 제품 실사')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/fg-stocktake')
export class FgStocktakeController {
  constructor(private readonly service: FgStocktakeService) {}

  @Get('active')
  @ApiOperation({ summary: '진행 중인 제품 실사 (가장 최근 실사월과 진행 현황). 없으면 null.' })
  async active(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.active(organizationId));
  }

  @Get()
  @ApiOperation({ summary: '제품 실사표 (박스별 장부 · 실사 · 차이 · 이미 넣은 조정). 차이 있는 박스가 먼저.' })
  async list(@Query() query: FgStocktakeListDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.list(query.yyyymm, query, organizationId));
  }

  @Post('start')
  @ApiOperation({ summary: '제품 실사 시작 (**쓰기**) — 지금 제품재고(수량 ≠ 0)를 박스 단위로 실사표에 고정한다.' })
  async start(@Body() dto: StocktakeStartDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(
      await this.service.start(dto.yyyymm, Boolean(dto.regenerate), organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('scan')
  @ApiOperation({ summary: '제품 실사 스캔 한 건 (**쓰기**) — 박스 바코드. 이미 센 박스는 거절한다.' })
  async scan(@Body() dto: FgStocktakeCountDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.record([dto], 'scan', organizationId, userId || DEFAULT_USER));
  }

  @Post('scan/cancel')
  @ApiOperation({ summary: '제품 실사 스캔 취소 (**쓰기**).' })
  async cancel(@Body() dto: FgStocktakeCountDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.cancel(dto, organizationId, userId || DEFAULT_USER));
  }

  @Post('upload')
  @ApiOperation({
    summary: '제품 실사 엑셀 업로드 (**쓰기**) — 박스 바코드 열과 선택 수량 열. 이미 센 박스는 엑셀 수량으로 고친다.',
  })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(excelUpload())
  async upload(
    @UploadedFile() file: Express.Multer.File,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    if (!file) throw new BadRequestException('파일이 필요합니다.');
    const rows = parseStocktakeWorkbook(file.buffer);
    return ResponseUtil.success(await this.service.record(rows, 'upload', organizationId, userId || DEFAULT_USER));
  }

  @Post('adjust-all')
  @ApiOperation({
    summary: '제품 실사 일괄 조정 (**쓰기**) — 박스별 (실사 − 장부 − 이미 넣은 조정)을 재고에 더하고'
      + ' IP_PRODUCT_FG_ADJUST 에 남긴다. 입고·출고 표는 건드리지 않는다.',
  })
  async adjustAll(@Body() dto: InventoryCloseMonthDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.adjustAll(dto.yyyymm, organizationId, userId || DEFAULT_USER));
  }
}

@ApiTags('재고 - 제품재고마감')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/fg-close')
export class FgCloseController {
  constructor(private readonly service: FgCloseService) {}

  @Get('status')
  @ApiOperation({ summary: '제품 마감 상태 — 마감 여부, 마지막 마감월, 기초 출처, 마감·취소 가능 여부와 이유.' })
  async status(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.status(query.yyyymm, organizationId));
  }

  @Get('preview')
  @ApiOperation({ summary: '제품 월마감 계산 (읽기). 기초 + 입고 − 출고 + 조정 = 기말 (모델 단위, 수량). 저장하지 않는다.' })
  async preview(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.preview(query.yyyymm, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '제품 월마감 (**쓰기**). IP_PRODUCT_FG_INV_CLOSE 에 그 달만 갈아끼우고 마감으로 남긴다.' })
  async close(@Body() dto: InventoryCloseMonthDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.close(dto.yyyymm, organizationId, userId || DEFAULT_USER));
  }

  @Post('cancel')
  @ApiOperation({ summary: '제품 마감 취소 (**쓰기**). 마지막 마감월만.' })
  async cancel(@Body() dto: InventoryCloseMonthDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.cancel(dto.yyyymm, organizationId, userId || DEFAULT_USER));
  }
}

@ApiTags('재고 - 공정재고마감')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/wip-close')
export class WipCloseController {
  constructor(private readonly service: WipCloseService) {}

  @Get('status')
  @ApiOperation({ summary: '공정 마감 상태 — 마감 여부, 마지막 마감월, 기초 출처, 원자재 마감 여부, 마감·취소 가능 여부와 이유.' })
  async status(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.status(query.yyyymm, organizationId));
  }

  @Get('preview')
  @ApiOperation({
    summary: '공정 월마감 계산 (읽기). 기초 + 입고 − 출고 = 기말 (품목 단위). 단가는 그 달 원자재 마감 월평균단가. 저장하지 않는다.',
  })
  async preview(@Query() query: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.preview(query.yyyymm, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '공정 월마감 (**쓰기**). IM_ITEM_WORKSTAGE_INV_CLOSE 에 그 달만 갈아끼운다. 원자재 마감을 먼저 해야 한다.' })
  async close(@Body() dto: InventoryCloseMonthDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.close(dto.yyyymm, organizationId, userId || DEFAULT_USER));
  }

  @Post('cancel')
  @ApiOperation({ summary: '공정 마감 취소 (**쓰기**). 마지막 마감월만.' })
  async cancel(@Body() dto: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.cancel(dto.yyyymm, organizationId));
  }
}

@ApiTags('재고 - 재고마감일자')
@UseGuards(JwtAuthGuard)
@Controller('inventory-query/close-date')
export class CloseDateController {
  constructor(private readonly service: CloseDateService) {}

  @Get()
  @ApiOperation({ summary: '재고마감일자 — 그 해 12개월의 마감 시작일·종료일과 자재·제품·공정 마감 현황. 등록이 없는 달은 달력 월.' })
  async list(@Query() query: CloseDateYearDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.list(query.year, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '재고마감일자 한 달 저장 (**쓰기**). 이웃한 달과 이어져야 하고, 마감한 달은 바꿀 수 없다.' })
  async save(@Body() dto: CloseDateSaveDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(
      await this.service.save(dto.yyyymm, dto.startDate, dto.endDate, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('delete')
  @ApiOperation({ summary: '재고마감일자 등록 삭제 (**쓰기**). 그 달은 달력 월로 돌아간다. 마감한 달은 지울 수 없다.' })
  async remove(@Body() dto: InventoryCloseMonthDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto.yyyymm, organizationId));
  }

  @Post('generate')
  @ApiOperation({ summary: '재고마감일자 연간 생성 (**쓰기**). 시작일 1 = 달력 월, N = 전달 N일 ~ 이번 달 N−1일. 마감한 달이 있는 해는 거절.' })
  async generate(@Body() dto: CloseDateGenerateDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.generate(dto.year, dto.startDay, organizationId, userId || DEFAULT_USER));
  }
}
