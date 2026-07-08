import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { resolve } from "node:path";

const repoRoot = resolve(import.meta.dirname, "../../../../..");
const appModulePath = resolve(repoRoot, "apps/backend/src/app.module.ts");
const masterCodeModulePath = resolve(repoRoot, "apps/backend/src/modules/master/master-code.module.ts");
const databaseModulePath = resolve(repoRoot, "apps/backend/src/database/database.module.ts");
const comCodeControllerPath = resolve(repoRoot, "apps/backend/src/modules/master/controllers/com-code.controller.ts");

test("enabled backend app registers the common-code master route without enabling the full MasterModule", () => {
  const appModule = readFileSync(appModulePath, "utf8");
  const masterCodeModule = readFileSync(masterCodeModulePath, "utf8");
  const databaseModule = readFileSync(databaseModulePath, "utf8");
  const comCodeController = readFileSync(comCodeControllerPath, "utf8");

  assert.match(comCodeController, /@Controller\('master\/com-codes'\)/);
  assert.match(comCodeController, /@Get\('groups'\)/);
  assert.match(appModule, /import \{ MasterCodeModule \} from '\.\/modules\/master\/master-code\.module'/);
  assert.match(appModule, /MasterCodeModule,/);
  assert.doesNotMatch(appModule, /MasterModule,/);
  assert.match(masterCodeModule, /ComCodeController/);
  assert.match(masterCodeModule, /ComCodeService/);
  assert.match(masterCodeModule, /TypeOrmModule\.forFeature\(\[\s*ComCode\s*\]\)/);
  assert.match(databaseModule, /import \{ ComCode \} from '\.\.\/entities\/com-code\.entity'/);
  assert.match(databaseModule, /entities:\s*\[[\s\S]*\bComCode\b/);
});
