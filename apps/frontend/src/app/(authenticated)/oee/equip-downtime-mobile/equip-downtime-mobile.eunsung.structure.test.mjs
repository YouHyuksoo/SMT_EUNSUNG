import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";

const page = readFileSync(new URL("./page.tsx", import.meta.url), "utf8");

test("equipment mobile screen is explicitly read-only while retaining IMCN_MACHINE lookup", () => {
  assert.match(page, /설비 조회 \(모바일\)/);
  assert.match(page, /조회 전용/);
  assert.match(page, /비가동 상태를 변경하거나 저장하지 않습니다/);

  assert.match(page, /getUserMedia/);
  assert.match(page, /설비코드 수동 입력/);
  assert.match(page, /\/equipment\/equips\/code\/\$\{encodeURIComponent\(normalized\)\}/);
  assert.match(page, /IMCN_MACHINE/);
  assert.match(page, /machine\.machineCode/);
  assert.match(page, /machine\.machineName/);

  assert.doesNotMatch(page, /toast\.success|react-hot-toast|설비 가동상태가 저장되었습니다/);
  assert.doesNotMatch(page, /saveDowntime|toggleDowntime|setDowntime|DowntimeState|STOP_REASONS|CURRENT_USER/);
  assert.doesNotMatch(page, /저장\s*<\/button>|datetime-local|<textarea|stopReason|stopWorker|resumeAt/);
});
