import test from 'node:test';
import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';

const source = readFileSync(new URL('./SidebarMenu.tsx', import.meta.url), 'utf8');
const sidebarSource = readFileSync(new URL('./Sidebar.tsx', import.meta.url), 'utf8');
const useMenuTreeSource = readFileSync(new URL('../../hooks/useMenuTree.ts', import.meta.url), 'utf8');
const tabBarSource = readFileSync(new URL('./TabBar.tsx', import.meta.url), 'utf8');
const tabContextMenuSource = readFileSync(new URL('./TabContextMenu.tsx', import.meta.url), 'utf8');
const navigationUrl = new URL('./clientNavigation.ts', import.meta.url);
const navigationSource = existsSync(navigationUrl) ? readFileSync(navigationUrl, 'utf8') : '';
const menuConfigSource = readFileSync(new URL('../../config/menuConfig.ts', import.meta.url), 'utf8');

function resolveTranslation(resource, key) {
  const nestedValue = key.split('.').reduce((obj, part) => obj?.[part], resource);
  if (nestedValue !== undefined) return nestedValue;

  const [root, ...rest] = key.split('.');
  return resource[root]?.[rest.join('.')];
}

test('layout tab navigation avoids Next Link/router route fetches', () => {
  assert.doesNotMatch(source, /next\/link/);
  assert.doesNotMatch(source, /useRouter/);
  assert.doesNotMatch(source, /router\.push/);
  assert.doesNotMatch(source, /<Link/);
  assert.match(source, /navigateClientOnly\(menuItem\.path\)/);

  assert.doesNotMatch(tabBarSource, /useRouter/);
  assert.doesNotMatch(tabBarSource, /router\.push/);
  assert.match(tabBarSource, /navigateClientOnly\(tab\.path\)/);
  assert.match(tabBarSource, /navigateClientOnly\(next\.path\)/);

  assert.doesNotMatch(tabContextMenuSource, /useRouter/);
  assert.doesNotMatch(tabContextMenuSource, /router\.push/);
  assert.match(tabContextMenuSource, /navigateClientOnly\(active\.path\)/);

  assert.match(navigationSource, /window\.history\.pushState\(null,\s*["']["'],\s*target\)/);
  assert.doesNotMatch(navigationSource, /next\/navigation/);
});

test('sidebar keeps full help link in a fixed bottom area', () => {
  assert.match(sidebarSource, /const HELP_MENU_PATH = ["']\/help["']/);
  assert.match(sidebarSource, /labelKey: ["']help\.viewAll["']/);
  assert.match(useMenuTreeSource, /excludeHelpMenuItems\(result\)/);
  assert.match(sidebarSource, /className=["']min-h-0 flex-1 overflow-y-auto p-3["']/);
  assert.match(sidebarSource, /className=["']flex-shrink-0 border-t border-border bg-surface p-3["']/);
  assert.match(sidebarSource, /isMenuDisabled=\{\(\) => false\}/);
});

test('DB menu categories fall back to the category-specific menuConfig icon', () => {
  assert.match(useMenuTreeSource, /const categoryLookup = new Map/);
  assert.match(useMenuTreeSource, /categoryLookup\.get\(g\.categoryCode\)\?\.icon/);
  assert.match(useMenuTreeSource, /ICON_MAP\[g\.iconName \|\| ['"]['"]\] \?\? categoryLookup\.get\(g\.categoryCode\)\?\.icon \?\? Folder/);
});

test('sidebar keeps empty categories visible in the left menu', () => {
  assert.doesNotMatch(useMenuTreeSource, /if \(children\.length === 0\) return \[\]/);
  assert.doesNotMatch(useMenuTreeSource, /if \(childrenLeaf\.length === 0\) continue/);
  assert.match(useMenuTreeSource, /children:\s*childrenLeaf/);
});

test('sidebar does not discard active DB categories missing from menuConfig', () => {
  assert.doesNotMatch(useMenuTreeSource, /allowedCategoryCodes/);
  assert.doesNotMatch(useMenuTreeSource, /!allowedCategoryCodes\.has/);
});

test('top-level sidebar categories use distinct icons', () => {
  const topLevelIcons = [...menuConfigSource.matchAll(/^    icon:\s*([A-Za-z0-9_]+),$/gm)].map((match) => match[1]);

  assert.deepEqual(topLevelIcons, [
    'Database',
    'Activity',
    'Package',
    'GitBranch',
    'Boxes',
    'Building2',
    'Settings',
  ]);
  assert.equal(new Set(topLevelIcons).size, topLevelIcons.length);
});

test('all sidebar menu label keys resolve in every locale', () => {
  const labelKeys = [...menuConfigSource.matchAll(/labelKey:\s*"([^"]+)"/g)].map((match) => match[1]);
  const localeFiles = ['ko', 'en', 'vi', 'zh'];

  for (const lang of localeFiles) {
    const resource = JSON.parse(readFileSync(new URL(`../../locales/${lang}.json`, import.meta.url), 'utf8'));
    const missing = labelKeys.filter((key) => resolveTranslation(resource, key) === undefined);
    assert.deepEqual(missing, [], `${lang} locale is missing sidebar menu labels`);
  }
});
