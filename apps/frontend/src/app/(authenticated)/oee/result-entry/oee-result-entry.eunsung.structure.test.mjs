import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import test from 'node:test';

const page = readFileSync(resolve(import.meta.dirname, 'page.tsx'), 'utf8');
const consoleSource = readFileSync(resolve(import.meta.dirname, 'ResultInputConsole.tsx'), 'utf8');

test('result entry targets an available 1280x800 viewport without forcing overflow and keeps a 60/40 workspace', () => {
  assert.match(page, /data-target="1280x800"/);
  assert.match(page, /h-full min-h-0 min-w-0/);
  assert.doesNotMatch(page, /h-\[800px\]|min-h-\[800px\]|min-w-\[1280px\]/);
  assert.match(page, /data-testid="oee-result-entry-grid"/);
  assert.match(page, /grid-cols-\[minmax\(0,3fr\)_minmax\(0,2fr\)\]/);
  assert.match(page, /data-layout="60-40"/);
  assert.match(page, /data-testid="oee-result-entry-left-workspace"/);
  assert.doesNotMatch(page, /WorkResultForm/);
});

test('left workspace keeps compact two-row conditions above the work-order list', () => {
  assert.match(page, /data-testid="oee-result-entry-query-bar"/);
  assert.match(page, /data-testid="oee-result-entry-query-row-1"/);
  assert.match(page, /data-testid="oee-result-entry-query-row-2"/);
  assert.match(page, /data-testid="oee-result-entry-orders-title"/);
  assert.match(page, /data-testid="oee-result-entry-query"/);
  assert.match(page, /onClick=\{queryOrders\}/);
  assert.match(page, /type="date"/);
  assert.match(page, /style=\{\{ colorScheme: 'dark' \}\}/);
  assert.match(page, /handleDateChange\(event\.target\.value\)/);
});

