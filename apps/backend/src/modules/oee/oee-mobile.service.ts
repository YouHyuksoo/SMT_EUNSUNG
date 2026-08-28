import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, IsNull, Not, Repository } from 'typeorm';
import { EquipDowntimeReason } from '../../entities/equip-downtime-reason.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { OeeDowntimeEvent } from '../../entities/oee-downtime-event.entity';
import { OeeResource } from '../../entities/oee-resource.entity';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { WorktimeRange } from '../../entities/worktime-range.entity';
import {
  OEE_MOBILE_PROCESS_CODES,
  OEE_MOBILE_REASON_TYPES,
  OEE_MOBILE_RESOURCE_TYPES,
  OeeMobileEndDowntimeDto,
  OeeMobileProcessCode,
  OeeMobileReason,
  OeeMobileReasonType,
  OeeMobileResource,
  OeeMobileResourceType,
  OeeMobileStartDowntimeDto,
} from './oee-mobile.dto';
import { resolveOeeMobileWorkContext } from './oee-mobile-worktime';

// Keep the mobile response numeric while retaining null DISPLAY_ORDER rows at the end.
const NULL_DISPLAY_ORDER = Number.MAX_SAFE_INTEGER;

function isOeeMobileReasonType(
  value: string | null | undefined,
): value is (typeof OEE_MOBILE_REASON_TYPES)[number] {
  return OEE_MOBILE_REASON_TYPES.includes(value as (typeof OEE_MOBILE_REASON_TYPES)[number]);
}

