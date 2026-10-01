"use client";

/**
 * @file src/app/(authenticated)/inventory-query/total-inventory/page.tsx
 * @description 총재고조회 — PB w_mat_total_inventory_query 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **한 품목이 지금 어디에 얼마나 있는지 한 줄로 보는 화면이다.** 재고는 네 군데에
 *    흩어져 있다 — 자재창고 · 공정(라인) · 조립품 · 완제품.
 * 2. **품목을 고르면 아래에 상세가 나온다.** 어느 자리에 있는지(창고·라인)와
 *    롯트별로 얼마인지를 함께 본다.
 * 3. **전체를 조회하면 6초쯤 걸린다.** 품목 2,560건마다 재고 함수를 네 번씩 부르기
 *    때문이고 PB 도 같다. **품목분류나 구분으로 좁히면 빨라진다.**
 * 4. 상세에서 **수량이 0 인 자리는 빠진다** — 재고표가 183만 행이라 0 을 빼지 않으면
 *    쓸 수 없다.
 */
import { useCallback, useState } from 'react';
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
  inventoryByLocationColumns,
  inventoryByLotColumns,
  totalInventoryColumns,
} from '../inventory-query-columns';
import type {
  InventoryByLocationRow,
  InventoryByLotRow,
  TotalInventoryRow,
} from '../inventory-query-columns';
import PartSearchField from '@/components/shared/PartSearchField';

type DetailTab = 'location' | 'lot';

export default function TotalInventoryPage() {
  const [itemCode, setItemCode] = useState('');
  const [itemClass, setItemClass] = useState('');
  const [itemDivision, setItemDivision] = useState('');

  const [rows, setRows] = useState<TotalInventoryRow[]>([]);
  const [selected, setSelected] = useState<TotalInventoryRow | null>(null);
  const [byLocation, setByLocation] = useState<InventoryByLocationRow[]>([]);
  const [byLot, setByLot] = useState<InventoryByLotRow[]>([]);
  const [detailTab, setDetailTab] = useState<DetailTab>('location');
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const narrowed = [itemCode, itemClass, itemDivision]
    .some((v) => v.trim().length > 0);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/inventory-query/total', {
        params: {
          itemCode: itemCode || undefined,
          itemClass: itemClass || undefined,
          itemDivision: itemDivision || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      setSelected(null);
      setByLocation([]);
      setByLot([]);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [itemCode, itemClass, itemDivision, mark]);

  /** 품목을 고르면 자리별·롯트별 상세를 함께 가져온다. */
  const pick = useCallback(async (row: TotalInventoryRow) => {
    setSelected(row);
    try {
      const [loc, lot] = await Promise.all([
        api.get('/inventory-query/total/by-location', {
          params: { itemCode: row.itemCode },
        }),
        api.get('/inventory-query/total/by-lot', {
          params: { itemCode: row.itemCode },
        }),
      ]);
      setByLocation(loc.data?.data ?? []);
      setByLot(lot.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '상세 조회에 실패했습니다.');
      setByLocation([]);
      setByLot([]);
    }
  }, []);

  const withStock = rows.filter((r) => Number(r.totalQty ?? 0) !== 0).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">총재고조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재창고·공정·조립품·완제품 네 군데 재고를 한 줄로 봅니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}품목 · 재고 있음 ${withStock.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="품목분류" placeholder="품목분류" value={itemClass}
            className="w-36"
            onChange={(e) => setItemClass(e.target.value)} />
          <Input aria-label="품목구분" placeholder="품목구분" value={itemDivision}
            className="w-36"
            onChange={(e) => setItemDivision(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {!narrowed && (
            <span className="text-sm text-text-muted">
              조건 없이 전체를 보면 6초쯤 걸립니다 — 품목분류나 구분으로 좁히면
              빨라집니다.
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-rows-[1.4fr_1fr]">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={rows}
              columns={totalInventoryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="총재고"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['itemCode'] }}
              emptyMessage={searched ? '조건에 맞는 품목이 없습니다.' : '조회하세요.'}
              onRowClick={(row) => void pick(row as TotalInventoryRow)}
            />
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <div className="flex items-center gap-3">
              <ScreenTabs
                tabs={[
                  { key: 'location' as DetailTab, label: '자리별', count: byLocation.length },
                  { key: 'lot' as DetailTab, label: '롯트별', count: byLot.length },
                ]}
                active={detailTab}
                onChange={setDetailTab}
              />
              {selected && (
                <span className="text-sm text-text-muted">
                  {selected.itemCode} {selected.itemName ?? ''} · 총{' '}
                  {Number(selected.totalQty ?? 0).toLocaleString()}
                </span>
              )}
            </div>
            <div className="min-h-0 flex-1">
              {detailTab === 'location' ? (
                <DataGrid
                  data={byLocation}
                  columns={inventoryByLocationColumns}
                  pageSize={50}
                  enableExport
                  exportFileName="총재고_자리별"
                  emptyMessage={selected
                    ? '이 품목은 재고가 있는 자리가 없습니다.'
                    : '위에서 품목을 고르세요.'}
                />
              ) : (
                <DataGrid
                  data={byLot}
                  columns={inventoryByLotColumns}
                  pageSize={50}
                  enableExport
                  exportFileName="총재고_롯트별"
                  emptyMessage={selected
                    ? '이 품목은 롯트 재고가 없습니다.'
                    : '위에서 품목을 고르세요.'}
                />
              )}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
