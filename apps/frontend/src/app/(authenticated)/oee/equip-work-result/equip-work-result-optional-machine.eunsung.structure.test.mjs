import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const source = readFileSync(new URL('./page.tsx', import.meta.url), 'utf8');

test('work results allow an omitted machine while preserving the process', () => {
  assert.doesNotMatch(source, /if \(!form\.machineCode\) return toast\.error\('설비를 선택하세요'\)/);
  assert.doesNotMatch(source, /설비선택 <span className="text-red-500">\*<\/span>/);
  assert.match(source, /machineCode: form\.machineCode \|\| undefined/);
  assert.match(source, /workstageCode: form\.workstageCode/);
});
