import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";

const frontendRoot = fs.existsSync("src/app") ? "." : "apps/frontend";
const companyFormPath = `${frontendRoot}/src/app/(authenticated)/master/company/components/CompanyForm.tsx`;
const sectionPath = `${frontendRoot}/src/app/(authenticated)/master/company/components/CellManagementSection.tsx`;
const typesPath = `${frontendRoot}/src/app/(authenticated)/master/company/types.ts`;
const localePaths = ["ko", "en", "zh", "vi"].map(
  (locale) => `${frontendRoot}/src/locales/${locale}.json`,
);

const companyForm = fs.readFileSync(companyFormPath, "utf8");
const section = fs.existsSync(sectionPath) ? fs.readFileSync(sectionPath, "utf8") : "";
const types = fs.readFileSync(typesPath, "utf8");

test("CELL 조회는 승인된 2F/PROD2 계약과 페이지 파라미터를 사용한다", () => {
  assert.match(
    section,
    /api\.get\("\/master\/plants",\s*\{\s*params:\s*\{\s*plantType:\s*"CELL",\s*page:\s*"1",\s*limit:\s*"10000"\s*\}\s*,[\s\S]*?\}\s*\)/,
  );
  assert.match(section, /plant\.plantCode\s*===\s*"EUNSUNG"/);
  assert.match(section, /plant\.shopCode\s*===\s*"2F"/);
  assert.match(section, /plant\.lineCode\s*===\s*"PROD2"/);
  assert.match(section, /plant\.plantType\s*===\s*"CELL"/);

  const cellGet = section.match(/api\.get\([\s\S]*?\);/)?.[0] ?? "";
  assert.doesNotMatch(cellGet, /\b(?:company|plantCd)\b/);
});

test("CELL 수정은 4-key URL과 encodeURIComponent를 사용하고 editable 필드는 3개뿐이다", () => {
  assert.match(types, /encodeURIComponent\(/);
  assert.match(section, /api\.put\(`\/master\/plants\/\$\{getPlantPath\(editingCell\)\}`/);
  assert.match(
    section,
    /const cellPayload = \{\s*plantName:\s*[^,]+,\s*useYn:\s*[^,]+,\s*sortOrder:\s*[^\n]+\s*\};/,
  );
  const payload = section.match(/const cellPayload = \{[\s\S]*?\};/)?.[0] ?? "";
  assert.doesNotMatch(payload, /\b(?:plantCode|shopCode|lineCode|cellCode|company|plantCd)\b/);
  assert.match(section, /value=\{draft\.plantName\}/);
  assert.match(section, /<UseYnSelect[\s\S]*?value=\{draft\.useYn\}/);
  assert.match(section, /type="number"[^>]*min=\{0\}[^>]*value=\{draft\.sortOrder\}/);
  assert.match(section, /label=\{t\("master\.company\.cellName"[\s\S]*?maxLength=\{200\}/);
  assert.match(section, /plantCode[\s\S]*aria-readonly="true"/);
  assert.match(section, /shopCode[\s\S]*aria-readonly="true"/);
  assert.match(section, /lineCode[\s\S]*aria-readonly="true"/);
  assert.match(section, /cellCode[\s\S]*aria-readonly="true"/);
});

test("기존 사업장 CRUD는 tenant body/query 없이 새 복합키 계약을 사용한다", () => {
  const plantGet = companyForm.match(/api\.get\("\/master\/plants",[\s\S]*?\);/)?.[0] ?? "";
  assert.doesNotMatch(plantGet, /\b(?:company|plantCd)\s*:/);

  const addPlant = companyForm.match(/const handleAddPlant = async \(\) => \{[\s\S]*?\n\s*\};/)?.[0] ?? "";
  assert.match(addPlant, /api\.post\("\/master\/plants"/);
  assert.doesNotMatch(addPlant, /\b(?:company|plantCd)\s*:/);

  const deletePlant = companyForm.match(/const handleDeletePlantConfirm = async \(\) => \{[\s\S]*?\n\s*\};/)?.[0] ?? "";
  assert.match(deletePlant, /api\.delete\(`\/master\/plants\/\$\{getPlantPath\(deletePlantTarget\)\}`/);
  assert.doesNotMatch(deletePlant, /`\/master\/plants\/\$\{deletePlantTarget\.plantCode\}`/);
});

test("Plant 타입은 실제 tenant 응답 필드를 사용하고 잘못된 plant alias를 두지 않는다", () => {
  const plantInterface = types.match(/export interface Plant \{([\s\S]*?)\n\}/)?.[1] ?? "";
  assert.match(plantInterface, /\bcompany\??:\s*string/);
  assert.match(plantInterface, /\bplantCd\??:\s*string/);
  assert.doesNotMatch(plantInterface, /\bplant\??:\s*string/);
});

test("CELL add/delete API는 범위 밖이며 company와 CELL dirty를 OR로 보고한다", () => {
  assert.doesNotMatch(section, /api\.(post|delete)\(/);
  assert.doesNotMatch(section, /addCell|deleteCell|Trash2/);
  assert.match(companyForm, /const dirty = companyDirty \|\| cellDirty/);
  assert.match(companyForm, /onDirtyChange\?\.\(dirty\)/);
});

test("활성 4개 locale에 CELL 관리 번역 key가 모두 있다", () => {
  const requiredKeys = [
    "cellSection",
    "cellCode",
    "cellName",
    "cellUseYn",
    "cellSortOrder",
    "cellEdit",
    "cellEditTitle",
    "cellPlantCode",
    "cellShopCode",
    "cellLineCode",
    "cellLoading",
    "cellEmpty",
    "cellLoadError",
    "cellRetry",
    "cellSaveSuccess",
    "cellSaveError",
    "cellNameRequired",
    "cellSortOrderInvalid",
    "cellDiscardConfirm",
  ];

  for (const localePath of localePaths) {
    const messages = JSON.parse(fs.readFileSync(localePath, "utf8"));
    for (const key of requiredKeys) {
      assert.equal(typeof messages.master?.company?.[key], "string", `${localePath}: ${key}`);
    }
  }
});
