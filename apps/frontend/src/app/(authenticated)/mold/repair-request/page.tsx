"use client";

/**
 * @file src/app/(authenticated)/mold/repair-request/page.tsx
 * @description S-PARTS 수리신청관리 — PB w_mcn_mold_repair_request_master 이식
 *
 * 초보자 가이드:
 * 1. **수리주기**는 오늘 − 마지막 입고일이다(PB 계산식 그대로). 이 값이 큰 것이
 *    오래 안 돌아본 S-PARTS 다 — 대상 목록을 이 값으로 정렬해 보면 된다.
 * 2. **접수하면 상태가 '신청'으로 시작한다.** 처리 내용은 수리관리 화면에서 채운다.
 * 3. 하단은 선택 S-PARTS 의 수리이력이다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardPlus, Search, Wrench } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import MoldCodeField from '../components/MoldCodeField';
import { moldRepairColumns, moldRepairTargetColumns } from '../columns';
import type { MoldRepairRow, MoldRepairTargetRow } from '../types';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const yearAgo = () => {
  const date = new Date();
  date.setFullYear(date.getFullYear() - 1);
  return isoDate(date);
};

export default function MoldRepairRequestPage() {
  const [rows, setRows] = useState<MoldRepairTargetRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [moldCode, setMoldCode] = useState('');
  const [moldGroup, setMoldGroup] = useState('');

  const [selected, setSelected] = useState<MoldRepairTargetRow | null>(null);
  const [history, setHistory] = useState<MoldRepairRow[]>([]);
  const [historyLoading, setHistoryLoading] = useState(false);

  const [repairReasonCode, setRepairReasonCode] = useState('');
  const [repairVendorCode, setRepairVendorCode] = useState('');
  const [repairQty, setRepairQty] = useState('1');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/mold/repair/targets', {
        params: { moldCode: moldCode || undefined, moldGroup: moldGroup || undefined },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
      setSelected(null);
      setHistory([]);
    } catch {
      toast.error('수리 대상 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [moldCode, moldGroup]);

  /** 선택 S-PARTS 의 수리이력 — 최근 1년 */
  const loadHistory = useCallback(async (code: string) => {
    setHistoryLoading(true);
    try {
      const response = await api.get('/mold/repair', {
        params: { dateFrom: yearAgo(), dateTo: isoDate(new Date()), moldCode: code },
      });
      setHistory(response.data?.data ?? []);
    } catch {
      toast.error('수리이력 조회에 실패했습니다.');
    } finally {
      setHistoryLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!selected) return;
    void loadHistory(selected.moldCode);
  }, [selected, loadHistory]);

  const request = useCallback(async () => {
    if (!selected) return toast.error('수리를 신청할 S-PARTS 를 고르세요.');
    setBusy(true);
    try {
      const response = await api.post('/mold/repair/request', {
        moldCode: selected.moldCode,
        moldVersion: selected.moldVersion ?? undefined,
        moldSetSerial: selected.moldSetSerial ?? undefined,
        repairReasonCode: repairReasonCode || undefined,
        repairVendorCode: repairVendorCode || undefined,
        repairQty: repairQty.trim() === '' ? undefined : Number(repairQty),
        comments: comments || undefined,
      });
      toast.success(`수리 ${response.data?.data?.repairSequence ?? ''}번 접수`);
      setComments('');
      void loadHistory(selected.moldCode);
    } catch {
      toast.error('수리 접수에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, repairReasonCode, repairVendorCode, repairQty, comments, loadHistory]);

  const targetCols = useMemo(() => moldRepairTargetColumns, []);
  const historyCols = useMemo(() => moldRepairColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <ClipboardPlus className="h-6 w-6 text-primary" />S-PARTS 수리신청관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            수리주기를 보고 S-PARTS 수리를 접수합니다 ·{' '}
            {searched ? `${rows.length}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <MoldCodeField popupId="mold-search" returnKey="moldCode"
            label="S-PARTS 코드" placeholder="S-PARTS 코드"
            value={moldCode} onChange={setMoldCode} />
          <ComCodeSelect groupCode="MOLD GROUP" labelPrefix="그룹"
            value={moldGroup} onChange={setMoldGroup} className="w-56" />
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-end gap-3 p-3">
          <div className="flex items-center gap-2 self-center">
            <Wrench className="h-5 w-5 text-primary" />
            <span className="text-sm font-semibold text-text">수리 접수</span>
          </div>
          <span className="self-center text-sm text-text-muted">
            {selected
              ? `${selected.moldCode} / 버전 ${selected.moldVersion ?? '-'} / SET ${selected.moldSetSerial ?? '-'}`
              : '아래 목록에서 S-PARTS 를 고르세요'}
          </span>
          <label className="text-xs text-text-muted">
            수리원인
            <ComCodeSelect groupCode="REPAIR REASON CODE" includeAll={false}
              value={repairReasonCode} onChange={setRepairReasonCode} className="w-40" />
          </label>
          <label className="text-xs text-text-muted">
            수리업체
            <SupplierSelect includeAll={false} value={repairVendorCode}
              onChange={setRepairVendorCode} className="w-48" />
          </label>
          <label className="text-xs text-text-muted">
            수리수량
            <Input type="number" value={repairQty} className="w-24"
              onChange={(e) => setRepairQty(e.target.value)} />
          </label>
          <label className="text-xs text-text-muted">
            신청내용
            <Input value={comments} className="w-64"
              onChange={(e) => setComments(e.target.value)} />
          </label>
          <Button size="sm" onClick={request} disabled={!selected || busy}>
            <ClipboardPlus className="mr-1 h-4 w-4" />접수
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={targetCols}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="S-PARTS수리대상"
            emptyMessage="조회 버튼을 눌러 수리 대상을 확인하세요."
            onRowClick={(row) => setSelected(row as MoldRepairTargetRow)}
            initialSorting={[{ id: 'repairTerm', desc: true }]}
            getRowId={(row) => {
              const target = row as MoldRepairTargetRow;
              return `${target.moldCode}|${target.moldVersion ?? ''}|${target.moldSetSerial ?? ''}`;
            }}
          />
        </CardContent>
      </Card>

      <Card padding="none" className="h-56 shrink-0 overflow-hidden">
        <CardContent className="flex h-full flex-col p-3">
          <b className="mb-2 text-sm text-text">
            수리이력 (최근 1년){selected ? ` — ${selected.moldCode}` : ''}
          </b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={history}
              columns={historyCols}
              isLoading={historyLoading}
              pageSize={20}
              emptyMessage={selected ? '수리이력이 없습니다.' : 'S-PARTS 를 선택하세요.'}
              getRowId={(row) => {
                const repair = row as MoldRepairRow;
                return `${repair.moldCode}|${repair.repairSequence}`;
              }}
            />
          </div>
        </CardContent>
      </Card>
    </main>
  );
}
