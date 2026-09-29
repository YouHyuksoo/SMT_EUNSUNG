import type { OeeProcessCode } from './oee-mobile';

export type MultiEntryMode = 'START' | 'END';
export type BatchOutcomeState = 'success' | 'definitiveFailure' | 'needsConfirmation';

export interface MultiEntryEvent {
  dtSeq: number;
  organizationId: number;
  lineCode: string;
  reasonCode: string | null;
  memo: string | null;
  worker: string | null;
  startTime: string | null;
  endTime: string | null;
}

export interface MultiEntryStatus {
  workDate: string;
  workSegment: 'DAY' | 'NIGHT';
  state: 'RUNNING' | 'DOWNTIME';
  events: MultiEntryEvent[];
  openEvents: MultiEntryEvent[];
}

export interface MultiEntryStartPayload {
  processCode: OeeProcessCode;
  lineCodes: string[];
  workerId: string;
  reasonCode?: string;
  memo?: string;
}

export interface MultiEntryEndItem {
  lineCode: string;
  dtSeq: number;
}

export interface MultiEntryEndPayload {
  processCode: OeeProcessCode;
  items: MultiEntryEndItem[];
  reasonCode?: string;
}

export interface MultiEntryBatchResponse {
  events: MultiEntryEvent[];
}

export type EndReasonSummaryState = 'same' | 'mixed' | 'someMissing' | 'allMissing';

export interface MultiEntryEndReasonTarget {
  lineCode: string;
  dtSeq: number;
  reasonCode: string | null;
}

export interface EndReasonSummary {
  state: EndReasonSummaryState;
  snapshotKey: string;
  reasonCodes: string[];
  totalCount: number;
  filledCount: number;
  missingCount: number;
}

export interface EndReasonOverride {
  reasonCode: string;
  snapshotKey: string;
}

export interface PendingMultiEntrySubmission {
  mode: MultiEntryMode;
  processCode: OeeProcessCode;
  lineCodes: string[];
  items?: MultiEntryEndItem[];
  createdAt: number;
}

export interface PendingStatusSnapshot {
  status: MultiEntryStatus | null;
  error: string | null;
}

export function canConfirmPendingSubmission({
  pending,
  statusByLine,
  statusLoading,
  online,
  submitting,
}: {
  pending: PendingMultiEntrySubmission | null;
  statusByLine: Record<string, PendingStatusSnapshot>;
  statusLoading: boolean;
  online: boolean;
  submitting: boolean;
}): boolean {
  if (!pending || pending.lineCodes.length === 0 || statusLoading || !online || submitting) return false;
  return pending.lineCodes.every((lineCode) => {
    const result = statusByLine[lineCode];
    return Boolean(result && result.status && !result.error);
  });
}

export interface PendingStorage {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
  removeItem(key: string): void;
}

export type PendingSubmissionStorageErrorCode =
  | 'missing-key'
  | 'unavailable'
  | 'read-failed'
  | 'write-failed'
  | 'clear-failed'
  | 'corrupt';

export class PendingSubmissionStorageError extends Error {
  readonly code: PendingSubmissionStorageErrorCode;

  constructor(code: PendingSubmissionStorageErrorCode, message: string) {
    super(message);
    this.name = 'PendingSubmissionStorageError';
    this.code = code;
  }
}

const PENDING_STORAGE_PREFIX = 'oee-multi-entry-pending';
const EVENT_KEYS = [
  'dtSeq',
  'organizationId',
  'lineCode',
  'reasonCode',
  'memo',
  'worker',
  'startTime',
  'endTime',
] as const;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function unwrapResponse(response: unknown): unknown {
  let value = response;
  for (let depth = 0; depth < 2; depth += 1) {
    if (!isRecord(value) || !('data' in value)) return value;
    value = value.data;
  }
  return value;
}

function positiveInteger(value: unknown): number | null {
  const numberValue = typeof value === 'number' ? value : Number(value);
  return Number.isSafeInteger(numberValue) && numberValue > 0 ? numberValue : null;
}

function nullableString(value: unknown): string | null | undefined {
  if (value === null) return null;
  if (typeof value === 'string') return value;
  return undefined;
}

