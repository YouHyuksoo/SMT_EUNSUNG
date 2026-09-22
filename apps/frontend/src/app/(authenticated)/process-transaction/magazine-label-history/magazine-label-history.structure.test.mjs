import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const read = path => fs.readFileSync(new URL(path, import.meta.url), 'utf8');
const page = read('./page.tsx');
const columns = read('./columns.tsx');
const matrix = read('./matrix.ts');
const menu = read('../../../../config/menuConfig.ts');

test('magazine label history preserves all PB query controls and three views', () => {
  for (const token of ['LineSelect', 'ProcessSelect', 'modelName', 'magazineLabelNo', 'runNo', 'dateFrom', 'dateTo', 'history', 'summary', 'matrix', 'DataGrid']) {
    assert.match(page, new RegExp(token));
  }
});

test('matrix mode pivots receipt date and magazine label type like the PB crosstab', () => {
  assert.match(page, /pivotMagazineMatrix/);
  assert.match(columns, /matrixColumnKeys/);
  assert.match(matrix, /receiptDate[\s\S]*magazineLabelType/);
});

test('history grid exposes the PB DataWindow fields', () => {
  for (const field of ['magazineLabelType', 'runNo', 'magazineLabelNo', 'enterDate', 'lineCode', 'workstageCode', 'receiptDate', 'modelName', 'modelSuffix', 'itemCode', 'pcbItem', 'lotQty', 'badQty', 'transferMagazineLabelNo']) {
    assert.match(columns, new RegExp(`accessorKey: ['"]${field}['"]`));
  }
});

test('route is registered below process transaction', () => {
  assert.match(menu, /PROCESS_TRANSACTION[\s\S]*PLN_MAGAZINE_LABEL_HISTORY/);
  assert.match(menu, /\/process-transaction\/magazine-label-history/);
});
