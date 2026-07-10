import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { resolve } from "node:path";

const repoRoot = resolve(import.meta.dirname, "../../../../../..");
const frontendMenuPath = resolve(repoRoot, "apps/frontend/src/config/menuConfig.ts");
const defaultLayoutPath = resolve(repoRoot, "apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts");

function extractFrontendLeafCodes(source) {
  const lines = source.split(/\r?\n/);
  const positions = [];
  lines.forEach((line, i) => {
    const match = line.match(/code:\s*"([A-Z0-9_]+)"/);
    if (match) positions.push({ code: match[1], line: i });
  });

  const codes = new Set();
  for (let i = 0; i < positions.length; i++) {
    const start = positions[i].line;
    const end = i + 1 < positions.length ? positions[i + 1].line : lines.length;
    const windowText = lines.slice(start, end).join("\n");
    if (/path:\s*"[^"]+"/.test(windowText)) codes.add(positions[i].code);
  }
  return [...codes].sort();
}

function extractLayoutMenuCodes(source) {
  return [...source.matchAll(/menuCodes:\s*\[([^\]]*)\]/g)]
    .flatMap((match) => [...match[1].matchAll(/'([A-Z0-9_]+)'/g)].map((codeMatch) => codeMatch[1]))
    .sort();
}

test("default menu category layout contains every frontend leaf menu exactly once", () => {
  const frontendLeafCodes = extractFrontendLeafCodes(readFileSync(frontendMenuPath, "utf8"));
  const layoutMenuCodes = extractLayoutMenuCodes(readFileSync(defaultLayoutPath, "utf8"));

  assert.deepEqual(layoutMenuCodes, frontendLeafCodes);
});
