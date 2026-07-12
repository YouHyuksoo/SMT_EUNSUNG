import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const root = resolve(import.meta.dirname, '../../../../..');
const read = (path) => readFileSync(resolve(root, path), 'utf8');

test('purchase price menu is synchronized between frontend and backend seed', () => {
  const frontend = read('src/config/menuConfig.ts');
  const seed = read('../backend/src/seeds/menu-config.json');
  const whitelist = read('../backend/src/modules/menu-categories/utils/menu-code-validator.ts');
  const defaultLayout = read('../backend/src/modules/menu-categories/utils/default-menu-category-layout.ts');
  assert.match(frontend, /MST_PURCHASE_PRICE/);
  assert.match(frontend, /\/master\/purchase-price/);
  assert.match(seed, /MST_PURCHASE_PRICE/);
  assert.match(whitelist, /MST_PURCHASE_PRICE/);
  assert.match(defaultLayout, /MST_PURCHASE_PRICE/);
  assert.match(read('src/components/layout/pageRegistry.generated.ts'), /case "\/master\/purchase-price"/);
});

test('supplier options use the legacy supplier endpoint', () => {
  const hooks = read('src/hooks/useMasterOptions.ts');
  const select = read('src/components/shared/SupplierSelect.tsx');
  assert.match(hooks, /useSupplierOptions/);
  assert.match(hooks, /\/master\/suppliers/);
  assert.match(select, /useSupplierOptions/);
});

test('purchase price page provides filters and impact-confirmed create and update', () => {
  const page = read('src/app/(authenticated)/master/purchase-price/page.tsx');
  const panel = read('src/app/(authenticated)/master/purchase-price/components/PurchasePriceFormPanel.tsx');
  assert.match(page, /\/master\/purchase-prices/);
  assert.match(page, /validOnly/);
  assert.match(page, /PartSearchModal/);
  assert.match(panel, /\/master\/purchase-prices\/impact/);
  assert.match(panel, /mode: isEdit \? "update" : "create"/);
  assert.match(panel, /ConfirmModal/);
  assert.match(panel, /api\.post\("\/master\/purchase-prices"/);
  assert.match(panel, /api\.put\("\/master\/purchase-prices"/);
  assert.match(panel, /closingRows/);
  assert.doesNotMatch(panel, /api\.delete|승인.*Button|approve/i);
});

test('purchase price labels exist in every locale', () => {
  for (const locale of ['ko', 'en', 'zh', 'vi']) {
    const source = read(`src/locales/${locale}.json`);
    assert.match(source, /"purchasePrice"/);
  }
});
