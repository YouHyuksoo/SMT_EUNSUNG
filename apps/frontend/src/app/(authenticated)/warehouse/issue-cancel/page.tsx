"use client";

/**
 * @file src/app/(authenticated)/warehouse/issue-cancel/page.tsx
 * @description 자재출고취소 — PB w_mat_mass_issue_cancel_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **잘못 나간 출고를 되돌리는 화면이다.**
 * 2. **원장을 지우지 않는다.** 원래 건의 상태를 '취소' 로 바꾸고, **부호를 뒤집은 행을
 *    한 건 더 넣는다** (출고 ↔ 반납, 수량·금액 음수). 그래서 목록에 두 줄이 남고
 *    무엇이 언제 취소됐는지 이력이 보인다.
 * 3. **이미 공정으로 이관된 자재는 취소할 수 없다** (PB 가드). 이미 쓰인 자재를
 *    되돌리면 재고가 실제와 어긋난다.
 * 4. **취소일을 고를 수 있다.** 취소 행의 출고일이 그 날짜가 된다 — 월이 넘어간 뒤
 *    취소하면 어느 달 장부에 잡힐지가 이 값으로 정해진다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, RotateCcw, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { issueColumns } from '../issue-manage-columns';
import type { IssueRow } from '../issue-manage-columns';
import PartSearchField from '@/components/shared/PartSearchField';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

const STATUS_OPTIONS = [
  { value: 'N', label: '정상 출고만' },
  { value: 'C', label: '취소된 것만' },
  { value: '', label: '전체' },
];

export default function IssueCancelPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [itemCode, setItemCode] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [invoiceNo, setInvoiceNo] = useState('');
  const [issueStatus, setIssueStatus] = useState('N');

  const [rows, setRows] = useState<IssueRow[]>([]);
  const [selected, setSelected] = useState<IssueRow | null>(null);
  const [cancelDate, setCancelDate] = useState(today());
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/warehouse/issue-manage/history', {
        params: {
          dateFrom,
          dateTo,
          itemCode: itemCode || undefined,
          lineCode: lineCode || undefined,
          invoiceNo: invoiceNo || undefined,
          issueStatus: issueStatus || undefined,
        },
      });
      setRows(r.data?.data ?? []);
      setSelected(null);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, itemCode, lineCode, invoiceNo, issueStatus, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const blocker = !selected
    ? '취소할 출고를 목록에서 고르세요.'
    : String(selected.issueStatus ?? '') === 'C'
      ? '이미 취소된 건입니다.'
      : null;

  const cancel = useCallback(async () => {
    setConfirmOpen(false);
    if (!selected) return;
    setBusy(true);
    try {
      const r = await api.post('/warehouse/issue-manage/cancel', {
        issueDate: selected.issueDate,
        issueSequence: selected.issueSequence,
        cancelDate,
      });
      const result = r.data?.data as { cancelSequence?: number } | undefined;
      toast.success(
        `취소했습니다 (취소 순번 ${result?.cancelSequence}). 원장에 되돌림 한 줄이`
        + ' 추가됐습니다.',
      );
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '출고취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, cancelDate, search]);

  const canceledCount = rows.filter((r) => String(r.issueStatus ?? '') === 'C').length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재출고취소</h1>
        <p className="mt-1 text-sm text-text-muted">
          잘못 나간 출고를 되돌립니다. 지우지 않고 부호를 뒤집은 줄을 더합니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건`
              + (canceledCount > 0 ? ` · 취소 ${canceledCount}건` : '')
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Input aria-label="전표번호" placeholder="전표번호" value={invoiceNo}
            className="w-40"
            onChange={(e) => setInvoiceNo(e.target.value)} />
          <Select options={STATUS_OPTIONS} value={issueStatus} onChange={setIssueStatus}
            className="w-40" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      {/* 취소 조작 줄 */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <RotateCcw className="h-4 w-4" />출고취소
          </span>
          {selected ? (
            <span className="text-sm">
              <b>{selected.itemCode}</b> · 출고일 {selected.issueDate} · 순번{' '}
              {selected.issueSequence} · 수량{' '}
              <b>{Number(selected.issueQty ?? 0).toLocaleString()}</b>
            </span>
          ) : (
            <span className="text-sm text-text-muted">목록에서 한 줄을 고르세요.</span>
          )}
          <label className="flex items-center gap-2 text-sm text-text">
            취소일
            <input type="date" value={cancelDate} className="rounded border border-border
              bg-surface px-2 py-1 text-sm"
              onChange={(e) => setCancelDate(e.target.value)} />
          </label>
          <Button size="sm" variant="danger" disabled={busy || Boolean(blocker)}
            onClick={() => setConfirmOpen(true)}>
            취소 처리
          </Button>
          {blocker && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={issueColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재출고취소"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['issueDate'] }}
            emptyMessage={searched ? '조건에 맞는 출고가 없습니다.' : '조회하세요.'}
            onRowClick={(row) => setSelected(row as IssueRow)}
            rowClassName={(row) => (String((row as IssueRow).issueStatus ?? '') === 'C'
              ? 'bg-amber-500/5'
              : '')}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={cancel}
        title="출고취소"
        message={`출고일 ${selected?.issueDate} 순번 ${selected?.issueSequence}`
          + ` (${selected?.itemCode} ·`
          + ` ${Number(selected?.issueQty ?? 0).toLocaleString()})을 취소합니다.`
          + ` 원장에 ${cancelDate} 자로 되돌림 한 줄이 추가됩니다. 되돌릴 수 없습니다.`}
        confirmText="취소 처리"
      />
    </div>
  );
}
