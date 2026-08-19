import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";

const root = new URL("../../../../../", import.meta.url);
const read = (path) => fs.readFileSync(new URL(path, root), "utf8");

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
