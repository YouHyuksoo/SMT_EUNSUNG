import { BadRequestException, ConflictException } from '@nestjs/common';
import { LotCardService } from './lot-card.service';

const card = { runNo: 'R1', runDate: '2026-10-13', lineCode: 'L01', carrierSize: 4 };

describe('LotCardService start serial (PB cb_3 branches)', () => {
  const service = new LotCardService({} as never);

  it('KI: last carrier number × carrier size + 1, ignores the start-serial input', async () => {
    const query = jest.fn().mockResolvedValue([{ last: 25 }]);
    await expect(service.startSerial({ query }, card, { productClass: 'X', customerCode: 'KI' }, 500))
      .resolves.toBe(25 * 4 + 1);
    expect(String(query.mock.calls[0][0])).toContain('F_GET_MONTH_CODE2');
  });

  it('KI: refuses a carrier size below 2', async () => {
    const query = jest.fn();
    await expect(service.startSerial({ query }, { ...card, carrierSize: 1 }, { productClass: null, customerCode: 'KI' }, 0))
      .rejects.toBeInstanceOf(BadRequestException);
    expect(query).not.toHaveBeenCalled();
  });

  it('AT: next number after the 15-char label prefix, start-serial input wins', async () => {
    const query = jest.fn()
      .mockResolvedValueOnce([{ prefix: '2000011RBMSQAD2' }])
      .mockResolvedValueOnce([{ next: 7 }]);
    await expect(service.startSerial({ query }, card, { productClass: '2000011', customerCode: 'AT' }, 0)).resolves.toBe(7);
    expect(String(query.mock.calls[0][0])).toContain('F_GET_PCB_BARCODE_LABEL');

    query.mockResolvedValueOnce([{ prefix: 'P' }]).mockResolvedValueOnce([{ next: 7 }]);
    await expect(service.startSerial({ query }, card, { productClass: '2000011', customerCode: 'AT' }, 300)).resolves.toBe(300);
  });

  it('others: hex sequence after product class + YYMMDD', async () => {
    const query = jest.fn().mockResolvedValue([{ next: 12 }]);
    await expect(service.startSerial({ query }, card, { productClass: 'DN8', customerCode: 'TS' }, 0)).resolves.toBe(12);
    const sql = String(query.mock.calls[0][0]);
    expect(sql).toContain("'XXX'");
    expect(query.mock.calls[0][1]).toMatchObject({ productClass: 'DN8', runNo: 'R1' });
  });
});

describe('LotCardService.createPids guards', () => {
  const run = [{ runNo: 'R1', modelName: 'M', runDate: '2026-10-13', lotSize: 10, itemCode: 'I', parentItemCode: 'P', lineCode: 'L01', carrierSize: 2, lotNo: 'MFS' }];

  function serviceWith(query: jest.Mock) {
    const transaction = jest.fn(async (callback: (m: { query: jest.Mock }) => unknown) => callback({ query }));
    return new LotCardService({ transaction } as never);
  }

  it('asks before regenerating existing PIDs', async () => {
    const query = jest.fn().mockResolvedValueOnce(run).mockResolvedValueOnce([{ cnt: 1 }]);
    await expect(serviceWith(query).createPids('R1', {}, 1, 'U')).rejects.toBeInstanceOf(ConflictException);
    expect(query).toHaveBeenCalledTimes(2);
  });

  it('refuses to regenerate when a PID already went through a workstage', async () => {
    const query = jest.fn()
      .mockResolvedValueOnce(run)
      .mockResolvedValueOnce([{ cnt: 1 }])
      .mockResolvedValueOnce([{ cnt: 3 }]);
    await expect(serviceWith(query).createPids('R1', { regenerate: true }, 1, 'U')).rejects.toBeInstanceOf(ConflictException);
    expect(query.mock.calls.some(([sql]) => String(sql).startsWith('DELETE'))).toBe(false);
  });

  it('inserts lot-size rows through the DB serial/label functions', async () => {
    const query = jest.fn()
      .mockResolvedValueOnce(run)
      .mockResolvedValueOnce([{ cnt: 0 }])
      .mockResolvedValueOnce([{ productClass: 'DN8', customerCode: 'TS' }])
      .mockResolvedValueOnce([{ next: 5 }])
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([{ count: 10, firstSerial: 'A', lastSerial: 'B' }]);
    const result = await serviceWith(query).createPids('R1', {}, 1, 'U');
    const insert = query.mock.calls[4];
    expect(String(insert[0])).toContain('F_GET_PCB_BARCODE_SERIAL');
    expect(insert[1]).toMatchObject({ runNo: 'R1', serial: 5, lotSize: 10, userId: 'U', organizationId: 1 });
    expect(result).toMatchObject({ count: 10, startSerial: 5 });
  });
});

