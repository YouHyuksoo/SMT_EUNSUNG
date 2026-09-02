import { BadRequestException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { ProductSensorActual } from '../../entities/product-sensor-actual.entity';
import { WorkResultService } from './work-result.service';

describe('WorkResultService tenancy', () => {
  const query = jest.fn();
  const transaction = jest.fn();
  const repository = {
    manager: { query, transaction },
  } as unknown as Repository<ProductSensorActual>;
  const service = new WorkResultService(repository);

  beforeEach(() => {
    jest.clearAllMocks();
    query.mockResolvedValue([]);
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

  it('uses the authenticated user and organization for writes', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('MAX(TO_NUMBER(SEQ_NO))'))
          return Promise.resolve([{ mx: 0 }]);
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

    // 2026-09-02: 실적 저장 테이블이 IP_PRODUCT_SENSOR_ACTUAL로 바뀌었다.
    const insertCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('INSERT INTO IP_PRODUCT_SENSOR_ACTUAL'),
    );
    expect(insertCall?.[1]).toContain(7);
    expect(insertCall?.[1]).toContain('authenticated-user');
    expect(insertCall?.[1]).not.toContain('forged-user');
  });

  it('binds null equipment and preserves the process when creating a result', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes('SEQ_PRODUCT_SENSOR.NEXTVAL'))
          return Promise.resolve([{ seq: 1 }]);
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
      String(sql).includes('INSERT INTO IP_PRODUCT_SENSOR_ACTUAL'),
    );
    const runCardCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('UPDATE IP_PRODUCT_RUN_CARD'),
    );
    expect(insertCall?.[1]?.[3]).toBeNull();
    expect(insertCall?.[1]?.[4]).toBe('WS-1');
    expect(runCardCall?.[1]?.[0]).toBeNull();
    expect(runCardCall?.[1]?.[1]).toBe('WS-1');
  });

  it('normalizes whitespace equipment on an existing result update', async () => {
    const manager = {
      query: jest.fn().mockImplementation((sql: string) => {
        if (sql.includes("SELECT NVL(IS_LAST_YN,'N')"))
          return Promise.resolve([{ st: 'N' }]);
        return Promise.resolve([]);
      }),
    };
    transaction.mockImplementation(
      (callback: (value: typeof manager) => unknown) => callback(manager),
    );

    await service.upsertResult(
      {
        runNo: 'RUN-1',
        seqNo: '1',
        machineCode: '   ',
        workstageCode: 'WS-1',
        resultQty: 10,
        resultStatus: 'WIP',
      },
      7,
      'user-7',
    );

    const sensorUpdateCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('UPDATE IP_PRODUCT_SENSOR_ACTUAL SET'),
    );
    const runCardCall = manager.query.mock.calls.find(([sql]) =>
      String(sql).includes('UPDATE IP_PRODUCT_RUN_CARD'),
    );
    expect(sensorUpdateCall?.[1]?.[0]).toBeNull();
    expect(sensorUpdateCall?.[1]?.[1]).toBe('WS-1');
    expect(runCardCall?.[1]?.[0]).toBeNull();
    expect(runCardCall?.[1]?.[1]).toBe('WS-1');
  });
});
