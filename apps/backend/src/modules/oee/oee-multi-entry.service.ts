import {
  BadRequestException,
  ConflictException,
  Injectable,
} from '@nestjs/common';
import { InjectDataSource, InjectRepository } from '@nestjs/typeorm';
import { DataSource, EntityManager, Repository } from 'typeorm';
import { WorktimeRange } from '../../entities/worktime-range.entity';
import { OeeMobileService } from './oee-mobile.service';
import {
  OEE_MULTI_ENTRY_PROCESS_CODES,
  OeeMultiEntryEndDto,
  OeeMultiEntryEndItemDto,
  OeeMultiEntryProcessCode,
  OeeMultiEntryStartDto,
} from './oee-multi-entry.dto';
import { resolveOeeMobileWorkContext } from './oee-mobile-worktime';

const BUSINESS_DAY_START_HOUR = 8;
const BUSINESS_DAY_START_MINUTE = 30;

const EFFECTIVE_LINE_SQL =
  'NVL(d.LINE_CODE, (SELECT m.LINE_CODE FROM IMCN_MACHINE m WHERE m.ORGANIZATION_ID = d.ORGANIZATION_ID AND m.MACHINE_CODE = d.MACHINE_CODE))';
const EVENT_COLUMNS = `
  d.DT_SEQ AS "dtSeq",
  d.ORGANIZATION_ID AS "organizationId",
  ${EFFECTIVE_LINE_SQL} AS "lineCode",
  d.REASON_CODE AS "reasonCode",
  d.MEMO AS "memo",
  d.WORKER AS "worker",
  d.START_TIME AS "startTime",
  d.END_TIME AS "endTime"`;

interface SqlRow {
  [key: string]: unknown;
}

export interface OeeMultiEntryEvent {
  dtSeq: number;
  organizationId: number;
  lineCode: string;
  reasonCode: string | null;
  memo: string | null;
  worker: string | null;
  startTime: Date | string | null;
  endTime: Date | string | null;
}

function isRecord(value: unknown): value is SqlRow {
  return typeof value === 'object' && value !== null;
}

function rowsOf(value: unknown): SqlRow[] {
  return Array.isArray(value) ? value.filter(isRecord) : [];
}

function byteLength(value: string): number {
  return Buffer.byteLength(value, 'utf8');
}

function stringValue(value: unknown): string {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean')
    return String(value);
  return '';
}

@Injectable()
export class OeeMultiEntryService {
  constructor(
    @InjectDataSource() private readonly dataSource: DataSource,
    private readonly mobileService: OeeMobileService,
    @InjectRepository(WorktimeRange)
    private readonly worktimeRepository: Repository<WorktimeRange>,
  ) {}

  async getStatus(
    processCode: OeeMultiEntryProcessCode,
    lineCode: string,
    organizationId?: number,
    company?: string,
    plantCd?: string,
  ): Promise<{
    workDate: string;
    workSegment: 'DAY' | 'NIGHT';
    state: 'RUNNING' | 'DOWNTIME';
    events: OeeMultiEntryEvent[];
    openEvents: OeeMultiEntryEvent[];
  }> {
    const organization = this.requireOrganization(organizationId);
    this.assertTenant(company, plantCd);
    this.assertProcessCode(processCode);
    this.assertLineCode(lineCode);

    const resources = await this.mobileService.listResources(
      processCode,
      organization,
      company,
      plantCd,
    );
    this.assertKnownLineCodes([lineCode], resources, processCode);

    const context = await this.resolveCurrentWorkContext(
      processCode,
      organization,
      new Date(),
    );
    const workdayStart = this.toBusinessDayStart(context.workDate);
    const nextWorkdayStart = new Date(
      workdayStart.getTime() + 24 * 60 * 60 * 1000,
    );
    const events = this.mapEvents(
      await this.dataSource.query(
        `SELECT ${EVENT_COLUMNS}
           FROM IP_EQUIP_DOWNTIME_RESULT d
          WHERE d.ORGANIZATION_ID = :1
            AND ${EFFECTIVE_LINE_SQL} = :2
            AND d.START_TIME >= :3
            AND d.START_TIME < :4
          ORDER BY d.START_TIME ASC, d.DT_SEQ ASC`,
        [organization, lineCode, workdayStart, nextWorkdayStart],
      ),
    );
    const openRows = rowsOf(
      await this.dataSource.query(
        `SELECT ${EVENT_COLUMNS}
           FROM IP_EQUIP_DOWNTIME_RESULT d
          WHERE d.ORGANIZATION_ID = :1
            AND ${EFFECTIVE_LINE_SQL} = :2
            AND d.END_TIME IS NULL
          ORDER BY d.START_TIME ASC, d.DT_SEQ ASC`,
        [organization, lineCode],
      ),
    );
    const openEvents = this.mapEvents(openRows);

    return {
      workDate: context.workDate,
      workSegment: context.workSegment,
      state: openEvents.length > 0 ? 'DOWNTIME' : 'RUNNING',
      events,
      openEvents,
    };
  }

