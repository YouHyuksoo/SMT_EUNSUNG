import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import test from "node:test";

const __dirname = dirname(fileURLToPath(import.meta.url));
const manifest = readFileSync(join(__dirname, "manifest.json"), "utf8");

function collectMarkdownFiles(dir) {
  const files = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const fullPath = join(dir, entry.name);
    if (entry.isDirectory()) files.push(...collectMarkdownFiles(fullPath));
    if (entry.isFile() && entry.name.endsWith(".md")) files.push(fullPath);
  }
  return files;
}

test("SYS_CONFIG help is reset for current-site authoring", () => {
  const userHelp = readFileSync(join(__dirname, "user", "ko", "SYS_CONFIG.md"), "utf8");
  const operatorHelp = readFileSync(join(__dirname, "operator", "ko", "SYS_CONFIG.md"), "utf8");

  assert.match(userHelp, /^---\nmenuCode: SYS_CONFIG\n/);
  assert.match(operatorHelp, /^---\nmenuCode: SYS_CONFIG\n/);
  assert.match(userHelp, /summary: 도움말 작성 예정/);
  assert.match(operatorHelp, /summary: 도움말 작성 예정/);
});

test("manifest still includes SYS_CONFIG route", () => {
  assert.match(manifest, /"menuCode": "SYS_CONFIG"/);
  assert.match(manifest, /"path": "\/system\/config"/);
});

test("help files do not contain previous-project identifiers", () => {
  const stalePatterns = [
    /\bHANES\b/i,
    /\bJSHANES\b/i,
    /\bSVEHICLE\b/i,
    /\bMXVC\b/i,
    /COMPANY\s*=\s*['"]?40/i,
    /PLANT_CD\s*=\s*['"]?1000/i,
    /\bITEM_MASTERS\b/,
    /\bBOM_MASTERS\b/,
    /\bPROCESS_MASTERS\b/,
  ];

  const templatePath = join("_templates");
  const files = collectMarkdownFiles(__dirname).filter((file) => !file.includes(templatePath));
  for (const file of files) {
    const text = readFileSync(file, "utf8");
    for (const pattern of stalePatterns) {
      assert.doesNotMatch(text, pattern, `stale content in ${file}`);
    }
  }
});
