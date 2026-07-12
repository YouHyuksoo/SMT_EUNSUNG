import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const read = (name) => readFileSync(new URL(name, import.meta.url), 'utf8');

test('routing module registers every repository currently injected by RoutingGroupService', () => {
  const service = read('./services/routing-group.service.ts');
  const module = read('./master-routing-group.module.ts');
  const dependencies = [...service.matchAll(/@InjectRepository\((\w+)\)/g)].map(([, entity]) => entity);
  const registrations = module.match(/TypeOrmModule\.forFeature\(\[([\s\S]*?)\]\)/)?.[1] ?? '';

  assert.ok(dependencies.length > 0, 'service repository dependencies were not detected');
  for (const entity of dependencies) {
    assert.match(registrations, new RegExp(`\\b${entity}\\b`), `${entity} repository is not registered`);
    assert.match(module, new RegExp(`import \\{ ${entity} \\}`), `${entity} entity import is missing`);
  }
});
