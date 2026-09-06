import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const frontendRoot = fs.existsSync('src/app') ? '.' : 'apps/frontend';
const read = (path) => fs.readFileSync(`${frontendRoot}/${path}`, 'utf8');
const stripComments = (source) => source.replace(/\/\*[\s\S]*?\*\//g, '').replace(/\/\/[^\r\n]*/g, '');

test('legacy OEE resource menu is hidden while its direct page remains', () => {
  const activeMenu = stripComments(read('src/config/menuConfig.ts'));
  assert.doesNotMatch(activeMenu, /code:\s*["']OEE_MST_RESOURCE["']/);

  for (const path of [
    '../backend/src/seeds/menu-config.json',
    '../backend/src/modules/menu-categories/utils/default-menu-category-layout.ts',
    '../backend/src/modules/menu-categories/utils/menu-code-validator.ts',
  ]) {
    assert.doesNotMatch(read(path), /OEE_MST_RESOURCE/);
  }

  const legacyPage = read('src/app/(authenticated)/oee/master/resource/page.tsx');
  assert.match(legacyPage, /\/oee\/resource/);
  assert.match(legacyPage, />OEE 라인 관리<\/h1>/);
});
