"use client";

/**
 * @file src/app/(authenticated)/report/line-barcode/page.tsx
 * @description 라인설비바코드 — PB w_pln_line_barcode_rpt 이식
 *
 * 초보자 가이드:
 * 1. **설비에 붙이는 바코드 라벨 목록이다.** 작업자가 PDA 로 설비를 찍을 때 쓰는
 *    그 바코드다.
 * 2. **라벨 지오메트리(용지 크기·바코드 배치)는 옮기지 않았다.** 값을 CSV 로 내보내
 *    라벨 소프트웨어가 찍는다 — 웹 브라우저 인쇄로는 라벨 프린터 정밀도가 안 나온다.
 * 3. **PB 의 `dw_1.update()` 는 무동작이었다** (갱신 대상 테이블이 지정돼 있지 않고
 *    update=yes 컬럼도 line_code 하나뿐 — 실측). 그래서 조회 전용으로 옮겼다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { lineBarcodeColumns } from '../report-columns';
import type { LineBarcodeRow } from '../report-types';

export default function LineBarcodeReportPage() {
  const [lineCode, setLineCode] = useState('');
  const [machine, setMachine] = useState('');

  const [rows, setRows] = useState<LineBarcodeRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/line-barcode', {
        params: {
          lineCode: lineCode || undefined,
          machine: machine || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '라인설비바코드 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, machine]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">라인설비바코드</h1>
        <p className="mt-1 text-sm text-text-muted">
          설비 라벨에 찍는 바코드 값을 뽑습니다 (라벨 인쇄는 CSV 로 내보내 라벨
          소프트웨어가 합니다) · {searched ? `${rows.length}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <div className="w-48">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Input aria-label="설비" placeholder="설비" value={machine} className="w-40"
            onChange={(e) => setMachine(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={lineBarcodeColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="라인설비바코드"
            emptyMessage={searched ? '조건에 맞는 설비가 없습니다.' : '조회하세요.'}
            getRowId={(row) => (row as LineBarcodeRow).barcodeText}
          />
        </CardContent>
      </Card>
    </div>
  );
}