  async start(
    dto: OeeMultiEntryStartDto,
    organizationId?: number,
    company?: string,
    plantCd?: string,
    userId?: string,
  ): Promise<{ events: OeeMultiEntryEvent[] }> {
    const organization = this.requireOrganization(organizationId);
    this.assertTenant(company, plantCd);
    const executor = this.requireExecutor(userId);
    this.assertStartDto(dto);

    const lineCodes = dto.lineCodes;
    const resources = await this.mobileService.listResources(
      dto.processCode,
      organization,
      company,
      plantCd,
    );
    this.assertKnownLineCodes(lineCodes, resources, dto.processCode);
    const worker = await this.mobileService.getWorker(
      dto.workerId,
      organization,
    );
    const reasonCode = await this.validateOptionalReason(
      dto.reasonCode,
      organization,
    );
    return this.dataSource.transaction(async (manager) => {
      await this.lockLineMasters(manager, organization, lineCodes);
      const openRows = rowsOf(
        await manager.query(
          `SELECT ${EVENT_COLUMNS}
           FROM IP_EQUIP_DOWNTIME_RESULT d
          WHERE d.ORGANIZATION_ID = :1
            AND ${EFFECTIVE_LINE_SQL} IN (${this.inPlaceholders(lineCodes, 2)})
            AND d.END_TIME IS NULL
          ORDER BY ${EFFECTIVE_LINE_SQL} ASC, d.ORGANIZATION_ID ASC, d.DT_SEQ ASC`,
          [organization, ...lineCodes],
        ),
      );
      if (openRows.length > 0) {
        throw new ConflictException(
          '선택한 라인 중 이미 열린 비가동이 있습니다.',
        );
      }

      const now = this.serverSecond();
      const createdItems: OeeMultiEntryEndItemDto[] = [];
      for (const lineCode of lineCodes) {
        const dtSeq = await this.nextDtSeq(manager);
        await manager.query(
          `INSERT INTO IP_EQUIP_DOWNTIME_RESULT
             (RUN_NO, DT_SEQ, ORGANIZATION_ID, MACHINE_CODE, LINE_CODE, WORKSTAGE_CODE,
              REASON_CODE, START_TIME, END_TIME, MEMO, WORKER, ENTER_BY, ENTER_DATE)
           VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13)`,
          [
            null,
            dtSeq,
            organization,
            null,
            lineCode,
            null,
            reasonCode,
            now,
            null,
            dto.memo ?? null,
            worker.workerId,
            executor,
            now,
          ],
        );
        createdItems.push({ lineCode, dtSeq });
      }

      return {
        events: await this.readEventsByItems(
          manager,
          organization,
          createdItems,
        ),
      };
    });
  }

