"use client";

/**
 * @file src/app/pda/product/inventory-count/page.tsx
 * @description 제품 재고실사 PDA — 창고의 제품 박스 바코드를 찍어 센다
 *
 * 초보자 가이드:
 * 1. PC 제품실사 화면에서 실사를 시작해야 입력할 수 있다 (없으면 안내만 나온다).
 * 2. 박스 바코드를 찍으면 장부 수량으로 센다. 쓰다 만 박스는 "센 수량" 을 먼저 넣고 찍는다.
 *    찍은 뒤 센 수량 칸은 비워진다 (다음 박스에 잘못 붙지 않게).
 * 3. 장부에 없던 박스도 박스 라벨 수량으로 들어간다 (결과에 "장부에 없던 박스" 로 표시).
 * 4. "취소 모드" 를 켜고 찍으면 그 박스의 입력을 지운다.
 * 5. 서버 API 는 PC 화면과 같다 (/inventory-query/fg-stocktake/*). 조정은 PC 의 일괄 조정이 한다.
 */
import { useCallback, useEffect, useRef, useState } from "react";
import { useTranslation } from "react-i18next";
import { AlertTriangle, Loader2 } from "lucide-react";
import PdaHeader from "@/components/pda/PdaHeader";
import ScanInput from "@/components/pda/ScanInput";
import type { ScanInputHandle } from "@/components/pda/ScanInput";
import ScanResultCard from "@/components/pda/ScanResultCard";
import ScanHistoryList from "@/components/pda/ScanHistoryList";
import { useSoundFeedback } from "@/components/pda/SoundFeedback";
import { api } from "@/services/api";

interface Session {
  yyyymm: string;
  bookBoxes: number;
  scannedBoxes: number;
}

interface ScanLast {
  barcode: string;
  locationCode: string;
  modelName: string | null;
  modelSuffix: string | null;
  qty: number;
  bookQty: number;
  countedQty: number;
  newBox: boolean;
}

interface HistoryItem {
  key: string;
  barcode: string;
  modelName: string;
  qty: number;
  bookQty: number;
  newBox: boolean;
  canceled: boolean;
  timestamp: string;
}

const BASE = "/inventory-query/fg-stocktake";
const message = (err: unknown) =>
  (err as { response?: { data?: { message?: string } } })?.response?.data?.message || "SCAN_FAILED";

