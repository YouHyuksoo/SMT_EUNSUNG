/**
 * @file 자재입출고수불원장 조회 훅
 *
 * 모드를 바꿔도 조회 버튼을 누르기 전에는 요청하지 않는다.
 * 레거시 창도 라디오를 바꾼 뒤 조회를 눌러야 retrieve가 일어난다.
 */

import { useCallback, useRef, useState } from "react";
import api from "@/services/api";
import { LEDGER_MODE_PATH, buildLedgerParams, type LedgerFilterState, type LedgerMode } from "./types";

/** 한 번에 가져올 최대 행수. 넘치면 화면에서 범위를 좁히도록 안내한다. */
export const LEDGER_ROW_LIMIT = 5000;

interface LedgerQueryState {
  rows: unknown[];
  total: number;
  loading: boolean;
  error: string | null;
  loaded: boolean;
}

const INITIAL: LedgerQueryState = { rows: [], total: 0, loading: false, error: null, loaded: false };

export function useLedgerQuery() {
  const [state, setState] = useState<LedgerQueryState>(INITIAL);
  const controllerRef = useRef<AbortController | null>(null);

  const search = useCallback(async (mode: LedgerMode, filters: LedgerFilterState) => {
    controllerRef.current?.abort();
    const controller = new AbortController();
    controllerRef.current = controller;
    setState(prev => ({ ...prev, loading: true, error: null }));
    try {
      const response = await api.get(LEDGER_MODE_PATH[mode], {
        params: buildLedgerParams(mode, filters, LEDGER_ROW_LIMIT),
        signal: controller.signal,
        suppressErrorModal: true,
      });
      if (controller.signal.aborted) return;
      const rows = Array.isArray(response.data?.data) ? response.data.data : [];
      const total = Number(response.data?.meta?.total ?? rows.length);
      setState({ rows, total, loading: false, error: null, loaded: true });
    } catch (error: unknown) {
      if (controller.signal.aborted) return;
      const record = typeof error === "object" && error !== null ? error as Record<string, unknown> : {};
      const response = typeof record.response === "object" && record.response !== null
        ? record.response as Record<string, unknown>
        : {};
      const body = typeof response.data === "object" && response.data !== null
        ? response.data as Record<string, unknown>
        : {};
      const message = typeof body.message === "string" ? body.message : null;
      setState({ rows: [], total: 0, loading: false, error: message, loaded: true });
    }
  }, []);

  const reset = useCallback(() => {
    controllerRef.current?.abort();
    setState(INITIAL);
  }, []);

  return { ...state, search, reset };
}
