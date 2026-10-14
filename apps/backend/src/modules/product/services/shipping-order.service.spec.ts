import { BadRequestException, ConflictException } from '@nestjs/common';
import { ShippingOrderService, nextStatus, shipOrderNo } from './shipping-order.service';

/** SQL 정규식으로 응답을 고르는 query 모킹 */
const qr = (answers: Array<[RegExp, unknown]>) => {
  const query = jest.fn(async (sql: string) => {
    const hit = answers.find(([re]) => re.test(sql));
    return hit ? hit[1] : [];
  });
  return { query };
};

describe('ShippingOrderService', () => {
  const service = new ShippingOrderService({} as never, {} as never);
  const order = [{ modelName: 'M1', planQty: 100, actualQty: 90, planStatus: 'P' }];
  const box = (modelName: string, qty: number) => [{ modelName, qty }];

  it('numbers orders DLV + YYMMDD + 3 digits', () => {
    expect(shipOrderNo('2026-10-20', 7)).toBe('DLV261020007');
  });

  it('derives status from quantities', () => {
    expect(nextStatus(100, 0)).toBe('W');
    expect(nextStatus(100, 40)).toBe('P');
    expect(nextStatus(100, 100)).toBe('C');
  });

  it('links a shipped box: SHIP_NO on issue row and pack, adds ACTUAL_QTY', async () => {
    const r = qr([[/FOR UPDATE/, order], [/FROM IP_PRODUCT_PACK_MASTER/, box('M1', 10)]]);
    await service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U');
    const sqls = r.query.mock.calls.map(([s]) => String(s).trim());
    expect(sqls.some((s) => s.startsWith('UPDATE IP_PRODUCT_FG_ISSUE') && s.includes('SHIP_NO'))).toBe(true);
    expect(sqls.some((s) => s.startsWith('UPDATE IP_PRODUCT_PACK_MASTER') && s.includes('SHIP_NO'))).toBe(true);
    const upd = r.query.mock.calls.find(([s]) => String(s).trim().startsWith('UPDATE IP_PRODUCT_DELIVERY_PLAN'))!;
    expect(upd[1]).toMatchObject({ actualQty: 100, planStatus: 'C' });
  });

  it('rejects a box of another model', async () => {
    const r = qr([[/FOR UPDATE/, order], [/FROM IP_PRODUCT_PACK_MASTER/, box('M2', 10)]]);
    await expect(service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U')).rejects.toBeInstanceOf(BadRequestException);
  });

  it('rejects going over the order quantity', async () => {
    const r = qr([[/FOR UPDATE/, order], [/FROM IP_PRODUCT_PACK_MASTER/, box('M1', 20)]]);
    await expect(service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U')).rejects.toBeInstanceOf(ConflictException);
  });

  it('rejects a completed order', async () => {
    const r = qr([[/FOR UPDATE/, [{ ...order[0], actualQty: 100, planStatus: 'C' }]]]);
    await expect(service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U')).rejects.toBeInstanceOf(ConflictException);
  });

  it('unlinks a cancelled box: subtracts ACTUAL_QTY and recomputes status', async () => {
    const r = qr([[/FOR UPDATE/, [{ modelName: 'M1', planQty: 100, actualQty: 100, planStatus: 'C' }]], [/FROM IP_PRODUCT_PACK_MASTER/, box('M1', 10)]]);
    await service.unlinkCancelledBox(r as never, 'DLV261020001', 'BOX1', 1, 'U');
    const upd = r.query.mock.calls.find(([s]) => String(s).trim().startsWith('UPDATE IP_PRODUCT_DELIVERY_PLAN'))!;
    expect(upd[1]).toMatchObject({ actualQty: 90, planStatus: 'P' });
  });

  it('finds the order of a box only for DLV ship numbers', async () => {
    const r1 = qr([[/SHIP_NO/, [{ shipNo: 'DLV261020001' }]]]);
    await expect(service.shipOrderOfBox(r1 as never, 'BOX1', 1)).resolves.toBe('DLV261020001');
    const r2 = qr([[/SHIP_NO/, [{ shipNo: '20261013172415I868000000' }]]]);
    await expect(service.shipOrderOfBox(r2 as never, 'BOX1', 1)).resolves.toBeNull();
  });

  it('rejects a box shipped to another customer than the order', async () => {
    const r = qr([[/FOR UPDATE/, [{ ...order[0], customerCode: 'TS' }]], [/FROM IP_PRODUCT_PACK_MASTER/, box('M1', 10)]]);
    await expect(service.linkIssuedBox(r as never, 'DLV261020001', 'BOX1', 1, 'U', 'KY')).rejects.toBeInstanceOf(BadRequestException);
  });

  it('serializes order numbering with a table lock so two creates cannot take the same number', async () => {
    const r = qr([[/FROM IP_PRODUCT_MODEL_MASTER/, [{ modelSuffix: '*', itemCode: 'I1' }]], [/AS "seq"/, [{ seq: 1 }]], [/COUNT\(\*\)/, [{ cnt: 0 }]]]);
    const tx = { run: jest.fn(async (cb: (q: unknown) => unknown) => cb(r)) };
    const svc = new ShippingOrderService({} as never, tx as never);
    await svc.create({ planDate: '2026-10-20', customerCode: 'TS', modelName: 'M1', planQty: 10 }, 1, 'U');
    const sqls = r.query.mock.calls.map(([s]) => String(s).trim());
    const lockAt = sqls.findIndex((s) => s.startsWith('LOCK TABLE IP_PRODUCT_DELIVERY_PLAN'));
    const seqAt = sqls.findIndex((s) => s.includes('AS "seq"'));
    expect(lockAt).toBeGreaterThanOrEqual(0);
    expect(lockAt).toBeLessThan(seqAt);
  });

  it('refuses to delete an order that already shipped boxes', async () => {
    const tx = { run: jest.fn(async (cb: (q: unknown) => unknown) => cb(qr([[/FOR UPDATE/, order]]))) };
    const svc = new ShippingOrderService({} as never, tx as never);
    await expect(svc.remove('DLV261020001', 1)).rejects.toBeInstanceOf(ConflictException);
  });
});
