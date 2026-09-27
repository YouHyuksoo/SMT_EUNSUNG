"use client";

/**
 * @file src/app/(authenticated)/report/material-rack-move/page.tsx
 * @description 자재랙이동리포트 — PB w_mat_location_address_move_report 이식
 *
 * 초보자 가이드:
 * 1. **자재가 어느 랙에서 어느 랙으로 옮겨졌는지 본다.**
 * 2. **이 표는 현재 0행이다** (IM_ITEM_LOCATION_MOVE_HIST 실측 0건). 화면은
 *    동작하지만 볼 것이 없다 — 은성이 랙 이동을 기록하지 않기 때문이다.
 *    조건이 틀린 게 아니다.
 * 3. **품목명을 함께 보여준다.** PB 는 품목코드만 보여줘서 무엇이 움직였는지
 *    코드를 외우지 않으면 알 수 없었다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { materialRackMoveColumns } from '../report-b-columns';
import type { MaterialRackMoveRow } from '../report-b-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function MaterialRackMovePage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(30));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [itemCode, setItemCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');

  const [rows, setRows] = useState<MaterialRackMoveRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/material-rack-move', {
        params: {
          dateFrom,
          dateTo,
          itemCode: itemCode || undefined,
          materialMfs: materialMfs || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재랙이동 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, itemCode, materialMfs]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재랙이동리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재가 옮겨간 랙 이력을 봅니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="이동일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="자재 롯트" placeholder="자재 롯트" value={materialMfs} className="w-40"
            onChange={(e) => setMaterialMfs(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={materialRackMoveColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재랙이동"
            emptyMessage={searched
              ? '랙 이동 기록이 없습니다 (이 표는 현재 비어 있습니다).'
              : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
