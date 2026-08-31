import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const src = readFileSync(new URL('./Modal.tsx', import.meta.url), 'utf8');

test('Modal manages opener focus, initial focus, and focus trapping', () => {
  assert.match(src, /useRef<HTMLElement \| null>/);
  assert.match(src, /document\.activeElement/);
  assert.match(src, /requestAnimationFrame/);
  assert.match(src, /initialFocusRef/);
  assert.match(src, /preferredFocus/);
  assert.match(src, /firstFocusable/);
  assert.match(src, /e\.key (?:===|!==) ['"]Tab['"]/);
  assert.match(src, /shiftKey/);
  assert.match(src, /focus\(\)/);
  assert.match(src, /tabIndex=\{-1\}/);
  assert.match(src, /isConnected|document\.contains/);
});

test('Modal preserves overlay and ESC closing while keeping xl content within the viewport', () => {
  assert.match(src, /closeOnEsc/);
  assert.match(src, /e\.key === ['"]Escape['"]/);
  assert.match(src, /closeOnOverlayClick/);
  assert.match(src, /max-w-2xl/);
  assert.match(src, /max-h-\[75vh\]/);
  assert.match(src, /pointer-events-none fixed inset-0/);
  assert.match(src, /pointer-events-auto w-full/);
});
