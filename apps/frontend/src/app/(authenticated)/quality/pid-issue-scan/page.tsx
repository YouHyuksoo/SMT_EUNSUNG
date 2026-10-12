"use client";

/**
 * @file src/app/(authenticated)/quality/pid-issue-scan/page.tsx
 * @description PCB 이슈발생스캔관리 — PB w_pln_product_pid_issue_scan_master 이식
 *
 * 초보자 가이드:
 * 1. **이 화면은 `IP_PRODUCT_ISSUE_PID_SCAN` 만 본다** — 1억 8천만 행짜리 제품바코드와
 *    다른 테이블이라 기간 조회로 충분하다.
 * 2. PID 를 넣으면 그 PID 의 스캔 내역만 따로 본다 (PB 도 등호 조건이었다).
 * 3. **이 DB 에서 이 테이블은 0행이다** — 은성에서 아직 쓰지 않은 기능이다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { ScanSearch, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { pidIssueScanColumns, type PidIssueScanRow } from '../pid-columns';
import PartSearchField from '@/components/shared/PartSearchField';
import ComCodeSelect from '@/components/shared/ComCodeSelect';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function PidIssueScanPage() {
  const [rows, setRows] = useState<PidIssueScanRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [serialNo, setSerialNo] = useState('');
  const [modelName, setModelName] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [pidIssueType, setPidIssueType] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/pid/issue-scans', {
        params: {
          dateFrom, dateTo,
          serialNo: serialNo || undefined,
          modelName: modelName || undefined,
          itemCode: itemCode || undefined,
          pidIssueType: pidIssueType || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('이슈 스캔 이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, serialNo, modelName, itemCode, pidIssueType]);

  const columns = useMemo(() => pidIssueScanColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ScanSearch className="h-6 w-6 text-primary" />PCB 이슈발생스캔관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            PCB 이슈 발생 시 스캔한 PID 이력을 조회합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="스캔일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="PID" placeholder="PID" value={serialNo}
            className="w-52" onChange={(e) => setSerialNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ModelSearchField value={modelName} onChange={(v) => setModelName(v)}
            className="w-44" aria-label="모델명" placeholder="모델명" />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-40" onChange={(e) => setItemCode(e.target.value)} />
          <ComCodeSelect groupCode="PID ISSUE TYPE" labelPrefix="이슈유형" value={pidIssueType} onChange={setPidIssueType} className="w-44" />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="PCB이슈스캔이력"
            emptyMessage="조회 버튼을 눌러 이력을 확인하세요."
            getRowId={(row) => {
              const r = row as PidIssueScanRow;
              return `${r.serialNo}|${String(r.scanDate ?? '')}`;
            }}
          />
        </CardContent>
      </Card>
    </main>
  );
}
