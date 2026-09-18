import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import test from 'node:test';

const source = readFileSync(resolve(import.meta.dirname, 'page.tsx'), 'utf8');

test('tablet result entry keeps the three-step touch workflow', () => {
  assert.match(source, /01 \/ LINE · CELL/);
  assert.match(source, /02 \/ WORK ORDER/);
  assert.match(source, /03 \/ RESULT/);
  assert.match(source, /min-h-16/);
  assert.match(source, /min-h-\[76px\]/);
  assert.match(source, /WorkResultForm/);
});

test('tablet result entry reuses the PC work-result data contract', () => {
  assert.match(source, /api\.get\('\/oee\/work-result'/);
  assert.match(source, /api\.get\('\/oee\/work-result\/machines'/);
  assert.match(source, /lineCode/);
  assert.doesNotMatch(source, /alert\(|confirm\(|prompt\(/);
});

test('result entry exposes an editable work-order date and reloads the selected line', () => {
  assert.match(source, /useState\(currentKstDate\)/);
  assert.match(source, /type="date"/);
  assert.match(source, /value=\{workDate\}/);
  assert.match(source, /setWorkDate\(event\.target\.value\)/);
  assert.match(source, /fromDate: workDate, toDate: workDate/);
});

test('resources are grouped by workplace and parent-line hierarchy', () => {
  assert.match(source, /PROCESS_CODES\.map\(\(processCode\)/);
  assert.match(source, /data-workplace=\{processCode\}/);
  assert.match(source, /groupResourceHierarchy\(processResources\)/);
  assert.match(source, /parentLineCode/);
  assert.match(source, /selectedResource\?\.resourceCode/);
  assert.match(source, /OEE 실적 입력/);
});

test('tablet result entry supports the shared fullscreen convention', () => {
  assert.match(source, /searchParams\.get\('view'\) === 'full'/);
  assert.match(source, /next\.set\('view', 'full'\)/);
});
