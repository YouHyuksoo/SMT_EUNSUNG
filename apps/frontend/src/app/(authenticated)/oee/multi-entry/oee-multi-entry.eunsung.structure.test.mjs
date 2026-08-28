import assert from "node:assert/strict";
import { existsSync, readFileSync } from "node:fs";
import test from "node:test";
import ts from "typescript";

const frontendRoot = existsSync("src/app") ? "." : "apps/frontend";
const routeRoot = `${frontendRoot}/src/app/(authenticated)/oee/multi-entry`;
const pagePath = `${routeRoot}/page.tsx`;
const helperPath = `${routeRoot}/_lib/multi-entry.ts`;
const mobileHelperPath = `${routeRoot}/_lib/oee-mobile.ts`;
const menuPath = `${frontendRoot}/src/config/menuConfig.ts`;
const page = existsSync(pagePath) ? readFileSync(pagePath, "utf8") : "";
const helper = existsSync(helperPath) ? readFileSync(helperPath, "utf8") : "";
const mobileHelper = readFileSync(mobileHelperPath, "utf8");
const menu = readFileSync(menuPath, "utf8");
const locales = ["ko", "en", "zh", "vi"];
const helperModule = ts.transpileModule(helper, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
}).outputText;
const mobileHelperModule = ts.transpileModule(mobileHelper, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
}).outputText;
const { commandKey, isTerminalSuccess, selectRetryableResources } = await import(
  `data:text/javascript;base64,${Buffer.from(helperModule).toString("base64")}`,
);
const {
  createRequestId,
  formatServerTimestamp,
  makeEndPayload,
  makeStartPayload,
  normalizeCommandResult,
  normalizeEvent,
  normalizeResource,
  normalizeStatus,
  resourceIdentity,
  stableStartSignature,
} = await import(`data:text/javascript;base64,${Buffer.from(mobileHelperModule).toString("base64")}`);

