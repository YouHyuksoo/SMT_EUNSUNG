import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

const page = readFileSync(new URL('./page.tsx', import.meta.url), 'utf8');
const menuConfig = readFileSync(new URL('../../../../config/menuConfig.ts', import.meta.url), 'utf8');
const ko = readFileSync(new URL('../../../../locales/ko.json', import.meta.url), 'utf8');
const en = readFileSync(new URL('../../../../locales/en.json', import.meta.url), 'utf8');
const vi = readFileSync(new URL('../../../../locales/vi.json', import.meta.url), 'utf8');
const zh = readFileSync(new URL('../../../../locales/zh.json', import.meta.url), 'utf8');

test('searches run cards with the PowerBuilder where-condition set', () => {
  assert.match(page, /\/production\/run-card/);
  assert.match(page, /params: \{ fromDate, toDate, runNo, modelName, lineCode, lotNo \}/);
  assert.match(page, /ProdLineSelect/);
});

test('never lets the user type RUN_NO — the server assigns it', () => {
  assert.match(page, /저장 시 자동 채번/);
  assert.match(page, /form\.isEdit \? \{ runNo: form\.runNo \} : \{\}/);
  // 등록 폼에서 runNo 입력을 허용하는 핸들러가 없어야 한다
  assert.doesNotMatch(page, /set\('runNo'/);
});

test('uses shared code selectors for ISYS_BASECODE columns instead of free text', () => {
  for (const codeType of ['RUN STATUS', 'PRODUCT RUN TYPE', 'SHIFT CODE', 'ARRAY TYPE', 'PCB ITEM', 'MODEL CLASS', 'ACTIVE YN']) {
    assert.match(page, new RegExp(`groupCode="${codeType}"`));
  }
});

test('warns before a delete the server will block', () => {
  assert.match(page, /deleteTarget\.pidCount > 0 \|\| deleteTarget\.resultCount > 0/);
  assert.match(page, /삭제가 차단됩니다/);
});

test('registers the production menu with the run-card leaf code', () => {
  assert.match(menuConfig, /code: "PRODUCTION"/);
  assert.match(menuConfig, /code: "PRD_RUN_CARD", labelKey: "menu\.production\.runCard", path: "\/production\/run-card"/);
});

test('translates the menu label in all four locales', () => {
  assert.match(ko, /"production\.runCard": "작업지시관리"/);
  assert.match(en, /"production\.runCard": "Work Order Management"/);
  assert.match(vi, /"production\.runCard":/);
  assert.match(zh, /"production\.runCard": "工单管理"/);
});