/** Normalizes only the new ledger event shape; legacy eventId responses are not accepted. */
export function normalizeMultiEntryEvent(value: unknown): MultiEntryEvent | null {
  if (!isRecord(value) || 'eventId' in value) return null;
  if (!EVENT_KEYS.every((key) => key in value)) return null;

  const dtSeq = positiveInteger(value.dtSeq);
  const organizationId = positiveInteger(value.organizationId);
  const lineCode = typeof value.lineCode === 'string' && value.lineCode.trim() ? value.lineCode : null;
  const reasonCode = nullableString(value.reasonCode);
  const memo = nullableString(value.memo);
  const worker = nullableString(value.worker);
  const startTime = nullableString(value.startTime);
  const endTime = nullableString(value.endTime);

  if (
    dtSeq === null ||
    organizationId === null ||
    lineCode === null ||
    reasonCode === undefined ||
    memo === undefined ||
    worker === undefined ||
    startTime === undefined ||
    endTime === undefined
  ) {
    return null;
  }

  return { dtSeq, organizationId, lineCode, reasonCode, memo, worker, startTime, endTime };
}

export function normalizeMultiEntryStatus(response: unknown): MultiEntryStatus {
  const value = unwrapResponse(response);
  if (!isRecord(value)) throw new Error('다중입력 상태 응답 형식이 올바르지 않습니다.');

  const workDate = typeof value.workDate === 'string' && value.workDate.trim() ? value.workDate : null;
  const workSegment = value.workSegment === 'DAY' || value.workSegment === 'NIGHT' ? value.workSegment : null;
  const state = value.state === 'RUNNING' || value.state === 'DOWNTIME' ? value.state : null;
  if (!workDate || !workSegment || !state || !Array.isArray(value.events)) {
    throw new Error('다중입력 상태 응답 형식이 올바르지 않습니다.');
  }

  const events = value.events.map(normalizeMultiEntryEvent);
  if (events.some((event): event is null => event === null)) {
    throw new Error('다중입력 상태 응답의 원장 이벤트 형식이 올바르지 않습니다.');
  }

  if (!Array.isArray(value.openEvents)) {
    throw new Error('다중입력 상태 응답의 열린 이벤트 목록 형식이 올바르지 않습니다.');
  }
  const openEvents = value.openEvents.map(normalizeMultiEntryEvent);
  if (openEvents.some((event): event is null => event === null)) {
    throw new Error('다중입력 상태 응답의 열린 이벤트 목록 형식이 올바르지 않습니다.');
  }
  const normalizedOpenEvents = openEvents as MultiEntryEvent[];
  if (new Set(normalizedOpenEvents.map((event) => event.dtSeq)).size !== normalizedOpenEvents.length) {
    throw new Error('다중입력 상태 응답의 열린 이벤트 실적번호가 중복되었습니다.');
  }
  const derivedState = normalizedOpenEvents.length === 0 ? 'RUNNING' : 'DOWNTIME';
  if (state !== derivedState) {
    throw new Error('다중입력 상태의 state가 열린 이벤트 목록과 일치하지 않습니다.');
  }

  return {
    workDate,
    workSegment,
    state,
    events: events as MultiEntryEvent[],
    openEvents: normalizedOpenEvents,
  };
}

export function normalizeBatchResponse(response: unknown): MultiEntryBatchResponse {
  const value = unwrapResponse(response);
  if (!isRecord(value) || !Array.isArray(value.events)) {
    throw new Error('다중입력 일괄 응답 형식이 올바르지 않습니다.');
  }

  const events = value.events.map(normalizeMultiEntryEvent);
  if (events.some((event): event is null => event === null)) {
    throw new Error('다중입력 일괄 응답의 원장 이벤트 형식이 올바르지 않습니다.');
  }
  return { events: events as MultiEntryEvent[] };
}

function normalizedReasonCode(value: unknown): string | null {
  if (typeof value !== 'string') return null;
  const code = value.trim();
  return code || null;
}

export function utf8ByteLength(value: string): number {
  return new TextEncoder().encode(value).length;
}

