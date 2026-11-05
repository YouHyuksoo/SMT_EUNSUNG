import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

const migrationUrl = new URL('./2026-07-12_ip_routing_tables.sql', import.meta.url);
const sql = readFileSync(migrationUrl, 'utf8').toUpperCase();
const compact = sql.replace(/\s+/g, ' ');

test('defines exactly the three IP routing tables and excludes retired routing fields', () => {
  const createdTables = [...sql.matchAll(/CREATE\s+TABLE\s+([A-Z0-9_]+)/g)].map((match) => match[1]);
  assert.deepEqual(createdTables, [
    'IP_ROUTING_GROUPS',
    'IP_ROUTING_PROCESSES',
    'IP_ROUTING_MATERIALS',
  ]);
  assert.doesNotMatch(sql, /ITEM_MASTERS|SG_LABEL|FG_LABEL|CIRCUIT|QUALITY_CONDITION|SELF_INSPECT/);
  assert.doesNotMatch(sql, /\b(DROP|CASCADE|INSERT|UPDATE|DELETE|MERGE)\b/);
});

test('defines master foreign keys in referenced key order', () => {
  assert.match(compact, /FOREIGN KEY \(WORKSTAGE_CODE, ORGANIZATION_ID\) REFERENCES IP_PRODUCT_WORKSTAGE \(WORKSTAGE_CODE, ORGANIZATION_ID\)/);
  assert.match(compact, /FOREIGN KEY \(SUBCON_SUPPLIER_CODE, ORGANIZATION_ID\) REFERENCES ICOM_SUPPLIER \(SUPPLIER_CODE, ORGANIZATION_ID\)/);
  assert.match(compact, /FOREIGN KEY \(CHILD_ITEM_CODE, ORGANIZATION_ID\) REFERENCES ID_ITEM \(ITEM_CODE, ORGANIZATION_ID\)/);
});

