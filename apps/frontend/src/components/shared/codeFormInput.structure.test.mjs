/**
 * 코드성 등록·수정 칸 직접입력 금지 구조 테스트 (우측 패널 · 등록 영역)
 *
 * 조회 필터는 codeFilterInput.structure.test.mjs 가 본다. 이 테스트는 그 테스트가 빼 둔
 * 등록·수정 폼 파일(FormPanel/Modal/ActionPanel/ScanPanel/Panel/Form)과, 화면(page.tsx) 안의
 * 등록 영역 칸을 본다. 다른 마스터를 가리키는 코드나 기준코드(ISYS_BASECODE)는 손으로 치게 두지 않는다.
 *   라인 → ProdLineSelect / 설비 → EquipSelect / 공정 → ProcessSelect / 공급처 → SupplierSelect
 *   품목 → PartSearchField / 모델 → ModelSearchField / 지그 → PopupSearchField(jig-search)
 *   S-PARTS → MoldCodeField / 기준코드 → ComCodeSelect(groupCode)
 *
 * 그 화면이 등록하는 자기 키, 저장값이 코드가 아니라 자유 문장인 칸은 ALLOW 에 이유와 함께 둔다.
 *
 * 실행: node --test apps/frontend/src/components/shared/codeFormInput.structure.test.mjs
 */
import assert from "node:assert/strict";
import { readdirSync, readFileSync } from "node:fs";
import { dirname, join, relative } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";
import { findInputsByBinding } from "./codeInputScan.mjs";

const here = dirname(fileURLToPath(import.meta.url));
const appDir = join(here, "../../app/(authenticated)");

/** 폼에서 선택·조회로만 받아야 하는 바인딩 */
const FORM_BINDS = /^(lineCode[12]?|workstageCode|machineCode|supplierCode|customerCode|itemCode|modelName|moldCode|moldUom|priceChangeReason|repairReasonCode|repairVendorCode|defectCode|lineDivision|jigCode|lineType|issueAccount|checkStatus|locationCode)$/;

/** 등록·수정 폼 파일 */
const FORM_FILE = /(FormPanel|Modal|ActionPanel|ScanPanel|Panel|Form)\.tsx$/;

/** 화면(page.tsx) 안 등록 영역 — 이 바인딩은 직접입력이면 안 된다 */
const PAGE_REGISTER = {
  "jig/repair-request/page.tsx": ["jigCode", "repairReasonCode", "repairVendorCode"],
  "warehouse/barcode-receipt/page.tsx": ["originSupplierCode"],
  "warehouse/msl-check/page.tsx": ["actionCode"],
  "production/run-card/page.tsx": ["pcbSupplierCode"],
  "process-transaction/wip-close/page.tsx": ["itemCode"],
};

/** "경로:바인딩" → 직접입력으로 두는 이유 */
const ALLOW = {
  "jig/master/components/JigMasterFormPanel.tsx:jigCode": "지그마스터 자기 키",
  "jig/master/components/JigMasterFormPanel.tsx:customerCode": "저장값이 고객 코드가 아니라 손으로 친 이름(INFAC, TS MOST 등)",
  "jig/master/components/JigMasterFormPanel.tsx:supplierCode": "저장값이 공급처 코드가 아니라 손으로 친 제작처 이름(신일정밀 등)",
  "master/customer/components/CustomerFormPanel.tsx:customerCode": "고객마스터 자기 키",
  "mold/master/components/MoldMasterFormPanel.tsx:moldCode": "S-PARTS 마스터 자기 키",
  "smt/location/components/SmtLocationFormPanel.tsx:locationCode": "피더 위치코드 마스터 자기 키",
  "smt/bom/components/SmtBomFormPanel.tsx:locationCode": "피더 위치(창고 아님), PB 자유입력",
  "smt/bom-replace/components/SmtBomReplaceFormPanel.tsx:locationCode": "피더 위치(창고 아님), PB 자유입력",
};

function* walk(dir) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    const p = join(dir, e.name);
    if (e.isDirectory()) yield* walk(p);
    else if (p.endsWith(".tsx")) yield p;
  }
}

test("form panels use shared selects for code fields", () => {
  const offenders = [];
  for (const file of walk(appDir)) {
    const rel = relative(appDir, file).replaceAll("\\", "/");
    const pageBinds = PAGE_REGISTER[rel];
    if (!FORM_FILE.test(file) && !pageBinds) continue;
    const pattern = pageBinds ? new RegExp(`^(${pageBinds.join("|")})$`) : FORM_BINDS;
    for (const hit of findInputsByBinding(readFileSync(file, "utf8"), pattern, file)) {
      if (ALLOW[`${rel}:${hit.bind}`]) continue;
      offenders.push(`${rel}:${hit.line} [${hit.bind}]`);
    }
  }
  assert.deepEqual(offenders, [], `공용 선택/조회 컴포넌트로 바꿔야 하는 코드성 입력칸:\n${offenders.join("\n")}`);
});

test("allow list has no stale entries", () => {
  const stale = [];
  for (const key of Object.keys(ALLOW)) {
    const [rel, bind] = key.split(":");
    const src = readFileSync(join(appDir, rel), "utf8");
    if (findInputsByBinding(src, new RegExp(`^${bind}$`), rel).length === 0) stale.push(key);
  }
  assert.deepEqual(stale, [], `더 이상 직접입력이 아닌 ALLOW 항목:\n${stale.join("\n")}`);
});
