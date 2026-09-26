"use client";

/**
 * @file src/app/(authenticated)/mold/issue/page.tsx
 * @description S-PARTS 출고관리 — PB w_mcn_mold_issue_master 이식
 *
 * 초보자 가이드:
 * 1. **탭 3개** — 출고이력 / 출고대상(재고에서 직접) / 청구출고(청구건을 보고).
 *    PB 도 이 세 경로였고, **경로에 따라 출고항번 시퀀스가 다르다**(백엔드 주석 참조).
 * 2. **출고계정은 필수다.** PB 도 안 고르면 진행하지 않았다.
 * 3. **출고이력에는 취소건이 안 나온다** — PB 조건 그대로다.
 *    취소 이력은 재고관리 화면의 출고이력에서 본다.
 * 4. **출고취소는 행을 지우지 않는다.** 원본을 '취소'로 바꾸고, 그 출고로 처리됐던
 *    청구를 미처리로 되돌리고, 상계행을 새로 넣는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Ban, PackageMinus, Search, Send } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { moldIssueColumns, moldIssueTargetColumns, moldRequestColumns } from '../columns';
import type { MoldIssueRow, MoldIssueTargetRow, MoldRequestRow } from '../types';

type Mode = 'history' | 'targets' | 'requests';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function MoldIssuePage() {
  const [mode, setMode] = useState<Mode>('history');
  const [history, setHistory] = useState<MoldIssueRow[]>([]);
  const [targets, setTargets] = useState<MoldIssueTargetRow[]>([]);
  const [requests, setRequests] = useState<MoldRequestRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [moldCode, setMoldCode] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [moldUseStatus, setMoldUseStatus] = useState('');

  const [selectedHistory, setSelectedHistory] = useState<MoldIssueRow | null>(null);
  const [selectedTarget, setSelectedTarget] = useState<MoldIssueTargetRow | null>(null);
  const [selectedRequest, setSelectedRequest] = useState<MoldRequestRow | null>(null);

  const [issueQty, setIssueQty] = useState('1');
  const [moldIssueAccount, setMoldIssueAccount] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [machineCode, setMachineCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [cancelOpen, setCancelOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (mode === 'history') {
        const response = await api.get('/mold/issue', {
          params: { dateFrom, dateTo, moldCode: moldCode || undefined },
        });
        setHistory(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      } else if (mode === 'targets') {
        const response = await api.get('/mold/issue/targets', {
          params: {
            moldCode: moldCode || undefined,
            supplierCode: supplierCode || undefined,
            moldUseStatus: moldUseStatus || undefined,
          },
        });
        const data: MoldIssueTargetRow[] = response.data?.data ?? [];
        setTargets(data);
        setTotal(data.length);
      } else {
        const response = await api.get('/mold/issue/requests', {
          params: { moldCode: moldCode || undefined },
        });
        const data: MoldRequestRow[] = response.data?.data ?? [];
        setRequests(data);
        setTotal(data.length);
      }
      setSearched(true);
      setSelectedHistory(null);
      setSelectedTarget(null);
      setSelectedRequest(null);
    } catch {
      toast.error('S-PARTS 출고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mode, dateFrom, dateTo, moldCode, supplierCode, moldUseStatus]);

  const changeMode = useCallback((next: Mode) => {
    setMode(next);
    setHistory([]);
    setTargets([]);
    setRequests([]);
    setTotal(0);
    setSearched(false);
    setSelectedHistory(null);
    setSelectedTarget(null);
    setSelectedRequest(null);
  }, []);

  const issueFromStock = useCallback(async () => {
    if (!selectedTarget) return toast.error('출고할 재고를 고르세요.');
    if (!moldIssueAccount) return toast.error('출고계정을 고르세요.');
    setBusy(true);
    try {
      const response = await api.post('/mold/issue', {
        moldCode: selectedTarget.moldCode,
        issueQty: Number(issueQty),
        moldIssueAccount,
        moldVersion: selectedTarget.moldVersion ?? undefined,
        moldSetSerial: selectedTarget.moldSetSerial ?? undefined,
        workstageCode: workstageCode || undefined,
        lineCode: lineCode || undefined,
        machineCode: machineCode || undefined,
        locationCode: selectedTarget.locationCode ?? undefined,
        supplierCode: selectedTarget.supplierCode ?? undefined,
      });
      toast.success(`출고 ${response.data?.data?.issueSequence ?? ''}번 등록`);
      setIssueQty('1');
      void search();
    } catch {
      toast.error('출고 등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selectedTarget, moldIssueAccount, issueQty, workstageCode, lineCode, machineCode, search]);

  const issueFromRequest = useCallback(async () => {
    if (!selectedRequest) return toast.error('출고할 청구건을 고르세요.');
    if (!moldIssueAccount) return toast.error('출고계정을 고르세요.');
    setBusy(true);
    try {
      const response = await api.post('/mold/issue/from-request', {
        moldCode: selectedRequest.moldCode,
        requestDate: String(selectedRequest.requestDate).slice(0, 10),
        requestSequence: selectedRequest.requestSequence,
        issueQty: Number(issueQty),
        moldIssueAccount,
        moldVersion: selectedRequest.moldVersion ?? undefined,
        moldSetSerial: selectedRequest.moldSetSerial ?? undefined,
        workstageCode: workstageCode || undefined,
        lineCode: lineCode || undefined,
        machineCode: machineCode || undefined,
        supplierCode: selectedRequest.supplierCode ?? undefined,
      });
      toast.success(`출고 ${response.data?.data?.issueSequence ?? ''}번 등록 · 청구 완료 처리`);
      setIssueQty('1');
      void search();
    } catch {
      toast.error('이미 처리된 청구이거나 출고에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selectedRequest, moldIssueAccount, issueQty, workstageCode, lineCode, machineCode, search]);

  const cancel = useCallback(async () => {
    if (!selectedHistory) return;
    setCancelOpen(false);
    setBusy(true);
    try {
      await api.put('/mold/issue/cancel', {
        issueDate: String(selectedHistory.issueDate).slice(0, 10),
        issueSequence: selectedHistory.issueSequence,
      });
      toast.success('출고를 취소했습니다.');
      void search();
    } catch {
      toast.error('이미 취소되었거나 찾을 수 없는 출고건입니다.');
    } finally {
      setBusy(false);
    }
  }, [selectedHistory, search]);

  const historyCols = useMemo(() => moldIssueColumns, []);
  const targetCols = useMemo(() => moldIssueTargetColumns, []);
  const requestCols = useMemo(() => moldRequestColumns, []);
  const shown = mode === 'history' ? history.length : mode === 'targets' ? targets.length : requests.length;

  /** 출고 등록 패널 — 재고출고와 청구출고가 같은 입력을 쓴다 */
  const issuePanel = (onSubmit: () => void, label: string, disabled: boolean) => (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-end gap-3 p-3">
        <div className="flex items-center gap-2 self-center">
          <Send className="h-5 w-5 text-primary" />
          <span className="text-sm font-semibold text-text">{label}</span>
        </div>
        <label className="text-xs text-text-muted">
          출고계정 (필수)
          <ComCodeSelect groupCode="MOLD ISSUE ACCOUNT" includeAll={false}
            value={moldIssueAccount} onChange={setMoldIssueAccount} className="w-44" />
        </label>
        <label className="text-xs text-text-muted">
          출고수량
          <Input type="number" value={issueQty} className="w-24"
            onChange={(e) => setIssueQty(e.target.value)} />
        </label>
        <label className="text-xs text-text-muted">
          공정
          <ProcessSelect value={workstageCode} onChange={setWorkstageCode} className="w-44" />
        </label>
        <label className="text-xs text-text-muted">
          라인
          <LineSelect value={lineCode} onChange={setLineCode} className="w-40" />
        </label>
        <label className="text-xs text-text-muted">
          설비코드
          <Input value={machineCode} className="w-36"
            onChange={(e) => setMachineCode(e.target.value)} />
        </label>
        <Button size="sm" onClick={onSubmit} disabled={disabled || busy}>
          <PackageMinus className="mr-1 h-4 w-4" />출고
        </Button>
      </CardContent>
    </Card>
  );

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <PackageMinus className="h-6 w-6 text-primary" />S-PARTS 출고관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            재고에서 직접 또는 청구건으로 S-PARTS 를 출고하고 취소(역분개)합니다 ·{' '}
            {searched ? `${shown}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          {mode === 'history' && (
            <DateRangeFilter label="출고일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
          )}
          <Input aria-label="S-PARTS 코드" placeholder="S-PARTS 코드" value={moldCode}
            className="w-48" onChange={(e) => setMoldCode(e.target.value)} />
          {mode === 'targets' && (
            <>
              <SupplierSelect labelPrefix="공급처" value={supplierCode}
                onChange={setSupplierCode} className="w-56" />
              <ComCodeSelect groupCode="MOLD USE STATUS" labelPrefix="사용상태"
                value={moldUseStatus} onChange={setMoldUseStatus} className="w-52" />
            </>
          )}
        </CardContent>
      </Card>

      {mode === 'targets' && issuePanel(issueFromStock, '재고 직접출고', !selectedTarget)}
      {mode === 'requests' && issuePanel(issueFromRequest, '청구건 출고', !selectedRequest)}
      {mode === 'history' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <span className="text-sm text-text-muted">
              {selectedHistory
                ? `${selectedHistory.moldCode} / 출고항번 ${selectedHistory.issueSequence}`
                : '취소할 출고건을 고르세요'}
            </span>
            <Button size="sm" variant="secondary" disabled={!selectedHistory || busy}
              onClick={() => setCancelOpen(true)}>
              <Ban className="mr-1 h-4 w-4 text-red-500" />출고취소
            </Button>
          </CardContent>
        </Card>
      )}

      <nav className="flex gap-1 border-b border-border" aria-label="조회 모드">
        {([['history', '출고이력'], ['targets', '출고대상(재고)'], ['requests', '청구출고']] as const)
          .map(([key, label]) => (
            <button
              key={key}
              type="button"
              onClick={() => changeMode(key)}
              className={`px-3 py-1.5 text-sm ${
                mode === key
                  ? 'border-b-2 border-primary font-semibold text-text'
                  : 'text-text-muted'
              }`}
            >
              {label}
            </button>
          ))}
      </nav>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {mode === 'history' && (
            <DataGrid
              data={history}
              columns={historyCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS출고"
              emptyMessage="조회 버튼을 눌러 출고이력을 확인하세요."
              onRowClick={(row) => setSelectedHistory(row as MoldIssueRow)}
              getRowId={(row) => {
                const issue = row as MoldIssueRow;
                return `${issue.issueDate}|${issue.issueSequence}`;
              }}
            />
          )}
          {mode === 'targets' && (
            <DataGrid
              data={targets}
              columns={targetCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS출고대상"
              emptyMessage="조회 버튼을 눌러 출고대상을 확인하세요."
              onRowClick={(row) => setSelectedTarget(row as MoldIssueTargetRow)}
              getRowId={(row) => {
                const target = row as MoldIssueTargetRow;
                return `${target.moldCode}|${target.moldVersion ?? ''}|${target.moldSetSerial ?? ''}`;
              }}
            />
          )}
          {mode === 'requests' && (
            <DataGrid
              data={requests}
              columns={requestCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS청구"
              emptyMessage="조회 버튼을 눌러 청구건을 확인하세요."
              onRowClick={(row) => setSelectedRequest(row as MoldRequestRow)}
              getRowId={(row) => {
                const req = row as MoldRequestRow;
                return `${req.requestDate}|${req.requestSequence}`;
              }}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={cancelOpen}
        onClose={() => setCancelOpen(false)}
        onConfirm={cancel}
        title="출고 취소"
        message={selectedHistory
          ? `${selectedHistory.moldCode} / 출고항번 ${selectedHistory.issueSequence} 을(를) 취소합니다. 행은 지워지지 않고, 이 출고로 처리됐던 청구가 미처리로 되돌아갑니다.`
          : ''}
        variant="danger"
      />
    </main>
  );
}
