import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";

const root = new URL("../../../../../", import.meta.url);
const read = (path) => fs.readFileSync(new URL(path, root), "utf8");

test("equipment master filters and saves by applied process", () => {
  const tab = read("src/app/(authenticated)/master/equip/components/EquipMasterTab.tsx");
  const help = read("src/app/(authenticated)/master/equip/components/EquipFieldHelp.tsx");

  assert.match(tab, /const \[processFilter, setProcessFilter\] = useState\(""\)/);
  assert.match(tab, /if \(processFilter\) params\.processCode = processFilter/);
  assert.match(tab, /processCode:\s*equip\.processCode \|\| ""/);
  assert.match(tab, /processCode:\s*form\.processCode \|\| undefined/);
  assert.match(tab, /<ProcessSelect[^>]*showProcessType[^>]*value=\{processFilter\}[^>]*onChange=\{setProcessFilter\}/s);
  assert.match(tab, /<FieldProcessSelect[^>]*field="processCode"[^>]*showProcessType[^>]*value=\{form\.processCode\}/s);
  assert.match(tab, /accessorKey: "processCode", header: t\("master\.equip\.process", "적용공정"\)/);

  const scopedPaths = [
    tab.match(/interface FormState \{[\s\S]*?\n\}/)?.[0] ?? "",
    tab.match(/const EMPTY_FORM:[\s\S]*?\n\};/)?.[0] ?? "",
    tab.match(/const \[processFilter[\s\S]*?const \[commFilter/)?.[0] ?? "",
    tab.match(/const params:[\s\S]*?const res =/)?.[0] ?? "",
    tab.match(/const nextForm:[\s\S]*?setForm\(nextForm\)/)?.[0] ?? "",
    tab.match(/const body = \{[\s\S]*?\n      \};/)?.[0] ?? "",
  ].join("\n");
  assert.doesNotMatch(scopedPaths, /lineCode|lineFilter/);

  assert.match(help, /processCode: \{ db: "IMCN_MACHINE\.WORKSTAGE_CODE"/);
  assert.match(help, /FieldProcessSelect/);
  assert.doesNotMatch(help, /FieldLineSelect|LineSelect/);
});

test("equipment applied-process labels are translated", () => {
  const expected = {
    ko: "적용공정",
    en: "Applied Process",
    zh: "应用工序",
    vi: "Công đoạn áp dụng",
  };

  for (const [locale, label] of Object.entries(expected)) {
    const messages = JSON.parse(read(`src/locales/${locale}.json`));
    assert.equal(messages.master.equip.process, label);
  }
});
