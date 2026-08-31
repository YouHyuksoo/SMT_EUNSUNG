import { BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { SmtCloseRunPreviewService } from './smt-close-run-preview.service';

type QueryMock = jest.MockedFunction<DataSource['query']>;

const runRow = {
  organizationId: 7,
  runNo: 'RUN-1',
  runStatus: '8',
  lineCode: '01',
  itemCode: 'ITEM-1',
  modelName: 'MODEL-1',
  lineName: 'SMT A',
  customerCode: 'CUSTOMER-1',
};

const resourceRow = {
  organizationId: 7,
  resourceId: 11,
  processCode: 'SMT',
  resourceType: 'LINE',
  refCode: '01',
  useYn: 'Y',
};

const validCtRow = {
  itemCode: 'ITEM-1',
  dateset: '2026-08-01',
  dateend: '2026-08-31',
  ctValue: 12,
};

function createDataSource(): {
  dataSource: { query: QueryMock };
  service: SmtCloseRunPreviewService;
} {
  const dataSource = { query: jest.fn() as QueryMock };
  const service = new SmtCloseRunPreviewService(
    dataSource as unknown as DataSource,
  );
  return { dataSource, service };
}

function mockValidSourceQueries(
  dataSource: { query: QueryMock },
  overrides: {
    run?: Record<string, unknown>;
    resources?: Array<Record<string, unknown>>;
    spi?: Array<Record<string, unknown>>;
    aoi?: Array<Record<string, unknown>>;
    ct?: Array<Record<string, unknown>>;
  } = {},
): void {
  dataSource.query.mockImplementation(async (sql) => {
    if (sql.includes('IP_PRODUCT_RUN_CARD')) return [overrides.run ?? runRow];
    if (sql.includes('OEE_RESOURCE'))
      return overrides.resources ?? [resourceRow];
    if (sql.includes('IQ_MACHINE_INSPECT_SPI')) return overrides.spi ?? [];
    if (sql.includes('IQ_MACHINE_INSPECT_AOI')) return overrides.aoi ?? [];
    if (sql.includes('IP_PRODUCT_ST_MASTER'))
      return overrides.ct ?? [validCtRow];
    throw new Error(`unexpected SQL: ${sql}`);
  });
}

describe('SmtCloseRunPreviewService', () => {
  it('scopes the source report to the authenticated organization and the approved SMT line resource', async () => {
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource, {
      spi: [
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          inspectDate: '2026/08/24 08:01:00',
        },
        {
          organizationId: 8,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'OTHER_ORG',
          inspectDate: '2026/08/24 08:00:00',
        },
      ],
    });

    const result = await service.preview(
      { runNo: 'RUN-1', ctDate: '2026-08-24', organizationId: 999 } as never,
      7,
    );

    expect(result.spi.uniquePidCount).toBe(1);
    expect(result.resource).toMatchObject({ resourceId: 11, refCode: '01' });

    const runCall = dataSource.query.mock.calls.find(([sql]) =>
      sql.includes('IP_PRODUCT_RUN_CARD'),
    );
    const resourceCall = dataSource.query.mock.calls.find(([sql]) =>
      sql.includes('OEE_RESOURCE'),
    );
    expect(runCall?.[0]).toContain('r.ORGANIZATION_ID = :organizationId');
    expect(resourceCall?.[0]).toContain("PROCESS_CODE = 'SMT'");
    expect(resourceCall?.[0]).toContain("RESOURCE_TYPE = 'LINE'");
    expect(resourceCall?.[0]).toContain("USE_YN = 'Y'");
    expect(resourceCall?.[1]).toEqual({ organizationId: 7, lineCode: '01' });
    expect(JSON.stringify(dataSource.query.mock.calls)).not.toContain(
      'organizationId":999',
    );
  });

  it('excludes inactive, non-SMT, non-LINE, other-organization, and external-line resources', async () => {
    const excludedResources = [
      { ...resourceRow, useYn: 'N' },
      { ...resourceRow, processCode: 'ASSY' },
      { ...resourceRow, resourceType: 'CELL' },
      { ...resourceRow, organizationId: 8 },
      { ...resourceRow, refCode: '50' },
    ];
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource, { resources: excludedResources });

    const result = await service.preview(
      { runNo: 'RUN-1', ctDate: '2026-08-24' },
      7,
    );

    expect(result.resource).toBeNull();
    expect(result.validationErrors.map((error) => error.code)).toContain(
      'RESOURCE_OUT_OF_SCOPE',
    );
    expect(
      dataSource.query.mock.calls.some(([sql]) =>
        sql.includes('IQ_MACHINE_INSPECT_SPI'),
      ),
    ).toBe(false);
    expect(
      dataSource.query.mock.calls.some(([sql]) =>
        sql.includes('IQ_MACHINE_INSPECT_AOI'),
      ),
    ).toBe(false);
  });

  it('rejects RUN_STATUS 5 and allows only statuses 6, 7, and 8', async () => {
    for (const runStatus of ['6', '7', '8']) {
      const { dataSource, service } = createDataSource();
      mockValidSourceQueries(dataSource, { run: { ...runRow, runStatus } });
      await expect(
        service.preview({ runNo: 'RUN-1', ctDate: '2026-08-24' }, 7),
      ).resolves.toMatchObject({
        run: { runStatus },
      });
    }

    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource, { run: { ...runRow, runStatus: '5' } });
    await expect(
      service.preview({ runNo: 'RUN-1', ctDate: '2026-08-24' }, 7),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it('requires an explicit valid ctDate instead of defaulting from server time', async () => {
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource);

    await expect(
      service.preview({ runNo: 'RUN-1' } as never, 7),
    ).rejects.toBeInstanceOf(BadRequestException);
    await expect(
      service.preview({ runNo: 'RUN-1', ctDate: '2026-02-30' }, 7),
    ).rejects.toBeInstanceOf(BadRequestException);
    expect(dataSource.query).not.toHaveBeenCalled();
  });

  it('deduplicates SPI and AOI by organization, run, line, and PID, excluding placeholders and master results', async () => {
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource, {
      spi: [
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'OK',
          inspectDate: '2026/08/24 08:01:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P2',
          result: 'MasterOK',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'NULL',
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: '*',
          lineCode: '01',
          pid: 'P3',
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: null,
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
      ],
      aoi: [
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'NG',
          inspectDate: '2026/08/24 08:01:00',
          reviewResult: 'USEROK',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P2',
          result: 'MasterNG',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'NULL',
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: '*',
          lineCode: '01',
          pid: 'P3',
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
      ],
    });

    const result = await service.preview(
      { runNo: 'RUN-1', ctDate: '2026-08-24' },
      7,
    );

    expect(result.spi.uniquePidCount).toBe(1);
    expect(result.aoi).toMatchObject({
      uniquePidCount: 1,
      outputCount: 1,
      goodCount: 1,
      defectCount: 0,
      unclassifiedCount: 0,
      ambiguousCount: 0,
    });
  });

  it('selects the latest AOI inspection and prefers REVIEW_RESULT over RESULT', async () => {
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource, {
      aoi: [
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'NG',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'NG',
          reviewResult: 'GOOD',
          inspectDate: '2026/08/24 08:01:00',
        },
      ],
    });

    await expect(
      service.preview({ runNo: 'RUN-1', ctDate: '2026-08-24' }, 7),
    ).resolves.toMatchObject({
      aoi: { uniquePidCount: 1, goodCount: 1, defectCount: 0 },
    });
  });

  it('marks conflicting latest AOI results as SOURCE_AMBIGUOUS and unknown results as unclassified', async () => {
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource, {
      aoi: [
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'OK',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'NG',
          inspectDate: '2026/08/24 08:00:00',
        },
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P2',
          result: 'REVIEW_PENDING',
          inspectDate: '2026/08/24 08:02:00',
        },
      ],
    });

    const result = await service.preview(
      { runNo: 'RUN-1', ctDate: '2026-08-24' },
      7,
    );

    expect(result.aoi).toMatchObject({
      uniquePidCount: 2,
      outputCount: 2,
      goodCount: 0,
      defectCount: 0,
      unclassifiedCount: 1,
      ambiguousCount: 1,
    });
    expect(result.validationErrors.map((error) => error.code)).toEqual(
      expect.arrayContaining(['SOURCE_AMBIGUOUS', 'AOI_RESULT_UNCLASSIFIED']),
    );
  });

  it('detects malformed VARCHAR2 INSPECT_DATE values instead of silently converting them', async () => {
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource, {
      spi: [
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          inspectDate: 'not-a-date',
        },
      ],
      aoi: [
        {
          organizationId: 7,
          runNo: 'RUN-1',
          lineCode: '01',
          pid: 'P1',
          result: 'OK',
          inspectDate: '2026/99/99 99:99:99',
        },
      ],
    });

    const result = await service.preview(
      { runNo: 'RUN-1', ctDate: '2026-08-24' },
      7,
    );

    expect(result.validationErrors.map((error) => error.code)).toEqual(
      expect.arrayContaining([
        'SPI_INSPECT_DATE_INVALID',
        'AOI_INSPECT_DATE_INVALID',
      ]),
    );
  });

  it.each([
    ['missing', [], 'MISSING', 'CT_MISSING'],
    [
      'duplicate',
      [validCtRow, { ...validCtRow, dateset: '2026-08-10' }],
      'DUPLICATE',
      'CT_DUPLICATE',
    ],
    [
      'zero',
      [{ ...validCtRow, ctValue: 0 }],
      'NON_POSITIVE',
      'CT_NON_POSITIVE',
    ],
    [
      'negative',
      [{ ...validCtRow, ctValue: -1 }],
      'NON_POSITIVE',
      'CT_NON_POSITIVE',
    ],
  ] as const)(
    'reports CT %s without using an OEE resource fallback',
    async (_name, ct, status, errorCode) => {
      const { dataSource, service } = createDataSource();
      mockValidSourceQueries(dataSource, { ct });

      const result = await service.preview(
        { runNo: 'RUN-1', ctDate: '2026-08-24' },
        7,
      );

      expect(result.ct.status).toBe(status);
      expect(result.validationErrors.map((error) => error.code)).toContain(
        errorCode,
      );
      const ctSql = dataSource.query.mock.calls.find(([sql]) =>
        sql.includes('IP_PRODUCT_ST_MASTER'),
      )?.[0] as string;
      expect(ctSql).toContain('CT_VALUE');
      expect(ctSql).not.toContain('IDEAL_CT');
    },
  );

  it('uses only read-only source tables and does not depend on OEE result, summary, BOM, or routing objects', async () => {
    const { dataSource, service } = createDataSource();
    mockValidSourceQueries(dataSource);

    await service.preview({ runNo: 'RUN-1', ctDate: '2026-08-24' }, 7);

    for (const [sql] of dataSource.query.mock.calls) {
      expect(sql).toMatch(/^\s*SELECT\b/i);
      expect(sql).not.toMatch(
        /\b(?:INSERT|UPDATE|DELETE|MERGE|CREATE|ALTER|DROP)\b/i,
      );
      expect(sql).not.toMatch(
        /OEE_PRODUCTION_RESULT|OEE_DAILY_SUMMARY|V_OEE_LIVE|BOM|ROUTING/i,
      );
    }
  });

  it('preserves the original Oracle error from a source query', async () => {
    const { dataSource, service } = createDataSource();
    const oracleError = Object.assign(
      new Error('ORA-00942: table or view does not exist'),
      {
        code: 'ORA-00942',
      },
    );
    dataSource.query.mockImplementation(async (sql) => {
      if (sql.includes('IQ_MACHINE_INSPECT_SPI')) throw oracleError;
      if (sql.includes('IP_PRODUCT_RUN_CARD')) return [runRow];
      if (sql.includes('OEE_RESOURCE')) return [resourceRow];
      if (sql.includes('IP_PRODUCT_ST_MASTER')) return [validCtRow];
      return [];
    });

    await expect(
      service.preview({ runNo: 'RUN-1', ctDate: '2026-08-24' }, 7),
    ).rejects.toBe(oracleError);
  });

  it('passes a fresh named-bind object to every query even when the first call mutates its binds', async () => {
    const { dataSource, service } = createDataSource();
    let call = 0;
    dataSource.query.mockImplementation(async (sql, parameters) => {
      const binds = parameters as unknown as Record<string, unknown>;
      if (call++ === 0) binds.organizationId = 999;
      if (sql.includes('IP_PRODUCT_RUN_CARD')) return [runRow];
      if (sql.includes('OEE_RESOURCE')) return [resourceRow];
      if (sql.includes('IP_PRODUCT_ST_MASTER')) return [validCtRow];
      return [];
    });

    await service.preview({ runNo: 'RUN-1', ctDate: '2026-08-24' }, 7);

    const bindCalls = dataSource.query.mock.calls.map(
      ([, parameters]) => parameters,
    );
    expect(bindCalls.length).toBeGreaterThan(1);
    expect(bindCalls[0]).not.toBe(bindCalls[1]);
    expect(bindCalls[1]).toEqual(
      expect.objectContaining({ organizationId: 7 }),
    );
  });
});
