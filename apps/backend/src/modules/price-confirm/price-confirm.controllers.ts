/**
 * @file src/modules/price-confirm/price-confirm.controllers.ts
 * @description 단가승인 3화면 컨트롤러
 *              PB w_mat_buy_price_confirm / w_sal_sale_price_confirm
 *                 w_mcn_mold_buy_price_confirm
 *
 * 구현은 PriceConfirmService 하나에 있고 각 컨트롤러는 자기 설정만 넘긴다.
 * 컨트롤러를 상속으로 줄이지 않고 셋을 그대로 쓴다 — NestJS 의 라우트 메타데이터는
 * 상속 체인에서 다루기 까다롭고, 이 저장소의 다른 컨트롤러도 전부 명시형이다.
 */
import { Body, Controller, Get, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PriceConfirmApplyDto, PriceConfirmQueryDto } from './price-confirm.dto';
import { PRICE_CONFIRM, PriceConfirmService } from './price-confirm.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('승인 - 구매단가승인')
@UseGuards(JwtAuthGuard)
@Controller('confirm/buy-price')
export class BuyPriceConfirmController {
  constructor(private readonly service: PriceConfirmService) {}

  @Get()
  @ApiOperation({ summary: '구매단가 승인 대상 조회 (이전단가는 DB 함수로 가져온다)' })
  async find(@Query() query: PriceConfirmQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(PRICE_CONFIRM.buy, query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Put()
  @ApiOperation({ summary: '구매단가 승인 / 승인취소 (체크한 행 일괄)' })
  async apply(
    @Body() dto: PriceConfirmApplyDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.apply(PRICE_CONFIRM.buy, dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('승인 - 판매단가승인')
@UseGuards(JwtAuthGuard)
@Controller('confirm/sale-price')
export class SalePriceConfirmController {
  constructor(private readonly service: PriceConfirmService) {}

  @Get()
  @ApiOperation({ summary: '판매단가 승인 대상 조회' })
  async find(@Query() query: PriceConfirmQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(PRICE_CONFIRM.sale, query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Put()
  @ApiOperation({ summary: '판매단가 승인 / 승인취소 (체크한 행 일괄)' })
  async apply(
    @Body() dto: PriceConfirmApplyDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.apply(PRICE_CONFIRM.sale, dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('승인 - S-PARTS구매단가승인')
@UseGuards(JwtAuthGuard)
@Controller('confirm/mold-price')
export class MoldPriceConfirmController {
  constructor(private readonly service: PriceConfirmService) {}

  @Get()
  @ApiOperation({
    summary: 'S-PARTS 구매단가 승인 대상 조회 (IMCN_MOLD_UNIT_PRICE 는 이 DB 에서 0행이다)',
  })
  async find(@Query() query: PriceConfirmQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(PRICE_CONFIRM.mold, query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Put()
  @ApiOperation({ summary: 'S-PARTS 구매단가 승인 / 승인취소 (체크한 행 일괄)' })
  async apply(
    @Body() dto: PriceConfirmApplyDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.apply(PRICE_CONFIRM.mold, dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
