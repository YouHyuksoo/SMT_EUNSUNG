import { classifyFgRows } from './fg-stocktake.service';
import { fgCloseAggregateSql, fgEnding } from './fg-close.service';

const inCheck = (rn: number, barcode: string, loc: string, book: number) => ({
  rn, barcode, checkLocation: loc, bookQty: book, scannedYn: 'N',
  packBarcode: barcode, packType: 'C', modelName: 'M1', modelSuffix: '*', itemCode: 'E1', packQty: 72,
});
const packOnly = (rn: number, barcode: string, packQty: number | null) => ({
  rn, barcode, checkLocation: null, bookQty: null, scannedYn: null,
  packBarcode: barcode, packType: 'C', modelName: 'M2', modelSuffix: '*', itemCode: 'E2', packQty,
});

describe('classifyFgRows', () => {
  it('실사표에 있는 박스는 수량을 비우면 장부 수량으로 센다', () => {
    const { entries, errors } = classifyFgRows(
      [{ rn: 1, barcode: 'B1', qty: null, locationCode: null }],
      [inCheck(1, 'B1', 'P01', 72)],
    );
    expect(errors).toEqual([]);
    expect(entries).toEqual([expect.objectContaining({ barcode: 'B1', locationCode: 'P01', qty: 72, inCheck: true })]);
  });

  it('쓰다 만 박스는 넣은 수량으로 센다', () => {
    const { entries } = classifyFgRows(
      [{ rn: 1, barcode: 'B1', qty: 30, locationCode: null }],
      [inCheck(1, 'B1', 'P01', 72)],
    );
    expect(entries[0].qty).toBe(30);
  });

  it('같은 박스가 두 로케이션에 있으면 로케이션을 준 쪽, 안 주면 장부 수량이 큰 쪽', () => {
    const resolved = [inCheck(1, 'B1', 'P02', 10), inCheck(1, 'B1', 'P01', 72)];
    expect(classifyFgRows([{ rn: 1, barcode: 'B1', qty: null, locationCode: null }], resolved).entries[0].locationCode).toBe('P01');
    expect(classifyFgRows([{ rn: 1, barcode: 'B1', qty: null, locationCode: 'P02' }], resolved).entries[0].locationCode).toBe('P02');
  });

  it('장부에 없는 박스는 박스 마스터 수량으로 P01 에 새로 넣고, 수량을 모르면 거절한다', () => {
    const ok = classifyFgRows([{ rn: 1, barcode: 'N1', qty: null, locationCode: null }], [packOnly(1, 'N1', 50)]);
    expect(ok.entries[0]).toEqual(expect.objectContaining({ locationCode: 'P01', qty: 50, inCheck: false, modelName: 'M2' }));
    const bad = classifyFgRows([{ rn: 1, barcode: 'N1', qty: null, locationCode: null }], [packOnly(1, 'N1', null)]);
    expect(bad.entries).toEqual([]);
    expect(bad.errors[0].reason).toContain('수량');
  });

  it('등록 안 된 바코드·빈 바코드·잘못된 수량·파일 안 중복을 오류로 돌려준다', () => {
    const { entries, errors } = classifyFgRows(
      [
        { rn: 1, barcode: 'X', qty: null, locationCode: null },
        { rn: 2, barcode: null, qty: 1, locationCode: null },
        { rn: 3, barcode: 'B1', qty: -1, locationCode: null },
        { rn: 4, barcode: 'B1', qty: null, locationCode: null },
        { rn: 5, barcode: 'B1', qty: null, locationCode: null },
      ],
      [{ rn: 1, barcode: 'X' }, inCheck(4, 'B1', 'P01', 72), inCheck(5, 'B1', 'P01', 72)],
    );
    expect(entries).toHaveLength(1);
    expect(errors.map((e) => e.row)).toEqual([1, 2, 3, 5]);
  });
});

describe('fg close', () => {
  it('기말 = 기초 + 입고 − 출고 + 조정', () => {
    expect(fgEnding({ openingQty: 100, receiptQty: 50, issueQty: 30, adjustQty: -5 })).toBe(115);
  });

  it('첫 마감은 직전 마감 기말을 읽지 않고, 이후 마감은 읽는다', () => {
    expect(fgCloseAggregateSql(true)).not.toContain('IP_PRODUCT_FG_INV_CLOSE');
    expect(fgCloseAggregateSql(false)).toContain(':prevYyyymm');
  });
});

describe('FgStocktakeService.adjustAll', () => {
  /** 쿼리 순서: 마감 확인 → 조정 대상 → 재고 MERGE → 조정 INSERT → (새 박스면) 입고표시 UPDATE */
  const run = async (targets: Record<string, unknown>[]) => {
    const sqls: { sql: string; params: unknown }[] = [];
    const qr = {
      query: jest.fn(async (sql: string, params?: unknown) => {
        sqls.push({ sql, params });
        if (/IP_PRODUCT_FG_INV_CLOSE_MONTH/.test(sql)) return [{ n: 0 }];
        if (/FROM IP_PRODUCT_FG_INV_CHECK c/.test(sql)) return targets;
        return [];
      }),
    };
    const tx = { run: (cb: (q: typeof qr) => unknown) => cb(qr) };
    const { FgStocktakeService } = await import('./fg-stocktake.service');
    const service = new FgStocktakeService({} as never, tx as never);
    await service.adjustAll('202610', 1, 'tester');
    return sqls.filter((s) => /UPDATE IP_PRODUCT_PACK_MASTER/.test(s.sql));
  };
  const target = (barcode: string, remaining: number, inInventory: 'Y' | 'N') => ({
    barcode, locationCode: 'P01', packType: 'C', modelName: 'M1', modelSuffix: '*', itemCode: 'E1',
    remaining, nowQty: inInventory === 'Y' ? 10 : 0, inInventory,
  });

  it('재고에 없던 박스를 조정으로 넣으면 포장 실적을 입고됨(RECEIPT_FLAG=Y)으로 바꾼다', async () => {
    const updates = await run([target('NEW1', 72, 'N'), target('OLD1', -5, 'Y')]);
    expect(updates).toHaveLength(1);
    expect(updates[0].sql).toMatch(/SET RECEIPT_FLAG = 'Y'[\s\S]*RECEIPT_FLAG = 'N'/);
    expect(JSON.stringify(updates[0].params)).toContain('NEW1');
    expect(JSON.stringify(updates[0].params)).not.toContain('OLD1');
  });

  it('재고에 있던 박스만 조정하면 포장 실적을 건드리지 않는다', async () => {
    expect(await run([target('OLD1', 3, 'Y')])).toHaveLength(0);
  });
});
