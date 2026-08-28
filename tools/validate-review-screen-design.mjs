import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, isAbsolute, join, relative, resolve, sep } from 'node:path';
import { pathToFileURL } from 'node:url';

const workspace = resolve(import.meta.dirname, '..');
const presentationsDir = join(workspace, 'docs', 'presentations');
const requestedFiles = process.argv.slice(2);

if (requestedFiles.length === 0) throw new Error('Pass at least one screen-design HTML file.');

const chromeCandidates = [
  join(process.env.PROGRAMFILES ?? '', 'Google', 'Chrome', 'Application', 'chrome.exe'),
  join(process.env['PROGRAMFILES(X86)'] ?? '', 'Microsoft', 'Edge', 'Application', 'msedge.exe'),
  join(process.env.LOCALAPPDATA ?? '', 'Google', 'Chrome', 'Application', 'chrome.exe'),
];
const browser = chromeCandidates.find((candidate) => candidate && existsSync(candidate));
if (!browser) throw new Error('Chrome or Edge executable was not found.');

const outputDir = join(tmpdir(), 'opencode', 'review-screen-design-validation');
mkdirSync(outputDir, { recursive: true });

const count = (text, pattern) => (text.match(pattern) ?? []).length;
const failures = [];

for (const requestedFile of requestedFiles) {
  const file = resolve(workspace, requestedFile);
  const relativeToPresentations = relative(presentationsDir, file);
  if (
    isAbsolute(relativeToPresentations) ||
    relativeToPresentations === '..' ||
    relativeToPresentations.startsWith(`..${sep}`) ||
    !/^\d{4}-\d{2}-\d{2}-[a-z0-9-]+-screen-design\.html$/.test(basename(file))
  ) {
    failures.push(`${requestedFile}: expected a dated screen-design file under docs/presentations`);
    continue;
  }
  if (!existsSync(file)) {
    failures.push(`${requestedFile}: file missing`);
    continue;
  }

  const html = readFileSync(file, 'utf8');
  const checks = [
    [html.startsWith('<!doctype html>'), 'doctype'],
    [/<meta\s+charset=["']utf-8["']\s*\/?\s*>/i.test(html), 'UTF-8 charset'],
    [count(html, /<section class="sheet" id="page-[123]">/g) === 3, 'exactly three ordered sheets'],
    [count(html, /Page 1 \/ 3/g) === 1, 'Page 1 / 3 footer'],
    [count(html, /Page 2 \/ 3/g) === 1, 'Page 2 / 3 footer'],
    [count(html, /Page 3 \/ 3/g) === 1, 'Page 3 / 3 footer'],
    [/@page\s*\{[^}]*size\s*:\s*594mm\s+420mm[^}]*margin\s*:\s*0/is.test(html), 'A2 landscape print CSS'],
    [/\.sheet\s*\{[^}]*height\s*:\s*404mm[^}]*min-height\s*:\s*404mm/is.test(html), '404mm sheet height'],
    [/(requirements|요구사항|업무 목적|목적·)/iu.test(html), 'requirements section'],
    [/(wireframe|화면 구성|실제 UI)/iu.test(html), 'actual UI wireframe'],
    [/(component|control|DataWindow|DW|컴포넌트|컨트롤)/iu.test(html), 'component/control contract'],
    [/(API|SQL|데이터|interface|인터페이스)/iu.test(html), 'data/interface contract'],
    [/(interface|인터페이스|REST endpoint|PowerBuilder|DataWindow\/SQL)/iu.test(html), 'interface section'],
    [/(state|상태).*validation/is.test(html), 'state and validation section'],
    [/(risk|위험)/iu.test(html), 'risk section'],
    [/(evidence|근거)/iu.test(html), 'evidence section'],
    [!/<link\b[^>]*rel=["']?stylesheet/i.test(html), 'no external stylesheet'],
    [!/<script\b[^>]*\bsrc=/i.test(html), 'no external script'],
    [!/<(?:img|source)\b[^>]*\bsrc=["']https?:/i.test(html), 'no external image'],
    [/<\/body>\s*<\/html>\s*$/i.test(html), 'closing body/html'],
  ];

  for (const [passed, name] of checks) {
    if (!passed) failures.push(`${requestedFile}: ${name}`);
  }
  for (const tag of ['section', 'article', 'table', 'tr', 'div']) {
    const opens = count(html, new RegExp(`<${tag}(?:\\s|>)`, 'gi'));
    const closes = count(html, new RegExp(`</${tag}>`, 'gi'));
    if (opens !== closes) failures.push(`${requestedFile}: unbalanced <${tag}> (${opens}/${closes})`);
  }
  if (failures.some((failure) => failure.startsWith(`${requestedFile}:`))) continue;

  const slug = basename(file, '.html');
  const pdf = join(outputDir, `${slug}.pdf`);
  const profile = join(outputDir, `${slug}-profile`);
  rmSync(pdf, { force: true });
  rmSync(profile, { recursive: true, force: true });

  const result = spawnSync(
    browser,
    [
      '--headless',
      '--disable-gpu',
      '--disable-background-networking',
      '--no-first-run',
      '--no-pdf-header-footer',
      `--user-data-dir=${profile}`,
      `--print-to-pdf=${pdf}`,
      pathToFileURL(file).href,
    ],
    { encoding: 'utf8', timeout: 45_000 },
  );
  rmSync(profile, { recursive: true, force: true });

  if (result.status !== 0 || !existsSync(pdf)) {
    failures.push(`${requestedFile}: browser render failed (${result.error?.message ?? result.stderr.trim()})`);
    continue;
  }

  const source = readFileSync(pdf).toString('latin1');
  const pages = count(source, /\/Type\s*\/Page\b/g);
  const mediaBoxes = [...source.matchAll(/\/MediaBox\s*\[0 0 ([\d.]+) ([\d.]+)\]/g)];
  const isA2Landscape =
    mediaBoxes.length === pages &&
    mediaBoxes.every(
      (match) =>
        Number(match[1]) >= 1670 &&
        Number(match[1]) <= 1695 &&
        Number(match[2]) >= 1175 &&
        Number(match[2]) <= 1205,
    );

  if (pages !== 3) failures.push(`${requestedFile}: expected 3 PDF pages, found ${pages}`);
  if (!isA2Landscape) failures.push(`${requestedFile}: PDF MediaBox is not A2 landscape`);
  if (pages === 3 && isA2Landscape) {
    console.log(`${requestedFile}: static checks passed; PDF is 3-page A2 landscape`);
  }
}

if (failures.length > 0) {
  console.error(`Screen-design validation failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}
