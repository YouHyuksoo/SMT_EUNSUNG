'use client';

import { useCallback, useEffect, useState } from 'react';
import useSWR from 'swr';
import { useTranslations } from 'next-intl';
import DisplayLayout from '@/components/display/DisplayLayout';
import DefectByModelChart from './DefectByModelChart';
import FpyTrendChart from './FpyTrendChart';
import DefectRatePanel from './DefectRatePanel';
import TopDefectModelChart from './TopDefectModelChart';
import TodayLineDefectChart from './TodayLineDefectChart';
import WeeklyLineDefectChart from './WeeklyLineDefectChart';
import useDisplayTiming from '@/hooks/useDisplayTiming';
import { fetcher } from '@/lib/fetcher';
import { buildDisplayApiUrl, getSelectedLines } from '@/lib/display-helpers';
import type { FctChartApiResponse } from '@/lib/queries/fct-chart';

interface FctChartStatusProps {
  screenId: string;
}

const PHASE_COUNT = 7;
const ORIGINS = [
  'origin-top-left',
  'origin-top',
  'origin-top-right',
  'origin-bottom-left',
  'origin-bottom',
  'origin-bottom-right',
];

export default function FctChartStatus({ screenId }: FctChartStatusProps) {
  const t = useTranslations('display');
  const timing = useDisplayTiming();
  const [phase, setPhase] = useState(-1);
  const [lines, setLines] = useState('%');

  useEffect(() => {
    setLines(getSelectedLines(screenId));
  }, [screenId]);

  useEffect(() => {
    const id = setInterval(() => {
      setPhase((prev) => (prev + 1 >= PHASE_COUNT - 1 ? -1 : prev + 1));
    }, timing.scrollSeconds * 1000);
    return () => clearInterval(id);
  }, [timing.scrollSeconds]);

  const handleLineChange = useCallback(() => {
    setLines(getSelectedLines(screenId));
  }, [screenId]);

  useEffect(() => {
    const eventName = `line-config-changed-${screenId}`;
    window.addEventListener(eventName, handleLineChange);
    return () => window.removeEventListener(eventName, handleLineChange);
  }, [screenId, handleLineChange]);

  const { data, error, isLoading } = useSWR<FctChartApiResponse>(
    buildDisplayApiUrl(screenId, { lines: encodeURIComponent(lines) }),
    fetcher,
    { refreshInterval: timing.refreshSeconds * 1000 },
  );

  if (isLoading) {
    return (
      <DisplayLayout screenId={screenId}>
        <div className="flex h-full items-center justify-center text-zinc-400">
          {t('loading')}
        </div>
      </DisplayLayout>
    );
  }

  if (error) {
    return (
      <DisplayLayout screenId={screenId}>
        <div className="flex h-full items-center justify-center text-red-400">
          {t('loadError')}
        </div>
      </DisplayLayout>
    );
  }

  const charts = [
    <DefectByModelChart key="by-model" data={data?.byModel ?? []} />,
    <FpyTrendChart key="trend" data={data?.fpyTrend ?? []} />,
    <TodayLineDefectChart key="today-lines" data={data?.todayLines ?? []} />,
    <DefectRatePanel key="summary" summary={data?.summary ?? null} />,
    <TopDefectModelChart key="top-models" data={data?.topModels ?? []} />,
    <WeeklyLineDefectChart key="weekly-lines" data={data?.weeklyLines ?? []} />,
  ];

  return (
    <DisplayLayout screenId={screenId}>
      <div className="grid h-full grid-cols-3 grid-rows-2 gap-2 p-2">
        {charts.map((chart, i) => {
          const isAllView = phase === -1;
          const isSpotlight = phase === i;
          let cellClass: string;

          if (isAllView) {
            cellClass = 'z-10 scale-100 opacity-100 saturate-100';
          } else if (isSpotlight) {
            cellClass = 'z-20 scale-[1.42] shadow-[0_0_40px_rgba(245,158,11,0.28)]';
          } else {
            cellClass = 'z-10 scale-[0.92] opacity-50 saturate-[0.6]';
          }

          return (
            <div
              key={i}
              onClick={() => setPhase(i)}
              className={[
                'cursor-pointer rounded-xl transition-all duration-700 ease-in-out',
                ORIGINS[i],
                cellClass,
              ].join(' ')}
            >
              {chart}
            </div>
          );
        })}
      </div>
    </DisplayLayout>
  );
}
