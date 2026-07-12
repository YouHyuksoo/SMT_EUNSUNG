import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const hook = fs.readFileSync(new URL('./useComCode.ts', import.meta.url), 'utf8');
const purchaseColumns = fs.readFileSync(new URL('../app/(authenticated)/master/purchase-price/purchasePriceColumns.tsx', import.meta.url), 'utf8');
const saleColumns = fs.readFileSync(new URL('../app/(authenticated)/master/sale-price/salePriceColumns.tsx', import.meta.url), 'utf8');
const partPage = fs.readFileSync(new URL('../app/(authenticated)/master/part/page.tsx', import.meta.url), 'utf8');
const partColumns = fs.readFileSync(new URL('../app/(authenticated)/master/part/partColumns.tsx', import.meta.url), 'utf8');
const partPanel = fs.readFileSync(new URL('../app/(authenticated)/master/part/components/PartFormPanel.tsx', import.meta.url), 'utf8');

test('common code lookup normalizes column names and CODE_TYPE spacing', () => {
  assert.match(hook, /export function normalizeComCodeType/);
  assert.match(hook, /replace\(\/\[\^A-Z0-9\]\+\/g, ""\)/);
  assert.match(hook, /resolveComCodeGroup/);
});

test('/master/part uses ID_ITEM column names for base-code lookup and rendering', () => {
  assert.match(partPage, /groupCode="ITEM_TYPE"/);
  assert.match(partColumns, /ComCodeBadge groupCode="ITEM_TYPE"/);
  assert.match(partColumns, /ComCodeBadge groupCode="ITEM_CLASS"/);
  assert.match(partColumns, /ComCodeBadge groupCode="ITEM_UOM"/);
  assert.match(partPanel, /groupCode="ITEM_CLASS"/);
  assert.match(partPanel, /groupCode="ITEM_UOM"/);
  assert.doesNotMatch(`${partPage}\n${partColumns}\n${partPanel}`, /PRODUCT_TYPE|UNIT_TYPE|RAW_MATERIAL|DEFECT_MODEL_GROUP/);
});

test('new price grids render coded columns through ComCodeBadge', () => {
  for (const source of [purchaseColumns, saleColumns]) {
    assert.match(source, /ComCodeBadge/);
    assert.match(source, /PRICE_TYPE/);
    assert.match(source, /PRICE_CHANGE_REASON/);
    assert.match(source, /PRICE_CHANGE_CONFIRM_YN/);
  }
  assert.match(purchaseColumns, /LINE_TYPE/);
  assert.match(saleColumns, /PRODUCT_LINE_TYPE/);
});
