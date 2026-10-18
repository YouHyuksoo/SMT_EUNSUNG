import { BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { WorkResultService } from './work-result.service';

/** 작업지시 · 라인구분 · 채번 · 상태 조회에 답하는 트랜잭션 매니저 */
function upsertManager(opts: { div?: string; fixed?: string | null; status?: string } = {}) {
  return {
    query: jest.fn().mockImplementation((sql: string) => {
      if (sql.includes('FROM IP_PRODUCT_RUN_CARD') && sql.includes('FOR UPDATE'))
        return Promise.resolve([{ lineCode: '50', workstageCode: opts.fixed ?? null, itemCode: 'E1', lotNo: 'MI1', runDate: '2026-10-19' }]);
      if (sql.includes('LINE_DIVISION')) return Promise.resolve([{ div: opts.div ?? 'L' }]);
      if (sql.includes('MAX(TO_NUMBER(SEQ_NO))')) return Promise.resolve([{ seq: '01' }]);
      if (sql.includes("SELECT NVL(RESULT_STATUS,'WIP')")) return Promise.resolve([{ st: opts.status ?? 'WIP' }]);
      if (sql.includes('SELECT WORKSTAGE_ISSUE_YN')) return Promise.resolve([{ flag: 'Y', msg: null }]);
      return Promise.resolve([]);
    }),
  };
}

describe('WorkResultService tenancy', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const dataSource = { manager: { query, transaction } } as unknown as DataSource;
  const service = new WorkResultService(dataSource);

  beforeEach(() => {
    jest.clearAllMocks();
    query.mockResolvedValue([]);
  });

  function useManager(manager: ReturnType<typeof upsertManager>) {
    transaction.mockImplementation((callback: (value: typeof manager) => unknown) => callback(manager));
    return manager;
  }

  it('refuses SMT line results — SMT actuals come from AOI', async () => {
    const manager = useManager(upsertManager({ div: 'D' }));
    await expect(service.upsertResult(
      { runNo: 'RUN-1', resultQty: 10, resultStatus: 'DONE' } as never, 7, 'user-7',
    )).rejects.toThrow('SMT');
    expect(manager.query.mock.calls.some(([s]) => String(s).includes('INSERT INTO IP_PRODUCT_RESULT'))).toBe(false);
  });

  it('keeps a non-assembly line result without inventory and marks it X', async () => {
    const manager = useManager(upsertManager({ div: 'W' }));

    const res = await service.upsertResult(
      { runNo: 'RUN-1', machineCode: 'MC-1', workstageCode: 'WS-1', resultQty: 10, resultStatus: 'DONE' } as never,
      7,
      'user-7',
    );

    expect(res).toEqual({ seqNo: '01', sensorApplyYn: 'X' });
    expect(manager.query.mock.calls.some(([s]) => String(s).includes('P_PRODUCT_RESULT_WIP'))).toBe(false);
    const marked = query.mock.calls.find(([sql]) => String(sql).includes('SET WORKSTAGE_ISSUE_YN=:1'));
    expect(marked?.[1]).toEqual(['X', null, 'RUN-1', '01', 7]);
    // 가공 라인 → 작업구분 W
    const insert = manager.query.mock.calls.find(([s]) => String(s).includes('INSERT INTO IP_PRODUCT_RESULT'));
    expect(insert?.[1]?.[2]).toBe('W');
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
    expect(sql).toContain('FROM IP_PRODUCT_RESULT wr');
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

  it('writes the run card product into IP_PRODUCT_RESULT with the authenticated user and organization', async () => {
    const manager = useManager(upsertManager());

    await service.upsertResult(
      {
        runNo: 'RUN-1',
        resultQty: 10,
        resultStatus: 'WIP',
        userId: 'forged-user',
      } as never,
      7,
      'authenticated-user',
    );

    const insertCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('INSERT INTO IP_PRODUCT_RESULT'),
    );
    const binds = insertCall?.[1] as unknown[];
    // [0]=org [1]=runDate [2]=workDivision [3]=item [4]=mfs(lot) [5]=line [6]=workstage [7]=machine [8]=qty
    // [9]=runNo [10]=seqNo ... [15]=user
    expect(binds[0]).toBe(7);
    expect(binds[2]).toBe('P');
    expect(binds[3]).toBe('E1');
    expect(binds[4]).toBe('MI1');
    // 공정이 빈 조립라인 지시 = 포장 공정
    expect(binds[6]).toBe('W220');
    expect(binds[7]).toBeNull();
    expect(binds[9]).toBe('RUN-1');
    expect(binds[10]).toBe('01');
    expect(binds).toContain('authenticated-user');
    expect(binds).not.toContain('forged-user');
    const runCardCall = manager.query.mock.calls.find(([sql]) => String(sql).includes('UPDATE IP_PRODUCT_RUN_CARD'));
    expect(runCardCall?.[1]?.[0]).toBeNull();
    // 공정은 발행 때 정해지고 실적이 런카드에 다시 쓰지 않는다
    expect(String(runCardCall?.[0])).not.toContain('WORKSTAGE_CODE');
  });

  it('normalizes whitespace equipment on an existing result update', async () => {
    const manager = useManager(upsertManager());

    await service.upsertResult(
      {
        runNo: 'RUN-1',
        seqNo: '01',
        machineCode: '   ',
        workstageCode: 'W220',
        resultQty: 10,
        resultStatus: 'WIP',
      },
      7,
      'user-7',
    );

    const updateCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('UPDATE IP_PRODUCT_RESULT SET'),
    );
    // [0]=machineCode(공백 정규화 → null), [1]=workstageCode
    expect(updateCall?.[1]?.[0]).toBeNull();
    expect(updateCall?.[1]?.[1]).toBe('W220');
  });

  it('does not move inventory for an in-progress result', async () => {
    useManager(upsertManager());

    const res = await service.upsertResult(
      { runNo: 'RUN-1', resultQty: 10, resultStatus: 'WIP' } as never,
      7,
      'user-7',
    );

    expect(res.sensorApplyYn).toBe('N');
    expect(transaction).toHaveBeenCalledTimes(1);
  });

  it('moves inventory once for a completed assembly line result', async () => {
    const manager = useManager(upsertManager());

    const res = await service.upsertResult(
      { runNo: 'RUN-1', machineCode: 'MC-1', resultQty: 10, resultStatus: 'DONE' } as never,
      7,
      'user-7',
    );

    const call = manager.query.mock.calls.find(([s]) => String(s).includes('P_PRODUCT_RESULT_WIP'));
    expect(call?.[1]).toEqual(['RUN-1', '01', 7, 1]);
    expect(res.sensorApplyYn).toBe('Y');
    expect(res.sensorWarning).toBeUndefined();
  });

  it('keeps the result and warns when the inventory step fails', async () => {
    const manager = upsertManager();
    let calls = 0;
    transaction.mockImplementation((callback: (value: typeof manager) => unknown) => {
      calls += 1;
      if (calls === 1) return callback(manager);
      return Promise.reject(new Error('ORA-01400: cannot insert NULL'));
    });

    const res = await service.upsertResult(
      { runNo: 'RUN-1', resultQty: 10, resultStatus: 'DONE' } as never,
      7,
      'user-7',
    );

    expect(res.sensorApplyYn).toBe('N');
    expect(res.sensorWarning).toContain('ORA-01400');
    // 반영 실패를 실적 행에 기록해 화면이 빨간색으로 표기할 수 있게 한다.
    const flagCall = query.mock.calls.find(([sql]) => String(sql).includes('SET WORKSTAGE_ISSUE_YN=:1'));
    expect(flagCall?.[1]?.[0]).toBe('N');
    expect(String(flagCall?.[1]?.[1])).toContain('ORA-01400');
  });

  it('refuses to re-apply a result already reflected in the inventory', async () => {
    query.mockResolvedValue([{ resultStatus: 'DONE', sensorApplyYn: 'Y', workDiv: 'P' }]);

    await expect(
      service.applySensor({ runNo: 'RUN-1', seqNo: '01' }, 7),
    ).rejects.toThrow(BadRequestException);
    expect(transaction).not.toHaveBeenCalled();
  });

  it('re-applies a completed assembly line result that has not been reflected yet', async () => {
    query.mockResolvedValue([{ resultStatus: 'DONE', sensorApplyYn: 'N', workDiv: 'P' }]);
    const manager = useManager(upsertManager());

    const res = await service.applySensor({ runNo: 'RUN-1', seqNo: '01' }, 7);

    expect(manager.query.mock.calls.some(([s]) => String(s).includes('P_PRODUCT_RESULT_WIP'))).toBe(true);
    expect(res.sensorApplyYn).toBe('Y');
  });

  it('keeps a processing-workstage result on an assembly line without inventory (W, X)', async () => {
    const manager = useManager(upsertManager({ fixed: 'W091' }));

    const res = await service.upsertResult(
      { runNo: 'RUN-1', workstageCode: 'W091', resultQty: 10, resultStatus: 'DONE' } as never, 7, 'user-7',
    );

    expect(res.sensorApplyYn).toBe('X');
    const insert = manager.query.mock.calls.find(([s]) => String(s).includes('INSERT INTO IP_PRODUCT_RESULT'));
    expect(insert?.[1]?.[2]).toBe('W');
    expect(manager.query.mock.calls.some(([s]) => String(s).includes('P_PRODUCT_RESULT_WIP'))).toBe(false);
  });

  it('refuses a different process than the packing process on an assembly work order without a process', async () => {
    useManager(upsertManager());
    await expect(service.upsertResult(
      { runNo: 'RUN-1', workstageCode: 'W040', resultQty: 10, resultStatus: 'WIP' } as never, 7, 'user-7',
    )).rejects.toThrow('W220');
  });

  it('reverts the inventory with sign -1 when a reflected result is cancelled', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('FOR UPDATE')) return Promise.resolve([{ st: 'DONE', applied: 'Y', today: 'Y' }]);
        if (sql.includes('SELECT WORKSTAGE_ISSUE_YN')) return Promise.resolve([{ flag: 'C', msg: null }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation((callback: (value: typeof manager) => unknown) => callback(manager));

    const res = await service.cancelResult({ runNo: 'RUN-1', seqNo: '01' } as never, 7, 'user-7');

    expect(res).toEqual({ cancelled: true });
    const cancel = manager.query.mock.calls.find(([s]) => String(s).includes("RESULT_STATUS='CANCEL'"));
    expect(String(cancel?.[0])).toContain("PRODUCT_ACTUAL_STATUS='C'");
    const call = manager.query.mock.calls.find(([s]) => String(s).includes('P_PRODUCT_RESULT_WIP'));
    expect(call?.[1]).toEqual(['RUN-1', '01', 7, -1]);
  });
});

describe('WorkResultService process-bound run cards', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const dataSource = { manager: { query, transaction } } as unknown as DataSource;
  const service = new WorkResultService(dataSource);

  function managerFor(fixed: string | null) {
    // 가공 라인(W) 지시 — 공정이 빈 예전 지시는 어느 공정 실적도 받는다
    const manager = upsertManager({ fixed, div: 'W' });
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
    expect(manager.query.mock.calls.some(([s]) => String(s).startsWith('INSERT INTO IP_PRODUCT_RESULT'))).toBe(false);
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
  const dataSource = { manager: { query, transaction } } as unknown as DataSource;
  const service = new WorkResultService(dataSource);

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