test('the item holds the routing code and the group no longer holds the item', () => {
  const groups = sql.match(/CREATE TABLE IP_ROUTING_GROUPS \([\s\S]*?\)~';/)?.[0] ?? '';
  assert.ok(groups.length > 0, 'IP_ROUTING_GROUPS create statement was not found');
  assert.doesNotMatch(groups, /ITEM_CODE/);
  assert.doesNotMatch(sql, /UK_IP_RG_ACTIVE_ITEM[^']*ON IP_ROUTING_GROUPS/);
  assert.match(compact, /ALTER TABLE ID_ITEM ADD \(ROUTING_CODE VARCHAR2\(50\)\)/);
  assert.match(compact, /ADD CONSTRAINT UK_ID_ITEM_ROUTING UNIQUE \(ITEM_CODE, ORGANIZATION_ID, ROUTING_CODE\)/);
  assert.match(compact, /ADD CONSTRAINT FK_ID_ITEM_ROUTING FOREIGN KEY \(ORGANIZATION_ID, ROUTING_CODE\) REFERENCES IP_ROUTING_GROUPS \(ORGANIZATION_ID, ROUTING_CODE\)/);
  assert.match(compact, /CREATE INDEX IX_ID_ITEM_ROUTING ON ID_ITEM \(ORGANIZATION_ID, ROUTING_CODE\)/);
  // ROUTE_NO 를 바꾸면 ID_ITEM_UPD_MANUAL 트리거가 재고 행을 지운다.
  assert.doesNotMatch(sql, /UPDATE\s+ID_ITEM|SET\s+ROUTE_NO/);
});

test('materials are keyed by routing, process, item and child and tied to the item routing', () => {
  assert.match(compact, /PRIMARY KEY \(ORGANIZATION_ID, ROUTING_CODE, PROCESS_SEQ, ITEM_CODE, CHILD_ITEM_CODE\)/);
  assert.match(compact, /FOREIGN KEY \(ITEM_CODE, ORGANIZATION_ID, ROUTING_CODE\) REFERENCES ID_ITEM \(ITEM_CODE, ORGANIZATION_ID, ROUTING_CODE\)/);
  assert.match(compact, /UNIQUE \(ORGANIZATION_ID, ROUTING_CODE, ITEM_CODE, CHILD_ITEM_CODE\)/);
});

test('enforces positive sequence, quantities and times', () => {
  assert.match(compact, /CHECK \(PROCESS_SEQ > 0\)/);
  assert.match(compact, /CHECK \(ALLOC_QTY > 0\)/);
  assert.match(compact, /CHECK \(STANDARD_TIME IS NULL OR STANDARD_TIME >= 0\)/);
  assert.match(compact, /CHECK \(SETUP_TIME IS NULL OR SETUP_TIME >= 0\)/);
});

test('makes the material process foreign key deferrable but initially immediate', () => {
  assert.match(compact, /FOREIGN KEY \(ORGANIZATION_ID, ROUTING_CODE, PROCESS_SEQ\) REFERENCES IP_ROUTING_PROCESSES \(ORGANIZATION_ID, ROUTING_CODE, PROCESS_SEQ\) DEFERRABLE INITIALLY IMMEDIATE/);
});

test('validates existing definitions and only alters ID_ITEM', () => {
  assert.match(sql, /USER_TABLES/);
  assert.match(sql, /USER_TAB_COLUMNS/);
  assert.match(sql, /USER_CONSTRAINTS/);
  assert.match(sql, /USER_CONS_COLUMNS/);
  assert.match(sql, /USER_INDEXES/);
  assert.match(sql, /RAISE_APPLICATION_ERROR/);
  assert.match(sql, /PROCEDURE ASSERT_DEFAULT/);
  assert.match(sql, /R_CONSTRAINT_NAME/);
  for (const column of [
    'CREATED_BY', 'CREATED_AT', 'UPDATED_BY', 'UPDATED_AT',
    'ORGANIZATION_ID', 'ROUTING_CODE', 'USE_YN',
  ]) {
    assert.match(sql, new RegExp(`ASSERT_COLUMN\\([^\\n]*'${column}'`));
  }
  const alters = [...sql.matchAll(/EXECUTE IMMEDIATE\s+'ALTER TABLE (\w+)/g)].map((match) => match[1]);
  assert.ok(alters.length > 0);
  assert.ok(alters.every((table) => table === 'ID_ITEM'), `unexpected ALTER targets: ${alters}`);
});

test('normalizes all whitespace when validating multiline check constraints', () => {
  const assertCheck = sql.match(/PROCEDURE ASSERT_CHECK[\s\S]*?\n  END;/)?.[0] ?? '';
  assert.match(assertCheck, /REGEXP_REPLACE\([^\n]*L_TEXT[^\n]*'\[\[:SPACE:\]\]\+'[^\n]*''\)/);
  assert.match(assertCheck, /REGEXP_REPLACE\([^\n]*P_TEXT[^\n]*'\[\[:SPACE:\]\]\+'[^\n]*''\)/);
});

test('treats a null metadata comparison as a validation failure', () => {
  const assertTrue = sql.match(/PROCEDURE ASSERT_TRUE[\s\S]*?\n  END;/)?.[0] ?? '';
  assert.match(assertTrue, /IF P_OK IS NULL OR NOT P_OK THEN/);
});

test('uses Oracle 12.2 compatible CLOB bridges for dictionary LONG values', () => {
  assert.doesNotMatch(sql, /DATA_DEFAULT_VC/);
  assert.match(sql, /DBMS_XMLGEN\.GETXMLTYPE/);
  assert.match(sql, /DBMS_ASSERT\.(SIMPLE_SQL_NAME|ENQUOTE_LITERAL)/);
});

test('upgrade migrations: item routing code, group item removal, legacy table cleanup', () => {
  const read = (name) => readFileSync(new URL(name, import.meta.url), 'utf8').toUpperCase().replace(/\s+/g, ' ');
  const addColumn = read('./2026-11-05_item_routing_code.sql');
  assert.match(addColumn, /ALTER TABLE ID_ITEM ADD \(ROUTING_CODE VARCHAR2\(50\)\)/);
  assert.match(addColumn, /ADD CONSTRAINT UK_ID_ITEM_ROUTING UNIQUE \(ITEM_CODE, ORGANIZATION_ID, ROUTING_CODE\)/);
  assert.match(addColumn, /ADD CONSTRAINT FK_ID_ITEM_ROUTING FOREIGN KEY \(ORGANIZATION_ID, ROUTING_CODE\) REFERENCES IP_ROUTING_GROUPS/);
  assert.doesNotMatch(addColumn, /UPDATE ID_ITEM|SET ROUTE_NO/);

  const dropItem = read('./2026-11-05_routing_groups_drop_item_code.sql');
  assert.match(dropItem, /ALTER TABLE IP_ROUTING_GROUPS DROP COLUMN ITEM_CODE/);
  assert.match(dropItem, /RAISE_APPLICATION_ERROR\(-20010/);
  assert.match(dropItem, /RAISE_APPLICATION_ERROR\(-20011/);
  // 투입자재·옛 라우팅 테이블은 0건일 때만 지운다.
  assert.match(dropItem, /RAISE_APPLICATION_ERROR\(-20012/);
  assert.match(dropItem, /RAISE_APPLICATION_ERROR\(-20013/);
  assert.match(dropItem, /DROP TABLE IP_PRODUCT_ROUTING'/);
  assert.match(dropItem, /DROP TABLE IP_PRODUCT_ROUTING_MASTER'/);
});
