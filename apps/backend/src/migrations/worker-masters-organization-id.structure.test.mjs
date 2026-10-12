import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const migrationPath = resolve(
  import.meta.dirname,
  '2026-09-09_worker_masters_organization_id.sql',
);
const source = readFileSync(migrationPath, 'utf8');
const compact = source.replace(/\s+/g, ' ').trim();

test('worker migration creates WORKER_MASTERS when the table is absent', () => {
  assert.match(source, /^DECLARE\b/);
  assert.match(compact, /USER_TABLES[\s\S]*TABLE_NAME = 'WORKER_MASTERS'/);
  assert.match(compact, /CREATE TABLE WORKER_MASTERS/);
  assert.match(compact, /ORGANIZATION_ID NUMBER DEFAULT 1 NOT NULL/);
  assert.match(compact, /CONSTRAINT PK_WORKER_MASTERS PRIMARY KEY \(COMPANY, PLANT_CD, WORKER_CODE\)/);
});
