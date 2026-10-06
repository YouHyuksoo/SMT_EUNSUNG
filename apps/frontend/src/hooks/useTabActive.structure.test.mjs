import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (rel) => readFileSync(new URL(rel, import.meta.url), 'utf8');

const hook = read('./useTabActive.tsx');
const keepAlive = read('../components/layout/TabKeepAlive.tsx');

// 숨겨진 탭에서 멈춰야 하는 주기 실행 화면들 (경로는 src 기준)
const POLLING_FILES = [
  '../app/(authenticated)/oee/equip-ops-status/page.tsx',
  '../app/(authenticated)/oee/equip-ops-status/components/DowntimeTab.tsx',
  '../app/(authenticated)/query/feeder-monitor/page.tsx',
  '../app/(authenticated)/query/sensor-actual/page.tsx',
  '../app/(authenticated)/tracking/line-dashboard/page.tsx',
  '../components/shared/EquipDowntimePanel.tsx',
];

test('TabKeepAlive 가 각 탭을 TabActiveProvider 로 감싸 활성 여부를 내려준다', () => {
  assert.match(keepAlive, /import \{ TabActiveProvider \} from "@\/hooks\/useTabActive"/);
  assert.match(keepAlive, /<TabActiveProvider value=\{active\}>\s*<Component \/>\s*<\/TabActiveProvider>/);
});

test('Provider 밖에서는 항상 활성(true)이라 탭 구조가 아닌 곳의 동작이 바뀌지 않는다', () => {
  assert.match(hook, /createContext\(true\)/);
});

test('useActiveInterval 은 숨겨진 탭이나 delay 없음이면 타이머를 걸지 않는다', () => {
  assert.match(hook, /if \(!active \|\| !delayMs \|\| delayMs <= 0\) return;/);
  assert.match(hook, /return \(\) => clearInterval\(id\);/);
});

test('catchUp 은 숨겨졌다 돌아온 경우에만, 주기를 놓쳤을 때 한 번 즉시 실행한다', () => {
  assert.match(hook, /const reactivated = active && !wasActiveRef\.current;/);
  assert.match(hook, /catchUp && reactivated && Date\.now\(\) - lastRunRef\.current >= delayMs/);
});

for (const rel of POLLING_FILES) {
  test(`${rel.split('/').slice(-2).join('/')} 는 setInterval 대신 useActiveInterval 을 쓴다`, () => {
    const src = read(rel);
    assert.match(src, /import \{ useActiveInterval \} from '@\/hooks\/useTabActive'/);
    assert.match(src, /useActiveInterval\(/);
    assert.doesNotMatch(src, /setInterval\(/, '화면에서 직접 setInterval 을 걸면 숨겨진 탭에서도 돈다');
  });
}

test('overall-status 시계는 앱 탭이 숨겨져도 멈춘다', () => {
  const src = read('../app/(authenticated)/oee/overall-status/page.tsx');
  assert.match(src, /import \{ useIsTabActive \} from "@\/hooks\/useTabActive"/);
  assert.match(src, /document\.hidden \|\| !tabActive/);
  assert.match(src, /if \(!tabActive\) return;/);
});