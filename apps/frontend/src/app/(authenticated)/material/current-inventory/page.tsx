"use client";

import { useCallback, useMemo, useState } from 'react';
import { ClipboardList, RefreshCw, Search } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { currentInventoryColumns } from './columns';
import type { CurrentInventoryRow } from './types';

export default function CurrentInventoryPage() {
  const [rows, setRows] = useState<CurrentInventoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [itemCode, setItemCode] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [lineType, setLineType] = useState('');
  const [inventoryStatus, setInventoryStatus] = useState('');
  const [inventoryHold, setInventoryHold] = useState('');
  const [includeZero, setIncludeZero] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/material/current-inventory', {
        params: {
          limit: '5000',
          itemCode: itemCode || undefined,
          locationCode: locationCode || undefined,
          lineType: lineType || undefined,
          inventoryStatus: inventoryStatus || undefined,
          inventoryHold: inventoryHold || undefined,
          includeZero: includeZero ? 'Y' : 'N',
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? response.data?.total ?? 0));
      setSearched(true);
    } catch {
      setRows([]);
      setTotal(0);
    } finally {
      setLoading(false);
    }
  }, [includeZero, inventoryHold, inventoryStatus, itemCode, lineType, locationCode]);

  const summary = useMemo(() => rows.reduce((acc, row) => ({
    qty: acc.qty + Number(row.inventoryQty ?? 0),
    amount: acc.amount + Number(row.inventoryAmt ?? 0),
  }), { qty: 0, amount: 0 }), [rows]);

  return (
    <main className="flex h-full min-w-0 flex-col gap-3 p-5">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ClipboardList className="h-6 w-6 text-primary" />현재고조회
          </h1>
          <p className="mt-1 text-sm text-text-muted">PB DataWindow d_mat_current_inventory_detail_lst 기준 · {searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}</p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={search} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침</Button>
          <Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button>
        </div>
      </header>
      <Card className="shrink-0" padding="sm">
        <div className="flex flex-wrap items-center gap-2">
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} onChange={e => setItemCode(e.target.value)} className="w-40" />
          <Input aria-label="로케이션" placeholder="로케이션" value={locationCode} onChange={e => setLocationCode(e.target.value)} className="w-36" />
          <Input aria-label="라인유형" placeholder="라인유형" value={lineType} onChange={e => setLineType(e.target.value)} className="w-32" />
          <Input aria-label="재고상태" placeholder="재고상태" value={inventoryStatus} onChange={e => setInventoryStatus(e.target.value)} className="w-32" />
          <Input aria-label="보류" placeholder="보류(Y/N)" value={inventoryHold} onChange={e => setInventoryHold(e.target.value)} className="w-28" />
          <label className="flex h-10 items-center gap-2 whitespace-nowrap text-sm"><input type="checkbox" checked={includeZero} onChange={e => setIncludeZero(e.target.checked)} className="h-4 w-4 accent-primary" />0 재고 포함</label>
        </div>
      </Card>
      <div className="flex gap-4 text-sm text-text-muted"><span>현재고 합계: <strong className="text-text">{summary.qty.toLocaleString()}</strong></span><span>재고금액 합계: <strong className="text-text">{summary.amount.toLocaleString(undefined, { minimumFractionDigits: 2 })}</strong></span></div>
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3"><DataGrid data={rows} columns={currentInventoryColumns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName="현재고조회" emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 현재고를 확인하세요.'} /></CardContent>
      </Card>
    </main>
  );
}
