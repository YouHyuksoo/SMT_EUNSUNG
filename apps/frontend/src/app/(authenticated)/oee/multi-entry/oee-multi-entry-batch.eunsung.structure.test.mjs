import assert from "node:assert/strict";
import { existsSync, readFileSync } from "node:fs";
import test from "node:test";
import ts from "typescript";

const frontendRoot = existsSync("src/app") ? "." : "apps/frontend";
const routeRoot = `${frontendRoot}/src/app/(authenticated)/oee/multi-entry`;
const helperPath = `${routeRoot}/_lib/multi-entry.ts`;
const helperSource = existsSync(helperPath) ? readFileSync(helperPath, "utf8") : "";
const helperModule = ts.transpileModule(helperSource, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
}).outputText;
const {
  clearPendingSubmission,
  canConfirmPendingSubmission,
  createEndReasonOverride,
  getActiveEndReasonCode,
  getPendingSubmissionStorageKey,
  makeEndBatchPayload,
  makeStartBatchPayload,
  normalizeBatchResponse,
  normalizeMultiEntryStatus,
  parseOrganizationId,
  summarizeEndReasons,
  PendingSubmissionStorageError,
  readPendingSubmission,
  validateBatchEvents,
  writePendingSubmission,
} = await import(`data:text/javascript;base64,${Buffer.from(helperModule).toString("base64")}`);

const openEvent = (dtSeq, lineCode = "L-01") => ({
  dtSeq,
  organizationId: 7,
  lineCode,
  reasonCode: "R-01",
  memo: null,
  worker: "W-01",
  startTime: "2026-09-10T01:00:00.000Z",
  endTime: null,
});

test("legacy-line status normalizes every plural open event and derives downtime state", () => {
  const first = openEvent(10);
  const second = openEvent(11);
  const status = normalizeMultiEntryStatus({
    workDate: "2026-09-10",
    workSegment: "DAY",
    state: "DOWNTIME",
    events: [],
    openEvents: [first, second],
  });

  assert.deepEqual(status.openEvents, [first, second]);
  assert.equal(status.state, "DOWNTIME");
  assert.throws(
    () => normalizeMultiEntryStatus({
      workDate: "2026-09-10",
      workSegment: "DAY",
      state: "RUNNING",
      events: [],
      openEvents: [first],
    }),
    /상태|openEvents/i,
  );
});

test("END response matching uses unique dtSeq values and permits repeated line codes", () => {
  const events = [
    { ...openEvent(10), reasonCode: "R-END", endTime: "2026-09-10T02:00:00.000Z" },
    { ...openEvent(11), reasonCode: "R-END", endTime: "2026-09-10T02:00:00.000Z" },
  ];
  const expected = {
    mode: "END",
    organizationId: 7,
    items: [
      { lineCode: "L-01", dtSeq: 10 },
      { lineCode: "L-01", dtSeq: 11 },
    ],
    reasonCode: "R-END",
  };

  assert.deepEqual(validateBatchEvents(events, expected), events);
  assert.throws(
    () => validateBatchEvents(
      [{ ...events[0], dtSeq: 10 }, { ...events[1], dtSeq: 10 }],
      expected,
    ),
    /개수|대상|일치|match/i,
  );
  assert.throws(
    () => validateBatchEvents([{ ...events[0], lineCode: "L-02" }, events[1]], expected),
    /라인|line/i,
  );
});

