// 설비별 작업 실적관리 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/work-result
import { Body, Controller, Get, Param, Post, Put, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { DefectSaveDto, DowntimeBulkDto, DowntimeUpsertDto, WorkResultUpsertDto } from './work-result.dto';
import { WorkResultService } from './work-result.service';

@Public()
@Controller('oee/work-result')
export class WorkResultController {
  constructor(private readonly service: WorkResultService) {}

  /** 작업지시 목록 */
  @Get()
  async list(
    @Query('fromDate') fromDate: string,
    @Query('toDate') toDate: string,
    @Query('lineCode') lineCode?: string,
    @Query('keyword') keyword?: string,
  ) {
    return { list: await this.service.list(fromDate, toDate, lineCode || undefined, keyword || undefined) };
  }

  /** 실적 이력 */
  @Get('results')
  async results(@Query('runNo') runNo: string) {
    return { list: await this.service.results(runNo) };
  }

  /** 실적 상세 */
  @Get('results/:runNo/:seqNo')
  async resultDetail(@Param('runNo') runNo: string, @Param('seqNo') seqNo: string) {
    return await this.service.resultDetail(runNo, seqNo);
  }

  /** 실적 신규 */
  @Post('results')
  async createResult(@Body() dto: WorkResultUpsertDto) {
    return await this.service.upsertResult({ ...dto, seqNo: undefined });
  }

  /** 실적 수정 */
  @Put('results')
  async updateResult(@Body() dto: WorkResultUpsertDto) {
    return await this.service.upsertResult(dto);
  }

  /** 작업지시 대표불량 조회 */
  @Get('defect')
  async getDefect(@Query('runNo') runNo: string) {
    return { defect: await this.service.getDefect(runNo) };
  }

  /** 작업지시 대표불량 단일 저장 (실적과 독립) */
  @Post('defect')
  async saveDefect(@Body() dto: DefectSaveDto) {
    await this.service.saveDefect(dto.runNo, dto.badCode, dto.badQty, dto.remark, dto.userId);
    return { ok: true };
  }

  /** 부적합 유형 (WQC) */
  @Get('bad-reasons')
  async badReasons() {
    return { list: await this.service.badReasons() };
  }

  /** 후공정(PBA) 설비 콤보 */
  @Get('machines')
  async machines() {
    return { list: await this.service.machines() };
  }

  /** 비가동 사유 (설비 연계) */
  @Get('downtime-reasons')
  async downtimeReasons(@Query('machineCode') machineCode?: string) {
    return { list: await this.service.downtimeReasons(machineCode || undefined) };
  }

  /** 비가동 실적 목록 (설비별) + DB 현재시각 */
  @Get('downtimes')
  async downtimes(@Query('machineCode') machineCode: string) {
    return await this.service.downtimes(machineCode);
  }

  /** 비가동 시작(신규) */
  @Post('downtimes')
  async createDowntime(@Body() dto: DowntimeUpsertDto) {
    return await this.service.upsertDowntime({ ...dto, dtSeq: undefined });
  }

  /** 비가동 종료/수정 */
  @Put('downtimes')
  async updateDowntime(@Body() dto: DowntimeUpsertDto) {
    return await this.service.upsertDowntime(dto);
  }

  /** 라인/설비 일괄 비가동 시작·종료 */
  @Post('downtimes/bulk')
  async bulkDowntime(@Body() dto: DowntimeBulkDto) {
    return await this.service.bulkDowntime(dto);
  }
}
