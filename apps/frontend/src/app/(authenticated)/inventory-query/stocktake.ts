/**
 * @file src/app/(authenticated)/inventory-query/stocktake.ts
 * @description 바코드 실사 API — 272 자재재고조사 · 274 자재바코드스캔실사가 같이 쓴다
 */
import api from '@/services/api';

/** 진행 중인 실사 (마감 안 된 가장 최근 실사월). */
export interface StocktakeSession {
  yyyymm: string;
  lots: number;
  bookLots: number;
  countedLots: number;
  matchedLots: number;
  shortLots: number;
  overLots: number;
  startedAt: string | null;
}

/** 스캔 한 건의 결과. differenceQty = 실사 − 장부. */
export interface StocktakeScanResult {
  yyyymm: string;
  itemCode: string;
  itemName: string | null;
  lotNo: string;
  bookQty: number;
  countedQty: number;
  differenceQty: number;
}

export interface StocktakeAdjustResult {
  yyyymm: string;
  adjusted: number;
  skipped: { itemCode: string; lotNo: string; reason: string }[];
}

export const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export const stocktakeApi = {
  active: async () =>
    ((await api.get('/inventory-query/stocktake/active')).data?.data ?? null) as StocktakeSession | null,
  start: async (yyyymm: string, regenerate = false) =>
    (await api.post('/inventory-query/stocktake/start', { yyyymm, regenerate }, { timeout: 180_000 })).data?.data as
      { yyyymm: string; lots: number },
  scan: async (barcode: string, qty?: number) =>
    (await api.post('/inventory-query/stocktake/scan', { barcode, qty })).data?.data as StocktakeScanResult,
  cancel: async (barcode: string) =>
    (await api.post('/inventory-query/stocktake/scan/cancel', { barcode })).data?.data as
      { yyyymm: string; itemCode: string; lotNo: string },
  adjustAll: async (yyyymm: string) =>
    (await api.post('/inventory-query/stocktake/adjust-all', { yyyymm }, { timeout: 300_000 })).data?.data as
      StocktakeAdjustResult,
};
