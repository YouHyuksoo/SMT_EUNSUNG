import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { resolve } from "node:path";

const repoRoot = resolve(import.meta.dirname, "../../../../..");
const appModulePath = resolve(repoRoot, "apps/backend/src/app.module.ts");
const masterCodeModulePath = resolve(repoRoot, "apps/backend/src/modules/master/master-code.module.ts");
const masterCompanyModulePath = resolve(repoRoot, "apps/backend/src/modules/master/master-company.module.ts");
const databaseModulePath = resolve(repoRoot, "apps/backend/src/database/database.module.ts");
const comCodeControllerPath = resolve(repoRoot, "apps/backend/src/modules/master/controllers/com-code.controller.ts");
const companyControllerPath = resolve(repoRoot, "apps/backend/src/modules/master/controllers/company.controller.ts");
const companyServicePath = resolve(repoRoot, "apps/backend/src/modules/master/services/company.service.ts");

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

test("enabled backend app registers the company route with ISYS_ORGANIZATION without enabling the full MasterModule", () => {
  const appModule = readFileSync(appModulePath, "utf8");
  const masterCompanyModule = readFileSync(masterCompanyModulePath, "utf8");
  const databaseModule = readFileSync(databaseModulePath, "utf8");
  const companyController = readFileSync(companyControllerPath, "utf8");
  const companyService = readFileSync(companyServicePath, "utf8");

  assert.match(companyController, /@Controller\('master\/companies'\)/);
  assert.match(companyController, /@Get\(\)/);
  assert.match(appModule, /import \{ MasterCompanyModule \} from '\.\/modules\/master\/master-company\.module'/);
  assert.match(appModule, /MasterCompanyModule,/);
  assert.doesNotMatch(appModule, /MasterModule,/);
  assert.match(masterCompanyModule, /CompanyController/);
  assert.match(masterCompanyModule, /CompanyService/);
  assert.match(masterCompanyModule, /TypeOrmModule\.forFeature\(\[\s*IsysOrganization\s*\]\)/);
  assert.match(companyService, /@InjectRepository\(IsysOrganization\)/);
  assert.doesNotMatch(companyService, /CompanyMaster/);
  assert.match(databaseModule, /import \{ IsysOrganization \} from '\.\.\/entities\/isys-organization\.entity'/);
  assert.match(databaseModule, /entities:\s*\[[\s\S]*\bIsysOrganization\b/);
});
