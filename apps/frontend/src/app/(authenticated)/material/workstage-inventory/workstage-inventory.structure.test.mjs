import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const read = path => fs.readFileSync(new URL(path, import.meta.url), 'utf8');
const page = read('./page.tsx');
const columns = read('./columns.tsx');
const menu = read('../../../../config/menuConfig.ts');

test('workstage inventory page preserves the PB query and positive quantity filter', () => {
  assert.match(page, /\/material\/workstage-inventory/);
  assert.match(page, /PartSelect/);
  assert.match(page, /includeZero/);
  assert.match(page, /DataGrid/);
});

test('workstage inventory grid exposes the PB DataWindow columns', () => {
  for (const field of ['itemCode', 'itemName', 'itemSpec', 'itemUom', 'inventoryQty', 'enterDate', 'enterBy', 'lastModifyDate', 'lastModifyBy', 'organizationId']) {
    assert.match(columns, new RegExp(`accessorKey: ['\"]${field}['\"]`));
  }
});

test('workstage inventory route is registered in the material menu', () => {
  assert.match(menu, /MAT_WORKSTAGE_INVENTORY/);
  assert.match(menu, /\/material\/workstage-inventory/);
});
