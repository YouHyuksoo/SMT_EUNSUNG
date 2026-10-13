import { ConflictException } from '@nestjs/common';
import { PLAN_TABLES, PlanBaseService } from './plan-base.service';

/** 계획 제조번호(MFS) — 등록 때 'SMD'/'MI'||순번, 삭제는 그 번호의 롯트카드가 있을 때만 막는다 */
function serviceWith(query: jest.Mock) {
  const tx = { run: jest.fn(async (cb: (qr: { query: jest.Mock }) => unknown) => cb({ query })) };
  return new PlanBaseService({} as never, tx as never);
}

const filledDto = {
  planDate: '2026-10-13', planSequence: 500, lineCode: '01', modelName: 'M', modelSuffix: '*', planQty: 10,
  planPriority: 1, workstageCode: 'W010', itemCode: 'I', workOrderNo: 'WO1', pcbItem: 'T',
  masterModelName: 'M', productionType: 'P', mfsGroupNo: 'SMD500', shiftCode: 'A',
};

describe('PlanBaseService MFS', () => {
  it.each([
    ['smd', 'SMD500'],
    ['mi', 'MI500'],
  ] as const)('%s plan is created with MFS = prefix || sequence', async (kind, mfs) => {
    const query = jest.fn().mockResolvedValueOnce([{ CNT: 0 }]).mockResolvedValue([]);
    await serviceWith(query).create(PLAN_TABLES[kind], filledDto as never, 1, 'U');
    const insert = query.mock.calls.find(([sql]) => String(sql).startsWith('INSERT'))!;
    expect(String(insert[0])).toContain(':mfs');
    expect(insert[1]).toMatchObject({ mfs, planSequence: 500 });
  });

  it('refuses to delete a plan whose MFS is used by a lot card', async () => {
    const query = jest.fn()
      .mockResolvedValueOnce([{ MFS: 'SMD500' }])
      .mockResolvedValueOnce([{ RUN_NO: '01AXX' }]);
    await expect(serviceWith(query).remove(PLAN_TABLES.smd, { planDate: '2026-10-13', planSequence: 500 } as never, 1))
      .rejects.toBeInstanceOf(ConflictException);
    expect(String(query.mock.calls[1][0])).toContain('IP_PRODUCT_RUN_CARD');
    expect(query.mock.calls.some(([sql]) => String(sql).startsWith('DELETE'))).toBe(false);
  });

  it('deletes a plan whose MFS is set but has no lot card', async () => {
    const query = jest.fn()
      .mockResolvedValueOnce([{ MFS: 'MI500' }])
      .mockResolvedValueOnce([{ RUN_NO: null }])
      .mockResolvedValue([[], 1]);
    await serviceWith(query).remove(PLAN_TABLES.mi, { planDate: '2026-10-13', planSequence: 500 } as never, 1);
    expect(query.mock.calls.some(([sql]) => String(sql).includes('DELETE FROM IP_PRODUCT_MI_PLAN'))).toBe(true);
  });
});
