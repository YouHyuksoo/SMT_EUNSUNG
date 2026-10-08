"use client";

/**
 * @file src/app/(authenticated)/inventory-query/barcode-check/page.tsx
 * @description 자재바코드스캔실사 — PB w_mat_barcode_check_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **실사 때 릴 바코드를 찍는 화면이다.** 자재재고실사에서 실사를 시작하면 위쪽 입력칸으로
 *    바코드를 찍는다 (scan-card.tsx). PDA 자재 재고실사도 같은 기록을 남긴다.
 * 2. 아래 목록은 찍은 기록이다. 찍은 수량과 찍을 때의 장부 수량을 나란히 놓고 차이를 본다.
 * 3. 장부에 없는 바코드를 찍으면 실사표에 장부 0 으로 들어가고, 일괄 조정 때 재고로 들어온다.
 * 4. 차이를 실제로 맞추는 것은 **자재재고실사** 화면의 일괄 조정이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  barcodeCheckColumns,
  barcodeCheckSummaryColumns,
} from '../inventory-query-columns';
import type {
  BarcodeCheckRow,
  BarcodeCheckSummaryRow,
} from '../inventory-query-columns';
import PartSearchField from '@/components/shared/PartSearchField';
import LineSelect from '@/components/shared/LineSelect';
import ScanCard from './scan-card';
import { stocktakeApi, type StocktakeSession } from '../stocktake';

type TabKey = 'list' | 'summary';

export default function BarcodeCheckPage() {
  const [tab, setTab] = useState<TabKey>('list');
  const [yyyymm, setYyyymm] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [lineCode, setLineCode] = useState('');

  const [rows, setRows] = useState<BarcodeCheckRow[]>([]);
  const [summary, setSummary] = useState<BarcodeCheckSummaryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();
  const [session, setSession] = useState<StocktakeSession | null>(null);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        yyyymm: yyyymm || undefined,
        itemCode: itemCode || undefined,
        lineCode: lineCode || undefined,
      };
      if (tab === 'list') {
        const r = await api.get('/inventory-query/barcode', { params });
        setRows(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/inventory-query/barcode/summary', { params });
        setSummary(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, yyyymm, itemCode, lineCode, mark]);

  useEffect(() => { void search(); }, [tab, yyyymm.length === 6 ? yyyymm : '']); // eslint-disable-line react-hooks/exhaustive-deps

  const loadSession = useCallback(async () => {
    try {
      const s = await stocktakeApi.active();
      setSession(s);
      return s;
    } catch {
      setSession(null);
      return null;
    }
  }, []);

  // 진행 중인 실사가 있으면 그 달 기록을 연다.
  useEffect(() => {
    void loadSession().then((s) => { if (s) setYyyymm(s.yyyymm); });
  }, [loadSession]);

  const onScanned = useCallback(() => {
    void loadSession();
    void search();
  }, [loadSession, search]);

  const mismatched = rows.filter((r) => Number(r.differenceQty ?? 0) !== 0).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재바코드스캔실사</h1>
        <p className="mt-1 text-sm text-text-muted">
          실사 때 찍은 바코드와 장부 수량을 견줍니다 ·{' '}
          {searched
            ? `${(tab === 'list' ? rows : summary).length.toLocaleString()}건`
              + (tab === 'list' && mismatched > 0 ? ` · 차이 ${mismatched}건` : '')
            : '조회하세요'}
        </p>
      </header>

      <ScanCard session={session} onScanned={onScanned} />

      <ScreenTabs
        tabs={[
          { key: 'list' as TabKey, label: '실사 목록', count: rows.length },
          { key: 'summary' as TabKey, label: '품목별 요약', count: summary.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="실사월" placeholder="실사월 (YYYYMM, 비우면 전체)"
            value={yyyymm} className="w-52" inputMode="numeric"
            onChange={(e) => setYyyymm(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)} />
          {tab === 'list' && (
            <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>


      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'list' ? (
            <DataGrid
              data={rows}
              columns={barcodeCheckColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="바코드스캔실사"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['itemBarcode'] }}
              emptyMessage={searched ? '실사 기록이 없습니다.' : '조회하세요.'}
              rowClassName={(row) => (Number((row as BarcodeCheckRow).differenceQty ?? 0) !== 0
                ? 'bg-amber-500/5'
                : '')}
            />
          ) : (
            <DataGrid
              data={summary}
              columns={barcodeCheckSummaryColumns}
              isLoading={loading}
              pageSize={100}
              enableExport
              exportFileName="바코드스캔실사_요약"
              emptyMessage={searched ? '요약할 실사 기록이 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
