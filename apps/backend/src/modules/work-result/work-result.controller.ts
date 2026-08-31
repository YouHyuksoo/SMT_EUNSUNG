// 설비별 작업 실적관리 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/work-result
import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  OrganizationId,
  UserId,
} from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  DefectSaveDto,
  DowntimeBulkDto,
  DowntimeUpsertDto,
  PlanDowntimeCreateDto,
  WorkResultUpsertDto,
} from './work-result.dto';
import { WorkResultService } from './work-result.service';

@UseGuards(JwtAuthGuard)
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
    @OrganizationId() organizationId?: number,
  ) {
    return {
      list: await this.service.list(
        fromDate,
        toDate,
        lineCode || undefined,
        keyword || undefined,
        organizationId,
      ),
    };
  }

  /** 실적 이력 */
  @Get('results')
  async results(
    @Query('runNo') runNo: string,
    @OrganizationId() organizationId?: number,
  ) {
    return { list: await this.service.results(runNo, organizationId) };
  }

  /** 실적 상세 */
  @Get('results/:runNo/:seqNo')
  async resultDetail(
    @Param('runNo') runNo: string,
    @Param('seqNo') seqNo: string,
    @OrganizationId() organizationId?: number,
  ) {
    return await this.service.resultDetail(runNo, seqNo, organizationId);
  }

  /** 실적 신규 */
  @Post('results')
  async createResult(
    @Body() dto: WorkResultUpsertDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.upsertResult(
      { ...dto, seqNo: undefined },
      organizationId,
      userId,
    );
  }

  /** 실적 수정 */
  @Put('results')
  async updateResult(
    @Body() dto: WorkResultUpsertDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.upsertResult(dto, organizationId, userId);
  }

  /** 작업지시 대표불량 조회 */
  @Get('defect')
  async getDefect(
    @Query('runNo') runNo: string,
    @OrganizationId() organizationId?: number,
  ) {
    return { defect: await this.service.getDefect(runNo, organizationId) };
  }

  /** 작업지시 대표불량 단일 저장 (실적과 독립) */
  @Post('defect')
  async saveDefect(
    @Body() dto: DefectSaveDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    await this.service.saveDefect(
      dto.runNo,
      dto.badCode,
      dto.badQty,
      dto.remark,
      organizationId,
      userId,
    );
    return { ok: true };
  }

  /** 부적합 유형 (WQC) */
  @Get('bad-reasons')
  async badReasons(@OrganizationId() organizationId?: number) {
    return { list: await this.service.badReasons(organizationId) };
  }

  /** 후공정(PBA) 설비 콤보 */
  @Get('machines')
  async machines(@OrganizationId() organizationId?: number) {
    return { list: await this.service.machines(organizationId) };
  }

  /** 비가동 사유 (설비 연계) */
  @Get('downtime-reasons')
  async downtimeReasons(
    @Query('machineCode') machineCode: string | undefined,
    @Query('reasonType') reasonType: string | undefined,
    @OrganizationId() organizationId?: number,
  ) {
    return {
      list: await this.service.downtimeReasons(
        machineCode || undefined,
        organizationId,
        reasonType || undefined,
      ),
    };
  }

  /** 비가동 실적 목록 (설비별) + DB 현재시각 */
  @Get('downtimes')
  async downtimes(
    @Query('machineCode') machineCode: string,
    @OrganizationId() organizationId?: number,
  ) {
    return await this.service.downtimes(machineCode, organizationId);
  }

  /** 계획 비가동 일괄 등록 (일자 x 설비) */
  @Post('downtimes/plan')
  async createPlanDowntime(
    @Body() dto: PlanDowntimeCreateDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.createPlanDowntime(dto, organizationId, userId);
  }

  /** 기간 내 계획 비가동 목록 (캘린더 뱃지 + 일자별 목록) */
  @Get('downtimes/plan')
  async planDowntimes(
    @Query('from') from: string,
    @Query('to') to: string,
    @OrganizationId() organizationId?: number,
  ) {
    return { list: await this.service.planDowntimes(from, to, organizationId) };
  }

  /** 비가동 1건 삭제 (계획 비가동 취소) */
  @Delete('downtimes/:dtSeq')
  async deleteDowntime(
    @Param('dtSeq') dtSeq: string,
    @OrganizationId() organizationId?: number,
  ) {
    return await this.service.deleteDowntime(Number(dtSeq), organizationId);
  }

  /** 비가동 시작(신규) */
  @Post('downtimes')
  async createDowntime(
    @Body() dto: DowntimeUpsertDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.upsertDowntime(
      { ...dto, dtSeq: undefined },
      organizationId,
      userId,
    );
  }

  /** 비가동 종료/수정 */
  @Put('downtimes')
  async updateDowntime(
    @Body() dto: DowntimeUpsertDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.upsertDowntime(dto, organizationId, userId);
  }

  /** 라인/설비 일괄 비가동 시작·종료 (ADR 0002) */
  @Post('downtimes/bulk')
  async bulkDowntime(
    @Body() dto: DowntimeBulkDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.bulkDowntime(dto, organizationId, userId);
  }
}
