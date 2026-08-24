/**
 * @file src/modules/oee/oee-master.service.ts
 * @description OEE 리소스·비가동사유 마스터 CRUD.
 */
import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { OeeResource } from '../../entities/oee-resource.entity';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import {
  OEE_PROCESS_CODES,
  OEE_RESOURCE_TYPES,
  ReasonUpsertDto,
  ResourceCreateDto,
  ResourceUpdateDto,
} from './oee.dto';

const RESOURCE_LIST_SQL = `
  SELECT r.ORGANIZATION_ID AS "organizationId",
         r.RESOURCE_ID AS "resourceId",
         l.LINE_CODE AS "lineCode",
         l.LINE_NAME AS "lineName",
         l.LINE_CODE AS "resourceCode",
         l.LINE_NAME AS "resourceName",
         l.LINE_CODE AS "parentLineCode",
         r.PROCESS_CODE AS "processCode",
         r.RESOURCE_TYPE AS "resourceType",
         r.REF_CODE AS "refCode",
         r.IDEAL_CT AS "idealCt",
         r.USE_YN AS "useYn",
         r.SORT_ORDER AS "sortOrder"
    FROM OEE_RESOURCE r
    JOIN IP_PRODUCT_LINE l
      ON l.ORGANIZATION_ID = r.ORGANIZATION_ID
     AND l.LINE_CODE = r.REF_CODE
   WHERE r.ORGANIZATION_ID = :organizationId
     AND r.USE_YN = 'Y'
     AND r.PROCESS_CODE IN ('SMT', 'ASSY')
     AND r.RESOURCE_TYPE IN ('LINE', 'CELL')
   ORDER BY r.PROCESS_CODE ASC, r.SORT_ORDER ASC, l.LINE_CODE ASC`;

const RESOURCE_CANDIDATES_SQL = `
  SELECT l.LINE_CODE AS "lineCode",
         l.LINE_NAME AS "lineName",
         l.LINE_CODE AS "parentLineCode"
    FROM IP_PRODUCT_LINE l
   WHERE l.ORGANIZATION_ID = :organizationId
     AND NOT EXISTS (
       SELECT 1
         FROM OEE_RESOURCE r
        WHERE r.ORGANIZATION_ID = l.ORGANIZATION_ID
          AND r.REF_CODE = l.LINE_CODE
     )
   ORDER BY NVL(
              l.MES_DISPLAY_SEQUENCE,
              CASE
                WHEN REGEXP_LIKE(l.LINE_CODE, '^[0-9]+$') THEN TO_NUMBER(l.LINE_CODE)
                ELSE 2147483647
              END
            ),
            l.LINE_CODE ASC`;

const LINE_LOOKUP_SQL = `
  SELECT l.LINE_CODE AS "lineCode",
         l.LINE_NAME AS "lineName",
         l.MES_DISPLAY_SEQUENCE AS "mesDisplaySequence"
    FROM IP_PRODUCT_LINE l
   WHERE l.ORGANIZATION_ID = :organizationId
     AND l.LINE_CODE = :lineCode`;

const RESOURCE_REFERENCE_COUNTS_SQL = `
  SELECT
    (SELECT COUNT(*)
       FROM OEE_OPERATION_LOG h
      WHERE h.ORGANIZATION_ID = :organizationId
        AND h.RESOURCE_ID = :resourceId) AS "operationLog",
    (SELECT COUNT(*)
       FROM OEE_PLAN_TIME h
      WHERE h.ORGANIZATION_ID = :organizationId
        AND h.RESOURCE_ID = :resourceId) AS "planTime",
    (SELECT COUNT(*)
       FROM OEE_PRODUCTION_RESULT h
      WHERE h.ORGANIZATION_ID = :organizationId
        AND h.RESOURCE_ID = :resourceId) AS "productionResult",
    (SELECT COUNT(*)
       FROM OEE_DAILY_SUMMARY h
      WHERE h.ORGANIZATION_ID = :organizationId
        AND h.RESOURCE_ID = :resourceId) AS "dailySummary",
    (SELECT COUNT(*)
       FROM OEE_DOWNTIME_EVENT h
      WHERE h.ORGANIZATION_ID = :organizationId
        AND h.PROCESS_CODE = :processCode
        AND h.RESOURCE_TYPE = :resourceType
        AND h.RESOURCE_CODE = :resourceCode) AS "downtimeEvent"
  FROM DUAL`;

