/**
 * @file src/modules/oee/oee.controller.ts
 * @description OEE 입력 API — 리소스/사유 마스터, 가동일지 로드/저장.
 * 라우트(글로벌 prefix api/v1):
 *   GET/POST/PUT /oee/resource, /oee/reason
 *   GET /oee/log?resourceId=&workDate=&shift= , POST /oee/log
 */
import { Body, Controller, Get, Post, Put, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { Public } from '../../common/decorators/public.decorator';
import { OeeMasterService } from './oee-master.service';
import { OeeLogService } from './oee-log.service';
import { ResourceUpsertDto, ReasonUpsertDto, LogSaveDto } from './oee.dto';

@ApiTags('OEE')
@Public()
@Controller('oee')
export class OeeController {
  constructor(
    private readonly master: OeeMasterService,
    private readonly log: OeeLogService,
  ) {}

  @Get('resource')
  @ApiOperation({ summary: 'OEE 리소스 목록' })
  async listResources() {
    return { resources: await this.master.listResources() };
  }

  @Post('resource')
  @ApiOperation({ summary: 'OEE 리소스 신규' })
  async createResource(@Body() dto: ResourceUpsertDto) {
    await this.master.upsertResource({ ...dto, resourceId: undefined });
    return { ok: true };
  }

  @Put('resource')
  @ApiOperation({ summary: 'OEE 리소스 수정' })
  async updateResource(@Body() dto: ResourceUpsertDto) {
    await this.master.upsertResource(dto);
    return { ok: true };
  }

  @Get('reason')
  @ApiOperation({ summary: 'OEE 비가동사유 목록' })
  async listReasons() {
    return { reasons: await this.master.listReasons() };
  }

  @Post('reason')
  @ApiOperation({ summary: 'OEE 비가동사유 신규' })
  async createReason(@Body() dto: ReasonUpsertDto) {
    await this.master.upsertReason(dto, false);
    return { ok: true };
  }

  @Put('reason')
  @ApiOperation({ summary: 'OEE 비가동사유 수정' })
  async updateReason(@Body() dto: ReasonUpsertDto) {
    await this.master.upsertReason(dto, true);
    return { ok: true };
  }

  @Get('log')
  @ApiOperation({ summary: 'OEE 근무조 가동일지 로드' })
  async loadLog(
    @Query('resourceId') resourceId: string,
    @Query('workDate') workDate: string,
    @Query('shift') shift: string,
  ) {
    return { rows: await this.log.loadShift(Number(resourceId), workDate, shift) };
  }

  @Post('log')
  @ApiOperation({ summary: 'OEE 근무조 가동일지 저장(원자 replace)' })
  async saveLog(@Body() dto: LogSaveDto) {
    await this.log.saveShift(dto);
    return { ok: true };
  }
}
