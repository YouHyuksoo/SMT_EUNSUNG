"use client";

/**
 * @file src/app/pda/material/inventory-count/page.tsx
 * @description 자재 재고실사 PDA — PC(자재재고조사)에서 시작한 바코드 실사에 릴 바코드를 찍는다
 *
 * 초보자 가이드:
 * 1. PC 에서 실사를 시작해야 스캔할 수 있다 (없으면 안내만 나온다).
 * 2. 자재 바코드를 연속으로 찍는다. 한 장 = 한 롯트이고, 실사수량은 바코드 수량이다.
 * 3. 스캐너는 키보드처럼 입력칸에 친다 — 입력칸 하나로만 받는다 (전역 감지를 같이 쓰면 두 번 전송된다).
 * 4. 이력에 롯트별 장부수량·실사수량이 쌓인다. 차이 조정은 PC 의 일괄 조정이 한다.
 */
import { useCallback, useRef } from "react";
import { useTranslation } from "react-i18next";
import PdaHeader from "@/components/pda/PdaHeader";
import ScanInput from "@/components/pda/ScanInput";
import type { ScanInputHandle } from "@/components/pda/ScanInput";
import ScanResultCard from "@/components/pda/ScanResultCard";
import ScanHistoryList from "@/components/pda/ScanHistoryList";
import { useSoundFeedback } from "@/components/pda/SoundFeedback";
import { AlertTriangle, Loader2 } from "lucide-react";
import {
  useMatInventoryCount,
  type CountHistoryItem,
} from "@/hooks/pda/useMatInventoryCount";

export default function MaterialInventoryCountPage() {
  const { t } = useTranslation();
  const { playSuccess, playError } = useSoundFeedback();

  /** 자재 스캔 인풋 포커스 핸들 */
  const matScanRef = useRef<ScanInputHandle>(null);

  const {
    session,
    noActiveInv,
    isLoadingSession,
    isScanning,
    error,
    history,
    handleScanMaterial,
    clearError,
  } = useMatInventoryCount();

  /** 자재 바코드 스캔 */
  const onScanMaterial = useCallback(
    async (barcode: string) => {
      clearError();
      const ok = await handleScanMaterial(barcode);
      setTimeout(() => matScanRef.current?.focus(), 100);
      if (ok) {
        playSuccess();
      } else {
        playError();
      }
    },
    [handleScanMaterial, playSuccess, playError, clearError],
  );

  /** 이력 렌더 */
  const renderHistoryItem = useCallback(
    (item: CountHistoryItem) => (
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-slate-800 dark:text-slate-200">
            {item.itemCode}
          </p>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {item.itemName}
          </p>
          <p className="text-xs text-slate-400 dark:text-slate-500">
            {item.lotNo}
          </p>
        </div>
        <div className="text-right">
          <p className="text-base font-bold text-emerald-600 dark:text-emerald-400">
            {item.countedQty.toLocaleString()}
          </p>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {t("pda.invCount.systemQty")}: {item.bookQty.toLocaleString()}
          </p>
          <p className="text-xs text-slate-400">{item.timestamp}</p>
        </div>
      </div>
    ),
    [t],
  );

  /* ─── 세션 로딩 중 ─── */
  if (isLoadingSession) {
    return (
      <>
        <PdaHeader titleKey="pda.inventoryCount.title" backPath="/pda/material/menu" />
        <div className="flex flex-col items-center justify-center py-20 gap-3">
          <Loader2 className="w-10 h-10 text-primary animate-spin" />
          <p className="text-sm text-slate-500 dark:text-slate-400">
            {t("common.loading")}
          </p>
        </div>
      </>
    );
  }

  /* ─── 진행 중 실사 없음 ─── */
  if (noActiveInv) {
    return (
      <>
        <PdaHeader titleKey="pda.inventoryCount.title" backPath="/pda/material/menu" />
        <div className="mx-4 mt-8 p-8 rounded-2xl border-2 border-dashed border-amber-300 dark:border-amber-600 bg-amber-50 dark:bg-amber-950/20">
          <div className="text-center">
            <AlertTriangle className="w-12 h-12 text-amber-400 dark:text-amber-500 mx-auto mb-3" />
            <p className="text-base font-semibold text-amber-700 dark:text-amber-400">
              {t("pda.invCount.noActive")}
            </p>
            <p className="text-sm text-amber-600 dark:text-amber-500 mt-2">
              {t("pda.invCount.startOnPc")}
            </p>
          </div>
        </div>
      </>
    );
  }

  /* ─── 메인 UI ─── */
  return (
    <>
      <PdaHeader titleKey="pda.inventoryCount.title" backPath="/pda/material/menu" />

      {session && (
        <div className="mx-4 mb-1 px-4 py-3 rounded-xl bg-primary/5 dark:bg-primary/10 border border-primary/20">
          <div className="flex items-center justify-between">
            <span className="text-sm font-bold text-primary">{session.yyyymm}</span>
            <span className="text-xs font-medium text-slate-500 dark:text-slate-400">
              {session.countedLots.toLocaleString()} / {session.bookLots.toLocaleString()}
            </span>
          </div>
        </div>
      )}

      <ScanInput
        ref={matScanRef}
        onScan={onScanMaterial}
        placeholderKey="pda.invCount.scanMaterial"
        disabled={isScanning}
        isLoading={isScanning}
      />

      {error && (
        <ScanResultCard
          fields={[]}
          variant="error"
          errorMessage={error}
        />
      )}

      <ScanHistoryList
        items={history}
        renderItem={renderHistoryItem}
        keyExtractor={(item, idx) => `${item.barcode}-${idx}`}
      />
    </>
  );
}
