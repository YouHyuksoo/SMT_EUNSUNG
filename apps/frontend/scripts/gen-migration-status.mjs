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
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const frontendRoot = join(scriptDir, '..');
const repoRoot = join(frontendRoot, '..', '..');
const menuConfigPath = join(frontendRoot, 'src', 'config', 'menuConfig.ts');
const inventoryPath = join(scriptDir, 'data', 'pb-screen-inventory.json');
const outPath = join(repoRoot, 'docs', 'business-logics', 'pb-screen-migration-status.md');
const linkOutPath = join(repoRoot, 'docs', 'business-logics', 'pb-menu-route-links.md');

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
    const entry = {
      code: child.code,
      path: child.path,
      label: label(child.labelKey),
      group: label(cat.labelKey),
      pbLinkStatus: child.pbLinkStatus ?? null,
      pbWindow: child.pbWindow ?? null,
      pbEvidence: child.pbEvidence ?? null,
      pbLinkNote: child.pbLinkNote ?? null,
    };
    developed.push(entry);
    if (child.pbWindow) developedByWindow.set(child.pbWindow.toLowerCase(), entry);
  }
}

// --- 검증: 모든 웹 메뉴의 PB 연결 상태 / 윈도우 근거 / 중복 ---
const inventoryWindows = new Set(inventory.screens.map((s) => (s.window || '').toLowerCase()).filter(Boolean));
const errors = [];
const seen = new Map();
for (const e of developed) {
  if (!['powerbuilder', 'web-native', 'unresolved'].includes(e.pbLinkStatus)) {
    errors.push(`${e.code} (${e.path})에 pbLinkStatus가 없습니다.`);
    continue;
  }
  if (e.pbLinkStatus === 'web-native') {
    if (e.pbWindow || e.pbEvidence || e.pbLinkNote) errors.push(`${e.code}는 web-native이므로 PB 윈도우/근거/미해결 사유를 가질 수 없습니다.`);
    continue;
  }
  if (e.pbLinkStatus === 'unresolved') {
    if (e.pbWindow || e.pbEvidence) errors.push(`${e.code}는 unresolved이므로 확정 PB 윈도우/근거를 가질 수 없습니다.`);
    if (!e.pbLinkNote) errors.push(`${e.code}는 unresolved 사유(pbLinkNote)가 필요합니다.`);
    continue;
  }
  if (!e.pbWindow) {
    errors.push(`${e.code}는 powerbuilder 연결이므로 pbWindow가 필요합니다.`);
    continue;
  }
  const w = e.pbWindow.toLowerCase();
  if (!inventoryWindows.has(w)) {
    if (!e.pbEvidence) {
      errors.push(`pbWindow "${e.pbWindow}" (${e.code})가 PB 메뉴 인벤토리에 없으므로 pbEvidence가 필요합니다.`);
    } else {
      const evidencePath = join(repoRoot, e.pbEvidence);
      if (!existsSync(evidencePath)) errors.push(`${e.code}의 pbEvidence 파일이 없습니다: ${e.pbEvidence}`);
      else if (!readFileSync(evidencePath, 'utf8').toLowerCase().includes(w)) errors.push(`${e.code}의 pbEvidence에 ${e.pbWindow}가 없습니다: ${e.pbEvidence}`);
    }
  }
  if (seen.has(w)) errors.push(`pbWindow "${e.pbWindow}" 가 ${seen.get(w)} 와 ${e.code} 두 화면에 중복 선언됐습니다.`);
  else seen.set(w, e.code);
}

// 장비 공통 화면 정의가 menuConfig의 연결 계약과 어긋나지 않게 한다.
const equipmentDefinitionsPath = join(frontendRoot, 'src', 'app', '(authenticated)', 'equipment', 'result-query', '_lib', 'result-query-definitions.ts');
const equipmentDefinitions = readFileSync(equipmentDefinitionsPath, 'utf8');
for (const match of equipmentDefinitions.matchAll(/menuCode:\s*'([^']+)'[^\n]*pbWindow:\s*'([^']+)'/g)) {
  const [, code, pbWindow] = match;
  const linked = developed.find((e) => e.code === code);
  if (!linked) errors.push(`장비 정의 ${code}가 menuConfig에 없습니다.`);
  else if (linked.pbWindow?.toLowerCase() !== pbWindow.toLowerCase()) errors.push(`장비 정의 ${code}의 pbWindow(${pbWindow})가 menuConfig(${linked.pbWindow ?? '없음'})와 다릅니다.`);
}
if (errors.length > 0) {
  console.error('이관 현황 검증 실패:');
  for (const m of errors) console.error(`  - ${m}`);
  process.exit(1);
}

