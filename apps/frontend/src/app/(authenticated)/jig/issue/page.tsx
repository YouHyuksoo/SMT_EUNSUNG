"use client";

/**
 * @file src/app/(authenticated)/jig/issue/page.tsx
 * @description 지그출고관리 — PB w_mcn_jig_issue_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. PB 는 `값 + '%'` LIKE 로 조회한다. 빈 값이면 전체다.
 * 2. 코드성 조건은 자유 입력이 아니라 기초코드 선택이다.
 * 3. 출고 등록·취소는 상단 패널에서 한다. 취소는 행을 지우지 않고 상태만 'C' 로 바꾼다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { PackageOpen, RefreshCw, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { jigIssueColumns, type JigIssueRow } from './columns';
import IssueActionPanel from './components/IssueActionPanel';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function JigIssuePage() {
  const [rows, setRows] = useState<JigIssueRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [selected, setSelected] = useState<JigIssueRow | null>(null);
  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [jigCode, setJigCode] = useState('');
  const [jigType, setJigType] = useState('');
  const [issueStatus, setIssueStatus] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/issue', {
        params: {
          dateFrom,
          dateTo,
          jigCode: jigCode || undefined,
          jigType: jigType || undefined,
          issueStatus: issueStatus || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('지그출고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, jigCode, jigType, issueStatus]);

  const columns = useMemo(() => jigIssueColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <PackageOpen className="h-6 w-6 text-primary" />지그출고관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            지그 출고·반품 내역과 출고계정을 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
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

      <IssueActionPanel selected={selected} onChanged={search} />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input placeholder="지그코드" value={jigCode} className="w-44"
            onChange={(e) => setJigCode(e.target.value)} />
          <ComCodeSelect groupCode="JIG TYPE" value={jigType}
            onChange={setJigType} className="w-44" />
          <ComCodeSelect groupCode="ISSUE STATUS" value={issueStatus}
            onChange={setIssueStatus} className="w-44" />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid data={rows} columns={columns} isLoading={loading} pageSize={50}
            enableColumnFilter enableExport exportFileName="지그출고"
            emptyMessage="조회 버튼을 눌러 출고내역을 확인하세요."
            onRowClick={(row) => setSelected(row as JigIssueRow)}
            getRowId={(row) => {
              const issue = row as JigIssueRow;
              return `${String(issue.issueDate ?? '').slice(0, 10)}|${issue.issueSequence}`;
            }} />
        </CardContent>
      </Card>
    </div>
  );
}