test("multi-resource OEE route is registered with the approved menu contract", () => {
  assert.equal(existsSync(pagePath), true, "the approved route page must exist");
  assert.match(menu, /code:\s*["']OEE_MULTI_ENTRY["']/);
  assert.match(menu, /labelKey:\s*["']menu\.oee\.multiEntry["']/);
  assert.match(menu, /path:\s*["']\/oee\/multi-entry["']/);

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
  assert.doesNotMatch(page, /\/oee\/mobile\/(?:health|heartbeat|metrics)/);
  assert.doesNotMatch(page, /organizationId|tenantKey|clientTime/);
});

test("mobile helper preserves resource normalization and the approved payload field limits", () => {
  assert.match(mobileHelper, /parentLineCode/);
  assert.match(mobileHelper, /resourceCode/);
  assert.match(mobileHelper, /CELL/);
  assert.match(mobileHelper, /export function makeStartPayload/);
  assert.match(mobileHelper, /export function makeEndPayload/);

  const startBuilder = mobileHelper.match(/export function makeStartPayload[\s\S]*?\n\}/)?.[0] ?? "";
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

  const endBuilder = mobileHelper.match(/export function makeEndPayload[\s\S]*?\n\}/)?.[0] ?? "";
  assert.match(endBuilder, /eventId/);
  assert.match(endBuilder, /requestId/);
  assert.doesNotMatch(endBuilder, /workerId|processCode|resourceCode|parentLineCode|reasonCode|memo/);

  const startFields = {
    processCode: "SMT",
    resourceType: "LINE",
    resourceCode: "L-01",
    parentLineCode: "P-01",
    workerId: "W-01",
    reasonCode: "R-01",
    memo: "note",
    requestId: "req-1",
  };
  assert.deepEqual(makeStartPayload(startFields), startFields);
  assert.deepEqual(
    makeEndPayload({
      eventId: 42,
      requestId: "req-2",
      processCode: "SMT",
      resourceType: "LINE",
      resourceCode: "L-01",
      parentLineCode: "P-01",
      workerId: "W-01",
    }),
    { eventId: 42, requestId: "req-2" },
  );
});

test("mobile resource normalization preserves LINE/CELL identity and parent line codes", () => {
  assert.equal(normalizeEvent({ eventId: 1, resourceType: "LINE" })?.resourceType, "LINE");
  assert.equal(normalizeEvent({ eventId: 2, resourceType: "CELL" })?.resourceType, "CELL");

  const line = normalizeResource({
    resourceId: 1,
    processCode: "SMT",
    resourceType: "LINE",
    resourceCode: "L-01",
    resourceName: "Line 01",
    parentLineCode: "P-01",
  });
  const cell = normalizeResource({
    resourceId: 2,
    processCode: "ASSY",
    resourceType: "CELL",
    resourceCode: "C-01",
    resourceName: "Cell 01",
    parentLineCode: "L-02",
  });

  assert.equal(line.resourceType, "LINE");
  assert.equal(line.parentLineCode, "P-01");
  assert.equal(cell.resourceType, "CELL");
  assert.equal(cell.parentLineCode, "L-02");
  assert.notEqual(resourceIdentity(line), resourceIdentity(cell));
});

test("mobile request IDs retain stable command signatures and have a bounded UUID fallback", () => {
  assert.match(mobileHelper, /stableStartSignature/);
  assert.match(mobileHelper, /createRequestId/);
  const signatureFields = {
    processCode: "SMT",
    resourceType: "LINE",
    resourceCode: "L-01",
    parentLineCode: "P-01",
    workerId: "W-01",
    reasonCode: "R-01",
    memo: "note",
  };
  assert.equal(stableStartSignature(signatureFields), stableStartSignature({ ...signatureFields }));
  assert.notEqual(stableStartSignature(signatureFields), stableStartSignature({ ...signatureFields, memo: "changed" }));
  const fallback = createRequestId({ randomUUID: undefined, getRandomValues: undefined });
  assert.match(fallback, /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i);
  assert.ok(fallback.length <= 64);

  const supplied = createRequestId({ randomUUID: () => "123e4567-e89b-42d3-a456-426614174000" });
  assert.equal(supplied, "123e4567-e89b-42d3-a456-426614174000");
});

test("mobile status normalization rejects contradictory open-event state", () => {
  assert.match(mobileHelper, /workSegment:\s*['"]DAY['"]\s*\|\s*['"]NIGHT['"]/);
  const base = { workDate: "2026-08-10", workSegment: "DAY", events: [] };
  assert.equal(normalizeStatus({ ...base, state: "RUNNING", openEvent: null }).workSegment, "DAY");
  assert.equal(
    normalizeStatus({ ...base, workSegment: "NIGHT", state: "RUNNING", openEvent: null }).workSegment,
    "NIGHT",
  );
  assert.throws(
    () => normalizeStatus({ ...base, workSegment: "A", state: "RUNNING", openEvent: null }),
    /상태 응답 형식/,
  );
  assert.throws(
    () => normalizeStatus({ ...base, state: "DOWNTIME", openEvent: null }),
    /DOWNTIME.*openEvent/,
  );
  assert.throws(
    () => normalizeStatus({ ...base, state: "DOWNTIME", openEvent: { eventId: 0 } }),
    /DOWNTIME.*openEvent/,
  );
  assert.throws(
    () => normalizeStatus({ ...base, state: "RUNNING", openEvent: { eventId: 42 } }),
    /RUNNING.*openEvent/,
  );
  assert.equal(
    normalizeStatus({ ...base, state: "DOWNTIME", openEvent: { eventId: 42 } }).openEvent?.eventId,
    42,
  );
  assert.equal(normalizeStatus({ ...base, state: "RUNNING", openEvent: null }).openEvent, null);
});

test("mobile server timestamps are formatted in Asia/Seoul", () => {
  assert.equal(formatServerTimestamp("2026-08-10T00:30:00.000Z"), "2026-08-10 09:30:00");
  assert.equal(formatServerTimestamp("2026-08-10T00:30:00.000"), "2026-08-10 00:30:00");
  assert.doesNotMatch(formatServerTimestamp("2026-08-10T00:30:00.000Z"), /Z|UTC/);
});

test("mobile helper rejects malformed command responses before a success state", () => {
  assert.match(mobileHelper, /normalizeCommandResult[\s\S]*if \(!event\) throw new Error/);
  assert.throws(() => normalizeCommandResult({ data: {} }), /이벤트가 없습니다/);
});

test("workplace selection is an exclusive ALL, SMT, or ASSY choice", () => {
  assert.match(page, /['"]START['"][\s\S]*['"]END['"]/);
  assert.match(page, /selectedResourceIds/);
  assert.match(page, /new Set/);
  assert.match(page, /setSelectedResourceIds\(new Set\(\)\)/);
  assert.match(page, /selectedWorkplace/);
  assert.match(page, /useState<\s*OeeProcessCode\s*\|\s*['"]ALL['"]\s*\|\s*null\s*>/);
  assert.doesNotMatch(page, /useState<\s*Set<OeeProcessCode>\s*>/);
  assert.match(page, /selectedProcessList/);
  assert.match(page, /setSelectedWorkplace/);
  assert.match(page, /selectedWorkplace\s*===\s*['"]ALL['"]/);
  assert.match(page, /aria-pressed=\{selected\}/);
  assert.match(page, /aria-checked=\{processMasterState\}/);
  assert.doesNotMatch(page, /MultiEntryProcessFilter|processFilter/);
  assert.match(page, /['"]ALL['"]/);
  assert.match(page, /selectedWorkplace\s*===\s*processCode/);
  assert.match(page, /resource\.processCode === requestedProcess/);
  assert.match(page, /status\.state === ['"]RUNNING['"]/);
  assert.match(page, /status\.state === ['"]DOWNTIME['"]/);
  assert.match(page, /status\.openEvent/);
  assert.match(page, /statusLoading|statusError|unknown/);
  assert.match(page, /disabledReason|inapplicable|notApplicable/);
});

test("workplace controls appear before the resource-header ON/OFF mode controls", () => {
  const workplaceMarker = "aria-label={t('oeeMultiEntry.processSelection')}";
  const modeMarker = "aria-label={t('oeeMultiEntry.mode')}";
  const workplaceIndex = page.indexOf(workplaceMarker);
  const modeIndex = page.indexOf(modeMarker);

  assert.ok(workplaceIndex >= 0, "workplace selector must be present");
  assert.ok(modeIndex >= 0, "mode selector must be present");
  assert.ok(workplaceIndex < modeIndex, "workplace selection must precede mode selection");

  const resourceHeaderIndex = page.indexOf("t('oeeMultiEntry.resourceList')");
  const selectAllIndex = page.indexOf('data-testid="oee-multi-select-all"');
  assert.ok(resourceHeaderIndex >= 0, "resource list header must be present");
  assert.ok(resourceHeaderIndex < modeIndex, "resource title must precede mode controls");
  assert.ok(modeIndex < selectAllIndex, "mode controls must precede select all");

  const modeBlock = page.slice(modeIndex, selectAllIndex + 600);
  assert.match(modeBlock, /startMode/);
  assert.match(modeBlock, /endMode/);
  assert.match(modeBlock, /min-h-\[44px\]/);
  assert.match(modeBlock, /inline-flex/);
  assert.match(page, /flex-wrap/);
});

test("pressing a selected workplace keeps it selected while switching clears hidden resources", () => {
  const toggleWorkplaceBlock = page.match(/const toggleWorkplace[\s\S]*?\n  \);/)?.[0] ?? "";
  assert.match(toggleWorkplaceBlock, /if \(selectedWorkplace === processCode\) return/);
  assert.match(toggleWorkplaceBlock, /setSelectedWorkplace\(processCode\)/);
  assert.doesNotMatch(toggleWorkplaceBlock, /nextProcesses\.(delete|add)/);
  assert.match(toggleWorkplaceBlock, /resource\.processCode\s*!==\s*processCode/);
  assert.match(toggleWorkplaceBlock, /loadContext\(\[processCode\]\)/);

  const toggleAllBlock = page.match(/const toggleAllProcesses[\s\S]*?\n  \);/)?.[0] ?? "";
  assert.match(toggleAllBlock, /setSelectedWorkplace\(['"]ALL['"]\)/);
  assert.match(toggleAllBlock, /loadContext\(RESOURCE_PROCESS_CODES\)/);
});

test("logged-in identity auto-resolves a worker with empNo-first fallback and keeps manual changes compact", () => {
  assert.match(page, /useAuthStore/);
  assert.match(page, /(?:user|loggedInUser)\.empNo/);
  assert.match(page, /(?:user|loggedInUser)\.id/);
  assert.match(page, /auto.*worker|worker.*auto/i);
  assert.match(page, /workers\/\$\{encodeURIComponent\(workerId\)\}/);
  assert.match(page, /workerAutoResolveRef|autoWorkerIdentityRef/);
  assert.match(page, /worker-summary|workerSummary|worker-chip/i);
  assert.match(page, /workerConfirm/);
  const autoResolver = page.match(/const resolveAutoWorker[\s\S]*?\n  \);/)?.[0] ?? "";
  assert.doesNotMatch(autoResolver, /toast\.success/);
});

test("selected processes load concurrently, cache reasons for the worker context, and clear deselected resources", () => {
  assert.match(page, /SMT/);
  assert.match(page, /ASSY/);
  assert.match(page, /RESOURCE_PROCESS_CODES/);
  assert.match(page, /loadContext\(\[processCode\]\)/);
  assert.match(page, /Promise\.allSettled/);
  assert.match(page, /partial|resourceProcessErrors|failedProcesses/i);
  assert.match(page, /retryProcess/);
  assert.match(page, /reasonsLoadedRef|reasonsLoadingRef|reasonsRequestedRef/);
  assert.match(page, /visibleResources/);

  const toggleProcessBlock = page.match(/const toggleWorkplace[\s\S]*?\n  \);/)?.[0] ?? "";
  assert.match(toggleProcessBlock, /setSelectedResourceIds/);
  assert.match(toggleProcessBlock, /resource\.processCode/);
  assert.match(page, /data-testid=["']oee-multi-process-all["']/);
  assert.match(page, /data-testid=\{`oee-multi-process-\$\{processCode\.toLowerCase\(\)\}`\}/);
  assert.match(page, /processMasterState/);
  const toggleAllBlock = page.match(/const toggleAllProcesses[\s\S]*?\n  \);/)?.[0] ?? "";
  assert.match(toggleAllBlock, /setSelectedWorkplace\(['"]ALL['"]\)/);
  assert.match(toggleAllBlock, /loadContext\(RESOURCE_PROCESS_CODES\)/);
});

test("selected process groups share one responsive resource scroll and compact cards", () => {
  assert.match(page, /data-testid=["']oee-multi-resource-groups["']/);
  assert.match(page, /grid-cols-1 xl:grid-cols-2/);
  assert.match(page, /overflow-y-auto overflow-x-hidden/);
  assert.match(page, /data-process-code=\{processCode\}/);
  assert.match(page, /min-h-\[(?:64|68|72)px\]/);
  assert.doesNotMatch(page, /min-h-\[96px\]/);
  assert.match(page, /selectedProcessList\.length === 1 \? ['"]grid-cols-1 sm:grid-cols-2 2xl:grid-cols-3['"] : ['"]grid-cols-1 sm:grid-cols-2['"]/);

  const resourceCard = page.match(/data-testid=["']oee-multi-resource-card["'][\s\S]*?<\/button>/)?.[0] ?? "";
  assert.match(resourceCard, /resource\.resourceCode/);
  assert.match(resourceCard, /resource\.resourceName/);
  assert.match(resourceCard, /resource\.resourceType/);
  assert.doesNotMatch(resourceCard, /resourceTypeLine|resourceTypeCell/);
  assert.match(resourceCard, /selected[\s\S]*Check/);
  assert.match(resourceCard, /StateIcon|statusIcon/);
  assert.doesNotMatch(resourceCard, /resource\.processCode/);
});

test("resource cards use a compact two-row identity and status layout", () => {
  const resourceCard = page.match(/data-testid=["']oee-multi-resource-card["'][\s\S]*?<\/button>/)?.[0] ?? "";
  const identityRow = resourceCard.match(/data-testid=["']oee-multi-resource-card-identity["'][\s\S]*?<\/div>/)?.[0] ?? "";
  const statusRow = resourceCard.match(/data-testid=["']oee-multi-resource-card-status["'][\s\S]*?<\/div>/)?.[0] ?? "";

  assert.match(resourceCard, /min-h-\[56px\]/);
  assert.doesNotMatch(resourceCard, /min-h-\[68px\]/);
  assert.match(identityRow, /resource\.resourceCode/);
  assert.match(identityRow, /resource\.resourceName/);
  assert.match(statusRow, /resource\.resourceType/);
  assert.match(statusRow, /StateIcon/);
  assert.match(resourceCard, /availability\.disabledReason/);
  assert.match(resourceCard, /aria-label=\{`\$\{resource\.resourceCode\}, \$\{resource\.resourceName\}, \$\{resource\.resourceType\}, \$\{availability\.label\}/);
  assert.match(resourceCard, /selected \? <Check/);
  assert.doesNotMatch(resourceCard, /selected\s*\?\s*<Check[\s\S]*:\s*<StateIcon/);
});

test("resource cards keep actual status icons and labels separate from selection", () => {
  assert.match(page, /PlayCircle/);
  assert.match(page, /PauseCircle/);
  assert.match(page, /Loader2/);
  assert.match(page, /AlertTriangle/);

  const resourceCard = page.match(/data-testid=["']oee-multi-resource-card["'][\s\S]*?<\/button>/)?.[0] ?? "";
  assert.match(resourceCard, /availability\.label/);
  assert.match(resourceCard, /StateIcon|statusIcon/);
  assert.match(resourceCard, /selected[\s\S]*Check/);
  assert.doesNotMatch(resourceCard, /selected\s*\?\s*<Check[\s\S]*:\s*<StateIcon/);
});

test("status and command payloads use each resource's process code", () => {
  assert.match(page, /processCode:\s*resource\.processCode/);
  assert.equal(page.match(/processCode:\s*resource\.processCode/g)?.length >= 3, true);

  const startCommandBlock = page.match(/const buildStartCommand[\s\S]*?const buildEndCommand/)?.[0] ?? "";
  const endCommandBlock = page.match(/const buildEndCommand[\s\S]*?const refreshStatuses/)?.[0] ?? "";
  assert.match(startCommandBlock, /processCode:\s*resource\.processCode/);
  assert.match(endCommandBlock, /processCode:\s*resource\.processCode/);
});

test("eligible-resource select-all has checked and mixed semantics and only toggles visible eligible items", () => {
  assert.match(page, /role=["']checkbox["']/);
  assert.match(page, /aria-checked/);
  assert.match(page, /mixed/);
  assert.match(page, /visibleEligibleResources/);
  assert.match(page, /selectAll|toggleVisibleEligible/i);
  assert.match(page, /isEligibleStatus\(mode/);
  assert.match(page, /visibleSelectedCount|selectedVisibleCount/);

  const selectAll = page.match(/data-testid=["']oee-multi-select-all["'][\s\S]*?<\/button>/)?.[0] ?? "";
  assert.match(selectAll, /min-h-\[44px\]/);
  assert.match(selectAll, /t\('oeeMultiEntry\.selectAll'\)/);
  assert.match(selectAll, /t\('oeeMultiEntry\.selectAllEligible'\)/);
  assert.match(selectAll, /visibleSelectedEligibleCount/);
  assert.match(selectAll, /visibleEligibleResources\.length/);
});

test("each resource command has a stable request ID keyed by operation, resource, and signature", () => {
  assert.match(page, /createRequestId\(\)/);
  assert.match(page, /stableStartSignature\(/);
  assert.match(page, /stableEndSignature\(/);
  assert.match(page, /pendingCommandsRef/);
  assert.match(page, /commandKey|operation.*resource.*signature|mode.*resourceIdentity.*signature/);
  assert.match(page, /pending\?\.signature === signature \? pending\.requestId : createRequestId\(\)/);
  assert.match(page, /makeStartPayload/);
  assert.match(page, /makeEndPayload/);
  assert.match(page, /reasonCode/);
  assert.match(page, /memo/);
  assert.match(page, /eventId/);
});

test("retry selection excludes successful and replayed resources while retaining failed resources", () => {
  assert.notEqual(commandKey("START", "101", "same-signature"), commandKey("START", "102", "same-signature"));
  assert.notEqual(commandKey("START", "101", "same-signature"), commandKey("END", "101", "same-signature"));
  assert.equal(isTerminalSuccess("success"), true);
  assert.equal(isTerminalSuccess("replayed"), true);
  assert.equal(isTerminalSuccess("error"), false);

  const selected = [
    { resource: { resourceId: 101 }, resourceKey: "101" },
    { resource: { resourceId: 102 }, resourceKey: "102" },
    { resource: { resourceId: 103 }, resourceKey: "103" },
    { resource: { resourceId: 104 }, resourceKey: "104" },
  ];
  const outcomes = new Map([
    ["101", { resourceKey: "101", resourceCode: "L-101", mode: "START", requestId: "req-101", state: "success", message: "ok" }],
    ["102", { resourceKey: "102", resourceCode: "L-102", mode: "START", requestId: "req-102", state: "replayed", message: "replayed" }],
    ["103", { resourceKey: "103", resourceCode: "L-103", mode: "START", requestId: "req-103", state: "conflict", message: "conflict" }],
  ]);

  assert.deepEqual(selectRetryableResources(selected, outcomes).map((item) => item.resourceKey), ["103", "104"]);
});

test("partial results are visible per resource and retries omit successful items while retaining failed IDs", () => {
  for (const status of ["success", "replayed", "conflict", "error"]) {
    assert.match(page, new RegExp(`['"]${status}['"]`));
  }
  assert.match(page, /Promise\.allSettled/);
  assert.match(page, /outcomes|commandOutcomes/);
  assert.match(page, /success.*replayed|replayed.*success/);
  assert.match(page, /retryFailed|failedOnly|status !== ['"]success['"]/);
  assert.match(page, /refreshStatuses|loadStatuses/);
  assert.match(page, /finally[\s\S]*refreshStatuses|refreshStatuses[\s\S]*finally/);
  assert.match(page, /setSubmitting\(true\)/);
  assert.match(page, /contextLocked|submitting/);
});

test("stale resource status aborts the batch before any partial submission", () => {
  assert.match(page, /commands\.length !== retryCandidates\.length/);
  assert.match(page, /statusChanged[\s\S]*refreshStatuses\(\)[\s\S]*return/);
});

test("the primary START or END action stays visible in the command header", () => {
  assert.match(page, /data-testid=["']oee-multi-primary-action["']/);
  assert.match(page, /oee-multi-command-title[\s\S]*submitBatch\(\)[\s\S]*startBatch/);
  assert.match(page, /\)\s*:\s*\(\s*<button[\s\S]*?onClick=\{\(\) => void submitBatch\(\)\}[\s\S]*?endBatch/);
  assert.doesNotMatch(page, /endConfirmOpen|setEndConfirmOpen|ConfirmModal/);
  assert.doesNotMatch(page, /<span[^>]*>\s*\{mode\}\s*<\/span>/);
});

test("the tablet board exposes touch-sized accessible controls and never uses browser dialogs", () => {
  assert.match(page, /min-h-\[64px\]/);
  assert.match(page, /aria-pressed/);
  assert.match(page, /aria-disabled|aria-label/);
  assert.match(page, /focus-visible:ring/);
  assert.match(page, /Loader2|AlertTriangle|Ban/);
  assert.doesNotMatch(page, /ConfirmModal/);
  assert.doesNotMatch(page, /\b(?:alert|confirm|prompt)\s*\(/);
  assert.match(page, /navigator\.onLine/);
  assert.match(page, /lastCommunication|recentCommunication/);
  assert.match(page, /Device network|deviceNetwork|deviceNetworkLabel/);
  assert.match(page, /MES communication|mesCommunication|recentMes/);
  assert.match(page, /lg:grid-cols-\[minmax\(0,3fr\)_minmax\(0,2fr\)\]/);
  assert.match(page, /xl:w-\[min\(44rem,100%\)\]/);
});

test("START reason selection uses a compact COMMAND summary and an xl modal picker", () => {
  assert.match(page, /reasonEditorOpen/);
  assert.match(page, /setReasonEditorOpen\(false\)/);
  assert.match(page, /setReasonEditorOpen\(true\)/);
  assert.match(page, /data-testid=["']oee-multi-reason-summary["']/);
  assert.match(page, /data-testid=["']oee-multi-reason-trigger["']/);
  assert.match(page, /selectedReason/);
  assert.match(page, /reasonTypeLabel/);
  assert.match(page, /memo\.trim\(\)/);
  assert.match(page, /t\(['"]common\.change['"]\)/);
  assert.match(page, /t\(['"]oeeMultiEntry\.reasonSelect['"]\)/);
  assert.match(page, /maxLength=\{500\}/);
  assert.match(page, /clearCommandState\(\)/);
  assert.match(page, /<Modal[\s\S]*size=["']xl["']/);
  assert.match(page, /initialFocusRef=\{firstReasonButtonRef\}/);
  assert.match(page, /ref=\{reason\.reasonCode === firstReasonCode \? firstReasonButtonRef : undefined\}/);
  assert.match(page, /const clearContext[\s\S]*setReasonEditorOpen\(false\)/);
  assert.match(page, /const selectMode[\s\S]*setReasonEditorOpen\(false\)/);
  assert.match(page, /setReasonCode\(reason\.reasonCode\);\s*clearCommandState\(\);\s*setReasonEditorOpen\(false\)/);

  const commandFieldset = page.match(/<fieldset[\s\S]*?<\/fieldset>/)?.[0] ?? "";
  assert.doesNotMatch(commandFieldset, /oee-multi-reason-group/);
});

test("reasons expose PLAN/UNPLAN ordering and render two-column modal slots", () => {
  assert.match(mobileHelper, /reasonType:\s*['"]PLAN['"]\s*\|\s*['"]UNPLAN['"]/);
  assert.match(mobileHelper, /displayOrder:\s*number/);

  assert.match(page, /reasonGroups|groupedReasons/);
  assert.match(page, /reason\.reasonType/);
  assert.match(page, /(?:left|right)\.displayOrder/);
  assert.match(page, /['"]PLAN['"]/);
  assert.match(page, /['"]UNPLAN['"]/);
  assert.match(page, /reasonTypePlan/);
  assert.match(page, /reasonTypeUnplan/);

  const reasonCard = page.match(/data-testid=["']oee-multi-reason-card["'][\s\S]*?<\/button>/)?.[0] ?? "";
  assert.match(reasonCard, /min-h-\[44px\]/);
  assert.match(reasonCard, /reasonTypeLabel|reasonTypePlan|reasonTypeUnplan/);
  assert.match(reasonCard, /reason\.reasonName/);
  assert.match(reasonCard, /reason\.reasonCode/);
  assert.match(reasonCard, /aria-label=\{`\$\{reasonTypeLabel\}: \$\{reason\.reasonName\}, \$\{reason\.reasonCode\}/);
  assert.match(page, /reasonCardCapacity/);
  assert.match(page, /Math\.max\(6/);
  assert.match(page, /largestReasonGroup\s*%\s*2/);
  assert.match(page, /Array\.from\(\{\s*length:\s*reasonCardCapacity/);
  assert.match(page, /data-testid=["']oee-multi-reason-placeholder["']/);
  assert.match(page, /aria-hidden=["']true["']/);
  assert.match(page, /md:grid-cols-2/);
  assert.match(page, /grid-cols-2/);
  assert.match(page, /size=["']xl["']/);
  assert.doesNotMatch(reasonCard, /overflow-x-auto/);
});

test("desktop selection and command panels use the approved 3:2 ratio", () => {
  assert.match(page, /lg:grid-cols-\[minmax\(0,3fr\)_minmax\(0,2fr\)\]/);
  assert.doesNotMatch(page, /lg:grid-cols-\[minmax\(0,0\.95fr\)_minmax\(0,1\.2fr\)\]/);
});

test("resolved worker identity shares the compact status area while the unresolved form stays usable", () => {
  assert.match(page, /data-testid=["']oee-multi-status-area["']/);
  assert.match(page, /data-testid=["']oee-multi-status-area["'][\s\S]*data-testid=["']oee-multi-worker-summary["']/);
  assert.match(page, /data-testid=["']oee-multi-status-area["'][\s\S]*min-h-\[48px\]/);
  const workerSummary = page.match(/data-testid=["']oee-multi-worker-summary["'][\s\S]*?<\/button>/)?.[0] ?? "";
  assert.match(workerSummary, /min-h-\[48px\]/);
  assert.match(workerSummary, /min-h-\[44px\]/);
  const workerForm = page.match(/data-testid=["']oee-multi-worker-form["'][\s\S]*?\n\s*<\/form>/)?.[0] ?? "";
  assert.match(workerForm, /min-h-\[64px\]/);
});

test("all active locale files contain the new menu label and board copy", () => {
  const requiredKeys = [
    "title",
    "subtitle",
    "startMode",
    "endMode",
    "deviceNetwork",
    "recentMesCommunication",
    "selectProcess",
    "processSelection",
    "processGroupSmt",
    "processGroupAssy",
    "selectAtLeastOne",
    "startBatch",
    "endBatch",
    "success",
    "replayed",
    "conflict",
    "error",
      "retryFailed",
      "allProcesses",
      "selectAll",
      "selectAllEligible",
    "visible",
    "partialResourceLoadError",
      "reasonTypePlan",
      "reasonTypeUnplan",
      "reasonSelect",
  ];

  const expectedTitle = {
    ko: "OEE 비가동 입력",
    en: "OEE Downtime Entry",
    zh: "OEE停机录入",
    vi: "Nhập thời gian dừng OEE",
  };
  const expectedSubtitle = {
    ko: "작업장별 비가동 시작·종료",
    en: "Start/end downtime by workplace.",
    zh: "按工作场所开始/结束停机。",
    vi: "Bắt đầu/kết thúc dừng theo nơi làm việc.",
  };
  const expectedModeCopy = {
    ko: { startMode: "ON", endMode: "OFF", startRule: "가동 상태", endRule: "비가동 상태" },
    en: { startMode: "ON", endMode: "OFF", startRule: "Running", endRule: "Downtime" },
    zh: { startMode: "ON", endMode: "OFF", startRule: "运行中", endRule: "停机中" },
    vi: { startMode: "ON", endMode: "OFF", startRule: "Đang chạy", endRule: "Đang dừng" },
  };
  const expectedShortCopy = {
    ko: {
      endSelectionHint: "선택한 열린 이벤트만 종료",
      selectAll: "전체선택",
      reasonSelect: "사유 선택",
    },
    en: {
      endSelectionHint: "Ends selected open events",
      selectAll: "Select all",
      reasonSelect: "Select reason",
    },
    zh: {
      endSelectionHint: "结束已选开放事件",
      selectAll: "全选",
      reasonSelect: "选择原因",
    },
    vi: {
      endSelectionHint: "Kết thúc sự kiện đang mở đã chọn",
      selectAll: "Chọn tất cả",
      reasonSelect: "Chọn lý do",
    },
  };
  const expectedReasonTypeCopy = {
    ko: { reasonTypePlan: "계획", reasonTypeUnplan: "비계획" },
    en: { reasonTypePlan: "Planned", reasonTypeUnplan: "Unplanned" },
    zh: { reasonTypePlan: "计划", reasonTypeUnplan: "非计划" },
    vi: { reasonTypePlan: "Có kế hoạch", reasonTypeUnplan: "Không có kế hoạch" },
  };
  const expectedResourceCopy = {
    ko: {
      selectionTitle: "작업장 LINE/CELL 선택",
      resourceList: "LINE/CELL 목록",
      selectionHint: "상태 확인된 LINE/CELL만 선택",
      resourcesLoading: "LINE/CELL 목록을 불러오는 중입니다.",
      resourceLoadError: "LINE/CELL 목록을 불러오지 못했습니다.",
      partialResourceLoadError: "일부 작업장 LINE/CELL을 불러오지 못했습니다: {{processes}}",
      noResources: "사용 가능한 LINE/CELL이 없습니다.",
      startOnly: "START: 가동 LINE/CELL만",
      commandTitle: "LINE/CELL 명령",
      selectAllEligible: "가능 LINE/CELL 전체 선택",
      selectAtLeastOne: "상태 확인된 LINE/CELL을 하나 이상 선택하세요.",
      commonStartHint: "선택 LINE/CELL에 공통 적용",
      statusChanged: "상태가 갱신되어 실행 가능한 선택 LINE/CELL이 없습니다.",
      resultsTitle: "LINE/CELL 처리 결과",
      noResults: "선택한 LINE/CELL이 없습니다.",
    },
    en: {
      selectionTitle: "Select workplace and LINE/CELL",
      resourceList: "LINE/CELL list",
      selectionHint: "Select confirmed LINE/CELL only",
      resourcesLoading: "Loading LINE/CELL list.",
      resourceLoadError: "Failed to load LINE/CELL list.",
      partialResourceLoadError: "Failed to load LINE/CELL for some workplaces: {{processes}}",
      noResources: "No LINE/CELL available.",
      startOnly: "START: running LINE/CELL only",
      commandTitle: "LINE/CELL commands",
      selectAllEligible: "Select all eligible LINE/CELL",
      selectAtLeastOne: "Select at least one confirmed LINE/CELL.",
      commonStartHint: "Applied to selected LINE/CELL",
      statusChanged: "Status refreshed; no selected LINE/CELL is currently actionable.",
      resultsTitle: "LINE/CELL results",
      noResults: "No LINE/CELL selected.",
    },
    zh: {
      selectionTitle: "选择工作场所 LINE/CELL",
      resourceList: "LINE/CELL 列表",
      selectionHint: "仅选择已确认状态的 LINE/CELL",
      resourcesLoading: "正在加载 LINE/CELL 列表。",
      resourceLoadError: "LINE/CELL 列表加载失败。",
      partialResourceLoadError: "部分工作场所 LINE/CELL 加载失败：{{processes}}",
      noResources: "没有可用的 LINE/CELL。",
      startOnly: "START：仅运行中的 LINE/CELL",
      commandTitle: "LINE/CELL 命令",
      selectAllEligible: "全选可执行 LINE/CELL",
      selectAtLeastOne: "请至少选择一个已确认状态的 LINE/CELL。",
      commonStartHint: "应用于已选 LINE/CELL",
      statusChanged: "状态已刷新；当前没有可执行的已选 LINE/CELL。",
      resultsTitle: "LINE/CELL 处理结果",
      noResults: "未选择 LINE/CELL。",
    },
    vi: {
      selectionTitle: "Chọn nơi làm việc và LINE/CELL",
      resourceList: "Danh sách LINE/CELL",
      selectionHint: "Chỉ chọn LINE/CELL đã xác nhận trạng thái",
      resourcesLoading: "Đang tải danh sách LINE/CELL.",
      resourceLoadError: "Không thể tải danh sách LINE/CELL.",
      partialResourceLoadError: "Không thể tải LINE/CELL tại một số nơi làm việc: {{processes}}",
      noResources: "Không có LINE/CELL khả dụng.",
      startOnly: "START: chỉ LINE/CELL đang chạy",
      commandTitle: "Lệnh LINE/CELL",
      selectAllEligible: "Chọn tất cả LINE/CELL đủ điều kiện",
      selectAtLeastOne: "Hãy chọn ít nhất một LINE/CELL đã xác nhận trạng thái.",
      commonStartHint: "Áp dụng cho LINE/CELL đã chọn",
      statusChanged: "Đã làm mới trạng thái; không có LINE/CELL đã chọn để thực hiện.",
      resultsTitle: "Kết quả LINE/CELL",
      noResults: "Chưa chọn LINE/CELL.",
    },
  };
  const expectedActionCopy = {
    ko: { startBatch: "비가동 START", endBatch: "비가동 END" },
    en: { startBatch: "Downtime START", endBatch: "Downtime END" },
    zh: { startBatch: "停机 START", endBatch: "停机 END" },
    vi: { startBatch: "Dừng máy START", endBatch: "Dừng máy END" },
  };

  for (const locale of locales) {
    const messages = JSON.parse(readFileSync(`${frontendRoot}/src/locales/${locale}.json`, "utf8"));
    assert.equal(typeof messages.menu?.["oee.multiEntry"], "string", `${locale}: menu.oee.multiEntry`);
    assert.equal(messages.menu?.["oee.multiEntry"], expectedTitle[locale], `${locale}: menu title`);
    for (const key of requiredKeys) {
      assert.equal(typeof messages.oeeMultiEntry?.[key], "string", `${locale}: oeeMultiEntry.${key}`);
    }
    assert.equal(messages.oeeMultiEntry?.title, expectedTitle[locale], `${locale}: board title`);
    assert.equal(messages.oeeMultiEntry?.subtitle, expectedSubtitle[locale], `${locale}: board subtitle`);
    for (const key of ["startMode", "endMode", "startRule", "endRule"]) {
      assert.equal(messages.oeeMultiEntry?.[key], expectedModeCopy[locale][key], `${locale}: oeeMultiEntry.${key}`);
    }
    for (const key of ["reasonTypePlan", "reasonTypeUnplan"]) {
      assert.equal(messages.oeeMultiEntry?.[key], expectedReasonTypeCopy[locale][key], `${locale}: oeeMultiEntry.${key}`);
    }
    for (const key of ["startBatch", "endBatch"]) {
      assert.equal(messages.oeeMultiEntry?.[key], expectedActionCopy[locale][key], `${locale}: oeeMultiEntry.${key}`);
    }
    for (const [key, value] of Object.entries(expectedResourceCopy[locale])) {
      assert.equal(messages.oeeMultiEntry?.[key], value, `${locale}: oeeMultiEntry.${key}`);
    }
    for (const key of ["endSelectionHint", "selectAll", "reasonSelect"]) {
      assert.equal(messages.oeeMultiEntry?.[key], expectedShortCopy[locale][key], `${locale}: oeeMultiEntry.${key}`);
    }
  }

  const koCopy = JSON.stringify(JSON.parse(readFileSync(`${frontendRoot}/src/locales/ko.json`, "utf8")).oeeMultiEntry);
  assert.doesNotMatch(koCopy, /공정/);
  assert.doesNotMatch(koCopy, /리소스/);
});
