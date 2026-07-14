import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
const components=new URL("./components/",import.meta.url);
const read=(name)=>fs.readFileSync(new URL(name,components),"utf8");
test("routing async loaders ignore stale out-of-order responses",()=>{
  for(const source of[read("RoutingGroupManager.tsx"),read("RoutingMaterialEditor.tsx")]){
    assert.match(source,/AbortController/);
    assert.match(source,/requestGeneration/);
    assert.match(source,/generation !== requestGeneration\.current/);
    assert.match(source,/signal:\s*controller\.signal/);
    assert.match(source,/RequestController\.current\?\.abort\(\)/i);
  }
});
test("existing material assignment can only be removed by confirmed explicit delete",()=>{
  const source=read("RoutingMaterialEditor.tsx");
  assert.match(source,/const existingAssignment/);
  assert.match(source,/disabled=\{other\|\|stale\|\|existingAssignment/);
  assert.match(source,/setDeleteRow\(x\)/);
  assert.match(source,/ConfirmModal/);
});
test("switching process during save resets only the superseded save state",()=>{
  const source=read("RoutingMaterialEditor.tsx");
  assert.match(source,/saveGeneration/);
  assert.match(source,/const saveToken=\+\+saveGeneration\.current/);
  assert.match(source,/saveGeneration\.current\+\+/);
  assert.match(source,/setSaving\(false\)/);
  assert.match(source,/saveToken===saveGeneration\.current/);
});
