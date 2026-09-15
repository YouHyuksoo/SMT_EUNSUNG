import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import {
  Company,
  OrganizationId,
  Plant,
  UserId,
} from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  OeeMultiEntryEndDto,
  OeeMultiEntryStartDto,
  OeeMultiEntryStatusQueryDto,
} from './oee-multi-entry.dto';
import { OeeMultiEntryService } from './oee-multi-entry.service';

@ApiTags('OEE MULTI-ENTRY')
@UseGuards(JwtAuthGuard)
@Controller('oee/multi-entry')
export class OeeMultiEntryController {
  constructor(private readonly service: OeeMultiEntryService) {}

  @Get('status')
  @ApiOperation({ summary: 'OEE 다중입력 라인 상태·업무일 이력' })
  async getStatus(
    @Query() query: OeeMultiEntryStatusQueryDto,
    @OrganizationId() organizationId: number | undefined,
    @Company() company: string | undefined,
    @Plant() plantCd: string | undefined,
  ) {
    return this.service.getStatus(
      query.processCode,
      query.lineCode,
      organizationId,
      company,
      plantCd,
    );
  }

  @Post('start')
  @ApiOperation({ summary: 'OEE 다중입력 비가동 일괄 시작' })
  async start(
    @Body() dto: OeeMultiEntryStartDto,
    @OrganizationId() organizationId: number | undefined,
    @Company() company: string | undefined,
    @Plant() plantCd: string | undefined,
    @UserId() userId: string | undefined,
  ) {
    return this.service.start(dto, organizationId, company, plantCd, userId);
  }

  @Post('end')
  @ApiOperation({ summary: 'OEE 다중입력 비가동 일괄 종료' })
  async end(
    @Body() dto: OeeMultiEntryEndDto,
    @OrganizationId() organizationId: number | undefined,
    @Company() company: string | undefined,
    @Plant() plantCd: string | undefined,
    @UserId() userId: string | undefined,
  ) {
    return this.service.end(dto, organizationId, company, plantCd, userId);
  }
}
