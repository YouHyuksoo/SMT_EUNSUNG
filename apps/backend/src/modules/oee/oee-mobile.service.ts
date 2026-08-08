import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, IsNull, Not, Repository } from 'typeorm';
import { ComCode } from '../../entities/com-code.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { OeeDowntimeEvent } from '../../entities/oee-downtime-event.entity';
import { Plant } from '../../entities/plant.entity';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { WorktimeRange } from '../../entities/worktime-range.entity';
import {
  OEE_MOBILE_PROCESS_CODES,
  OEE_MOBILE_RESOURCE_TYPES,
  OeeMobileEndDowntimeDto,
  OeeMobileProcessCode,
  OeeMobileReason,
  OeeMobileResource,
  OeeMobileResourceType,
  OeeMobileStartDowntimeDto,
} from './oee-mobile.dto';
import { resolveOeeMobileWorkContext } from './oee-mobile-worktime';

const SMT_LINE_CODES = [
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
];
const MACHINE_STATUS_CODE = 'MACHINE STATUS CODE';
const ASSY_PARENT_LINE_CODE = 'PROD2';

function errorText(error: unknown): string[] {
  if (error == null) return [];
  if (error instanceof Error) return [error.message];
  if (typeof error !== 'object') return [String(error)];

  const record = error as Record<string, unknown>;
  const values: string[] = [];
  for (const key of ['code', 'message']) {
    if (typeof record[key] === 'string') values.push(record[key] as string);
  }
  const driverError = record.driverError;
  if (typeof driverError === 'object' && driverError !== null) {
    const driverRecord = driverError as Record<string, unknown>;
    for (const key of ['code', 'message']) {
      if (typeof driverRecord[key] === 'string') values.push(driverRecord[key] as string);
    }
  }
  return values;
}

function isOracleUniqueViolation(error: unknown): boolean {
  return errorText(error).some((value) => value.includes('ORA-00001'));
}

@Injectable()
export class OeeMobileService {
  constructor(
    @InjectRepository(ProdLineMaster)
    private readonly lineRepository: Repository<ProdLineMaster>,
    @InjectRepository(Plant)
    private readonly plantRepository: Repository<Plant>,
    @InjectRepository(IsysUser)
    private readonly userRepository: Repository<IsysUser>,
    @InjectRepository(ComCode)
    private readonly codeRepository: Repository<ComCode>,
    @InjectRepository(OeeDowntimeEvent)
    private readonly eventRepository: Repository<OeeDowntimeEvent>,
    @InjectRepository(WorktimeRange)
    private readonly worktimeRepository: Repository<WorktimeRange>,
  ) {}

  async listResources(
    processCode: OeeMobileProcessCode,
    organizationId?: number,
    company?: string,
    plantCd?: string,
  ): Promise<OeeMobileResource[]> {
    this.assertTenant(organizationId, company, plantCd);

    if (!OEE_MOBILE_PROCESS_CODES.includes(processCode)) {
      throw new BadRequestException('지원하지 않는 OEE 모바일 공정입니다.');
    }

    if (processCode === 'SMT') {
      return this.listSmtResources(organizationId);
    }

    return this.listAssyResources(company, plantCd);
  }

  async getWorker(
    workerId: string,
    organizationId?: number,
  ): Promise<{ workerId: string; workerName: string }> {
    const organization = this.requireOrganization(organizationId);
    this.assertBoundedString(workerId, '작업자 ID', 20);
    const worker = await this.userRepository.findOne({
      where: { userId: workerId, organizationId: organization },
    });
    if (!worker) throw new NotFoundException('작업자를 찾을 수 없습니다.');

    return { workerId: worker.userId, workerName: worker.userName ?? '' };
  }

