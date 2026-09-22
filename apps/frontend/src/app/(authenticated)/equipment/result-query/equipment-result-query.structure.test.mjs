import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import test from 'node:test';

const frontendRoot = join(import.meta.dirname, '../../../../..');
const read = (path) => readFileSync(join(frontendRoot, path), 'utf8');

const screens = [
  ['EQUIP_RESULT_SP', 'sp'],
  ['EQUIP_RESULT_SPI', 'spi'],
  ['EQUIP_RESULT_ICT', 'ict'],
  ['EQUIP_RESULT_AOI', 'aoi'],
  ['EQUIP_RESULT_ROUTER', 'router'],
  ['EQUIP_RESULT_ROM_WRITE', 'rom-write'],
  ['EQUIP_RESULT_SOLDER', 'solder'],
  ['EQUIP_RESULT_REFLOW', 'reflow'],
  ['EQUIP_RESULT_PERFORMANCE', 'performance'],
];

test('설비관리 메뉴에서 9개 작업·검사결과 조회 화면으로 이동할 수 있다', () => {
  const menu = read('src/config/menuConfig.ts');
  for (const [code, slug] of screens) {
    assert.match(menu, new RegExp(`code: "${code}"[\\s\\S]*?path: "/equipment/result-query/${slug}"`));
    assert.ok(existsSync(join(frontendRoot, `src/app/(authenticated)/equipment/result-query/${slug}/page.tsx`)));
  }
});

test('9개 화면은 공통 PB 결과조회 컴포넌트와 정의를 사용한다', () => {
  const definitions = read('src/app/(authenticated)/equipment/result-query/_lib/result-query-definitions.ts');
  const component = read('src/app/(authenticated)/equipment/result-query/_components/EquipmentResultQueryPage.tsx');
  for (const [, slug] of screens) assert.match(definitions, new RegExp(`['"]${slug}['"]`));
  assert.match(component, /DataGrid/);
  assert.match(component, /ProdLineSelect/);
  assert.match(component, /api\.get\(`\/equipment\/result-queries\/\$\{definition\.type\}`/);
});

test('각 메뉴는 사용자·운영자 도움말과 manifest 항목을 가진다', () => {
  const manifest = read('public/help/manifest.json');
  for (const [code, slug] of screens) {
    assert.match(manifest, new RegExp(`"menuCode": "${code}"[\\s\\S]*?"path": "/equipment/result-query/${slug}"`));
    for (const audience of ['user', 'operator']) {
      const path = join(frontendRoot, `public/help/${audience}/ko/${code}.md`);
      assert.ok(existsSync(path), path);
      const help = readFileSync(path, 'utf8');
      assert.equal(help.startsWith('---'), true);
      assert.match(help, new RegExp(`menuCode: ${code}`));
      assert.match(help, new RegExp(`audience: ${audience}`));
    }
  }
});
