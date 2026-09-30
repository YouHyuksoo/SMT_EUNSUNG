"use client";

/**
 * @file src/app/(authenticated)/report/magazine-stock/page.tsx
 * @description 공정매거진조회 — PB w_product_workstage_magazine_stock_rpt 이식
 *
 * 초보자 가이드:
 * 1. **세 갈래를 한 화면에서 본다.** 재공은 매거진에 남아 있는 스냅샷이고,
 *    불량·폐기는 입출고 원장을 기간으로 집계한 것이다.
 * 2. **재공에는 기간이 없고, 불량·폐기에는 기간이 필수다.** 스냅샷과 원장은 성질이
 *    다르다 — 갈래를 바꾸면 기간 칸이 나타나고 사라진다.
 * 3. **갈래마다 공정 묶음이 정해져 있다** (PB 하드코딩 그대로):
 *    불량 W063·W065·W080 · 폐기 W088·W089.
 * 4. **갈래를 바꾸면 이전 결과를 비운다.** 채워지는 칸이 갈래마다 달라서 섞이면
 *    빈 칸을 0 으로 오해한다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { useRunAfterRender } from '@/hooks/useRunAfterRender';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { magazineStockColumns } from '../report-columns';
import type { MagazineStockRow } from '../report-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Kind = 'workstage' | 'defect' | 'destroy';

/** 갈래별 설명. PB 가 하드코딩한 공정 묶음을 화면에 적어 둔다. */
const KIND_NOTE: Record<Kind, string> = {
  workstage: '매거진에 남아 있는 재공 스냅샷입니다 (기간 조건이 없습니다).',
  defect: '불량 공정(W063·W065·W080) 입출고를 기간으로 집계합니다.',
  destroy: '폐기 공정(W088·W089) 입출고를 기간으로 집계합니다.',
};

export default function MagazineStockReportPage() {
  const [kind, setKind] = useState<Kind>('workstage');
  const [modelName, setModelName] = useState('');
  const [modelSuffix, setModelSuffix] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));

  const [rows, setRows] = useState<MagazineStockRow[]>([]);
  /** 마지막 조회의 갈래. 컬럼은 이 값으로 정한다 (탭 상태가 아니다). */
  const [shownKind, setShownKind] = useState<Kind>('workstage');
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async (target: Kind) => {
    setLoading(true);
    try {
      const response = await api.get('/report/magazine-stock', {
        params: {
          kind: target,
          modelName: modelName || undefined,
          modelSuffix: modelSuffix || undefined,
          // 스냅샷 갈래에는 기간을 보내지 않는다 (서버도 쓰지 않는다).
          dateFrom: target === 'workstage' ? undefined : dateFrom,
          dateTo: target === 'workstage' ? undefined : dateTo,
        },
      });
      setRows(response.data?.data ?? []);
      setShownKind(target);
      mark(response);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '공정매거진 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, modelSuffix, dateFrom, dateTo]);

  useEffect(() => { void search('workstage'); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 갈래를 바꾸면 이전 결과를 비우고 새로 읽는다 — 칸의 뜻이 달라진다. */
  const changeKind = (next: Kind) => {
    setKind(next);
    setRows([]);
    setSearched(false);
    void search(next);
  };

  const columns = useMemo(() => magazineStockColumns(shownKind), [shownKind]);

  // 모델을 고르면 새 모델명으로 바로 조회한다 (Enter 조회를 대신함)
  const searchAfterModelSelect = useRunAfterRender(() => search(kind));

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">공정매거진조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          {KIND_NOTE[kind]} · {searched ? `${rows.length}건` : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <ScreenTabs
        tabs={[
          { key: 'workstage', label: '공정재공' },
          { key: 'defect', label: '불량' },
          { key: 'destroy', label: '폐기' },
        ]}
        active={kind}
        onChange={changeKind}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName} className="w-44"
            onChange={(v) => { setModelName(v); if (v) searchAfterModelSelect(); }} />
          <Input aria-label="모델 SFX" placeholder="모델 SFX" value={modelSuffix} className="w-32"
            onChange={(e) => setModelSuffix(e.target.value)} />
          {kind !== 'workstage' && (
            <DateRangeFilter label="입출고일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
          )}
          <Button size="sm" onClick={() => search(kind)} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName={`공정매거진_${kind}`}
            emptyMessage={searched ? '조건에 맞는 자료가 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
