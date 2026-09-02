import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";

const grid = fs.readFileSync(new URL("./components/ProcessEquipGrid.tsx", import.meta.url), "utf8");

test("assigned equipment types use the MACHINE TYPE common-code names", () => {
  assert.match(grid, /accessorKey:\s*"equipType"[\s\S]*?groupCode="MACHINE TYPE"/);
  assert.doesNotMatch(grid, /groupCode="EQUIP_TYPE"/);
});
