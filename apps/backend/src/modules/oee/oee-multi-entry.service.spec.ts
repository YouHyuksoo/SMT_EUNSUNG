import { BadRequestException, ConflictException } from '@nestjs/common';
import { DataSource, EntityManager, Repository } from 'typeorm';
import { WorktimeRange } from '../../entities/worktime-range.entity';
import { OeeMobileService } from './oee-mobile.service';
import {
  OeeMultiEntryEndDto,
  OeeMultiEntryStartDto,
} from './oee-multi-entry.dto';
import { OeeMultiEntryService } from './oee-multi-entry.service';

type Query = (sql: string, parameters?: unknown[]) => Promise<unknown>;

// node-oracledb applies array binds by placeholder occurrence, not by the
// numeric suffix written after each colon.
function oracleArrayBindValuesByOccurrence(
  sql: string,
  parameters: unknown[],
): unknown[] {
  return (sql.match(/:\d+/g) ?? []).map((_, index) => parameters[index]);
}

describe('OeeMultiEntryService', () => {
  let target: OeeMultiEntryService;
  let manager: { query: jest.MockedFunction<Query> };
  let dataSource: { transaction: jest.Mock; query: jest.Mock };
  let mobileService: {
    listResources: jest.Mock;
    getWorker: jest.Mock;
    listReasons: jest.Mock;
  };
  let worktimeRepository: { find: jest.Mock };
  let sequence = 100;
  let rolledBack = false;

  const resources = [
    {
      resourceId: 1,
      processCode: 'SMT' as const,
      resourceType: 'LINE' as const,
      resourceCode: '01',
      resourceName: 'SMT 01',
      parentLineCode: '01',
    },
    {
      resourceId: 2,
      processCode: 'SMT' as const,
      resourceType: 'LINE' as const,
      resourceCode: '02',
      resourceName: 'SMT 02',
      parentLineCode: '02',
    },
  ];

  const readbackEvents = [
    {
      dtSeq: 101,
      organizationId: 7,
      lineCode: '01',
      reasonCode: null,
      memo: 'batch',
      worker: 'WORKER01',
      startTime: new Date('2026-09-10T01:20:30.000Z'),
      endTime: null,
    },
    {
      dtSeq: 102,
      organizationId: 7,
      lineCode: '02',
      reasonCode: null,
      memo: 'batch',
      worker: 'WORKER01',
      startTime: new Date('2026-09-10T01:20:30.000Z'),
      endTime: null,
    },
  ];

  beforeEach(() => {
    jest.clearAllMocks();
    sequence = 100;
    rolledBack = false;
    manager = { query: jest.fn() };
    dataSource = { transaction: jest.fn(), query: jest.fn() };
    mobileService = {
      listResources: jest.fn().mockResolvedValue(resources),
      getWorker: jest
        .fn()
        .mockResolvedValue({ workerId: 'WORKER01', workerName: '작업자' }),
      listReasons: jest.fn().mockResolvedValue([
        {
          reasonCode: 'R1',
          reasonName: '정지',
          reasonType: 'UNPLAN',
          displayOrder: 1,
        },
        {
          reasonCode: 'R2',
          reasonName: '종료',
          reasonType: 'PLAN',
          displayOrder: 2,
        },
      ]),
    };
    worktimeRepository = { find: jest.fn() };
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE')) {
        return resources.map((resource) => ({
          lineCode: resource.resourceCode,
          organizationId: 7,
        }));
      }
      if (sql.includes('SEQ_IP_EQUIP_DOWNTIME.NEXTVAL')) {
        sequence += 1;
        return [{ dtSeq: sequence }];
      }
      if (sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('END_TIME IS NULL')
      ) {
        return [];
      }
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT')) return readbackEvents;
      return [];
    });
    dataSource.transaction.mockImplementation(
      async (
        callback: (transactionManager: EntityManager) => Promise<unknown>,
      ) => {
        try {
          return await callback(manager as unknown as EntityManager);
        } catch (error: unknown) {
          rolledBack = true;
          throw error;
        }
      },
    );
    target = new OeeMultiEntryService(
      dataSource as unknown as DataSource,
      mobileService as unknown as OeeMobileService,
      worktimeRepository as unknown as Repository<WorktimeRange>,
    );
  });

  it('uses the authenticated resources/worker/reason masters, locks sorted tenant lines, writes only the new ledger, and reads back in one transaction', async () => {
    jest
      .useFakeTimers()
      .setSystemTime(new Date('2026-09-10T10:20:30.987+09:00'));
    try {
      const dto: OeeMultiEntryStartDto = {
        processCode: 'SMT',
        lineCodes: ['02', '01'],
        workerId: 'WORKER01',
        reasonCode: 'R1',
        memo: 'batch',
      };

      const result = await target.start(dto, 7, 'EUNSUNG', '1', 'LOGIN01');

      expect(mobileService.listResources).toHaveBeenCalledWith(
        'SMT',
        7,
        'EUNSUNG',
        '1',
      );
      expect(mobileService.getWorker).toHaveBeenCalledWith('WORKER01', 7);
      expect(mobileService.listReasons).toHaveBeenCalledWith(7);
      expect(result).toEqual({ events: readbackEvents });
      expect(dataSource.query).not.toHaveBeenCalled();

      const lineLock = manager.query.mock.calls.find(
        ([sql]) =>
          sql.includes('FROM IP_PRODUCT_LINE') && sql.includes('FOR UPDATE'),
      );
      expect(lineLock?.[0]).toContain('ORDER BY LINE_CODE, ORGANIZATION_ID');
      expect(lineLock?.[1]).toEqual([7, '01', '02']);

      const insertCalls = manager.query.mock.calls.filter(([sql]) =>
        sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'),
      );
      expect(insertCalls).toHaveLength(2);
      expect(
        new Set(manager.query.mock.calls.map(([, parameters]) => parameters))
          .size,
      ).toBe(manager.query.mock.calls.length);
      for (const [, parameters] of insertCalls) {
        const values = parameters as unknown[];
        expect(values).toContain(7);
        expect(values).toContain('LOGIN01');
        expect(
          values
            .filter((value) => value instanceof Date)
            .map((value) => (value as Date).getTime()),
        ).toEqual([
          new Date('2026-09-10T10:20:30.000+09:00').getTime(),
          new Date('2026-09-10T10:20:30.000+09:00').getTime(),
        ]);
      }
      expect(
        manager.query.mock.calls.every(
          ([sql]) => !sql.includes('OEE_DOWNTIME_EVENT'),
        ),
      ).toBe(true);
      expect(
        manager.query.mock.calls.some(
          ([sql]) =>
            sql.includes('NVL(d.LINE_CODE') && sql.includes('IMCN_MACHINE'),
        ),
      ).toBe(true);
    } finally {
      jest.useRealTimers();
    }
  });

  it('captures START_TIME after the locked open-row check completes', async () => {
    const beforeLock = new Date('2026-09-10T10:20:30.999+09:00');
    const afterOpenCheck = new Date('2026-09-10T10:20:31.999+09:00');
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE')) {
        return [{ lineCode: '01', organizationId: 7 }];
      }
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('END_TIME IS NULL')
      ) {
        jest.setSystemTime(afterOpenCheck);
        return [];
      }
      if (sql.includes('SEQ_IP_EQUIP_DOWNTIME.NEXTVAL'))
        return [{ dtSeq: 101 }];
      if (sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT'))
        return [{ ...readbackEvents[0], dtSeq: 101, lineCode: '01' }];
      return [];
    });

    jest.useFakeTimers().setSystemTime(beforeLock);
    try {
      await target.start(
        { processCode: 'SMT', lineCodes: ['01'], workerId: 'WORKER01' },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      );

      const insert = manager.query.mock.calls.find(([sql]) =>
        sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'),
      );
      expect((insert?.[1] as unknown[])[7]).toEqual(
        new Date('2026-09-10T10:20:31.000+09:00'),
      );
    } finally {
      jest.useRealTimers();
    }
  });

  it('blocks a new start when a NULL LINE_CODE legacy row resolves to the selected effective line', async () => {
    mobileService.listResources.mockResolvedValue([
      ...resources,
      {
        resourceId: 3,
        processCode: 'SMT' as const,
        resourceType: 'LINE' as const,
        resourceCode: '03',
        resourceName: 'SMT 03',
        parentLineCode: '03',
      },
    ]);
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '03', organizationId: 7 }];
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('END_TIME IS NULL')
      ) {
        return [
          {
            dtSeq: 780,
            organizationId: 7,
            lineCode: '03',
            machineCode: 'LEGACY-MACHINE-03',
            endTime: null,
          },
        ];
      }
      return [];
    });

    await expect(
      target.start(
        { processCode: 'SMT', lineCodes: ['03'], workerId: 'WORKER01' },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(ConflictException);
    expect(
      manager.query.mock.calls.some(
        ([sql]) =>
          sql.includes('NVL(d.LINE_CODE') && sql.includes('IMCN_MACHINE'),
      ),
    ).toBe(true);
    expect(
      manager.query.mock.calls.some(([sql]) =>
        sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'),
      ),
    ).toBe(false);
  });

  it('allows an omitted start reason and overwrites every selected open row with the required end reason', async () => {
    const startDto: OeeMultiEntryStartDto = {
      processCode: 'SMT',
      lineCodes: ['01'],
      workerId: 'WORKER01',
    };
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (sql.includes('SEQ_IP_EQUIP_DOWNTIME.NEXTVAL'))
        return [{ dtSeq: 101 }];
      if (sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('END_TIME IS NULL')
      )
        return [];
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT'))
        return [readbackEvents[0]];
      return [];
    });
    await target.start(startDto, 7, 'EUNSUNG', '1', 'LOGIN01');
    expect(mobileService.listReasons).not.toHaveBeenCalled();
    const startInsert = manager.query.mock.calls.find(([sql]) =>
      sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'),
    );
    expect((startInsert?.[1] as unknown[])[6]).toBeNull();

    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('FOR UPDATE')
      ) {
        return [
          { ...readbackEvents[0], dtSeq: 101, lineCode: '01', endTime: null },
        ];
      }
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT')) {
        return [
          {
            ...readbackEvents[0],
            dtSeq: 101,
            lineCode: '01',
            reasonCode: 'R2',
            endTime: new Date(),
          },
        ];
      }
      return [];
    });
    jest
      .useFakeTimers()
      .setSystemTime(new Date('2026-09-10T11:22:33.999+09:00'));
    try {
      const result = await target.end(
        {
          processCode: 'SMT',
          items: [{ lineCode: '01', dtSeq: 101 }],
          reasonCode: 'R2',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      );

      expect(mobileService.listResources).toHaveBeenLastCalledWith(
        'SMT',
        7,
        'EUNSUNG',
        '1',
      );
      expect(mobileService.listReasons).toHaveBeenCalledWith(7);
      expect(result.events[0].reasonCode).toBe('R2');
      const update = manager.query.mock.calls.find(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      );
      const updateSql = update?.[0] as string;
      const updateParameters = update?.[1] as unknown[];
      const expectedEnd = new Date('2026-09-10T11:22:33.000+09:00');
      expect(updateSql.match(/:\d+/g)).toEqual([
        ':1',
        ':2',
        ':3',
        ':4',
        ':5',
        ':6',
        ':7',
      ]);
      expect(updateSql).toContain('NVL(d.LINE_CODE');
      expect(updateSql).toContain('FROM IMCN_MACHINE m');
      expect(
        oracleArrayBindValuesByOccurrence(updateSql, updateParameters),
      ).toEqual(['R2', expectedEnd, 'LOGIN01', expectedEnd, 7, 101, '01']);
    } finally {
      jest.useRealTimers();
    }
  });

  it('preserves mixed nonblank reasons when end reason is omitted', async () => {
    const targetRows = [
      {
        ...readbackEvents[0],
        lineCode: '01',
        dtSeq: 111,
        reasonCode: 'QC01',
        endTime: null,
      },
      {
        ...readbackEvents[1],
        lineCode: '01',
        dtSeq: 112,
        reasonCode: 'EB01',
        endTime: null,
      },
    ];
    const expectedEnd = new Date('2026-09-10T11:22:33.000+09:00');
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (sql.includes('FOR UPDATE')) return targetRows;
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT')) return 1;
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT')) {
        return targetRows.map((row) => ({ ...row, endTime: expectedEnd }));
      }
      return [];
    });
    jest
      .useFakeTimers()
      .setSystemTime(new Date('2026-09-10T11:22:33.999+09:00'));
    try {
      const result = await target.end(
        {
          processCode: 'SMT',
          items: [
            { lineCode: '01', dtSeq: 111 },
            { lineCode: '01', dtSeq: 112 },
          ],
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      );

      expect(result.events.map((event) => event.reasonCode)).toEqual([
        'QC01',
        'EB01',
      ]);
      expect(mobileService.listReasons).not.toHaveBeenCalled();
      const update = manager.query.mock.calls.find(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      );
      const updateSql = update?.[0] as string;
      const updateParameters = update?.[1] as unknown[];
      expect(updateSql).not.toContain('REASON_CODE');
      expect(updateSql.match(/:\d+/g)).toEqual([
        ':1',
        ':2',
        ':3',
        ':4',
        ':5',
        ':6',
      ]);
      expect(
        oracleArrayBindValuesByOccurrence(updateSql, updateParameters),
      ).toEqual([expectedEnd, 'LOGIN01', expectedEnd, 7, 111, '01']);
    } finally {
      jest.useRealTimers();
    }
  });

  it('preserves a shared nonblank reason without requiring the active reason master', async () => {
    const existing = {
      ...readbackEvents[0],
      lineCode: '01',
      dtSeq: 121,
      reasonCode: 'OLD01',
      endTime: null,
    };
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (sql.includes('FOR UPDATE')) return [existing];
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT'))
        return [{ ...existing, endTime: new Date() }];
      return [];
    });
    mobileService.listReasons.mockRejectedValue(
      new Error('reason master should not be queried for preserve'),
    );

    await expect(
      target.end(
        { processCode: 'SMT', items: [{ lineCode: '01', dtSeq: 121 }] },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).resolves.toMatchObject({ events: [{ reasonCode: 'OLD01' }] });
    expect(mobileService.listReasons).not.toHaveBeenCalled();
  });

  it('validates an overwrite reason after the locked exact target set and before UPDATE', async () => {
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (sql.includes('FOR UPDATE'))
        return [
          { ...readbackEvents[0], lineCode: '01', dtSeq: 131, endTime: null },
        ];
      return [];
    });
    mobileService.listReasons.mockResolvedValue([]);

    await expect(
      target.end(
        {
          processCode: 'SMT',
          items: [{ lineCode: '01', dtSeq: 131 }],
          reasonCode: 'NEW01',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(BadRequestException);
    expect(
      manager.query.mock.calls.some(([sql]) => sql.includes('FOR UPDATE')),
    ).toBe(true);
    expect(
      manager.query.mock.calls.some(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      ),
    ).toBe(false);
  });

  it('rejects a blank existing reason after locking the full preserve set without DML', async () => {
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (sql.includes('FOR UPDATE'))
        return [
          {
            ...readbackEvents[0],
            lineCode: '01',
            dtSeq: 141,
            reasonCode: '   ',
            endTime: null,
          },
        ];
      return [];
    });

    await expect(
      target.end(
        { processCode: 'SMT', items: [{ lineCode: '01', dtSeq: 141 }] },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(BadRequestException);
    expect(rolledBack).toBe(true);
    expect(
      manager.query.mock.calls.some(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      ),
    ).toBe(false);
  });

  it('rolls back the entire batch when a late open-row conflict is found before writes', async () => {
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE')) {
        return [
          { lineCode: '01', organizationId: 7 },
          { lineCode: '02', organizationId: 7 },
        ];
      }
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('END_TIME IS NULL')
      ) {
        return [
          { dtSeq: 55, organizationId: 7, lineCode: '02', endTime: null },
        ];
      }
      return [];
    });

    await expect(
      target.start(
        { processCode: 'SMT', lineCodes: ['01', '02'], workerId: 'WORKER01' },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(ConflictException);

    expect(rolledBack).toBe(true);
    expect(
      manager.query.mock.calls.some(([sql]) => sql.includes('INSERT INTO')),
    ).toBe(false);
  });

  it('rolls back after a late write failure instead of returning a partial batch', async () => {
    let insertCount = 0;
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE')) {
        return [
          { lineCode: '01', organizationId: 7 },
          { lineCode: '02', organizationId: 7 },
        ];
      }
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('END_TIME IS NULL')
      )
        return [];
      if (sql.includes('SEQ_IP_EQUIP_DOWNTIME.NEXTVAL'))
        return [{ dtSeq: ++sequence }];
      if (sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT')) {
        insertCount += 1;
        if (insertCount === 2) throw new Error('ORA-02291: late write failure');
        return { rowsAffected: 1 };
      }
      return [];
    });

    await expect(
      target.start(
        { processCode: 'SMT', lineCodes: ['01', '02'], workerId: 'WORKER01' },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow('ORA-02291: late write failure');

    expect(rolledBack).toBe(true);
    expect(insertCount).toBe(2);
  });

  it('uses one truncated server timestamp for every selected end update', async () => {
    const endedEvents = [
      {
        ...readbackEvents[0],
        dtSeq: 201,
        endTime: new Date('2026-09-10T02:22:33.000Z'),
      },
      {
        ...readbackEvents[1],
        dtSeq: 202,
        endTime: new Date('2026-09-10T02:22:33.000Z'),
      },
    ];
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE')) {
        return [
          { lineCode: '01', organizationId: 7 },
          { lineCode: '02', organizationId: 7 },
        ];
      }
      if (sql.includes('FOR UPDATE')) {
        return endedEvents.map((event) => ({ ...event, endTime: null }));
      }
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT')) return endedEvents;
      return [];
    });
    jest
      .useFakeTimers()
      .setSystemTime(new Date('2026-09-10T11:22:33.999+09:00'));
    try {
      await expect(
        target.end(
          {
            processCode: 'SMT',
            items: [
              { lineCode: '01', dtSeq: 201 },
              { lineCode: '02', dtSeq: 202 },
            ],
            reasonCode: 'R2',
          },
          7,
          'EUNSUNG',
          '1',
          'LOGIN01',
        ),
      ).resolves.toEqual({ events: endedEvents });

      const updates = manager.query.mock.calls.filter(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      );
      expect(updates).toHaveLength(2);
      expect(
        updates.map(([, parameters]) => (parameters as unknown[])[1]),
      ).toEqual([
        new Date('2026-09-10T11:22:33.000+09:00'),
        new Date('2026-09-10T11:22:33.000+09:00'),
      ]);
      expect(
        updates.map(([, parameters]) => (parameters as unknown[])[3]),
      ).toEqual([
        new Date('2026-09-10T11:22:33.000+09:00'),
        new Date('2026-09-10T11:22:33.000+09:00'),
      ]);
    } finally {
      jest.useRealTimers();
    }
  });

  it.each([
    ['numeric rows-affected success', 1, true],
    ['numeric zero rows-affected conflict', 0, false],
    ['undefined rows-affected conflict', undefined, false],
  ] as const)(
    '%s matches the Oracle query result shape',
    async (_label, updateResult, succeeds) => {
      const startTime = new Date('2026-09-10T01:20:30.000Z');
      const endTime = new Date('2026-09-10T02:22:33.000Z');
      manager.query.mockImplementation(async (sql: string) => {
        if (sql.includes('FROM IP_PRODUCT_LINE'))
          return [{ lineCode: '01', organizationId: 7 }];
        if (sql.includes('FOR UPDATE')) {
          return [
            { ...readbackEvents[0], dtSeq: 401, startTime, endTime: null },
          ];
        }
        if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'))
          return updateResult;
        if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT')) {
          return [
            {
              ...readbackEvents[0],
              dtSeq: 401,
              startTime,
              reasonCode: 'R2',
              endTime,
            },
          ];
        }
        return [];
      });
      jest
        .useFakeTimers()
        .setSystemTime(new Date('2026-09-10T11:22:33.999+09:00'));
      try {
        const command = target.end(
          {
            processCode: 'SMT',
            items: [{ lineCode: '01', dtSeq: 401 }],
            reasonCode: 'R2',
          },
          7,
          'EUNSUNG',
          '1',
          'LOGIN01',
        );
        if (succeeds) {
          await expect(command).resolves.toMatchObject({
            events: [{ dtSeq: 401, reasonCode: 'R2' }],
          });
        } else {
          await expect(command).rejects.toThrow(ConflictException);
        }
      } finally {
        jest.useRealTimers();
      }
    },
  );

  it('rejects a memo over the live 500-byte column before opening a transaction', async () => {
    const memo = '가'.repeat(167);

    await expect(
      target.start(
        {
          processCode: 'SMT',
          lineCodes: ['01', '02'],
          workerId: 'WORKER01',
          memo,
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(BadRequestException);

    expect(dataSource.transaction).not.toHaveBeenCalled();
  });

  it('captures END_TIME after line locks and target confirmation, never before target START_TIME', async () => {
    const targetStart = new Date('2026-09-10T11:22:33.000+09:00');
    const afterLock = new Date('2026-09-10T11:22:34.999+09:00');
    const expectedEnd = new Date('2026-09-10T11:22:34.000+09:00');
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE')) {
        jest.setSystemTime(afterLock);
        return [{ lineCode: '01', organizationId: 7 }];
      }
      if (sql.includes('FOR UPDATE')) {
        return [
          {
            ...readbackEvents[0],
            dtSeq: 451,
            startTime: targetStart,
            endTime: null,
          },
        ];
      }
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT')) return 1;
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT')) {
        return [
          {
            ...readbackEvents[0],
            dtSeq: 451,
            startTime: targetStart,
            endTime: afterLock,
          },
        ];
      }
      return [];
    });
    jest
      .useFakeTimers()
      .setSystemTime(new Date('2026-09-10T11:22:32.000+09:00'));
    try {
      await target.end(
        {
          processCode: 'SMT',
          items: [{ lineCode: '01', dtSeq: 451 }],
          reasonCode: 'R2',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      );

      const update = manager.query.mock.calls.find(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      );
      expect((update?.[1] as unknown[])[1]).toEqual(expectedEnd);
      expect(
        ((update?.[1] as unknown[])[1] as Date).getTime(),
      ).toBeGreaterThanOrEqual(targetStart.getTime());
    } finally {
      jest.useRealTimers();
    }
  });

  it('rolls back all end updates when a later target write fails', async () => {
    let updateCount = 0;
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE')) {
        return [
          { lineCode: '01', organizationId: 7 },
          { lineCode: '02', organizationId: 7 },
        ];
      }
      if (sql.includes('FOR UPDATE')) {
        return [
          { ...readbackEvents[0], dtSeq: 301, endTime: null },
          { ...readbackEvents[1], dtSeq: 302, endTime: null },
        ];
      }
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT')) {
        updateCount += 1;
        if (updateCount === 2) throw new Error('ORA-01403: late end failure');
        return { rowsAffected: 1 };
      }
      return [];
    });

    await expect(
      target.end(
        {
          processCode: 'SMT',
          items: [
            { lineCode: '01', dtSeq: 301 },
            { lineCode: '02', dtSeq: 302 },
          ],
          reasonCode: 'R2',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow('ORA-01403: late end failure');

    expect(rolledBack).toBe(true);
    expect(updateCount).toBe(2);
  });

  it('uses only the authenticated organization for cross-tenant validation and ledger binds', async () => {
    mobileService.listResources.mockResolvedValue([
      { ...resources[0], resourceCode: '01', parentLineCode: '01' },
    ]);
    mobileService.getWorker.mockResolvedValue({
      workerId: 'WORKER01',
      workerName: 'other tenant worker',
    });
    mobileService.listReasons.mockResolvedValue([
      {
        reasonCode: 'R1',
        reasonName: '정지',
        reasonType: 'UNPLAN',
        displayOrder: 1,
      },
    ]);
    manager.query.mockImplementation(
      async (sql: string, parameters?: unknown[]) => {
        if (sql.includes('FROM IP_PRODUCT_LINE'))
          return [{ lineCode: '01', organizationId: 8 }];
        if (
          sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
          sql.includes('END_TIME IS NULL')
        )
          return [];
        if (sql.includes('SEQ_IP_EQUIP_DOWNTIME.NEXTVAL'))
          return [{ dtSeq: 801 }];
        if (sql.includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'))
          return { rowsAffected: 1 };
        if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT'))
          return [{ ...readbackEvents[0], organizationId: 8 }];
        return parameters ?? [];
      },
    );

    await target.start(
      {
        processCode: 'SMT',
        lineCodes: ['01'],
        workerId: 'WORKER01',
        reasonCode: 'R1',
      },
      8,
      'EUNSUNG',
      '2',
      'LOGIN01',
    );

    expect(mobileService.listResources).toHaveBeenCalledWith(
      'SMT',
      8,
      'EUNSUNG',
      '2',
    );
    expect(mobileService.getWorker).toHaveBeenCalledWith('WORKER01', 8);
    expect(mobileService.listReasons).toHaveBeenCalledWith(8);
    for (const [, parameters] of manager.query.mock.calls) {
      if (Array.isArray(parameters) && parameters.includes(8))
        expect(parameters).not.toContain(7);
    }
  });

  it('rejects duplicate start lines but permits multiple distinct dtSeq targets on one line', async () => {
    await expect(
      target.start(
        { processCode: 'SMT', lineCodes: ['01', '01'], workerId: 'WORKER01' },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(BadRequestException);
    expect(dataSource.transaction).not.toHaveBeenCalled();

    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('FOR UPDATE')
      ) {
        return [
          { ...readbackEvents[0], lineCode: '01', dtSeq: 1, endTime: null },
          { ...readbackEvents[0], lineCode: '01', dtSeq: 2, endTime: null },
        ];
      }
      if (sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'))
        return { rowsAffected: 1 };
      if (sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT')) {
        return [
          {
            ...readbackEvents[0],
            lineCode: '01',
            dtSeq: 1,
            endTime: new Date(),
          },
          {
            ...readbackEvents[0],
            lineCode: '01',
            dtSeq: 2,
            endTime: new Date(),
          },
        ];
      }
      return [];
    });

    await expect(
      target.end(
        {
          processCode: 'SMT',
          items: [
            { lineCode: '01', dtSeq: 1 },
            { lineCode: '01', dtSeq: 2 },
          ],
          reasonCode: 'R2',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).resolves.toMatchObject({ events: expect.any(Array) });
    const lineLock = manager.query.mock.calls.find(([sql]) =>
      sql.includes('FROM IP_PRODUCT_LINE'),
    );
    expect(lineLock?.[1]).toEqual([7, '01']);

    await expect(
      target.end(
        {
          processCode: 'SMT',
          items: [
            { lineCode: '01', dtSeq: 1 },
            { lineCode: '01', dtSeq: 1 },
          ],
          reasonCode: 'R2',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(BadRequestException);
  });

  it('rejects a stale ended dtSeq without issuing an update', async () => {
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '01', organizationId: 7 }];
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('FOR UPDATE')
      ) {
        return [
          {
            dtSeq: 10,
            organizationId: 7,
            lineCode: '01',
            endTime: new Date('2026-09-10T01:00:00Z'),
          },
        ];
      }
      return [];
    });

    await expect(
      target.end(
        {
          processCode: 'SMT',
          items: [{ lineCode: '01', dtSeq: 10 }],
          reasonCode: 'R2',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(ConflictException);
    expect(
      manager.query.mock.calls.some(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      ),
    ).toBe(false);
  });

  it('rejects an omitted open row when the locked effective-line set is larger than the request', async () => {
    mobileService.listResources.mockResolvedValue([
      ...resources,
      {
        resourceId: 3,
        processCode: 'SMT' as const,
        resourceType: 'LINE' as const,
        resourceCode: '03',
        resourceName: 'SMT 03',
        parentLineCode: '03',
      },
    ]);
    manager.query.mockImplementation(async (sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_LINE'))
        return [{ lineCode: '03', organizationId: 7 }];
      if (
        sql.includes('FROM IP_EQUIP_DOWNTIME_RESULT') &&
        sql.includes('FOR UPDATE')
      ) {
        return [
          { ...readbackEvents[0], lineCode: '03', dtSeq: 801, endTime: null },
          { ...readbackEvents[0], lineCode: '03', dtSeq: 802, endTime: null },
        ];
      }
      return [];
    });

    await expect(
      target.end(
        {
          processCode: 'SMT',
          items: [{ lineCode: '03', dtSeq: 801 }],
          reasonCode: 'R2',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(ConflictException);
    expect(
      manager.query.mock.calls.some(([sql]) =>
        sql.includes('UPDATE IP_EQUIP_DOWNTIME_RESULT'),
      ),
    ).toBe(false);
  });

  it('returns business-day history and an open row without reading the old event ledger', async () => {
    worktimeRepository.find.mockResolvedValue([
      {
        organizationId: 7,
        rangeType: 'SMTWORKTIME',
        workType: 'A',
        startTime: '083000',
        endTime: '173000',
        attribute01: null,
        attribute02: null,
      },
    ] as WorktimeRange[]);
    const history = [
      { ...readbackEvents[0], endTime: new Date('2026-09-10T02:00:00Z') },
    ];
    const open = [{ ...readbackEvents[0], endTime: null }];
    dataSource.query.mockImplementation(async (sql: string) => {
      if (sql.includes('START_TIME >=') && sql.includes('START_TIME <'))
        return history;
      if (sql.includes('END_TIME IS NULL')) return open;
      return [];
    });
    jest.useFakeTimers().setSystemTime(new Date('2026-09-10T10:00:00+09:00'));
    try {
      await expect(
        target.getStatus('SMT', '01', 7, 'EUNSUNG', '1'),
      ).resolves.toEqual({
        workDate: '2026-09-10',
        workSegment: 'DAY',
        state: 'DOWNTIME',
        events: history,
        openEvents: [open[0]],
      });
      expect(worktimeRepository.find).toHaveBeenCalledWith({
        where: { organizationId: 7, rangeType: 'SMTWORKTIME' },
        order: { workType: 'ASC' },
      });
      expect(
        dataSource.query.mock.calls.every(([sql]) =>
          sql.includes('IP_EQUIP_DOWNTIME_RESULT'),
        ),
      ).toBe(true);
      expect(
        dataSource.query.mock.calls.every(
          ([sql]) => !sql.includes('OEE_DOWNTIME_EVENT'),
        ),
      ).toBe(true);
      expect(
        dataSource.query.mock.calls.some(
          ([sql]) =>
            sql.includes('NVL(d.LINE_CODE') && sql.includes('IMCN_MACHINE'),
        ),
      ).toBe(true);
    } finally {
      jest.useRealTimers();
    }
  });

  it('returns all effective-line open rows when status finds multiple open rows', async () => {
    worktimeRepository.find.mockResolvedValue([
      {
        organizationId: 7,
        rangeType: 'SMTWORKTIME',
        workType: 'A',
        startTime: '083000',
        endTime: '173000',
        attribute01: null,
        attribute02: null,
      },
    ] as WorktimeRange[]);
    dataSource.query.mockImplementation(async (sql: string) => {
      if (sql.includes('START_TIME >=') && sql.includes('START_TIME <'))
        return [];
      if (sql.includes('END_TIME IS NULL')) {
        return [
          { ...readbackEvents[0], dtSeq: 901, endTime: null },
          { ...readbackEvents[0], dtSeq: 902, endTime: null },
        ];
      }
      return [];
    });

    jest.useFakeTimers().setSystemTime(new Date('2026-09-10T10:00:00+09:00'));
    try {
      await expect(
        target.getStatus('SMT', '01', 7, 'EUNSUNG', '1'),
      ).resolves.toMatchObject({
        state: 'DOWNTIME',
        openEvents: expect.arrayContaining([
          expect.objectContaining({ dtSeq: 901, lineCode: '01' }),
          expect.objectContaining({ dtSeq: 902, lineCode: '01' }),
        ]),
      });
    } finally {
      jest.useRealTimers();
    }
  });
});
