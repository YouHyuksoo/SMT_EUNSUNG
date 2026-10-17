import { BadRequestException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { ProductWorkResult } from '../../entities/product-work-result.entity';
import { AssemblyResultService } from '../assembly-result/assembly-result.service';
import { WorkResultService } from './work-result.service';

describe('WorkResultService tenancy', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const add = jest.fn();
  const repository = {
    manager: { query, transaction },
  } as unknown as Repository<ProductWorkResult>;
  const service = new WorkResultService(repository, { add } as unknown as AssemblyResultService);

  beforeEach(() => {
    jest.clearAllMocks();
    // 라인구분 조회는 SMT('D')로 답한다 — 생산실적(조립실적)은 SMT 라인만 받는다
    query.mockImplementation((sql: string) =>
      Promise.resolve(sql.includes('LINE_DIVISION') ? [{ div: 'D' }] : []),
    );
    add.mockResolvedValue({ itemCode: 'SEMI-1', productDate: new Date(), productSeq: 1 });
  });

  it('does not put a non-SMT line result into the assembly result and marks it X', async () => {
    query.mockImplementation((sql: string) =>
      Promise.resolve(sql.includes('LINE_DIVISION') ? [{ div: 'W' }] : []),
    );
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))')) return Promise.resolve([{ seq: '01' }]);
        if (sql.includes('SELECT LINE_CODE')) return Promise.resolve([{ lineCode: '34' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation((callback: (value: typeof manager) => unknown) => callback(manager));

    const res = await service.upsertResult(
      { runNo: 'RUN-1', machineCode: 'MC-1', workstageCode: 'WS-1', resultQty: 10, resultStatus: 'DONE' } as never,
      7,
      'user-7',
    );

    expect(add).not.toHaveBeenCalled();
    expect(res).toEqual({ seqNo: '01', sensorApplyYn: 'X' });
    const marked = query.mock.calls.find(([sql]) => String(sql).includes("SENSOR_APPLY_YN='X'"));
    expect(marked?.[1]).toEqual(['RUN-1', '01', 7]);
  });

  it('requires an authenticated organization', () => {
    expect(() => service.results('RUN-1', undefined)).toThrow(BadRequestException);
    expect(query).not.toHaveBeenCalled();
  });

  it('binds the authenticated organization in read queries', async () => {
    await service.list('2026-08-01', '2026-08-25', undefined, undefined, 7);

    const [sql, params] = query.mock.calls[0] as [string, unknown[]];
    expect(sql).toContain('r.ORGANIZATION_ID = :1');
    expect(sql).not.toContain('ORGANIZATION_ID = 1');
    expect(sql).toContain('WHERE ROWNUM <= 500');
    expect(params).toEqual([7, '2026-08-01', '2026-08-25']);
  });

  it('uses positional binds for multiple lines and preserves existing filters', async () => {
    await service.list(
      '2026-08-01',
      '2026-08-25',
      'LEGACY-LINE',
      'ITEM',
      7,
      'MACHINE-1',
      false,
      ['L1', 'L2'],
    );

    const [sql, params] = query.mock.calls[0] as [string, unknown[]];
    expect(sql).toContain('AND r.LINE_CODE IN (:4, :5)');
    expect(sql).toContain('AND r.MACHINE_CODE = :6');
    expect(sql).toContain('UPPER(r.ITEM_CODE) LIKE :7');
    expect(sql).not.toContain('L1');
    expect(sql).not.toContain('L2');
    expect(params).toEqual([
      7,
      '2026-08-01',
      '2026-08-25',
      'L1',
      'L2',
      'MACHINE-1',
      '%ITEM%',
    ]);
    expect(sql).toContain('WHERE ROWNUM <= 101');
  });

  describe('downtimeMachines', () => {
    const machineRow = { machineCode: 'MC-1', machineName: 'M1', workstageCode: 'W1', lineCode: '03' };

    it('fixes the machine when the work order has one', async () => {
      query
        .mockResolvedValueOnce([{ machineCode: 'MC-1', workstageCode: 'W1', lineCode: '03' }])
        .mockResolvedValueOnce([machineRow]);
      const res = await service.downtimeMachines('RUN-1', 7);
      expect(res).toEqual({ by: 'machine', fixed: true, list: [machineRow] });
      expect(query.mock.calls[1][0]).toContain('m.MACHINE_CODE=:2');
      expect(query.mock.calls[1][1]).toEqual([7, 'MC-1']);
    });

    it('lists the placed machines of the workstage when only the workstage is set', async () => {
      query
        .mockResolvedValueOnce([{ machineCode: null, workstageCode: 'W1', lineCode: '03' }])
        .mockResolvedValueOnce([machineRow]);
      const res = await service.downtimeMachines('RUN-1', 7);
      expect(res.by).toBe('workstage');
      expect(query.mock.calls[1][0]).toContain('m.WORKSTAGE_CODE=:2');
      expect(query.mock.calls[1][1]).toEqual([7, 'W1']);
    });

    it('falls back to machines placed on the work order line', async () => {
      query
        .mockResolvedValueOnce([{ machineCode: null, workstageCode: null, lineCode: '03' }])
        .mockResolvedValueOnce([machineRow]);
      const res = await service.downtimeMachines('RUN-1', 7);
      expect(res.by).toBe('line');
      expect(query.mock.calls[1][0]).toContain('m.LINE_CODE=:2');
      expect(query.mock.calls[1][1]).toEqual([7, '03']);
    });

    it('returns an empty list when the work order has no machine, workstage or line', async () => {
      query.mockResolvedValueOnce([{ machineCode: null, workstageCode: null, lineCode: null }]);
      expect(await service.downtimeMachines('RUN-1', 7)).toEqual({ by: 'none', fixed: false, list: [] });
    });
  });

  it('excludes SMT-division lines only when requested', async () => {
    await service.list('2026-08-01', '2026-08-25', undefined, undefined, 7, undefined, true);

    const [sql, params] = query.mock.calls[0] as [string, unknown[]];
    expect(sql).toContain('LINE_DIVISION IN (:4,:5)');
    expect(params).toEqual([7, '2026-08-01', '2026-08-25', 'D', 'SMT']);
  });

  it('uses the authenticated user and organization for writes', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))'))
          return Promise.resolve([{ seq: '01' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation(
      (callback: (value: typeof manager) => unknown) => callback(manager),
    );

    await service.upsertResult(
      {
        runNo: 'RUN-1',
        machineCode: 'MC-1',
        workstageCode: 'WS-1',
        resultQty: 10,
        resultStatus: 'WIP',
        userId: 'forged-user',
      } as never,
      7,
      'authenticated-user',
    );

    // 2026-09-30: 실적 이력 원장이 IP_PRODUCT_WORK_RESULT로 되돌아갔다.
    const insertCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('INSERT INTO IP_PRODUCT_WORK_RESULT'),
    );
    expect(insertCall?.[1]).toContain(7);
    expect(insertCall?.[1]).toContain('authenticated-user');
    expect(insertCall?.[1]).not.toContain('forged-user');
  });

  it('binds null equipment and preserves the process when creating a result', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))'))
          return Promise.resolve([{ seq: '01' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation(
      (callback: (value: typeof manager) => unknown) => callback(manager),
    );

    await service.upsertResult(
      {
        runNo: 'RUN-1',
        workstageCode: 'WS-1',
        resultQty: 10,
        resultStatus: 'WIP',
      } as never,
      7,
      'user-7',
    );

    const insertCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('INSERT INTO IP_PRODUCT_WORK_RESULT'),
    );
    const runCardCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('UPDATE IP_PRODUCT_RUN_CARD'),
    );
    // [0]=runNo, [1]=seqNo, [2]=organization, [3]=machineCode(미지정 → null), [4]=workstageCode
    expect(insertCall?.[1]?.[1]).toBe('01');
    expect(insertCall?.[1]?.[3]).toBeNull();
    expect(insertCall?.[1]?.[4]).toBe('WS-1');
    expect(runCardCall?.[1]?.[0]).toBeNull();
    // 공정은 발행 때 정해지고 실적이 런카드에 다시 쓰지 않는다
    expect(String(runCardCall?.[0])).not.toContain('WORKSTAGE_CODE');
  });

  it('normalizes whitespace equipment on an existing result update', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes("SELECT NVL(RESULT_STATUS,'WIP')"))
          return Promise.resolve([{ st: 'WIP' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation(
      (callback: (value: typeof manager) => unknown) => callback(manager),
    );

    await service.upsertResult(
      {
        runNo: 'RUN-1',
        seqNo: '01',
        machineCode: '   ',
        workstageCode: 'WS-1',
        resultQty: 10,
        resultStatus: 'WIP',
      },
      7,
      'user-7',
    );

    const updateCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('UPDATE IP_PRODUCT_WORK_RESULT SET'),
    );
    const runCardCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('UPDATE IP_PRODUCT_RUN_CARD'),
    );
    // [0]=machineCode(공백 정규화 → null), [1]=workstageCode
    expect(updateCall?.[1]?.[0]).toBeNull();
    expect(updateCall?.[1]?.[1]).toBe('WS-1');
    expect(runCardCall?.[1]?.[0]).toBeNull();
    // 공정은 발행 때 정해지고 실적이 런카드에 다시 쓰지 않는다
    expect(String(runCardCall?.[0])).not.toContain('WORKSTAGE_CODE');
  });

  it('does not put an in-progress result into the assembly result', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))'))
          return Promise.resolve([{ seq: '01' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation(
      (callback: (value: typeof manager) => unknown) => callback(manager),
    );

    const res = await service.upsertResult(
      { runNo: 'RUN-1', workstageCode: 'WS-1', resultQty: 10, resultStatus: 'WIP' } as never,
      7,
      'user-7',
    );

    expect(add).not.toHaveBeenCalled();
    expect(res.sensorApplyYn).toBe('N');
  });

  it('puts a completed SMT result into the assembly result once (MANUAL)', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))'))
          return Promise.resolve([{ seq: '01' }]);
        if (sql.includes('SELECT LINE_CODE'))
          return Promise.resolve([{ lineCode: 'L1' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation(
      (callback: (value: typeof manager) => unknown) => callback(manager),
    );

    const res = await service.upsertResult(
      {
        runNo: 'RUN-1',
        machineCode: 'MC-1',
        workstageCode: 'WS-1',
        resultQty: 10,
        resultStatus: 'DONE',
      } as never,
      7,
      'user-7',
    );

    expect(add).toHaveBeenCalledTimes(1);
    const [input] = add.mock.calls[0] as [Record<string, unknown>];
    expect(input).toMatchObject({ runNo: 'RUN-1', lineCode: 'L1', qty: 10, source: 'MANUAL', remark: 'RUN-1-01', user: 'user-7' });
    expect(res.sensorApplyYn).toBe('Y');
    expect(res.sensorWarning).toBeUndefined();
  });

  it('keeps the result and warns when the assembly result is refused', async () => {
    add.mockRejectedValue(new BadRequestException('조립실적을 넣지 못했습니다: M1 T면 생산 품목 미지정'));
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))'))
          return Promise.resolve([{ seq: '01' }]);
        if (sql.includes('SELECT LINE_CODE'))
          return Promise.resolve([{ lineCode: 'L1' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation(
      (callback: (value: typeof manager) => unknown) => callback(manager),
    );

    const res = await service.upsertResult(
      { runNo: 'RUN-1', workstageCode: 'WS-1', resultQty: 10, resultStatus: 'DONE' } as never,
      7,
      'user-7',
    );

    expect(res.sensorApplyYn).toBe('N');
    expect(res.sensorWarning).toContain('생산 품목 미지정');
    // 반영 실패를 실적 행에 기록해 화면이 빨간색으로 표기할 수 있게 한다.
    const flagCall = query.mock.calls.find(([sql]) =>
      String(sql).includes('SET SENSOR_APPLY_YN'),
    );
    expect(flagCall?.[1]?.[0]).toBe('N');
    expect(String(flagCall?.[1]?.[1])).toContain('생산 품목 미지정');
  });

  it('refuses to re-apply a result already reflected in the assembly result', async () => {
    query.mockResolvedValue([
      {
        workstageCode: 'WS-1',
        machineCode: 'MC-1',
        resultQty: 10,
        resultStatus: 'DONE',
        sensorApplyYn: 'Y',
        lineCode: 'L1',
      },
    ]);

    await expect(
      service.applySensor({ runNo: 'RUN-1', seqNo: '01' }, 7),
    ).rejects.toThrow(BadRequestException);
    expect(add).not.toHaveBeenCalled();
  });

  it('re-applies a completed result that has not been reflected yet', async () => {
    const row = {
      workstageCode: 'WS-1',
      machineCode: 'MC-1',
      resultQty: 25,
      resultStatus: 'DONE',
      sensorApplyYn: 'N',
      lineCode: 'L1',
    };
    query.mockImplementation((sql: string) =>
      Promise.resolve(sql.includes('LINE_DIVISION') ? [{ div: 'D' }] : [row]),
    );

    const res = await service.applySensor({ runNo: 'RUN-1', seqNo: '01' }, 7);

    expect(add).toHaveBeenCalledTimes(1);
    expect((add.mock.calls[0] as [Record<string, unknown>])[0]).toMatchObject({ qty: 25, source: 'MANUAL' });
    expect(res.sensorApplyYn).toBe('Y');
  });
});