  async listReasons(organizationId?: number): Promise<OeeMobileReason[]> {
    const organization = this.requireOrganization(organizationId);
    const rows = await this.codeRepository.find({
      where: {
        groupCode: MACHINE_STATUS_CODE,
        organizationId: organization,
        detailCode: Not(In(['N', '*'])),
      },
      order: { detailCode: 'ASC' },
    });

    return rows
      .filter(
        (row) =>
          row.groupCode === MACHINE_STATUS_CODE &&
          row.organizationId === organization &&
          row.detailCode !== 'N' &&
          row.detailCode !== '*',
      )
      .sort((left, right) => left.detailCode.localeCompare(right.detailCode))
      .map((row) => ({ reasonCode: row.detailCode, reasonName: row.codeName ?? '' }));
  }

  async getStatus(
    processCode: OeeMobileProcessCode,
    resourceType: OeeMobileResourceType,
    resourceCode: string,
    parentLineCode: string,
    organizationId?: number,
    company?: string,
    plantCd?: string,
  ) {
    const organization = this.requireOrganization(organizationId);
    const resource = await this.resolveResourceContract(
      processCode,
      resourceType,
      resourceCode,
      parentLineCode,
      organization,
      company,
      plantCd,
    );
    const now = new Date();
    const context = await this.resolveCurrentWorkContext(processCode, resourceType, organization, now);
    const events = await this.findCurrentEvents(
      organization,
      processCode,
      resource.resourceType,
      resource.resourceCode,
      resource.parentLineCode ?? resource.resourceCode,
      context.workDate,
    );
    const openEvent = await this.findOpenEvent(
      organization,
      processCode,
      resource.resourceType,
      resource.resourceCode,
      resource.parentLineCode ?? resource.resourceCode,
    );

    return {
      workDate: context.workDate,
      workSegment: context.workSegment,
      state: openEvent ? ('DOWNTIME' as const) : ('RUNNING' as const),
      events,
      openEvent,
    };
  }

  async startDowntime(
    dto: OeeMobileStartDowntimeDto,
    organizationId?: number,
    company?: string,
    plantCd?: string,
    userId?: string,
  ): Promise<{ event: OeeDowntimeEvent; replayed: boolean }> {
    const organization = this.requireOrganization(organizationId);
    const executor = this.requireExecutor(userId);
    this.assertStartCommand(dto);

    const replay = await this.eventRepository.findOne({
      where: { organizationId: organization, startRequestId: dto.requestId },
    });
    if (replay) return { event: replay, replayed: true };

    const resource = await this.resolveResourceContract(
      dto.processCode,
      dto.resourceType,
      dto.resourceCode,
      dto.parentLineCode,
      organization,
      company,
      plantCd,
    );
    const worker = await this.userRepository.findOne({
      where: { userId: dto.workerId, organizationId: organization },
    });
    if (!worker) throw new NotFoundException('작업자를 찾을 수 없습니다.');

    const reason = await this.findReason(organization, dto.reasonCode);
    if (!reason) throw new NotFoundException('비가동 사유를 찾을 수 없습니다.');

    const now = new Date();
    const context = await this.resolveCurrentWorkContext(dto.processCode, dto.resourceType, organization, now);
    const normalizedParentLineCode = resource.parentLineCode ?? resource.resourceCode;
    const openEvent = await this.eventRepository.findOne({
      where: {
        organizationId: organization,
        processCode: dto.processCode,
        resourceType: resource.resourceType,
        resourceCode: resource.resourceCode,
        parentLineCode: normalizedParentLineCode,
        endTime: IsNull(),
      },
    });
    if (openEvent) throw new ConflictException('이미 열린 비가동 이벤트가 있습니다.');

    const event = this.eventRepository.create({
      organizationId: organization,
      resourceType: resource.resourceType,
      resourceCode: resource.resourceCode,
      parentLineCode: normalizedParentLineCode,
      processCode: dto.processCode,
      workDate: this.toKstMidnight(context.workDate),
      workSegment: context.workSegment,
      startTime: now,
      endTime: null,
      reasonCode: reason.detailCode,
      memo: dto.memo ?? null,
      workerId: worker.userId,
      startRequestId: dto.requestId,
      endRequestId: null,
      startedBy: executor,
      endedBy: null,
      createdDate: now,
      updatedDate: now,
    });

    try {
      const saved = await this.eventRepository.save(event);
      return { event: saved, replayed: false };
    } catch (error: unknown) {
      if (!isOracleUniqueViolation(error)) throw error;
      const requestReplay = await this.eventRepository.findOne({
        where: { organizationId: organization, startRequestId: dto.requestId },
      });
      if (requestReplay) return { event: requestReplay, replayed: true };
      throw new ConflictException('이미 처리 중이거나 열린 비가동 이벤트가 있습니다.');
    }
  }