  async end(
    dto: OeeMultiEntryEndDto,
    organizationId?: number,
    company?: string,
    plantCd?: string,
    userId?: string,
  ): Promise<{ events: OeeMultiEntryEvent[] }> {
    const organization = this.requireOrganization(organizationId);
    this.assertTenant(company, plantCd);
    const executor = this.requireExecutor(userId);
    this.assertEndDto(dto);

    const resources = await this.mobileService.listResources(
      dto.processCode,
      organization,
      company,
      plantCd,
    );
    this.assertKnownLineCodes(
      dto.items.map((item) => item.lineCode),
      resources,
      dto.processCode,
    );

    return this.dataSource.transaction(async (manager) => {
      const lineCodes = [
        ...new Set(dto.items.map((item) => item.lineCode)),
      ].sort((left, right) => left.localeCompare(right));
      await this.lockLineMasters(manager, organization, lineCodes);
      const targetRows = rowsOf(
        await manager.query(
          `SELECT ${EVENT_COLUMNS}
           FROM IP_EQUIP_DOWNTIME_RESULT d
          WHERE d.ORGANIZATION_ID = :1
            AND ${EFFECTIVE_LINE_SQL} IN (${this.inPlaceholders(lineCodes, 2)})
            AND d.END_TIME IS NULL
          ORDER BY ${EFFECTIVE_LINE_SQL} ASC, d.ORGANIZATION_ID ASC, d.DT_SEQ ASC
           FOR UPDATE`,
          [organization, ...lineCodes],
        ),
      );
      this.assertExactOpenTargets(targetRows, dto.items, organization);
      if (dto.reasonCode === undefined) {
        this.assertPreservedReasons(targetRows);
      } else {
        await this.validateRequiredReason(dto.reasonCode, organization);
      }
      const now = this.serverSecond();
      this.assertEndTimeNotBeforeStart(targetRows, now);

      for (const item of dto.items) {
        const preserveReason = dto.reasonCode === undefined;
        const result: unknown = await manager.query(
          preserveReason
            ? `UPDATE IP_EQUIP_DOWNTIME_RESULT d
                  SET END_TIME = :1,
                      LAST_MODIFY_BY = :2,
                      LAST_MODIFY_DATE = :3
                WHERE d.ORGANIZATION_ID=:4 AND d.DT_SEQ=:5 AND ${EFFECTIVE_LINE_SQL}=:6 AND d.END_TIME IS NULL`
            : `UPDATE IP_EQUIP_DOWNTIME_RESULT d
                  SET REASON_CODE = :1,
                      END_TIME = :2,
                      LAST_MODIFY_BY = :3,
                      LAST_MODIFY_DATE = :4
                WHERE d.ORGANIZATION_ID=:5 AND d.DT_SEQ=:6 AND ${EFFECTIVE_LINE_SQL}=:7 AND d.END_TIME IS NULL`,
          preserveReason
            ? [now, executor, now, organization, item.dtSeq, item.lineCode]
            : [
                dto.reasonCode,
                now,
                executor,
                now,
                organization,
                item.dtSeq,
                item.lineCode,
              ],
        );
        if (this.affectedRows(result) !== 1) {
          throw new ConflictException(
            '선택한 비가동이 이미 종료되었거나 변경되었습니다.',
          );
        }
      }

      return {
        events: await this.readEventsByItems(manager, organization, dto.items),
      };
    });
  }

  private async lockLineMasters(
    manager: EntityManager,
    organization: number,
    lineCodes: string[],
  ): Promise<void> {
    const sortedLineCodes = [...new Set(lineCodes)].sort((left, right) =>
      left.localeCompare(right),
    );
    const lockedRows = rowsOf(
      await manager.query(
        `SELECT LINE_CODE AS "lineCode", ORGANIZATION_ID AS "organizationId"
         FROM IP_PRODUCT_LINE
        WHERE ORGANIZATION_ID = :1
          AND LINE_CODE IN (${this.inPlaceholders(sortedLineCodes, 2)})
        ORDER BY LINE_CODE, ORGANIZATION_ID
        FOR UPDATE`,
        [organization, ...sortedLineCodes],
      ),
    );
    const lockedKeys = new Set(
      lockedRows
        .filter((row) => Number(row.organizationId) === organization)
        .map((row) => stringValue(row.lineCode)),
    );
    if (
      lockedKeys.size !== sortedLineCodes.length ||
      sortedLineCodes.some((lineCode) => !lockedKeys.has(lineCode))
    ) {
      throw new ConflictException(
        '선택한 라인 마스터가 인증 조직에서 변경되었습니다.',
      );
    }
  }

