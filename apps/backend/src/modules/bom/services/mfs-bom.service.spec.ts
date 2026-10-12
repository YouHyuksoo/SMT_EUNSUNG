import { BadRequestException } from '@nestjs/common';
import { MfsBomService, MFS_COPY_INSERT_SQL, MFS_GENERATE_INSERT_SQL } from './mfs-bom.service';

/** qr.query 를 호출 순서대로 응답하는 목 */
function setup(responses: unknown[]) {
  const queue = [...responses];
  const qr = { query: jest.fn(async () => queue.shift()) };
  const tx = { run: jest.fn((cb: (q: typeof qr) => unknown) => cb(qr)) };
  const dataSource = { query: jest.fn() };
  const service = new MfsBomService(dataSource as never, tx as never);
  return { service, qr };
}
const sqlOf = (qr: { query: jest.Mock }, i: number) => String(qr.query.mock.calls[i][0]);

describe('MfsBomService.generate', () => {
  const dto = { itemCode: 'M1', mfs: 'A1', showHide: 'Y' as const };

  it('승인된 행이 있으면 전개 함수를 부르지 않고 거부한다', async () => {
    const { service, qr } = setup([[{ cnt: 3 }]]);
    await expect(service.generate(dto, 1, 'u')).rejects.toBeInstanceOf(BadRequestException);
    expect(qr.query).toHaveBeenCalledTimes(1);
  });

  it('전개 결과가 -100 이면 유효한 설계BOM 없음', async () => {
    const { service, qr } = setup([[{ cnt: 0 }], { sid: -100 }]);
    await expect(service.generate(dto, 1, 'u')).rejects.toThrow('유효한 설계BOM이 없습니다');
    expect(sqlOf(qr, 1)).toContain('PKG_DESIGN.BOM_QUERY_ALL(');
  });

  it('showHide=N 이면 BOM_QUERY, 이후 삭제→INSERT→PCB B/T→임시행 삭제 순서로 실행하고 INSERT 행수를 돌려준다', async () => {
    const { service, qr } = setup([
      [{ cnt: 0 }], { sid: 77 }, { affected: 0 }, { affected: 12 }, { affected: 0 }, { affected: 0 }, { affected: 12 },
    ]);
    await expect(service.generate({ ...dto, showHide: 'N' }, 1, 'u1')).resolves.toEqual({ itemCode: 'M1', mfs: 'A1', inserted: 12 });
    expect(sqlOf(qr, 1)).toContain('PKG_DESIGN.BOM_QUERY(');
    expect(sqlOf(qr, 2)).toContain('DELETE FROM ID_MFS_BOM');
    expect(sqlOf(qr, 3)).toBe(MFS_GENERATE_INSERT_SQL);
    expect(qr.query.mock.calls[3][1]).toMatchObject({ sid: 77, showHide: 'N', userId: 'u1', org: 1 });
    expect(qr.query.mock.calls[4][1]).toMatchObject({ pcbItem: 'B' });
    expect(qr.query.mock.calls[5][1]).toMatchObject({ pcbItem: 'T' });
    expect(sqlOf(qr, 6)).toContain('DELETE FROM ID_ENG_BOM_TEMP');
  });
});

describe('MfsBomService.copy', () => {
  const dto = { itemCode: 'M1', sourceMfs: 'A1', destMfs: 'A2' };

  it('원본이 없으면 거부', async () => {
    const { service } = setup([[{ cnt: 0 }]]);
    await expect(service.copy(dto, 1, 'u')).rejects.toThrow('A1 제조BOM이 없습니다');
  });

  it('대상에 행이 있으면 거부 (PB 는 중복 INSERT 했다)', async () => {
    const { service, qr } = setup([[{ cnt: 5 }], [{ cnt: 2 }]]);
    await expect(service.copy(dto, 1, 'u')).rejects.toThrow('이미 있습니다');
    expect(qr.query).toHaveBeenCalledTimes(2);
  });

  it('원본과 대상이 같으면 DB 에 가지 않고 거부', async () => {
    const { service, qr } = setup([]);
    await expect(service.copy({ ...dto, destMfs: 'A1' }, 1, 'u')).rejects.toBeInstanceOf(BadRequestException);
    expect(qr.query).not.toHaveBeenCalled();
  });

  it('정상이면 복사 INSERT 행수를 돌려준다', async () => {
    const { service, qr } = setup([[{ cnt: 5 }], [{ cnt: 0 }], { affected: 5 }]);
    await expect(service.copy(dto, 1, 'u')).resolves.toMatchObject({ inserted: 5 });
    expect(sqlOf(qr, 2)).toBe(MFS_COPY_INSERT_SQL);
  });
});

describe('MfsBomService.drop / unconfirm', () => {
  it('승인된 MFS 는 삭제할 수 없다', async () => {
    const { service, qr } = setup([[{ cnt: 1 }]]);
    await expect(service.drop({ itemCode: 'M1', mfs: 'A1' }, 1)).rejects.toThrow('승인');
    expect(qr.query).toHaveBeenCalledTimes(1);
  });

  it('승인취소는 USED_YN 조건 없이 MFS 전체 행을 되돌린다', async () => {
    const { service, qr } = setup([{ affected: 4 }]);
    await expect(service.unconfirm({ itemCode: 'M1', mfs: 'A1' }, 1, 'u')).resolves.toMatchObject({ updated: 4 });
    expect(sqlOf(qr, 0)).not.toContain('USED_YN');
    expect(sqlOf(qr, 0)).toContain("CONFIRM_YN = 'N', CONFIRM_DATE = NULL, CONFIRM_BY = NULL");
  });

  it('대상 행이 없으면 거부', async () => {
    const { service } = setup([{ affected: 0 }]);
    await expect(service.confirm({ itemCode: 'M1', mfs: 'X' }, 1, 'u')).rejects.toThrow('X 제조BOM이 없습니다');
  });
});
