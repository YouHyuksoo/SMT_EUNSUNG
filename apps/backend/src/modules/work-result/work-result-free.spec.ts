import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { IS_PUBLIC_KEY } from '../../common/decorators/public.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { WorkResultFreeController } from './work-result-free.controller';
import { FREE_RUN_MARK, WorkResultFreeService } from './work-result-free.service';
import type { FreeResultCreateDto } from './work-result-free.dto';
import type { WorkResultService } from './work-result.service';

const dto: FreeResultCreateDto = {
  lineCode: 'L2', workstageCode: 'W210', machineCode: 'ES-001', modelName: 'MODEL-A', itemCode: 'ITEM-A',
  timeZone: 'B', resultQty: 10, workTime: 30, workerCount: 2, workerName: '홍길동',
};

const ZONES = [
  { code: 'A', startTime: '0830', endTime: '1030' },
  { code: 'B', startTime: '1030', endTime: '1240' },
];

function build(queryImpl: (sql: string, params?: unknown[]) => unknown) {
  const query = jest.fn(async (sql: string, params?: unknown[]) => queryImpl(sql, params));
  const manager = { query, transaction: async (fn: (m: { query: typeof query }) => unknown) => fn({ query }) };
  const upsertResult = jest.fn().mockResolvedValue({ seqNo: '01', sensorApplyYn: 'X' });
  const cancelResult = jest.fn().mockResolvedValue({ cancelled: true });
  const service = new WorkResultFreeService(
    { manager } as never,
    { upsertResult, cancelResult } as unknown as WorkResultService,
  );
  return { service, query, upsertResult, cancelResult };
}

describe('WorkResultFreeController', () => {
  it('requires JwtAuthGuard and is not public', () => {
    expect(Reflect.getMetadata(IS_PUBLIC_KEY, WorkResultFreeController)).toBeFalsy();
    expect(Reflect.getMetadata(GUARDS_METADATA, WorkResultFreeController) ?? []).toContain(JwtAuthGuard);
  });
});

describe('WorkResultFreeService', () => {
  it('lists only recent-plan models without a search word and puts them first when searching', async () => {
    const { service, query } = build(() => [{ modelName: 'M' }]);
    await service.models(undefined, 7);
    await service.models('   ', 7);
    const first = String(query.mock.calls[0][0]);
    expect(first).toContain('IP_PRODUCT_MI_PLAN');
    expect(first).toContain(") - 3");
    expect(query.mock.calls[0][1]).toEqual([7]);
    expect(String(query.mock.calls[1][0])).not.toContain('LIKE');
    await service.models('aaf', 7);
    const search = String(query.mock.calls[2][0]);
    expect(search).toContain('LIKE :2');
    expect(search).toContain('ORDER BY CASE WHEN EXISTS');
    expect(query.mock.calls[2][1]).toEqual([7, '%AAF%', '%AAF%']);
  });

  it('rejects a time zone that is not registered in the work time ranges before saving anything', async () => {
    const { service, upsertResult } = build((sql) => (sql.includes('FROM ICOM_WORKTIME_RANGES') ? ZONES : []));
    await expect(service.createResult({ ...dto, timeZone: 'J' }, 7)).rejects.toBeInstanceOf(BadRequestException);
    expect(upsertResult).not.toHaveBeenCalled();
  });

  it('rejects a model that is not in the model master', async () => {
    const { service, upsertResult } = build((sql) => (sql.includes('IP_PRODUCT_MODEL_MASTER') ? [] : []));
    await expect(service.createResult(dto, 7)).rejects.toBeInstanceOf(BadRequestException);
    expect(upsertResult).not.toHaveBeenCalled();
  });

  it('reuses today run of the same line, workstage and model and syncs the plan to the result total', async () => {
    const { service, query, upsertResult } = build((sql) => {
      if (sql.includes('FROM ICOM_WORKTIME_RANGES')) return ZONES;
      if (sql.includes('IP_PRODUCT_MODEL_MASTER')) return [{ revision: 'A' }];
      if (sql.includes('MIN(RUN_NO)')) return [{ runNo: 'RUN-1' }];
      return [];
    });
    const res = await service.createResult(dto, 7, 'u1');
    expect(res.runNo).toBe('RUN-1');
    expect(upsertResult).toHaveBeenCalledWith(
      expect.objectContaining({ runNo: 'RUN-1', resultStatus: 'DONE', resultQty: 10, workerName: '홍길동' }), 7, 'u1',
    );
    expect(query.mock.calls.some(([sql]) => String(sql).includes('INSERT INTO IP_PRODUCT_RUN_CARD'))).toBe(false);
    // 선택한 타임구간(B)이 실적 저장에 같이 넘어간다
    expect(upsertResult.mock.calls[0][0]).toEqual(expect.objectContaining({ timeZone: 'B' }));
    const sync = query.mock.calls.find(([sql]) => String(sql).includes('SET LOT_SIZE = GREATEST(1'));
    expect(sync?.[1]).toEqual(['RUN-1', 7, FREE_RUN_MARK]);
  });

  it('creates the run when none exists and removes the empty run if the result save fails', async () => {
    const { service, query, upsertResult } = build((sql) => {
      if (sql.includes('FROM ICOM_WORKTIME_RANGES')) return ZONES;
      if (sql.includes('IP_PRODUCT_MODEL_MASTER')) return [{ revision: 'A' }];
      if (sql.includes('MIN(RUN_NO)')) return [{ runNo: null }];
      if (sql.includes('F_GET_NEW_RUN_NO')) return [{ runNo: 'RUN-NEW' }];
      return [];
    });
    upsertResult.mockRejectedValueOnce(new BadRequestException('공정이 없습니다'));
    await expect(service.createResult(dto, 7)).rejects.toBeInstanceOf(BadRequestException);
    const sqls = query.mock.calls.map(([sql]) => String(sql));
    expect(sqls.some((s) => s.includes('INSERT INTO IP_PRODUCT_RUN_CARD'))).toBe(true);
    expect(sqls.some((s) => s.startsWith('DELETE FROM IP_PRODUCT_RUN_CARD'))).toBe(true);
  });

  it('refuses to cancel a result of a run this screen did not create', async () => {
    const { service, cancelResult } = build(() => []);
    await expect(service.cancelResult({ runNo: 'PLANNED-1', seqNo: '01' }, 7)).rejects.toBeInstanceOf(NotFoundException);
    expect(cancelResult).not.toHaveBeenCalled();
  });

  it('cancels through the shared rule and re-syncs the plan', async () => {
    const { service, query, cancelResult } = build((sql) => (sql.startsWith('SELECT 1') ? [{ x: 1 }] : []));
    await service.cancelResult({ runNo: 'RUN-1', seqNo: '01' }, 7, 'u1');
    expect(cancelResult).toHaveBeenCalledWith({ runNo: 'RUN-1', seqNo: '01' }, 7, 'u1');
    expect(query.mock.calls.some(([sql]) => String(sql).includes('SET LOT_SIZE = GREATEST(1'))).toBe(true);
  });
});
