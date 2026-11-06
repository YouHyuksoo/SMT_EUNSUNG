import { ProductFgService } from './product-fg.service';

/** 출고와 출하지시 연결 — 같은 트랜잭션에서 프로시저 뒤에 박스를 지시에 잇는다 */
describe('ProductFgService.issue with a shipping order', () => {
  const qr = { query: jest.fn().mockResolvedValue([]) };
  const tx = { run: jest.fn(async (cb: (q: typeof qr) => unknown) => cb(qr)) };
  const shippingOrders = {
    linkIssuedBox: jest.fn(),
    unlinkCancelledBox: jest.fn(),
    shipOrderOfBox: jest.fn(),
  };
  const service = new ProductFgService({} as never, tx as never, shippingOrders as never);
  const base = { barcode: ' BOX1 ', customerCode: 'C1', locationCode: 'F01' };

  beforeEach(() => jest.clearAllMocks());

  it('links the shipped box to the order after the procedure, in the same transaction', async () => {
    await service.issue({ ...base, shipOrderNo: 'DLV261020001' }, 1, 'U');
    expect(qr.query.mock.calls.some(([sql]) => String(sql).includes('P_PRODUCT_FG_ISSUE'))).toBe(true);
    expect(shippingOrders.linkIssuedBox).toHaveBeenCalledWith(qr, 'DLV261020001', 'BOX1', 1, 'U', 'C1');
    expect(tx.run).toHaveBeenCalledTimes(1);
  });

  it('fails the whole issue when the box cannot be linked (transaction rolls back)', async () => {
    shippingOrders.linkIssuedBox.mockRejectedValueOnce(new Error('박스 모델이 다릅니다'));
    await expect(service.issue({ ...base, shipOrderNo: 'DLV261020001' }, 1, 'U')).rejects.toThrow('박스 모델');
  });

  it('on cancel, reads the order before the procedure and gives the quantity back after it', async () => {
    shippingOrders.shipOrderOfBox.mockResolvedValueOnce('DLV261020001');
    await service.issue({ ...base, cancel: true }, 1, 'U');
    const procCall = qr.query.mock.invocationCallOrder[0];
    expect(shippingOrders.shipOrderOfBox.mock.invocationCallOrder[0]).toBeLessThan(procCall);
    expect(shippingOrders.unlinkCancelledBox).toHaveBeenCalledWith(qr, 'DLV261020001', 'BOX1', 1, 'U');
  });

  it('issues without an order exactly as before', async () => {
    await service.issue(base, 1, 'U');
    expect(shippingOrders.linkIssuedBox).not.toHaveBeenCalled();
    expect(shippingOrders.shipOrderOfBox).not.toHaveBeenCalled();
  });
});

/** 제품 선입선출 — 환경설정 PRODUCT_FIFO_YN 이 Y 면 먼저 들어온 같은 모델 박스가 남았을 때 출하를 막는다 */
describe('ProductFgService.issue with product FIFO', () => {
  const config = (fifo: string) => [
    { name: 'PRODUCT_FIFO_YN', value: fifo },
    { name: 'PRODUCT_DEAD_STOCK_DAYS', value: '30' },
  ];
  const setup = (...results: unknown[]) => {
    const qr = { query: jest.fn() };
    for (const result of results) qr.query.mockResolvedValueOnce(result);
    qr.query.mockResolvedValue([]);
    const tx = { run: jest.fn(async (cb: (q: typeof qr) => unknown) => cb(qr)) };
    const shippingOrders = { linkIssuedBox: jest.fn(), unlinkCancelledBox: jest.fn(), shipOrderOfBox: jest.fn() };
    const service = new ProductFgService({} as never, tx as never, shippingOrders as never);
    const procCalls = () => qr.query.mock.calls.filter(([sql]) => String(sql).includes('P_PRODUCT_FG_ISSUE'));
    return { qr, service, procCalls };
  };
  const base = { barcode: 'BOX2', customerCode: 'C1', locationCode: 'P01' };

  it('rejects before the procedure when an older box of the same model is still in stock', async () => {
    const { qr, service, procCalls } = setup(
      config('Y'),
      [{ count: 2, oldestBarcode: 'BOX1', oldestDate: '2026-10-20 08:00' }],
    );
    await expect(service.issue(base, 1, 'U')).rejects.toThrow('선입선출: 먼저 들어온 같은 모델 박스 2개');
    expect(procCalls()).toHaveLength(0);
    const [fifoSql, fifoBinds] = qr.query.mock.calls[1];
    expect(fifoSql).toContain('o.INVENTORY_DATE < t.INVENTORY_DATE');
    expect(fifoSql).toContain('o.QTY > 0');
    expect(fifoBinds).toEqual({ barcode: 'BOX2', organizationId: 1, days: 30 });
  });

  it('ships when no older box is left', async () => {
    const { service, procCalls } = setup(config('Y'), [{ count: 0 }]);
    await service.issue(base, 1, 'U');
    expect(procCalls()).toHaveLength(1);
  });

  it('skips the check when PRODUCT_FIFO_YN is N', async () => {
    const { qr, service, procCalls } = setup(config('N'));
    await service.issue(base, 1, 'U');
    expect(qr.query.mock.calls.some(([sql]) => String(sql).includes('o.INVENTORY_DATE'))).toBe(false);
    expect(procCalls()).toHaveLength(1);
  });

  it('never checks FIFO on cancel', async () => {
    const { qr, service } = setup();
    await service.issue({ ...base, cancel: true }, 1, 'U');
    expect(qr.query.mock.calls.some(([sql]) => String(sql).includes('PRODUCT_FIFO_YN'))).toBe(false);
  });
});

/** 출하가능 목록 — 출하된 박스는 재고 행이 남고 QTY 만 0 이 되므로 남은 수량으로 거른다 */
describe('ProductFgService.findIssuable', () => {
  it('lists only boxes with quantity left', async () => {
    const dataSource = { query: jest.fn().mockResolvedValue([]) };
    const service = new ProductFgService(dataSource as never, {} as never, {} as never);
    await service.findIssuable({ dateFrom: '2026-10-27', dateTo: '2026-10-27' }, 1);
    expect(String(dataSource.query.mock.calls[0][0])).toContain('AND v.QTY > 0');
  });
});