const checkOnly = process.argv.includes('--check');
if (checkOnly) {
  const mapped = developed.filter((e) => e.pbLinkStatus === 'powerbuilder').length;
  const native = developed.filter((e) => e.pbLinkStatus === 'web-native').length;
  const unresolved = developed.filter((e) => e.pbLinkStatus === 'unresolved').length;
  console.log(`PB 연결 계약 OK: 웹 메뉴 ${developed.length}개 (PB ${mapped} / 웹 신규 ${native} / 미확정 ${unresolved}).`);
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
const mappedMenus = developed.filter((e) => e.pbLinkStatus === 'powerbuilder');
const nativeMenus = developed.filter((e) => e.pbLinkStatus === 'web-native');
const unresolvedMenus = developed.filter((e) => e.pbLinkStatus === 'unresolved');
const verifiedCommit = execFileSync('git', ['rev-parse', '--short', 'HEAD'], { cwd: repoRoot, encoding: 'utf8' }).trim();

const L = [];
L.push('---');
L.push('sources:');
L.push('  - apps/frontend/src/config/menuConfig.ts');
L.push('  - apps/frontend/scripts/data/pb-screen-inventory.json');
L.push('generator: apps/frontend/scripts/gen-migration-status.mjs');
L.push(`verifiedCommit: ${verifiedCommit}`);
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
L.push(`웹 메뉴 연결 계약: **PB ${mappedMenus.length}개 / 웹 신규 ${nativeMenus.length}개 / 미확정 ${unresolvedMenus.length}개**. PB 매핑과 웹 경로의 전체 연결표는 [pb-menu-route-links.md](pb-menu-route-links.md)에서 관리합니다.`);
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
if (unresolvedMenus.length > 0) {
  L.push('## PB 연결 미확정 웹 화면');
  L.push('');
  L.push('추정 연결을 금지한다. PB 원본이 소스나 메뉴 인벤토리로 확인되면 `menuConfig.ts`의 상태를 `powerbuilder`로 바꾸고 근거를 함께 기록한다.');
  L.push('');
  L.push('| 그룹 | 화면 | 코드 | 경로 | 미확정 사유 |');
  L.push('|---|---|---|---|---|');
  for (const e of unresolvedMenus) L.push(`| ${e.group} | ${e.label} | \`${e.code}\` | \`${e.path}\` | ${e.pbLinkNote} |`);
  L.push('');
}

writeFileSync(outPath, L.join('\n'), 'utf8');

const R = [];
R.push('---');
R.push('sources:');
R.push('  - apps/frontend/src/config/menuConfig.ts');
R.push('  - apps/frontend/scripts/data/pb-screen-inventory.json');
R.push('generator: apps/frontend/scripts/gen-migration-status.mjs');
R.push(`verifiedCommit: ${verifiedCommit}`);
R.push('---');
R.push('');
R.push('# PB 윈도우 ↔ 웹 메뉴·경로 연결표 (자동 생성)');
R.push('');
R.push('> **직접 수정하지 마세요.** 메뉴 클릭 경로와 PB 원본의 연결 계약은 `menuConfig.ts`에서 관리합니다.');
R.push('> 새 메뉴는 `powerbuilder`, `web-native`, `unresolved` 중 하나를 반드시 선언해야 하며 `pnpm test`가 누락·중복·오타를 차단합니다.');
R.push('');
R.push('## 연결 현황');
R.push('');
R.push('| 전체 웹 메뉴 | PB 연결 | 웹 신규 | 미확정 |');
R.push('|---:|---:|---:|---:|');
R.push(`| ${developed.length} | ${mappedMenus.length} | ${nativeMenus.length} | ${unresolvedMenus.length} |`);
R.push('');
R.push('## 전체 연결표');
R.push('');
R.push('| 그룹 | 웹 메뉴 | 메뉴코드 | 웹 경로 | 연결 상태 | PB 윈도우 | 근거/사유 |');
R.push('|---|---|---|---|---|---|---|');
for (const e of developed) {
  const status = e.pbLinkStatus === 'powerbuilder' ? 'PB 연결' : e.pbLinkStatus === 'web-native' ? '웹 신규' : '미확정';
  const evidence = e.pbLinkStatus === 'powerbuilder'
    ? (inventoryWindows.has(e.pbWindow.toLowerCase()) ? 'PB 메뉴 인벤토리' : `\`${e.pbEvidence}\``)
    : (e.pbLinkNote ?? 'PB 대응 없음');
  R.push(`| ${e.group} | ${e.label} | \`${e.code}\` | \`${e.path}\` | ${status} | ${e.pbWindow ? '\`' + e.pbWindow + '\`' : ''} | ${evidence} |`);
}
R.push('');
writeFileSync(linkOutPath, R.join('\n'), 'utf8');

console.log(`Generated migration status → docs/business-logics/pb-screen-migration-status.md (완료 ${done} / 미착수 ${todo} / 미상 ${unknown})`);
console.log(`Generated PB route links → docs/business-logics/pb-menu-route-links.md (PB ${mappedMenus.length} / 웹 신규 ${nativeMenus.length} / 미확정 ${unresolvedMenus.length})`);
