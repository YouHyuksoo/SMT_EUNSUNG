/**
 * @file (authenticated)/oee/dashboard/_lib/fetcher.ts
 * @description OEE 대시보드 전용 SWR fetcher.
 * 과거 일자 스냅샷 미생성은 백엔드가 409(OEE_SUMMARY_NOT_BUILT)로 응답한다.
 * 이는 오류가 아니라 "마감 필요" 상태이므로 에러 모달을 띄우지 않고 notBuilt 플래그로 변환한다.
 */
import axios from 'axios';
import { api } from '@/services/api';

/** 대시보드 조회 결과 — 스냅샷 미생성 시 notBuilt=true, data=null */
export interface OeeResult<T> {
  notBuilt: boolean;
  data: T | null;
}

export async function oeeFetch<T>(url: string): Promise<OeeResult<T>> {
  try {
    const res = await api.get(url, { suppressErrorModal: true });
    return { notBuilt: false, data: (res.data?.data ?? res.data) as T };
  } catch (err: unknown) {
    if (axios.isAxiosError(err) && err.response?.status === 409) {
      return { notBuilt: true, data: null };
    }
    throw err;
  }
}

/** KST(브라우저 로컬) 기준 오늘 YYYY-MM-DD */
export function todayStr(): string {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

/** 소수(0~1) → 백분율 문자열 */
export function pct(n: number | null | undefined): string {
  if (n == null) return '-';
  return `${(n * 100).toFixed(1)}%`;
}
