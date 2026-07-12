import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync, existsSync } from "node:fs";

const root = new URL("../../../../../", import.meta.url);
const read = (path) => readFileSync(new URL(path, root), "utf8");

test("IP routing frontend uses only the approved routing API and fields", () => {
  const page = read("src/app/(authenticated)/master/routing/page.tsx");
  const manager = read("src/app/(authenticated)/master/routing/components/RoutingGroupManager.tsx");
  const materials = read("src/app/(authenticated)/master/routing/components/RoutingMaterialEditor.tsx");
  const types = read("src/app/(authenticated)/master/routing/types.ts");
  const all = `${page}\n${manager}\n${materials}\n${types}`;

  for (const forbidden of ["QualityConditionEditor", "SelfInspectConfigEditor", "/by-item/", "/materials/bulk", "circuitId", "issueLabelType", "sampleInspectYn", "IN_HOUSE"]) {
    assert.doesNotMatch(all, new RegExp(forbidden.replaceAll("/", "\\/")));
  }
  for (const required of ["workstageCode", "subconSupplierCode", "standardTime", "INTERNAL", "bomMatchYn", "assignedProcessSeq", "selectableYn", "bomQty", "allocQty", "issueMethod", "upserts", "deletes"]) {
    assert.match(all, new RegExp(required));
  }
  assert.equal(existsSync(new URL("src/app/(authenticated)/master/routing/components/QualityConditionEditor.tsx", root)), false);
  assert.equal(existsSync(new URL("src/app/(authenticated)/master/routing/components/SelfInspectConfigEditor.tsx", root)), false);
});
