export type OeeProcessCode = 'SMT' | 'ASSY';
export type OeeResourceType = 'LINE' | 'CELL';

export const ASSY_PARENT_LINE_CODE = 'PROD2';
export const NO_ASSEMBLY_CELL_MASTER = 'NO_ASSEMBLY_CELL_MASTER';

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
  if (resource.processCode === 'SMT') {
    return {
      ...resource,
      resourceType: 'LINE',
      parentLineCode: resource.parentLineCode ?? resource.resourceCode,
    };
  }

  return {
    ...resource,
    processCode: 'ASSY',
    resourceType: 'CELL',
    parentLineCode: ASSY_PARENT_LINE_CODE,
  };
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

  return {
    workDate,
    workSegment,
    state,
    events,
    openEvent: normalizeEvent(value.openEvent),
  };
}
