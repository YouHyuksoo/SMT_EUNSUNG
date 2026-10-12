/**
 * 그리드 품목 컬럼 순서 구조 테스트
 *
 * 품목코드·품목명이 들어간 그리드 컬럼 배열은 아래 순서를 지킨다.
 *   관리(actions) → 선택 체크박스(select) → 품목코드 → 품목명 → 나머지
 * 컬럼 배열은 TypeScript 파서로 읽는다 (accessorKey / id / header, columnHelper.accessor 모두 인식).
 *
 * 실행: node --test apps/frontend/src/components/data-grid/gridItemColumnOrder.structure.test.mjs
 */
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, join, relative } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const srcDir = join(here, "../..");
const ts = createRequire(import.meta.url)("typescript");

const RANK = { actions: 0, select: 1, itemCode: 2, itemName: 3, other: 4 };

function* walk(dir) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    if (e.name === "node_modules") continue;
    const p = join(dir, e.name);
    if (e.isDirectory()) yield* walk(p);
    else if (/\.tsx?$/.test(p) && !p.endsWith(".d.ts")) yield p;
  }
}

function str(node) {
  if (!node) return null;
  if (ts.isStringLiteral(node) || ts.isNoSubstitutionTemplateLiteral(node)) return node.text;
  if (ts.isCallExpression(node) && node.arguments.length) return str(node.arguments[1]) ?? str(node.arguments[0]);
  return null;
}

/** 컬럼 요소에서 {key, header}. 컬럼이 아니면 null */
function columnInfo(el) {
  if (ts.isObjectLiteralExpression(el)) {
    const props = {};
    for (const p of el.properties) if (ts.isPropertyAssignment(p)) props[p.name.getText().replace(/['"]/g, "")] = p.initializer;
    if (!("accessorKey" in props) && !("id" in props) && !("header" in props) && !("accessorFn" in props)) return null;
    return { key: str(props.accessorKey) ?? str(props.id), header: props.header ? str(props.header) : null };
  }
  if (ts.isCallExpression(el) && ts.isPropertyAccessExpression(el.expression)) {
    const fn = el.expression.name.text;
    if (fn === "accessor") {
      let header = null;
      const opts = el.arguments[1];
      if (opts && ts.isObjectLiteralExpression(opts)) {
        for (const p of opts.properties) if (ts.isPropertyAssignment(p) && p.name.getText() === "header") header = str(p.initializer);
      }
      return { key: str(el.arguments[0]), header };
    }
    if (fn === "display" && el.arguments[0] && ts.isObjectLiteralExpression(el.arguments[0])) return columnInfo(el.arguments[0]);
  }
  return null;
}

export function classify(info) {
  if (!info) return "other";
  const { key, header } = info;
  if ((key && /^item_?code$/i.test(key)) || header === "품목코드") return "itemCode";
  if ((key && /^item_?name$/i.test(key)) || header === "품목명") return "itemName";
  if ((key && /^(actions?|manage|management|_actions)$/i.test(key)) || header === "관리") return "actions";
  if (key && /^(select|selection|_select|checkbox|check)$/i.test(key)) return "select";
  return "other";
}

/** 소스 하나에서 순서 위반 컬럼 배열 목록 */
export function findOrderViolations(text, fileName = "x.tsx") {
  const sf = ts.createSourceFile(fileName, text, ts.ScriptTarget.Latest, true, fileName.endsWith("x") ? ts.ScriptKind.TSX : ts.ScriptKind.TS);
  const out = [];
  const visit = (node) => {
    if (ts.isArrayLiteralExpression(node) && node.elements.length >= 2) {
      const infos = node.elements.map((e) => (ts.isSpreadElement(e) ? "spread" : columnInfo(e)));
      const spreads = infos.filter((i) => i === "spread").length;
      const cols = infos.filter((i) => i && i !== "spread").length;
      if (cols >= 2 && cols >= node.elements.length - spreads) {
        const kinds = infos.map((i) => (i === "spread" ? "spread" : classify(i)));
        if (kinds.includes("itemCode") || kinds.includes("itemName")) {
          // 펼침 요소는 '나머지' 로 본다 → 품목 컬럼보다 앞에 오면 위반
          const ranks = kinds.map((k) => (k === "spread" ? RANK.other : RANK[k]));
          const bad = ranks.some((r, i) => i > 0 && r < ranks[i - 1]);
          if (bad) out.push({ line: sf.getLineAndCharacterOfPosition(node.getStart()).line + 1, kinds: kinds.join(",") });
        }
      }
    }
    ts.forEachChild(node, visit);
  };
  visit(sf);
  return out;
}

test("grids put actions → select → itemCode → itemName first", () => {
  const offenders = [];
  for (const file of walk(srcDir)) {
    const text = readFileSync(file, "utf8");
    if (!/itemCode|itemName|item_code|item_name|품목코드|품목명/i.test(text)) continue;
    for (const v of findOrderViolations(text, file)) {
      offenders.push(`${relative(srcDir, file).replaceAll("\\", "/")}:${v.line}  ${v.kinds}`);
    }
  }
  assert.deepEqual(offenders, [], `컬럼 순서 위반 (관리→선택→품목코드→품목명→나머지):\n${offenders.join("\n")}`);
});

test("order check catches misplaced columns", () => {
  const bad = `const c = [
    { accessorKey: 'lineName', header: '라인' },
    { accessorKey: 'itemCode', header: '품목코드' },
    { id: 'actions', header: '관리' },
  ];`;
  assert.equal(findOrderViolations(bad).length, 1);
  const spreadFirst = `const c = [...base, { accessorKey: 'itemCode' }, { accessorKey: 'itemName' }];`;
  assert.equal(findOrderViolations(spreadFirst).length, 1);
  const good = `const c = [
    { id: 'actions', header: '관리' },
    { id: 'select' },
    { accessorKey: 'itemCode', header: '품목코드' },
    { accessorKey: 'itemName', header: '품목명' },
    { accessorKey: 'qty', header: '수량' },
  ];`;
  assert.equal(findOrderViolations(good).length, 0);
});
