/**
 * @file scripts/gen-function-status.mjs
 * @description PB 함수 처리 현황 문서를 카탈로그(정본)와 PB 실측 인벤토리에서 자동 생성한다.
 *
 * 왜 자동생성인가:
 * - PB 함수는 메뉴에도 화면 목록에도 안 잡혀서, 손으로 관리하면 이미 DB 패키지로 올린 함수를
 *   TypeScript 로 또 구현하는 중복이 생긴다. 그러면 PB 와 웹이 서로 다른 로직을 탄다.
 * - 카탈로그에 엔트리를 추가하면 이 스크립트가 실측 인벤토리와 대조해 미처리분을 뽑아준다.
 *
 * 판별 원칙: PB 함수는 SQL 문장 안에서 호출할 수 없다.
 *   - SQL 안에서 불렀으면  → Oracle DB 함수 (웹도 그대로 호출. 재구현 금지)
 *   - PowerScript 에서 불렀으면 → PB 전역함수 (.srf) — 전환/치환 대상
 *
 * 입력:
 *   - scripts/data/pb-function-catalog.json                     : 처리 이력 정본
 *   - ../../docs/database/generated/pb-function-inventory.json  : PB 실측 스냅샷(창별)
 * 출력:
 *   - ../../docs/business-logics/pb-function-status.md
 *
 * 사용: `node scripts/gen-function-status.mjs`
 * 검증: `--check` 는 문서를 쓰지 않고 카탈로그 정합성(중복·오타·미존재 함수)만 검사한다.
 */
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const frontendRoot = join(scriptDir, '..');
const repoRoot = join(frontendRoot, '..', '..');
const catalogPath = join(scriptDir, 'data', 'pb-function-catalog.json');
const inventoryPath = join(repoRoot, 'docs', 'database', 'generated', 'pb-function-inventory.json');
const outPath = join(repoRoot, 'docs', 'business-logics', 'pb-function-status.md');

const checkOnly = process.argv.includes('--check');

const ACTIONS = ['converted', 'replaced', 'dropped', 'inlined', 'native', 'blocked'];
const ACTION_LABEL = {
  converted: 'DB 패키지 전환',
  replaced: '웹 수단으로 치환',
  dropped: '제거',
  inlined: '서비스에 이식',
  native: '웹에서 직접',
  blocked: '전환 보류',
};

if (!existsSync(inventoryPath)) {
  console.error(
    `PB 함수 인벤토리가 없습니다: ${inventoryPath}\n` +
    'PB 소스 폴더를 대상으로 pb_function_calls.py --per-window 로 1회 생성하세요.',
  );
  process.exit(1);
}

const catalog = JSON.parse(readFileSync(catalogPath, 'utf8'));
const inventory = JSON.parse(readFileSync(inventoryPath, 'utf8'));

/** 카탈로그 정합성 — 중복 엔트리, 알 수 없는 action, 실측에 없는 함수명 */
const seen = new Set();
const problems = [];
for (const entry of catalog.functions) {
  const name = String(entry.pbFunction ?? '').toLowerCase();
  if (!name) problems.push('pbFunction 이 비어 있는 엔트리가 있습니다.');
  else if (seen.has(name)) problems.push(`카탈로그 중복: ${name}`);
  else seen.add(name);
  if (!ACTIONS.includes(entry.action)) {
    problems.push(`${name}: 알 수 없는 action "${entry.action}" (${ACTIONS.join('|')})`);
  }
  if (entry.action === 'converted' && !entry.target) {
    problems.push(`${name}: converted 인데 target(패키지.오브젝트)이 없습니다.`);
  }
}

/** 실측 집계 — 창별 분류를 함수 단위로 접는다 */
const pbCalls = new Map();   // name -> { calls, verdict, windows:Set }
const dbCalls = new Map();   // name -> calls
for (const [window, entry] of Object.entries(inventory.windows)) {
  for (const fn of entry.pbFunctions) {
    const row = pbCalls.get(fn.name) ?? { calls: 0, verdict: fn.verdict, windows: new Set() };
    row.calls += fn.calls;
    row.windows.add(window);
    // 한 함수가 창마다 다르게 잡히지 않지만, 더 보수적인 판정을 남긴다
    if (row.verdict !== 'blocked' && fn.verdict === 'blocked') row.verdict = 'blocked';
    pbCalls.set(fn.name, row);
  }
  for (const fn of entry.dbFunctions) {
    dbCalls.set(fn.name, (dbCalls.get(fn.name) ?? 0) + fn.calls);
  }
}

for (const name of seen) {
  if (!pbCalls.has(name) && !dbCalls.has(name)) {
    problems.push(`${name}: PB 실측 인벤토리에 없는 함수입니다 (오타 또는 인벤토리 미갱신).`);
  }
}

