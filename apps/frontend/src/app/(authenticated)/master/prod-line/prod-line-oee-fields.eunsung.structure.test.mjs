import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const root = new URL('../../../../../', import.meta.url);
const read = (path) => fs.readFileSync(new URL(path, root), 'utf8');

test('production-line form exposes the approved OEE selects and transitions', () => {
  const source = read('src/components/master/ProdLineTab.tsx');

  for (const field of ['processCode', 'resourceType', 'parentLineCode']) {
    assert.match(source, new RegExp(`FieldSelect field="${field}"`));
  }
  assert.match(source, /processCode: "SMT"/);
  assert.match(source, /resourceType: "LINE"/);
  assert.match(source, /line\.lineCode !== formData\.lineCode/);
  assert.match(source, /resourceType === "LINE"/);
  assert.match(source, /resourceType === "CELL"/);
});

test('production-line grid places workplace, OEE type, and parent after line status', () => {
  const source = read('src/components/master/ProdLineTab.tsx');
  const status = source.indexOf('accessorKey: "lineStatus"');
  const process = source.indexOf('accessorKey: "processCode"');
  const resource = source.indexOf('accessorKey: "resourceType"');
  const parent = source.indexOf('accessorKey: "parentLineCode"');

  assert.ok(status >= 0 && status < process);
  assert.ok(process < resource);
  assert.ok(resource < parent);
  for (const column of ['PROCESS_CODE', 'RESOURCE_TYPE', 'PARENT_LINE_CODE']) {
    assert.match(source, new RegExp(column));
  }
});

test('production-line help maps all OEE fields to IP_PRODUCT_LINE', () => {
  const help = read('src/app/(authenticated)/master/prod-line/components/ProdLineFieldHelp.tsx');
  assert.match(help, /processCode: \{ db: "IP_PRODUCT_LINE\.PROCESS_CODE"/);
  assert.match(help, /resourceType: \{ db: "IP_PRODUCT_LINE\.RESOURCE_TYPE"/);
  assert.match(help, /parentLineCode: \{ db: "IP_PRODUCT_LINE\.PARENT_LINE_CODE"/);
});
