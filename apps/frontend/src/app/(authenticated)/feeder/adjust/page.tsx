"use client";

/**
 * @file src/app/(authenticated)/feeder/adjust/page.tsx
 * @description 피더교정관리 — PB w_mcn_jig_feeder_adjust_master 이식
 *
 * 초보자 가이드:
 * 1. **스캔 1회 = 교정 등록**. PB 도 바코드 modified 이벤트에서 바로 INSERT 한다.
 *    현장 스캐너는 키보드 방식이라 Enter 핸들러 하나면 된다.
 * 2. 교정항번은 SEQ_FEEDER_ADJUST_SEQUENCE 로 채번한다(PKG_MES_MAC.SP_FEEDER_ADJUST_SCAN).
 * 3. PB 는 스캔 시 JIG_TYPE 조건을 걸지 않는다 — 지그LOT 만으로 찾는다. 그대로 옮겼다.
 */
import { useCallback, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { ScanLine, Search, Settings2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { feederAdjustColumns, type FeederAdjustRow } from './columns';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function FeederAdjustPage() {
  const scanRef = useRef<HTMLInputElement>(null);
  const [rows, setRows] = useState<FeederAdjustRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [jigCode, setJigCode] = useState('');
  const [jigLotNo, setJigLotNo] = useState('');

  const [barcode, setBarcode] = useState('');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/feeder-adjust', {
        params: {
          dateFrom,
          dateTo,
          jigCode: jigCode || undefined,
          jigLotNo: jigLotNo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('피더교정 이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, jigCode, jigLotNo]);

  const registerScan = useCallback(async () => {
    const value = barcode.trim();
    if (!value || busy) return;
    setBusy(true);
    try {
      const response = await api.post('/jig/feeder-adjust/scan', {
        jigLotNo: value,
        comments: comments || undefined,
      });
      toast.success(`${value} 교정 ${response.data?.data?.adjustSequence ?? ''}번 등록`);
      void search();
    } catch {
      toast.error('등록되지 않은 피더 바코드입니다.');
    } finally {
      setBusy(false);
      setBarcode('');
      scanRef.current?.focus();
    }
  }, [barcode, busy, comments, search]);

  const columns = useMemo(() => feederAdjustColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Settings2 className="h-6 w-6 text-primary" />피더교정관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            피더 교정 이력을 바코드 스캔으로 등록하고 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <div className="flex items-center gap-2">
            <ScanLine className="h-5 w-5 text-primary" />
            <span className="text-sm font-semibold text-text">피더 바코드 스캔</span>
          </div>
          <Input
            ref={scanRef}
            autoFocus
            placeholder="바코드를 스캔하세요"
            value={barcode}
            disabled={busy}
            className="w-64"
            onChange={(event) => setBarcode(event.target.value)}
            onKeyDown={(event) => { if (event.key === 'Enter') void registerScan(); }}
          />
          <Input
            placeholder="교정 설명 (선택)"
            value={comments}
            className="w-64"
            onChange={(event) => setComments(event.target.value)}
          />
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="교정일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input placeholder="피더코드" value={jigCode} className="w-44"
            onChange={(e) => setJigCode(e.target.value)} />
          <Input placeholder="피더LOT" value={jigLotNo} className="w-44"
            onChange={(e) => setJigLotNo(e.target.value)} />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid data={rows} columns={columns} isLoading={loading} pageSize={50}
            enableColumnFilter enableExport exportFileName="피더교정"
            emptyMessage="조회 버튼을 눌러 교정이력을 확인하세요." />
        </CardContent>
      </Card>
    </div>
  );
}
