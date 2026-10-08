/**
 * @file src/app/(authenticated)/product/fg-stocktake/fg-stocktake.ts
 * @description 제품 실사 API · 타입
 */
import api from '@/services/api';

export interface FgSession {
  yyyymm: string;
  boxes: number;
  bookBoxes: number;
  scannedBoxes: number;
  diffBoxes: number;
  /** 조정이 아직 안 들어간 박스 */
  pendingBoxes: number;
  bookQty: number;
  checkQty: number;
  startedAt: string | null;
}

/** 실사표 한 줄 (박스). differenceQty = 실사 − 장부 */
export interface FgCheckRow {
  barcode: string;
  locationCode: string;
  packType: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  bookQty: number;
  checkQty: number;
  differenceQty: number;
  adjustedQty: number | null;
  scannedYn: 'Y' | 'N';
  comments: string | null;
}

export interface FgCheckList {
  data: FgCheckRow[];
  total: number;
  /** 10,000행 상한에 닿아 일부만 내려온 경우 */
  truncated: boolean;
}

export type FgStatusFilter = '' | 'diff' | 'unscanned';

export interface FgListFilter {
  status: FgStatusFilter;
  barcode: string;
  modelName: string;
}

export interface FgCountInput {
  barcode: string;
  qty?: number;
  locationCode?: string;
}

export interface FgCountResult {
  last?: {
    barcode: string;
    locationCode: string;
    modelName: string | null;
    modelSuffix: string | null;
    qty: number;
    bookQty: number;
    countedQty: number;
    newBox: boolean;
  };
}

export const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const BASE = '/inventory-query/fg-stocktake';

export const fgApi = {
  uploadEndpoint: `${BASE}/upload`,
  active: async () => ((await api.get(`${BASE}/active`)).data?.data ?? null) as FgSession | null,
  list: async (yyyymm: string, filter: FgListFilter) =>
    ((await api.get(BASE, {
      params: {
        yyyymm,
        ...(filter.status ? { status: filter.status } : {}),
        ...(filter.barcode.trim() ? { barcode: filter.barcode.trim() } : {}),
        ...(filter.modelName.trim() ? { modelName: filter.modelName.trim() } : {}),
      },
    })).data?.data ?? { data: [], total: 0, truncated: false }) as FgCheckList,
  start: async (yyyymm: string, regenerate = false) =>
    (await api.post(`${BASE}/start`, { yyyymm, regenerate }, { timeout: 180_000 })).data?.data as { yyyymm: string; boxes: number },
  scan: async (input: FgCountInput) => (await api.post(`${BASE}/scan`, input)).data?.data as FgCountResult,
  cancel: async (input: FgCountInput) =>
    (await api.post(`${BASE}/scan/cancel`, input)).data?.data as { yyyymm: string; barcode: string },
  adjustAll: async (yyyymm: string) =>
    (await api.post(`${BASE}/adjust-all`, { yyyymm }, { timeout: 300_000 })).data?.data as
      { adjusted: number; adjustedQty: number },
};
