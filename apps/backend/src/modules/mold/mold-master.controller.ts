import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  MoldBillQueryDto,
  MoldCodeDto,
  MoldMasterQueryDto,
  MoldMasterUpsertDto,
} from './mold-master.dto';
import { MoldMasterService } from './mold-master.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('S-PARTS관리 - S-PARTS마스터')
@UseGuards(JwtAuthGuard)
@Controller('mold/master')
export class MoldMasterController {
  constructor(private readonly service: MoldMasterService) {}

  @Get()
  @ApiOperation({ summary: 'S-PARTS 마스터 조회 (PB w_mcn_mold_master)' })
  async find(@Query() query: MoldMasterQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('bills')
  @ApiOperation({ summary: 'S-PARTS BOM(소요품목) 조회' })
  async findBills(@Query() query: MoldBillQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findBills(query, organizationId));
  }

  @Get('inventory')
  @ApiOperation({ summary: '선택 S-PARTS 의 재고(버전·SET별) 조회' })
  async findInventory(@Query() query: MoldCodeDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findInventory(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: 'S-PARTS 등록 (감사컬럼은 서버가 채운다)' })
  async create(
    @Body() dto: MoldMasterUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: 'S-PARTS 수정 (LAST_MODIFY_* 만 갱신)' })
  async update(
    @Body() dto: MoldMasterUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: 'S-PARTS 연쇄삭제 (PKG_MES_MAC.SP_MOLD_DELETE_CASCADE)' })
  async remove(@Body() dto: MoldCodeDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }

  @Post('generate-items')
  @ApiOperation({ summary: '품목 일괄생성 (PKG_MES_MAC.SP_MOLD_GENERATE_ITEM)' })
  async generateItems(
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.generateItems(organizationId, userId || DEFAULT_USER),
    );
  }
}
