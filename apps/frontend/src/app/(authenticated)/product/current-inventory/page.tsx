"use client";

import { useCallback, useMemo, useState } from 'react';
import { Boxes, RefreshCw, Search } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { productInventoryColumns } from './columns';
import type { ProductInventoryRow } from './types';

export default function ProductInventoryPage() {
  const [rows, setRows] = useState<ProductInventoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [qtyTotal, setQtyTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [model, setModel] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [packType, setPackType] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/product/current-inventory', {
        params: { limit: '5000', model: model || undefined, locationCode: locationCode || undefined, packType: packType || undefined },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setQtyTotal((response.data?.data ?? []).reduce((sum: number, row: ProductInventoryRow) => sum + Number(row.qty ?? 0), 0));
      setSearched(true);
    } catch {
      setRows([]);
      setTotal(0);
      setQtyTotal(0);
    } finally {
      setLoading(false);
    }
  }, [locationCode, model, packType]);

  const columns = useMemo(() => productInventoryColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-3 p-5">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text"><Boxes className="h-6 w-6 text-primary" />제품재고조회</h1>
          <p className="mt-1 text-sm text-text-muted">PB DataWindow d_product_fg_inventory_lst 기준 · {searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}</p>
        </div>
        <div className="flex gap-2"><Button variant="secondary" size="sm" onClick={search} disabled={loading}><RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침</Button><Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button></div>
      </header>
      <Card className="shrink-0" padding="sm"><div className="flex flex-wrap items-center gap-2"><Input aria-label="모델명" placeholder="모델명" value={model} onChange={e => setModel(e.target.value)} className="w-52" /><Input aria-label="제품로케이션" placeholder="제품로케이션" value={locationCode} onChange={e => setLocationCode(e.target.value)} className="w-40" /><Input aria-label="포장유형" placeholder="포장유형" value={packType} onChange={e => setPackType(e.target.value)} className="w-32" /></div></Card>
      <div className="flex gap-4 text-sm text-text-muted"><span>제품재고 합계: <strong className="text-text">{qtyTotal.toLocaleString()}</strong></span><span>조회 건수: <strong className="text-text">{total.toLocaleString()}</strong></span></div>
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none"><CardContent className="h-full p-3"><DataGrid data={rows} columns={columns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName="제품재고조회" emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 제품재고를 확인하세요.'} /></CardContent></Card>
    </main>
  );
}
