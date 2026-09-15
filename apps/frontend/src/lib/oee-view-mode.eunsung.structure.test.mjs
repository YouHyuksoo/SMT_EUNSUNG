import assert from "node:assert/strict";
import { existsSync, readFileSync } from "node:fs";
import test from "node:test";
import ts from "typescript";

const helperUrl = new URL("./oee-view-mode.ts", import.meta.url);
const helperSource = existsSync(helperUrl) ? readFileSync(helperUrl, "utf8") : "";
const helperModule = ts.transpileModule(helperSource, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
}).outputText;
const { resolveOeeMenuPath, resolveOeeViewMode } = await import(
  `data:text/javascript;base64,${Buffer.from(helperModule).toString("base64")}`,
);

test("OEE view mode defaults by route and honors explicit full/normal overrides", () => {
  assert.equal(typeof resolveOeeViewMode, "function", "the shared OEE view resolver must exist");
  assert.equal(resolveOeeViewMode("/oee/multi-entry", null), "normal");
  assert.equal(resolveOeeViewMode("/oee/multi-entry-7in", null), "full");
  assert.equal(resolveOeeViewMode("/oee/multi-entry-7in", "normal"), "normal");
  assert.equal(resolveOeeViewMode("/oee/multi-entry", "full"), "full");
  assert.equal(resolveOeeViewMode("/oee/multi-entry-7in", "unexpected"), "full");
});

test("OEE legacy alias resolves to the canonical menu permission and tab path", () => {
  assert.equal(resolveOeeMenuPath("/oee/multi-entry-7in"), "/oee/multi-entry");
  assert.equal(resolveOeeMenuPath("/oee/dashboard"), "/oee/dashboard");

  const frontendRoot = existsSync("src/app") ? "." : "apps/frontend";
  const authGuard = readFileSync(`${frontendRoot}/src/components/layout/AuthGuard.tsx`, "utf8");
  const tabSync = readFileSync(`${frontendRoot}/src/hooks/useTabSync.ts`, "utf8");
  assert.match(authGuard, /findMenuCodeByPath\(resolveOeeMenuPath\(pathname\)\)/);
  assert.match(tabSync, /const menuPath = resolveOeeMenuPath\(pathname\)/);
  assert.match(tabSync, /findMenuItemByPath\(menuPath\)/);
});
