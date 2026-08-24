import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

const sql = readFileSync(new URL('./2026-08-12_process_workstage_lines.sql', import.meta.url), 'utf8').toUpperCase();
const compact = sql.replace(/\s+/g, ' ');

test('creates the tenant-scoped process line relation with ordered keys', () => {
  assert.match(compact, /CREATE TABLE IP_PRODUCT_WORKSTAGE_LINE/);
  assert.match(compact, /PRIMARY KEY \(ORGANIZATION_ID, WORKSTAGE_CODE, WORKSTAGE_TYPE, LINE_CODE\)/);
  assert.match(compact, /FOREIGN KEY \(WORKSTAGE_CODE, ORGANIZATION_ID\) REFERENCES IP_PRODUCT_WORKSTAGE \(WORKSTAGE_CODE, ORGANIZATION_ID\)/);
  assert.match(compact, /FOREIGN KEY \(LINE_CODE, ORGANIZATION_ID\) REFERENCES IP_PRODUCT_LINE \(LINE_CODE, ORGANIZATION_ID\)/);
});

test('registers approved production lines idempotently', () => {
  for (const [code, name] of [['21', '성능검사기'], ['22', 'COATING MACHINE'], ['23', 'JETTING MACHINE'], ['24', 'ROUTER']]) {
    assert.match(sql, new RegExp(`MERGE INTO IP_PRODUCT_LINE[\\s\\S]*?'${code}'[\\s\\S]*?'${name.toUpperCase()}'`));
  }
  assert.match(compact, /'W' LINE_DIVISION/);
  assert.match(compact, /'FIXED' LINE_PRODUCT_DIVISION/);
  assert.match(compact, /'N' LINE_STATUS/);
  assert.match(compact, /'N' ACTIVE_YN/);
});
