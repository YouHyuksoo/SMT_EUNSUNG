import { Body, Controller, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { Company, OrganizationId, Plant, UserId } from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  OeeMobileEndDowntimeDto,
  OeeMobileReasonsQueryDto,
  OeeMobileResourcesQueryDto,
  OeeMobileStartDowntimeDto,
  OeeMobileStatusQueryDto,
} from './oee-mobile.dto';
import { OeeMobileService } from './oee-mobile.service';

@ApiTags('OEE MOBILE')
@UseGuards(JwtAuthGuard)
@Controller('oee/mobile')
export class OeeMobileController {
  constructor(private readonly service: OeeMobileService) {}

  @Get('resources')
  @ApiOperation({ summary: 'OEE 모바일 공정별 리소스 목록' })
  async listResources(
    @Query() query: OeeMobileResourcesQueryDto,
    @OrganizationId() organizationId: number | undefined,
    @Company() company: string | undefined,
    @Plant() plantCd: string | undefined,
  ) {
    return {
      resources: await this.service.listResources(query.processCode, organizationId, company, plantCd),
    };
  }

  @Get('workers/:workerId')
  @ApiOperation({ summary: 'OEE 모바일 작업자 확인' })
  async getWorker(
    @Param('workerId') workerId: string,
    @OrganizationId() organizationId: number | undefined,
  ) {
    return this.service.getWorker(workerId, organizationId);
  }

  @Get('reasons')
  @ApiOperation({ summary: 'OEE 모바일 비가동 사유 목록' })
  async listReasons(
    @Query() _query: OeeMobileReasonsQueryDto,
    @OrganizationId() organizationId: number | undefined,
  ) {
    return { reasons: await this.service.listReasons(organizationId) };
  }

  @Get('status')
  @ApiOperation({ summary: 'OEE 모바일 현재 상태·업무일 이력' })
  async getStatus(
    @Query() query: OeeMobileStatusQueryDto,
    @OrganizationId() organizationId: number | undefined,
    @Company() company: string | undefined,
    @Plant() plantCd: string | undefined,
  ) {
    return this.service.getStatus(
      query.processCode,
      query.resourceType,
      query.resourceCode,
      query.parentLineCode,
      organizationId,
      company,
      plantCd,
    );
  }

  @Post('downtime/start')
  @ApiOperation({ summary: 'OEE 모바일 비가동 시작' })
  async startDowntime(
    @Body() dto: OeeMobileStartDowntimeDto,
    @OrganizationId() organizationId: number | undefined,
    @Company() company: string | undefined,
    @Plant() plantCd: string | undefined,
    @UserId() userId: string | undefined,
  ) {
    return this.service.startDowntime(dto, organizationId, company, plantCd, userId);
  }

  @Post('downtime/end')
  @ApiOperation({ summary: 'OEE 모바일 비가동 종료' })
  async endDowntime(
    @Body() dto: OeeMobileEndDowntimeDto,
    @OrganizationId() organizationId: number | undefined,
    @UserId() userId: string | undefined,
  ) {
    return this.service.endDowntime(dto, organizationId, userId);
  }
}
