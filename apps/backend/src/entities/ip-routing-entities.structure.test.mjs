import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const read = (name) => readFileSync(new URL(name, import.meta.url), 'utf8');

test('IP routing entities map only the live Oracle tables and columns', () => {
  const group = read('./routing-group.entity.ts');
  const process = read('./routing-process.entity.ts');
  const material = read('./routing-material.entity.ts');

  assert.match(group, /@Entity\(\{ name: 'IP_ROUTING_GROUPS' \}\)/);
  for (const column of ['ORGANIZATION_ID', 'ROUTING_CODE', 'ITEM_CODE', 'ROUTING_NAME', 'DESCRIPTION', 'USE_YN', 'CREATED_BY', 'CREATED_AT', 'UPDATED_BY', 'UPDATED_AT']) {
    assert.match(group, new RegExp(`name: '${column}'`));
  }

  assert.match(process, /@Entity\(\{ name: 'IP_ROUTING_PROCESSES' \}\)/);
  for (const [property, column] of [
    ['processSeq', 'PROCESS_SEQ'], ['workstageCode', 'WORKSTAGE_CODE'],
    ['subconSupplierCode', 'SUBCON_SUPPLIER_CODE'], ['standardTime', 'STANDARD_TIME'],
  ]) {
    assert.match(process, new RegExp(`name: '${column}'[^\\n]*\\n\\s*${property}[:!]`));
  }
  for (const removed of ['PROCESS_NAME', 'PROCESS_TYPE', 'EQUIP_TYPE', 'SAMPLE_INSPECT_YN', 'QC_SELF_YN', 'INSPECT_METHOD', 'DESTRUCTIVE_YN', 'ISSUE_LABEL_TYPE', 'SAMPLE_QTY']) {
    assert.doesNotMatch(process, new RegExp(`name: '${removed}'`));
  }

  assert.match(material, /@Entity\(\{ name: 'IP_ROUTING_MATERIALS' \}\)/);
  assert.match(material, /name: 'PROCESS_SEQ'[^\n]*\n\s*processSeq[:!]/);
  for (const removed of ['CIRCUIT_ID', 'USE_YN']) {
    assert.doesNotMatch(material, new RegExp(`name: '${removed}'`));
  }
});

test('routing module does not register excluded routing repositories', () => {
  const databaseModule = read('../database/database.module.ts');
  const routingModule = read('../modules/master/master-routing-group.module.ts');

  assert.doesNotMatch(databaseModule, /ProcessQualityCondition/);
  assert.doesNotMatch(routingModule, /ProcessQualityCondition|HarnessCircuitSpec/);
});
