/**
 * 품목코드 입력칸 공용화 구조 테스트
 *
 * 품목코드를 입력받는 <Input>/<input> 이 있으면 실패한다 → PartSearchField 를 써야 한다.
 * placeholder 글자만 보면 번역 함수(placeholder={f("itemCode")}), label 만 있는 칸, placeholder 없는 폼 칸을 놓친다.
 * 그래서 여는 태그 전체(value/onChange 에 묶인 필드 이름, 번역 키, label/aria-label/placeholder 글자)로 판정한다.
 *
 * 실행: node --test apps/frontend/src/components/shared/partSearchField.structure.test.mjs
 */
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const srcDir = join(here, "../..");

/** 품목코드 칸 신호: 바인딩 필드명(itemCode, parentItemCode …), 번역 키, 한글 라벨 */
const ITEM_CODE_SIGNAL = /(\bitemCode\b|[a-z]ItemCode\b|\bitem_code\b|\bITEM_CODE\b|품목코드|품목\)코드|모품목|자품목|구성품목|대체품목|상위품목|SET 품목)/;

/** 품목코드 칸이 아니거나 품목마스터 조회 대상이 아닌 곳 (파일 경로 끝 → 이유) */
const EXEMPT = {
  "components/shared/PartSearchModal.tsx": "품목 조회 모달 자체의 검색어 입력칸",
  "app/(authenticated)/oee/equip-work-result/page.tsx": "품번·품명·설비를 함께 찾는 키워드 칸",
  "app/(authenticated)/master/equip/components/EquipBomPanel.tsx": "설비 자체 부품 목록 (품목명·유형을 직접 입력)",
};

function* walk(dir) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    if (e.name === "node_modules") continue;
    const p = join(dir, e.name);
    if (e.isDirectory()) yield* walk(p);
    else if (p.endsWith(".tsx")) yield p;
  }
}

/** pos 의 '<Tag' 부터 여는 태그 끝('>')까지 — JSX 중괄호 깊이를 고려 */
function openTag(src, pos) {
  let depth = 0;
  for (let i = pos; i < src.length; i++) {
    const c = src[i];
    if (c === "{") depth++;
    else if (c === "}") depth--;
    else if (c === ">" && depth === 0) return src.slice(pos, i + 1);
  }
  return src.slice(pos);
}

/** 조건 없이 disabled / readOnly 인 표시 전용 칸 */
const isDisplayOnly = (tag) => /\s(disabled|readOnly)(\s|\/?>|=\{true\})/.test(tag);
const isNonText = (tag) => /type=["'](date|number|checkbox|radio|hidden|file)["']/.test(tag);

export function findPlainItemCodeInputs() {
  const found = [];
  for (const file of walk(srcDir)) {
    const rel = relative(srcDir, file).replaceAll("\\", "/");
    if (Object.keys(EXEMPT).some((x) => rel.endsWith(x))) continue;
    const src = readFileSync(file, "utf8");
    for (const m of src.matchAll(/<(Input|input)[\s/>]/g)) {
      const tag = openTag(src, m.index);
      if (!ITEM_CODE_SIGNAL.test(tag) || isDisplayOnly(tag) || isNonText(tag)) continue;
      found.push(`${rel}:${src.slice(0, m.index).split("\n").length}`);
    }
  }
  return found;
}

test("item code inputs use PartSearchField instead of plain Input", () => {
  const offenders = findPlainItemCodeInputs();
  assert.deepEqual(offenders, [], `PartSearchField 로 바꿔야 하는 품목코드 입력칸:\n${offenders.join("\n")}`);
});

test("detection does not depend on placeholder text", () => {
  // 번역 함수 placeholder · label 만 있는 칸 · placeholder 없는 칸도 품목코드 칸으로 잡혀야 한다
  const samples = [
    `<Input value={filters.itemCode} onChange={e => onChange({ itemCode: e.target.value })} placeholder={f("itemCode")} />`,
    `<Input label="품목코드" value={code} onChange={(e) => setCode(e.target.value)} />`,
    `<Input value={form.parentItemCode} onChange={(e) => set('parentItemCode', e.target.value)} />`,
  ];
  for (const s of samples) assert.ok(ITEM_CODE_SIGNAL.test(openTag(s, 0)) && !isDisplayOnly(s), s);
  // 표시 전용 칸은 대상이 아니다
  assert.ok(isDisplayOnly(`<Input aria-label="모품목코드" value={form.parentItemCode} disabled fullWidth />`));
  assert.ok(!isDisplayOnly(`<Input value={form.parentItemCode} disabled={edit} onChange={() => {}} />`));
});

test("PartSearchField opens the shared PartSearchModal with the typed keyword", () => {
  const field = readFileSync(join(here, "PartSearchField.tsx"), "utf8");
  assert.match(field, /<PartSearchModal/);
  assert.match(field, /initialKeyword=\{keyword\}/);
  assert.match(readFileSync(join(here, "PartSearchModal.tsx"), "utf8"), /setKeyword\(initialKeyword\)/);
});
