"use client";

/**
 * @file src/app/(authenticated)/report/workstage-stock/page.tsx
 * @description 공정재공조회 — PB w_product_workstage_stock_rpt 이식
 *
 * 초보자 가이드:
 * 1. **공정마다 몇 장이 남아 있나(재공)를 본다.** 라인·공정·모델별 스냅샷이다.
 * 2. **이 표는 현재 0행이다** (IP_PRODUCT_WORKSTAGE_INV 실측 0건). 화면이 비어
 *    보이는 것은 조건이 틀린 게 아니라 은성이 아직 공정재공을 쌓지 않기 때문이다.
 * 3. **음수 재공은 기본으로 감춘다.** PB `SIGN(qty) >= :arg_sign` 을 그대로 옮겼다.
 *    음수는 입출고가 어긋난 자리라 따로 찾아볼 때만 켠다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { workstageStockColumns } from '../report-columns';
import type { WorkstageStockRow } from '../report-types';

export default function WorkstageStockReportPage() {
  const [modelName, setModelName] = useState('');
  const [modelSuffix, setModelSuffix] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [includeNegative, setIncludeNegative] = useState(false);

  const [rows, setRows] = useState<WorkstageStockRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/workstage-stock', {
        params: {
          modelName: modelName || undefined,
          modelSuffix: modelSuffix || undefined,
          workstageCode: workstageCode || undefined,
          // PB 의 arg_sign 그대로다. -1 이면 음수까지 전부, 0 이면 0 이상만.
          sign: includeNegative ? -1 : 0,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '공정재공 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, modelSuffix, workstageCode, includeNegative]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const totalQty = rows.reduce((sum, r) => sum + Number(r.inventoryQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">공정재공조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          라인·공정·모델별 재공수량을 봅니다 ·{' '}
          {searched
            ? `${rows.length}건 · 재공 합계 ${totalQty.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="모델명" placeholder="모델명" value={modelName} className="w-44"
            onChange={(e) => setModelName(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="모델 SFX" placeholder="모델 SFX" value={modelSuffix} className="w-32"
            onChange={(e) => setModelSuffix(e.target.value)} />
          <div className="w-56">
            <ProcessSelect value={workstageCode} onChange={setWorkstageCode}
              labelPrefix="공정" fullWidth />
          </div>
          <label className="flex items-center gap-2 text-sm text-text">
            <input type="checkbox" checked={includeNegative}
              onChange={(e) => setIncludeNegative(e.target.checked)} />
            음수 재공까지 보기
          </label>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={workstageStockColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="공정재공"
            emptyMessage={searched
              ? '공정재공이 없습니다 (이 표는 현재 비어 있습니다).'
              : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