  async endDowntime(
    dto: OeeMobileEndDowntimeDto,
    organizationId?: number,
    userId?: string,
  ): Promise<{ event: OeeDowntimeEvent; replayed: boolean }> {
    const organization = this.requireOrganization(organizationId);
    const executor = this.requireExecutor(userId);
    this.assertEndCommand(dto);

    const requestReplay = await this.eventRepository.findOne({
      where: { organizationId: organization, endRequestId: dto.requestId },
    });
    if (requestReplay) return { event: requestReplay, replayed: true };

    const event = await this.eventRepository.findOne({
      where: { organizationId: organization, eventId: dto.eventId },
    });
    if (!event) throw new NotFoundException('비가동 이벤트를 찾을 수 없습니다.');
    if (event.endTime != null) throw new ConflictException('이미 종료된 비가동 이벤트입니다.');

    const now = new Date();
    let updateResult;
    try {
      updateResult = await this.eventRepository.update(
        { eventId: dto.eventId, organizationId: organization, endTime: IsNull() },
        { endTime: now, endRequestId: dto.requestId, endedBy: executor, updatedDate: now },
      );
    } catch (error: unknown) {
      if (!isOracleUniqueViolation(error)) throw error;
      const concurrentReplay = await this.eventRepository.findOne({
        where: { organizationId: organization, endRequestId: dto.requestId },
      });
      if (concurrentReplay) return { event: concurrentReplay, replayed: true };
      throw new ConflictException('이미 처리된 비가동 종료 요청입니다.');
    }

    if (updateResult.affected !== 1) {
      const conditionalReplay = await this.eventRepository.findOne({
        where: { organizationId: organization, endRequestId: dto.requestId },
      });
      if (conditionalReplay) return { event: conditionalReplay, replayed: true };
      throw new ConflictException('비가동 이벤트가 이미 종료되었습니다.');
    }

    const updated = await this.eventRepository.findOne({
      where: { organizationId: organization, eventId: dto.eventId },
    });
    return {
      event:
        updated ??
        ({
          ...event,
          endTime: now,
          endRequestId: dto.requestId,
          endedBy: executor,
          updatedDate: now,
        } as OeeDowntimeEvent),
      replayed: false,
    };
  }

  private async listSmtResources(organizationId: number): Promise<OeeMobileResource[]> {
    const lines = await this.lineRepository.find({
      where: {
        organizationId,
        lineDivision: 'D',
        lineCode: In(SMT_LINE_CODES),
      },
      order: { lineCode: 'ASC' },
    });

    return [...lines]
      .sort((left, right) => left.lineCode.localeCompare(right.lineCode))
      .map((line) => ({
        processCode: 'SMT',
        resourceType: 'LINE',
        resourceCode: line.lineCode,
        resourceName: line.lineName,
        parentLineCode: null,
      }));
  }

