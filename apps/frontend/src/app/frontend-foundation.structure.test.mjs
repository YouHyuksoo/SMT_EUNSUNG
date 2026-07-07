import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';
import test from 'node:test';

const root = process.cwd();
const fromRoot = (...parts) => path.join(root, ...parts);

test('display monitoring route group remains isolated from business layout shell', () => {
  const displayPagePath = fromRoot('src', 'app', '(display)', 'display', '[screenId]', 'page.tsx');
  const displayLayoutPath = fromRoot('src', 'components', 'display', 'DisplayLayout.tsx');

  assert.equal(existsSync(displayPagePath), true, 'display page route must remain under (display)');
  assert.equal(existsSync(displayLayoutPath), true, 'display layout component must remain available');

  const displayPage = readFileSync(displayPagePath, 'utf8');
  assert.equal(displayPage.includes('@/components/layout/MainLayout'), false);
  assert.equal(displayPage.includes('@/components/layout/Header'), false);
  assert.equal(displayPage.includes('@/components/layout/Sidebar'), false);
});

test('display product-line API keeps backend query contract', () => {
  const apiPath = fromRoot('src', 'app', 'api', 'display', '21', 'route.ts');

  assert.equal(existsSync(apiPath), true, 'display 21 API route must remain available');

  const apiRoute = readFileSync(apiPath, 'utf8');
  assert.equal(apiRoute.includes('executeQuery'), true);
  assert.equal(apiRoute.includes('sqlProductLineMonitoring'), true);
});