const RESOURCE_HISTORY_MIGRATION_SQL = `
BEGIN
  UPDATE OEE_DOWNTIME_EVENT
     SET PROCESS_CODE = :newProcessCode,
         RESOURCE_TYPE = :newResourceType
   WHERE ORGANIZATION_ID = :organizationId
     AND PROCESS_CODE = :oldProcessCode
     AND RESOURCE_TYPE = :oldResourceType
     AND RESOURCE_CODE = :resourceCode;

  UPDATE OEE_OPERATION_LOG
     SET PROCESS_CODE = :newProcessCode
   WHERE ORGANIZATION_ID = :organizationId
     AND RESOURCE_ID = :resourceId;

  UPDATE OEE_PRODUCTION_RESULT
     SET PROCESS_CODE = :newProcessCode
   WHERE ORGANIZATION_ID = :organizationId
     AND RESOURCE_ID = :resourceId;

  UPDATE OEE_DAILY_SUMMARY
     SET PROCESS_CODE = :newProcessCode
   WHERE ORGANIZATION_ID = :organizationId
     AND RESOURCE_ID = :resourceId;

  UPDATE OEE_RESOURCE
     SET PROCESS_CODE = :newProcessCode,
         RESOURCE_TYPE = :newResourceType
   WHERE ORGANIZATION_ID = :organizationId
     AND RESOURCE_ID = :resourceId
     AND PROCESS_CODE = :oldProcessCode
     AND RESOURCE_TYPE = :oldResourceType
     AND REF_CODE = :resourceCode;

  IF SQL%ROWCOUNT <> 1 THEN
    RAISE_APPLICATION_ERROR(-20003, 'OEE resource changed during update');
  END IF;
END;`;

export interface OeeResourceListRow {
  organizationId: number;
  resourceId: number;
  lineCode: string;
  lineName: string;
  resourceCode: string;
  resourceName: string;
  parentLineCode: string;
  processCode: string;
  resourceType: string;
  refCode: string | null;
  idealCt: number | null;
  useYn: string;
  sortOrder: number;
}

export interface OeeResourceCandidateRow {
  lineCode: string;
  lineName: string;
  parentLineCode: string;
}

export interface OeeResourceReferenceCounts {
  operationLog: number;
  planTime: number;
  productionResult: number;
  dailySummary: number;
  downtimeEvent: number;
}

interface LineLookupRow {
  lineCode?: string;
  lineName?: string;
  sortOrder?: number | string | null;
  mesDisplaySequence?: number | string | null;
  LINE_CODE?: string;
  LINE_NAME?: string;
  MES_DISPLAY_SEQUENCE?: number | string | null;
}

interface ReferenceCountsRow extends Partial<OeeResourceReferenceCounts> {
  OPERATION_LOG?: number | string | null;
  PLAN_TIME?: number | string | null;
  PRODUCTION_RESULT?: number | string | null;
  DAILY_SUMMARY?: number | string | null;
  DOWNTIME_EVENT?: number | string | null;
}

@Injectable()
export class OeeMasterService {
  constructor(
    @InjectRepository(OeeResource)
    private readonly resourceRepo: Repository<OeeResource>,
    @InjectRepository(OeeDowntimeReason)
    private readonly reasonRepo: Repository<OeeDowntimeReason>,
    private readonly dataSource: DataSource,
  ) {}

  async listResources(organizationId?: number): Promise<OeeResourceListRow[]> {
    const organization = this.requireOrganization(organizationId);
    return this.query<OeeResourceListRow[]>(RESOURCE_LIST_SQL, {
      organizationId: organization,
    });
  }

  async listResourceCandidates(
    organizationId?: number,
  ): Promise<OeeResourceCandidateRow[]> {
    const organization = this.requireOrganization(organizationId);
    return this.query<OeeResourceCandidateRow[]>(RESOURCE_CANDIDATES_SQL, {
      organizationId: organization,
    });
  }

  async createResource(
    dto: ResourceCreateDto,
    organizationId?: number,
  ): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    this.assertResourceDto(dto);
    const requestedLineCode = dto.lineCode.trim();
    const lines = await this.query<LineLookupRow[]>(LINE_LOOKUP_SQL, {
      organizationId: organization,
      lineCode: requestedLineCode,
    });
    const line = lines[0];
    if (!line) {
      throw new NotFoundException('인증 조직의 생산라인을 찾을 수 없습니다.');
    }