test("pending END records allow repeated line codes but require complete unique dtSeq targets", () => {
  const storage = new Map();
  const session = {
    getItem: (key) => storage.get(key) ?? null,
    setItem: (key, value) => storage.set(key, value),
    removeItem: (key) => storage.delete(key),
  };
  const key = getPendingSubmissionStorageKey(7, "LOGIN01");
  const pending = {
    mode: "END",
    processCode: "SMT",
    lineCodes: ["L-01", "L-02"],
    items: [
      { lineCode: "L-01", dtSeq: 10 },
      { lineCode: "L-01", dtSeq: 11 },
      { lineCode: "L-02", dtSeq: 12 },
    ],
    createdAt: 123,
  };

  writePendingSubmission(key, pending, session);
  assert.deepEqual(readPendingSubmission(key, session), pending);

  for (const items of [
    [{ lineCode: "L-01", dtSeq: 10 }, { lineCode: "L-01", dtSeq: 10 }, { lineCode: "L-02", dtSeq: 12 }],
    [{ lineCode: "L-01", dtSeq: 10 }, { lineCode: "L-01", dtSeq: 11 }],
    [{ lineCode: "L-01", dtSeq: 10 }, { lineCode: "L-01", dtSeq: 11 }, { lineCode: "L-03", dtSeq: 12 }],
  ]) {
    session.setItem(key, JSON.stringify({ ...pending, items }));
    assert.throws(
      () => readPendingSubmission(key, session),
      (error) => error instanceof PendingSubmissionStorageError && error.code === "corrupt",
    );
  }
});

test("END reason summaries distinguish same, mixed, partly missing, and fully missing targets", () => {
  const same = summarizeEndReasons([
    { lineCode: "L-01", dtSeq: 10, reasonCode: "QC01" },
    { lineCode: "L-02", dtSeq: 11, reasonCode: "QC01" },
  ]);
  assert.equal(same.state, "same");
  assert.deepEqual(same.reasonCodes, ["QC01"]);

  assert.equal(
    summarizeEndReasons([
      { lineCode: "L-01", dtSeq: 10, reasonCode: "QC01" },
      { lineCode: "L-02", dtSeq: 11, reasonCode: "EB01" },
    ]).state,
    "mixed",
  );
  assert.equal(
    summarizeEndReasons([
      { lineCode: "L-01", dtSeq: 10, reasonCode: "QC01" },
      { lineCode: "L-02", dtSeq: 11, reasonCode: null },
    ]).state,
    "someMissing",
  );
  assert.equal(
    summarizeEndReasons([
      { lineCode: "L-01", dtSeq: 10, reasonCode: "" },
      { lineCode: "L-02", dtSeq: 11, reasonCode: null },
    ]).state,
    "allMissing",
  );
});

test("explicit END reason overrides are scoped to the exact line/dtSeq/reason snapshot", () => {
  const targets = [
    { lineCode: "L-01", dtSeq: 10, reasonCode: "QC01" },
    { lineCode: "L-02", dtSeq: 11, reasonCode: "EB01" },
  ];
  const snapshot = summarizeEndReasons(targets);
  const override = createEndReasonOverride("QC01", snapshot.snapshotKey);
  assert.deepEqual(override, { reasonCode: "QC01", snapshotKey: snapshot.snapshotKey });
  assert.equal(getActiveEndReasonCode(override, snapshot.snapshotKey), "QC01");

  const changedTarget = summarizeEndReasons([
    ...targets,
    { lineCode: "L-02", dtSeq: 12, reasonCode: "EB01" },
  ]);
  const changedReason = summarizeEndReasons(targets.map((target) =>
    target.lineCode === "L-01" ? { ...target, reasonCode: "EB01" } : target,
  ));
  assert.notEqual(changedTarget.snapshotKey, snapshot.snapshotKey);
  assert.notEqual(changedReason.snapshotKey, snapshot.snapshotKey);
  assert.equal(getActiveEndReasonCode(override, changedTarget.snapshotKey), null);
  assert.equal(getActiveEndReasonCode(override, changedReason.snapshotKey), null);
  assert.equal(createEndReasonOverride(" ", snapshot.snapshotKey), null);
});