  private async readEventsByItems(
    manager: EntityManager,
    organization: number,
    items: OeeMultiEntryEndItemDto[],
  ): Promise<OeeMultiEntryEvent[]> {
    const result = rowsOf(
      await manager.query(
        `SELECT ${EVENT_COLUMNS}
         FROM IP_EQUIP_DOWNTIME_RESULT d
        WHERE d.ORGANIZATION_ID = :1
          AND ${EFFECTIVE_LINE_SQL} IS NOT NULL
          AND (${this.itemPredicate(items, 2)})
        ORDER BY ${EFFECTIVE_LINE_SQL} ASC, d.ORGANIZATION_ID ASC, d.DT_SEQ ASC`,
        [organization, ...items.flatMap((item) => [item.lineCode, item.dtSeq])],
      ),
    ).map((row) => this.mapEvent(row));
    if (result.length !== items.length) {
      throw new ConflictException(
        '일괄 처리 결과를 같은 트랜잭션에서 확인할 수 없습니다.',
      );
    }
    return result;
  }

  private async nextDtSeq(manager: EntityManager): Promise<number> {
    const result = rowsOf(
      await manager.query(
        'SELECT SEQ_IP_EQUIP_DOWNTIME.NEXTVAL AS "dtSeq" FROM DUAL',
        [],
      ),
    );
    const dtSeq = Number(result[0]?.dtSeq);
    if (!Number.isSafeInteger(dtSeq) || dtSeq <= 0) {
      throw new Error(
        'SEQ_IP_EQUIP_DOWNTIME.NEXTVAL 결과가 올바르지 않습니다.',
      );
    }
    return dtSeq;
  }

  private async validateOptionalReason(
    reasonCode: string | undefined,
    organization: number,
  ): Promise<string | null> {
    if (reasonCode == null) return null;
    const reasons = await this.mobileService.listReasons(organization);
    if (!reasons.some((reason) => reason.reasonCode === reasonCode)) {
      throw new BadRequestException('인증 조직의 활성 비가동 사유가 아닙니다.');
    }
    return reasonCode;
  }

  private async validateRequiredReason(
    reasonCode: string,
    organization: number,
  ): Promise<void> {
    const reasons = await this.mobileService.listReasons(organization);
    if (!reasons.some((reason) => reason.reasonCode === reasonCode)) {
      throw new BadRequestException('인증 조직의 활성 비가동 사유가 아닙니다.');
    }
  }

  private async resolveCurrentWorkContext(
    processCode: OeeMultiEntryProcessCode,
    organization: number,
    serverTime: Date,
  ) {
    const rangeType = processCode === 'SMT' ? 'SMTWORKTIME' : 'WORKTIME';
    const rows = await this.worktimeRepository.find({
      where: { organizationId: organization, rangeType },
      order: { workType: 'ASC' },
    });
    if (rows.length === 0)
      throw new BadRequestException('현재 업무시간 구간이 없습니다.');

    try {
      return resolveOeeMobileWorkContext(serverTime, rows);
    } catch (error: unknown) {
      if (error instanceof Error) throw new BadRequestException(error.message);
      throw error;
    }
  }

  private assertExactOpenTargets(
    targetRows: SqlRow[],
    items: OeeMultiEntryEndItemDto[],
    organization: number,
  ): void {
    const requestedKeys = new Set(
      items.map((item) => this.itemKey(item.lineCode, item.dtSeq)),
    );
    const actualKeys = new Set<string>();
    for (const row of targetRows) {
      const key = this.itemKey(stringValue(row.lineCode), Number(row.dtSeq));
      if (
        Number(row.organizationId) !== organization ||
        row.endTime != null ||
        actualKeys.has(key)
      ) {
        throw new ConflictException(
          '선택한 라인의 미종료 비가동 집합이 변경되었습니다.',
        );
      }
      actualKeys.add(key);
    }
    if (
      actualKeys.size !== requestedKeys.size ||
      [...requestedKeys].some((key) => !actualKeys.has(key))
    ) {
      throw new ConflictException(
        '선택한 라인의 미종료 비가동 집합이 변경되었습니다.',
      );
    }
  }