describe('WorkResultService process-bound run cards', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const repository = { manager: { query, transaction } } as unknown as Repository<ProductWorkResult>;
  const service = new WorkResultService(repository, { add: jest.fn() } as unknown as AssemblyResultService);

  function managerFor(fixed: string | null) {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))')) return Promise.resolve([{ seq: '01' }]);
        if (sql.includes('SELECT LINE_CODE')) return Promise.resolve([{ lineCode: '34', workstageCode: fixed }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation((callback: (value: typeof manager) => unknown) => callback(manager));
    return manager;
  }

  beforeEach(() => {
    jest.clearAllMocks();
    query.mockResolvedValue([]);
  });

  it('list filters by process but keeps unassigned run cards', async () => {
    await service.list('2026-10-14', '2026-10-14', '34', undefined, 7, undefined, true, undefined, 'W091');
    const [sql, params] = query.mock.calls[0] as [string, unknown[]];
    expect(sql).toMatch(/\(r\.WORKSTAGE_CODE = :\d+ OR r\.WORKSTAGE_CODE IS NULL\)/);
    expect(params).toContain('W091');
  });

  it('rejects a result for a different process than the run card', async () => {
    const manager = managerFor('W091');
    await expect(service.upsertResult(
      { runNo: 'R1', machineCode: 'M1', workstageCode: 'W120', resultQty: 5, resultStatus: 'WIP' } as never, 7, 'U',
    )).rejects.toThrow('W091');
    expect(manager.query.mock.calls.some(([s]) => String(s).startsWith('INSERT INTO IP_PRODUCT_WORK_RESULT'))).toBe(false);
  });

  it('keeps a legacy run card without a process unassigned (only the machine is written back)', async () => {
    const manager = managerFor(null);
    await service.upsertResult(
      { runNo: 'R1', machineCode: 'M1', workstageCode: 'W091', resultQty: 5, resultStatus: 'WIP' } as never, 7, 'U',
    );
    const write = manager.query.mock.calls.find(([s]) => String(s).startsWith('UPDATE IP_PRODUCT_RUN_CARD'));
    expect(String(write?.[0])).toContain('SET MACHINE_CODE=:1 WHERE');
    expect(String(write?.[0])).not.toContain('WORKSTAGE_CODE');
  });
});

