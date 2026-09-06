import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const frontendRoot = fs.existsSync('src/app') ? '.' : 'apps/frontend';

function parseMenuConfig(source) {
  const marker = source.indexOf('export const menuConfig');
  assert.ok(marker >= 0, 'menuConfig declaration must exist');
  const eq = source.indexOf('=', marker);
  const arrayStart = source.indexOf('[', eq);
  let depth = 0;
  let arrayEnd = -1;
  for (let index = arrayStart; index < source.length; index += 1) {
    if (source[index] === '[') depth += 1;
    else if (source[index] === ']' && --depth === 0) {
      arrayEnd = index;
      break;
    }
  }
  assert.ok(arrayEnd >= 0, 'menuConfig array must be balanced');
  const literal = source.slice(arrayStart, arrayEnd + 1).replace(/icon:\s*\w+,?/g, '');
  return new Function(`return ${literal};`)();
}

test('OEE master leaves belong to master data in the approved order', () => {
  const source = fs.readFileSync(`${frontendRoot}/src/config/menuConfig.ts`, 'utf8');
  const menu = parseMenuConfig(source);
  const master = menu.find((category) => category.code === 'MASTER');
  const oee = menu.find((category) => category.code === 'OEE');
  assert.ok(master && oee);

  const movedLeaves = [
    { code: 'OEE_MST_STD_TIME', labelKey: 'menu.oee.standardTime', path: '/oee/master/standard-time' },
    { code: 'OEE_MST_IDLE_REASON', labelKey: 'menu.oee.idleReason', path: '/oee/master/idle-reason' },
    { code: 'OEE_MST_EQUIP_REASON', labelKey: 'menu.oee.equipReason', path: '/oee/master/equip-reason-map' },
  ];
  for (const leaf of movedLeaves) {
    assert.deepEqual(master.children.find((item) => item.code === leaf.code), leaf);
    assert.equal(oee.children.some((item) => item.code === leaf.code), false);
  }

  const codes = master.children.map((item) => item.code);
  const start = codes.indexOf('EQUIP_MASTER');
  assert.deepEqual(codes.slice(start, start + 5), [
    'EQUIP_MASTER',
    'OEE_MST_STD_TIME',
    'OEE_MST_IDLE_REASON',
    'OEE_MST_EQUIP_REASON',
    'MST_PROCESS',
  ]);
});
