"use client";

/**
 * @file src/app/(authenticated)/jig/repair-request/page.tsx
 * @description 187 지그수리신청 — PB w_mcn_jig_repair_request_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **고장난 지그를 "고쳐 달라"고 올리는 화면이다.** 실제로 고치고 마감하는 것은
 *    **지그수리관리**(`/jig/repair`) 화면이 한다 — 같은 표를 둘이 나눠 쓴다.
 * 2. **수리가 시작된 건은 못 고치고 못 지운다.** 수리일이 채워졌으면 수리관리
 *    화면이 처리한 것이다.
 * 3. **드물게 쓰는 화면이다** — 전 기간 12건. 그래도 고장 접수 경로가 이것뿐이다.
 * 4. 지그 목록에 **미완료 신청 건수**를 함께 보여 중복 신청을 막는다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Search, Wrench } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { jigRepairRequestColumns, repairableJigColumns } from '../jig-extra-columns';
import type { JigRepairRequestRow, RepairableJigRow } from '../jig-extra-columns';

const today = () => new Date().toISOString().slice(0, 10);
const yearsAgo = (n: number) => {
  const d = new Date();
  d.setFullYear(d.getFullYear() - n);
  return d.toISOString().slice(0, 10);
};

export default function JigRepairRequestPage() {
  const [dateFrom, setDateFrom] = useState(yearsAgo(3));
  const [dateTo, setDateTo] = useState(today());
  const [jigCodeCond, setJigCodeCond] = useState('');
  const [requests, setRequests] = useState<JigRepairRequestRow[]>([]);
  const [jigs, setJigs] = useState<RepairableJigRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 신청 폼
  const [jigCode, setJigCode] = useState('');
  const [jigLotNo, setJigLotNo] = useState('');
  const [repairReasonCode, setRepairReasonCode] = useState('');
  const [repairRequestDate, setRepairRequestDate] = useState(today());
  const [repairVendorCode, setRepairVendorCode] = useState('');
  const [comments, setComments] = useState('');
  const [editing, setEditing] = useState<JigRepairRequestRow | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<JigRepairRequestRow | null>(null);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const [req, jig] = await Promise.all([
        api.get('/jig/repair-request', {
          params: { dateFrom, dateTo, jigCode: jigCodeCond || undefined },
        }),
        api.get('/jig/repair-request/jigs', {
          params: { jigCode: jigCodeCond || undefined },
        }),
      ]);
      setRequests(req.data?.data ?? []);
      setJigs(jig.data?.data ?? []);
      mark(req);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, jigCodeCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const resetForm = useCallback(() => {
    setEditing(null);
    setJigCode('');
    setJigLotNo('');
    setRepairReasonCode('');
    setRepairRequestDate(today());
    setRepairVendorCode('');
    setComments('');
  }, []);

  /** 신청 한 줄을 고르면 수정 모드로 들어간다 (수리 시작 전인 것만). */
  const pickRequest = useCallback((row: JigRepairRequestRow) => {
    if (row.repairDate) {
      toast.error('이미 수리가 시작된 건입니다. 고칠 수 없습니다.');
      return;
    }
    setEditing(row);
    setJigCode(row.jigCode);
    setJigLotNo(row.jigLotNo ?? '');
    setRepairReasonCode(row.repairReasonCode ?? '');
    setRepairRequestDate(row.repairRequestDate ?? today());
    setRepairVendorCode(row.repairVendorCode ?? '');
    setComments(row.comments ?? '');
  }, []);

  const blocker = !jigCode.trim()
    ? '지그를 고르세요.'
    : !repairReasonCode.trim()
      ? '수리사유를 넣으세요.'
      : !repairRequestDate
        ? '신청일을 넣으세요.'
        : null;

  const submit = useCallback(async () => {
    if (blocker) return;
    setBusy(true);
    try {
      const body = {
        jigCode: jigCode.trim(),
        jigLotNo: jigLotNo.trim() || undefined,
        repairReasonCode: repairReasonCode.trim(),
        repairRequestDate,
        repairVendorCode: repairVendorCode.trim() || undefined,
        comments: comments.trim() || undefined,
      };
      if (editing) {
        await api.patch('/jig/repair-request', {
          ...body, repairSequence: editing.repairSequence,
        });
        toast.success('신청을 고쳤습니다.');
      } else {
        const r = await api.post('/jig/repair-request', body);
        toast.success(`신청했습니다 (신청번호 ${r.data?.data?.repairSequence ?? '-'}).`);
      }
      resetForm();
      await search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [blocker, jigCode, jigLotNo, repairReasonCode, repairRequestDate,
    repairVendorCode, comments, editing, resetForm, search]);

  const remove = useCallback(async () => {
    if (!deleteTarget) return;
    setBusy(true);
    try {
      await api.delete('/jig/repair-request', {
        data: {
          jigCode: deleteTarget.jigCode,
          repairSequence: deleteTarget.repairSequence,
        },
      });
      toast.success('신청을 취소했습니다.');
      setDeleteTarget(null);
      resetForm();
      await search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [deleteTarget, resetForm, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">지그수리신청</h1>
        <p className="mt-1 text-sm text-text-muted">
          고장난 지그의 수리를 신청합니다 (수리 처리는 지그수리관리에서) ·{' '}
          {searched ? `${requests.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 신청 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <Wrench className="h-4 w-4" />{editing ? `신청 수정 (${editing.repairSequence})` : '수리 신청'}
          </span>
          <Input aria-label="지그코드" placeholder="지그코드" value={jigCode}
            className="w-40"
            onChange={(e) => setJigCode(e.target.value)} />
          <Input aria-label="지그 롯트" placeholder="지그 롯트 (선택)" value={jigLotNo}
            className="w-40"
            onChange={(e) => setJigLotNo(e.target.value)} />
          <Input aria-label="수리사유" placeholder="수리사유 코드" value={repairReasonCode}
            className="w-36"
            onChange={(e) => setRepairReasonCode(e.target.value)} />
          <Input aria-label="신청일" type="date" value={repairRequestDate}
            className="w-44"
            onChange={(e) => setRepairRequestDate(e.target.value)} />
          <Input aria-label="수리업체" placeholder="수리업체 (선택)" value={repairVendorCode}
            className="w-36"
            onChange={(e) => setRepairVendorCode(e.target.value)} />
          <Input aria-label="신청내용" placeholder="신청내용" value={comments}
            className="w-56"
            onChange={(e) => setComments(e.target.value)} />
          <Button size="sm" disabled={busy || Boolean(blocker)} onClick={submit}>
            {editing ? '수정' : '신청'}
          </Button>
          {editing && (
            <>
              <Button size="sm" variant="secondary" onClick={resetForm}>새 신청</Button>
              <Button size="sm" variant="danger" disabled={busy}
                onClick={() => setDeleteTarget(editing)}>
                신청 취소
              </Button>
            </>
          )}
          {blocker && jigCode && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="신청일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="지그코드 조건" placeholder="지그코드" value={jigCodeCond}
            className="w-40"
            onChange={(e) => setJigCodeCond(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-[1.3fr_1fr]">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text">
              수리 신청 {requests.length.toLocaleString()}건
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={requests}
                columns={jigRepairRequestColumns}
                isLoading={loading}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="지그수리신청"
                emptyMessage={searched ? '이 기간에 신청이 없습니다.' : '조회하세요.'}
                onRowClick={(row) => pickRequest(row as JigRepairRequestRow)}
                rowClassName={(row) => ((row as JigRepairRequestRow).repairSequence
                  === editing?.repairSequence ? 'bg-primary/10' : '')}
              />
            </div>
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text">
              지그 {jigs.length.toLocaleString()}건 — 고르면 신청 폼에 들어갑니다
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={jigs}
                columns={repairableJigColumns}
                pageSize={100}
                enableColumnFilter
                emptyMessage="지그가 없습니다."
                onRowClick={(row) => {
                  const jig = row as RepairableJigRow;
                  setEditing(null);
                  setJigCode(jig.jigCode);
                }}
              />
            </div>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={Boolean(deleteTarget)}
        onClose={() => setDeleteTarget(null)}
        onConfirm={remove}
        title="수리 신청 취소"
        message={`${deleteTarget?.jigCode ?? ''} 의 신청 ${deleteTarget?.repairSequence ?? ''} 을`
          + ' 지웁니다. 이미 수리가 시작된 건은 지워지지 않습니다.'}
        confirmText="취소"
      />
    </div>
  );
}
