import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";

const grid = fs.readFileSync(new URL("./components/ProcessEquipGrid.tsx", import.meta.url), "utf8");

test("places the assign action before the title in the DataGrid fullscreen toolbar row", () => {
  const toolbar = grid.match(
    /toolbarLeft=\{\s*\/\* assigned-equipment-toolbar:start \*\/[\s\S]*?\/\* assigned-equipment-toolbar:end \*\/\s*\}/,
  )?.[0] ?? "";

  assert.ok(toolbar, "assigned equipment toolbar block must exist");
  assert.match(toolbar, /toolbarLeft=\{/);
  assert.match(toolbar, /<Button[^>]*className="!h-7 flex-shrink-0 !px-2 !text-xs"[^>]*onClick=\{onAdd\}/);
  assert.match(toolbar, /assignEquipment/);
  assert.match(toolbar, /assignedEquipments/);
  assert.ok(toolbar.indexOf("assignEquipment") < toolbar.indexOf("assignedEquipments"));
  assert.match(toolbar, /\{equipments\.length\}\{t\("common\.count"/);
  assert.doesNotMatch(grid, /className="px-4 pt-3 pb-1 border-b border-border flex-shrink-0"/);
});
