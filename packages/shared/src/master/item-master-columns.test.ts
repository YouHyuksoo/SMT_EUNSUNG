/**
 * @file packages/shared/src/master/item-master-columns.test.ts
 * @description 품목마스터 컬럼 목록 테스트.
 *
 * ID_ITEM 은 109개 컬럼이다 (2026-10-12 USER_TAB_COLUMNS 확인). 하나라도 빠지면
 * 등록창·그리드에서 그 컬럼이 사라지고, 키가 겹치면 두 컬럼이 한 칸에 묶인다.
 */
import { describe, expect, it } from 'vitest';
import {
  ITEM_MASTER_CASCADE_COLUMNS,
  ITEM_MASTER_COLUMNS,
  ITEM_MASTER_SECTIONS,
  itemMasterDefaults,
} from './item-master-columns';

describe('ITEM_MASTER_COLUMNS', () => {
  it('ID_ITEM 109개 컬럼이 한 번씩 있다', () => {
    expect(ITEM_MASTER_COLUMNS).toHaveLength(109);
    expect(new Set(ITEM_MASTER_COLUMNS.map((c) => c.column)).size).toBe(109);
    expect(new Set(ITEM_MASTER_COLUMNS.map((c) => c.key)).size).toBe(109);
  });

  it('코드 입력은 기준코드 그룹이 있고 모든 구역이 정의돼 있다', () => {
    const sections = new Set(ITEM_MASTER_SECTIONS.map((s) => s.key));
    for (const c of ITEM_MASTER_COLUMNS) {
      expect(sections.has(c.section)).toBe(true);
      if (c.input === 'code') expect(c.codeGroup).toBeTruthy();
    }
  });

  it('재고를 지우는 ROUTE_NO 는 고칠 수 없고, 연쇄 컬럼은 목록에 있다', () => {
    expect(ITEM_MASTER_COLUMNS.find((c) => c.column === 'ROUTE_NO')?.edit).toBe('never');
    for (const col of ITEM_MASTER_CASCADE_COLUMNS) {
      expect(ITEM_MASTER_COLUMNS.find((c) => c.column === col)?.edit).toBe('always');
    }
  });

  it('NOT NULL 컬럼은 기본값이 있거나 등록창에서 반드시 받는다', () => {
    const defaults = itemMasterDefaults('2026-10-12');
    const mustInput = ITEM_MASTER_COLUMNS
      .filter((c) => c.required && c.edit !== 'never' && defaults[c.key] === undefined)
      .map((c) => c.column)
      .sort();
    expect(mustInput).toEqual(['ITEM_CODE', 'ITEM_DIVISION', 'ITEM_NAME', 'LINE_TYPE']);
    expect(defaults.dateset).toBe('2026-10-12');
    expect(defaults.isSplittable).toBe('N');
  });
});