describe('LotCardService per-process run cards', () => {
  function serviceWith(query: jest.Mock) {
    const transaction = jest.fn(async (callback: (m: { query: jest.Mock }) => unknown) => callback({ query }));
    return new LotCardService({ transaction, query, manager: { query } } as never);
  }
  const miPlan = {
    planType: 'MI', mfs: 'MI20261014001', planDate: '2026-10-14', planSequence: 1, lineCode: '34',
    modelName: 'M', itemCode: 'I', itemName: null, parentItemCode: null, workOrderNo: 'WO1', pcbItem: null,
    masterModelName: 'M', mfsGroupNo: 'MI20261014001', shiftCode: 'A', productionType: 'P', customerCode: null,
    planStatus: 'W', planQty: 100, lotQty: 100, remainQty: 100,
  };

  it('refuses an MI run card without a process', async () => {
    const query = jest.fn();
    await expect(serviceWith(query).createFromPlan(
      { planType: 'MI', planDate: '2026-10-14', planSequence: 1, mfs: miPlan.mfs, productRunType: 'P' }, 1, 'U',
    )).rejects.toBeInstanceOf(BadRequestException);
    expect(query).not.toHaveBeenCalled();
  });

  const createDeps = (existingProcess: string | null) => jest.fn(async (sql: string) => {
    if (sql.includes('FROM IP_PRODUCT_MI_PLAN')) return [miPlan];
    if (sql.includes('AS "otherProcess"')) return [{ otherProcess: existingProcess }];
    if (sql.includes('FROM IP_PRODUCT_MODEL_MASTER')) return [{ cnt: 1, carrierSize: 2 }];
    if (sql.includes('F_GET_NEW_RUN_NO')) return [{ runNo: 'R9' }];
    if (sql.includes('SELECT COUNT(*) AS "cnt" FROM IP_PRODUCT_RUN_CARD WHERE RUN_NO')) return [{ cnt: 0 }];
    return [];
  });

  it('computes MI remaining quantity per plan (all run cards of the MFS) and stores WORKSTAGE_CODE', async () => {
    const query = createDeps(null);
    await serviceWith(query).createFromPlan(
      { planType: 'MI', planDate: '2026-10-14', planSequence: 1, mfs: miPlan.mfs, productRunType: 'P', workstageCode: 'W091' }, 1, 'U',
    );
    const plan = query.mock.calls.find(([s]) => String(s).includes('FROM IP_PRODUCT_MI_PLAN'))!;
    expect(String(plan[0])).not.toContain('WORKSTAGE_CODE');
    expect(plan[1]).not.toHaveProperty('workstageCode');
    const insert = query.mock.calls.find(([s]) => String(s).includes('INSERT INTO IP_PRODUCT_RUN_CARD ('))!;
    expect(String(insert[0])).toContain('WORKSTAGE_CODE');
    expect(insert[1]).toMatchObject({ workstageCode: 'W091' });
  });

  it('refuses an MI run card whose process differs from the process the plan was already issued to', async () => {
    const query = createDeps('W120');
    await expect(serviceWith(query).createFromPlan(
      { planType: 'MI', planDate: '2026-10-14', planSequence: 1, mfs: miPlan.mfs, productRunType: 'P', workstageCode: 'W091' }, 1, 'U',
    )).rejects.toBeInstanceOf(ConflictException);
    const check = query.mock.calls.find(([s]) => String(s).includes('AS "otherProcess"'))!;
    expect(check[1]).toMatchObject({ mfs: miPlan.mfs, workstageCode: 'W091' });
    expect(query.mock.calls.some(([s]) => String(s).includes('INSERT INTO IP_PRODUCT_RUN_CARD ('))).toBe(false);
  });

  it('MI plan list remaining quantity subtracts every run card of the plan', async () => {
    const query = jest.fn().mockResolvedValue([]);
    query.mockResolvedValueOnce([{ division: 'L' }]);
    await serviceWith(query).findPlans({ lineCode: '34', dateFrom: '2026-10-14', dateTo: '2026-10-14' }, 1);
    const sql = String(query.mock.calls[1][0]);
    expect(sql).toContain('WHERE rc.LOT_NO = p.MFS AND rc.ORGANIZATION_ID = p.ORGANIZATION_ID), 0) AS "remainQty"');
  });
});
