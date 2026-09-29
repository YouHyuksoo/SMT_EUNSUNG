"use client";

/**
 * @file src/app/(authenticated)/query/pcb-input/page.tsx
 * @description PCB 투입 리스트조회 — PB w_qc_pcb_input_scan_master 이식
 *
 * 초보자 가이드:
 * 1. **라인에 투입된 생 PCB 를 언제 누가 스캔했는지 본다.** PCB 는 코팅 유효기간이
 *    있어 '언제 코팅했고 며칠 지났나' 가 중요하다.
 * 2. **순수 조회 화면이다.** PB 에도 저장 동작이 없다 (실측).
 * 3. **스캔일 기간을 필수로 넣었다.** PB 원본에는 날짜 조건이 없었는데, 계속 쌓이는
 *    표라 전체 조회는 화면이 못 버틴다.
 * 4. **제조주차는 자재 바코드에서 가져온다.** 매칭이 없어도 행이 빠지지 않게
 *    외부조인을 유지했다 (조건을 NVL 로 감싼 이유다).
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { pcbInputColumns } from '../query-columns';
import type { PcbInputRow } from '../query-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function PcbInputQueryPage() {
  const [runNo, setRunNo] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [itemBarcode, setItemBarcode] = useState('');
  const [manufactureWeek, setManufactureWeek] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));

  const [rows, setRows] = useState<PcbInputRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/query/pcb-input', {
        params: {
          runNo: runNo || undefined,
          lineCode: lineCode || undefined,
          modelName: modelName || undefined,
          itemCode: itemCode || undefined,
          itemBarcode: itemBarcode || undefined,
          manufactureWeek: manufactureWeek || undefined,
          dateFrom,
          dateTo,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'PCB 투입 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [runNo, lineCode, modelName, itemCode, itemBarcode, manufactureWeek, dateFrom, dateTo]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const totalQty = rows.reduce((sum, r) => sum + Number(r.lotQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">PCB 투입 리스트조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          라인에 투입된 생 PCB 의 스캔 기록과 코팅 이력을 봅니다 ·{' '}
          {searched ? `${rows.length}건 · 수량 합계 ${totalQty.toLocaleString()}` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="Run No" placeholder="Run No" value={runNo} className="w-36"
            onChange={(e) => setRunNo(e.target.value)} />
          <div className="w-40">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName} className="w-36"
            onChange={(v) => setModelName(v)} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-36"
            onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="PCB 바코드" placeholder="PCB 바코드" value={itemBarcode}
            className="w-44" onChange={(e) => setItemBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="제조주차" placeholder="제조주차" value={manufactureWeek}
            className="w-28" onChange={(e) => setManufactureWeek(e.target.value)} />
          <DateRangeFilter label="스캔일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={pcbInputColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="PCB투입리스트"
            emptyMessage={searched ? '이 조건에 PCB 투입 기록이 없습니다.' : '조회하세요.'}
            getRowId={(row) => {
              const r = row as PcbInputRow;
              return [r.pcbBarcode, r.scanDate, r.runNo].join('|');
            }}
          />
        </CardContent>
      </Card>
    </div>
  );
}
