import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

const modal = readFileSync(new URL('./components/ProcessUploadModal.tsx', import.meta.url), 'utf8');
const page = readFileSync(new URL('./page.tsx', import.meta.url), 'utf8');
const list = readFileSync(new URL('./components/ProcessList.tsx', import.meta.url), 'utf8');
const equipmentGrid = readFileSync(new URL('./components/ProcessEquipGrid.tsx', import.meta.url), 'utf8');
const ko = readFileSync(new URL('../../../../locales/ko.json', import.meta.url), 'utf8');

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

test('preserves the process editor panel and equipment assignment modal composition', () => {
  assert.match(page, /\{isPanelOpen && \(/);
  assert.match(page, /w-\[520px\].*animate-slide-in-right/s);
  assert.match(page, /editingItem \? t\("master\.process\.editProcess"\) : t\("master\.process\.addProcess"\)/);
  assert.match(page, /<Modal\s+isOpen=\{assignModalOpen\}[\s\S]*?size="md"/);
  assert.match(page, /<Select[\s\S]*?options=\{assignOptions\}[\s\S]*?onChange=\{setAssignEquipCode\}/);
});

test('process and assigned-equipment grids use a 60:40 vertical layout with room for three equipment rows', () => {
  assert.match(page, /grid-rows-\[minmax\(0,3fr\)_minmax\(220px,2fr\)\]/);
  assert.doesNotMatch(page, /grid-cols-12/);
  assert.doesNotMatch(page, /col-span-7/);
  assert.doesNotMatch(page, /col-span-5/);
});

test('directs users to select a process from the upper grid', () => {
  assert.match(ko, /"noProcessSelected": "상단에서 공정을 선택해주세요\."/);
  assert.doesNotMatch(ko, /"noProcessSelected": "좌측에서 공정을 선택해주세요\."/);
});

test('uses compact process-card padding and an inline assigned-equipment toolbar count', () => {
  assert.match(list, /<Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">/);
  assert.match(list, /<CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 py-3">/);
  assert.match(
    equipmentGrid,
    /toolbarLeft=\{[\s\S]*?assignedEquipments[\s\S]*?<span className="truncate font-normal text-text-muted">\s*- \{processCode\} \(\{processName\}\) · \{equipments\.length\}\{t\("common\.count"/,
  );
  assert.doesNotMatch(
    equipmentGrid,
    /<p[^>]*>(?:(?!<\/p>)[\s\S])*\{equipments\.length\}(?:(?!<\/p>)[\s\S])*<\/p>/,
  );
});

test('contains both grids and keeps the equipment action visible', () => {
  assert.equal(
    (page.match(/className="flex flex-col min-w-0 min-h-0 overflow-hidden"/g) ?? []).length,
    2,
  );
  assert.match(equipmentGrid, /<Card padding="none" className="flex-1 flex flex-col min-w-0 min-h-0 w-full max-w-full overflow-hidden">/);
  assert.match(equipmentGrid, /<Card className="flex-1 flex items-center justify-center min-w-0 min-h-0 w-full max-w-full overflow-hidden">/);
  assert.doesNotMatch(equipmentGrid, /className="px-4 pt-3 pb-1 border-b border-border flex-shrink-0"/);
  assert.match(equipmentGrid, /toolbarLeft=\{/);
  assert.match(equipmentGrid, /className="flex min-w-0 items-center gap-2"/);
  assert.match(equipmentGrid, /<Button size="sm" className="!h-7 flex-shrink-0 !px-2 !text-xs" onClick=\{onAdd\}>/);
  assert.match(equipmentGrid, /<CardContent className="flex-1 min-w-0 min-h-0 overflow-hidden px-4 pt-1 pb-3">/);
});
