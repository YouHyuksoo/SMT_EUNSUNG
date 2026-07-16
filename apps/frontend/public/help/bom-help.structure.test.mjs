import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const userHelp = readFileSync("apps/frontend/public/help/user/ko/MST_BOM.md", "utf8");
const operatorHelp = readFileSync("apps/frontend/public/help/operator/ko/MST_BOM.md", "utf8");

test("MST_BOM help is reset for current-site authoring", () => {
  assert.match(userHelp, /^---\nmenuCode: MST_BOM\n/);
  assert.match(operatorHelp, /^---\nmenuCode: MST_BOM\n/);
  assert.match(userHelp, /summary: 도움말 작성 예정/);
  assert.match(operatorHelp, /summary: 도움말 작성 예정/);
  assert.match(userHelp, /## 도움말 초기화됨/);
  assert.match(operatorHelp, /## 도움말 초기화됨/);
});

test("MST_BOM help no longer carries previous-site details", () => {
  const stalePatterns = [
    /\bHANES\b/i,
    /\bJSHANES\b/i,
    /\bSVEHICLE\b/i,
    /\bMXVC\b/i,
    /COMPANY\s*=\s*['"]?40/i,
    /PLANT_CD\s*=\s*['"]?1000/i,
    /\bBOM_MASTERS\b/,
  ];

  for (const text of [userHelp, operatorHelp]) {
    for (const pattern of stalePatterns) {
      assert.doesNotMatch(text, pattern);
    }
  }
});
