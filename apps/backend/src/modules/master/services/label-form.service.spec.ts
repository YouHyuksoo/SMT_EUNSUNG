import { LabelFormService } from './label-form.service';

/** 라벨 양식 파일 업로드·DML — 공용 트랜잭션으로 실행하고 파일은 BLOB 바인드로 넘긴다 */
describe('LabelFormService writes', () => {
  function serviceWith(affected: number) {
    const qr = { query: jest.fn().mockResolvedValue({ affected }) };
    const tx = { run: jest.fn(async (cb: (q: typeof qr) => unknown) => cb(qr)) };
    const dataSource = { createQueryRunner: jest.fn(), query: jest.fn() };
    return { service: new LabelFormService(dataSource as never, tx as never), qr, tx, dataSource };
  }

  it('uploads a .btw file as a BLOB bind inside TransactionService', async () => {
    const { service, qr, tx, dataSource } = serviceWith(1);
    const file = { buffer: Buffer.from('abc'), originalname: 'form.btw' };
    await expect(service.uploadFile({ modelName: 'M', labelFormNo: 1 } as never, 'syntax', file, 1, 'U')).resolves.toEqual({ size: 3, fileName: 'form.btw' });
    expect(tx.run).toHaveBeenCalledTimes(1);
    expect(dataSource.createQueryRunner).not.toHaveBeenCalled();
    const binds = qr.query.mock.calls[0][1] as Record<string, { val?: unknown; type?: unknown }>;
    expect(binds.content.val).toEqual(file.buffer);
    expect(binds.content.type).toBeDefined();
    expect(qr.query.mock.calls[0][2]).toBe(true);
  });

  it('reports a missing form when nothing was updated', async () => {
    const { service } = serviceWith(0);
    await expect(service.uploadFile({ modelName: 'M', labelFormNo: 1 } as never, 'image', { buffer: Buffer.from('x'), originalname: 'a.png' }, 1, 'U'))
      .rejects.toThrow('라벨 양식을 찾지 못했습니다');
  });
});
