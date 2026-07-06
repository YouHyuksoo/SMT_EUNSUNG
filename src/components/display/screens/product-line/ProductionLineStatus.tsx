/**
 * @file ProductionLineStatus.tsx
 * @description 제품생산현황 메인 화면 (메뉴 21). SWR polling + 테이블/차트 레이아웃.
 * 초보자 가이드: API에서 라인별 생산 데이터를 가져와 좌측 테이블 + 우측 달성률 차트에 표시.
 * DisplayLayout이 100vh 프레임을 제공하고, 좌우 패널이 꽉 찬 높이를 차지한다.
 */
'use client';

import { useCallback, useEffect, useState } from 'react';
import useSWR from 'swr';
import { useTranslations } from 'next-intl';
import DisplayLayout from '../../DisplayLayout';
import ProductionLineTable from './ProductionLineTable';
import ProductionLineChart from './ProductionLineChart';
import useDisplayTiming from '@/hooks/useDisplayTiming';
import { useSyncFooterStatus } from '@/components/providers/FooterProvider';
import { fetcher } from '@/lib/fetcher';
import { buildDisplayApiUrl, DEFAULT_ORG_ID, getSelectedLines } from '@/lib/display-helpers';
import type { ProductionLineApiResponse, ProductionLineRowWithRate } from './types';

interface ProductionLineStatusProps {
  screenId: string;
}

/** PLAN_QTY 기반 달성률 계산 (0으로 나누기 방지) */
function calcAchieveRate(actual: number | null, plan: number | null): number {
  if (!plan || plan === 0) return 0;
  return Math.round(((actual ?? 0) / plan) * 1000) / 10;
}

export default function ProductionLineStatus({ screenId }: ProductionLineStatusProps) {
  const t = useTranslations('display');
  const timing = useDisplayTiming();
  const [lastUpdated, setLastUpdated] = useState<Date | null>(null);
  const [selectedLines, setSelectedLines] = useState(() => getSelectedLines(screenId));

  const { data, error, isLoading } = useSWR<ProductionLineApiResponse>(
    buildDisplayApiUrl(screenId, { orgId: DEFAULT_ORG_ID, lines: encodeURIComponent(selectedLines) }),
    fetcher,
    {
      refreshInterval: timing.refreshSeconds * 1000,
      onSuccess: () => setLastUpdated(new Date()),
    },
  );

  const handleLineChange = useCallback(() => {
    setSelectedLines(getSelectedLines(screenId));
  }, [screenId]);

  useEffect(() => {
    const eventName = `line-config-changed-${screenId}`;
    window.addEventListener(eventName, handleLineChange);
    return () => window.removeEventListener(eventName, handleLineChange);
  }, [screenId, handleLineChange]);

  useSyncFooterStatus({ loading: isLoading, lastUpdated });

  const rows: ProductionLineRowWithRate[] = (data?.lines ?? []).map((row) => ({
    ...row,
    achieveRate: calcAchieveRate(row.RUNNING_LOT_ACTUAL_QTY, row.RUNNING_LOT_PLAN_QTY),
  }));

  if (isLoading) {
    return (
      <DisplayLayout screenId={screenId}>
        <div className="flex h-full items-center justify-center text-zinc-400">
          {t('loading')}
        </div>
      </DisplayLayout>
    );
  }

  if (error || data?.error) {
    return (
      <DisplayLayout screenId={screenId}>
        <div className="flex h-full items-center justify-center text-red-400">
          {t('loadError')}
        </div>
      </DisplayLayout>
    );
  }

  return (
    <DisplayLayout screenId={screenId}>
      <div className="flex h-full gap-3 overflow-hidden p-3">
        {/* 좌측: 테이블 72% */}
        <div className="flex min-h-0 w-[72%] flex-col overflow-hidden rounded-lg border border-zinc-800">
          <div className="shrink-0 border-b border-zinc-700 bg-zinc-800 px-5 py-3">
            <h2 className="text-3xl font-black text-white">{t('lineProductionStatus')}</h2>
          </div>
          <div className="min-h-0 flex-1">
            <ProductionLineTable rows={rows} />
          </div>
        </div>
        {/* 우측: 달성률 바 차트 28% */}
        <div className="flex min-h-0 w-[28%] flex-col overflow-hidden rounded-lg border border-zinc-800">
          <div className="shrink-0 border-b border-zinc-700 bg-zinc-800 px-5 py-3">
            <h2 className="text-3xl font-black text-white">{t('lineAchievementRate')}</h2>
          </div>
          <div className="min-h-0 flex-1">
            <ProductionLineChart rows={rows} />
          </div>
        </div>
      </div>
    </DisplayLayout>
  );
}