test('line picker uses the shared modal, staged multi-line controls, and scoped persistence', () => {
  assert.match(page, /<Modal/);
  assert.match(page, /PROCESS_CODES: OeeProcessCode\[\] = \['ASSY'\]/);
  assert.match(page, /role="tablist"/);
  assert.match(page, /setDraftLineCodes\(\[\]\)/);
  assert.match(page, /data-testid="oee-result-entry-line-card"/);
  assert.match(page, /data-testid="oee-result-entry-select-all"/);
  assert.match(page, /data-testid="oee-result-entry-deselect-all"/);
  assert.match(page, /data-testid="oee-result-entry-line-apply"/);
  assert.match(page, /LINE_SELECTION_STORAGE_PREFIX/);
  assert.match(page, /organizationId/);
  assert.match(page, /user\.id/);
  assert.match(page, /localStorage\.getItem/);
  assert.match(page, /localStorage\.setItem/);
  assert.match(page, /api\.get\('\/oee\/mobile\/resources'/);
});

test('work orders use one explicit combined multi-line query and auto-select the first incomplete order', () => {
  assert.equal(page.match(/api\.get\('\/oee\/work-result'/g)?.length, 1);
  assert.match(page, /lineCodes: requestLineCodes\.join\(','\)/);
  assert.match(page, /fromDate: workDate, toDate: workDate/);
  assert.match(page, /void loadOrders\(false\)/);
  assert.match(page, /nextOrders\.find\(\(order\) => !isComplete\(order\)\) \?\? nextOrders\[0\]/);
  assert.match(page, /responseTruncated/);
  assert.match(page, /조회 결과가 100건으로 제한되었습니다/);
  assert.doesNotMatch(page, /multi-entry\/status/);
});

test('completed orders remain selectable while the console disables new input', () => {
  assert.match(page, /complete \? '완료' : '입력 가능'/);
  assert.match(page, /isComplete=\{isComplete\(selectedOrder\)\}/);
  assert.match(consoleSource, /disabled=\{isComplete \|\| saving\}/);
  assert.match(consoleSource, /최근 실적/);
  assert.match(consoleSource, /읽기 전용/);
});

test('touch console owns the mobile result contract without a machine selector', () => {
  assert.match(page, /ResultInputConsole/);
  assert.match(consoleSource, /data-testid="oee-result-entry-input-console"/);
  assert.match(consoleSource, /data-testid="oee-result-entry-order-summary"/);
  assert.match(consoleSource, /data-testid="oee-result-entry-overrun"/);
  assert.match(consoleSource, /data-testid="oee-result-entry-latest"/);
  assert.match(consoleSource, /data-testid=\{`oee-result-entry-\$\{field\}-card`\}/);
  assert.match(consoleSource, /field: 'resultQty'/);
  assert.match(consoleSource, /field: 'workTime'/);
  assert.match(consoleSource, /field: 'workerCount'/);
  assert.match(consoleSource, /data-testid="oee-result-entry-keypad"/);
  assert.match(consoleSource, /!isComplete && <div data-testid="oee-result-entry-keypad"/);
  assert.match(consoleSource, /data-testid="oee-result-entry-keypad"[^>]*absolute bottom-3 left-3 right-3/);
  assert.match(consoleSource, /isComplete \? '' : 'pb-\[322px\]'/);
  assert.match(consoleSource, /data-testid="oee-result-entry-keypad-clear"/);
  assert.match(consoleSource, /data-testid="oee-result-entry-keypad-backspace"/);
  assert.match(consoleSource, /data-testid=\{`oee-result-entry-key-\$\{key\}`\}/);
  assert.match(consoleSource, /clearActiveNumericField/);
  assert.match(consoleSource, /backspace/);
  assert.match(consoleSource, /KEYPAD_KEYS = \['7'.*'00', '0'\]/s);
  assert.match(consoleSource, /data-testid=\{`oee-result-entry-status-\$\{status\.toLowerCase\(\)\}`\}/);
  assert.match(consoleSource, /\['WIP', 'DONE'\]/);
  assert.match(consoleSource, /api\.post\('\/oee\/work-result\/results'/);
  assert.match(consoleSource, /sensorWarning/);
  assert.match(consoleSource, /data-testid="oee-result-entry-sensor-warning"/);
  assert.match(consoleSource, /api\.post\('\/oee\/work-result\/results\/apply-sensor'/);
  assert.doesNotMatch(consoleSource, /MachineCombo|설비를 선택/);
});

test('worker defaults to the authenticated user and supports optional mobile worker lookup', () => {
  assert.match(page, /defaultWorkerId=\{user\?\.empNo \|\| user\?\.id \|\| ''\}/);
  assert.match(consoleSource, /api\.get\(`\/oee\/mobile\/workers\/\$\{encodeURIComponent\(workerId\)\}`/);
  assert.match(consoleSource, /data-testid="oee-result-entry-worker-lookup"/);
  assert.match(consoleSource, /빈 값으로 저장 가능/);
  assert.match(consoleSource, /workerName: draft\.workerName/);
});

test('project modals guard DONE saves and discard dirty input before navigation-like actions', () => {
  assert.match(consoleSource, /<Modal/);
  assert.match(consoleSource, /doneConfirmationOpen/);
  assert.match(consoleSource, /resultStatus === 'DONE'/);
  assert.match(page, /pendingDiscardAction/);
  assert.match(page, /requestDiscard/);
  assert.match(page, /handleRemoveAppliedLine/);
  assert.match(page, /handleDateChange/);
  assert.match(page, /selectOrder/);
  assert.match(page, /queryOrders/);
  assert.doesNotMatch(page, /window\.(alert|confirm|prompt)/);
  assert.doesNotMatch(consoleSource, /window\.(alert|confirm|prompt)/);
});

test('saving refreshes the selected order and latest result while fullscreen only changes shared chrome', () => {
  assert.match(page, /await loadOrders\(true\)/);
  assert.match(page, /key=\{workOrderKey\(selectedOrder\)\}/);
  assert.match(consoleSource, /await loadLatest\(\)/);
  assert.match(page, /searchParams\.get\('view'\) === 'full'/);
  assert.match(page, /next\.set\('view', 'full'\)/);
  assert.doesNotMatch(page, /isFullView \? 'lg:grid-cols/);
});
