"use client";

/**
 * @file src/hooks/useCodeMaster.ts
 * @description 코드마스터(ISYS_CODE_MASTER) 조회 훅 — 공통코드(useComCode)와 다른 체계다.
 *
 * 초보자 가이드:
 * 1. **둘을 구분해야 하는 이유**: PB DataWindow 의 DDDW 중 `vd_standard_code` 계열은
 *    ISYS_BASECODE 가 아니라 ISYS_CODE_MASTER 를 읽는다. 같은 이름의 CODE_TYPE 이
 *    양쪽에 다른 내용으로 존재할 수 있어, 잘못 고르면 라벨이 전부 빈칸이 된다.
 * 2. **어느 쪽인지 판정**: docs/database/pb-dddw-inventory.md 의 `kind` 열
 *    (`basecode` → useComCode, `codemaster` → 이 훅).
 * 3. **캐시**: 전체를 한 번 받아 5분 캐시한다(251행 규모).
 */
import { useMemo } from "react";
import { useApiQuery } from "./useApi";

export interface CodeMasterItem {
  detailCode: string;
  codeName: string;
  codeGroup: string | null;
  codeGroupSecond: string | null;
  codeGroupThird: string | null;
}

export type CodeMasterMap = Record<string, CodeMasterItem[]>;

const CODE_MASTER_QUERY_KEY = ["code-masters", "all-active"];
const CODE_MASTER_URL = "/master/code-masters/all-active";

export function useCodeMasters(enabled: boolean = true) {
  return useApiQuery<CodeMasterMap>(CODE_MASTER_QUERY_KEY, CODE_MASTER_URL, {
    staleTime: 5 * 60 * 1000,
    gcTime: 10 * 60 * 1000,
    retry: false,
    enabled,
  });
}

/** 해당 CODE_TYPE 의 코드 목록 */
export function useCodeMasterList(codeType: string): CodeMasterItem[] {
  const { data } = useCodeMasters();
  return useMemo(() => data?.data?.[codeType] ?? [], [data, codeType]);
}

/** 코드 한 건 */
export function useCodeMasterItem(codeType: string, detailCode?: string | null): CodeMasterItem | undefined {
  const list = useCodeMasterList(codeType);
  return useMemo(
    () => (detailCode ? list.find((item) => item.detailCode === detailCode) : undefined),
    [list, detailCode],
  );
}

/** 코드 → 표시 문구. 못 찾으면 코드를 그대로 돌려준다(빈칸으로 사라지지 않게). */
export function useCodeMasterLabel(codeType: string, detailCode?: string | null): string {
  const item = useCodeMasterItem(codeType, detailCode);
  return item?.codeName ?? (detailCode ?? "");
}

/** Select 옵션 */
export function useCodeMasterOptions(codeType: string, includeAll = true) {
  const list = useCodeMasterList(codeType);
  return useMemo(() => {
    const options = list.map((item) => ({ value: item.detailCode, label: item.codeName }));
    return includeAll ? [{ value: "", label: "전체" }, ...options] : options;
  }, [list, includeAll]);
}
