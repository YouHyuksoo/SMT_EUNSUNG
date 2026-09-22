/**
 * @file scripts/gen-migration-status.mjs
 * @description PB 화면 이관 현황 문서를 menuConfig(정본)에서 자동 생성한다.
 *
 * 왜 자동생성인가:
 * - 이관 현황을 손으로 관리하면, 화면을 개발해도 문서에 완료 표기를 안 해 미착수로 남는다(드리프트).
 * - menuConfig.ts 의 각 화면에 `pbWindow` 를 달면, 이 스크립트가 PB 인벤토리와 대조해
 *   완료/미착수를 자동 판정하고 docs 를 재생성한다. 개발과 문서가 항상 일치한다.
 *
 * 입력:
 *   - src/config/menuConfig.ts        : 개발된 화면(정본). pbWindow 로 PB 원본을 명시.
 *   - scripts/data/pb-screen-inventory.json : PB 업무화면 스냅샷(order/group/window/origin).
 * 출력:
 *   - ../../docs/business-logics/pb-screen-migration-status.md
 *
 * 사용: `node scripts/gen-migration-status.mjs` (pnpm test/dev 파이프라인에서 자동 실행)
 * 검증: `--check` 로 실행하면 menuConfig.pbWindow 의 오타/중복만 검사하고 문서를 쓰지 않는다.
 */
import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const frontendRoot = join(scriptDir, '..');
const repoRoot = join(frontendRoot, '..', '..');
const menuConfigPath = join(frontendRoot, 'src', 'config', 'menuConfig.ts');
const inventoryPath = join(scriptDir, 'data', 'pb-screen-inventory.json');
const outPath = join(repoRoot, 'docs', 'business-logics', 'pb-screen-migration-status.md');

/** menuConfig.ts 의 배열 리터럴을 파싱한다(icon 컴포넌트 제거 후 평가). gen-menu-registration 과 동일 패턴. */
function parseMenuConfig() {
  const source = readFileSync(menuConfigPath, 'utf8');
  const marker = source.indexOf('export const menuConfig');
  const eq = source.indexOf('=', marker);
  const arrStart = source.indexOf('[', eq);
  let depth = 0;
  let end = -1;
  for (let i = arrStart; i < source.length; i++) {
    if (source[i] === '[') depth++;
    else if (source[i] === ']' && --depth === 0) { end = i; break; }
  }
  const literal = source.slice(arrStart, end + 1).replace(/icon:\s*\w+,?/g, '');
  return new Function(`return ${literal};`)();
}

/** ko 라벨 조회 */
function loadKoLabels() {
  const ko = JSON.parse(readFileSync(join(frontendRoot, 'src', 'locales', 'ko.json'), 'utf8'));
  return ko.menu ?? {};
}

const menu = parseMenuConfig();
const ko = loadKoLabels();
const inventory = JSON.parse(readFileSync(inventoryPath, 'utf8'));
const label = (key) => ko[String(key).replace(/^menu\./, '')] ?? key;

/** 개발된 화면: pbWindow -> { code, path, label } */
const developedByWindow = new Map();
const developed = [];
for (const cat of menu) {
  for (const child of cat.children ?? []) {
    const entry = { code: child.code, path: child.path, label: label(child.labelKey), group: label(cat.labelKey), pbWindow: child.pbWindow ?? null };
    developed.push(entry);
    if (child.pbWindow) developedByWindow.set(child.pbWindow.toLowerCase(), entry);
  }
}

// --- 검증: pbWindow 오타(인벤토리에 없음) / 중복 ---
const inventoryWindows = new Set(inventory.screens.map((s) => (s.window || '').toLowerCase()).filter(Boolean));
const errors = [];
const seen = new Map();
for (const e of developed) {
  if (!e.pbWindow) continue;
  const w = e.pbWindow.toLowerCase();
  if (!inventoryWindows.has(w)) {
    errors.push(`menuConfig 의 pbWindow "${e.pbWindow}" (${e.code}) 가 PB 인벤토리에 없습니다. 오타이거나 인벤토리 갱신이 필요합니다.`);
  }
  if (seen.has(w)) errors.push(`pbWindow "${e.pbWindow}" 가 ${seen.get(w)} 와 ${e.code} 두 화면에 중복 선언됐습니다.`);
  else seen.set(w, e.code);
}
if (errors.length > 0) {
  console.error('이관 현황 검증 실패:');
  for (const m of errors) console.error(`  - ${m}`);
  process.exit(1);
}

const checkOnly = process.argv.includes('--check');
if (checkOnly) {
  console.log(`이관 현황 검증 OK: 개발 화면 ${developed.length}개, pbWindow 매핑 ${developedByWindow.size}개.`);
  process.exit(0);
}