test("the batch helper emits only the approved multi-entry wire fields", () => {
  assert.deepEqual(
    makeStartBatchPayload({
      processCode: "SMT",
      lineCodes: ["L-01", "L-02"],
      workerId: "W-01",
      memo: "optional note",
    }),
    {
      processCode: "SMT",
      lineCodes: ["L-01", "L-02"],
      workerId: "W-01",
      memo: "optional note",
    },
  );
  assert.deepEqual(
    makeEndBatchPayload({
      processCode: "SMT",
      items: [{ lineCode: "L-01", dtSeq: 10 }],
      reasonCode: "R-01",
    }),
    {
      processCode: "SMT",
      items: [{ lineCode: "L-01", dtSeq: 10 }],
      reasonCode: "R-01",
    },
  );
  assert.deepEqual(
    Object.keys(makeStartBatchPayload({ processCode: "ASSY", lineCodes: ["L-03"], workerId: "W-02" })).sort(),
    ["lineCodes", "processCode", "workerId"],
  );
  assert.deepEqual(
    Object.keys(makeEndBatchPayload({ processCode: "ASSY", items: [{ lineCode: "L-03", dtSeq: 11 }], reasonCode: "R-02" })).sort(),
    ["items", "processCode", "reasonCode"],
  );
  assert.deepEqual(
    makeEndBatchPayload({ processCode: "ASSY", items: [{ lineCode: "L-03", dtSeq: 11 }] }),
    { processCode: "ASSY", items: [{ lineCode: "L-03", dtSeq: 11 }] },
  );
});

test("the batch response uses ledger dtSeq/lineCode fields and validates the complete target set", () => {
  const response = normalizeBatchResponse({
    events: [
      {
        dtSeq: 10,
        organizationId: 7,
        lineCode: "L-01",
        reasonCode: "R-01",
        memo: null,
        worker: "W-01",
        startTime: "2026-09-10T01:00:00.000Z",
        endTime: null,
      },
      {
        dtSeq: 11,
        organizationId: 7,
        lineCode: "L-02",
        reasonCode: "R-01",
        memo: null,
        worker: "W-01",
        startTime: "2026-09-10T01:00:00.000Z",
        endTime: null,
      },
    ],
  });

  assert.deepEqual(validateBatchEvents(response.events, { mode: "START", organizationId: 7, lineCodes: ["L-01", "L-02"] }), response.events);
  const endResponse = normalizeBatchResponse({
    events: response.events.map((event) => ({
      ...event,
      reasonCode: "R-02",
      endTime: "2026-09-10T02:00:00.000Z",
    })),
  });
  assert.deepEqual(
    validateBatchEvents(endResponse.events, {
      mode: "END",
      organizationId: 7,
      items: [
        { lineCode: "L-01", dtSeq: 10 },
        { lineCode: "L-02", dtSeq: 11 },
      ],
      reasonCode: "R-02",
    }),
    endResponse.events,
  );
  assert.throws(
    () => validateBatchEvents(response.events.slice(0, 1), { mode: "START", organizationId: 7, lineCodes: ["L-01", "L-02"] }),
    /개수|target|match/i,
  );
  assert.throws(
    () => normalizeBatchResponse({ events: [{ eventId: 10, lineCode: "L-01" }] }),
    /응답|event|dtSeq/i,
  );
});

