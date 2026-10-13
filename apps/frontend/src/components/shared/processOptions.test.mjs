import { test } from 'node:test';
import assert from 'node:assert/strict';
import { isManufacturingProcess } from './processOptions.mjs';

test('제조공정만 통과: SMT 그룹·검사 유형 제외', () => {
  assert.equal(isManufacturingProcess({ codeGroup: 'PBA', processType: 'I' }), true);
  assert.equal(isManufacturingProcess({ codeGroup: 'SMT', processType: 'I' }), false);
  assert.equal(isManufacturingProcess({ codeGroup: 'PBA', processType: 'Q' }), false);
  assert.equal(isManufacturingProcess({}), true);
});