  private async listAssyResources(company: string, plantCd: string): Promise<OeeMobileResource[]> {
    const cells = await this.plantRepository.find({
      where: {
        company,
        plantCd,
        plantCode: 'EUNSUNG',
        shopCode: '2F',
        lineCode: ASSY_PARENT_LINE_CODE,
        plantType: 'CELL',
        useYn: 'Y',
      },
      order: { sortOrder: 'ASC', cellCode: 'ASC' },
    });

    return [...cells]
      .sort((left, right) => {
        const sortOrderDifference = (left.sortOrder ?? 0) - (right.sortOrder ?? 0);
        return sortOrderDifference || left.cellCode.localeCompare(right.cellCode);
      })
      .map((cell) => ({
        processCode: 'ASSY',
        resourceType: 'CELL',
        resourceCode: cell.cellCode,
        resourceName: cell.plantName,
        parentLineCode: ASSY_PARENT_LINE_CODE,
      }));
  }

  private async resolveResourceContract(
    processCode: OeeMobileProcessCode,
    resourceType: OeeMobileResourceType,
    resourceCode: string,
    parentLineCode: string,
    organizationId: number,
    company?: string,
    plantCd?: string,
  ): Promise<OeeMobileResource> {
    if (!OEE_MOBILE_PROCESS_CODES.includes(processCode)) {
      throw new BadRequestException('지원하지 않는 OEE 모바일 공정입니다.');
    }
    if (!OEE_MOBILE_RESOURCE_TYPES.includes(resourceType)) {
      throw new BadRequestException('지원하지 않는 OEE 모바일 리소스 유형입니다.');
    }
    this.assertBoundedString(resourceCode, '리소스 코드', 50);
    this.assertBoundedString(parentLineCode, '상위 라인 코드', 50);

    if (processCode === 'SMT' && resourceType !== 'LINE') {
      throw new BadRequestException('SMT 공정은 LINE 리소스만 사용할 수 있습니다.');
    }
    if (processCode === 'ASSY' && resourceType !== 'CELL') {
      throw new BadRequestException('ASSY 공정은 CELL 리소스만 사용할 수 있습니다.');
    }
    if (processCode === 'ASSY' && parentLineCode !== ASSY_PARENT_LINE_CODE) {
      throw new BadRequestException('ASSY CELL의 상위 라인은 PROD2여야 합니다.');
    }

    const resources = await this.listResources(processCode, organizationId, company, plantCd);
    const found = resources.find((resource) => {
      if (resource.resourceCode !== resourceCode) return false;
      return processCode === 'SMT' || resource.parentLineCode === parentLineCode;
    });
    if (!found) throw new BadRequestException('인증 테넌트의 OEE 리소스가 아닙니다.');

    return processCode === 'SMT' ? { ...found, parentLineCode: found.resourceCode } : found;
  }

  private async findReason(organizationId: number, reasonCode: string): Promise<ComCode | null> {
    if (reasonCode === 'N' || reasonCode === '*') return null;
    const reason = await this.codeRepository.findOne({
      where: {
        groupCode: MACHINE_STATUS_CODE,
        detailCode: reasonCode,
        organizationId,
      },
    });
    if (
      !reason ||
      reason.groupCode !== MACHINE_STATUS_CODE ||
      reason.organizationId !== organizationId ||
      reason.detailCode === 'N' ||
      reason.detailCode === '*'
    ) {
      return null;
    }
    return reason;
  }

  private async resolveCurrentWorkContext(
    processCode: OeeMobileProcessCode,
    resourceType: OeeMobileResourceType,
    organizationId: number,
    serverTime: Date,
  ) {
    const rangeType = processCode === 'SMT' && resourceType === 'LINE' ? 'SMTWORKTIME' : 'WORKTIME';
    const rows = await this.worktimeRepository.find({
      where: { organizationId, rangeType },
      order: { workType: 'ASC' },
    });
    if (rows.length === 0) throw new BadRequestException('현재 업무시간 구간이 없습니다.');

    try {
      return resolveOeeMobileWorkContext(serverTime, rows);
    } catch (error: unknown) {
      if (error instanceof Error) throw new BadRequestException(error.message);
      throw error;
    }
  }

