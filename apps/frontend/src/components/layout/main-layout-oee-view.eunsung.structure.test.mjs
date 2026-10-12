import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const source = readFileSync(new URL("./MainLayout.tsx", import.meta.url), "utf8");

test("canonical OEE full mode keeps one stable TabKeepAlive mount", () => {
  assert.match(source, /const isFullscreenView = searchParams\.get\(["']view["']\) === ["']full["'];/);
  assert.match(source, /const isChromeless = isKioskWorkView \|\| isFullscreenView/);
  assert.equal((source.match(/<TabKeepAlive>/g) ?? []).length, 1);
  assert.doesNotMatch(source, /\{isChromeless \? \(/);
  assert.match(source, /!isChromeless\s*&&\s*<Header/);
  assert.match(source, /!isChromeless\s*&&\s*<Sidebar/);
  assert.match(source, /!isChromeless\s*&&\s*<TabBar/);
});

test("11-inch OEE screens preserve the user's sidebar state", () => {
  assert.doesNotMatch(source, /matchMedia|preOeeAutoCollapseRef|restoreSidebar|isOeeMultiEntry/);
  assert.match(source, /setCollapsed\(\(current\) => !current\)/);
});
