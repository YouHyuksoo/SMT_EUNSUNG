import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const source = readFileSync(new URL("./MainLayout.tsx", import.meta.url), "utf8");

test("canonical OEE full mode keeps one stable TabKeepAlive mount", () => {
  assert.match(source, /resolveOeeViewMode\(searchParams\.get\(["']view["']\)\)/);
  assert.match(source, /isOeeMultiEntry && oeeViewMode === ["']full["']/);
  assert.match(source, /const isFullscreenView = searchParams\.get\(["']view["']\) === ["']full["'];/);
  assert.equal((source.match(/<TabKeepAlive>/g) ?? []).length, 1);
  assert.doesNotMatch(source, /\{isChromeless \? \(/);
  assert.match(source, /!isChromeless\s*&&\s*<Header/);
  assert.match(source, /!isChromeless\s*&&\s*<Sidebar/);
  assert.match(source, /!isChromeless\s*&&\s*<TabBar/);
});

test("canonical OEE tablet mode auto-collapses and restores the sidebar without locking its toggle", () => {
  assert.match(source, /matchMedia\(["']\(min-width: 1024px\) and \(max-width: 1535\.98px\)["']\)/);
  assert.match(source, /preOeeAutoCollapseRef/);
  assert.match(source, /restoreSidebar/);
  assert.match(source, /setCollapsed\(\(current\) => !current\)/);
});
