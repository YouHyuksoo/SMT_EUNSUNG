import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { resolve } from "node:path";

const repoRoot = resolve(import.meta.dirname, "../../../..");
const entitySource = readFileSync(resolve(repoRoot, "apps/backend/src/entities/comm-config.entity.ts"), "utf8");
const migrationSource = readFileSync(resolve(repoRoot, "apps/backend/src/migrations/2026-07-08_create_isys_comm_configs.sql"), "utf8");

test("ISYS_COMM_CONFIGS migration matches the current organization-scoped entity shape", () => {
  assert.match(entitySource, /@Entity\(\{ name: 'ISYS_COMM_CONFIGS' \}\)/);
  assert.match(entitySource, /name: 'ORGANIZATION_ID'/);

  assert.match(migrationSource, /CREATE TABLE ISYS_COMM_CONFIGS/);
  assert.match(migrationSource, /CONFIG_NAME VARCHAR2\(100\) NOT NULL/);
  assert.match(migrationSource, /ORGANIZATION_ID NUMBER NOT NULL/);
  assert.match(migrationSource, /LINE_ENDING VARCHAR2\(10\) DEFAULT ''NONE''/);
  assert.match(migrationSource, /EXTRA_CONFIG CLOB/);
  assert.match(migrationSource, /PK_ISYS_COMM_CONFIGS/);
});
