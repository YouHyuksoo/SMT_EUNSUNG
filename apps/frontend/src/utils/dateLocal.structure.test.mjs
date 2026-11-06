/**
 * 날짜 문자열을 UTC 로 만들지 않는다 — 구조 테스트
 *
 * `date.toISOString().slice(0, 10)` 은 UTC 날짜다. 한국 시간 오전 9시 전에는 어제 날짜가 나와
 * 조회 기본값·등록 기본일·기간 끝 계산이 하루 밀린다. 날짜만 필요하면 utils/date 의
 * getTodayLocal(date) 을 쓴다 (백엔드는 @smt/shared 의 formatDate).
 *
 * 실행: node --test apps/frontend/src/utils/dateLocal.structure.test.mjs
 */
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const SRC = join(dirname(fileURLToPath(import.meta.url)), "..");
const UTC_DATE = /toISOString\(\)\s*\.\s*(slice|substring)\(\s*0\s*,\s*(7|10)\s*\)|toISOString\(\)\s*\.\s*split\(\s*["']T["']\s*\)/;

function walk(dir, out = []) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === "node_modules") continue;
    const path = join(dir, entry.name);
    if (entry.isDirectory()) walk(path, out);
    else if (/\.(ts|tsx)$/.test(entry.name) && !/\.(test|spec)\./.test(entry.name)) out.push(path);
  }
  return out;
}

test("날짜만 필요한 곳에 UTC 날짜(toISOString 앞자리)를 쓰지 않는다", () => {
  const hits = walk(SRC)
    .filter((path) => UTC_DATE.test(readFileSync(path, "utf8")))
    .map((path) => relative(SRC, path).replaceAll("\\", "/"));
  assert.deepEqual(hits, [], `getTodayLocal(date) 로 바꾸세요:\n${hits.join("\n")}`);
});
