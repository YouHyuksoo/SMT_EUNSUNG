"use client";

/**
 * @file src/app/(authenticated)/report/material-long-term/page.tsx
 * @description 자재장기재고리포트 — PB w_mat_long_term_inventory_report 이식
 *
 * 초보자 가이드:
 * 1. **오래 입고가 없는 재고를 찾는다.** 기간이 아니라 **기준일 + 개월수**다 —
 *    기준일에서 개월수를 거꾸로 세어 그보다 오래된 재고를 본다 (PB ADD_MONTHS).
 * 2. **경과일수를 함께 보여준다.** PB 는 마지막 입고일만 보여줘서 며칠인지
 *    직접 세어야 했다. 1년 넘으면 빨강, 6개월 넘으면 주황으로 보인다.
 * 3. **재고수량이 0 보다 큰 것만 본다** (PB 고정조건). 그 조건이 있어 가볍다
 *    (183만행 중 수량 > 0 은 3,540행 — 실측).
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateFilter from '@/components/shared/DateFilter';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { materialLongTermColumns } from '../report-b-columns';
import type { MaterialLongTermRow } from '../report-b-types';
import PartSearchField from '@/components/shared/PartSearchField';

const today = () => new Date().toISOString().slice(0, 10);

export default function MaterialLongTermPage() {
  const [baseDate, setBaseDate] = useState(today());
  const [termMonths, setTermMonths] = useState('6');
  const [itemCode, setItemCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');
  const [supplierCode, setSupplierCode] = useState('');

  const [rows, setRows] = useState<MaterialLongTermRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    const months = Number(termMonths);
    if (!months || months < 1) {
      toast.error('개월수를 1 이상 넣으세요.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/report/material-long-term', {
        params: {
          baseDate,
          termMonths: months,
          itemCode: itemCode || undefined,
          materialMfs: materialMfs || undefined,
          supplierCode: supplierCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      mark(response);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '장기재고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [baseDate, termMonths, itemCode, materialMfs, supplierCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const overYear = rows.filter((r) => Number(r.idleDays ?? 0) >= 365).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재장기재고리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          기준일에서 정한 개월수보다 오래 입고가 없는 재고를 봅니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건${overYear > 0 ? ` · 1년 이상 ${overYear.toLocaleString()}건` : ''}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="1년 이상 건수" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          {/* 기간이 아니라 기준일이다 — 여기서 개월수를 거꾸로 센다. */}
          <label className="flex items-center gap-2 text-sm text-text">
            기준일
            <DateFilter value={baseDate} onChange={setBaseDate} />
          </label>
          <label className="flex items-center gap-1 text-sm text-text">
            <Input aria-label="개월수" value={termMonths} className="w-16"
              onChange={(e) => setTermMonths(e.target.value.replace(/\D/g, ''))} />
            개월 이상 입고 없음
          </label>
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="자재 롯트" placeholder="자재 롯트" value={materialMfs} className="w-40"
            onChange={(e) => setMaterialMfs(e.target.value)} />
          <div className="w-52">
            <SupplierSelect includeAll value={supplierCode} onChange={setSupplierCode} />
          </div>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={materialLongTermColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재장기재고"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['itemCode'] }}
            emptyMessage={searched ? '조건에 맞는 장기재고가 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
