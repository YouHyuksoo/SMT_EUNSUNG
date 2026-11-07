import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const source = readFileSync(resolve(import.meta.dirname, '2026-11-05_iq_equip_inspect_result_time_zone.sql'), 'utf8');
const compact = source.replace(/\s+/g, ' ').trim();

test('inspect time zone migration is an anonymous block that checks the table and the column before adding', () => {
  assert.match(source, /^DECLARE\b/);
  assert.match(compact, /USER_TABLES WHERE TABLE_NAME = 'IQ_EQUIP_INSPECT_RESULT'/);
  assert.match(compact, /USER_TAB_COLUMNS WHERE TABLE_NAME = 'IQ_EQUIP_INSPECT_RESULT' AND COLUMN_NAME = 'TIME_ZONE'/);
  assert.match(compact, /ADD \(TIME_ZONE VARCHAR2\(2\)\)/);
});

test('inspect time zone migration does not backfill old rows', () => {
  assert.doesNotMatch(compact, /UPDATE IQ_EQUIP_INSPECT_RESULT/);
});
