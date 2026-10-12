import type { DataSource } from 'typeorm';
import type { TransactionService } from '../../shared/transaction.service';
import { InventoryCheckService } from './inventory-check.service';

/** 조정 출고 INSERT 에 넘어간 바인드를 잡아 부호를 확인한다. */
async function adjust(differenceQty: number, closedMonth = false) {
  const calls: { sql: string; binds: Record<string, unknown> }[] = [];
  const qr = {
    query: jest.fn(async (sql: string, binds: Record<string, unknown>) => {
      calls.push({ sql, binds });
      if (sql.includes('ISYS_INVENTORY_CLOSE_DATE')) return closedMonth ? [{ closed: 1 }] : [];
      if (sql.includes('FROM IM_ITEM_INVENTORY v')) {
        return [{ inventoryType: 'R', lineType: 'R', locationCode: 'W1', inventoryPrice: 10, bookQty: 100 }];
      }
      return { rowsAffected: 1 };
    }),
  };
  const tx = { run: (cb: (q: typeof qr) => Promise<unknown>) => cb(qr) } as unknown as TransactionService;
  const service = new InventoryCheckService({} as DataSource, tx);
  const result = await service.adjustInventory(
    { yyyymm: '202610', itemCode: 'A', lotNo: 'L1', differenceQty },
    1,
    'tester',
  );
  const issue = calls.find((c) => c.sql.includes('INSERT INTO IM_ITEM_ISSUE'))!;
  const barcode = calls.find((c) => c.sql.includes('UPDATE IM_ITEM_RECEIPT_BARCODE'))!;
  return { result, issue, barcode };
}

describe('adjustInventory — 차이(실사 − 장부)와 조정 출고 부호', () => {
  it('실제가 적으면(차이 −5) 출고 +5, 구분 3 — 재고가 준다', async () => {
    const { result, issue, barcode } = await adjust(-5);
    expect(issue.binds.outQty).toBe(5);
    expect(issue.binds.deficit).toBe('3');
    expect(result.issueDeficit).toBe(3);
    expect(barcode.sql).toContain("ISSUE_COMPARE_YN   = 'Y'");
  });

  it('실제가 많으면(차이 +3) 출고 −3, 구분 4 — 재고가 는다', async () => {
    const { result, issue, barcode } = await adjust(3);
    expect(issue.binds.outQty).toBe(-3);
    expect(issue.binds.deficit).toBe('4');
    expect(result.issueDeficit).toBe(4);
    expect(barcode.sql).toContain("ISSUE_RETURN_YN    = 'Y'");
  });

  it('마감된 달은 조정을 거절한다', async () => {
    await expect(adjust(-5, true)).rejects.toThrow('마감된 달');
  });
});
