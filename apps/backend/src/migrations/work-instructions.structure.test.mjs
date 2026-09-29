import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const migrationPath = resolve(import.meta.dirname, '2026-09-25_work_instructions.sql');

test('work-instructions migration creates and upgrades the table contract', () => {
  assert.equal(existsSync(migrationPath), true, 'WORK_INSTRUCTIONS migration must exist');
  const source = readFileSync(migrationPath, 'utf8');
  const compact = source.replace(/\s+/g, ' ').trim();

  assert.match(source, /^DECLARE\b/);
  assert.match(compact, /USER_TABLES[\s\S]*TABLE_NAME = 'WORK_INSTRUCTIONS'/);
  assert.match(compact, /CREATE TABLE WORK_INSTRUCTIONS/);
  assert.match(compact, /ORGANIZATION_ID NUMBER DEFAULT 1 NOT NULL/);
  assert.match(compact, /CONSTRAINT PK_WORK_INSTRUCTIONS PRIMARY KEY \(ITEM_CODE, PROCESS_CODE, REVISION\)/);
});
