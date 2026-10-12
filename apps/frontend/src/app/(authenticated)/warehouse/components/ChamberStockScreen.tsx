"use client";

/**
 * @file src/app/(authenticated)/warehouse/components/ChamberStockScreen.tsx
 * @description 챔버 재고조회 화면 본체 — 262·263·264 가 함께 쓴다.
 *
 * 초보자 가이드:
 * 1. **세 화면이 같은 화면이다.** 베이킹실·진공포장·제습함의 PB DataWindow SQL 이
 *    글자까지 같고 `chamber_type` 인자만 'B'/'V'/'D' 로 다르다 (실측).
 *    그래서 화면도 하나로 만들고 각 라우트가 `chamberType` 만 넘긴다 —
 *    세 벌로 복제하면 한쪽만 고쳐진다.
 * 2. **마스터-디테일이다.** 위 표에서 (챔버, 품목) 묶음을 고르면 아래에 그 묶음의
 *    자재 하나하나가 뜬다. PB 도 그렇게 조회한다.
 * 3. **재고는 "넣었고 아직 안 꺼낸 것" 이다.** 지나간 이력은 안 나온다.
 * 4. **경과시간이 기준을 넘으면 빨갛게 보인다.** 기준은 품목의 베이킹시간이고
 *    없으면 수명을 쓴다. 넘긴 자재는 다시 베이킹해야 하므로 그게 이 화면의 목적이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  chamberStockDetailColumns,
  chamberStockSummaryColumns,
} from '../warehouse-columns';
import type {
  ChamberStockDetailRow,
  ChamberStockSummaryRow,
  ChamberType,
} from '../warehouse-types';
import PartSearchField from '@/components/shared/PartSearchField';

export function ChamberStockScreen({
  chamberType,
  title,
  description,
}: {
  chamberType: ChamberType;
  title: string;
  description: string;
}) {
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [chamberCode, setChamberCode] = useState('');

  const [summary, setSummary] = useState<ChamberStockSummaryRow[]>([]);
  const [detail, setDetail] = useState<ChamberStockDetailRow[]>([]);
  const [selected, setSelected] = useState<ChamberStockSummaryRow | null>(null);
  const [loading, setLoading] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    setSelected(null);
    setDetail([]);
    try {
      const response = await api.get('/warehouse/chamber-stock/summary', {
        params: {
          chamberType,
          itemCode: itemCode || undefined,
          lotNo: lotNo || undefined,
          chamberCode: chamberCode || undefined,
        },
      });
      setSummary(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '챔버 재고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [chamberType, itemCode, lotNo, chamberCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 묶음을 고르면 그 묶음의 자재 목록을 읽는다 (PB 마스터-디테일과 같다). */
  const loadDetail = useCallback(async (row: ChamberStockSummaryRow) => {
    setSelected(row);
    if (!row.chamberCode) {
      toast.error('이 묶음에는 챔버코드가 없어 상세를 조회할 수 없습니다.');
      return;
    }
    setDetailLoading(true);
    try {
      const response = await api.get('/warehouse/chamber-stock/detail', {
        params: {
          chamberType,
          itemCode: row.itemCode,
          chamberCode: row.chamberCode,
        },
      });
      setDetail(response.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '상세 조회에 실패했습니다.');
    } finally {
      setDetailLoading(false);
    }
  }, [chamberType]);

  const totalQty = summary.reduce((sum, r) => sum + Number(r.lotQty ?? 0), 0);
  const totalCount = summary.reduce((sum, r) => sum + Number(r.countNum ?? 0), 0);
  /** 기준 시간을 넘긴 묶음. 이 숫자가 이 화면을 보는 이유다. */
  const overLimit = summary.filter((r) => {
    const limit = Number(r.bakingTime ?? 0) > 0
      ? Number(r.bakingTime)
      : Number(r.lifeCycle ?? 0);
    return limit > 0 && Number(r.maxLapseHours ?? 0) >= limit;
  }).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">{title}</h1>
        <p className="mt-1 text-sm text-text-muted">
          {description} ·{' '}
          {searched
            ? `${summary.length}묶음 · ${totalCount}건 · 수량 ${totalQty.toLocaleString()}`
              + (overLimit > 0 ? ` · 기준시간 초과 ${overLimit}묶음` : '')
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="자재 롯트" placeholder="자재 롯트" value={lotNo} className="w-40"
            onChange={(e) => setLotNo(e.target.value)} />
          <Input aria-label="챔버코드" placeholder="챔버코드" value={chamberCode} className="w-36"
            onChange={(e) => setChamberCode(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            넣었고 아직 꺼내지 않은 자재만 나옵니다.
          </span>
        </CardContent>
      </Card>

      {/* 위: 챔버·품목 묶음 / 아래: 고른 묶음의 자재 목록 (PB 마스터-디테일) */}
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={summary}
            columns={chamberStockSummaryColumns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName={`${title}_묶음`}
            emptyMessage={searched
              ? '챔버에 들어 있는 자재가 없습니다.'
              : '조회하세요.'}
            onRowClick={(row) => void loadDetail(row as ChamberStockSummaryRow)}
            rowClassName={(row) => {
              const r = row as ChamberStockSummaryRow;
              return r.chamberCode === selected?.chamberCode
                && r.itemCode === selected?.itemCode
                ? 'bg-primary/10'
                : '';
            }}
          />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={detail}
            columns={chamberStockDetailColumns}
            isLoading={detailLoading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName={`${title}_상세`}
            enableColumnPinning
            defaultPinnedColumns={{ left: ['itemBarcode'] }}
            emptyMessage={selected
              ? '이 묶음에 자재가 없습니다.'
              : '위에서 묶음을 고르면 자재 목록이 나옵니다.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
