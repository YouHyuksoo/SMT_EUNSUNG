import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const source = readFileSync(resolve(import.meta.dirname, '2026-11-06_purchase_book_opening.sql'), 'utf8');
const compact = source.replace(/\s+/g, ' ').trim();

test('purchase book opening migration creates the table only when USER_TABLES has none', () => {
  assert.match(source, /^DECLARE\b/);
  assert.match(compact, /USER_TABLES WHERE TABLE_NAME = 'IM_PURCHASE_BOOK_OPENING'/);
  assert.match(compact, /IF n = 0 THEN EXECUTE IMMEDIATE 'CREATE TABLE IM_PURCHASE_BOOK_OPENING/);
  assert.match(compact, /PRIMARY KEY \(ORGANIZATION_ID, BASE_DATE, ITEM_CODE\)/);
});

test('purchase book opening migration backfills optional columns on an existing table', () => {
  assert.match(compact, /USER_TAB_COLUMNS WHERE TABLE_NAME = 'IM_PURCHASE_BOOK_OPENING' AND COLUMN_NAME = p_col/);
  for (const col of ['BOOK_GROUP', 'ITEM_CLASS', 'UNIT_PRICE', 'ENTER_BY', 'ENTER_DATE']) {
    assert.match(compact, new RegExp(`ensure_col\\('${col}'`));
  }
});
