import { affectedRows } from './affected-rows.util';

describe('affectedRows', () => {
  it('TypeORM Oracle query() 기본 반환(행수 숫자)을 그대로 읽는다', () => {
    expect(affectedRows(1)).toBe(1);
    expect(affectedRows(3)).toBe(3);
  });

  it('0행이면 TypeORM 이 undefined 를 주므로 0 으로 읽는다', () => {
    expect(affectedRows(undefined)).toBe(0);
    expect(affectedRows(null)).toBe(0);
  });

  it('oracledb execute 결과와 TypeORM 구조화 결과도 읽는다', () => {
    expect(affectedRows({ rowsAffected: 2 })).toBe(2);
    expect(affectedRows({ affected: 4 })).toBe(4);
    expect(affectedRows({})).toBe(0);
  });
});
