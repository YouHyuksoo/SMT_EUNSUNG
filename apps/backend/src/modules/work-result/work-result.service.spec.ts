import { BadRequestException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { ProductWorkResult } from '../../entities/product-work-result.entity';
import { OracleService } from '../../common/services/oracle.service';
import { WorkResultService } from './work-result.service';

describe('WorkResultService tenancy', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const callProcScalar = jest.fn();
  const repository = {
    manager: { query, transaction },
  } as unknown as Repository<ProductWorkResult>;
  const service = new WorkResultService(repository, {
    callProcScalar,
  } as unknown as OracleService);

  beforeEach(() => {
    jest.clearAllMocks();
    query.mockResolvedValue([]);
    callProcScalar.mockResolvedValue({ P_OUT: 'OK' });
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
    expect(params).toEqual([7, '2026-08-01', '2026-08-25']);
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
    expect(runCardCall?.[1]?.[1]).toBe('WS-1');
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
    expect(runCardCall?.[1]?.[1]).toBe('WS-1');
  });

  it('does not call the sensor procedure while the result is in progress', async () => {
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

    expect(callProcScalar).not.toHaveBeenCalled();
    expect(res.sensorApplyYn).toBe('N');
  });

  it('calls the sensor procedure once when the result is completed', async () => {
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

    expect(callProcScalar).toHaveBeenCalledTimes(1);
    const [procName, outDefs, inParams, options] = callProcScalar.mock.calls[0] as [
      string,
      unknown,
      Record<string, unknown>,
      Record<string, unknown>,
    ];
    expect(procName).toBe('P_INTERLOCK_SENSOR_ACTUAL_NEO');
    expect(outDefs).toEqual([{ name: 'P_OUT', type: 'STRING', maxSize: 1000 }]);
    // P_ACC_COUNT가 실적수량이고 P_COUNT는 1 고정이다 — 이름과 의미가 반대다.
    expect(inParams.P_ACC_COUNT).toBe(10);
    expect(inParams.P_COUNT).toBe(1);
    expect(inParams.P_LINE_CODE).toBe('L1');
    expect(inParams.P_MACHINE_CODE).toBe('MC-1');
    // autoCommit 없이는 프로시저의 DML이 롤백된다.
    expect(options).toEqual({ autoCommit: true });
    expect(res.sensorApplyYn).toBe('Y');
    expect(res.sensorWarning).toBeUndefined();
  });

  it('keeps the result and warns when the sensor procedure fails', async () => {
    callProcScalar.mockResolvedValue({ P_OUT: 'NG ACTIVE PLAN NOT FOUND. Line Code=[L1]' });
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
      { runNo: 'RUN-1', workstageCode: 'WS-1', resultQty: 10, resultStatus: 'DONE' } as never,
      7,
      'user-7',
    );

    expect(res.sensorApplyYn).toBe('N');
    expect(res.sensorWarning).toContain('NG ACTIVE PLAN NOT FOUND');
    // 반영 실패를 실적 행에 기록해 화면이 빨간색으로 표기할 수 있게 한다.
    const flagCall = query.mock.calls.find(([sql]) =>
      String(sql).includes('SET SENSOR_APPLY_YN'),
    );
    expect(flagCall?.[1]?.[0]).toBe('N');
    expect(String(flagCall?.[1]?.[1])).toContain('NG ACTIVE PLAN NOT FOUND');
  });

  it('refuses to re-apply a result already reflected in the sensor tables', async () => {
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
    expect(callProcScalar).not.toHaveBeenCalled();
  });

  it('re-applies a completed result that has not been reflected yet', async () => {
    query.mockResolvedValue([
      {
        workstageCode: 'WS-1',
        machineCode: 'MC-1',
        resultQty: 25,
        resultStatus: 'DONE',
        sensorApplyYn: 'N',
        lineCode: 'L1',
      },
    ]);

    const res = await service.applySensor({ runNo: 'RUN-1', seqNo: '01' }, 7);

    expect(callProcScalar).toHaveBeenCalledTimes(1);
    const [, , inParams] = callProcScalar.mock.calls[0] as [
      string,
      unknown,
      Record<string, unknown>,
    ];
    expect(inParams.P_ACC_COUNT).toBe(25);
    expect(res.sensorApplyYn).toBe('Y');
  });
});
