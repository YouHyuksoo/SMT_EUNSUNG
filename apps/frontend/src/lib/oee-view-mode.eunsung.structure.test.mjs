import assert from "node:assert/strict";
import { existsSync, readFileSync } from "node:fs";
import test from "node:test";
import ts from "typescript";

const helperUrl = new URL("./oee-view-mode.ts", import.meta.url);
const helperSource = existsSync(helperUrl) ? readFileSync(helperUrl, "utf8") : "";
const helperModule = ts.transpileModule(helperSource, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
}).outputText;
const { isOeeMultiEntryPath, resolveOeeViewMode } = await import(
  `data:text/javascript;base64,${Buffer.from(helperModule).toString("base64")}`,
);

test("canonical OEE view mode honors the explicit full override", () => {
  assert.equal(typeof resolveOeeViewMode, "function", "the shared OEE view resolver must exist");
  assert.equal(resolveOeeViewMode(null), "normal");
  assert.equal(resolveOeeViewMode("normal"), "normal");
  assert.equal(resolveOeeViewMode("full"), "full");
  assert.equal(resolveOeeViewMode("unexpected"), "normal");
});

test("only the canonical route is recognized by the OEE layout", () => {
  assert.equal(isOeeMultiEntryPath("/oee/multi-entry"), true);
  assert.equal(isOeeMultiEntryPath("/oee/multi-entry-7in"), false);
  const frontendRoot = existsSync("src/app") ? "." : "apps/frontend";
  const authGuard = readFileSync(`${frontendRoot}/src/components/layout/AuthGuard.tsx`, "utf8");
  const tabSync = readFileSync(`${frontendRoot}/src/hooks/useTabSync.ts`, "utf8");
  assert.match(authGuard, /findMenuCodeByPath\(pathname\)/);
  assert.match(tabSync, /const menuPath = pathname/);
  assert.doesNotMatch(`${helperSource}\n${authGuard}\n${tabSync}`, /resolveOeeMenuPath|OEE_MULTI_ENTRY_7IN_PATH/);
});
