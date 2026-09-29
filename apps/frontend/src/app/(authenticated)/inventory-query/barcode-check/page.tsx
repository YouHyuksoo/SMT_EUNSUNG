"use client";

/**
 * @file src/app/(authenticated)/inventory-query/barcode-check/page.tsx
 * @description 자재바코드스캔실사 — PB w_mat_barcode_check_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **실사할 때 릴 바코드를 찍은 기록을 보는 화면이다.** 찍은 수량과 장부 수량을
 *    나란히 놓고 차이를 본다.
 * 2. **이 기록은 2020년 10월 것 한 건뿐이다** — 6년 동안 이 방식으로 실사한 적이
 *    없다. 화면에 그렇게 적었다.
 * 3. **쓰기는 옮기지 않았다.** PB 에는 실사에서 발견된 무전표 바코드를 **가상 입고로
 *    만드는** 경로가 있는데, 6년간 쓰이지 않았고 협력사 코드가 하드코딩돼 있다.
 *    검증할 수 없는 원장 생성 코드를 미리 만들어 두면 위험만 늘어난다 —
 *    필요해지면 그때 실측을 다시 하고 붙인다.
 * 4. 차이를 실제로 맞추는 것은 **자재재고조사** 화면이 한다.
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

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

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
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)} />
          {tab === 'list' && (
            <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
              className="w-32"
              onChange={(e) => setLineCode(e.target.value)} />
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <p className="text-sm text-text-muted">
        이 방식의 실사 기록은 2020년 10월 것 한 건뿐입니다. 차이를 실제로 맞추는 것은
        자재재고조사 화면이 합니다.
      </p>

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