test("batch validation enforces authenticated organization and server timestamp invariants", () => {
  const startEvents = [
    {
      dtSeq: 10,
      organizationId: 7,
      lineCode: "L-01",
      reasonCode: "R-01",
      memo: null,
      worker: "W-01",
      startTime: "2026-09-10T01:00:00.000Z",
      endTime: null,
    },
    {
      dtSeq: 11,
      organizationId: 7,
      lineCode: "L-02",
      reasonCode: "R-01",
      memo: null,
      worker: "W-01",
      startTime: "2026-09-10T01:00:00.000Z",
      endTime: null,
    },
  ];
  const startExpected = { mode: "START", organizationId: 7, lineCodes: ["L-01", "L-02"] };
  assert.deepEqual(validateBatchEvents(startEvents, startExpected), startEvents);

  assert.throws(
    () => validateBatchEvents(startEvents, { ...startExpected, organizationId: 8 }),
    /조직|organization/i,
  );
  assert.throws(
    () => validateBatchEvents(
      [{ ...startEvents[0], startTime: "not-a-time" }, startEvents[1]],
      startExpected,
    ),
    /시간|timestamp|time/i,
  );
  assert.throws(
    () => validateBatchEvents(
      [{ ...startEvents[0], startTime: "2026-09-10T01:00:00.000Z" }, { ...startEvents[1], startTime: "2026-09-10T01:00:01.000Z" }],
      startExpected,
    ),
    /공통|common|시간|time/i,
  );
  assert.throws(
    () => validateBatchEvents([{ ...startEvents[0], endTime: "2026-09-10T02:00:00.000Z" }, startEvents[1]], startExpected),
    /종료|end|시간|time/i,
  );

  const endEvents = startEvents.map((event) => ({
    ...event,
    reasonCode: "R-END",
    endTime: "2026-09-10T02:00:00.000Z",
  }));
  const endExpected = {
    mode: "END",
    organizationId: 7,
    items: [
      { lineCode: "L-01", dtSeq: 10 },
      { lineCode: "L-02", dtSeq: 11 },
    ],
    reasonCode: "R-END",
  };
  assert.deepEqual(validateBatchEvents(endEvents, endExpected), endEvents);
  assert.throws(
    () => validateBatchEvents([{ ...endEvents[0], reasonCode: "R-OLD" }, endEvents[1]], endExpected),
    /사유|reason/i,
  );
  assert.throws(
    () => validateBatchEvents([{ ...endEvents[0], endTime: null }, endEvents[1]], endExpected),
    /종료|end|시간|time/i,
  );
  assert.throws(
    () => validateBatchEvents([{ ...endEvents[0], endTime: "2026-09-10T02:00:00.000Z" }, { ...endEvents[1], endTime: "2026-09-10T02:00:01.000Z" }], endExpected),
    /공통|common|시간|time/i,
  );
});

test("END preservation accepts mixed nonblank reasons while override validation requires one selected code", () => {
  const events = [
    {
      ...openEvent(10, "L-01"),
      reasonCode: "QC01",
      endTime: "2026-09-10T02:00:00.000Z",
    },
    {
      ...openEvent(11, "L-02"),
      reasonCode: "EB01",
      endTime: "2026-09-10T02:00:00.000Z",
    },
  ];
  const items = [
    { lineCode: "L-01", dtSeq: 10 },
    { lineCode: "L-02", dtSeq: 11 },
  ];

  assert.deepEqual(
    validateBatchEvents(events, { mode: "END", organizationId: 7, items }),
    events,
    "omitted reasonCode preserves different existing reasons",
  );
  const overriddenEvents = events.map((event) => ({ ...event, reasonCode: "QC01" }));
  assert.deepEqual(
    validateBatchEvents(overriddenEvents, {
      mode: "END",
      organizationId: 7,
      items,
      reasonCode: "QC01",
    }),
    overriddenEvents,
  );
  assert.throws(
    () => validateBatchEvents([{ ...events[0], reasonCode: "" }, events[1]], { mode: "END", organizationId: 7, items }),
    /사유|reason|non.?blank/i,
  );
  assert.throws(
    () => validateBatchEvents(events, { mode: "END", organizationId: 7, items, reasonCode: "QC01" }),
    /사유|reason|일치|match/i,
  );
});

