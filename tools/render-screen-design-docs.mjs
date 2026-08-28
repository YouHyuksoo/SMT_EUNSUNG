import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, readdirSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const docsDir = fileURLToPath(new URL('../docs/presentations/', import.meta.url));
const allFiles = readdirSync(docsDir)
  .filter((file) => /^2026-08-11-.*-screen-design\.html$/.test(file))
  .sort();

if (allFiles.length !== 36) {
  throw new Error(`Expected 36 screen-design documents, found ${allFiles.length}.`);
}

const requestedFiles = process.argv.slice(2);
const files = requestedFiles.length > 0 ? requestedFiles : allFiles;
for (const file of files) {
  if (!allFiles.includes(file)) throw new Error(`Unknown screen-design document: ${file}`);
}

const chromeCandidates = [
  join(process.env.PROGRAMFILES ?? '', 'Google/Chrome/Application/chrome.exe'),
  join(process.env['PROGRAMFILES(X86)'] ?? '', 'Microsoft/Edge/Application/msedge.exe'),
  join(process.env.LOCALAPPDATA ?? '', 'Google/Chrome/Application/chrome.exe'),
];
const browser = chromeCandidates.find((candidate) => candidate && existsSync(candidate));
if (!browser) throw new Error('Chrome or Edge executable was not found.');

const outputDir = join(tmpdir(), 'opencode', 'screen-design-render-validation');
mkdirSync(outputDir, { recursive: true });
const failures = [];

for (const file of files) {
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
      pathToFileURL(join(docsDir, file)).href,
    ],
    { encoding: 'utf8', timeout: 45_000 },
  );

  rmSync(profile, { recursive: true, force: true });
  if (result.status !== 0 || !existsSync(pdf)) {
    failures.push(`${file}: browser render failed (${result.error?.message ?? result.stderr.trim()})`);
    continue;
  }

  const source = readFileSync(pdf).toString('latin1');
  const pages = (source.match(/\/Type\s*\/Page\b/g) ?? []).length;
  const mediaBoxes = [...source.matchAll(/\/MediaBox\s*\[0 0 ([\d.]+) ([\d.]+)\]/g)];
  const isA2Landscape =
    mediaBoxes.length === pages &&
    mediaBoxes.every((match) => Number(match[1]) >= 1670 && Number(match[1]) <= 1695 && Number(match[2]) >= 1175 && Number(match[2]) <= 1205);

  if (pages !== 3) failures.push(`${file}: expected 3 PDF pages, found ${pages}`);
  if (!isA2Landscape) failures.push(`${file}: PDF MediaBox is not A2 landscape`);
  process.stdout.write('.');
}

process.stdout.write('\n');
if (failures.length > 0) {
  console.error(`Screen-design render validation failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}

console.log(`Rendered ${files.length} documents as 3-page A2 landscape PDFs in ${outputDir}.`);
