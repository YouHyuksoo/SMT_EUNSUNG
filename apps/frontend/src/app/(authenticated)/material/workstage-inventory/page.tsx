"use client";

import { useCallback, useMemo, useState } from 'react';
import { Boxes, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import PartSelect from '@/components/shared/PartSelect';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { workstageInventoryColumns, workstageProductColumns } from './columns';
import type { WorkstageInventoryRow, WorkstageProductRow } from './types';

type TabKey = 'material' | 'product';

export default function WorkstageInventoryPage() {
  const [rows, setRows] = useState<WorkstageInventoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [products, setProducts] = useState<WorkstageProductRow[]>([]);
  const [tab, setTab] = useState<TabKey>('material');
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [itemCode, setItemCode] = useState('');
  const [itemDivision, setItemDivision] = useState('');
  const [itemClass, setItemClass] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [includeZero, setIncludeZero] = useState(true);

  const search = useCallback(async () => {
    setLoading(true);
    const [material, product] = await Promise.allSettled([
      api.get('/material/workstage-inventory', {
        params: {
          limit: 5000,
          itemCode: itemCode || undefined,
          itemDivision: itemDivision || undefined,
          itemClass: itemClass || undefined,
          supplierCode: supplierCode || undefined,
          includeZero: includeZero ? 'Y' : 'N',
        },
      }),
      api.get('/material/workstage-inventory/products'),
    ]);
    setRows(material.status === 'fulfilled' ? material.value.data?.data ?? [] : []);
    setTotal(material.status === 'fulfilled' ? Number(material.value.data?.meta?.total ?? 0) : 0);
    setProducts(product.status === 'fulfilled' ? product.value.data?.data ?? [] : []);
    setSearched(true);
    setLoading(false);
  }, [includeZero, itemClass, itemCode, itemDivision, supplierCode]);

  const inventoryQty = useMemo(() => rows.reduce((sum, row) => sum + Number(row.inventoryQty ?? 0), 0), [rows]);
  const productSummary = useMemo(() => products.reduce((acc, row) => ({
    boxes: acc.boxes + Number(row.boxCount ?? 0),
    qty: acc.qty + Number(row.packQty ?? 0),
  }), { boxes: 0, qty: 0 }), [products]);

  return (
    <main className="flex h-full min-w-0 flex-col gap-3 p-5">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text"><Boxes className="h-6 w-6 text-primary" />공정재고조회</h1>
          <p className="mt-1 text-sm text-text-muted">품목별 공정재고(재공) 수량을 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}</p>
        </div>
        <div className="flex gap-2">
          <Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button>
        </div>
      </header>
      <ScreenTabs
        tabs={[
          { key: 'material' as TabKey, label: '자재', count: rows.length, tooltip: '공정재고 장부. 공정으로 출고된 자재의 남은 수량' },
          { key: 'product' as TabKey, label: '제품(미입고 박스)', count: products.length, tooltip: '포장했지만 제품창고에 입고 안 한 박스 (2026-10-01 이후 포장)' },
        ]}
        active={tab}
        onChange={setTab}
      />
      {tab === 'material' && <>
      <Card className="shrink-0" padding="sm">
        <div className="flex flex-wrap items-center gap-3">
          <PartSelect labelPrefix="품목" value={itemCode} onChange={setItemCode} className="w-80" />
          <ComCodeSelect groupCode="ITEM DIVISION" labelPrefix="품목구분" value={itemDivision} onChange={setItemDivision} className="w-40" />
          <ComCodeSelect groupCode="ITEM CLASS" labelPrefix="품목분류" value={itemClass} onChange={setItemClass} className="w-48" />
          <SupplierSelect includeAll labelPrefix="공급상" value={supplierCode} onChange={setSupplierCode} className="w-56" />
          <label className="flex h-10 items-center gap-2 whitespace-nowrap text-sm"><input type="checkbox" checked={includeZero} onChange={event => setIncludeZero(event.target.checked)} className="h-4 w-4 accent-primary" />0 재고 포함</label>
        </div>
      </Card>
      <div className="text-sm text-text-muted">공정재고 합계: <strong className="text-text">{inventoryQty.toLocaleString(undefined, { maximumFractionDigits: 6 })}</strong></div>
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3"><DataGrid data={rows} columns={workstageInventoryColumns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName="공정재고조회" emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 공정재고를 확인하세요.'} /></CardContent>
      </Card>
      </>}
      {tab === 'product' && <>
      <div className="flex flex-wrap gap-x-4 gap-y-1 text-sm text-text-muted">
        <span>박스 합계: <strong className="text-text">{productSummary.boxes.toLocaleString()}</strong></span>
        <span>포장수량 합계: <strong className="text-text">{productSummary.qty.toLocaleString()}</strong></span>
        <span>이 제품에 들어간 자재는 제품창고에 입고될 때 공정재고에서 빠지므로, 지금은 자재 탭 수량에 포함돼 있습니다.</span>
      </div>
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3"><DataGrid data={products} columns={workstageProductColumns} isLoading={loading} pageSize={50} enableColumnFilter enableExport exportFileName="공정재고조회_미입고박스" emptyMessage={searched ? '미입고 박스가 없습니다.' : '조회 버튼을 눌러 공정에 있는 제품을 확인하세요.'} /></CardContent>
      </Card>
      </>}
    </main>
  );
}
