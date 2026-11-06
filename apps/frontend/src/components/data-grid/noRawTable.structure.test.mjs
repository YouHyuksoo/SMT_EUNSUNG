/**
 * 목록은 DataGrid 로 그린다 — 구조 테스트
 *
 * 화면마다 `<table>` 을 직접 그리면 정렬·필터·컬럼 고정·폭 조절·내보내기가 화면마다 달라진다.
 * 조회 목록·선택 목록·업로드 미리보기·크로스탭(열이 기간마다 바뀌는 표 — report/components/crosstab.tsx)은
 * 모두 DataGrid 로 그린다. 아래 예외는 DataGrid 로 옮기면 기능을 잃는 화면이다.
 *
 * 실행: node --test apps/frontend/src/components/data-grid/noRawTable.structure.test.mjs
 */
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const SRC = join(dirname(fileURLToPath(import.meta.url)), "../..");

/** DataGrid 로 옮기지 않는 표 — 경로: 이유 */
const ALLOWED = {
  "components/data-grid/DataGrid.tsx": "DataGrid 자신",
  "components/data-grid/SqlViewerModal.tsx": "SQL 뷰어 안의 조건 표",
  "app/(authenticated)/master/bom/components/BomTab.tsx": "펼침·접힘 트리 (정렬하면 상하위 순서가 깨진다)",
  "app/(authenticated)/master/routing/components/RoutingMaterialEditor.tsx": "줄마다 체크·수량·선택을 바로 고치는 편집 표",
  "app/(authenticated)/system/inventory-close-date/page.tsx": "줄마다 날짜를 고쳐 저장하는 편집 표",
  "app/(authenticated)/production/smd-plan-board/components/LineBlock.tsx": "rowSpan 으로 두 줄을 묶는 계획판",
  "app/(authenticated)/production/run-card/components/LotCardSheets.tsx": "종이에 찍는 롯트카드·출고계획 양식",
  "components/display/screens/product-line/ProductionLineTable.tsx": "모니터링 디스플레이 화면",
  "components/display/screens/smd-status/SmdCheckItems.tsx": "모니터링 디스플레이 화면",
  "components/help/MarkdownRenderer.tsx": "도움말 마크다운의 표",
  "components/ai/AiChatPanel.tsx": "AI 답변 마크다운의 표",
};

function walk(dir, out = []) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === "node_modules") continue;
    const path = join(dir, entry.name);
    if (entry.isDirectory()) walk(path, out);
    else if (entry.name.endsWith(".tsx")) out.push(path);
  }
  return out;
}

test("목록 표는 <table> 대신 DataGrid 를 쓴다", () => {
  const hits = walk(SRC)
    .filter((path) => /<table[\s>]/.test(readFileSync(path, "utf8")))
    .map((path) => relative(SRC, path).replaceAll("\\", "/"))
    .filter((path) => !(path in ALLOWED));
  assert.deepEqual(hits, [], `DataGrid 로 바꾸세요 (기능을 잃는 표면 ALLOWED 에 이유와 함께 추가):\n${hits.join("\n")}`);
});

test("예외 목록에 더 이상 <table> 이 없는 파일이 남지 않는다", () => {
  const stale = Object.keys(ALLOWED).filter((path) => {
    try {
      return !/<table[\s>]/.test(readFileSync(join(SRC, path), "utf8"));
    } catch {
      return true;
    }
  });
  assert.deepEqual(stale, [], `ALLOWED 에서 빼세요:\n${stale.join("\n")}`);
});
