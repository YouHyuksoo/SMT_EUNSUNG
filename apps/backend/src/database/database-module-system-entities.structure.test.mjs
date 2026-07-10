import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { resolve } from "node:path";

const repoRoot = resolve(import.meta.dirname, "../../../..");
const systemModulePath = resolve(repoRoot, "apps/backend/src/modules/system/system.module.ts");
const databaseModulePath = resolve(repoRoot, "apps/backend/src/database/database.module.ts");

function extractForFeatureEntities(source) {
  const match = source.match(/TypeOrmModule\.forFeature\(\[([\s\S]*?)\]\)/);
  assert.ok(match, "SystemModule must register TypeOrmModule.forFeature([...])");
  return [...match[1].matchAll(/\b([A-Z][A-Za-z0-9_]*)\b/g)]
    .map((m) => m[1])
    .filter((name) => !["TypeOrmModule"].includes(name))
    .sort();
}

function extractDatabaseEntities(source) {
  const match = source.match(/entities:\s*\[([\s\S]*?)\]/);
  assert.ok(match, "DatabaseModule must define a TypeORM entities array");
  return [...match[1].matchAll(/\b([A-Z][A-Za-z0-9_]*)\b/g)]
    .map((m) => m[1])
    .sort();
}

test("DatabaseModule includes all TypeORM entities required by enabled SystemModule", () => {
  const systemEntities = extractForFeatureEntities(readFileSync(systemModulePath, "utf8"));
  const databaseEntities = new Set(extractDatabaseEntities(readFileSync(databaseModulePath, "utf8")));

  const missing = systemEntities.filter((entityName) => !databaseEntities.has(entityName));
  assert.deepEqual(missing, []);
});