// --- 문서 생성 ---
const bizScreens = inventory.screens;
const groups = [];
const byGroup = new Map();
for (const sc of bizScreens) {
  if (!byGroup.has(sc.groupCode)) { byGroup.set(sc.groupCode, []); groups.push({ code: sc.groupCode, text: sc.group }); }
  byGroup.get(sc.groupCode).push(sc);
}

const statusOf = (sc) => {
  const dev = sc.window ? developedByWindow.get(sc.window.toLowerCase()) : null;
  if (dev) return { status: '완료', mes: dev.code, path: dev.path };
  if (!sc.window) return { status: '윈도우미상', mes: '', path: '' };
  return { status: '미착수', mes: '', path: '' };
};

let done = 0, todo = 0, unknown = 0;
for (const sc of bizScreens) {
  const st = statusOf(sc).status;
  if (st === '완료') done++; else if (st === '윈도우미상') unknown++; else todo++;
}
// menuConfig 에 있으나 pbWindow 미지정(=PB 매핑 안 된 개발 화면)
const developedNoPb = developed.filter((e) => !e.pbWindow);

const L = [];
L.push('---');
L.push('sources:');
L.push('  - apps/frontend/src/config/menuConfig.ts');
L.push('  - apps/frontend/scripts/data/pb-screen-inventory.json');
L.push('generator: apps/frontend/scripts/gen-migration-status.mjs');
L.push('---');
L.push('');
L.push('# PB 화면 이관 현황 (자동 생성)');
L.push('');
L.push('> **이 문서는 자동 생성됩니다. 직접 수정하지 마세요.**');
L.push('> `menuConfig.ts` 의 각 화면에 `pbWindow: "w_..."` 를 달면 이 문서가 자동으로 완료로 반영합니다.');
L.push('> 재생성: `pnpm --filter @eunsung/frontend gen:migration` (pnpm test/dev 에서 자동 실행).');
L.push('');
L.push('## 현황');
L.push('');
L.push('| 상태 | 건수 |');
L.push('|---|---:|');
L.push(`| PB 업무화면(셸 메뉴 제외) | ${bizScreens.length} |`);
L.push(`| 완료(개발됨, pbWindow 매핑) | ${done} |`);
L.push(`| 미착수 | ${todo} |`);
L.push(`| 윈도우 미상 | ${unknown} |`);
L.push('');
L.push(`개발됐지만 아직 PB 원본(pbWindow) 미지정 화면: **${developedNoPb.length}개** — 이관 완료 판정에 포함되지 않습니다. 아래 목록 참고.`);
L.push('');
L.push('## 대분류별 진행률');
L.push('');
L.push('| 대분류 | 코드 | 전체 | 완료 | 미착수 | 윈도우미상 |');
L.push('|---|---|---:|---:|---:|---:|');
for (const g of groups) {
  const scs = byGroup.get(g.code);
  const d = scs.filter((s) => statusOf(s).status === '완료').length;
  const u = scs.filter((s) => statusOf(s).status === '윈도우미상').length;
  L.push(`| ${g.text} | \`${g.code}\` | ${scs.length} | ${d} | ${scs.length - d - u} | ${u} |`);
}
L.push('');
L.push('## 화면 목록');
L.push('');
for (const g of groups) {
  L.push(`### ${g.text}  \`${g.code}\``);
  L.push('');
  L.push('| 순서 | 메뉴명 | PB 윈도우 | 원본 | 상태 | MES 메뉴코드 | 경로 |');
  L.push('|---:|---|---|:--:|---|---|---|');
  for (const sc of byGroup.get(g.code)) {
    const st = statusOf(sc);
    const ind = sc.level === '3' ? '└ ' : '';
    L.push(`| ${sc.order} | ${ind}${sc.text} | ${sc.window ? '`' + sc.window + '`' : ''} | ${sc.origin || '—'} | ${st.status} | ${st.mes ? '`' + st.mes + '`' : ''} | ${st.path ? '`' + st.path + '`' : ''} |`);
  }
  L.push('');
}
if (developedNoPb.length > 0) {
  L.push('## PB 원본(pbWindow) 미지정 개발 화면');
  L.push('');
  L.push('menuConfig 에 있으나 `pbWindow` 가 없어 PB 이관 완료로 집계되지 않습니다. PB 원본을 아는 화면은 `pbWindow` 를 채우세요(신규/비PB 화면은 그대로 두면 됩니다).');
  L.push('');
  L.push('| 그룹 | 화면 | 코드 | 경로 |');
  L.push('|---|---|---|---|');
  for (const e of developedNoPb) L.push(`| ${e.group} | ${e.label} | \`${e.code}\` | \`${e.path}\` |`);
  L.push('');
}

writeFileSync(outPath, L.join('\n'), 'utf8');
console.log(`Generated migration status → docs/business-logics/pb-screen-migration-status.md (완료 ${done} / 미착수 ${todo} / 미상 ${unknown} / pbWindow미지정 ${developedNoPb.length})`);