describe('WorkResultService machine downtime core', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const repository = { manager: { query, transaction } } as unknown as Repository<ProductWorkResult>;
  const service = new WorkResultService(repository, {} as unknown as AssemblyResultService);

  /** 설비 잠금·진행중 조회·채번에 답하는 트랜잭션 매니저 */
  function managerWith(opts: {
    locked: string[];
    open?: Array<{ machineCode: string; dtSeq: number; reasonCode: string | null }>;
    updateAffected?: number;
  }) {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('FROM IMCN_MACHINE m') && sql.includes('FOR UPDATE')) {
          return Promise.resolve(opts.locked.map((machineCode) => ({ machineCode, workstageCode: 'W040', lineCode: '04' })));
        }
        if (sql.includes('END_TIME IS NULL') && sql.startsWith('SELECT')) return Promise.resolve(opts.open ?? []);
        if (sql.includes('NEXTVAL')) return Promise.resolve([{ seq: 501 }]);
        if (sql.startsWith('UPDATE')) return Promise.resolve(opts.updateAffected ?? 1);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation((callback: (value: typeof manager) => unknown) => callback(manager));
    return manager;
  }
  const sqlOf = (manager: { query: jest.Mock }) => manager.query.mock.calls.map(([sql]) => String(sql));

  beforeEach(() => jest.clearAllMocks());

  it('locks only downtime-target machines (ES- code, in use, not TEMP) before starting', async () => {
    const manager = managerWith({ locked: ['ES-E-055'] });
    await service.bulkDowntime({ action: 'START', machineCodes: ['ES-E-055'], runNo: 'RUN-1' } as never, 1, 'U1');
    const lock = sqlOf(manager).find((sql) => sql.includes('FOR UPDATE')) ?? '';
    expect(lock).toContain("MACHINE_CODE LIKE 'ES-%'");
    expect(lock).toContain("<> 'TEMP'");
    const insert = manager.query.mock.calls.find(([sql]) => String(sql).includes('INSERT INTO IP_EQUIP_DOWNTIME_RESULT'));
    // 설비 · 작업지시 · 라인/공정(설비마스터) · 사유 · 시작시각만 — 동반정지 같은 구분은 없다
    expect(String(insert?.[0])).not.toContain('CAUSE_YN');
    expect(insert?.[1]).toEqual(['RUN-1', 501, 1, 'ES-E-055', 'W040', '04', null, null, null, 'U1']);
  });

  it('rejects a machine that is not a downtime target (old serial code row)', async () => {
    managerWith({ locked: [] });
    await expect(
      service.bulkDowntime({ action: 'START', machineCodes: ['HIT413H05'] } as never, 1, 'U1'),
    ).rejects.toThrow('비가동 대상 설비가 아닙니다');
  });

  it('skips machines already stopped on START instead of failing the batch', async () => {
    managerWith({ locked: ['ES-E-055', 'ES-E-058'], open: [{ machineCode: 'ES-E-055', dtSeq: 9, reasonCode: 'EB01' }] });
    await expect(
      service.bulkDowntime({ action: 'START', machineCodes: ['ES-E-055', 'ES-E-058'] } as never, 1, 'U1'),
    ).resolves.toEqual({ affected: 1, skipped: 1, targets: 2, skippedMachines: ['ES-E-055'] });
  });

  it('keeps the start reason on END when no new reason is given, but refuses when none exists', async () => {
    const manager = managerWith({ locked: ['ES-E-055'], open: [{ machineCode: 'ES-E-055', dtSeq: 9, reasonCode: 'EB01' }] });
    await service.bulkDowntime({ action: 'END', machineCodes: ['ES-E-055'] } as never, 1, 'U1');
    const update = sqlOf(manager).find((sql) => sql.startsWith('UPDATE')) ?? '';
    expect(update).toContain('NVL(:1, REASON_CODE)');
    expect(update).toContain('END_TIME IS NULL');

    managerWith({ locked: ['ES-E-055'], open: [{ machineCode: 'ES-E-055', dtSeq: 9, reasonCode: null }] });
    await expect(
      service.bulkDowntime({ action: 'END', machineCodes: ['ES-E-055'] } as never, 1, 'U1'),
    ).rejects.toThrow('종료 시 비가동 사유를 선택하세요');
  });

  it('refuses to end a downtime that another screen already closed', async () => {
    managerWith({ locked: ['ES-E-055'], open: [{ machineCode: 'ES-E-055', dtSeq: 9, reasonCode: 'EB01' }], updateAffected: 0 });
    await expect(
      service.bulkDowntime({ action: 'END', machineCodes: ['ES-E-055'] } as never, 1, 'U1'),
    ).rejects.toThrow('이미 종료된 비가동입니다');
  });

  it('locks the machine before checking for an open downtime on a single start', async () => {
    const manager = managerWith({ locked: ['ES-E-055'] });
    await service.bulkDowntime({ action: 'START', machineCodes: ['ES-E-055'] } as never, 1, 'U1');
    const sqls = sqlOf(manager);
    const lockAt = sqls.findIndex((sql) => sql.includes('FOR UPDATE'));
    const openAt = sqls.findIndex((sql) => sql.includes('END_TIME IS NULL'));
    expect(lockAt).toBeGreaterThanOrEqual(0);
    expect(lockAt).toBeLessThan(openAt);
  });
});
