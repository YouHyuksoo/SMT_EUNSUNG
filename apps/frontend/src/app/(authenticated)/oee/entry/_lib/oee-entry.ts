export type OeeProcessCode = 'SMT' | 'ASSY';
export type OeeResourceType = 'LINE' | 'CELL';

export interface OeeWorker {
  workerId: string;
  workerName: string;
}

export interface OeeResource {
  processCode: OeeProcessCode;
  resourceType: OeeResourceType;
  resourceCode: string;
  resourceName: string;
  parentLineCode: string | null;
}

export interface OeeReason {
  reasonCode: string;
  reasonName: string;
}

export interface OeeDowntimeEvent {
  eventId: number;
  processCode?: OeeProcessCode;
  resourceType?: OeeResourceType;
  resourceCode?: string;
  parentLineCode?: string | null;
  reasonCode?: string | null;
  memo?: string | null;
  workerId?: string | null;
  startTime?: string | null;
  endTime?: string | null;
}

export interface OeeStatus {
  workDate: string;
  workSegment: string;
  state: 'RUNNING' | 'DOWNTIME';
  events: OeeDowntimeEvent[];
  openEvent: OeeDowntimeEvent | null;
}

export interface OeeCommandResult {
  event: OeeDowntimeEvent;
  replayed: boolean;
}

export interface StartCommandFields {
  processCode: OeeProcessCode;
  resourceType: OeeResourceType;
  resourceCode: string;
  parentLineCode: string;
  workerId: string;
  reasonCode: string;
  memo?: string;
  requestId: string;
}

export interface OeeStartPayload {
  processCode: OeeProcessCode;
  resourceType: OeeResourceType;
  resourceCode: string;
  parentLineCode: string;
  workerId: string;
  reasonCode: string;
  memo?: string;
  requestId: string;
}

export interface EndCommandFields {
  eventId: number;
  requestId: string;
  processCode: OeeProcessCode;
  resourceType: OeeResourceType;
  resourceCode: string;
  parentLineCode: string;
  workerId: string;
}

export interface OeeEndPayload {
  eventId: number;
  requestId: string;
}

interface RequestIdCrypto {
  randomUUID?: () => string;
  getRandomValues?: (array: Uint8Array) => Uint8Array;
}

const UUID_V4_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

function formatUuid(bytes: Uint8Array): string {
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  const hex = Array.from(bytes, (byte) => byte.toString(16).padStart(2, '0')).join('');
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}

/** Generates an idempotency key in browsers where randomUUID is unavailable on plain HTTP. */
export function createRequestId(source: RequestIdCrypto | undefined = globalThis.crypto): string {
  try {
    const candidate = source?.randomUUID?.();
    if (typeof candidate === 'string' && candidate.length <= 64 && UUID_V4_PATTERN.test(candidate)) return candidate;
  } catch (error: unknown) {
    // Fall back to getRandomValues or Math.random below.
  }

  const bytes = new Uint8Array(16);
  let filled = false;
  try {
    if (source?.getRandomValues) {
      source.getRandomValues(bytes);
      filled = true;
    }
  } catch (error: unknown) {
    // Math.random remains available on older/insecure browser contexts.
  }
  if (!filled) {
    for (let index = 0; index < bytes.length; index += 1) bytes[index] = Math.floor(Math.random() * 256);
  }
  return formatUuid(bytes);
}

function timestampPart(parts: Intl.DateTimeFormatPart[], type: Intl.DateTimeFormatPartTypes): string {
  return parts.find((part) => part.type === type)?.value ?? '';
}

/** Formats server timestamps in the fixed MES business display timezone. */
export function formatServerTimestamp(value: string | null | undefined): string {
  if (!value?.trim()) return '—';

  const input = value.trim();
  const normalized = input.replace(' ', 'T');
  const hasTimeZone = /(?:Z|[+-]\d{2}:?\d{2})$/i.test(normalized);
  const date = new Date(hasTimeZone ? normalized : `${normalized}+09:00`);
  if (Number.isNaN(date.getTime())) return input.replace('T', ' ').replace(/\.\d+$/, '').replace(/Z$/i, '');

  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: 'Asia/Seoul',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hourCycle: 'h23',
  }).formatToParts(date);

  return `${timestampPart(parts, 'year')}-${timestampPart(parts, 'month')}-${timestampPart(parts, 'day')} ${timestampPart(parts, 'hour')}:${timestampPart(parts, 'minute')}:${timestampPart(parts, 'second')}`;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

/** Supports the common { data: { data: value } } envelope and raw fallback responses. */
export function unwrap<T>(response: unknown): T {
  if (isRecord(response) && isRecord(response.data) && 'data' in response.data) {
    return response.data.data as T;
  }
  if (isRecord(response) && 'data' in response) {
    return response.data as T;
  }
  return response as T;
}