  private async findCurrentEvents(
    organizationId: number,
    processCode: OeeMobileProcessCode,
    resourceType: OeeMobileResourceType,
    resourceCode: string,
    parentLineCode: string,
    workDate: string,
  ): Promise<OeeDowntimeEvent[]> {
    return this.eventRepository.find({
      where: {
        organizationId,
        processCode,
        resourceType,
        resourceCode,
        parentLineCode,
        workDate: this.toKstMidnight(workDate),
      },
      order: { startTime: 'ASC' },
    });
  }

  private async findOpenEvent(
    organizationId: number,
    processCode: OeeMobileProcessCode,
    resourceType: OeeMobileResourceType,
    resourceCode: string,
    parentLineCode: string,
  ): Promise<OeeDowntimeEvent | null> {
    return this.eventRepository.findOne({
      where: {
        organizationId,
        processCode,
        resourceType,
        resourceCode,
        parentLineCode,
        endTime: IsNull(),
      },
    });
  }

  private requireOrganization(organizationId?: number): number {
    if (organizationId == null || !Number.isInteger(organizationId) || organizationId <= 0) {
      throw new BadRequestException('인증 조직 정보가 필요합니다.');
    }
    return organizationId;
  }

  private requireExecutor(userId?: string): string {
    this.assertBoundedString(userId, '인증 실행자 ID', 20);
    return userId;
  }

  private assertBoundedString(value: unknown, fieldName: string, maxLength: number): asserts value is string {
    if (typeof value !== 'string' || value.trim().length === 0 || value.length > maxLength) {
      throw new BadRequestException(`${fieldName}이(가) 올바르지 않습니다.`);
    }
  }

  private assertStartCommand(dto: OeeMobileStartDowntimeDto): void {
    if (dto == null || typeof dto !== 'object') throw new BadRequestException('시작 요청이 필요합니다.');
    if (!OEE_MOBILE_PROCESS_CODES.includes(dto.processCode)) {
      throw new BadRequestException('지원하지 않는 OEE 모바일 공정입니다.');
    }
    if (!OEE_MOBILE_RESOURCE_TYPES.includes(dto.resourceType)) {
      throw new BadRequestException('지원하지 않는 OEE 모바일 리소스 유형입니다.');
    }
    this.assertBoundedString(dto.resourceCode, '리소스 코드', 50);
    this.assertBoundedString(dto.parentLineCode, '상위 라인 코드', 50);
    this.assertBoundedString(dto.workerId, '작업자 ID', 20);
    this.assertBoundedString(dto.reasonCode, '비가동 사유 코드', 100);
    if (dto.reasonCode === 'N' || dto.reasonCode === '*') {
      throw new BadRequestException('정상/와일드카드 사유는 사용할 수 없습니다.');
    }
    if (dto.memo != null && (typeof dto.memo !== 'string' || dto.memo.length > 500)) {
      throw new BadRequestException('메모는 500자 이내여야 합니다.');
    }
    this.assertBoundedString(dto.requestId, '요청 ID', 64);
  }

  private assertEndCommand(dto: OeeMobileEndDowntimeDto): void {
    if (dto == null || !Number.isInteger(dto.eventId) || dto.eventId <= 0) {
      throw new BadRequestException('이벤트 ID가 올바르지 않습니다.');
    }
    this.assertBoundedString(dto.requestId, '요청 ID', 64);
  }

  private toKstMidnight(workDate: string): Date {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(workDate)) {
      throw new BadRequestException('업무일 형식이 올바르지 않습니다.');
    }
    const result = new Date(`${workDate}T00:00:00+09:00`);
    if (Number.isNaN(result.getTime())) throw new BadRequestException('업무일을 해석할 수 없습니다.');
    return result;
  }

  private assertTenant(organizationId?: number, company?: string, plantCd?: string): void {
    if (
      organizationId == null ||
      !Number.isInteger(organizationId) ||
      organizationId <= 0 ||
      !company?.trim() ||
      !plantCd?.trim()
    ) {
      throw new BadRequestException('인증 테넌트 정보가 필요합니다.');
    }
  }
}
