#!/usr/bin/env node
/**
 * @file verify-build.mjs
 * @description 빌드 산출물 무결성 검증 — build-manifest.json에 적힌 모든 청크가
 *   실제 디스크에 존재하는지 확인. 누락 시 exit 1로 배포·기동을 막는다.
 * 초보자 가이드:
 *   - 빌드 직후 manifest 파일과 실제 .next/static 청크가 어긋난 적이 있어 자동 검증을 추가했다.
 *   - HTML이 참조하는 청크 파일이 디스크에 없으면 브라우저가 CSS/JS 404를 받아 화면이 깨진다.
 *   - 이 스크립트는 그 mismatch를 빌드 단계에서 잡아낸다.
 * 사용:
 *   node scripts/verify-build.mjs
 *   또는 package.json의 postbuild 훅으로 자동 실행됨.
 */
import { readFileSync, existsSync, readdirSync } from "node:fs";
import path from "node:path";

const cwd = process.cwd();
const nextDir = path.join(cwd, ".next");

function fail(msg) {
  console.error(`❌ ${msg}`);
  process.exit(1);
}

if (!existsSync(nextDir)) {
  fail("`.next` 폴더가 없습니다 — `npm run build`를 먼저 실행하세요.");
}

const manifestPath = path.join(nextDir, "build-manifest.json");
if (!existsSync(manifestPath)) {
  fail("`build-manifest.json`이 없습니다 — 빌드가 비정상 종료되었을 수 있습니다.");
}

const manifest = JSON.parse(readFileSync(manifestPath, "utf-8"));

const sections = [
  ["polyfillFiles", manifest.polyfillFiles ?? []],
  ["lowPriorityFiles", manifest.lowPriorityFiles ?? []],
  ["rootMainFiles", manifest.rootMainFiles ?? []],
];

for (const [route, files] of Object.entries(manifest.pages ?? {})) {
  sections.push([`pages[${route}]`, files]);
}

const missing = [];
let total = 0;

for (const [section, files] of sections) {
  for (const file of files) {
    total++;
    if (!existsSync(path.join(nextDir, file))) {
      missing.push({ section, file });
    }
  }
}

if (missing.length > 0) {
  console.error(`❌ 빌드 산출물 무결성 실패 — ${missing.length}/${total}개 청크 누락:`);
  for (const { section, file } of missing.slice(0, 30)) {
    console.error(`   [${section}] ${file}`);
  }
  if (missing.length > 30) {
    console.error(`   ... 그 외 ${missing.length - 30}개`);
  }
  console.error("");
  console.error("복구 절차:");
  console.error("  1) pm2 stop mes-display");
  console.error("  2) rmdir /S /Q .next");
  console.error("  3) npm run build");
  console.error("  4) pm2 restart mes-display");
  process.exit(1);
}

const chunksDir = path.join(nextDir, "static", "chunks");
let cssCount = 0;
let jsCount = 0;
if (existsSync(chunksDir)) {
  for (const f of readdirSync(chunksDir)) {
    if (f.endsWith(".css")) cssCount++;
    else if (f.endsWith(".js")) jsCount++;
  }
}

const buildId = readFileSync(path.join(nextDir, "BUILD_ID"), "utf-8").trim();

console.log(`✅ 빌드 무결성 검증 통과`);
console.log(`   - manifest 청크 ${total}개 모두 존재`);
console.log(`   - chunks/: JS ${jsCount}개, CSS ${cssCount}개`);
console.log(`   - BUILD_ID: ${buildId}`);
