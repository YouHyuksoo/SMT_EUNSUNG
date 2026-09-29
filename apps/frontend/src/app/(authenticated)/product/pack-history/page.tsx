"use client";

/**
 * @file src/app/(authenticated)/product/pack-history/page.tsx
 * @description 311 제품패킹이력 — PB w_prd_product_packing_history 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **어느 기판이 어느 박스에 담겨 어디까지 갔는지 되짚는 화면이다.** PID 를 찍으면
 *    그 기판이 들어간 박스와 포장·입고·출하 단계가 한 줄로 나온다.
 * 2. **PID 나 박스 바코드 중 하나는 반드시 넣어야 한다.** 이 표가 950만 건이라
 *    조건 없이 훑으면 화면이 돌아오지 않는다.
 * 3. **조건을 넣은 쪽만 SQL 에 들어간다.** `(:값이 없으면 통과)` 식으로 쓰면
 *    인덱스를 못 타 같은 조회가 8.17초가 된다 (실측). 지금은 0.5초다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { History, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { packHistoryColumns } from '../shipping-columns';
import type { PackHistoryRow } from '../shipping-columns';

export default function PackHistoryPage() {
  const [serialNo, setSerialNo] = useState('');
  const [packBarcode, setPackBarcode] = useState('');
  const [rows, setRows] = useState<PackHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    if (!serialNo.trim() && !packBarcode.trim()) {
      toast.error('PID 나 박스 바코드 중 하나는 넣으세요.');
      return;
    }
    setLoading(true);
    try {
      const r = await api.get('/product/pack/history', {
        params: {
          serialNo: serialNo.trim() || undefined,
          packBarcode: packBarcode.trim() || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [serialNo, packBarcode, mark]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품패킹이력</h1>
        <p className="mt-1 text-sm text-text-muted">
          기판이 어느 박스에 담겨 어디까지 갔는지 봅니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <History className="h-4 w-4" />되짚을 대상
          </span>
          <Input aria-label="PID" placeholder="PID" value={serialNo} className="w-64"
            autoFocus
            onChange={(e) => setSerialNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <span className="text-text-muted">또는</span>
          <Input aria-label="박스 바코드" placeholder="박스 바코드" value={packBarcode}
            className="w-64"
            onChange={(e) => setPackBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <p className="text-sm text-text-muted">
        패킹이력이 950만 건이라 PID 나 박스 바코드 중 하나는 반드시 넣어야 합니다.
      </p>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={packHistoryColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="제품패킹이력"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['serialNo'] }}
            emptyMessage={searched ? '패킹 기록이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
