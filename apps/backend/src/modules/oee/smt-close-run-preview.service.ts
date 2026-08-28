import {
  BadRequestException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import {
  SmtCloseRunCtStatus,
  SmtCloseRunPreviewQueryDto,
  SmtCloseRunPreviewResponse,
  SmtCloseRunValidationError,
} from './smt-close-run-preview.dto';

const CLOSED_RUN_STATUSES = new Set(['6', '7', '8']);
const MASTER_RESULTS = new Set(['MASTEROK', 'MASTERNG']);
const GOOD_RESULTS = new Set(['OK', 'GOOD', 'PASS', 'USEROK']);
const DEFECT_RESULTS = new Set(['NG', 'NO', 'USERNG']);
const INSPECT_DATE_PATTERN =
  /^(\d{4})\/(\d{2})\/(\d{2}) (\d{2}):(\d{2}):(\d{2})$/;

const RUN_SQL = `SELECT r.ORGANIZATION_ID AS "organizationId",
       r.RUN_NO AS "runNo",
       r.RUN_STATUS AS "runStatus",
       r.LINE_CODE AS "lineCode",
       r.ITEM_CODE AS "itemCode",
       r.MODEL_NAME AS "modelName",
       l.LINE_NAME AS "lineName",
       i.CUSTOMER_CODE AS "customerCode"
  FROM IP_PRODUCT_RUN_CARD r
  LEFT JOIN IP_PRODUCT_LINE l
    ON l.ORGANIZATION_ID = r.ORGANIZATION_ID
   AND l.LINE_CODE = r.LINE_CODE
  LEFT JOIN ID_ITEM i
    ON i.ORGANIZATION_ID = r.ORGANIZATION_ID
   AND i.ITEM_CODE = r.ITEM_CODE
 WHERE r.ORGANIZATION_ID = :organizationId
   AND r.RUN_NO = :runNo`;

const RESOURCE_SQL = `SELECT RESOURCE_ID AS "resourceId",
       ORGANIZATION_ID AS "organizationId",
       PROCESS_CODE AS "processCode",
       RESOURCE_TYPE AS "resourceType",
       REF_CODE AS "refCode",
       USE_YN AS "useYn"
  FROM OEE_RESOURCE
 WHERE ORGANIZATION_ID = :organizationId
   AND REF_CODE = :lineCode
   AND USE_YN = 'Y'
   AND PROCESS_CODE = 'SMT'
   AND RESOURCE_TYPE = 'LINE'`;

const SPI_SQL = `SELECT ORGANIZATION_ID AS "organizationId",
       RUN_NO AS "runNo",
       LINE_CODE AS "lineCode",
       PID AS "pid",
       INSPECT_DATE AS "inspectDate",
       RESULT AS "result"
  FROM IQ_MACHINE_INSPECT_SPI
 WHERE ORGANIZATION_ID = :organizationId
   AND RUN_NO = :runNo
   AND LINE_CODE = :lineCode
   AND PID IS NOT NULL
   AND UPPER(TRIM(PID)) <> 'NULL'
   AND RUN_NO IS NOT NULL
   AND TRIM(RUN_NO) <> '*'
   AND (RESULT IS NULL OR UPPER(TRIM(RESULT)) NOT IN ('MASTEROK', 'MASTERNG'))`;

const AOI_SQL = `SELECT ORGANIZATION_ID AS "organizationId",
       RUN_NO AS "runNo",
       LINE_CODE AS "lineCode",
       PID AS "pid",
       INSPECT_DATE AS "inspectDate",
       RESULT AS "result",
       REVIEW_RESULT AS "reviewResult"
  FROM IQ_MACHINE_INSPECT_AOI
 WHERE ORGANIZATION_ID = :organizationId
   AND RUN_NO = :runNo
   AND LINE_CODE = :lineCode
   AND PID IS NOT NULL
   AND UPPER(TRIM(PID)) <> 'NULL'
   AND RUN_NO IS NOT NULL
   AND TRIM(RUN_NO) <> '*'
   AND (RESULT IS NULL OR UPPER(TRIM(RESULT)) NOT IN ('MASTEROK', 'MASTERNG'))`;

const CT_SQL = `SELECT ITEM_CODE AS "itemCode",
       TO_CHAR(DATESET, 'YYYY-MM-DD') AS "dateset",
       TO_CHAR(DATEEND, 'YYYY-MM-DD') AS "dateend",
       CT_VALUE AS "ctValue"
  FROM IP_PRODUCT_ST_MASTER
 WHERE ORGANIZATION_ID = :organizationId
   AND ITEM_CODE = :itemCode
   AND DATESET <= TO_DATE(:ctDate, 'YYYY-MM-DD')
   AND (DATEEND IS NULL OR DATEEND >= TO_DATE(:ctDate, 'YYYY-MM-DD'))
 ORDER BY DATESET DESC`;

type NamedBinds = Record<string, unknown>;
type RawRow = Record<string, unknown>;

interface NamedQueryDataSource {
  query<T = unknown>(sql: string, parameters?: NamedBinds): Promise<T>;
}

type RunRow = RawRow & {
  organizationId?: number | string | null;
  runNo?: string;
  runStatus?: string | number;
  lineCode?: string | null;
  itemCode?: string | null;
  modelName?: string | null;
  lineName?: string | null;
  customerCode?: string | null;
};

type ResourceRow = RawRow & {
  resourceId?: number | string | null;
  organizationId?: number | string | null;
  processCode?: string;
  resourceType?: string;
  refCode?: string | null;
  useYn?: string;
};

type SourceRow = RawRow & {
  organizationId?: number | string | null;
  runNo?: string | null;
  lineCode?: string | null;
  pid?: string | null;
  inspectDate?: string | null;
  result?: string | null;
  reviewResult?: string | null;
};

type CtRow = RawRow & {
  itemCode?: string | null;
  dateset?: string | null;
  dateend?: string | null;
  ctValue?: number | string | null;
};

type ResultClass = 'GOOD' | 'DEFECT' | 'UNCLASSIFIED';

@Injectable()
export class SmtCloseRunPreviewService {
  constructor(
    @Inject(DataSource) private readonly dataSource: NamedQueryDataSource,
  ) {}

  async preview(
    query: SmtCloseRunPreviewQueryDto,
    organizationId?: number,
  ): Promise<SmtCloseRunPreviewResponse> {
    const organization = this.requireOrganization(organizationId);
    const runNo = this.requireRunNo(query?.runNo);
    const ctDate = this.requireCtDate(query?.ctDate);

    const runRows = await this.query<RunRow[]>(RUN_SQL, {
      organizationId: organization,
      runNo,
    });
    const run = runRows[0];
    if (!run) throw new NotFoundException('SMT RUN을 찾을 수 없습니다.');
    const runOrganizationId = this.numberValue(
      run,
      'organizationId',
      'ORGANIZATION_ID',
    );
    if (runOrganizationId != null && runOrganizationId !== organization) {
      throw new NotFoundException('SMT RUN을 찾을 수 없습니다.');
    }

    const runStatus = this.stringValue(run, 'runStatus', 'RUN_STATUS') ?? '';
    if (!CLOSED_RUN_STATUSES.has(runStatus)) {
      throw new BadRequestException({
        errorCode: 'SMT_RUN_NOT_CLOSED',
        message: 'RUN_STATUS 6, 7, 8인 SMT 마감 RUN만 검증할 수 있습니다.',
        runNo,
        runStatus,
      });
    }

    const lineCode = this.stringValue(run, 'lineCode', 'LINE_CODE');
    const itemCode = this.stringValue(run, 'itemCode', 'ITEM_CODE');
    const modelName = this.stringValue(run, 'modelName', 'MODEL_NAME');
    const lineName = this.stringValue(run, 'lineName', 'LINE_NAME');
    const customerCode = this.stringValue(run, 'customerCode', 'CUSTOMER_CODE');
    const validationErrors: SmtCloseRunValidationError[] = [];
    const line = lineCode ? { lineCode, lineName } : null;

    const resourceRows = lineCode
      ? await this.query<ResourceRow[]>(RESOURCE_SQL, {
          organizationId: organization,
          lineCode,
        })
      : [];
    const resources = resourceRows.filter((row) =>
      this.isApprovedResource(row, organization, lineCode),
    );
    const resource =
      resources.length === 1
        ? this.mapResource(resources[0], organization)
        : null;
    if (resources.length === 0) {
      this.addError(
        validationErrors,
        'RESOURCE_OUT_OF_SCOPE',
        'RUN 라인이 활성 SMT LINE OEE_RESOURCE에 등록되어 있지 않습니다.',
      );
    } else if (resources.length > 1) {
      this.addError(
        validationErrors,
        'RESOURCE_AMBIGUOUS',
        'RUN 라인에 일치하는 활성 SMT LINE OEE_RESOURCE가 여러 건입니다.',
        resources.length,
      );
    }

    const spi = { uniquePidCount: 0 };
    const aoi = {
      uniquePidCount: 0,
      outputCount: 0,
      goodCount: 0,
      defectCount: 0,
      unclassifiedCount: 0,
      ambiguousCount: 0,
    };

    if (resource && lineCode) {
      const spiRows = await this.query<SourceRow[]>(SPI_SQL, {
        organizationId: organization,
        runNo,
        lineCode,
      });
      const spiResult = this.aggregateSpi(
        spiRows,
        organization,
        runNo,
        lineCode,
      );
      spi.uniquePidCount = spiResult.uniquePidCount;
      if (spiResult.invalidInspectDateCount > 0) {
        this.addError(
          validationErrors,
          'SPI_INSPECT_DATE_INVALID',
          'SPI INSPECT_DATE가 YYYY/MM/DD HH24:MI:SS 형식이 아닙니다.',
          spiResult.invalidInspectDateCount,
        );
      }

      const aoiRows = await this.query<SourceRow[]>(AOI_SQL, {
        organizationId: organization,
        runNo,
        lineCode,
      });
      const aoiResult = this.aggregateAoi(
        aoiRows,
        organization,
        runNo,
        lineCode,
      );
      Object.assign(aoi, aoiResult.counts);
      if (aoiResult.invalidInspectDateCount > 0) {
        this.addError(
          validationErrors,
          'AOI_INSPECT_DATE_INVALID',
          'AOI INSPECT_DATE가 YYYY/MM/DD HH24:MI:SS 형식이 아닙니다.',
          aoiResult.invalidInspectDateCount,
        );
      }
      if (aoi.ambiguousCount > 0) {
        this.addError(
          validationErrors,
          'SOURCE_AMBIGUOUS',
          '동일 PID의 최신 AOI 판정이 서로 충돌합니다.',
          aoi.ambiguousCount,
        );
      }
      if (aoi.unclassifiedCount > 0) {
        this.addError(
          validationErrors,
          'AOI_RESULT_UNCLASSIFIED',
          'AOI 최종 판정을 GOOD/DEFECT로 분류할 수 없습니다.',
          aoi.unclassifiedCount,
        );
      }
    }

    const ct = await this.resolveCt(
      itemCode,
      ctDate,
      organization,
      validationErrors,
    );

    return {
      run: {
        runNo,
        runStatus,
        lineCode,
        itemCode,
        modelName,
      },
      resource,
      line,
      item: itemCode ? { itemCode } : null,
      model: modelName,
      customer: customerCode,
      status: validationErrors.length === 0 ? 'SOURCE_VALID' : 'SOURCE_INVALID',
      spi,
      aoi,
      ct,
      validationErrors,
    };
  }

  private async resolveCt(
    itemCode: string | null,
    ctDate: string,
    organizationId: number,
    validationErrors: SmtCloseRunValidationError[],
  ): Promise<SmtCloseRunPreviewResponse['ct']> {
    if (!itemCode) {
      this.addError(
        validationErrors,
        'ITEM_MISSING',
        'RUN 품목코드가 없습니다.',
      );
      this.addError(
        validationErrors,
        'CT_MISSING',
        '품목·기준일에 유효한 CT가 없습니다.',
      );
      return { candidateCount: 0, status: 'MISSING', candidates: [] };
    }

    const rows = await this.query<CtRow[]>(CT_SQL, {
      organizationId,
      itemCode,
      ctDate,
    });
    const candidates = rows.map((row) => ({
      itemCode: this.stringValue(row, 'itemCode', 'ITEM_CODE') ?? itemCode,
      dateset: this.stringValue(row, 'dateset', 'DATESET'),
      dateend: this.stringValue(row, 'dateend', 'DATEEND'),
      ctValue: this.numberValue(row, 'ctValue', 'CT_VALUE'),
    }));

    if (candidates.length === 0) {
      this.addError(
        validationErrors,
        'CT_MISSING',
        '품목·기준일에 유효한 CT가 없습니다.',
      );
      return { candidateCount: 0, status: 'MISSING', candidates };
    }

    if (candidates.length > 1) {
      this.addError(
        validationErrors,
        'CT_DUPLICATE',
        '품목·기준일에 유효한 CT가 정확히 한 건이 아닙니다.',
        candidates.length,
      );
    }

    const nonPositiveCount = candidates.filter(
      (candidate) => candidate.ctValue == null || candidate.ctValue <= 0,
    ).length;
    if (nonPositiveCount > 0) {
      this.addError(
        validationErrors,
        'CT_NON_POSITIVE',
        'CT_VALUE는 양수여야 합니다.',
        nonPositiveCount,
      );
    }

    let status: SmtCloseRunCtStatus = 'VALID';
    if (candidates.length > 1) status = 'DUPLICATE';
    else if (nonPositiveCount > 0) status = 'NON_POSITIVE';
    return { candidateCount: candidates.length, status, candidates };
  }

  private aggregateSpi(
    rows: SourceRow[],
    organizationId: number,
    runNo: string,
    lineCode: string,
  ): { uniquePidCount: number; invalidInspectDateCount: number } {
    const pids = new Set<string>();
    let invalidInspectDateCount = 0;
    for (const row of rows) {
      if (!this.isSourceRow(row, organizationId, runNo, lineCode)) continue;
      const pid = this.stringValue(row, 'pid', 'PID');
      if (!pid) continue;
      pids.add(pid);
      if (
        !this.isInspectDate(
          this.stringValue(row, 'inspectDate', 'INSPECT_DATE'),
        )
      ) {
        invalidInspectDateCount += 1;
      }
    }
    return { uniquePidCount: pids.size, invalidInspectDateCount };
  }

  private aggregateAoi(
    rows: SourceRow[],
    organizationId: number,
    runNo: string,
    lineCode: string,
  ): {
    counts: SmtCloseRunPreviewResponse['aoi'];
    invalidInspectDateCount: number;
  } {
    const grouped = new Map<string, SourceRow[]>();
    let invalidInspectDateCount = 0;
    for (const row of rows) {
      if (!this.isSourceRow(row, organizationId, runNo, lineCode)) continue;
      const pid = this.stringValue(row, 'pid', 'PID');
      if (!pid) continue;
      if (
        !this.isInspectDate(
          this.stringValue(row, 'inspectDate', 'INSPECT_DATE'),
        )
      ) {
        invalidInspectDateCount += 1;
      }
      const group = grouped.get(pid) ?? [];
      group.push(row);
      grouped.set(pid, group);
    }

    const counts: SmtCloseRunPreviewResponse['aoi'] = {
      uniquePidCount: grouped.size,
      outputCount: grouped.size,
      goodCount: 0,
      defectCount: 0,
      unclassifiedCount: 0,
      ambiguousCount: 0,
    };

    for (const group of grouped.values()) {
      const validRows = group.filter((row) =>
        this.isInspectDate(
          this.stringValue(row, 'inspectDate', 'INSPECT_DATE'),
        ),
      );
      if (validRows.length === 0) {
        counts.unclassifiedCount += 1;
        continue;
      }

      const latestTimestamp = Math.max(
        ...validRows.map((row) =>
          this.inspectDateTime(
            this.stringValue(row, 'inspectDate', 'INSPECT_DATE'),
          ),
        ),
      );
      const latestRows = validRows.filter(
        (row) =>
          this.inspectDateTime(
            this.stringValue(row, 'inspectDate', 'INSPECT_DATE'),
          ) === latestTimestamp,
      );
      const classifications = new Set(
        latestRows.map((row) => this.classifyResult(this.effectiveResult(row))),
      );
      if (classifications.size > 1) {
        counts.ambiguousCount += 1;
        continue;
      }

      const classification = [...classifications][0];
      if (classification === 'GOOD') counts.goodCount += 1;
      else if (classification === 'DEFECT') counts.defectCount += 1;
      else counts.unclassifiedCount += 1;
    }

    return { counts, invalidInspectDateCount };
  }

  private isSourceRow(
    row: SourceRow,
    organizationId: number,
    runNo: string,
    lineCode: string,
  ): boolean {
    const rowOrganizationId = this.numberValue(
      row,
      'organizationId',
      'ORGANIZATION_ID',
    );
    if (rowOrganizationId != null && rowOrganizationId !== organizationId) {
      return false;
    }
    const rowRunNo = this.stringValue(row, 'runNo', 'RUN_NO');
    if (!rowRunNo || rowRunNo !== runNo || rowRunNo === '*') return false;
    const rowLineCode = this.stringValue(row, 'lineCode', 'LINE_CODE');
    if (!rowLineCode || rowLineCode !== lineCode) return false;
    const pid = this.stringValue(row, 'pid', 'PID');
    if (!pid || pid.toUpperCase() === 'NULL') return false;
    const result = this.stringValue(row, 'result', 'RESULT');
    return !result || !MASTER_RESULTS.has(result.toUpperCase());
  }

  private effectiveResult(row: SourceRow): string | null {
    return (
      this.stringValue(row, 'reviewResult', 'REVIEW_RESULT') ??
      this.stringValue(row, 'result', 'RESULT')
    );
  }

  private classifyResult(value: string | null): ResultClass {
    const normalized = value?.trim().toUpperCase();
    if (normalized && GOOD_RESULTS.has(normalized)) return 'GOOD';
    if (normalized && DEFECT_RESULTS.has(normalized)) return 'DEFECT';
    return 'UNCLASSIFIED';
  }

  private isApprovedResource(
    row: ResourceRow,
    organizationId: number,
    lineCode: string | null,
  ): boolean {
    const rowOrganizationId = this.numberValue(
      row,
      'organizationId',
      'ORGANIZATION_ID',
    );
    return (
      (rowOrganizationId == null || rowOrganizationId === organizationId) &&
      this.stringValue(row, 'processCode', 'PROCESS_CODE') === 'SMT' &&
      this.stringValue(row, 'resourceType', 'RESOURCE_TYPE') === 'LINE' &&
      this.stringValue(row, 'useYn', 'USE_YN') === 'Y' &&
      this.stringValue(row, 'refCode', 'REF_CODE') === lineCode
    );
  }

  private mapResource(
    row: ResourceRow,
    organizationId: number,
  ): NonNullable<SmtCloseRunPreviewResponse['resource']> {
    return {
      resourceId: this.numberValue(row, 'resourceId', 'RESOURCE_ID'),
      organizationId,
      processCode:
        this.stringValue(row, 'processCode', 'PROCESS_CODE') ?? 'SMT',
      resourceType:
        this.stringValue(row, 'resourceType', 'RESOURCE_TYPE') ?? 'LINE',
      refCode: this.stringValue(row, 'refCode', 'REF_CODE') ?? '',
      useYn: this.stringValue(row, 'useYn', 'USE_YN') ?? 'Y',
    };
  }

  private isInspectDate(value: string | null): boolean {
    if (!value) return false;
    const match = INSPECT_DATE_PATTERN.exec(value);
    if (!match) return false;
    const year = Number(match[1]);
    const month = Number(match[2]);
    const day = Number(match[3]);
    const hour = Number(match[4]);
    const minute = Number(match[5]);
    const second = Number(match[6]);
    if (
      year < 1 ||
      month < 1 ||
      month > 12 ||
      hour > 23 ||
      minute > 59 ||
      second > 59
    ) {
      return false;
    }
    const date = new Date(Date.UTC(year, month - 1, day, hour, minute, second));
    return (
      date.getUTCFullYear() === year &&
      date.getUTCMonth() === month - 1 &&
      date.getUTCDate() === day &&
      date.getUTCHours() === hour &&
      date.getUTCMinutes() === minute &&
      date.getUTCSeconds() === second
    );
  }

  private inspectDateTime(value: string | null): number {
    const match = value ? INSPECT_DATE_PATTERN.exec(value) : null;
    if (!match || !this.isInspectDate(value)) return Number.NEGATIVE_INFINITY;
    return Date.UTC(
      Number(match[1]),
      Number(match[2]) - 1,
      Number(match[3]),
      Number(match[4]),
      Number(match[5]),
      Number(match[6]),
    );
  }

  private stringValue(row: RawRow, ...keys: string[]): string | null {
    for (const key of keys) {
      const value = row[key];
      if (typeof value === 'string' && value.trim() !== '') return value.trim();
      if (typeof value === 'number' && Number.isFinite(value)) {
        return String(value);
      }
    }
    return null;
  }

  private numberValue(row: RawRow, ...keys: string[]): number | null {
    for (const key of keys) {
      const value = row[key];
      if (value == null || value === '') continue;
      const number = Number(value);
      if (Number.isFinite(number)) return number;
    }
    return null;
  }

  private async query<T>(sql: string, binds: NamedBinds): Promise<T> {
    // Oracle may mutate named bind objects. Never reuse the object across calls.
    return this.dataSource.query<T>(sql, { ...binds });
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

  private requireRunNo(value: unknown): string {
    if (
      typeof value !== 'string' ||
      value.trim().length === 0 ||
      value.length > 50
    ) {
      throw new BadRequestException('runNo가 올바르지 않습니다.');
    }
    return value.trim();
  }

  private requireCtDate(value: unknown): string {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) {
      throw new BadRequestException('ctDate는 YYYY-MM-DD 형식이어야 합니다.');
    }
    const [year, month, day] = value.split('-').map(Number);
    const date = new Date(Date.UTC(year, month - 1, day));
    if (
      date.getUTCFullYear() !== year ||
      date.getUTCMonth() !== month - 1 ||
      date.getUTCDate() !== day
    ) {
      throw new BadRequestException('ctDate가 올바른 날짜가 아닙니다.');
    }
    return value;
  }

  private addError(
    errors: SmtCloseRunValidationError[],
    code: string,
    message: string,
    count?: number,
  ): void {
    errors.push(count == null ? { code, message } : { code, message, count });
  }
}
