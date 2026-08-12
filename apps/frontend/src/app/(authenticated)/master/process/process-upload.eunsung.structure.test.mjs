import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

const modal = readFileSync(new URL('./components/ProcessUploadModal.tsx', import.meta.url), 'utf8');
const page = readFileSync(new URL('./page.tsx', import.meta.url), 'utf8');
const list = readFileSync(new URL('./components/ProcessList.tsx', import.meta.url), 'utf8');

test('uploads a validated workbook with the selected department', () => {
  assert.match(modal, /DepartmentSelect/);
  assert.match(modal, /공정마스터/);
  assert.match(modal, /공정코드.*공정명.*공정유형.*시작공정구분.*적용라인코드/s);
  assert.match(modal, /body\.append\("file"/);
  assert.match(modal, /body\.append\("departmentCode"/);
  assert.match(modal, /\/master\/processes\/upload/);
});

test('wires the modal and renders applied line codes', () => {
  assert.match(page, /ProcessUploadModal/);
  assert.match(page, /엑셀 업로드/);
  assert.match(list, /appliedLineCodes/);
});
