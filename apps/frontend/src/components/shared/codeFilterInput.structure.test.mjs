/**
 * 코드성 조회 필터 직접입력 금지 구조 테스트
 *
 * 라인·공정·설비·창고·공급처·S-PARTS·공통코드성 값은 조회 필터에서 손으로 치게 두지 않는다.
 *   라인 → LineSelect / 공정 → ProcessSelect / 설비 → EquipSelect / 공급처 → SupplierSelect
 *   창고·유형·상태 → ComCodeSelect(groupCode) / 모델 → ModelSearchField / S-PARTS → MoldCodeField
 * 판정은 placeholder 글자가 아니라 value 에 묶인 필드 이름으로 한다.
 *
 * 등록·수정 폼 파일(FormPanel/Modal/ActionPanel/ScanPanel)은 대상이 아니다.
 * 화면 안 등록 영역이나 PB 원본도 자유입력(so_singlelineedit)이던 칸은 EXEMPT 에 이유와 함께 둔다.
 *
 * 실행: node --test apps/frontend/src/components/shared/codeFilterInput.structure.test.mjs
 */
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, join, relative } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const appDir = join(here, "../../app");
const ts = createRequire(import.meta.url)("typescript");

/** 코드성 필터 바인딩 이름 */
const CODE_BINDS = /^(lineCode|workstageCode|machineCode|locationCode|invLocationCode|supplierCode|customerCode|moldCode|itemDivision|itemClass|packType|inventoryStatus|inventoryHold|pidIssueType|lineType|issueAccount|checkStatus)$/;

/** 등록·수정 폼 파일 */
const FORM_FILE = /(FormPanel|Modal|ActionPanel|ScanPanel)\.tsx$/;

/** "경로:바인딩" → 이유 */
const EXEMPT = {
  "mold/issue/page.tsx:machineCode": "출고 등록 영역 입력 (조회 필터 아님)",
  "quality/wqc/page.tsx:machineCode": "스캔 등록 영역 입력 (조회 필터 아님)",
  "query/pda-ng/page.tsx:checkStatus": "선택 행 검사상태 저장 입력 (조회 필터 아님)",
  "warehouse/etc-issue/page.tsx:workstageCode": "기타출고 등록 영역",
  "warehouse/etc-issue/page.tsx:machineCode": "기타출고 등록 영역",
  "warehouse/etc-issue/page.tsx:issueAccount": "기타출고 등록 영역",
  "warehouse/etc-receipt/page.tsx:locationCode": "기타입고 등록 영역",
  "warehouse/etc-receipt/page.tsx:supplierCode": "기타입고 등록 영역",
  "warehouse/etc-receipt/page.tsx:lineType": "기타입고 등록 영역",
  "warehouse/solder-label/page.tsx:supplierCode": "솔더 라벨 발행 등록 영역",
  "query/pda-scan/page.tsx:locationCode": "피더위치(창고 아님), PB sle_location_code 자유입력",
  "smt/location/page.tsx:locationCode": "피더 위치코드(창고 아님), PB 에 조건 없음",
};

function* walk(dir) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    const p = join(dir, e.name);
    if (e.isDirectory()) yield* walk(p);
    else if (p.endsWith(".tsx")) yield p;
  }
}

/** 소스에서 코드성 바인딩을 가진 텍스트 <Input>/<input> 목록 */
export function findCodeInputs(src, fileName = "x.tsx") {
  const sf = ts.createSourceFile(fileName, src, ts.ScriptTarget.Latest, true, ts.ScriptKind.TSX);
  const out = [];
  const visit = (n) => {
    if ((ts.isJsxSelfClosingElement(n) || ts.isJsxOpeningElement(n)) && /^(Input|input)$/.test(n.tagName.getText())) {
      const attrs = {};
      for (const a of n.attributes.properties) if (ts.isJsxAttribute(a)) attrs[a.name.getText()] = a;
      const type = attrs.type?.initializer && ts.isStringLiteral(attrs.type.initializer) ? attrs.type.initializer.text : "text";
      const valueText = attrs.value?.initializer ? attrs.value.initializer.getText().replace(/^\{|\}$/g, "") : "";
      const bind = valueText.match(/([A-Za-z_$][\w$]*)\s*$/)?.[1] ?? "";
      // 조건 없는 readOnly/disabled 는 조회 버튼·모달 결과를 보여주는 표시 전용 칸
      const displayOnly = ["readOnly", "disabled"].some((k) => k in attrs && (!attrs[k].initializer || attrs[k].initializer.getText() === "{true}"));
      if (/^(text|search)$/.test(type) && CODE_BINDS.test(bind) && !displayOnly) {
        out.push({ bind, line: sf.getLineAndCharacterOfPosition(n.getStart()).line + 1 });
      }
    }
    ts.forEachChild(n, visit);
  };
  visit(sf);
  return out;
}

test("code-like filters use shared selects instead of free text Input", () => {
  const offenders = [];
  for (const file of walk(appDir)) {
    if (FORM_FILE.test(file)) continue;
    const rel = relative(join(appDir, "(authenticated)"), file).replaceAll("\\", "/");
    for (const hit of findCodeInputs(readFileSync(file, "utf8"), file)) {
      if (EXEMPT[`${rel}:${hit.bind}`]) continue;
      offenders.push(`${rel}:${hit.line} [${hit.bind}]`);
    }
  }
  assert.deepEqual(offenders, [], `공용 선택/조회 컴포넌트로 바꿔야 하는 코드성 필터:\n${offenders.join("\n")}`);
});

test("detection keys on binding name, not placeholder", () => {
  const hits = findCodeInputs(`<>
    <Input placeholder={f("line")} value={filters.lineCode} onChange={() => {}} />
    <Input value={workstageCode} onChange={() => {}} />
    <Input value={lotNo} onChange={() => {}} />
    <Input type="number" value={lineCode} onChange={() => {}} />
    <input value={form.machineCode} readOnly placeholder="설비선택" />
  </>`);
  assert.deepEqual(hits.map((h) => h.bind), ["lineCode", "workstageCode"]);
});
