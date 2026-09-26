import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  EcoNotifyQueryDto,
  EcoNotifyUpdateDto,
  QcNotifyCreateDto,
  QcNotifyKeyDto,
  QcNotifyQueryDto,
  QcNotifyStatusDto,
  QcNotifyUpdateDto,
} from '../dto/qc-notify.dto';
import { QcNotifyService } from '../services/qc-notify.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('품질관리 - 품질이상발생 / 품질알림')
@UseGuards(JwtAuthGuard)
@Controller('quality/notify')
export class QcNotifyController {
  constructor(private readonly service: QcNotifyService) {}

  @Get()
  @ApiOperation({ summary: '품질이상발생 조회 (PB w_qc_notify_master)' })
  async find(@Query() query: QcNotifyQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post()
  @ApiOperation({ summary: '품질이상발생 등록 (발생일자·항번은 서버가 채운다)' })
  async create(
    @Body() dto: QcNotifyCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '품질이상발생 수정' })
  async update(
    @Body() dto: QcNotifyUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('status')
  @ApiOperation({ summary: '조치상태 변경 (완료로 바꾸면 완료일시를 찍는다)' })
  async changeStatus(
    @Body() dto: QcNotifyStatusDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.changeStatus(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '품질이상발생 삭제' })
  async remove(@Body() dto: QcNotifyKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }

  @Get('eco')
  @ApiOperation({ summary: '품질알림(ECO) 대상 품목 조회 (PB w_qc_eco_notify_master)' })
  async findEcoTargets(
    @Query() query: EcoNotifyQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findEcoTargets(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Put('eco')
  @ApiOperation({ summary: '품질알림 확인 처리 — 품목의 ECO 확인여부·설명을 바꾼다' })
  async updateEcoCheck(
    @Body() dto: EcoNotifyUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.updateEcoCheck(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}
