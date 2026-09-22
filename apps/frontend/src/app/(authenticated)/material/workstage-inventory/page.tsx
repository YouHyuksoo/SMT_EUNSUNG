"use client";

import { useCallback, useMemo, useState } from 'react';
import { Boxes, RefreshCw, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import PartSelect from '@/components/shared/PartSelect';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { workstageInventoryColumns } from './columns';
import type { WorkstageInventoryRow } from './types';

export default function WorkstageInventoryPage() {
  const [rows, setRows] = useState<WorkstageInventoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [itemCode, setItemCode] = useState('');
  const [includeZero, setIncludeZero] = useState(true);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/material/workstage-inventory', {
        params: { limit: 5000, itemCode: itemCode || undefined, includeZero: includeZero ? 'Y' : 'N' },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      setRows([]);
      setTotal(0);
    } finally {
      setLoading(false);
    }
  }, [includeZero, itemCode]);

  const inventoryQty = useMemo(() => rows.reduce((sum, row) => sum + Number(row.inventoryQty ?? 0), 0), [rows]);

  return (
    <main className="flex h-full min-w-0 flex-col gap-3 p-5">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text"><Boxes className="h-6 w-6 text-primary" />공정재고조회</h1>
          <p className="mt-1 text-sm text-text-muted">PB W_MAT_WORKSTAGE_INVENTORY_QUERY 기준 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}</p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={search} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침</Button>
          <Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button>
        </div>
      </header>
      <Card className="shrink-0" padding="sm">
        <div className="flex flex-wrap items-center gap-3">
          <PartSelect labelPrefix="품목" value={itemCode} onChange={setItemCode} className="w-80" />
          <label className="flex h-10 items-center gap-2 whitespace-nowrap text-sm"><input type="checkbox" checked={includeZero} onChange={event => setIncludeZero(event.target.checked)} className="h-4 w-4 accent-primary" />0 재고 포함</label>
        </div>
      </Card>
      <div className="text-sm text-text-muted">공정재고 합계: <strong className="text-text">{inventoryQty.toLocaleString(undefined, { maximumFractionDigits: 6 })}</strong></div>
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3"><DataGrid data={rows} columns={workstageInventoryColumns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName="공정재고조회" emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 공정재고를 확인하세요.'} /></CardContent>
      </Card>
    </main>
  );
}
