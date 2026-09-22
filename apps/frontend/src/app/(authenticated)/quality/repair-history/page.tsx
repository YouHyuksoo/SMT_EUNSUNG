"use client";

/**
 * @file src/app/(authenticated)/quality/repair-history/page.tsx
 * @description 공정수리이력조회 — PB w_pln_product_pcb_repair_master 의 dw_3("Repair History") 이식
 *
 * 초보자 가이드:
 * 1. 조회 전용 화면이다. PB master 화면의 수리접수·저장·출고(DML)는 여기 없다.
 * 2. 코드성 조건은 ComCodeSelect(ISYS_BASECODE) 로 고르고, 자유 입력은 시리얼/모델뿐이다.
 * 3. TAT 는 QC 등록 후 경과 시간(시간 단위)으로, SQL 에서 계산해 내려온다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { RefreshCw, Search, Wrench } from 'lucide-react';
import { Button, Card, CardContent, Input } from '@/components/ui';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { repairHistoryColumns } from './columns';
import type { RepairHistoryRow } from './types';

const today = () => new Date().toISOString().slice(0, 10);
const monthAgo = () => {
  const d = new Date();
  d.setMonth(d.getMonth() - 1);
  return d.toISOString().slice(0, 10);
};

export default function RepairHistoryPage() {
  const [rows, setRows] = useState<RepairHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [serialNo, setSerialNo] = useState('');
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [receiptDeficit, setReceiptDeficit] = useState('');
  const [inspectHandling, setInspectHandling] = useState('');
  const [repairResultCode, setRepairResultCode] = useState('');
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/repair-history', {
        params: {
          limit: '5000',
          serialNo: serialNo || undefined,
          modelName: modelName || undefined,
          lineCode: lineCode || undefined,
          workstageCode: workstageCode || undefined,
          receiptDeficit: receiptDeficit || undefined,
          inspectHandling: inspectHandling || undefined,
          repairResultCode: repairResultCode || undefined,
          dateFrom: dateFrom || undefined,
          dateTo: dateTo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? response.data?.total ?? 0));
      setSearched(true);
    } catch {
      setRows([]);
      setTotal(0);
      toast.error('수리이력 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, inspectHandling, lineCode, modelName, receiptDeficit, repairResultCode, serialNo, workstageCode]);

  const summary = useMemo(() => {
    const repaired = rows.filter(row => row.repairResultCode === 'G').length;
    const pending = rows.filter(row => !row.repairResultCode).length;
    const badQty = rows.reduce((acc, row) => acc + Number(row.badQty ?? 0), 0);
    return { repaired, pending, badQty };
  }, [rows]);

  return (
    <main className="flex h-full min-w-0 flex-col gap-3 p-5">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Wrench className="h-6 w-6 text-primary" />공정수리이력조회
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            PB w_pln_product_pcb_repair_master · Repair History 기준 · {searched ? `${rows.length}/${total}건` : '조회조건을 입력하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={search} disabled={loading}>
            <RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침
          </Button>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
      </header>

      <Card className="shrink-0" padding="sm">
        <div className="flex flex-wrap items-center gap-2">
          <Input aria-label="PCB 시리얼" placeholder="PCB 시리얼" value={serialNo} onChange={e => setSerialNo(e.target.value)} className="w-44" />
          <Input aria-label="모델명" placeholder="모델명" value={modelName} onChange={e => setModelName(e.target.value)} className="w-40" />
          <LineSelect aria-label="라인" labelPrefix="라인" value={lineCode} onChange={value => setLineCode(value)} className="w-40" />
          <ProcessSelect aria-label="공정" labelPrefix="공정" value={workstageCode} onChange={value => setWorkstageCode(value)} className="w-44" />
          <ComCodeSelect groupCode="RECEIPT DEFICIT" labelPrefix="불량구분" aria-label="불량구분" value={receiptDeficit} onChange={value => setReceiptDeficit(value)} className="w-40" />
          <ComCodeSelect groupCode="QC INSPECT HANDLING" labelPrefix="검사처리" aria-label="검사처리" value={inspectHandling} onChange={value => setInspectHandling(value)} className="w-40" />
          <ComCodeSelect groupCode="REPAIR RESULT CODE" labelPrefix="수리결과" aria-label="수리결과" value={repairResultCode} onChange={value => setRepairResultCode(value)} className="w-40" />
          <label className="flex items-center gap-1 whitespace-nowrap text-sm text-text-muted">
            QC일자
            <Input aria-label="QC일자 시작" type="date" value={dateFrom} onChange={e => setDateFrom(e.target.value)} className="w-40" />
            ~
            <Input aria-label="QC일자 종료" type="date" value={dateTo} onChange={e => setDateTo(e.target.value)} className="w-40" />
          </label>
        </div>
      </Card>

      <div className="flex gap-4 text-sm text-text-muted">
        <span>수리완료(G): <strong className="text-text">{summary.repaired.toLocaleString()}</strong></span>
        <span>미수리: <strong className="text-text">{summary.pending.toLocaleString()}</strong></span>
        <span>불량수량 합계: <strong className="text-text">{summary.badQty.toLocaleString()}</strong></span>
      </div>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={repairHistoryColumns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="공정수리이력조회"
            emptyMessage={searched ? '조회 결과가 없습니다.' : '조회 버튼을 눌러 수리이력을 확인하세요.'}
          />
        </CardContent>
      </Card>
    </main>
  );
}
