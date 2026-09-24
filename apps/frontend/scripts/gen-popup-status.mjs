/**
 * @file scripts/gen-popup-status.mjs
 * @description PB 팝업 이관 현황 문서를 팝업 레지스트리(정본)와 PB 실측 인벤토리에서 자동 생성한다.
 *
 * 왜 자동생성인가:
 * - 팝업은 메뉴에 안 잡혀서 손으로 관리하면 "이미 만든 팝업을 또 만드는" 중복이 생긴다.
 * - packages/shared/src/popups/catalog.ts 에 엔트리를 추가하면 이 스크립트가 PB 팝업 인벤토리와
 *   대조해 ready/planned/미착수를 자동 판정한다. 구현과 문서가 어긋나지 않는다.
 *
 * 입력:
 *   - packages/shared/src/popups/catalog.ts          : 웹 팝업 정본(이관 이력)
 *   - ../../docs/database/generated/pb-popup-inventory.json : PB 팝업 실측 스냅샷
 * 출력:
 *   - ../../docs/business-logics/pb-popup-migration-status.md
 *
 * 사용: `node scripts/gen-popup-status.mjs`
 * 검증: `--check` 는 문서를 쓰지 않고 레지스트리 정합성(오타/중복)만 검사한다.
 */
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const frontendRoot = join(scriptDir, '..');
const repoRoot = join(frontendRoot, '..', '..');
const catalogPath = join(repoRoot, 'packages', 'shared', 'src', 'popups', 'catalog.ts');
const inventoryPath = join(repoRoot, 'docs', 'database', 'generated', 'pb-popup-inventory.json');
const outPath = join(repoRoot, 'docs', 'business-logics', 'pb-popup-migration-status.md');

const checkOnly = process.argv.includes('--check');

/** catalog.ts 의 배열 리터럴만 떼어내 평가한다 (menuConfig 파싱과 동일 패턴). */
function parseRegistry() {
  const source = readFileSync(catalogPath, 'utf8');
  const marker = source.indexOf('export const POPUP_CATALOG');
  if (marker < 0) throw new Error('POPUP_CATALOG 선언을 찾지 못했습니다.');
  // `PopupEntry[]` 의 대괄호를 집지 않도록 대입 연산자 뒤에서 배열을 찾는다.
  const arrStart = source.indexOf('[', source.indexOf('=', marker));
  let depth = 0;
  let end = -1;
  for (let i = arrStart; i < source.length; i++) {
    if (source[i] === '[') depth++;
    else if (source[i] === ']' && --depth === 0) { end = i; break; }
  }
  return new Function(`return ${source.slice(arrStart, end + 1)};`)();
}

const registry = parseRegistry();

if (!existsSync(inventoryPath)) {
  // --check 는 빌드/dev 파이프라인에서 돈다. 인벤토리는 PB 소스가 있어야 만들 수 있으므로
  // 없을 때 파이프라인을 막지 않고 건너뛴다. 문서 생성은 인벤토리가 있어야만 한다.
  if (checkOnly) {
    console.warn(`PB 팝업 인벤토리가 없어 팝업 현황 검사를 건너뜁니다: ${inventoryPath}`);
    process.exit(0);
  }
  console.error(
    `PB 팝업 인벤토리가 없습니다: ${inventoryPath}\n` +
    '생성: python ~/.claude/skills/powerbuilder/scripts/pb_popup_inventory.py ' +
    '--source-dir "PBL Library 10.5" --output docs/database/generated/pb-popup-inventory.json',
  );
  process.exit(1);
}
const inventory = JSON.parse(readFileSync(inventoryPath, 'utf8'));
const byWindow = new Map(inventory.windows.map((w) => [w.window.toLowerCase(), w]));

// --- 정합성 검사 -----------------------------------------------------------
const errors = [];
const seenId = new Set();
const seenWindow = new Map();
for (const entry of registry) {
  if (seenId.has(entry.id)) errors.push(`중복 팝업 id: ${entry.id}`);
  seenId.add(entry.id);
  if (!Array.isArray(entry.pbWindows) || entry.pbWindows.length === 0) {
    errors.push(`${entry.id}: pbWindows 가 비었습니다.`);
  }
  for (const w of entry.pbWindows ?? []) {
    const key = w.toLowerCase();
    if (!byWindow.has(key)) errors.push(`${entry.id}: PB 인벤토리에 없는 창 \`${w}\` (오타 확인)`);
    if (seenWindow.has(key)) errors.push(`PB 창 \`${w}\` 가 ${seenWindow.get(key)} 와 ${entry.id} 에 중복 매핑`);
    seenWindow.set(key, entry.id);
  }
  // ready 는 전용 컴포넌트 또는 엔진 설정(query) 둘 중 하나로 동작해야 한다.
  if (entry.status === 'ready' && !entry.component && !entry.query) {
    errors.push(`${entry.id}: status=ready 인데 component 도 query 도 없습니다.`);
  }
}
if (errors.length > 0) {
  console.error('팝업 레지스트리 정합성 오류:');
  for (const e of errors) console.error(`  - ${e}`);
  process.exit(1);
}
if (checkOnly) {
  console.log(`팝업 레지스트리 정합성 OK (${registry.length}건)`);
  process.exit(0);
}

