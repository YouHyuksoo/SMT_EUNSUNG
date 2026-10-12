/**
 * @file src/modules/popup-search/popup-search.contract.spec.ts
 * @description 팝업 카탈로그(@smt/shared) ↔ SQL 화이트리스트 정합성 계약
 *
 * 프론트 엔진은 카탈로그의 filters/columns 로 화면을 그리고, 백엔드는 같은 이름으로
 * 바인드·별칭을 만든다. 한쪽만 고치면 화면은 비고 필터는 안 먹는다. 그 드리프트를
 * 런타임이 아니라 여기서 잡는다.
 */
import { POPUP_CATALOG } from '@smt/shared';
import { POPUP_QUERIES, assertSelectOnly } from './popup-search.queries';
import { likePattern, toPositionalBinds } from './services/popup-search.service';

const engineEntries = POPUP_CATALOG.filter((entry) => entry.query);

describe('popup search contract', () => {
  it('카탈로그의 모든 query 에 SQL 정의가 있다', () => {
    for (const entry of engineEntries) {
      expect(POPUP_QUERIES[entry.query as string]).toBeDefined();
    }
  });

  it('SQL 정의에 대응하는 카탈로그 엔트리가 있다 (고아 SQL 금지)', () => {
    const queryNames = new Set(engineEntries.map((entry) => entry.query));
    for (const name of Object.keys(POPUP_QUERIES)) {
      expect(queryNames.has(name)).toBe(true);
    }
  });

  it('바인드 이름이 카탈로그 filters[].key 와 1:1 이다', () => {
    for (const entry of engineEntries) {
      const def = POPUP_QUERIES[entry.query as string];
      const filterKeys = (entry.filters ?? []).map((filter) => filter.key).sort();
      expect(Object.keys(def.binds).sort()).toEqual(filterKeys);
    }
  });

  it('모든 바인드가 SQL 안에서 실제로 쓰인다', () => {
    for (const [name, def] of Object.entries(POPUP_QUERIES)) {
      for (const bind of Object.keys(def.binds)) {
        expect(def.sql).toContain(`:${bind}`);
      }
      expect(def.sql).toContain(':organizationId');
      expect(name).toBeTruthy();
    }
  });

  it('카탈로그 columns[].key 가 SQL 별칭으로 존재한다', () => {
    for (const entry of engineEntries) {
      const def = POPUP_QUERIES[entry.query as string];
      for (const column of entry.columns ?? []) {
        expect(def.sql).toContain(`AS "${column.key}"`);
      }
    }
  });

  it('returnColumns 는 컬럼 목록 안에 있다', () => {
    for (const entry of engineEntries) {
      const keys = new Set((entry.columns ?? []).map((column) => column.key));
      for (const name of entry.returnColumns ?? []) {
        expect(keys.has(name)).toBe(true);
      }
    }
  });

  it('엔진 설정형 엔트리는 컬럼을 반드시 선언한다', () => {
    for (const entry of engineEntries) {
      expect((entry.columns ?? []).length).toBeGreaterThan(0);
    }
  });

  it('모든 SQL 이 SELECT 전용이다', () => {
    for (const [name, def] of Object.entries(POPUP_QUERIES)) {
      expect(() => assertSelectOnly(name, def)).not.toThrow();
    }
  });

  it('PB 창이 두 엔트리에 중복 매핑되지 않는다', () => {
    const seen = new Map<string, string>();
    for (const entry of POPUP_CATALOG) {
      for (const pbWindow of entry.pbWindows) {
        expect(seen.get(pbWindow)).toBeUndefined();
        seen.set(pbWindow, entry.id);
      }
    }
  });
});

describe('popup search binding', () => {
  it('코드 필터는 앞자리 LIKE, 명칭 필터는 부분 LIKE 로 만든다 (PB retrieve 인자와 동일)', () => {
    expect(likePattern('es001', 'prefix')).toBe('ES001%');
    expect(likePattern(' 코프 ', 'contains')).toBe('%코프%');
    expect(likePattern('A', 'exact')).toBe('A');
  });

  it('빈 값은 전체 조회 패턴이 된다', () => {
    expect(likePattern(undefined, 'prefix')).toBe('%');
    expect(likePattern('   ', 'contains')).toBe('%');
  });

  it('입력의 LIKE 와일드카드를 제거한다 (전체 조회로 새지 않게)', () => {
    expect(likePattern('%', 'prefix')).toBe('%');
    expect(likePattern('A%B', 'prefix')).toBe('AB%');
    expect(likePattern('A_B', 'contains')).toBe('%AB%');
  });

  it('명명 바인드를 위치 바인드로 바꾸고 값 순서를 맞춘다', () => {
    const result = toPositionalBinds(
      'SELECT * FROM T WHERE ORG = :organizationId AND C LIKE :code',
      { organizationId: 1, code: 'A%' },
    );
    expect(result.sql).toBe('SELECT * FROM T WHERE ORG = :1 AND C LIKE :2');
    expect(result.params).toEqual([1, 'A%']);
  });

  it('같은 바인드가 여러 번 나오면 같은 위치를 재사용한다', () => {
    const result = toPositionalBinds('SELECT :a, :b, :a FROM DUAL', { a: 'x', b: 'y' });
    expect(result.sql).toBe('SELECT :1, :2, :1 FROM DUAL');
    expect(result.params).toEqual(['x', 'y']);
  });

  it('값이 없는 바인드는 실행 전에 실패한다', () => {
    expect(() => toPositionalBinds('SELECT :missing FROM DUAL', {})).toThrow('바인드 값이 없습니다');
  });

  it('화이트리스트 SQL 의 모든 바인드가 값으로 채워진다', () => {
    for (const def of Object.values(POPUP_QUERIES)) {
      const values: Record<string, unknown> = { organizationId: 1, offset: 0, limit: 10 };
      for (const bind of Object.keys(def.binds)) values[bind] = '%';
      expect(() =>
        toPositionalBinds(
          `${def.sql} ORDER BY ${def.orderBy} OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
          values,
        ),
      ).not.toThrow();
    }
  });
});