    const lineCode = this.lineCodeFromRow(line) ?? requestedLineCode;
    const existing = await this.resourceRepo.findOne({
      where: { organizationId: organization, refCode: lineCode },
    });
    if (existing) {
      throw new ConflictException(
        '해당 조직과 라인에 이미 OEE 리소스가 등록되어 있습니다.',
      );
    }

    try {
      await this.resourceRepo.insert({
        organizationId: organization,
        processCode: dto.processCode,
        resourceType: dto.resourceType,
        refCode: lineCode,
        resourceName: this.lineNameFromRow(line) ?? '',
        idealCt: null,
        useYn: 'Y',
        sortOrder: this.sortOrderFromRow(line, lineCode),
      });
    } catch (error: unknown) {
      if (this.isOracleUniqueViolation(error)) {
        throw new ConflictException(
          '해당 조직과 라인에 이미 OEE 리소스가 등록되어 있습니다.',
        );
      }
      throw error;
    }
  }

  async updateResource(
    resourceId: number,
    dto: ResourceUpdateDto,
    organizationId?: number,
  ): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    this.assertResourceId(resourceId);
    this.assertResourceDto(dto);

    const resource = await this.resourceRepo.findOne({
      where: { resourceId, organizationId: organization },
    });
    if (!resource) {
      throw new NotFoundException('인증 조직의 OEE 리소스를 찾을 수 없습니다.');
    }

    const requestedLineCode = dto.lineCode.trim();
    if (resource.refCode?.trim() !== requestedLineCode) {
      throw new BadRequestException('라인코드는 수정할 수 없습니다.');
    }

    const processChanged = resource.processCode !== dto.processCode;
    const typeChanged = resource.resourceType !== dto.resourceType;
    if (!processChanged && !typeChanged) return;

    try {
      await this.query(RESOURCE_HISTORY_MIGRATION_SQL, {
        organizationId: organization,
        resourceId,
        resourceCode: resource.refCode,
        oldProcessCode: resource.processCode,
        oldResourceType: resource.resourceType,
        newProcessCode: dto.processCode,
        newResourceType: dto.resourceType,
      });
    } catch (error: unknown) {
      if (this.isOracleError(error, 'ORA-20003')) {
        throw new NotFoundException(
          '인증 조직의 OEE 리소스가 수정 중 변경되었습니다.',
        );
      }
      if (this.isOracleUniqueViolation(error)) {
        throw new ConflictException(
          '해당 조직과 라인에 이미 OEE 리소스가 등록되어 있습니다.',
        );
      }
      throw error;
    }
  }

  async deleteResource(
    resourceId: number,
    organizationId?: number,
  ): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    this.assertResourceId(resourceId);

    const resource = await this.resourceRepo.findOne({
      where: { resourceId, organizationId: organization },
    });
    if (!resource) {
      throw new NotFoundException('인증 조직의 OEE 리소스를 찾을 수 없습니다.');
    }

    const counts = await this.referenceCounts(resource, organization);
    if (this.hasReferences(counts)) {
      throw this.resourceInUse(
        counts,
        '이력 데이터가 있는 OEE 리소스는 삭제할 수 없습니다.',
      );
    }

    const result = await this.resourceRepo.delete({
      resourceId,
      organizationId: organization,
    });
    if (result.affected !== 1) {
      throw new NotFoundException('인증 조직의 OEE 리소스를 찾을 수 없습니다.');
    }
  }

  async listReasons(organizationId?: number): Promise<OeeDowntimeReason[]> {
    const organization = this.requireOrganization(organizationId);
    return this.reasonRepo.find({
      where: { organizationId: organization, useYn: 'Y' },
      order: { sortOrder: 'ASC' },
    });
  }

  async upsertReason(
    dto: ReasonUpsertDto,
    isUpdate: boolean,
    organizationId?: number,
  ): Promise<void> {
    const organization = this.requireOrganization(organizationId);
    const fields = {
      organizationId: organization,
      processCode: dto.processCode ?? '*',
      reasonName: dto.reasonName,
      lossBucket: dto.lossBucket,
      oeeFactor: dto.oeeFactor,
      useYn: dto.useYn ?? 'Y',
      sortOrder: dto.sortOrder ?? 0,
    };
    if (isUpdate) {
      const result = await this.reasonRepo.update(
        { reasonCode: dto.reasonCode, organizationId: organization },
        fields,
      );
      if (result.affected !== 1) {
        throw new NotFoundException(
          '인증 조직의 OEE 비가동 사유를 찾을 수 없습니다.',
        );
      }
    } else {
      await this.reasonRepo.insert({ reasonCode: dto.reasonCode, ...fields });
    }
  }

  private async referenceCounts(
    resource: Pick<
      OeeResource,
      'resourceId' | 'processCode' | 'resourceType' | 'refCode'
    >,
    organizationId: number,
  ): Promise<OeeResourceReferenceCounts> {
    const rows = await this.query<ReferenceCountsRow[]>(
      RESOURCE_REFERENCE_COUNTS_SQL,
      {
        organizationId,
        resourceId: resource.resourceId,
        processCode: resource.processCode,
        resourceType: resource.resourceType,
        resourceCode: resource.refCode,
      },
    );
    const row = rows[0] ?? {};
    return {
      operationLog: this.countValue(row.operationLog ?? row.OPERATION_LOG),
      planTime: this.countValue(row.planTime ?? row.PLAN_TIME),
      productionResult: this.countValue(
        row.productionResult ?? row.PRODUCTION_RESULT,
      ),
      dailySummary: this.countValue(row.dailySummary ?? row.DAILY_SUMMARY),
      downtimeEvent: this.countValue(row.downtimeEvent ?? row.DOWNTIME_EVENT),
    };
  }

  private resourceInUse(
    counts: OeeResourceReferenceCounts,
    message: string,
  ): ConflictException {
    return new ConflictException({
      errorCode: 'OEE_RESOURCE_IN_USE',
      message,
      details: { counts },
    });
  }

  private hasReferences(counts: OeeResourceReferenceCounts): boolean {
    return Object.values(counts).some((count) => count > 0);
  }

  private sortOrderFromRow(row: LineLookupRow, lineCode: string): number {
    const mesDisplaySequence = this.numberValue(
      row.sortOrder ?? row.mesDisplaySequence ?? row.MES_DISPLAY_SEQUENCE,
    );
    if (mesDisplaySequence != null) return mesDisplaySequence;

    const numericLineCode = Number(lineCode);
    return Number.isFinite(numericLineCode) ? numericLineCode : 0;
  }

  private lineCodeFromRow(row: LineLookupRow): string | null {
    const value = row.lineCode ?? row.LINE_CODE;
    return typeof value === 'string' && value.trim() ? value.trim() : null;
  }

  private lineNameFromRow(row: LineLookupRow): string | null {
    const value = row.lineName ?? row.LINE_NAME;
    return typeof value === 'string' ? value : null;
  }

  private numberValue(value: unknown): number | null {
    if (value == null || value === '') return null;
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
  }

  private countValue(value: unknown): number {
    return this.numberValue(value) ?? 0;
  }

  private assertResourceDto(dto: ResourceCreateDto): void {
    if (dto == null || typeof dto !== 'object') {
      throw new BadRequestException('OEE 리소스 요청이 필요합니다.');
    }
    if (typeof dto.lineCode !== 'string' || dto.lineCode.trim().length === 0) {
      throw new BadRequestException('라인코드가 필요합니다.');
    }
    if (!OEE_PROCESS_CODES.includes(dto.processCode)) {
      throw new BadRequestException('지원하지 않는 OEE 공정입니다.');
    }
    if (!OEE_RESOURCE_TYPES.includes(dto.resourceType)) {
      throw new BadRequestException('지원하지 않는 OEE 리소스 유형입니다.');
    }
  }

  private assertResourceId(resourceId: number): void {
    if (!Number.isInteger(resourceId) || resourceId <= 0) {
      throw new BadRequestException('리소스 ID가 올바르지 않습니다.');
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

  private async query<T>(
    sql: string,
    binds: Record<string, unknown>,
  ): Promise<T> {
    // Oracle 드라이버가 named bind 객체를 변경할 수 있으므로 호출마다 복제한다.
    return this.dataSource.query<T>(sql, { ...binds } as unknown as unknown[]);
  }

  private isOracleUniqueViolation(error: unknown): boolean {
    return this.isOracleError(error, 'ORA-00001');
  }

  private isOracleError(error: unknown, code: string): boolean {
    if (typeof error === 'string') return error.includes(code);
    if (error == null || typeof error !== 'object') return false;
    const record = error as Record<string, unknown>;
    const driverError = record.driverError;
    const texts = [record.message, record.code];
    if (driverError && typeof driverError === 'object') {
      const driverRecord = driverError as Record<string, unknown>;
      texts.push(driverRecord.message, driverRecord.code);
    }
    return texts.some((value) => typeof value === 'string' && value.includes(code));
  }
}
