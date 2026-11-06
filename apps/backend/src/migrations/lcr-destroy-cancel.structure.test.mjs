import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const source = readFileSync(resolve(import.meta.dirname, '2026-10-27_lcr_destroy_cancel.sql'), 'utf8');
const compact = source.replace(/\s+/g, ' ').trim();

test('첫 토큰이 DECLARE 라 connector 가 PL/SQL 블록으로 실행한다', () => {
  assert.match(source, /^DECLARE\b/);
});

test('테이블이 없으면 칸을 더하지 않고 멈춘다', () => {
  assert.match(compact, /FROM USER_TABLES WHERE TABLE_NAME = 'IP_LCR_DESTROY'; IF n = 0 THEN RAISE_APPLICATION_ERROR/);
});

test('취소 칸은 USER_TAB_COLUMNS 로 확인한 뒤 없을 때만 더한다', () => {
  assert.match(compact, /FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'IP_LCR_DESTROY' AND COLUMN_NAME = p_column; IF c = 0 THEN EXECUTE IMMEDIATE 'ALTER TABLE IP_LCR_DESTROY ADD \('/);
  assert.match(compact, /add_column\('CANCEL_YN', q'~VARCHAR2\(1\) DEFAULT 'N' NOT NULL~'\)/);
  for (const column of ["'CANCEL_DATE', 'DATE'", "'CANCEL_BY', 'VARCHAR2(20)'", "'CANCEL_REASON', 'VARCHAR2(500)'"]) {
    assert.ok(compact.includes(`add_column(${column})`), `${column} 이 없다`);
  }
  assert.match(compact, /USER_CONSTRAINTS WHERE CONSTRAINT_NAME = 'CK_IP_LCR_DESTROY_CANCEL'; IF n = 0 THEN/);
});

test('행을 지우지 않는다', () => {
  assert.doesNotMatch(compact, /DELETE FROM/i);
});
