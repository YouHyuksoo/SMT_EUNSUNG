import { readFileSync } from 'fs';
import { join } from 'path';
import type { DataSource } from 'typeorm';
import type { TransactionService } from '../../../shared/transaction.service';
import { ProductDestroyService } from './product-destroy.service';
import type { ProductDestroyExecuteDto } from '../dto/product-destroy.dto';

const setup = (...results: unknown[]) => {
  const qr = { query: jest.fn() };
  for (const result of results) qr.query.mockResolvedValueOnce(result);
  qr.query.mockResolvedValue([]);
  const tx = { run: (cb: (q: typeof qr) => Promise<unknown>) => cb(qr) } as unknown as TransactionService;
  const service = new ProductDestroyService({} as DataSource, tx);
  const sqls = () => qr.query.mock.calls.map(([sql]) => String(sql));
  return { qr, service, sqls };
};

// 사용자 지시: "WORK_QC 는 수리판정일 뿐이고 폐기이력은 따로 재고처럼 모아야"
describe('공정폐기는 원장 IP_PRODUCT_DESTROY 에만 쓴다', () => {
  it('서비스 SQL 에 수리판정 테이블 IP_PRODUCT_WORK_QC 가 다시 나오지 않는다', () => {
    const source = readFileSync(join(__dirname, 'product-destroy.service.ts'), 'utf8');
    const code = source.replace(/\/\*\*[\s\S]*?\*\//g, '').replace(/\/\/.*$/gm, '');
    expect(code).not.toMatch(/IP_PRODUCT_WORK_QC/);
  });

  it('시리얼 폐기를 원장에 폐기보관(D)으로 넣는다', async () => {
    const { qr, service, sqls } = setup(
      [], // 취소 안 된 폐기 없음
      [{ itemCode: 'I1', modelName: 'M1', modelSuffix: '*' }], // 2D 바코드
      [{ lineCode: '08', workstageCode: 'LOADER' }], // 공정이력
      [{ seq: 7 }], // SEQ_IP_PRODUCT_DESTROY
      [{ ownPrice: 100, bomPrice: null }], // 단가
    );
    const dto = {
      team: '1', badReasonCode: 'B1', productType: '1', shiftCode: 'A', causeBy: 'M', detectProcessCode: 'P1',
      worker: '홍길동', departmentCode: 'D1', serialNos: ['s1'], items: [],
    } as ProductDestroyExecuteDto;

    const result = await service.destroy(dto, 1, 'U');

    expect(result.ok).toBe(1);
    expect(sqls()[0]).toContain("DESTROY_STATUS <> 'C'");
    expect(sqls()[3]).toContain('SEQ_IP_PRODUCT_DESTROY.NEXTVAL');
    expect(sqls()[5]).toMatch(/^INSERT INTO IP_PRODUCT_DESTROY/);
    expect(sqls()[5]).toContain("SYSDATE, 'D'");
    expect(qr.query.mock.calls[5][1]).toMatchObject({ destroySeq: 7, serialNo: 'S1', qty: 1, unitPrice: 100, amount: 100 });
  });

  it('취소되지 않은 폐기가 있는 시리얼은 건너뛴다', async () => {
    const { service } = setup([{ destroySeq: 3 }]);
    const result = await service.destroy({
      team: '1', badReasonCode: 'B1', productType: '1', shiftCode: 'A', causeBy: 'M', detectProcessCode: 'P1',
      worker: 'W', departmentCode: 'D1', serialNos: ['S1'], items: [],
    } as ProductDestroyExecuteDto, 1, 'U');
    expect(result.skip).toBe(1);
  });
});

describe('ProductDestroyService.cancel — 지우지 않고 취소(C)로 남긴다', () => {
  it('취소일시·취소자·사유를 남기고 DELETE 하지 않는다', async () => {
    const { qr, service, sqls } = setup([{ destroySeq: 4 }]);

    const result = await service.cancel({ destroySeqs: [4, 4, 9], reason: ' 잘못 스캔 ' }, 1, 'U');

    expect(result).toEqual({ cancelled: 1, skipped: 1 });
    expect(sqls().some(sql => /DELETE/i.test(sql))).toBe(false);
    expect(sqls()[1]).toMatch(/SET DESTROY_STATUS = 'C', CANCEL_DATE = SYSDATE, CANCEL_BY = :userId/);
    expect(sqls()[1]).toContain("DESTROY_STATUS <> 'C'");
    expect(qr.query.mock.calls[1][1]).toEqual({ organizationId: 1, seq0: 4, seq1: 9, userId: 'U', reason: '잘못 스캔' });
    // 드라이버가 bind 객체를 바꾸므로 두 호출이 같은 객체를 쓰면 안 된다
    expect(qr.query.mock.calls[1][1]).not.toBe(qr.query.mock.calls[0][1]);
  });

  it('취소할 건이 없으면 UPDATE 하지 않는다', async () => {
    const { qr, service } = setup([]);
    await expect(service.cancel({ destroySeqs: [4], reason: 'x' }, 1, 'U')).rejects.toThrow('취소할 폐기 건이 없습니다');
    expect(qr.query).toHaveBeenCalledTimes(1);
  });
});

describe('ProductDestroyService 반품 / 반품취소', () => {
  it('폐기보관(D)만 반품(R)으로 바꾸고 반품일시·처리자를 남긴다', async () => {
    const { sqls, service } = setup([{ status: 'D' }]);
    await expect(service.issue({ destroySeq: 5 }, 1, 'U')).resolves.toEqual({ destroySeq: 5, destroyStatus: 'R' });
    expect(sqls()[1]).toContain("SET DESTROY_STATUS = 'R', RETURN_DATE = SYSDATE, RETURN_BY = :userId");
  });

  it('취소(C)된 건은 반품할 수 없다', async () => {
    const { service } = setup([{ status: 'C' }]);
    await expect(service.issue({ destroySeq: 5 }, 1, 'U')).rejects.toThrow('반품할 수 있는 폐기보관 건이 아닙니다');
  });

  it('반품취소는 R 을 D 로 되돌린다', async () => {
    const { sqls, service } = setup([{ status: 'R' }]);
    await service.issueCancel({ destroySeq: 5 }, 1, 'U');
    expect(sqls()[1]).toContain("SET DESTROY_STATUS = 'D', RETURN_DATE = NULL, RETURN_BY = NULL");
  });
});
