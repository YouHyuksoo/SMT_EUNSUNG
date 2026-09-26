import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  IqcInspectHistoryCreateDto,
  IqcInspectHistoryKeyDto,
  IqcInspectHistoryQueryDto,
  IqcInspectHistoryUpdateDto,
} from '../dto/iqc-history.dto';
import { IqcHistoryService } from '../services/iqc-history.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('품질관리 - IQC 이력등록')
@UseGuards(JwtAuthGuard)
@Controller('quality/iqc-history')
export class IqcHistoryController {
  constructor(private readonly service: IqcHistoryService) {}

  @Get()
  @ApiOperation({ summary: 'IQC 검사이력 조회 (PB w_qc_iqc_inspect_history_master)' })
  async find(
    @Query() query: IqcInspectHistoryQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post()
  @ApiOperation({ summary: '검사이력 등록 (검사일시·항번은 서버가 채운다)' })
  async create(
    @Body() dto: IqcInspectHistoryCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '검사이력 수정 (검사일시·항번은 바꿀 수 없다)' })
  async update(
    @Body() dto: IqcInspectHistoryUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '검사이력 삭제' })
  async remove(
    @Body() dto: IqcInspectHistoryKeyDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}
