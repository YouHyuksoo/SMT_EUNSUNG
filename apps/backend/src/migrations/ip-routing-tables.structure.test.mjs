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
  assert.match(compact, /FOREIGN KEY \(ITEM_CODE, ORGANIZATION_ID\) REFERENCES ID_ITEM \(ITEM_CODE, ORGANIZATION_ID\)/);
  assert.match(compact, /FOREIGN KEY \(WORKSTAGE_CODE, ORGANIZATION_ID\) REFERENCES IP_PRODUCT_WORKSTAGE \(WORKSTAGE_CODE, ORGANIZATION_ID\)/);
  assert.match(compact, /FOREIGN KEY \(SUBCON_SUPPLIER_CODE, ORGANIZATION_ID\) REFERENCES ICOM_SUPPLIER \(SUPPLIER_CODE, ORGANIZATION_ID\)/);
  assert.match(compact, /FOREIGN KEY \(CHILD_ITEM_CODE, ORGANIZATION_ID\) REFERENCES ID_ITEM \(ITEM_CODE, ORGANIZATION_ID\)/);
});

test('enforces routing uniqueness, process ownership, and positive quantities and times', () => {
  assert.match(compact, /CREATE UNIQUE INDEX [A-Z0-9_]+ ON IP_ROUTING_GROUPS \( CASE USE_YN WHEN 'Y' THEN ORGANIZATION_ID END, CASE USE_YN WHEN 'Y' THEN ITEM_CODE END \)/);
  assert.match(compact, /UNIQUE \(ORGANIZATION_ID, ROUTING_CODE, CHILD_ITEM_CODE\)/);
  assert.match(compact, /CHECK \(PROCESS_SEQ > 0\)/);
  assert.match(compact, /CHECK \(ALLOC_QTY > 0\)/);
  assert.match(compact, /CHECK \(STANDARD_TIME IS NULL OR STANDARD_TIME >= 0\)/);
  assert.match(compact, /CHECK \(SETUP_TIME IS NULL OR SETUP_TIME >= 0\)/);
});

test('makes the material process foreign key deferrable but initially immediate', () => {
  assert.match(compact, /FOREIGN KEY \(ORGANIZATION_ID, ROUTING_CODE, PROCESS_SEQ\) REFERENCES IP_ROUTING_PROCESSES \(ORGANIZATION_ID, ROUTING_CODE, PROCESS_SEQ\) DEFERRABLE INITIALLY IMMEDIATE/);
});

test('validates existing definitions and fails mismatches without altering objects', () => {
  assert.match(sql, /USER_TABLES/);
  assert.match(sql, /USER_TAB_COLUMNS/);
  assert.match(sql, /USER_CONSTRAINTS/);
  assert.match(sql, /USER_CONS_COLUMNS/);
  assert.match(sql, /USER_INDEXES/);
  assert.match(sql, /DBMS_METADATA\.GET_DDL/);
  assert.match(sql, /RAISE_APPLICATION_ERROR/);
  assert.match(sql, /PROCEDURE ASSERT_DEFAULT/);
  assert.match(sql, /R_CONSTRAINT_NAME/);
  assert.match(sql, /DBMS_LOB\.SUBSTR\(V_INDEX_DDL/);
  for (const column of [
    'CREATED_BY', 'CREATED_AT', 'UPDATED_BY', 'UPDATED_AT',
    'ORGANIZATION_ID', 'ROUTING_CODE', 'USE_YN',
  ]) {
    assert.match(sql, new RegExp(`ASSERT_COLUMN\\([^\\n]*'${column}'`));
  }
  assert.doesNotMatch(sql, /EXECUTE IMMEDIATE\s+'ALTER\b/);
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

test('requires exactly two ordered expressions in the active-route unique index', () => {
  assert.match(compact, /FROM USER_IND_COLUMNS WHERE INDEX_NAME = 'UK_IP_RG_ACTIVE_ITEM' AND TABLE_NAME = 'IP_ROUTING_GROUPS'; ASSERT_TRUE\(V_COUNT = 2, 'UK_IP_RG_ACTIVE_ITEM COLUMN COUNT MISMATCH'\)/);
  assert.match(compact, /CASEUSE_YNWHEN''Y''THENORGANIZATION_IDEND,CASEUSE_YNWHEN''Y''THENITEM_CODEEND/);
});

test('uses Oracle 12.2 compatible CLOB bridges for dictionary LONG values', () => {
  assert.doesNotMatch(sql, /DATA_DEFAULT_VC/);
  assert.match(sql, /DBMS_XMLGEN\.GETXMLTYPE/);
  assert.match(sql, /DBMS_ASSERT\.(SIMPLE_SQL_NAME|ENQUOTE_LITERAL)/);
  assert.match(sql, /DBMS_METADATA\.GET_DDL\('INDEX', 'UK_IP_RG_ACTIVE_ITEM'\)/);
  assert.doesNotMatch(sql, /REGEXP_REPLACE\([^;]*COLUMN_EXPRESSION/);
  assert.doesNotMatch(sql, /UPPER\([^;]*COLUMN_EXPRESSION/);
});

test('creates and exactly validates Oracle normalized simple CASE index expressions', () => {
  assert.match(compact, /CREATE UNIQUE INDEX UK_IP_RG_ACTIVE_ITEM ON IP_ROUTING_GROUPS \( CASE USE_YN WHEN 'Y' THEN ORGANIZATION_ID END, CASE USE_YN WHEN 'Y' THEN ITEM_CODE END \)/);
  assert.match(sql, /V_INDEX_EXPRESSIONS\s*:=\s*REGEXP_SUBSTR/);
  assert.match(compact, /ASSERT_TRUE\(V_INDEX_EXPRESSIONS = 'CASEUSE_YNWHEN''Y''THENORGANIZATION_IDEND,CASEUSE_YNWHEN''Y''THENITEM_CODEEND'/);
  assert.doesNotMatch(sql, /INSTR\(V_INDEX_TEXT/);
});