function errorText(error: unknown): string[] {
  if (error == null) return [];
  if (typeof error !== 'object') return [String(error)];

  const record = error as Record<string, unknown>;
  const values: string[] = [];
  if (error instanceof Error) values.push(error.message);
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
    @InjectRepository(OeeResource)
    private readonly resourceRepository: Repository<OeeResource>,
    @InjectRepository(IsysUser)
    private readonly userRepository: Repository<IsysUser>,
    @InjectRepository(EquipDowntimeReason)
    private readonly reasonRepository: Repository<EquipDowntimeReason>,
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
      return this.listLineResources('SMT', organizationId);
    }

    return this.listLineResources('ASSY', organizationId);
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
    const rows = await this.reasonRepository.find({
      where: {
        organizationId: organization,
        useYn: 'Y',
      },
      order: { reasonType: 'ASC', displayOrder: 'ASC', reasonCode: 'ASC' },
    });

    return rows
      .filter(
        (row): row is EquipDowntimeReason & { reasonType: OeeMobileReasonType } =>
          row.organizationId === organization &&
          row.useYn === 'Y' &&
          isOeeMobileReasonType(row.reasonType),
      )
      .sort((left, right) => {
        const leftTypeOrder = left.reasonType === 'PLAN' ? 0 : 1;
        const rightTypeOrder = right.reasonType === 'PLAN' ? 0 : 1;
        if (leftTypeOrder !== rightTypeOrder) return leftTypeOrder - rightTypeOrder;

        if (left.displayOrder == null && right.displayOrder != null) return 1;
        if (left.displayOrder != null && right.displayOrder == null) return -1;
        if (
          left.displayOrder != null &&
          right.displayOrder != null &&
          left.displayOrder !== right.displayOrder
        ) {
          return left.displayOrder - right.displayOrder;
        }
        return left.reasonCode.localeCompare(right.reasonCode);
      })
      .map((row) => ({
        reasonCode: row.reasonCode,
        reasonName: row.reasonName ?? '',
        reasonType: row.reasonType,
        displayOrder: row.displayOrder ?? NULL_DISPLAY_ORDER,
      }));
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
    const context = await this.resolveCurrentWorkContext(processCode, organization, now);
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
    if (replay) {
      this.assertStartReplayMatches(replay, dto);
      return { event: replay, replayed: true };
    }

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
    const context = await this.resolveCurrentWorkContext(dto.processCode, organization, now);
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
      reasonCode: reason.reasonCode,
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
      if (requestReplay) {
        this.assertStartReplayMatches(requestReplay, dto);
        return { event: requestReplay, replayed: true };
      }
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
    if (requestReplay) {
      this.assertEndReplayMatches(requestReplay, dto);
      return { event: requestReplay, replayed: true };
    }

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
      if (concurrentReplay) {
        this.assertEndReplayMatches(concurrentReplay, dto);
        return { event: concurrentReplay, replayed: true };
      }
      throw new ConflictException('이미 처리된 비가동 종료 요청입니다.');
    }

    if (updateResult.affected !== 1) {
      const conditionalReplay = await this.eventRepository.findOne({
        where: { organizationId: organization, endRequestId: dto.requestId },
      });
      if (conditionalReplay) {
        this.assertEndReplayMatches(conditionalReplay, dto);
        return { event: conditionalReplay, replayed: true };
      }
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

  private async listLineResources(
    processCode: OeeMobileProcessCode,
    organizationId: number,
  ): Promise<OeeMobileResource[]> {
    const resources = await this.resourceRepository.find({
      where: {
        organizationId,
        processCode,
        resourceType: In([...OEE_MOBILE_RESOURCE_TYPES]),
        useYn: 'Y',
        refCode: Not(IsNull()),
      },
      order: { sortOrder: 'ASC', refCode: 'ASC' },
    });
    const configuredResources = resources.filter(
      (resource) =>
        resource.organizationId === organizationId &&
        resource.processCode === processCode &&
        resource.useYn === 'Y' &&
        typeof resource.refCode === 'string' &&
        resource.refCode.trim().length > 0 &&
        OEE_MOBILE_RESOURCE_TYPES.includes(resource.resourceType as OeeMobileResourceType),
    );
    if (configuredResources.length === 0) return [];

    const refCodes = configuredResources.map((resource) => resource.refCode as string);
    const lines = await this.lineRepository.find({
      where: {
        organizationId,
        lineCode: In(refCodes),
      },
    });
    const linesByCode = new Map(
      lines
        .filter((line) => line.organizationId === organizationId)
        .map((line) => [line.lineCode, line]),
    );

    return configuredResources
      .flatMap((resource) => {
        const refCode = resource.refCode as string;
        const line = linesByCode.get(refCode);
        return line ? [{ resource, line, refCode }] : [];
      })
      .sort((left, right) => {
        const leftSortOrder = Number.isFinite(left.resource.sortOrder)
          ? left.resource.sortOrder
          : Number.MAX_SAFE_INTEGER;
        const rightSortOrder = Number.isFinite(right.resource.sortOrder)
          ? right.resource.sortOrder
          : Number.MAX_SAFE_INTEGER;
        if (leftSortOrder !== rightSortOrder) return leftSortOrder - rightSortOrder;
        const codeOrder = left.refCode.localeCompare(right.refCode);
        if (codeOrder !== 0) return codeOrder;
        return left.resource.resourceType.localeCompare(right.resource.resourceType);
      })
      .map(({ resource, line, refCode }) => ({
        resourceId: resource.resourceId,
        processCode,
        resourceType: resource.resourceType as OeeMobileResourceType,
        resourceCode: refCode,
        resourceName: line.lineName,
        parentLineCode: refCode,
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

    if (parentLineCode !== resourceCode) {
      throw new BadRequestException('OEE 리소스 기준 코드는 라인 마스터 코드와 같아야 합니다.');
    }

    const resources = await this.listResources(processCode, organizationId, company, plantCd);
    const found = resources.find((resource) => {
      return (
        resource.processCode === processCode &&
        resource.resourceType === resourceType &&
        resource.resourceCode === resourceCode &&
        resource.parentLineCode === parentLineCode
      );
    });
    if (!found) throw new BadRequestException('인증 테넌트의 OEE 리소스가 아닙니다.');

    return found;
  }

  private async findReason(
    organizationId: number,
    reasonCode: string,
  ): Promise<EquipDowntimeReason | null> {
    if (reasonCode === 'N' || reasonCode === '*') return null;
    const reason = await this.reasonRepository.findOne({
      where: {
        reasonCode,
        organizationId,
        useYn: 'Y',
      },
    });
    if (
      !reason ||
      reason.organizationId !== organizationId ||
      reason.useYn !== 'Y' ||
      !isOeeMobileReasonType(reason.reasonType)
    ) {
      return null;
    }
    return reason;
  }

  private async resolveCurrentWorkContext(
    processCode: OeeMobileProcessCode,
    organizationId: number,
    serverTime: Date,
  ) {
    const rangeType = processCode === 'SMT' ? 'SMTWORKTIME' : 'WORKTIME';
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

  private assertStartReplayMatches(
    event: OeeDowntimeEvent,
    dto: OeeMobileStartDowntimeDto,
  ): void {
    const matches =
      event.processCode === dto.processCode &&
      event.resourceType === dto.resourceType &&
      event.resourceCode === dto.resourceCode &&
      event.parentLineCode === dto.parentLineCode &&
      event.workerId === dto.workerId &&
      event.reasonCode === dto.reasonCode &&
      (event.memo ?? null) === (dto.memo ?? null);

    if (!matches) {
      throw new ConflictException('동일한 시작 요청 ID가 다른 비가동 명령에 사용되었습니다.');
    }
  }

  private assertEndReplayMatches(event: OeeDowntimeEvent, dto: OeeMobileEndDowntimeDto): void {
    if (event.eventId !== dto.eventId) {
      throw new ConflictException('동일한 종료 요청 ID가 다른 이벤트에 사용되었습니다.');
    }
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
