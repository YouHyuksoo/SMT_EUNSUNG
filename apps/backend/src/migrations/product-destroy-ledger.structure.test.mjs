import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const source = readFileSync(resolve(import.meta.dirname, '2026-10-27_product_destroy_ledger.sql'), 'utf8');
const compact = source.replace(/\s+/g, ' ').trim();

test('첫 토큰이 DECLARE 라 connector 가 PL/SQL 블록으로 실행한다', () => {
  assert.match(source, /^DECLARE\b/);
});

test('테이블이 없는 DB 에서도 만들고, 있으면 건너뛴다', () => {
  assert.match(compact, /SELECT COUNT\(\*\) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'IP_PRODUCT_DESTROY'; IF n = 0 THEN ddl\(q'~CREATE TABLE IP_PRODUCT_DESTROY \(/);
  assert.match(compact, /FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEQ_IP_PRODUCT_DESTROY'; IF n = 0 THEN ddl\('CREATE SEQUENCE SEQ_IP_PRODUCT_DESTROY/);
  for (const index of ['IX_IP_PRODUCT_DESTROY_DATE', 'IX_IP_PRODUCT_DESTROY_SERIAL', 'IX_IP_PRODUCT_DESTROY_SOURCE']) {
    assert.match(compact, new RegExp(`USER_INDEXES WHERE INDEX_NAME = '${index}'; IF n = 0 THEN ddl\\('CREATE INDEX ${index} `));
  }
});

test('원장 핵심 컬럼과 PK·상태 제약', () => {
  for (const column of [
    'DESTROY_SEQ NUMBER NOT NULL', 'ORGANIZATION_ID NUMBER NOT NULL', 'DESTROY_DATE DATE NOT NULL',
    "DESTROY_STATUS VARCHAR2(1) DEFAULT 'D' NOT NULL", 'SERIAL_NO VARCHAR2(30),', 'ITEM_CODE VARCHAR2(30) NOT NULL',
    'DESTROY_QTY NUMBER NOT NULL', 'CANCEL_DATE DATE', 'CANCEL_BY VARCHAR2(20)', 'RETURN_DATE DATE',
    'SOURCE_SERIAL_NO VARCHAR2(30)', 'SOURCE_QC_SEQUENCE NUMBER',
  ]) {
    assert.ok(compact.includes(column), `${column} 이 없다`);
  }
  assert.match(compact, /CONSTRAINT PK_IP_PRODUCT_DESTROY PRIMARY KEY \(DESTROY_SEQ\)/);
  assert.match(compact, /CHECK \(DESTROY_STATUS IN \('D', 'R', 'C'\)\)/);
});

test('옛 폐기 행 이관은 원본 키로 한 번만 옮기고 WORK_QC 는 건드리지 않는다', () => {
  assert.match(compact, /FROM IP_PRODUCT_WORK_QC q WHERE q.QC_INSPECT_HANDLING = 'D' AND NOT EXISTS \(SELECT 1 FROM IP_PRODUCT_DESTROY d WHERE d.SOURCE_SERIAL_NO = q.SERIAL_NO AND d.SOURCE_QC_SEQUENCE = q.QC_SEQUENCE/);
  assert.doesNotMatch(compact, /(UPDATE|DELETE FROM) IP_PRODUCT_WORK_QC/);
});