test("pending submissions are scoped to authenticated organization and user and round-trip in session storage", () => {
  const storage = new Map();
  const session = {
    getItem: (key) => storage.get(key) ?? null,
    setItem: (key, value) => storage.set(key, value),
    removeItem: (key) => storage.delete(key),
  };
  const key = getPendingSubmissionStorageKey(7, "LOGIN01");
  const pending = {
    mode: "END",
    processCode: "SMT",
    lineCodes: ["L-01"],
    items: [{ lineCode: "L-01", dtSeq: 10 }],
    createdAt: 123,
  };

  assert.match(key, /7/);
  assert.match(key, /LOGIN01/);
  writePendingSubmission(key, pending, session);
  assert.deepEqual(readPendingSubmission(key, session), pending);
  clearPendingSubmission(key, session);
  assert.equal(readPendingSubmission(key, session), null);
});

test("pending confirmation requires every target status and a stable online idle query", () => {
  const pending = {
    mode: "START",
    processCode: "SMT",
    lineCodes: ["L-01", "L-02"],
    createdAt: 123,
  };
  const status = {
    workDate: "2026-09-10",
    workSegment: "DAY",
    state: "RUNNING",
    events: [],
    openEvents: [],
  };
  const allSucceeded = {
    "L-01": { status, error: null },
    "L-02": { status, error: null },
  };

  assert.equal(canConfirmPendingSubmission({ pending, statusByLine: allSucceeded, statusLoading: false, online: true, submitting: false }), true);
  assert.equal(canConfirmPendingSubmission({ pending, statusByLine: { "L-01": allSucceeded["L-01"] }, statusLoading: false, online: true, submitting: false }), false, "partial query must stay disabled");
  assert.equal(canConfirmPendingSubmission({ pending, statusByLine: {}, statusLoading: false, online: true, submitting: false }), false, "unqueried targets must stay disabled");
  assert.equal(canConfirmPendingSubmission({ pending, statusByLine: allSucceeded, statusLoading: true, online: true, submitting: false }), false, "querying must stay disabled");
  assert.equal(canConfirmPendingSubmission({ pending, statusByLine: allSucceeded, statusLoading: false, online: false, submitting: false }), false, "offline must stay disabled");
  assert.equal(canConfirmPendingSubmission({ pending, statusByLine: { ...allSucceeded, "L-02": { status, error: "late failure" } }, statusLoading: false, online: true, submitting: false }), false, "errors must stay disabled");
});

test("pending storage failures are explicit and corrupted records never look like an empty store", () => {
  const pending = {
    mode: "START",
    processCode: "SMT",
    lineCodes: ["L-01"],
    createdAt: 123,
  };
  const key = getPendingSubmissionStorageKey("7", "LOGIN01");

  assert.equal(parseOrganizationId("7"), 7);
  assert.equal(parseOrganizationId("not-a-number"), null);
  assert.equal(getPendingSubmissionStorageKey("not-a-number", "LOGIN01"), null);

  assert.throws(
    () => writePendingSubmission(null, pending, { setItem() {}, getItem: () => null, removeItem() {} }),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "missing-key",
  );
  assert.throws(
    () => writePendingSubmission(key, pending, null),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "unavailable",
  );
  assert.throws(
    () => writePendingSubmission(key, pending, { setItem() { throw new Error("quota"); }, getItem: () => null, removeItem() {} }),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "write-failed",
  );

  assert.throws(
    () => readPendingSubmission(key, { getItem: () => "{", setItem() {}, removeItem() {} }),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "corrupt",
  );
  assert.throws(
    () => readPendingSubmission(key, { getItem: () => "", setItem() {}, removeItem() {} }),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "corrupt",
  );
  assert.throws(
    () => readPendingSubmission(key, { getItem() { throw new Error("blocked"); }, setItem() {}, removeItem() {} }),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "read-failed",
  );
  assert.throws(
    () => readPendingSubmission(key, { getItem: () => JSON.stringify({ ...pending, lineCodes: [] }), setItem() {}, removeItem() {} }),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "corrupt",
  );
  assert.throws(
    () => clearPendingSubmission(key, { getItem: () => null, setItem() {}, removeItem() { throw new Error("blocked"); } }),
    (error) => error instanceof PendingSubmissionStorageError && error.code === "clear-failed",
  );
});