export function readCollection<T>(response: unknown, key: string): T[] {
  const value = unwrap<unknown>(response);
  if (Array.isArray(value)) return value as T[];
  if (!isRecord(value) || !Array.isArray(value[key])) return [];
  return value[key] as T[];
}

export function normalizeResource(resource: OeeResource): OeeResource {
  return {
    ...resource,
    resourceType: resource.resourceType === 'CELL' ? 'CELL' : 'LINE',
    parentLineCode: typeof resource.parentLineCode === 'string' ? resource.parentLineCode : null,
  };
}

export function resourceIdentity(resource: Pick<OeeResource, 'processCode' | 'resourceType' | 'resourceCode'>): string {
  return `${resource.processCode}:${resource.resourceType}:${resource.resourceCode}`;
}

export function stableStartSignature(fields: Omit<StartCommandFields, 'requestId'>): string {
  return JSON.stringify({
    processCode: fields.processCode,
    resourceType: fields.resourceType,
    resourceCode: fields.resourceCode,
    parentLineCode: fields.parentLineCode,
    workerId: fields.workerId,
    reasonCode: fields.reasonCode,
    memo: fields.memo ?? '',
  });
}

export function stableEndSignature(fields: EndCommandFields): string {
  return JSON.stringify({
    eventId: fields.eventId,
    processCode: fields.processCode,
    resourceType: fields.resourceType,
    resourceCode: fields.resourceCode,
    parentLineCode: fields.parentLineCode,
    workerId: fields.workerId,
  });
}

export function makeStartPayload(fields: StartCommandFields): OeeStartPayload {
  const payload: OeeStartPayload = {
    processCode: fields.processCode,
    resourceType: fields.resourceType,
    resourceCode: fields.resourceCode,
    parentLineCode: fields.parentLineCode,
    workerId: fields.workerId,
    reasonCode: fields.reasonCode,
    requestId: fields.requestId,
  };

  if (fields.memo) payload.memo = fields.memo;
  return payload;
}

export function makeEndPayload(fields: EndCommandFields): OeeEndPayload {
  return {
    eventId: fields.eventId,
    requestId: fields.requestId,
  };
}

function readString(record: Record<string, unknown>, key: string): string | null {
  return typeof record[key] === 'string' ? record[key] : null;
}

export function normalizeEvent(value: unknown): OeeDowntimeEvent | null {
  if (!isRecord(value)) return null;
  const eventId = typeof value.eventId === 'number' ? value.eventId : Number(value.eventId);
  if (!Number.isInteger(eventId) || eventId < 1) return null;

  return {
    eventId,
    processCode: value.processCode === 'SMT' || value.processCode === 'ASSY' ? value.processCode : undefined,
    resourceType: value.resourceType === 'LINE' || value.resourceType === 'CELL' ? value.resourceType : undefined,
    resourceCode: readString(value, 'resourceCode') ?? undefined,
    parentLineCode: readString(value, 'parentLineCode'),
    reasonCode: readString(value, 'reasonCode'),
    memo: readString(value, 'memo'),
    workerId: readString(value, 'workerId'),
    startTime: readString(value, 'startTime'),
    endTime: readString(value, 'endTime'),
  };
}

export function normalizeCommandResult(response: unknown): OeeCommandResult {
  const value = unwrap<unknown>(response);
  if (!isRecord(value)) throw new Error('비가동 명령 응답 형식이 올바르지 않습니다.');
  const event = normalizeEvent(value.event);
  if (!event) throw new Error('비가동 명령 응답에 이벤트가 없습니다.');
  return {
    event,
    replayed: value.replayed === true,
  };
}

export function normalizeStatus(response: unknown): OeeStatus {
  const value = unwrap<unknown>(response);
  if (!isRecord(value)) throw new Error('상태 응답 형식이 올바르지 않습니다.');

  const state = value.state === 'DOWNTIME' || value.state === 'RUNNING' ? value.state : null;
  const workDate = readString(value, 'workDate');
  const workSegment = readString(value, 'workSegment');
  if (!state || !workDate || !workSegment) throw new Error('상태 응답 형식이 올바르지 않습니다.');

  const events = Array.isArray(value.events)
    ? value.events.map(normalizeEvent).filter((event): event is OeeDowntimeEvent => event !== null)
    : [];
  const openEvent = normalizeEvent(value.openEvent);
  const hasOpenEvent = value.openEvent !== null && value.openEvent !== undefined;
  if (state === 'DOWNTIME' && !openEvent) throw new Error('DOWNTIME 상태에는 유효한 openEvent가 필요합니다.');
  if (state === 'RUNNING' && hasOpenEvent) throw new Error('RUNNING 상태에는 openEvent가 없어야 합니다.');

  return {
    workDate,
    workSegment,
    state,
    events,
    openEvent,
  };
}
