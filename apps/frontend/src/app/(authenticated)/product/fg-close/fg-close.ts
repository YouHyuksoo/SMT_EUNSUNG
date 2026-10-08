/**
 * @file src/app/(authenticated)/product/fg-close/fg-close.ts
 * @description 제품 재고마감 API · 타입
 */
import api from '@/services/api';

export interface FgCloseStatus {
  yyyymm: string;
  closed: boolean;
  closedAt: string | null;
  lastClosed: string | null;
  openingSource: 'ledger' | 'previousClose' | null;
  canClose: boolean;
  canCancel: boolean;
  reason: string | null;
  /** 이 달 실사 조정이 아직 안 들어간 박스 수 */
  pendingAdjustBoxes: number;
}

export interface FgCloseLine {
  modelName: string;
  modelSuffix: string;
  itemCode: string | null;
  openingQty: number;
  receiptQty: number;
  issueQty: number;
  adjustQty: number;
  endingQty: number;
}

export const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const BASE = '/inventory-query/fg-close';

export const fgCloseApi = {
  status: async (yyyymm: string) =>
    ((await api.get(`${BASE}/status`, { params: { yyyymm } })).data?.data ?? null) as FgCloseStatus | null,
  preview: async (yyyymm: string) =>
    (await api.get(`${BASE}/preview`, { params: { yyyymm }, timeout: 180_000 })).data?.data as
      { status: FgCloseStatus; lines: FgCloseLine[] },
  close: async (yyyymm: string) =>
    (await api.post(BASE, { yyyymm }, { timeout: 180_000 })).data?.data as { yyyymm: string; lines: number; endingQty: number },
  cancel: async (yyyymm: string) => (await api.post(`${BASE}/cancel`, { yyyymm })).data?.data as { yyyymm: string },
};
