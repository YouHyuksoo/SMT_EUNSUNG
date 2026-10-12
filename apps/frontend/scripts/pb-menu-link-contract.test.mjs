import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const frontendRoot = join(scriptDir, '..');
const repoRoot = join(frontendRoot, '..', '..');

test('모든 웹 메뉴는 PB 연결 상태를 명시하고 연결표를 생성한다', () => {
  const result = spawnSync(process.execPath, [join(scriptDir, 'gen-migration-status.mjs'), '--check'], {
    cwd: frontendRoot,
    encoding: 'utf8',
  });

  assert.equal(result.status, 0, result.stderr || result.stdout);
  assert.match(result.stdout, /PB 연결 계약 OK: 웹 메뉴 \d+개/);

  const linkDocument = join(repoRoot, 'docs', 'business-logics', 'pb-menu-route-links.md');
  assert.equal(existsSync(linkDocument), true, 'PB 윈도우-웹 라우트 연결표가 없다');
  const source = readFileSync(linkDocument, 'utf8');
  assert.match(source, /PB 윈도우/);
  assert.match(source, /웹 경로/);
  assert.match(source, /연결 상태/);
});
