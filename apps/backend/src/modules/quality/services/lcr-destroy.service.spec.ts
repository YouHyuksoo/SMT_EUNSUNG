import { readFileSync } from 'fs';
import { join } from 'path';
import type { DataSource } from 'typeorm';
import type { TransactionService } from '../../../shared/transaction.service';
import { LcrDestroyService } from './lcr-destroy.service';

// 사용자 지시: "LCR 폐기도 취소로 바꿔줘" — 지우지 않고 취소로 남긴다
describe('LcrDestroyService 취소', () => {
  const setup = (...results: unknown[]) => {
    const qr = { query: jest.fn() };
    for (const result of results) qr.query.mockResolvedValueOnce(result);
    qr.query.mockResolvedValue([]);
    const tx = { run: (cb: (q: typeof qr) => Promise<unknown>) => cb(qr) } as unknown as TransactionService;
    const dataSource = { query: jest.fn().mockResolvedValue([]) };
    const service = new LcrDestroyService(dataSource as unknown as DataSource, tx);
    return { qr, service, dataSource };
  };

  it('서비스 SQL 에 DELETE 가 없다', () => {
    const source = readFileSync(join(__dirname, 'lcr-destroy.service.ts'), 'utf8');
    expect(source).not.toMatch(/DELETE\s+FROM/i);
  });

  it('취소일시·취소자·사유를 남기고 CANCEL_YN 을 Y 로 바꾼다', async () => {
    const { qr, service } = setup([{ cancelYn: 'N' }]);
    await expect(service.cancel(3, ' 품번 잘못 ', 1, 'U')).resolves.toEqual({ lcrSeq: 3, cancelYn: 'Y' });
    expect(String(qr.query.mock.calls[0][0])).toContain('FOR UPDATE');
    expect(String(qr.query.mock.calls[1][0])).toMatch(/SET CANCEL_YN = 'Y', CANCEL_DATE = SYSDATE, CANCEL_BY = :userId, CANCEL_REASON = :reason/);
    expect(qr.query.mock.calls[1][1]).toEqual({ lcrSeq: 3, organizationId: 1, userId: 'U', reason: '품번 잘못' });
  });

  it('이미 취소된 건은 다시 취소하지 않는다', async () => {
    const { qr, service } = setup([{ cancelYn: 'Y' }]);
    await expect(service.cancel(3, 'x', 1, 'U')).rejects.toThrow('이미 취소된 등록입니다');
    expect(qr.query).toHaveBeenCalledTimes(1);
  });

  it('월별 누계는 취소된 등록을 뺀다', async () => {
    const { service, dataSource } = setup();
    await service.monthly({ year: '2026' }, 1);
    expect(String(dataSource.query.mock.calls[0][0])).toContain("d.CANCEL_YN = 'N'");
  });
});