export default function ProductInventoryCountPage() {
  const { t } = useTranslation();
  const { playSuccess, playError } = useSoundFeedback();
  const scanRef = useRef<ScanInputHandle>(null);

  const [session, setSession] = useState<Session | null>(null);
  const [loadingSession, setLoadingSession] = useState(true);
  const [qty, setQty] = useState("");
  const [cancelMode, setCancelMode] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [history, setHistory] = useState<HistoryItem[]>([]);

  const loadSession = useCallback(async () => {
    try {
      const { data } = await api.get(`${BASE}/active`, { suppressErrorModal: true });
      setSession((data?.data ?? null) as Session | null);
    } catch {
      setSession(null);
    } finally {
      setLoadingSession(false);
    }
  }, []);

  useEffect(() => { void loadSession(); }, [loadSession]);

  const onScan = useCallback(
    async (barcode: string) => {
      setBusy(true);
      setError(null);
      try {
        if (cancelMode) {
          await api.post(`${BASE}/scan/cancel`, { barcode }, { suppressErrorModal: true });
          setHistory((prev) => [{
            key: `${Date.now()}`, barcode, modelName: "", qty: 0, bookQty: 0, newBox: false, canceled: true,
            timestamp: new Date().toLocaleTimeString(),
          }, ...prev]);
        } else {
          const body = { barcode, ...(qty.trim() === "" ? {} : { qty: Number(qty) }) };
          const { data } = await api.post(`${BASE}/scan`, body, { suppressErrorModal: true });
          const r = (data?.data as { last: ScanLast }).last;
          setHistory((prev) => [{
            key: `${Date.now()}`, barcode: r.barcode, modelName: r.modelName ?? "", qty: r.qty,
            bookQty: r.bookQty, newBox: r.newBox, canceled: false, timestamp: new Date().toLocaleTimeString(),
          }, ...prev]);
        }
        playSuccess();
        void loadSession();
      } catch (err: unknown) {
        setError(message(err));
        playError();
      } finally {
        setBusy(false);
        setQty("");
        setTimeout(() => scanRef.current?.focus(), 100);
      }
    },
    [cancelMode, qty, playSuccess, playError, loadSession],
  );

  const renderHistoryItem = useCallback(
    (item: HistoryItem) => (
      <div className="flex items-center justify-between">
        <div className="min-w-0">
          <p className="truncate text-sm font-medium text-slate-800 dark:text-slate-200">{item.barcode}</p>
          <p className="text-xs text-slate-500 dark:text-slate-400">{item.modelName}</p>
          {item.newBox && <p className="text-xs text-amber-600 dark:text-amber-400">{t("pda.fgCount.newBox")}</p>}
        </div>
        <div className="text-right">
          {item.canceled ? (
            <p className="text-sm font-bold text-red-500">{t("pda.fgCount.canceled")}</p>
          ) : (
            <>
              <p className="text-base font-bold text-emerald-600 dark:text-emerald-400">{item.qty.toLocaleString()}</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {t("pda.fgCount.book")} {item.bookQty.toLocaleString()}
              </p>
            </>
          )}
          <p className="text-xs text-slate-400">{item.timestamp}</p>
        </div>
      </div>
    ),
    [t],
  );

  if (loadingSession) {
    return (
      <>
        <PdaHeader titleKey="pda.fgCount.title" backPath="/pda/menu" />
        <div className="flex flex-col items-center justify-center py-20 gap-3">
          <Loader2 className="w-10 h-10 text-primary animate-spin" />
        </div>
      </>
    );
  }

  if (!session) {
    return (
      <>
        <PdaHeader titleKey="pda.fgCount.title" backPath="/pda/menu" />
        <div className="mx-4 mt-8 p-8 rounded-2xl border-2 border-dashed border-amber-300 dark:border-amber-600 bg-amber-50 dark:bg-amber-950/20">
          <div className="text-center">
            <AlertTriangle className="w-12 h-12 text-amber-400 dark:text-amber-500 mx-auto mb-3" />
            <p className="text-base font-semibold text-amber-700 dark:text-amber-400">{t("pda.fgCount.noActive")}</p>
            <p className="text-sm text-amber-600 dark:text-amber-500 mt-2">{t("pda.fgCount.startOnPc")}</p>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <PdaHeader titleKey="pda.fgCount.title" backPath="/pda/menu" />

      <div className="mx-4 mb-1 px-4 py-3 rounded-xl bg-primary/5 dark:bg-primary/10 border border-primary/20">
        <div className="flex items-center justify-between">
          <span className="text-sm font-bold text-primary">{session.yyyymm}</span>
          <span className="text-xs font-medium text-slate-500 dark:text-slate-400">
            {session.scannedBoxes.toLocaleString()} / {session.bookBoxes.toLocaleString()}
          </span>
        </div>
        <label className="mt-2 flex items-center gap-2 text-sm text-slate-700 dark:text-slate-300">
          <input type="checkbox" className="h-5 w-5" checked={cancelMode}
            onChange={(e) => setCancelMode(e.target.checked)} />
          {t("pda.fgCount.cancel")}
        </label>
      </div>

      {/* 쓰다 만 박스는 센 수량을 먼저 넣고 찍는다 */}
      <div className="mx-4 mt-2">
        <input aria-label={t("pda.fgCount.qty")} placeholder={t("pda.fgCount.qty")} inputMode="decimal"
          value={qty} disabled={cancelMode} onChange={(e) => setQty(e.target.value)}
          className="w-full rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 px-3 py-3 text-base text-slate-800 dark:text-slate-100" />
      </div>
      <ScanInput
        ref={scanRef}
        onScan={onScan}
        placeholderKey="pda.fgCount.scanBox"
        disabled={busy}
        isLoading={busy}
      />

      {error && <ScanResultCard fields={[]} variant="error" errorMessage={error} />}

      <ScanHistoryList items={history} renderItem={renderHistoryItem} keyExtractor={(item) => item.key} />
    </>
  );
}
