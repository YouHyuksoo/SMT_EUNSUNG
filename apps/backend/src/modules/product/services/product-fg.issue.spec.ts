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
    expect(String(qr.query.mock.calls[0][0])).toContain('P_PRODUCT_FG_ISSUE');
    expect(shippingOrders.linkIssuedBox).toHaveBeenCalledWith(qr, 'DLV261020001', 'BOX1', 1, 'U');
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