  private assertPreservedReasons(targetRows: SqlRow[]): void {
    if (
      targetRows.some(
        (row) =>
          typeof row.reasonCode !== 'string' ||
          row.reasonCode.trim().length === 0,
      )
    ) {
      throw new BadRequestException(
        '종료 대상에 입력된 비가동 사유가 없습니다.',
      );
    }
  }

  private assertEndTimeNotBeforeStart(
    targetRows: SqlRow[],
    endTime: Date,
  ): void {
    for (const row of targetRows) {
      if (row.startTime == null) continue;
      const startTime =
        row.startTime instanceof Date
          ? row.startTime
          : typeof row.startTime === 'string'
            ? new Date(row.startTime)
            : null;
      if (!startTime || Number.isNaN(startTime.getTime())) {
        throw new ConflictException(
          '선택한 비가동의 시작 시각을 확인할 수 없습니다.',
        );
      }
      if (endTime.getTime() < startTime.getTime()) {
        throw new ConflictException(
          '종료 시각이 시작 시각보다 빠를 수 없습니다.',
        );
      }
    }
  }

  private mapEvents(value: unknown): OeeMultiEntryEvent[] {
    return rowsOf(value).map((row) => this.mapEvent(row));
  }

  private mapEvent(row: SqlRow): OeeMultiEntryEvent {
    return {
      dtSeq: Number(row.dtSeq),
      organizationId: Number(row.organizationId),
      lineCode: stringValue(row.lineCode),
      reasonCode: row.reasonCode == null ? null : stringValue(row.reasonCode),
      memo: row.memo == null ? null : stringValue(row.memo),
      worker: row.worker == null ? null : stringValue(row.worker),
      startTime:
        row.startTime == null ? null : (row.startTime as Date | string),
      endTime: row.endTime == null ? null : (row.endTime as Date | string),
    };
  }

  private affectedRows(value: unknown): number {
    if (typeof value === 'number') return value;
    if (!isRecord(value)) return 0;
    return Number(value.rowsAffected ?? value.affected ?? 0);
  }

  private itemPredicate(
    items: OeeMultiEntryEndItemDto[],
    firstIndex: number,
  ): string {
    return items
      .map((_, index) => {
        const lineIndex = firstIndex + index * 2;
        return `(${EFFECTIVE_LINE_SQL} = :${lineIndex} AND d.DT_SEQ = :${lineIndex + 1})`;
      })
      .join(' OR ');
  }

  private inPlaceholders(values: string[], firstIndex: number): string {
    return values.map((_, index) => `:${firstIndex + index}`).join(', ');
  }

  private itemKey(lineCode: string, dtSeq: number): string {
    return `${lineCode}\u0000${dtSeq}`;
  }

  private serverSecond(): Date {
    const now = new Date();
    now.setMilliseconds(0);
    return now;
  }

  private toBusinessDayStart(workDate: string): Date {
    const result = new Date(
      `${workDate}T${String(BUSINESS_DAY_START_HOUR).padStart(2, '0')}:${String(BUSINESS_DAY_START_MINUTE).padStart(2, '0')}:00+09:00`,
    );
    if (Number.isNaN(result.getTime()))
      throw new BadRequestException('업무일을 해석할 수 없습니다.');
    return result;
  }

  private assertKnownLineCodes(
    lineCodes: string[],
    resources: Array<{ processCode: string; resourceCode: string }>,
    processCode: OeeMultiEntryProcessCode,
  ): void {
    const known = new Set(
      resources
        .filter(
          (resource) =>
            resource.processCode === processCode &&
            typeof resource.resourceCode === 'string',
        )
        .map((resource) => resource.resourceCode),
    );
    if (lineCodes.some((lineCode) => !known.has(lineCode))) {
      throw new BadRequestException('인증 테넌트의 현재 공정 라인이 아닙니다.');
    }
  }

