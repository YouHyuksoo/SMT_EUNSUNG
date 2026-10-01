"use client";

/**
 * @file src/app/(authenticated)/warehouse/etc-issue/page.tsx
 * @description 자재기타출고 — PB w_mat_other_issue_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **재고에서 자재를 빼는 화면이다.** 왼쪽 재고 목록에서 품목을 고르고 오른쪽 폼에서
 *    수량과 라인·공정·설비를 넣으면 출고 원장에 한 건이 들어간다.
 * 2. **라인·공정·설비는 반드시 넣어야 한다** (PB 도 같다). 비우면 어디로 나갔는지
 *    모르는 출고가 생긴다.
 * 3. **수량이 음수면 반납이다.** 라인에서 되돌려 받은 자재를 넣을 때 쓴다.
 * 4. **포장 단위 적용을 켜면 실제 출고 수량이 올라간다.** 250개들이 부품을 300개
 *    요청하면 500개가 나간다. 화면이 미리 보여주는 값과 서버가 넣는 값은 **같은
 *    함수**로 계산한다.
 *    **반납(음수)에는 켤 수 없다** — PB 는 그 경우 양수를 내놓아 반납이 출고로
 *    뒤집힌다. 여기서는 막는다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, PackageMinus, Search } from 'lucide-react';
import { applyIssuePacking } from '@smt/shared';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { issueColumns, issueInventoryColumns } from '../issue-manage-columns';
import type { IssueInventoryRow, IssueRow } from '../issue-manage-columns';
import PartSearchField from '@/components/shared/PartSearchField';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

export default function EtcIssuePage() {
  // 조회
  const [invItemCode, setInvItemCode] = useState('');
  const [invLocationCode, setInvLocationCode] = useState('');
  const [includeZero, setIncludeZero] = useState(false);
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());

  const [inventory, setInventory] = useState<IssueInventoryRow[]>([]);
  const [history, setHistory] = useState<IssueRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 등록 폼
  const [picked, setPicked] = useState<IssueInventoryRow | null>(null);
  const [issueDate, setIssueDate] = useState(today());
  const [issueQty, setIssueQty] = useState('');
  const [applyPacking, setApplyPacking] = useState(true);
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [machineCode, setMachineCode] = useState('');
  const [issueAccount, setIssueAccount] = useState('');
  const [invoiceNo, setInvoiceNo] = useState('');
  const [comments, setComments] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const [inv, hist] = await Promise.all([
        api.get('/warehouse/issue-manage/inventory', {
          params: {
            itemCode: invItemCode || undefined,
            locationCode: invLocationCode || undefined,
            includeZero: includeZero || undefined,
          },
        }),
        api.get('/warehouse/issue-manage/history', {
          params: { dateFrom, dateTo },
        }),
      ]);
      setInventory(inv.data?.data ?? []);
      setHistory(hist.data?.data ?? []);
      mark(inv, hist);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [invItemCode, invLocationCode, includeZero, dateFrom, dateTo, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const qty = Number(issueQty);
  const qtyValid = Number.isFinite(qty) && qty !== 0;

  /** 실제로 나갈 수량. 서버와 **같은 공유 함수**를 쓴다. */
  const finalQty = useMemo(() => {
    if (!qtyValid) return 0;
    if (!applyPacking || qty < 0) return qty;
    return applyIssuePacking(qty, picked?.issuePackingQty ?? 0);
  }, [qtyValid, applyPacking, qty, picked]);

  const blocker = useMemo(() => {
    if (!picked) return '왼쪽 재고 목록에서 품목을 고르세요.';
    if (!qtyValid) return '수량은 0 이 아닌 값이어야 합니다 (음수는 반납).';
    if (applyPacking && qty < 0) {
      return '반납(음수)에는 포장 단위를 적용할 수 없습니다.';
    }
    if (!lineCode) return '라인을 고르세요.';
    if (!workstageCode.trim()) return '공정을 넣으세요.';
    if (!machineCode.trim()) return '설비를 넣으세요.';
    if (qty > 0 && finalQty > Number(picked.inventoryQty ?? 0)) {
      return `재고(${Number(picked.inventoryQty ?? 0).toLocaleString()})보다`
        + ` 많이 나갑니다 (${finalQty.toLocaleString()}).`;
    }
    return null;
  }, [picked, qtyValid, applyPacking, qty, lineCode, workstageCode, machineCode,
    finalQty]);

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    if (!picked) return;
    setBusy(true);
    try {
      const r = await api.post('/warehouse/issue-manage', {
        issueDate,
        itemCode: picked.itemCode,
        issueQty: qty,
        lineCode,
        workstageCode: workstageCode.trim(),
        machineCode: machineCode.trim(),
        applyPackingQty: applyPacking,
        locationCode: picked.locationCode || undefined,
        materialMfs: picked.materialMfs || undefined,
        lineType: picked.lineType || undefined,
        issuePrice: picked.inventoryPrice ?? undefined,
        issueAccount: issueAccount.trim() || undefined,
        invoiceNo: invoiceNo.trim() || undefined,
        comments: comments.trim() || undefined,
      });
      const result = r.data?.data as
        { issueQty?: number; issueDeficit?: number; invoiceNo?: string } | undefined;
      toast.success(
        `${result?.issueDeficit === 4 ? '반납' : '출고'}`
        + ` ${Math.abs(Number(result?.issueQty ?? 0)).toLocaleString()} 처리했습니다`
        + ` (전표 ${result?.invoiceNo}).`,
      );
      setIssueQty('');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '출고에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [picked, issueDate, qty, lineCode, workstageCode, machineCode, applyPacking,
    issueAccount, invoiceNo, comments, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재기타출고</h1>
        <p className="mt-1 text-sm text-text-muted">
          재고에서 자재를 빼거나 되돌려 받습니다. 수량이 음수면 반납입니다 ·{' '}
          {searched
            ? `재고 ${inventory.length.toLocaleString()}건 · 출고 ${history.length.toLocaleString()}건`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <PartSearchField aria-label="재고 품목코드" placeholder="재고 품목코드" value={invItemCode}
            className="w-44"
            onChange={(e) => setInvItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="재고 창고코드" placeholder="재고 창고코드" value={invLocationCode}
            className="w-36"
            onChange={(e) => setInvLocationCode(e.target.value)} />
          <label className="flex items-center gap-2 text-sm text-text">
            <input type="checkbox" checked={includeZero}
              onChange={(e) => setIncludeZero(e.target.checked)} />
            재고 0 이하도 보기 (느립니다)
          </label>
          <DateRangeFilter label="출고 기간" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-[1fr_340px]">
        <div className="flex min-h-0 flex-col gap-4">
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={inventory}
                columns={issueInventoryColumns}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="기타출고_현재고"
                emptyMessage={searched ? '조건에 맞는 재고가 없습니다.' : '조회하세요.'}
                onRowClick={(row) => setPicked(row as IssueInventoryRow)}
              />
            </CardContent>
          </Card>

          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={history}
                columns={issueColumns}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="자재출고"
                enableColumnPinning
                defaultPinnedColumns={{ left: ['issueDate'] }}
                emptyMessage={searched ? '기간 안에 출고가 없습니다.' : '조회하세요.'}
                rowClassName={(row) => (String((row as IssueRow).issueStatus ?? '') === 'C'
                  ? 'bg-amber-500/5'
                  : '')}
              />
            </CardContent>
          </Card>
        </div>

        <Card className="min-h-0 overflow-auto" padding="none">
          <CardContent className="flex flex-col gap-3 p-3">
            <h2 className="flex items-center gap-1 text-sm font-semibold text-text">
              <PackageMinus className="h-4 w-4" />기타출고 등록
            </h2>

            {picked ? (
              <div className="rounded border border-border bg-surface-muted px-3 py-2 text-sm">
                <div><b>{picked.itemCode}</b> {picked.itemName ?? ''}</div>
                <div className="mt-1 text-text-muted">
                  재고 {Number(picked.inventoryQty ?? 0).toLocaleString()} ·
                  창고 {picked.locationCode ?? '-'} ·
                  포장 단위 {Number(picked.issuePackingQty ?? 0) > 0
                    ? Number(picked.issuePackingQty).toLocaleString()
                    : '없음'}
                </div>
              </div>
            ) : (
              <p className="text-sm text-text-muted">왼쪽 재고 목록에서 품목을 고르세요.</p>
            )}

            <Input label="출고일" type="date" value={issueDate}
              onChange={(e) => setIssueDate(e.target.value)} />
            <Input label="수량 (음수는 반납)" value={issueQty} inputMode="numeric"
              onChange={(e) => setIssueQty(e.target.value)} />
            <label className="flex items-center gap-2 text-sm text-text">
              <input type="checkbox" checked={applyPacking}
                onChange={(e) => setApplyPacking(e.target.checked)} />
              포장 단위로 올려서 출고
            </label>
            {qtyValid && (
              <div className="rounded border border-border bg-surface-muted px-3 py-2 text-sm">
                실제로 나갈 수량 <b>{finalQty.toLocaleString()}</b>
                {finalQty !== qty && (
                  <span className="text-text-muted">
                    {' '}(요청 {qty.toLocaleString()} → 포장 단위로 올림)
                  </span>
                )}
              </div>
            )}

            <div>
              <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
            </div>
            <Input label="공정코드" value={workstageCode}
              onChange={(e) => setWorkstageCode(e.target.value)} />
            <Input label="설비코드" value={machineCode}
              onChange={(e) => setMachineCode(e.target.value)} />
            <Input label="출고계정" value={issueAccount}
              onChange={(e) => setIssueAccount(e.target.value)} />
            <Input label="전표번호 (비우면 자동)" value={invoiceNo}
              onChange={(e) => setInvoiceNo(e.target.value)} />
            <Input label="비고" value={comments}
              onChange={(e) => setComments(e.target.value)} />

            {blocker && (
              <p className="flex items-start gap-1 text-sm text-amber-500">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />{blocker}
              </p>
            )}

            <Button disabled={busy || Boolean(blocker)} onClick={() => setConfirmOpen(true)}>
              출고
            </Button>
            <p className="text-xs text-text-muted">
              잘못 나갔으면 자재출고취소 화면에서 되돌립니다. 이 화면에서는 지울 수
              없습니다.
            </p>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title={qty < 0 ? '자재 반납' : '자재 출고'}
        message={`${picked?.itemCode} 를 ${Math.abs(finalQty).toLocaleString()}`
          + ` ${qty < 0 ? '반납' : '출고'} 합니다. 재고가 바로 바뀝니다.`}
        confirmText={qty < 0 ? '반납' : '출고'}
      />
    </div>
  );
}
