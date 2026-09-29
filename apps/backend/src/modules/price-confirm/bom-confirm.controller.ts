import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  BomConfirmApplyDto,
  BomConfirmClearDto,
  BomConfirmQueryDto,
} from './bom-confirm.dto';
import { BomConfirmService } from './bom-confirm.service';

@ApiTags('승인 - 설계BOM승인')
@UseGuards(JwtAuthGuard)
@Controller('confirm/bom')
export class BomConfirmController {
  constructor(private readonly service: BomConfirmService) {}

  @Get('work-numbers')
  @ApiOperation({ summary: '작업번호 목록 (PB ddlb_work_no). SET 품목·새 BOM 행수를 함께 낸다' })
  async findWorkNumbers(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findWorkNumbers(organizationId));
  }

  @Get()
  @ApiOperation({
    summary: '작업공간 BOM 조회 (ID_ENG_BOM_WORKSPACE 는 이 DB 에서 0행이다)',
  })
  async find(@Query() query: BomConfirmQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Post('apply')
  @ApiOperation({
    summary: 'BOM 반영 (PKG_DESIGN.BOM_TRANSLATION). NEW_BOM_YN=Y 행이 없으면 거부',
  })
  async apply(@Body() dto: BomConfirmApplyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.apply(dto, organizationId));
  }

  @Delete()
  @ApiOperation({ summary: '작업공간 비우기 (작업번호 단위 전체 삭제, 되돌릴 수 없다)' })
  async clear(@Body() dto: BomConfirmClearDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.clear(dto, organizationId));
  }
}
