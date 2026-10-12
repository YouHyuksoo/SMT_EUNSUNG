import { BadRequestException, NotFoundException } from '@nestjs/common';
import { normalizeLoops, RawBomService } from './raw-bom.service';
import type { RawBomUpdateDto } from '../dto/raw-bom.dto';

const dto = (over: Partial<RawBomUpdateDto> = {}): RawBomUpdateDto => ({
  parentItemCode: 'P1', childItemCode: 'C1', dateset: '2021-07-06',
  assyExplosionYn: 'Y', itemType: 'T', lineType: 'T',
  itemUnitQty: 1, itemUnitQtyExt: null, workstageCode: '*', sortSequence: 10, dateend: '9999-12-31',
  ...over,
});

function setup(updateResult: unknown) {
  const qr = { query: jest.fn().mockResolvedValue(updateResult) };
  const tx = { run: jest.fn((cb: (q: typeof qr) => unknown) => cb(qr)) };
  const dataSource = { query: jest.fn() };
  const service = new RawBomService(dataSource as never, tx as never);
  return { service, qr, dataSource };
}

describe('normalizeLoops', () => {
  it('회전된 같은 순환을 하나로 합치고 가장 작은 코드부터 시작한다', () => {
    const loops = normalizeLoops([
      'B > C > A > B',
      'A > B > C > A',
      'C > A > B > C',
      'Z > Z',
    ]);
    expect(loops).toEqual([
      { path: ['A', 'B', 'C', 'A'], length: 3 },
      { path: ['Z', 'Z'], length: 1 },
    ]);
  });
});

describe('RawBomService.update', () => {
  it('구조화 결과(useStructuredResult)로 1행 수정을 확인하고 날짜는 문자열로 바인드한다', async () => {
    const { service, qr } = setup({ affected: 1, raw: 1 });
    await expect(service.update(dto(), 1, 'user1')).resolves.toMatchObject({ updated: 1 });
    const [sql, binds, structured] = qr.query.mock.calls[0];
    expect(structured).toBe(true);
    expect(sql).toContain("DATESET = TO_DATE(:dateset, 'YYYY-MM-DD')");
    expect(binds).toMatchObject({ dateset: '2021-07-06', dateend: '9999-12-31', itemUnitQtyExt: null, userId: 'user1' });
  });

  it('0행이면 NotFound', async () => {
    const { service } = setup({ affected: 0 });
    await expect(service.update(dto(), 1, 'u')).rejects.toBeInstanceOf(NotFoundException);
  });

  it('종료일자가 시작일자보다 빠르면 DB 에 가지 않고 거부한다', async () => {
    const { service, qr } = setup({ affected: 1 });
    await expect(service.update(dto({ dateend: '2020-01-01' }), 1, 'u')).rejects.toBeInstanceOf(BadRequestException);
    expect(qr.query).not.toHaveBeenCalled();
  });
});

describe('RawBomService.findLoops', () => {
  it('itemCode 가 없으면 조직 전체 SQL, 있으면 대문자로 바꿔 품목 범위 SQL 을 쓴다', async () => {
    const { service, dataSource } = setup(null);
    dataSource.query.mockResolvedValue([{ cyclePath: 'A > B > A' }, { cyclePath: 'B > A > B' }]);
    const all = await service.findLoops({}, 1);
    expect(all).toEqual({ itemCode: null, loops: [{ path: ['A', 'B', 'A'], length: 2 }], total: 1 });
    expect(dataSource.query.mock.calls[0][1]).toEqual({ organizationId: 1 });

    dataSource.query.mockResolvedValueOnce([{ cnt: 3 }]).mockResolvedValueOnce([]);
    await service.findLoops({ itemCode: ' m1 ' }, 1);
    expect(dataSource.query.mock.calls[2][0]).toContain('START WITH P = :itemCode');
    expect(dataSource.query.mock.calls[2][1]).toEqual({ organizationId: 1, itemCode: 'M1' });
  });

  it('BOM 에 없는 품목코드면 순환 없음 대신 400 을 낸다', async () => {
    const { service, dataSource } = setup(null);
    dataSource.query.mockResolvedValueOnce([{ cnt: 0 }]);
    await expect(service.findLoops({ itemCode: 'M1590' }, 1)).rejects.toBeInstanceOf(BadRequestException);
    expect(dataSource.query).toHaveBeenCalledTimes(1);
  });
});
