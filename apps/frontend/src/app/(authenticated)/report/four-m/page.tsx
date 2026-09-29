"use client";

/**
 * @file src/app/(authenticated)/report/four-m/page.tsx
 * @description 4M 변경이력 — PB w_qc_4m_history_rpt 이식
 *
 * 초보자 가이드:
 * 1. **모델의 H/W·S/W 버전을 본다.** 4M(사람·설비·자재·방법) 중 방법 변경의
 *    근거로 쓰는 버전 기록이다.
 * 2. **PB 는 모델명을 정확히 입력해야 했다** (등호 조건). 모델 마스터가 327건뿐이라
 *    앞부분 일치로 넓혔다 — 모델명을 모르면 아무것도 못 보는 불편을 없앴다.
 * 3. **S/W 두 칸은 항상 비어 있다.** 원천 표(IP_PRODUCT_SOFTWARE_MASTER)가
 *    0행이기 때문이다 (실측). 조건이 틀린 게 아니라 S/W 업로드 기록이 없다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { fourMHistoryColumns } from '../report-b-columns';
import type { FourMHistoryRow } from '../report-b-types';

export default function FourMHistoryPage() {
  const [modelName, setModelName] = useState('');
  const [modelSuffix, setModelSuffix] = useState('');

  const [rows, setRows] = useState<FourMHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/four-m', {
        params: {
          modelName: modelName || undefined,
          modelSuffix: modelSuffix || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      mark(response);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '4M 변경이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, modelSuffix]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">4M 변경이력</h1>
        <p className="mt-1 text-sm text-text-muted">
          모델별 H/W·S/W 버전을 봅니다 (S/W 기록은 아직 쌓이지 않았습니다) ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="모델명" placeholder="모델명" value={modelName} className="w-48"
            onChange={(e) => setModelName(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="모델 SFX" placeholder="모델 SFX" value={modelSuffix} className="w-36"
            onChange={(e) => setModelSuffix(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={fourMHistoryColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="4M변경이력"
            emptyMessage={searched ? '조건에 맞는 모델이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
