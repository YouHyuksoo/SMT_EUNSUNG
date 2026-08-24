import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";
import { buildComCodeOptions } from "../../../../hooks/comCodeOptions.mjs";
import { hasRequiredEquipMasterFields } from "./equipMasterValidation.mjs";

const root = new URL("../../../../../", import.meta.url);
const read = (path) => fs.readFileSync(new URL(path, root), "utf8");
const testSource = fs.readFileSync(new URL("./equip-type-options.eunsung.structure.test.mjs", import.meta.url), "utf8");

test("Node tests import runtime-compatible JavaScript helpers", () => {
  assert.match(testSource, /from "\.\.\/\.\.\/\.\.\/\.\.\/hooks\/comCodeOptions\.mjs"/);
  assert.match(testSource, /from "\.\/equipMasterValidation\.mjs"/);
});

test("equipment types come from common codes without fabricated fallbacks", () => {
  const hooks = read("src/hooks/useMasterOptions.ts");
  const tab = read("src/app/(authenticated)/master/equip/components/EquipMasterTab.tsx");

  assert.match(hooks, /useComCodeOptions\("MACHINE TYPE", false, true\)/);
  assert.match(hooks, /useComCodes\(\)/);
  assert.doesNotMatch(hooks, /\/equipment\/equips\/metadata\/types/);

  assert.match(tab, /equipType:\s*""/);
  assert.doesNotMatch(tab, /TEMP/);
  assert.match(tab, /\.\.\.equipTypeOptions\.map/);
  assert.match(tab, /options=\{equipTypeOptions\}/);
  assert.doesNotMatch(tab, /equipTypeOptions\.length\s*\?/);
});

test("all MACHINE TYPE common codes become code and name options without equipment data", () => {
  const machineTypes = Array.from({ length: 9 }, (_, index) => ({
    detailCode: `TYPE${index + 1}`,
    codeName: `설비유형 ${index + 1}`,
    codeDesc: null,
    sortOrder: index + 1,
    attr1: null,
    attr2: null,
    attr3: null,
    defectGrade: null,
  }));

  const options = buildComCodeOptions(
    { "MACHINE TYPE": machineTypes },
    "MACHINE TYPE",
    (_groupCode, _detailCode, fallback) => fallback,
    false,
    true,
    "전체",
  );

  assert.equal(options.length, 9);
  assert.deepEqual(options[0], { value: "TYPE1", label: "TYPE1 - 설비유형 1" });
  assert.deepEqual(options[8], { value: "TYPE9", label: "TYPE9 - 설비유형 9" });
});

test("blank equipment type prevents save", () => {
  assert.equal(hasRequiredEquipMasterFields({ equipCode: "MC-01", equipName: "검사기", equipType: "" }), false);
  assert.equal(hasRequiredEquipMasterFields({ equipCode: "MC-01", equipName: "검사기", equipType: "AOI" }), true);
});
