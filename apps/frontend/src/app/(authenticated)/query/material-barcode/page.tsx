"use client";

/**
 * @file src/app/(authenticated)/query/material-barcode/page.tsx
 * @description 자재 바코드 상태 조회 — PB w_mat_barcode_status_report 이식
 *
 * 초보자 가이드:
 * 1. **자재 바코드 한 줄의 현재 상태를 본다.** 입고대조·출고대조가 됐는지,
 *    홀딩·반품·릴폐기 상태인지, MSL 경과가 얼마인지 한 줄에 다 있다.
 * 2. **조건 하나는 반드시 넣어야 한다.** 품목코드 · 제조번호 · 바코드 중 하나다.
 *    이 표는 193만행이고 조건 없이 열면 21초가 걸려 상한에서 잘린다 (실측) —
 *    그건 조회가 아니라 사고다. 세 조건 모두 인덱스가 있다.
 * 3. **순수 조회 화면이다.** PB 에도 저장 동작이 없다 (실측).
 * 4. **홀딩·릴폐기가 'Y' 면 빨갛게 보인다.** 그 자재는 쓸 수 없다는 뜻이다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { materialBarcodeColumns } from '../query-columns';
import type { MaterialBarcodeRow } from '../query-types';
import PartSearchField from '@/components/shared/PartSearchField';

export default function MaterialBarcodeQueryPage() {
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [itemBarcode, setItemBarcode] = useState('');

  const [rows, setRows] = useState<MaterialBarcodeRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const hasFilter = Boolean(itemCode || lotNo || itemBarcode);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/query/material-barcode', {
        params: {
          itemCode: itemCode || undefined,
          lotNo: lotNo || undefined,
          itemBarcode: itemBarcode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      mark(response);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재 바코드 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [itemCode, lotNo, itemBarcode, mark]);

  const holdCount = rows.filter(
    (r) => r.holdingYn === 'Y' || r.reelDestroyYn === 'Y',
  ).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재 바코드 상태 조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 바코드의 입출고 대조·홀딩·릴폐기·MSL 경과를 봅니다 ·{' '}
          {searched ? `${rows.length}건` : '조건을 넣고 조회하세요'}
          {holdCount > 0 && (
            <span className="ml-1 text-red-500">· 홀딩·폐기 {holdCount}건</span>
          )}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-44"
            onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="제조번호" placeholder="제조번호" value={lotNo} className="w-44"
            onChange={(e) => setLotNo(e.target.value)} />
          <Input aria-label="자재 바코드" placeholder="자재 바코드" value={itemBarcode}
            className="w-52" autoFocus
            onChange={(e) => setItemBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter' && hasFilter) void search(); }} />
          <Button size="sm" onClick={search} disabled={!hasFilter || loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {!hasFilter && (
            <span className="text-sm text-amber-500">
              품목코드 · 제조번호 · 자재 바코드 중 하나를 입력하세요
              (표가 193만행이라 조건 없이는 열 수 없습니다).
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={materialBarcodeColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재바코드상태"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['itemBarcode'] }}
            emptyMessage={searched ? '조건에 맞는 자재 바코드가 없습니다.' : '조건을 넣고 조회하세요.'}
            rowClassName={(row) => {
              const r = row as MaterialBarcodeRow;
              return r.holdingYn === 'Y' || r.reelDestroyYn === 'Y' ? 'bg-red-500/5' : '';
            }}
            getRowId={(row) => (row as MaterialBarcodeRow).itemBarcode}
          />
        </CardContent>
      </Card>
    </div>
  );
}
