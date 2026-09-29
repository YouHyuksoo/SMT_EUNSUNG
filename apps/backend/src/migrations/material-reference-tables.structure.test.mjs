import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { resolve } from 'node:path';

const migrationPath = resolve(
  import.meta.dirname,
  '2026-09-25_material_reference_tables.sql',
);
const source = readFileSync(migrationPath, 'utf8');
const compact = source.replace(/\s+/g, ' ').trim();

/** part.service.ts 의 품목 삭제 참조검사가 COUNT 하는 테이블 + 재고동결 가드 테이블. */
const TABLES = [
  'BOM_MASTERS', 'MAT_ARRIVALS', 'MAT_LOTS', 'MAT_RECEIVINGS',
  'PHYSICAL_INV_SESSIONS', 'PROD_PLANS',
];

test('migration creates every table the raw SQL paths reference', () => {
  for (const table of TABLES) {
    const creates = compact.match(new RegExp(`CREATE TABLE "${table}" \\(`, 'g')) ?? [];
    assert.equal(creates.length, 1, `${table} CREATE 문이 1개가 아니다`);
    assert.match(compact, new RegExp(`ddl_if_absent\\('${table}'`), `${table} 가드 누락`);
  }
  assert.match(compact, /SELECT COUNT\(\*\) INTO n FROM USER_TABLES WHERE TABLE_NAME = p_name/);
});

test('part.service.ts 가 쓰는 테이블은 ORGANIZATION_ID 테넌트를 쓴다', () => {
  for (const table of TABLES.filter((t) => t !== 'PHYSICAL_INV_SESSIONS')) {
    const body = compact.slice(compact.indexOf(`CREATE TABLE "${table}" (`));
    const create = body.slice(0, body.indexOf('~\');'));
    assert.match(create, /"ORGANIZATION_ID" NUMBER DEFAULT 1 NOT NULL/, `${table} 테넌트 컬럼 누락`);
    assert.doesNotMatch(create, /"COMPANY"|"PLANT_CD"/, `${table} 에 구 테넌트 컬럼이 남았다`);
  }
});

test('inventory-freeze.guard.ts 가 쓰는 테이블은 COMPANY/PLANT_CD 를 유지한다', () => {
  const body = compact.slice(compact.indexOf('CREATE TABLE "PHYSICAL_INV_SESSIONS" ('));
  const create = body.slice(0, body.indexOf('~\');'));
  assert.match(create, /"COMPANY"/);
  assert.match(create, /"PLANT_CD"/);
  assert.match(create, /"STATUS"/);
});
