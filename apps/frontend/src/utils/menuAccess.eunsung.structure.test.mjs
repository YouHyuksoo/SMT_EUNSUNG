// 메뉴 권한 판정이 isMenuAllowed 한 곳에만 있는지 검증하는 구조 테스트
import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (rel) => readFileSync(new URL(rel, import.meta.url), 'utf8');

const helper = read('./menuAccess.ts');
const authGuard = read('../components/layout/AuthGuard.tsx');
const menuTree = read('../hooks/useMenuTree.ts');
const pdaMenu = read('../app/pda/menu/page.tsx');
const pdaMaterialMenu = read('../app/pda/material/menu/page.tsx');

test('isMenuAllowed treats an empty allow list as "권한 미연동 = 전체 허용"', () => {
  assert.match(helper, /export function isMenuAllowed\(/);
  assert.match(helper, /if \(isAdmin\) return true;/);
  assert.match(helper, /if \(!code\) return true;/);
  assert.match(helper, /if \(allowedMenus\.length === 0\) return true;/);
  assert.match(helper, /return allowedMenus\.includes\(code\);/);
});

test('AuthGuard delegates the URL permission check to isMenuAllowed', () => {
  assert.match(authGuard, /import \{ isMenuAllowed \} from "@\/utils\/menuAccess";/);
  assert.match(authGuard, /if \(!isMenuAllowed\(menuCode, allowedMenus, isAdmin\)\)/);
  assert.doesNotMatch(authGuard, /!allowedMenus\.includes\(/);
});

test('sidebar menu filtering delegates to isMenuAllowed', () => {
  assert.match(menuTree, /import \{ isMenuAllowed \} from "@\/utils\/menuAccess";/);
  assert.match(menuTree, /isMenuAllowed\(child\.code, allowedMenus, isAdmin\)/);
  assert.match(menuTree, /isMenuAllowed\(item\.code, allowedMenus, isAdmin\)/);
  assert.doesNotMatch(menuTree, /allowedMenus\.includes\(/);
});

test('PDA menus delegate to isMenuAllowed instead of filtering inline', () => {
  for (const src of [pdaMenu, pdaMaterialMenu]) {
    assert.match(src, /import \{ isMenuAllowed \} from "@\/utils\/menuAccess";/);
    assert.match(src, /isMenuAllowed\(item\.menuCode, pdaAllowedMenus, isAdmin\)/);
    assert.doesNotMatch(src, /pdaAllowedMenus\.includes\(/);
  }
});