/** Stable target identity for an explicit END reason selection. */
export function getEndReasonSnapshotKey(targets: readonly MultiEntryEndReasonTarget[]): string {
  const snapshot = targets
    .map((target) => [target.lineCode, target.dtSeq, normalizedReasonCode(target.reasonCode)] as const)
    .sort((left, right) => {
      if (left[0] < right[0]) return -1;
      if (left[0] > right[0]) return 1;
      if (left[1] !== right[1]) return left[1] - right[1];
      const leftReason = left[2] ?? '';
      const rightReason = right[2] ?? '';
      return leftReason < rightReason ? -1 : leftReason > rightReason ? 1 : 0;
    });
  return JSON.stringify(snapshot);
}

export function summarizeEndReasons(targets: readonly MultiEntryEndReasonTarget[]): EndReasonSummary {
  const reasonCodes = Array.from(
    new Set(
      targets
        .map((target) => normalizedReasonCode(target.reasonCode))
        .filter((reasonCode): reasonCode is string => reasonCode !== null),
    ),
  );
  const filledCount = targets.filter((target) => normalizedReasonCode(target.reasonCode) !== null).length;
  const missingCount = targets.length - filledCount;
  const state: EndReasonSummaryState = filledCount === 0
    ? 'allMissing'
    : missingCount > 0
      ? 'someMissing'
      : reasonCodes.length === 1
        ? 'same'
        : 'mixed';

  return {
    state,
    snapshotKey: getEndReasonSnapshotKey(targets),
    reasonCodes,
    totalCount: targets.length,
    filledCount,
    missingCount,
  };
}

export function createEndReasonOverride(reasonCode: string, snapshotKey: string): EndReasonOverride | null {
  const normalizedCode = normalizedReasonCode(reasonCode);
  if (!normalizedCode || !snapshotKey) return null;
  return { reasonCode: normalizedCode, snapshotKey };
}

export function getActiveEndReasonCode(
  override: EndReasonOverride | null,
  snapshotKey: string,
): string | null {
  if (!override || override.snapshotKey !== snapshotKey) return null;
  return normalizedReasonCode(override.reasonCode);
}

export function makeStartBatchPayload(fields: MultiEntryStartPayload): MultiEntryStartPayload {
  const payload: MultiEntryStartPayload = {
    processCode: fields.processCode,
    lineCodes: [...fields.lineCodes],
    workerId: fields.workerId,
  };
  if (fields.reasonCode?.trim()) payload.reasonCode = fields.reasonCode;
  if (fields.memo?.trim()) payload.memo = fields.memo;
  return payload;
}

export function makeEndBatchPayload(fields: MultiEntryEndPayload): MultiEntryEndPayload {
  const payload: MultiEntryEndPayload = {
    processCode: fields.processCode,
    items: fields.items.map((item) => ({ ...item })),
  };
  const reasonCode = normalizedReasonCode(fields.reasonCode);
  if (reasonCode) payload.reasonCode = reasonCode;
  return payload;
}

function dtSeqKey(dtSeq: number): string {
  return String(dtSeq);
}