if (problems.length > 0) {
  console.error('PB 함수 카탈로그 정합성 오류:');
  for (const problem of problems) console.error(`  - ${problem}`);
  process.exit(1);
}

if (checkOnly) {
  console.log(
    `PB 함수 카탈로그 정합성 OK (${catalog.functions.length}건 / ` +
    `실측 PB 함수 ${pbCalls.size}개, DB 함수 ${dbCalls.size}개)`,
  );
  process.exit(0);
}

const byAction = new Map(ACTIONS.map((a) => [a, []]));
for (const entry of catalog.functions) byAction.get(entry.action).push(entry);

const pending = [...pbCalls.entries()]
  .filter(([name, row]) => !seen.has(name) && row.verdict === 'convertible')
  .sort((a, b) => b[1].windows.size - a[1].windows.size || b[1].calls - a[1].calls);

let verifiedCommit = 'unknown';
try {
  verifiedCommit = execFileSync('git', ['rev-parse', '--short', 'HEAD'], { cwd: repoRoot })
    .toString().trim();
} catch { /* git 없는 환경에서는 unknown 으로 둔다 */ }

const L = [];
L.push('---');
L.push('sources:');
L.push('  - apps/frontend/scripts/data/pb-function-catalog.json');
L.push('  - docs/database/generated/pb-function-inventory.json');
L.push('generator: apps/frontend/scripts/gen-function-status.mjs');
L.push(`verifiedCommit: ${verifiedCommit}`);
L.push('---');
L.push('');
L.push('# PB 함수 처리 현황 (자동 생성)');
L.push('');
L.push('> **직접 수정하지 마세요.** 함수를 전환하거나 치환하면');
L.push('> `apps/frontend/scripts/data/pb-function-catalog.json` 에 엔트리를 추가하세요.');
L.push('> 재생성: `pnpm --filter @eunsung/frontend gen:function-status`');
L.push('');
L.push('**판별은 이름이 아니라 호출 위치입니다.** PB 함수는 SQL 문장 안에서 호출할 수 없으므로,');
L.push('SQL 안에서 불린 `f_*` 는 Oracle DB 함수이고 PowerScript 에서 불린 것은 PB 전역함수입니다.');
L.push('DB 함수는 웹에서도 **그대로 호출**합니다 — 재구현하면 PB 와 번호·판정이 갈립니다.');
L.push('');
L.push('## 현황');
L.push('');
L.push('| 구분 | 건수 |');
L.push('|---|---:|');
L.push(`| PB 창(실측) | ${inventory.windowCount} |`);
L.push(`| SQL 안 호출 = DB 함수 (조치 불필요) | ${dbCalls.size} |`);
L.push(`| SQL 밖 호출 = PB 함수 | ${pbCalls.size} |`);
L.push(`| 카탈로그 등록(처리 완료) | ${catalog.functions.length} |`);
L.push(`| 미처리 전환 후보 | ${pending.length} |`);
L.push('');
L.push('## 처리 완료 (카탈로그)');
L.push('');
for (const action of ACTIONS) {
  const rows = byAction.get(action);
  if (rows.length === 0) continue;
  L.push(`### ${ACTION_LABEL[action]} (\`${action}\`) — ${rows.length}건`);
  L.push('');
  L.push('| PB 함수 | 대상 | 비고 |');
  L.push('|---|---|---|');
  for (const row of rows) {
    L.push(`| \`${row.pbFunction}\` | ${row.target ? `\`${row.target}\`` : '—'} | ${row.note ?? ''} |`);
  }
  L.push('');
}
L.push('## 미처리 전환 후보');
L.push('');
if (pending.length === 0) {
  L.push('없습니다.');
} else {
  L.push('본문이 SQL + 분기뿐이라 DB 패키지로 옮길 수 있는 것들입니다.');
  L.push('화면을 이관할 때 그 화면이 부르는 것부터 처리하세요.');
  L.push('');
  L.push('| PB 함수 | 호출 | 창 수 | 대표 창 |');
  L.push('|---|---:|---:|---|');
  for (const [name, row] of pending.slice(0, 80)) {
    const windows = [...row.windows].slice(0, 2).join(', ');
    L.push(`| \`${name}\` | ${row.calls} | ${row.windows.size} | ${windows} |`);
  }
  if (pending.length > 80) L.push(`| … | | | 외 ${pending.length - 80}개 |`);
}
L.push('');

writeFileSync(outPath, L.join('\n'), 'utf8');
console.log(`wrote ${outPath} — 카탈로그 ${catalog.functions.length}건 / 미처리 ${pending.length}건`);
