import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";

const frontendRoot = fs.existsSync("src/app") ? "." : "apps/frontend";
const pagePath = `${frontendRoot}/src/app/(authenticated)/oee/master/resource/page.tsx`;
const menuPath = `${frontendRoot}/src/config/menuConfig.ts`;
const page = fs.existsSync(pagePath) ? fs.readFileSync(pagePath, "utf8") : "";
const menu = fs.readFileSync(menuPath, "utf8");
const locales = ["ko", "en", "zh", "vi"];

test("resource master is registered with the approved CRUD and candidate endpoints", () => {
  assert.ok(page, "resource master page must exist");
  for (const endpoint of [
    "/oee/resource",
    "/oee/resource/candidates",
    "/oee/resource/",
  ]) {
    assert.match(page, new RegExp(endpoint.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")));
  }

  assert.match(page, /api\.get\(['"]\/oee\/resource['"]\)/);
  assert.match(page, /api\.get\(['"]\/oee\/resource\/candidates['"]\)/);
  assert.match(page, /api\.post\(['"]\/oee\/resource['"]/);
  assert.match(page, /api\.put\(\`\/oee\/resource\/\$\{/);
  assert.match(page, /api\.delete\(\`\/oee\/resource\/\$\{/);
});

test("resource master exposes the approved registration fields and keeps line immutable on edit", () => {
  for (const field of ["lineCode", "processCode", "resourceType"]) {
    assert.match(page, new RegExp(`\\b${field}\\b`));
  }
  assert.match(page, /value=["']SMT["']/);
  assert.match(page, /value=["']ASSY["']/);
  assert.match(page, /value=["']LINE["']/);
  assert.match(page, /value=["']CELL["']/);
  assert.match(page, /disabled=\{form\.isEdit\}/);
  assert.match(page, /ConfirmModal/);
  assert.doesNotMatch(page, /\b(?:alert|confirm|prompt)\s*\(/);
});

test("resource master menu and active locale labels are present", () => {
  assert.match(menu, /code:\s*["']OEE_MST_RESOURCE["']/);
  assert.match(menu, /path:\s*["']\/oee\/master\/resource["']/);
  assert.match(menu, /labelKey:\s*["']menu\.oee\.resource["']/);

  for (const locale of locales) {
    const messages = JSON.parse(fs.readFileSync(`${frontendRoot}/src/locales/${locale}.json`, "utf8"));
    assert.equal(typeof messages.menu?.["oee.resource"], "string", `${locale}: menu.oee.resource`);
  }
});