/** Requires a complete response set before a 2xx command can be shown as successful. */
export function validateBatchEvents(
  events: MultiEntryEvent[],
  expected:
    | { mode: 'START'; organizationId: number; lineCodes: string[] }
    | { mode: 'END'; organizationId: number; items: MultiEntryEndItem[]; reasonCode?: string | null },
): MultiEntryEvent[] {
  if (!Number.isSafeInteger(expected.organizationId) || expected.organizationId <= 0) {
    throw new Error('인증 조직 식별자가 올바르지 않습니다.');
  }
  if (events.length === 0) {
    throw new Error('다중입력 일괄 응답에 원장 이벤트가 없습니다.');
  }

  const expectedKeys = expected.mode === 'START'
    ? expected.lineCodes
    : expected.items.map((item) => dtSeqKey(item.dtSeq));
  const actualKeys = expected.mode === 'START'
    ? events.map((event) => event.lineCode)
    : events.map((event) => dtSeqKey(event.dtSeq));

  if (
    events.length !== expectedKeys.length ||
    new Set(expectedKeys).size !== expectedKeys.length ||
    new Set(actualKeys).size !== actualKeys.length ||
    expectedKeys.some((key) => !actualKeys.includes(key)) ||
    actualKeys.some((key) => !expectedKeys.includes(key))
  ) {
    throw new Error('다중입력 일괄 응답의 대상 개수 또는 대상이 요청과 일치하지 않습니다.');
  }

  if (expected.mode === 'END') {
    const expectedLineByDtSeq = new Map(expected.items.map((item) => [item.dtSeq, item.lineCode]));
    if (expectedLineByDtSeq.size !== expected.items.length || events.some((event) => expectedLineByDtSeq.get(event.dtSeq) !== event.lineCode)) {
      throw new Error('다중입력 일괄 응답의 실적 라인이 요청과 일치하지 않습니다.');
    }
  }

  let expectedEndReasonCode: string | null = null;
  if (expected.mode === 'END' && expected.reasonCode !== undefined) {
    expectedEndReasonCode = normalizedReasonCode(expected.reasonCode);
    if (expectedEndReasonCode === null) {
      throw new Error('END 일괄 요청의 변경 사유가 비어 있습니다.');
    }
  }

  if (events.some((event) => event.organizationId !== expected.organizationId)) {
    throw new Error('다중입력 일괄 응답의 인증 조직이 요청 조직과 일치하지 않습니다.');
  }

  const startTimes = events.map((event) => timestampValue(event.startTime));
  if (startTimes.some((value): value is null => value === null)) {
    throw new Error('다중입력 일괄 응답의 시작 시간이 올바르지 않습니다.');
  }

  if (expected.mode === 'START') {
    if (events.some((event) => event.endTime !== null)) {
      throw new Error('START 일괄 응답에는 종료 시간이 없어야 합니다.');
    }
    if (!hasCommonTimestamp(startTimes as number[])) {
      throw new Error('START 일괄 응답의 시작 시간이 공통 시각이 아닙니다.');
    }
  } else {
    const endTimes = events.map((event) => timestampValue(event.endTime));
    if (endTimes.some((value): value is null => value === null)) {
      throw new Error('END 일괄 응답의 종료 시간이 올바르지 않습니다.');
    }
    if (!hasCommonTimestamp(endTimes as number[])) {
      throw new Error('END 일괄 응답의 종료 시간이 공통 시각이 아닙니다.');
    }
    const responseReasonCodes = events.map((event) => normalizedReasonCode(event.reasonCode));
    if (responseReasonCodes.some((reasonCode) => reasonCode === null)) {
      throw new Error('END 일괄 응답의 모든 사유가 비어 있지 않아야 합니다.');
    }
    if (expectedEndReasonCode !== null && responseReasonCodes.some((reasonCode) => reasonCode !== expectedEndReasonCode)) {
      throw new Error('END 일괄 응답의 사유가 요청 사유와 일치하지 않습니다.');
    }
  }

  return events;
}

function timestampValue(value: string | null): number | null {
  if (typeof value !== 'string' || !value.trim()) return null;
  const parsed = Date.parse(value);
  return Number.isNaN(parsed) ? null : parsed;
}

function hasCommonTimestamp(values: number[]): boolean {
  const first = values[0];
  return first !== undefined && values.every((value) => value === first);
}

export function parseOrganizationId(value: string | number | null | undefined): number | null {
  if (typeof value === 'number') {
    return Number.isSafeInteger(value) && value > 0 ? value : null;
  }
  if (typeof value !== 'string' || !/^\d+$/.test(value.trim())) return null;
  const parsed = Number(value.trim());
  return Number.isSafeInteger(parsed) && parsed > 0 ? parsed : null;
}

export function getPendingSubmissionStorageKey(
  organizationId: string | number | null | undefined,
  userId: string | null | undefined,
): string | null {
  const organization = parseOrganizationId(organizationId);
  const user = typeof userId === 'string' ? userId.trim() : '';
  if (organization === null || !user) return null;
  return `${PENDING_STORAGE_PREFIX}:${encodeURIComponent(String(organization))}:${encodeURIComponent(user)}`;
}