// --- 현황 문서 -------------------------------------------------------------
let verifiedCommit = 'unknown';
try {
  verifiedCommit = execFileSync('git', ['rev-parse', '--short', 'HEAD'], { cwd: repoRoot })
    .toString().trim();
} catch { /* git 없는 환경에서는 unknown 으로 둔다 */ }

const KIND_LABEL = {
  'search-select': '검색선택형',
  readonly: '조회전용',
  complex: '복합/폼',
  util: '시스템/유틸',
};
const STATUS_LABEL = { ready: '연결가능', planned: '정의완료', excluded: '제외' };

const statusByWindow = new Map();
for (const entry of registry) {
  for (const w of entry.pbWindows) statusByWindow.set(w.toLowerCase(), entry);
}

const kinds = ['search-select', 'readonly', 'complex', 'util'];
const L = [];
L.push('---');
L.push('sources:');
L.push('  - packages/shared/src/popups/catalog.ts');
L.push('  - docs/database/generated/pb-popup-inventory.json');
L.push('generator: apps/frontend/scripts/gen-popup-status.mjs');
L.push(`verifiedCommit: ${verifiedCommit}`);
L.push('---');
L.push('');
L.push('# PB 팝업 이관 현황 (자동 생성)');
L.push('');
L.push('> **직접 수정하지 마세요.** 팝업을 만들거나 연결하면');
L.push('> `packages/shared/src/popups/catalog.ts` 에 엔트리를 추가하세요.');
L.push('> 재생성: `pnpm --filter @eunsung/frontend gen:popup-status`');
L.push('');
L.push('PB 팝업 판정 기준은 파일명이 아니라 호출관계입니다 — 다른 창에서');
L.push('`Open`/`OpenWithParm` 으로 열리는 창, 그리고 `*_popup` 으로 끝나는 창.');
L.push('');
L.push('> **분류(`kind`)는 정적 분석 결과입니다.** 값 반환은 두 가지 관용구로 잡습니다 —');
L.push('> `CloseWithReturn(...)` 과 전역 구조체(`gst_return.gvs_return[n] = ...`).');
L.push('> 둘 다 아닌 방식으로 값을 넘기는 창은 `조회전용` 으로 잡힐 수 있으니,');
L.push('> 실제로 연결할 때는 호출처 스크립트를 함께 확인하세요.');
L.push('');
L.push('## 현황');
L.push('');
L.push('| 분류 | PB 팝업 | 연결가능 | 정의완료 | 제외 | 미착수 |');
L.push('|---|---:|---:|---:|---:|---:|');
for (const kind of kinds) {
  const list = inventory.windows.filter((w) => w.kind === kind);
  const c = { ready: 0, planned: 0, excluded: 0 };
  for (const w of list) {
    const e = statusByWindow.get(w.window);
    if (e) c[e.status] += 1;
  }
  const todo = list.length - c.ready - c.planned - c.excluded;
  L.push(`| ${KIND_LABEL[kind]} | ${list.length} | ${c.ready} | ${c.planned} | ${c.excluded} | ${todo} |`);
}
L.push('');
L.push('## 등록된 웹 팝업');
L.push('');
L.push('| 팝업 id | 상태 | 제목 | 컴포넌트 | 조회 API | 대응 PB 창 | 비고 |');
L.push('|---|---|---|---|---|---|---|');
for (const e of registry) {
  const windows = e.pbWindows.map((w) => `\`${w}\``).join('<br>');
  L.push(
    `| \`${e.id}\` | ${STATUS_LABEL[e.status] ?? e.status} | ${e.title} | ` +
    `${e.component ? `\`${e.component}\`` : '엔진(SearchSelectModal)'} | ` +
    `${e.query ? `\`/popup-search/${e.query}\`` : e.endpoint ? `\`${e.endpoint}\`` : '미연결'} | ${windows} | ${e.note ?? ''} |`,
  );
}
L.push('');
L.push('## 미착수 PB 팝업 (호출 많은 순)');
L.push('');
L.push('`시스템/유틸` 은 PB 런타임 전용(progress, 대기, 인쇄)이라 웹 이관 대상이 아닙니다.');
L.push('');
L.push('| 호출수 | PB 창 | 분류 | 반환 방식 | 반환 컬럼 | 참조 테이블 |');
L.push('|---:|---|---|---|---|---|');
for (const w of inventory.windows) {
  if (w.kind === 'util' || statusByWindow.has(w.window)) continue;
  const style = w.returnStyle === 'close-with-return'
    ? 'CloseWithReturn'
    : w.returnStyle === 'global-struct' ? '전역구조체' : '';
  L.push(
    `| ${w.callerCount} | \`${w.window}\` | ${KIND_LABEL[w.kind]} | ${style} | ` +
    `${w.returnColumns.join(', ')} | ${w.tables.slice(0, 4).join(', ')} |`,
  );
}
L.push('');

writeFileSync(outPath, L.join('\n'), 'utf8');
const ready = registry.filter((e) => e.status === 'ready').length;
console.log(
  `Generated popup status → docs/business-logics/pb-popup-migration-status.md ` +
  `(등록 ${registry.length} / 연결가능 ${ready} / PB 팝업 ${inventory.popupCandidates})`,
);
