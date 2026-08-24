import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";
import { buildProcessOptions } from "./processOptions.mjs";

const root = new URL("../../../", import.meta.url);
const read = (path) => fs.readFileSync(new URL(path, root), "utf8");

test("process options optionally include the localized process type", () => {
  const processes = [
    { processCode: "P10", processName: "조립", processType: "I" },
    { processCode: "P20", processName: "검사", processType: "T" },
  ];
  const typeNames = {
    I: { codeName: "일반" },
    T: { codeName: "검사" },
  };

  assert.deepEqual(buildProcessOptions(processes, typeNames, true), [
    { value: "P10", label: "P10 | 조립 | 일반" },
    { value: "P20", label: "P20 | 검사 | 검사" },
  ]);
  assert.deepEqual(buildProcessOptions(processes, typeNames, false), [
    { value: "P10", label: "P10 - 조립" },
    { value: "P20", label: "P20 - 검사" },
  ]);
});

test("process selectors read process master data and preserve their default contract", () => {
  const hooks = read("src/hooks/useMasterOptions.ts");
  const select = read("src/components/shared/ProcessSelect.tsx");

  assert.match(hooks, /processType:\s*string/);
  assert.match(hooks, /useApiQuery<ProcessItem\[\]>/);
  assert.match(hooks, /\/master\/processes\?limit=5000/);
  assert.match(hooks, /Array\.isArray\(data\?\.data\)\s*\?\s*data\.data\s*:\s*\[\]/);
  assert.doesNotMatch(hooks, /\/equipment\/equips\/metadata\/processes/);
  assert.match(hooks, /return \{ options, isLoading, rawData \}/);

  assert.match(select, /showProcessType\?:\s*boolean/);
  assert.match(select, /useComCodeMap\("WORKSTAGE TYPE"\)/);
  assert.match(select, /\{ labelPrefix, showProcessType = false, \.\.\.props \}/);
  assert.match(select, /buildProcessOptions\(rawData, processTypeMap, showProcessType\)/);
  assert.match(select, /`\$\{labelPrefix\}: 전체`/);
  assert.doesNotMatch(select, /<Select[^>]*showProcessType=/s);
});
