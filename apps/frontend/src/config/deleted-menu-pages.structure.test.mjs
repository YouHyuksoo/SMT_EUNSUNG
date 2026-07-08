import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";

const read = (path) => fs.readFileSync(path, "utf8");

const forbiddenRoutes = [
  "/system/pda-roles",
  "/system/comm-config",
  "/interface/dashboard",
  "/interface/log",
  "/interface/manual",
  "/consumables/master",
  "/consumables/label",
  "/consumables/receiving",
  "/consumables/issuing",
  "/consumables/stock",
  "/consumables/life",
  "/consumables/mount",
  "/master/vendor-barcode",
];

const forbiddenCodes = [
  "SYS_PDA_ROLE",
  "SYS_COMM",
  "IF_DASHBOARD",
  "IF_LOG",
  "IF_MANUAL",
  "INTERFACE",
  "CONS_MASTER",
  "CONS_LABEL",
  "CONS_RECEIVING",
  "CONS_ISSUING",
  "CONS_STOCK",
  "CONS_LIFE",
  "CONS_MOUNT",
  "CONSUMABLES",
  "MST_VENDOR_BARCODE",
];

const deletedRouteDirs = [
  "apps/frontend/src/app/(authenticated)/system/pda-roles",
  "apps/frontend/src/app/(authenticated)/system/comm-config",
  "apps/frontend/src/app/(authenticated)/interface",
  "apps/frontend/src/app/(authenticated)/consumables",
  "apps/frontend/src/app/(authenticated)/master/vendor-barcode",
  "apps/backend/src/modules/ai-page-tools/registry/vendor-barcode-tools.provider.ts",
];

const deletedRegistryFiles = [
  "apps/frontend/src/components/layout/page-registries/system__pda-roles.generated.ts",
  "apps/frontend/src/components/layout/page-registries/system__comm-config.generated.ts",
  "apps/frontend/src/components/layout/page-registries/interface__dashboard.generated.ts",
  "apps/frontend/src/components/layout/page-registries/interface__log.generated.ts",
  "apps/frontend/src/components/layout/page-registries/interface__manual.generated.ts",
  "apps/frontend/src/components/layout/page-registries/consumables__master.generated.ts",
  "apps/frontend/src/components/layout/page-registries/consumables__label.generated.ts",
  "apps/frontend/src/components/layout/page-registries/consumables__receiving.generated.ts",
  "apps/frontend/src/components/layout/page-registries/consumables__issuing.generated.ts",
  "apps/frontend/src/components/layout/page-registries/consumables__stock.generated.ts",
  "apps/frontend/src/components/layout/page-registries/consumables__life.generated.ts",
  "apps/frontend/src/components/layout/page-registries/consumables__mount.generated.ts",
  "apps/frontend/src/components/layout/page-registries/master__vendor-barcode.generated.ts",
];

test("삭제된 메뉴 페이지는 메뉴, 기본 카테고리, 레지스트리에 남지 않는다", () => {
  const sources = [
    "apps/frontend/src/config/menuConfig.ts",
    "apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts",
    "apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts",
    "apps/backend/src/seeds/menu-config.json",
    "apps/frontend/src/components/layout/pageRegistry.generated.ts",
    "apps/frontend/src/config/workflowConfig.ts",
    "apps/frontend/src/config/workflowMap.ts",
    "packages/shared/src/constants/menu.ts",
    "apps/backend/src/modules/ai-page-tools/ai-page-tools.module.ts",
  ].map((path) => [path, read(path)]);

  for (const [path, source] of sources) {
    for (const route of forbiddenRoutes) {
      assert.equal(source.includes(route), false, `${path} must not reference deleted route ${route}`);
    }
    for (const code of forbiddenCodes) {
      assert.equal(source.includes(code), false, `${path} must not reference deleted menu code ${code}`);
    }
  }
});

test("삭제된 메뉴 페이지의 라우트 폴더와 생성 레지스트리 파일은 존재하지 않는다", () => {
  for (const path of [...deletedRouteDirs, ...deletedRegistryFiles]) {
    assert.equal(fs.existsSync(path), false, `${path} must be deleted`);
  }
});
