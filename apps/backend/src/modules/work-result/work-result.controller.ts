// 설비별 작업 실적관리 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/work-result
import {
  Body,
  BadRequestException,
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
  ApplySensorDto,
  CancelResultDto,
  DefectSaveDto,
  DowntimeBulkDto,
  PlanDowntimeCreateDto,
  WorkResultUpsertDto,
} from './work-result.dto';
import { WorkResultService } from './work-result.service';

const MAX_LINE_CODES = 100;
const MAX_LINE_CODE_LENGTH = 20;
const MAX_WORK_RESULT_ROWS = 100;

function parseLineCodes(value: unknown): string[] | undefined {
  if (value === undefined) return undefined;
  if (typeof value !== 'string') {
    throw new BadRequestException('lineCodes must be a comma-separated string');
  }

  const codes = value.split(',').map((code) => code.trim());
  if (
    codes.length > MAX_LINE_CODES ||
    codes.some(
      (code) => code.length < 1 || code.length > MAX_LINE_CODE_LENGTH,
    )
  ) {
    throw new BadRequestException(
      `lineCodes must contain 1-${MAX_LINE_CODE_LENGTH} character codes (maximum ${MAX_LINE_CODES})`,
    );
  }

  return [...new Set(codes)];
}

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
    @Query('machineCode') machineCode?: string,
    @OrganizationId() organizationId?: number,
    @Query('excludeSmt') excludeSmt?: string,
    @Query('lineCodes') lineCodes?: string,
    @Query('workstageCode') workstageCode?: string,
  ) {
    const parsedLineCodes = parseLineCodes(lineCodes);
    const rows = await this.service.list(
      fromDate,
      toDate,
      lineCode || undefined,
      keyword || undefined,
      organizationId,
      machineCode || undefined,
      excludeSmt === 'Y',
      parsedLineCodes,
      workstageCode || undefined,
    );

    if (!parsedLineCodes) return { list: rows };
    return {
      list: rows.slice(0, MAX_WORK_RESULT_ROWS),
      truncated: rows.length > MAX_WORK_RESULT_ROWS,
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

  /** 센서 반영 재시도 — 완료인데 미반영인 실적을 다시 프로시저로 넘긴다 */
  @Post('results/apply-sensor')
  async applySensor(
    @Body() dto: ApplySensorDto,
    @OrganizationId() organizationId?: number,
  ) {
    return await this.service.applySensor(dto, organizationId);
  }

  /** 실적 취소 — 오늘 업무일 실적만. 센서 누적에서 그 수량을 뺀다 */
  @Post('results/cancel')
  async cancelResult(
    @Body() dto: CancelResultDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.cancelResult(dto, organizationId, userId);
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

  /** 설비비가동 설비 콤보 (작업지시 설비 → 공정 배치설비 → 라인 배치설비) */
  @Get('downtime-machines')
  async downtimeMachines(
    @Query('runNo') runNo: string,
    @OrganizationId() organizationId?: number,
  ) {
    return this.service.downtimeMachines(runNo, organizationId);
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

  /** OEE 비가동 입력 보드 — 공정의 라인별 비가동 대상 설비와 진행중 비가동 (한 번에) */
  @Get('downtime-board')
  async downtimeBoard(
    @Query('processCode') processCode: string,
    @OrganizationId() organizationId?: number,
  ) {
    return await this.service.downtimeBoard(processCode, organizationId);
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

  /** 설비 비가동 시작·종료 — 비가동을 쓰는 유일한 API (ADR 0002·0003) */
  @Post('downtimes/bulk')
  async bulkDowntime(
    @Body() dto: DowntimeBulkDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return await this.service.bulkDowntime(dto, organizationId, userId);
  }
}
