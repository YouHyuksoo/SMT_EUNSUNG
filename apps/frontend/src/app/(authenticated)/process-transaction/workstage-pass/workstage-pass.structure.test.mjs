import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const page = readFileSync(new URL('./page.tsx', import.meta.url), 'utf8');
const menu = readFileSync(new URL('../../../../config/menuConfig.ts', import.meta.url), 'utf8');

test('공정통과 화면은 스캔·취소와 PB 5개 조회 모드를 제공한다', () => {
  assert.match(page, /\/process-transaction\/workstage-pass\/scan/);
  for (const mode of ['wait', 'history', 'inventory', 'today', 'workstageSummary']) assert.match(page, new RegExp(mode));
  assert.match(page, /cancel/);
});

test('공정수불관리 하위 메뉴에 등록한다', () => {
  assert.match(menu, /PLN_WORKSTAGE_PASS/);
  assert.match(menu, /\/process-transaction\/workstage-pass/);
});
