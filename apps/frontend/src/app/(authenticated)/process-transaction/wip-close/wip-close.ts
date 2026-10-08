/**
 * @file src/app/(authenticated)/process-transaction/wip-close/wip-close.ts
 * @description 공정재고마감 API · 타입
 */
import api from '@/services/api';

export interface WipCloseStatus {
  yyyymm: string;
  closed: boolean;
  lastClosed: string | null;
  openingSource: 'inventory' | 'previousClose' | null;
  /** 이 달 원자재 마감이 돼 있는가 (단가 출처) */
  materialClosed: boolean;
  canClose: boolean;
  canCancel: boolean;
  reason: string | null;
  /** 이 달 공정실사 조정이 아직 안 들어간 품목 수 */
  pendingAdjustItems: number;
}

export interface WipCloseLine {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string;
  openingQty: number;
  openingAmt: number;
  receiptQty: number;
  receiptAmt: number;
  issueQty: number;
  issueAmt: number;
  /** 재고조정 (출고에 포함, 모자람 +, 남음 −) */
  adjustQty: number;
  adjustAmt: number;
  endingQty: number;
  endingAmt: number;
  avgPrice: number;
}

export const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const BASE = '/inventory-query/wip-close';

export const wipCloseApi = {
  status: async (yyyymm: string) =>
    ((await api.get(`${BASE}/status`, { params: { yyyymm } })).data?.data ?? null) as WipCloseStatus | null,
  preview: async (yyyymm: string) =>
    (await api.get(`${BASE}/preview`, { params: { yyyymm }, timeout: 180_000 })).data?.data as
      { status: WipCloseStatus; lines: WipCloseLine[]; unpriced?: number },
  close: async (yyyymm: string) =>
    (await api.post(BASE, { yyyymm }, { timeout: 180_000 })).data?.data as
      { yyyymm: string; lines: number; endingQty: number; endingAmt: number },
  cancel: async (yyyymm: string) => (await api.post(`${BASE}/cancel`, { yyyymm })).data?.data as { yyyymm: string },
};
