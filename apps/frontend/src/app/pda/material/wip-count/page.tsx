"use client";

/**
 * @file src/app/pda/material/wip-count/page.tsx
 * @description 공정 실사 PDA — 라인을 돌며 릴 바코드를 찍고, 바코드 없는 자재는 품목코드·수량을 넣는다
 *
 * 초보자 가이드:
 * 1. PC 공정실사 화면에서 실사를 시작해야 입력할 수 있다 (없으면 안내만 나온다).
 * 2. 릴: 쓰다 남은 릴은 "남은 수량" 을 먼저 넣고 찍는다. 비워 두면 라벨 수량으로 센다.
 *    찍은 뒤 남은 수량 칸은 비워진다 (다음 릴에 잘못 붙지 않게).
 * 3. 바코드 없는 자재: 품목코드와 수량을 넣고 "입력".
 * 4. "취소 모드" 를 켜고 찍거나 넣으면 그 입력을 지운다.
 * 5. 서버 API 는 PC 화면과 같다 (/inventory-query/wip-stocktake/*). 조정은 PC 의 일괄 조정이 한다.
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
  bookItems: number;
  countedItems: number;
  entries: number;
}

interface HistoryItem {
  key: string;
  itemCode: string;
  itemName: string;
  lotNo: string;
  qty: number;
  bookQty: number;
  countedQty: number;
  canceled: boolean;
  timestamp: string;
}

const BASE = "/inventory-query/wip-stocktake";
const message = (err: unknown) =>
  (err as { response?: { data?: { message?: string } } })?.response?.data?.message || "SCAN_FAILED";

export default function PdaWipCountPage() {
  const { t } = useTranslation();
  const { playSuccess, playError } = useSoundFeedback();
  const scanRef = useRef<ScanInputHandle>(null);

  const [session, setSession] = useState<Session | null>(null);
  const [loadingSession, setLoadingSession] = useState(true);
  const [qty, setQty] = useState("");
  const [itemCode, setItemCode] = useState("");
  const [itemQty, setItemQty] = useState("");
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

  const send = useCallback(
    async (input: { barcode?: string; itemCode?: string; qty?: number }) => {
      setBusy(true);
      setError(null);
      try {
        if (cancelMode) {
          const { data } = await api.post(`${BASE}/count/cancel`, input, { suppressErrorModal: true });
          const r = data?.data as { itemCode: string; lotNo: string };
          setHistory((prev) => [{
            key: `${Date.now()}`, itemCode: r.itemCode, itemName: "", lotNo: r.lotNo,
            qty: 0, bookQty: 0, countedQty: 0, canceled: true, timestamp: new Date().toLocaleTimeString(),
          }, ...prev]);
        } else {
          const { data } = await api.post(`${BASE}/count`, input, { suppressErrorModal: true });
          const r = (data?.data as { last: Omit<HistoryItem, "key" | "canceled" | "timestamp" | "itemName"> & { itemName: string | null } }).last;
          setHistory((prev) => [{
            ...r, itemName: r.itemName ?? "", key: `${Date.now()}`, canceled: false,
            timestamp: new Date().toLocaleTimeString(),
          }, ...prev]);
        }
        playSuccess();
        void loadSession();
        return true;
      } catch (err: unknown) {
        setError(message(err));
        playError();
        return false;
      } finally {
        setBusy(false);
      }
    },
    [cancelMode, playSuccess, playError, loadSession],
  );

  /** 릴 바코드 */
  const onScan = useCallback(
    async (barcode: string) => {
      await send({ barcode, ...(qty.trim() === "" ? {} : { qty: Number(qty) }) });
      setQty("");
      setTimeout(() => scanRef.current?.focus(), 100);
    },
    [send, qty],
  );

  /** 바코드 없는 자재 */
  const onAddItem = useCallback(async () => {
    const code = itemCode.trim().toUpperCase();
    if (!code) return;
    const ok = await send({ itemCode: code, ...(itemQty.trim() === "" ? {} : { qty: Number(itemQty) }) });
    if (ok) { setItemCode(""); setItemQty(""); }
  }, [send, itemCode, itemQty]);

  const renderHistoryItem = useCallback(
    (item: HistoryItem) => (
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-slate-800 dark:text-slate-200">{item.itemCode}</p>
          <p className="text-xs text-slate-500 dark:text-slate-400">{item.itemName}</p>
          <p className="text-xs text-slate-400 dark:text-slate-500">{item.lotNo === "*" ? "-" : item.lotNo}</p>
        </div>
        <div className="text-right">
          {item.canceled ? (
            <p className="text-sm font-bold text-red-500">{t("pda.wipCount.canceled")}</p>
          ) : (
            <>
              <p className="text-base font-bold text-emerald-600 dark:text-emerald-400">{item.qty.toLocaleString()}</p>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {t("pda.wipCount.counted")} {item.countedQty.toLocaleString()} / {t("pda.wipCount.book")} {item.bookQty.toLocaleString()}
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
        <PdaHeader titleKey="pda.wipCount.title" backPath="/pda/material/menu" />
        <div className="flex flex-col items-center justify-center py-20 gap-3">
          <Loader2 className="w-10 h-10 text-primary animate-spin" />
        </div>
      </>
    );
  }

  if (!session) {
    return (
      <>
        <PdaHeader titleKey="pda.wipCount.title" backPath="/pda/material/menu" />
        <div className="mx-4 mt-8 p-8 rounded-2xl border-2 border-dashed border-amber-300 dark:border-amber-600 bg-amber-50 dark:bg-amber-950/20">
          <div className="text-center">
            <AlertTriangle className="w-12 h-12 text-amber-400 dark:text-amber-500 mx-auto mb-3" />
            <p className="text-base font-semibold text-amber-700 dark:text-amber-400">{t("pda.wipCount.noActive")}</p>
            <p className="text-sm text-amber-600 dark:text-amber-500 mt-2">{t("pda.wipCount.startOnPc")}</p>
          </div>
        </div>
      </>
    );
  }

  const inputClass =
    "w-full rounded-xl border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-900 px-3 py-3 text-base text-slate-800 dark:text-slate-100";

  return (
    <>
      <PdaHeader titleKey="pda.wipCount.title" backPath="/pda/material/menu" />

      <div className="mx-4 mb-1 px-4 py-3 rounded-xl bg-primary/5 dark:bg-primary/10 border border-primary/20">
        <div className="flex items-center justify-between">
          <span className="text-sm font-bold text-primary">{session.yyyymm}</span>
          <span className="text-xs font-medium text-slate-500 dark:text-slate-400">
            {session.countedItems.toLocaleString()} / {session.bookItems.toLocaleString()} · {session.entries.toLocaleString()}
          </span>
        </div>
        <label className="mt-2 flex items-center gap-2 text-sm text-slate-700 dark:text-slate-300">
          <input type="checkbox" className="h-5 w-5" checked={cancelMode}
            onChange={(e) => setCancelMode(e.target.checked)} />
          {t("pda.wipCount.cancel")}
        </label>
      </div>

      {/* 릴 바코드 — 남은 수량을 먼저 넣고 찍는다 */}
      <div className="mx-4 mt-2">
        <input aria-label={t("pda.wipCount.qty")} placeholder={t("pda.wipCount.qty")} inputMode="decimal"
          value={qty} disabled={cancelMode} onChange={(e) => setQty(e.target.value)} className={inputClass} />
      </div>
      <ScanInput
        ref={scanRef}
        onScan={onScan}
        placeholderKey="pda.wipCount.scanReel"
        disabled={busy}
        isLoading={busy}
      />

      {/* 바코드 없는 자재 */}
      <div className="mx-4 mt-2 flex gap-2">
        <input aria-label={t("pda.wipCount.itemCode")} placeholder={t("pda.wipCount.itemCode")}
          value={itemCode} onChange={(e) => setItemCode(e.target.value)} className={`${inputClass} flex-[3]`} />
        <input aria-label={t("pda.wipCount.itemQty")} placeholder={t("pda.wipCount.itemQty")} inputMode="decimal"
          value={itemQty} disabled={cancelMode} onChange={(e) => setItemQty(e.target.value)} className={`${inputClass} flex-[2]`} />
        <button type="button" disabled={busy || !itemCode.trim()} onClick={() => { void onAddItem(); }}
          className="flex-[1.5] rounded-xl bg-primary px-2 text-sm font-bold text-white disabled:opacity-40">
          {t("pda.wipCount.add")}
        </button>
      </div>

      {error && <ScanResultCard fields={[]} variant="error" errorMessage={error} />}

      <ScanHistoryList items={history} renderItem={renderHistoryItem} keyExtractor={(item) => item.key} />
    </>
  );
}
