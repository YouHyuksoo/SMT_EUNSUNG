/**
 * @file src/app/(authenticated)/process-transaction/wip-stocktake/wip-stocktake.ts
 * @description 공정 실사 API · 타입
 */
import api from '@/services/api';

export interface WipSession {
  yyyymm: string;
  items: number;
  bookItems: number;
  countedItems: number;
  diffItems: number;
  /** 조정이 아직 안 들어간 품목 */
  pendingItems: number;
  entries: number;
  startedAt: string | null;
}

/** 실사표 한 줄 (품목). differenceQty = 실사 − 장부 */
export interface WipCheckRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  bookQty: number;
  checkQty: number;
  differenceQty: number;
  adjustedQty: number | null;
  entries: number;
  comments: string | null;
}

/** 입력 기록 한 건 */
export interface WipEntryRow {
  itemCode: string;
  itemName: string | null;
  lotNo: string | null;
  lineCode: string | null;
  qty: number;
}

export interface WipCountInput {
  barcode?: string;
  itemCode?: string;
  qty?: number;
  lineCode?: string;
}

export interface WipCountResult {
  last?: { itemCode: string; itemName: string | null; lotNo: string; qty: number; bookQty: number; countedQty: number };
}

export const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const BASE = '/inventory-query/wip-stocktake';

export const wipApi = {
  uploadEndpoint: `${BASE}/upload`,
  active: async () => ((await api.get(`${BASE}/active`)).data?.data ?? null) as WipSession | null,
  list: async (yyyymm: string) => ((await api.get(BASE, { params: { yyyymm } })).data?.data ?? []) as WipCheckRow[],
  entries: async (yyyymm: string) =>
    ((await api.get(`${BASE}/entries`, { params: { yyyymm } })).data?.data ?? []) as WipEntryRow[],
  start: async (yyyymm: string, regenerate = false) =>
    (await api.post(`${BASE}/start`, { yyyymm, regenerate }, { timeout: 180_000 })).data?.data as { yyyymm: string; items: number },
  count: async (input: WipCountInput) => (await api.post(`${BASE}/count`, input)).data?.data as WipCountResult,
  cancel: async (input: WipCountInput) =>
    (await api.post(`${BASE}/count/cancel`, input)).data?.data as { itemCode: string; lotNo: string },
  adjustAll: async (yyyymm: string) =>
    (await api.post(`${BASE}/adjust-all`, { yyyymm }, { timeout: 300_000 })).data?.data as { adjusted: number },
};
