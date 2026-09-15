import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const source = readFileSync(new URL("./MainLayout.tsx", import.meta.url), "utf8");

test("OEE alias mode shares the resolver and keeps one stable TabKeepAlive mount", () => {
  assert.match(source, /resolveOeeViewMode\(pathname, searchParams\.get\(["']view["']\)\)/);
  assert.match(source, /isOeeMultiEntry && oeeViewMode === ["']full["']/);
  assert.match(source, /const isFullscreenView = searchParams\.get\(["']view["']\) === ["']full["'];/);
  assert.equal((source.match(/<TabKeepAlive>/g) ?? []).length, 1);
  assert.doesNotMatch(source, /\{isChromeless \? \(/);
  assert.match(source, /!isChromeless\s*&&\s*<Header/);
  assert.match(source, /!isChromeless\s*&&\s*<Sidebar/);
  assert.match(source, /!isChromeless\s*&&\s*<TabBar/);
});
