import assert from 'node:assert/strict';
import { readdirSync, readFileSync } from 'node:fs';
import { test } from 'node:test';
import { extname, join, resolve } from 'node:path';

const modulesRoot = resolve(import.meta.dirname, '..', 'modules');
const retiredSqlReference = /\b(?:FROM|JOIN|INTO|UPDATE|DELETE\s+FROM)\s+IP_PRODUCT_WORK_RESULT\b/i;

function typescriptFiles(directory) {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const path = join(directory, entry.name);
    if (entry.isDirectory()) return typescriptFiles(path);
    return extname(entry.name) === '.ts' ? [path] : [];
  });
}

test('backend SQL does not reference retired IP_PRODUCT_WORK_RESULT', () => {
  const violations = typescriptFiles(modulesRoot).filter((path) =>
    retiredSqlReference.test(readFileSync(path, 'utf8')),
  );

  assert.deepEqual(violations, []);
});