  private assertStartDto(dto: OeeMultiEntryStartDto): void {
    if (dto == null || typeof dto !== 'object')
      throw new BadRequestException('시작 요청이 필요합니다.');
    this.assertProcessCode(dto.processCode);
    if (!Array.isArray(dto.lineCodes) || dto.lineCodes.length === 0) {
      throw new BadRequestException('시작 라인을 하나 이상 선택해야 합니다.');
    }
    this.assertUniqueLineCodes(dto.lineCodes);
    dto.lineCodes.forEach((lineCode) => this.assertLineCode(lineCode));
    this.assertBoundedString(dto.workerId, '작업자 ID', 20);
    if (dto.reasonCode != null)
      this.assertReasonCode(dto.reasonCode, '비가동 사유 코드');
    if (dto.memo != null) {
      if (
        typeof dto.memo !== 'string' ||
        dto.memo.length > 500 ||
        byteLength(dto.memo) > 500
      ) {
        throw new BadRequestException('메모는 500바이트 이내여야 합니다.');
      }
    }
  }

  private assertEndDto(dto: OeeMultiEntryEndDto): void {
    if (dto == null || typeof dto !== 'object')
      throw new BadRequestException('종료 요청이 필요합니다.');
    this.assertProcessCode(dto.processCode);
    if (!Array.isArray(dto.items) || dto.items.length === 0) {
      throw new BadRequestException('종료 대상을 하나 이상 선택해야 합니다.');
    }
    const dtSeqs = new Set<number>();
    for (const item of dto.items) {
      if (item == null || typeof item !== 'object')
        throw new BadRequestException('종료 대상이 올바르지 않습니다.');
      this.assertLineCode(item.lineCode);
      if (
        !Number.isSafeInteger(item.dtSeq) ||
        item.dtSeq <= 0 ||
        dtSeqs.has(item.dtSeq)
      ) {
        throw new BadRequestException('종료 실적 식별자가 올바르지 않습니다.');
      }
      dtSeqs.add(item.dtSeq);
    }
    if (dto.reasonCode !== undefined) {
      this.assertReasonCode(dto.reasonCode, '종료 비가동 사유 코드');
    }
  }

  private assertUniqueLineCodes(lineCodes: string[]): void {
    if (new Set(lineCodes).size !== lineCodes.length) {
      throw new BadRequestException('동일 라인을 중복 선택할 수 없습니다.');
    }
  }

  private assertProcessCode(
    value: unknown,
  ): asserts value is OeeMultiEntryProcessCode {
    if (
      !OEE_MULTI_ENTRY_PROCESS_CODES.includes(value as OeeMultiEntryProcessCode)
    ) {
      throw new BadRequestException('지원하지 않는 OEE 공정입니다.');
    }
  }

  private assertLineCode(value: unknown): asserts value is string {
    this.assertBoundedString(value, '라인 코드', 20);
    if (byteLength(value) > 20)
      throw new BadRequestException('라인 코드는 20바이트 이내여야 합니다.');
  }

  private assertReasonCode(
    value: unknown,
    fieldName: string,
  ): asserts value is string {
    this.assertBoundedString(value, fieldName, 20);
    if (byteLength(value) > 20)
      throw new BadRequestException(
        `${fieldName}은(는) 20바이트 이내여야 합니다.`,
      );
  }

  private assertBoundedString(
    value: unknown,
    fieldName: string,
    maxLength: number,
  ): asserts value is string {
    if (
      typeof value !== 'string' ||
      value.trim().length === 0 ||
      value.length > maxLength
    ) {
      throw new BadRequestException(`${fieldName}이(가) 올바르지 않습니다.`);
    }
  }

  private requireOrganization(organizationId?: number): number {
    if (
      organizationId == null ||
      !Number.isInteger(organizationId) ||
      organizationId <= 0
    ) {
      throw new BadRequestException('인증 조직 정보가 필요합니다.');
    }
    return organizationId;
  }

  private requireExecutor(userId?: string): string {
    this.assertBoundedString(userId, '인증 실행자 ID', 20);
    return userId;
  }

  private assertTenant(company?: string, plantCd?: string): void {
    if (!company?.trim() || !plantCd?.trim()) {
      throw new BadRequestException('인증 테넌트 정보가 필요합니다.');
    }
  }
}
