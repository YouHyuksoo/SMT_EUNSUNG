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
  assert.match(toolbar, /<Button size="sm" onClick=\{onAdd\}>/);
  assert.match(toolbar, /<Plus className="w-4 h-4 mr-1" \/>/);
  assert.doesNotMatch(toolbar, /!h-7|!px-2|!text-xs/);
  assert.match(toolbar, /assignEquipment/);
  assert.match(toolbar, /assignedEquipments/);
  assert.ok(toolbar.indexOf("assignEquipment") < toolbar.indexOf("assignedEquipments"));
  assert.match(toolbar, /\{equipments\.length\}\{t\("common\.count"/);
  assert.doesNotMatch(grid, /className="px-4 pt-3 pb-1 border-b border-border flex-shrink-0"/);
});
