import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  MoldPriceGenerateDto,
  MoldPriceKeyDto,
  MoldPriceQueryDto,
  MoldPriceSupplierChangeDto,
  MoldPriceUpsertDto,
} from './mold-price.dto';
import { MoldPriceService } from './mold-price.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('S-PARTS관리 - S-PARTS구매단가')
@UseGuards(JwtAuthGuard)
@Controller('mold/price')
export class MoldPriceController {
  constructor(private readonly service: MoldPriceService) {}

  @Get()
  @ApiOperation({ summary: 'S-PARTS 구매단가 조회 (PB w_mcn_mold_buy_price_master)' })
  async find(@Query() query: MoldPriceQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post()
  @ApiOperation({ summary: '구매단가 등록 (승인여부는 N 으로 시작)' })
  async create(
    @Body() dto: MoldPriceUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '구매단가 수정 (승인 컬럼은 건드리지 않는다)' })
  async update(
    @Body() dto: MoldPriceUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '구매단가 삭제 (승인된 단가는 막는다)' })
  async remove(@Body() dto: MoldPriceKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }

  @Post('generate')
  @ApiOperation({ summary: '단가행 일괄생성 (PKG_MES_MAC.SP_MOLD_PRICE_GENERATE)' })
  async generate(
    @Body() dto: MoldPriceGenerateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.generate(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('supplier-change')
  @ApiOperation({ summary: '공급처 일괄변경 (PKG_MES_MAC.SP_MOLD_PRICE_SUPPLIER_CHANGE)' })
  async changeSupplier(
    @Body() dto: MoldPriceSupplierChangeDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.changeSupplier(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
