import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const source = readFileSync(resolve(import.meta.dirname, '2026-11-05_product_result_time_zone.sql'), 'utf8');
const compact = source.replace(/\s+/g, ' ').trim();

test('time zone migration is an anonymous block that checks the table and each column before adding', () => {
  assert.match(source, /^DECLARE\b/);
  assert.match(compact, /USER_TABLES WHERE TABLE_NAME = 'IP_PRODUCT_RESULT'/);
  assert.match(compact, /USER_TAB_COLUMNS[\s\S]*TABLE_NAME = 'IP_PRODUCT_RESULT' AND COLUMN_NAME = p_col/);
  assert.match(compact, /add_col\('TIME_ZONE', 'TIME_ZONE VARCHAR2\(2\)'\)/);
  assert.match(compact, /add_col\('ACTUAL_DATE', 'ACTUAL_DATE DATE'\)/);
});

test('time zone migration backfills ACTUAL_DATE only where it is empty and never touches SHIFT_CODE', () => {
  assert.match(compact, /SET ACTUAL_DATE = TRUNC\(PRODUCT_DATE\) WHERE ACTUAL_DATE IS NULL/);
  assert.doesNotMatch(compact, /ADD \([^)]*SHIFT_CODE/);
});
