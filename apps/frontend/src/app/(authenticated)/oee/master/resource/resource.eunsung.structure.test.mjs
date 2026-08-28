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

test("resource master keeps the OEE resource name separate from the canonical line name", () => {
  assert.match(page, /resourceName:\s*string/);
  assert.match(page, /accessorKey:\s*["']resourceName["']/);
  assert.match(page, /header:\s*["']리소스명["']/);
  assert.match(page, /record\.resourceName/);
  assert.match(page, /form\.isEdit\s*&&\s*\(/);
  assert.match(page, /리소스명\s*<span className=["']text-red-500["']>\*<\/span>/);
  assert.match(page, /maxLength=\{100\}/);
  assert.match(page, /resourceName:\s*form\.resourceName\.trim\(\)/);
});

test("resource master uses workplace terminology and displays the DB LINE/CELL values", () => {
  assert.match(page, /작업장별\s+라인·셀\s+리소스\s+기준정보/);
  assert.match(page, /통합검색\s*\(라인코드·라인명·리소스명·작업장·유형\)/);
  assert.match(page, /toast\.error\(['"]작업장과 OEE 유형을 확인하세요['"]\)/);
  assert.match(page, /header:\s*['"]작업장['"]/);
  assert.match(page, /header:\s*['"]OEE 유형['"]/);
  assert.match(page, /<span>OEE 유형 <span className=['"]text-red-500['"]>\*<\/span><\/span>/);
  assert.doesNotMatch(page, /RESOURCE_TYPE_LABELS/);
  assert.match(page, /accessorKey:\s*['"]resourceType['"][^\n]*String\(getValue\(\)/);
  assert.match(page, /value=["']LINE["'][^>]*>LINE/);
  assert.match(page, /value=["']CELL["'][^>]*>CELL/);
  assert.match(page, /deleteTarget\.resourceType/);

  const saveBlock = page.match(/const payload = \{[\s\S]*?\n    \};/)?.[0] ?? "";
  assert.match(saveBlock, /processCode:\s*form\.processCode/);
  assert.match(saveBlock, /resourceType:\s*form\.resourceType/);
  assert.doesNotMatch(saveBlock, /작업장|라인·셀|라인|셀/);
});

test("resource master menu and active locale labels are present", () => {
  assert.match(page, />OEE 라인 관리<\/h1>/);
  assert.match(page, /exportFileName=["']OEE라인관리["']/);
  assert.match(menu, /code:\s*["']OEE_MST_RESOURCE["']/);
  assert.match(menu, /path:\s*["']\/oee\/master\/resource["']/);
  assert.match(menu, /labelKey:\s*["']menu\.oee\.resource["']/);

  for (const locale of locales) {
    const messages = JSON.parse(fs.readFileSync(`${frontendRoot}/src/locales/${locale}.json`, "utf8"));
    assert.equal(typeof messages.menu?.["oee.resource"], "string", `${locale}: menu.oee.resource`);
    if (locale === "ko") assert.equal(messages.menu["oee.resource"], "OEE 라인 관리");
  }
});