function browserSessionStorage(): PendingStorage | null {
  if (typeof window === 'undefined') return null;
  try {
    return window.sessionStorage;
  } catch {
    return null;
  }
}

function requirePendingStorage(
  key: string | null,
  storage: PendingStorage | null,
): { key: string; storage: PendingStorage } {
  if (!key) {
    throw new PendingSubmissionStorageError(
      'missing-key',
      '제출 잠금을 저장할 인증 조직·사용자 식별자가 없습니다.',
    );
  }
  if (!storage) {
    throw new PendingSubmissionStorageError(
      'unavailable',
      '브라우저 세션 저장소를 사용할 수 없습니다.',
    );
  }
  return { key, storage };
}

function isPendingSubmission(value: unknown): value is PendingMultiEntrySubmission {
  if (!isRecord(value)) return false;
  const lineCodes = value.lineCodes;
  if (
    (value.mode !== 'START' && value.mode !== 'END') ||
    (value.processCode !== 'SMT' && value.processCode !== 'ASSY') ||
    !Array.isArray(lineCodes) ||
    lineCodes.length === 0 ||
    lineCodes.some((lineCode) => typeof lineCode !== 'string' || !lineCode.trim()) ||
    new Set(lineCodes).size !== lineCodes.length ||
    typeof value.createdAt !== 'number' ||
    !Number.isFinite(value.createdAt)
  ) {
    return false;
  }

  if (value.mode === 'START') return value.items === undefined;
  if (!Array.isArray(value.items) || value.items.length < lineCodes.length) return false;
  if (!value.items.every(
    (item) =>
      isRecord(item) &&
      typeof item.lineCode === 'string' &&
      lineCodes.includes(item.lineCode) &&
      typeof item.dtSeq === 'number' &&
      positiveInteger(item.dtSeq) !== null,
  )) return false;

  const dtSeqs = value.items.map((item) => positiveInteger((item as Record<string, unknown>).dtSeq));
  if (dtSeqs.some((dtSeq): dtSeq is null => dtSeq === null)) return false;
  const itemLineCodes = new Set(value.items.map((item) => (item as Record<string, unknown>).lineCode));
  return new Set(dtSeqs).size === dtSeqs.length && lineCodes.every((lineCode) => itemLineCodes.has(lineCode));
}

export function readPendingSubmission(
  key: string | null,
  storage: PendingStorage | null = browserSessionStorage(),
): PendingMultiEntrySubmission | null {
  const { key: storageKey, storage: pendingStorage } = requirePendingStorage(key, storage);
  let raw: string | null;
  try {
    raw = pendingStorage.getItem(storageKey);
  } catch {
    throw new PendingSubmissionStorageError('read-failed', '제출 잠금 저장소를 읽을 수 없습니다.');
  }
  if (raw === null) return null;

  let value: unknown;
  try {
    value = JSON.parse(raw);
  } catch {
    throw new PendingSubmissionStorageError('corrupt', '제출 잠금 저장소의 형식이 손상되었습니다.');
  }
  if (!isPendingSubmission(value)) {
    throw new PendingSubmissionStorageError('corrupt', '제출 잠금 저장소의 내용이 올바르지 않습니다.');
  }
  return value;
}

export function writePendingSubmission(
  key: string | null,
  pending: PendingMultiEntrySubmission,
  storage: PendingStorage | null = browserSessionStorage(),
): void {
  const { key: storageKey, storage: pendingStorage } = requirePendingStorage(key, storage);
  try {
    pendingStorage.setItem(storageKey, JSON.stringify(pending));
  } catch {
    throw new PendingSubmissionStorageError('write-failed', '제출 잠금 저장소에 쓸 수 없습니다.');
  }
}

/** Deliberately called only after a definitive HTTP result; uncertain requests are never auto-unlocked. */
export function clearPendingSubmission(
  key: string | null,
  storage: PendingStorage | null = browserSessionStorage(),
): void {
  const { key: storageKey, storage: pendingStorage } = requirePendingStorage(key, storage);
  try {
    pendingStorage.removeItem(storageKey);
  } catch {
    throw new PendingSubmissionStorageError('clear-failed', '제출 잠금 저장소를 정리할 수 없습니다.');
  }
}
