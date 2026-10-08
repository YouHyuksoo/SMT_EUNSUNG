/**
 * @file src/app/(authenticated)/system/inventory-close-date/inventory-close-date.ts
 * @description 재고마감일자 설정 API · 타입
 */
import api from '@/services/api';

export interface ClosePeriodRow {
  yyyymm: string;
  startDate: string;
  /** 종료일 (그날 끝까지 포함) */
  endDate: string;
  /** 등록된 기간인가 (아니면 달력 월이 적용된다) */
  registered: boolean;
  materialClosed: boolean;
  fgClosed: boolean;
  wipClosed: boolean;
  lastCloseDate: string | null;
}

export const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const BASE = '/inventory-query/close-date';

export const closeDateApi = {
  list: async (year: number) =>
    ((await api.get(BASE, { params: { year } })).data?.data ?? []) as ClosePeriodRow[],
  save: async (input: { yyyymm: string; startDate: string; endDate: string }) =>
    (await api.post(BASE, input)).data?.data as { yyyymm: string; startDate: string; endDate: string },
  remove: async (yyyymm: string) => (await api.post(`${BASE}/delete`, { yyyymm })).data?.data as { yyyymm: string },
  generate: async (year: number, startDay: number) =>
    (await api.post(`${BASE}/generate`, { year, startDay })).data?.data as { year: number; startDay: number; months: number },
};
