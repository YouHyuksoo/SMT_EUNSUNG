import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

// 실적 등록 폼은 components/shared/WorkResultForm.tsx로 옮겼다 (현장 화면과 공유).
// 이 규칙은 폼이 사는 곳에서 검사한다.
const form = readFileSync(
  new URL('../../../../components/shared/WorkResultForm.tsx', import.meta.url),
  'utf8',
);
const page = readFileSync(new URL('./page.tsx', import.meta.url), 'utf8');

test('work results allow an omitted machine while preserving the process', () => {
  assert.doesNotMatch(form, /if \(!form\.machineCode\) return toast\.error\('설비를 선택하세요'\)/);
  assert.doesNotMatch(form, /설비선택 <span className="text-red-500">\*<\/span>/);
  assert.match(form, /machineCode: form\.machineCode \|\| undefined/);
  assert.match(form, /workstageCode: form\.workstageCode/);
});

test('equip work result page delegates the result form to the shared component', () => {
  assert.match(page, /<WorkResultForm\b/, '실적 폼이 공용 컴포넌트로 연결되어야 합니다');
  assert.doesNotMatch(page, /function MachineCombo\b/, '설비 콤보가 페이지에 다시 생겼습니다');
});
