import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { test } from "node:test";
import { resolve } from "node:path";

const repoRoot = resolve(import.meta.dirname, "../../../../../..");
const menuConfigPath = resolve(repoRoot, "apps/frontend/src/config/menuConfig.ts");
const validatorPath = resolve(repoRoot, "apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts");

/**
 * menuConfig.ts에서 "path를 가진" 메뉴 코드(=사이드바 leaf)를 추출한다.
 * 사이드바(menuTreeStore.buildLeafLookup)의 판정 기준과 동일하게 path 유무로 판단하며,
 * 단독(top-level) 메뉴처럼 code/path가 여러 줄에 나뉜 경우도 인식한다.
 */
function extractFrontendLeafCodes(source) {
  const lines = source.split(/\r?\n/);
  const positions = [];
  lines.forEach((line, i) => {
    const m = line.match(/code:\s*"([A-Z0-9_]+)"/);
    if (m) positions.push({ code: m[1], line: i });
  });
  const codes = new Set();
  for (let k = 0; k < positions.length; k++) {
    const start = positions[k].line;
    const end = k + 1 < positions.length ? positions[k + 1].line : lines.length;
    const windowText = lines.slice(start, end).join("\n");
    if (/path:\s*"[^"]+"/.test(windowText)) codes.add(positions[k].code);
  }
  return [...codes].sort();
}

function extractValidatorCodes(source) {
  const codes = new Set();
  for (const match of source.matchAll(/'([A-Z0-9_]+)'/g)) codes.add(match[1]);
  return [...codes].sort();
}

test("menu-code-validator matches frontend leaf menu codes exactly (no missing, no extras)", () => {
  const frontendLeafCodes = extractFrontendLeafCodes(readFileSync(menuConfigPath, "utf8"));
  const validatorCodes = new Set(extractValidatorCodes(readFileSync(validatorPath, "utf8")));
  const frontendSet = new Set(frontendLeafCodes);

  const missing = frontendLeafCodes.filter((code) => !validatorCodes.has(code));
  const extra = [...validatorCodes].filter((code) => !frontendSet.has(code)).sort();

  assert.deepEqual(missing, [], `validator에 없는 사이드바 leaf: ${missing.join(", ")}`);
  assert.deepEqual(extra, [], `menuConfig에 없는 유령 코드(validator만 존재): ${extra.join(", ")}`);
});
