import { existsSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { basename, join, resolve } from 'node:path';

const workspace = resolve(import.meta.dirname, '..');
const pblDir = join(workspace, 'PBL Library 10.5');
const reportFile = join(workspace, 'docs', 'reports', 'PBL Library 10.5', 'menu-screen-inventory-dev-db.md');
const checkOnly = process.argv.includes('--check');

const files = new Map(
  readdirSync(pblDir)
    .filter((file) => /\.(?:srw|srd)$/i.test(file))
    .map((file) => [file.toLowerCase(), join(pblDir, file)]),
);
const cache = new Map();
const readSource = (file) => {
  if (!cache.has(file)) cache.set(file, readFileSync(file, 'utf8'));
  return cache.get(file);
};

const ignoredTables = new Set(['DUAL']);
const lookupTables = new Set([
  'ISYS_BASECODE',
  'ISYS_CODE_MASTER',
  'ISYS_USERS',
  'ICOM_CUSTOMER',
  'ICOM_SUPPLIER',
  'ID_ITEM',
  'IP_PRODUCT_LINE',
  'IP_PRODUCT_MODEL_MASTER',
  'IP_PRODUCT_WORKSTAGE',
]);
const genericTokens = new Set([
  'w',
  'd',
  'de',
  'com',
  'des',
  'mat',
  'mcn',
  'pln',
  'prd',
  'qc',
  'sal',
  'smt',
  'master',
  'query',
  'report',
  'rpt',
  'list',
  'lst',
  'mst',
]);

const cleanTable = (value) => value.replaceAll('"', '').trim().toUpperCase();
const isTable = (value) => {
  const table = cleanTable(value);
  return table.length > 2 && table.includes('_') && !ignoredTables.has(table) && /^[A-Z][A-Z0-9_$#]*$/.test(table);
};
const stripComments = (source) => source.replace(/\/\*[\s\S]*?\*\//g, ' ').replace(/^\s*\/\/.*$/gm, ' ');
const normalizedSql = (source) => stripComments(source).replaceAll('~"', '"');
const tokens = (value) =>
  value
    .toLowerCase()
    .split(/[^a-z0-9]+/)
    .filter((token) => token.length >= 3 && !genericTokens.has(token));

function addCandidate(candidates, tableName, score, evidence) {
  const table = cleanTable(tableName);
  if (!isTable(table)) return;
  const candidate = candidates.get(table) ?? { table, score: 0, evidence: new Set() };
  if (!candidate.evidence.has(evidence)) {
    candidate.score += score;
    candidate.evidence.add(evidence);
  }
  candidates.set(table, candidate);
}

function extractDataObjects(windowSource) {
  const controls = new Map();
  let currentControl = null;
  for (const line of windowSource.split(/\r?\n/)) {
    const typeMatch = line.match(/^type\s+([a-z_][a-z0-9_]*)\s+from\s+.+\s+within\s+/i);
    if (typeMatch) currentControl = typeMatch[1].toLowerCase();
    const declaration = line.match(/\bstring\s+dataobject\s*=\s*["']([^"']+)["']/i);
    if (declaration && currentControl) {
      if (!controls.has(currentControl)) controls.set(currentControl, new Set());
      controls.get(currentControl).add(declaration[1].toLowerCase());
    }
  }
  for (const match of windowSource.matchAll(/\b(this|[a-z_][a-z0-9_]*)\.dataobject\s*=\s*["']([^"']+)["']/gi)) {
    const control = match[1].toLowerCase();
    if (!controls.has(control)) controls.set(control, new Set());
    controls.get(control).add(match[2].toLowerCase());
  }
  return controls;
}

function extractActionControls(windowSource) {
  const controls = new Map();
  for (const match of windowSource.matchAll(/\b([a-z_][a-z0-9_]*)\.(update|insertrow|deleterow)\s*\(/gi)) {
    const control = match[1].toLowerCase();
    const action = match[2].toLowerCase();
    const current = controls.get(control) ?? new Set();
    current.add(action);
    controls.set(control, current);
  }
  return controls;
}

function analyzeDataObject(dataObject, candidates, scoreBoost, visited, depth = 0) {
  if (depth > 4 || visited.has(dataObject)) return;
  visited.add(dataObject);
  const file = files.get(`${dataObject.toLowerCase()}.srd`);
  if (!file) return;
  const source = readSource(file);
  const evidence = basename(file);

  for (const match of source.matchAll(/\bupdate\s*=\s*"([^"]+)"/gi)) {
    addCandidate(candidates, match[1], 95 + scoreBoost, `${evidence}:update`);
  }

  const pbTables = [...source.matchAll(/TABLE\s*\(\s*NAME\s*=\s*~?"([^"]+)~?"/gi)].map((match) => match[1]);
  pbTables.forEach((table, index) => addCandidate(candidates, table, (index === 0 ? 52 : 18) + scoreBoost / 4, `${evidence}:PBSELECT`));

  for (const match of source.matchAll(/column\([^)]*\bupdate=yes[^)]*\bdbname="([a-z0-9_$#]+)\.[^"]+"/gi)) {
    addCandidate(candidates, match[1], 18 + scoreBoost / 4, `${evidence}:editable-column`);
  }

  const sql = normalizedSql(source);
  const rawTables = [];
  for (const match of sql.matchAll(/\b(?:FROM|JOIN)\s+(?!\s*\()(?:(?:"?[a-z][a-z0-9_$#]*"?)\.)?"?([a-z][a-z0-9_$#]*)"?/gi)) {
    if (isTable(match[1])) rawTables.push(match[1]);
  }
  [...new Set(rawTables)].forEach((table, index) =>
    addCandidate(candidates, table, (index === 0 ? 46 : 16) + scoreBoost / 4, `${evidence}:SQL`),
  );

  for (const match of source.matchAll(/\breport\s*\([^)]*\bdataobject\s*=\s*"([^"]+)"/gi)) {
    analyzeDataObject(match[1].toLowerCase(), candidates, Math.max(0, scoreBoost - 25), visited, depth + 1);
  }
}

function mainTablesForScreen(windowName) {
  const windowFile = files.get(`${windowName.toLowerCase()}.srw`);
  if (!windowFile) return { label: '소스 미확인', status: 'missing' };

  const source = readSource(windowFile);
  const candidates = new Map();
  const controls = extractDataObjects(source);
  const actionControls = extractActionControls(source);
  const visited = new Set();
  let dynamic = /\.dataobject\s*=\s*(?!["'])/i.test(source) || /\b(?:SyntaxFromSQL|SetSQLSelect)\s*\(/i.test(source);

  for (const [control, dataObjects] of controls) {
    const actions = actionControls.get(control) ?? new Set();
    const scoreBoost = actions.has('update') ? 95 : actions.has('insertrow') || actions.has('deleterow') ? 55 : 0;
    for (const dataObject of dataObjects) analyzeDataObject(dataObject, candidates, scoreBoost, visited);
  }

  const sql = normalizedSql(source);
  for (const match of sql.matchAll(/\b(?:INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+(?:(?:"?[a-z][a-z0-9_$#]*"?)\.)?"?([a-z][a-z0-9_$#]*)"?/gi)) {
    addCandidate(candidates, match[1], 120, `${basename(windowFile)}:DML`);
  }
  const embeddedTables = [];
  for (const statement of sql.matchAll(/\bSELECT\b[\s\S]*?;/gi)) {
    for (const match of statement[0].matchAll(/\b(?:FROM|JOIN)\s+(?!\s*\()(?:(?:"?[a-z][a-z0-9_$#]*"?)\.)?"?([a-z][a-z0-9_$#]*)"?/gi)) {
      if (isTable(match[1])) embeddedTables.push(match[1]);
    }
  }
  [...new Set(embeddedTables)].forEach((table, index) =>
    addCandidate(candidates, table, index === 0 ? 35 : 12, `${basename(windowFile)}:SQL`),
  );

  const windowTokens = new Set(tokens(windowName));
  for (const candidate of candidates.values()) {
    const tableTokens = tokens(candidate.table);
    const affinity = tableTokens.filter((token) => windowTokens.has(token)).length;
    candidate.score += Math.min(30, affinity * 12);
    for (const suffix of ['DOCUMENT', 'IMAGE', 'LOG', 'HISTORY', 'TEMP', 'WORKSPACE', 'EXCEL', 'LOOP_CHECK']) {
      if (candidate.table.includes(`_${suffix}`) && !windowTokens.has(suffix.toLowerCase())) candidate.score -= 24;
    }
    if (lookupTables.has(candidate.table) && affinity === 0) candidate.score -= 22;
  }

  const ranked = [...candidates.values()].sort((a, b) => b.score - a.score || a.table.localeCompare(b.table));
  if (ranked.length === 0) return { label: dynamic ? '동적 확인 필요' : 'DB 소스 없음', status: dynamic ? 'dynamic' : 'none' };

  const selected = ranked.filter((candidate, index) => index === 0 || (index < 2 && ranked[0].score - candidate.score <= 8));
  const label = selected.map((candidate) => `\`${candidate.table}\``).join(', ');
  return { label, status: selected.length > 1 ? 'multi' : 'resolved' };
}

function enrichReport(original) {
  const lines = original.split(/\r?\n/);
  const output = [];
  const stats = { resolved: 0, multi: 0, dynamic: 0, none: 0, missing: 0 };
  let inScreenTable = false;
  let skipGeneratedSummary = false;

  for (const line of lines) {
    if (line === '<!-- MAIN_TABLE_SUMMARY:START -->') {
      skipGeneratedSummary = true;
      continue;
    }
    if (line === '<!-- MAIN_TABLE_SUMMARY:END -->') {
      skipGeneratedSummary = false;
      continue;
    }
    if (skipGeneratedSummary) continue;

    if (/^\| 순서 \| 메뉴 경로 \| PB 메뉴 항목 \| 화면 오브젝트 \| 화면명\(한글\) \|(?: 메인 DB 테이블 \|)? 상태 \|$/.test(line)) {
      output.push('| 순서 | 메뉴 경로 | PB 메뉴 항목 | 화면 오브젝트 | 화면명(한글) | 메인 DB 테이블 | 상태 |');
      inScreenTable = true;
      continue;
    }
    if (inScreenTable && /^\|---:/.test(line)) {
      output.push('|---:|---|---|---|---|---|---|');
      continue;
    }
    if (inScreenTable && /^\|\s*\d+\s*\|/.test(line)) {
      const cells = line.slice(1, -1).split('|').map((cell) => cell.trim());
      if (cells.length === 7) cells.splice(5, 1);
      const result = mainTablesForScreen(cells[3]);
      stats[result.status] += 1;
      cells.splice(5, 0, result.label);
      output.push(`| ${cells.join(' | ')} |`);
      continue;
    }
    if (inScreenTable && !line.startsWith('|')) inScreenTable = false;
    output.push(line);
  }

  const insertAt = output.findIndex((line) => line === '## 최상위 메뉴');
  if (insertAt < 0) throw new Error('Could not find summary insertion point.');
  const screenRows = Object.values(stats).reduce((sum, value) => sum + value, 0);
  if (screenRows !== 231) throw new Error(`Expected 231 menu screen rows, found ${screenRows}.`);
  output.splice(
    insertAt,
    0,
    '<!-- MAIN_TABLE_SUMMARY:START -->',
    `- 메인 DB 테이블 자동 확인: 단일 ${stats.resolved}행, 복수 ${stats.multi}행`,
    `- 확인 보류: 동적 ${stats.dynamic}행, DB 소스 없음 ${stats.none}행, 소스 미확인 ${stats.missing}행`,
    '<!-- MAIN_TABLE_SUMMARY:END -->',
    '',
  );

  const interpretationAt = output.findIndex((line) => line === '## 생성 파일');
  if (interpretationAt < 0) throw new Error('Could not find interpretation insertion point.');
  const existingMethod = output.findIndex((line) => line.startsWith('- `메인 DB 테이블`:'));
  if (existingMethod < 0) {
    output.splice(
      interpretationAt,
      0,
      '- `메인 DB 테이블`: 화면 SRW의 직접 DML과 저장 DataWindow의 SRD `update=`를 우선하고, 조회 화면은 직접 연결된 SRD의 중심 조회 테이블을 사용한다.',
      '- 복수 테이블은 점수가 비슷한 공동 fact를 함께 표시한다. `동적 확인 필요`, `DB 소스 없음`, `소스 미확인`은 각각 런타임 결정, 비DB 화면, 원본 파일 부재를 뜻한다.',
      '',
    );
  }

  return `${output.join('\n').replace(/\n{3,}/g, '\n\n').replace(/\n+$/, '')}\n`;
}

if (!existsSync(reportFile)) throw new Error(`Report not found: ${reportFile}`);
const original = readFileSync(reportFile, 'utf8');
const enriched = enrichReport(original);

if (checkOnly) {
  if (original !== enriched) {
    console.error('PBL menu inventory main-table data is stale.');
    process.exit(1);
  }
  console.log('PBL menu inventory main-table data is current.');
} else {
  writeFileSync(reportFile, enriched, 'utf8');
  console.log(`Updated ${reportFile}`);
}
