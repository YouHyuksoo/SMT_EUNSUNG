/**
 * @file src/hooks/pda/useMatInventoryCount.ts
 * @description 자재 재고실사 PDA 훅 — PC(자재재고조사)에서 시작한 바코드 실사에 스캔을 기록한다
 *
 * 초보자 가이드:
 * 1. 마운트 시 GET /inventory-query/stocktake/active → 진행 중인 실사월. 없으면 noActiveInv.
 * 2. handleScanMaterial(barcode): POST /inventory-query/stocktake/scan → 그 롯트의
 *    장부수량·실사수량을 돌려받아 이력에 쌓는다. 실사수량은 바코드 수량이다.
 * 3. 같은 바코드를 두 번 찍거나 등록되지 않은 바코드면 서버가 거절하고 error 에 담긴다.
 */
import { useState, useCallback, useEffect } from "react";
import { api } from "@/services/api";

/** 진행 중인 실사 */
export interface PhysicalInvSession {
  yyyymm: string;
  bookLots: number;
  countedLots: number;
}

/** 스캔 이력 항목 */
export interface CountHistoryItem {
  barcode: string;
  itemCode: string;
  itemName: string;
  lotNo: string;
  bookQty: number;
  countedQty: number;
  timestamp: string;
}

interface UseMatInventoryCountReturn {
  session: PhysicalInvSession | null;
  noActiveInv: boolean;
  isLoadingSession: boolean;
  isScanning: boolean;
  error: string | null;
  history: CountHistoryItem[];
  handleScanMaterial: (barcode: string) => Promise<boolean>;
  clearError: () => void;
}

export function useMatInventoryCount(): UseMatInventoryCountReturn {
  const [session, setSession] = useState<PhysicalInvSession | null>(null);
  const [noActiveInv, setNoActiveInv] = useState(false);
  const [isLoadingSession, setIsLoadingSession] = useState(true);
  const [isScanning, setIsScanning] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [history, setHistory] = useState<CountHistoryItem[]>([]);

  const loadSession = useCallback(async () => {
    try {
      const { data } = await api.get("/inventory-query/stocktake/active", { suppressErrorModal: true });
      const s = (data?.data ?? null) as PhysicalInvSession | null;
      setSession(s);
      setNoActiveInv(!s);
    } catch {
      setSession(null);
      setNoActiveInv(true);
    } finally {
      setIsLoadingSession(false);
    }
  }, []);

  useEffect(() => { void loadSession(); }, [loadSession]);

  const handleScanMaterial = useCallback(
    async (barcode: string): Promise<boolean> => {
      if (!session) return false;
      setIsScanning(true);
      setError(null);
      try {
        const { data } = await api.post(
          "/inventory-query/stocktake/scan",
          { barcode },
          { suppressErrorModal: true },
        );
        const r = data?.data as {
          itemCode: string; itemName: string | null; lotNo: string; bookQty: number; countedQty: number;
        };
        setHistory((prev) => [
          {
            barcode,
            itemCode: r.itemCode,
            itemName: r.itemName ?? "",
            lotNo: r.lotNo,
            bookQty: r.bookQty,
            countedQty: r.countedQty,
            timestamp: new Date().toLocaleTimeString(),
          },
          ...prev,
        ]);
        setSession((s) => (s ? { ...s, countedLots: s.countedLots + 1 } : s));
        return true;
      } catch (err: unknown) {
        const message =
          (err as { response?: { data?: { message?: string } } })?.response?.data?.message
          || "SCAN_FAILED";
        setError(message);
        return false;
      } finally {
        setIsScanning(false);
      }
    },
    [session],
  );

  const clearError = useCallback(() => setError(null), []);

  return {
    session,
    noActiveInv,
    isLoadingSession,
    isScanning,
    error,
    history,
    handleScanMaterial,
    clearError,
  };
}
