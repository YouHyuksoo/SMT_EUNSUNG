import { Body, Controller, Delete, Get, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmdActualKeyDto,
  SmdActualQueryDto,
  SmdActualUpdateDto,
  SmdShiftActualQueryDto,
  SmdShiftManualDeleteDto,
  SmdShiftManualSaveDto,
} from './smd-actual.dto';
import { SmdActualService } from './smd-actual.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('생산 - 반제품생산실적관리')
@UseGuards(JwtAuthGuard)
@Controller('production/smd-actual')
export class SmdActualController {
  constructor(private readonly service: SmdActualService) {}

  @Get()
  @ApiOperation({ summary: '센서 생산실적 조회 (PB w_pln_assembly_actual_master)' })
  async find(@Query() query: SmdActualQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('summary')
  @ApiOperation({ summary: '라인·모델별 실적 합계' })
  async findSummary(
    @Query() query: SmdActualQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findSummary(query, organizationId));
  }

  @Get('shift')
  @ApiOperation({ summary: '계획별 주간·야간 실적 (자동 집계 + 수기실적, 잔량)' })
  async findShiftActual(
    @Query() query: SmdShiftActualQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findShiftActual(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Put('shift-manual')
  @ApiOperation({ summary: '주간·야간 수기실적 저장 (비운 근무조는 지워서 자동 집계로 돌린다)' })
  async saveShiftManual(
    @Body() dto: SmdShiftManualSaveDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.saveShiftManual(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('shift-manual')
  @ApiOperation({ summary: '수기실적 삭제 (근무조를 비우면 주간·야간 둘 다)' })
  async removeShiftManual(
    @Body() dto: SmdShiftManualDeleteDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.removeShiftManual(dto, organizationId));
  }

  @Put()
  @ApiOperation({ summary: '실적수량·보정수량 수정 (센서 원시값은 바꾸지 않는다)' })
  async update(
    @Body() dto: SmdActualUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '실적 한 건 삭제' })
  async remove(@Body() dto: SmdActualKeyDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId, userId || DEFAULT_USER));
  }
}
