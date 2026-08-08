import assert from "node:assert/strict";
import fs from "node:fs";
import test from "node:test";

const frontendRoot = fs.existsSync("src/app") ? "." : "apps/frontend";
const pagePath = `${frontendRoot}/src/app/(authenticated)/oee/entry/page.tsx`;
const libPath = `${frontendRoot}/src/app/(authenticated)/oee/entry/_lib/oee-entry.ts`;
const page = fs.readFileSync(pagePath, "utf8");
const lib = fs.existsSync(libPath) ? fs.readFileSync(libPath, "utf8") : "";
const locales = ["ko", "en", "zh", "vi"];

test("canonical entry uses only the six authenticated mobile OEE endpoints", () => {
  for (const endpoint of [
    "/oee/mobile/workers/",
    "/oee/mobile/resources",
    "/oee/mobile/reasons",
    "/oee/mobile/status",
    "/oee/mobile/downtime/start",
    "/oee/mobile/downtime/end",
  ]) {
    assert.match(page, new RegExp(endpoint.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")));
  }

  assert.doesNotMatch(page, /\/oee\/(?:resource|reason|log)(?:["?`/]|$)/);
  assert.doesNotMatch(page, /useOeeProfile|IntervalEditor|oee-terminal-profile/);
  assert.doesNotMatch(page, /localStorage|sessionStorage|offlineQueue|queue/i);
  assert.doesNotMatch(page, /getUserMedia|BarcodeDetector|mediaDevices|<video/);
  assert.doesNotMatch(page, /type=["']date|\b(?:DAY|NIGHT|netLoad|quantity|organizationId|clientTime)\b/);
});

test("worker lookup gates context loading and unwraps both envelope shapes", () => {
  assert.match(page, /encodeURIComponent\(workerId/);
  assert.match(page, /workerLoading/);
  assert.match(page, /disabled=\{!worker \|\| contextLocked\}/);
  assert.match(page, /loadContext\(nextProcess\)/);
  assert.match(lib, /response\.data\.data/);
  assert.match(lib, /raw fallback|rawFallback|return responseData/);
});

test("resource normalization and payload builders preserve the approved mobile contract", () => {
  assert.match(lib, /parentLineCode.*resourceCode/);
  assert.match(lib, /PROD2/);
  assert.match(lib, /export function makeStartPayload/);
  assert.match(lib, /export function makeEndPayload/);

  const startBuilder = lib.match(/export function makeStartPayload[\s\S]*?\n\}/)?.[0] ?? "";
  for (const field of [
    "processCode",
    "resourceType",
    "resourceCode",
    "parentLineCode",
    "workerId",
    "reasonCode",
    "requestId",
  ]) {
    assert.match(startBuilder, new RegExp(`\\b${field}\\b`));
  }
  assert.doesNotMatch(startBuilder, /organizationId|tenant|clientTime|workDate|workSegment|shift|netLoad|quantity/);

  const endBuilder = lib.match(/export function makeEndPayload[\s\S]*?\n\}/)?.[0] ?? "";
  assert.match(endBuilder, /eventId/);
  assert.match(endBuilder, /requestId/);
  assert.doesNotMatch(endBuilder, /workerId|processCode|resourceCode|parentLineCode|reasonCode|memo/);
});

test("request IDs are stable for failed retries and invalidated by command changes", () => {
  assert.match(lib, /stableStartSignature/);
  assert.match(page, /pendingStartRef/);
  assert.match(page, /pendingEndRef/);
  assert.match(page, /crypto\.randomUUID\(\)/);
  assert.match(page, /pendingStartRef\.current\s*=\s*null/);
  assert.match(page, /pendingEndRef\.current\s*=\s*null/);
  assert.match(page, /stableStartSignature\(/);
  assert.match(page, /setStartSubmitting\(true\)/);
  assert.match(page, /setEndSubmitting\(true\)/);
});

test("malformed command responses cannot move the screen into a successful state", () => {
  assert.match(lib, /normalizeCommandResult[\s\S]*if \(!event\) throw new Error/);
  assert.match(page, /const result = normalizeCommandResult\(response\)/);
});

test("state failures keep transitions blocked and the page has industrial responsive touch targets", () => {
  assert.match(page, /statusError/);
  assert.match(page, /if \(statusError/);
  assert.match(page, /NO_ASSEMBLY_CELL_MASTER/);
  assert.match(page, /ConfirmModal/);
  assert.match(page, /grid-cols-1[\s\S]*min-\[1024px\]:grid-cols-2/);
  assert.match(page, /min-h-\[64px\]/);
  assert.match(page, /min-h-\[72px\]/);
  assert.doesNotMatch(page, /\b(?:alert|confirm|prompt)\s*\(/);
  assert.match(page, /StateBadge|aria-label=\{isRunning/);
});

test("legacy profile/editor files are removed after the canonical replacement", () => {
  assert.equal(
    fs.existsSync(`${frontendRoot}/src/app/(authenticated)/oee/entry/_components/IntervalEditor.tsx`),
    false,
  );
  assert.equal(fs.existsSync(`${frontendRoot}/src/hooks/useOeeProfile.ts`), false);
});

test("all active locales contain the canonical entry labels", () => {
  const requiredKeys = [
    "title",
    "online",
    "offline",
    "workerId",
    "workerConfirm",
    "process",
    "resource",
    "status",
    "running",
    "downtime",
    "startDowntime",
    "endDowntime",
    "reason",
    "memo",
    "memoLimit",
    "history",
    "retry",
    "noAssemblyCellMaster",
  ];

  for (const locale of locales) {
    const messages = JSON.parse(fs.readFileSync(`${frontendRoot}/src/locales/${locale}.json`, "utf8"));
    for (const key of requiredKeys) {
      assert.equal(typeof messages.oeeEntry?.[key], "string", `${locale}: oeeEntry.${key}`);
    }
  }
});
