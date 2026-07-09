import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const files = {
  user: "apps/frontend/public/help/user/ko/MST_PART.md",
  operator: "apps/frontend/public/help/operator/ko/MST_PART.md",
};

function read(path) {
  return readFileSync(path, "utf8");
}

test("MST_PART help is aligned with current Eunsung ID_ITEM implementation", () => {
  for (const [audience, path] of Object.entries(files)) {
    const body = read(path);
    assert.match(body, /^---\r?\n/);
    assert.match(body, new RegExp(`audience: ${audience}`));
    assert.match(body, /menuCode: MST_PART/);
    assert.match(body, /ID_ITEM/);
    assert.match(body, /ORGANIZATION_ID/);
    assert.match(body, /ITEM_CODE/);
    assert.match(body, /PART_NO/);
    assert.doesNotMatch(body, /ITEM_MASTERS/);
    assert.doesNotMatch(body, /COMPANY\s*=/);
    assert.doesNotMatch(body, /PLANT_CD/);
    assert.doesNotMatch(body, /HANES/);
  }
});

test("MST_PART user help documents actual screen actions", () => {
  const body = read(files.user);
  assert.match(body, /ERP 동기화/);
  assert.match(body, /품목 추가/);
  assert.match(body, /AQL 정책/);
  assert.match(body, /품목 사진/);
});

test("MST_PART operator help documents current APIs and storage mappings", () => {
  const body = read(files.operator);
  assert.match(body, /\/master\/parts/);
  assert.match(body, /\/interface\/inbound\/item-master/);
  assert.match(body, /FEEDER_LAYOUT_COMMENTS/);
  assert.match(body, /MES_DISPLAY_YN/);
  assert.match(body, /assertDeletable/);
});
