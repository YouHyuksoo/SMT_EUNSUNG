"use client";

/**
 * @file src/app/(authenticated)/warehouse/etc-issue/page.tsx
 * @description 자재기타출고 — PB w_mat_other_issue_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **왼쪽은 출고이력, 오른쪽은 한 건씩 출고하는 폼이다.** 화면을 열 때 자동 조회하지 않는다.
 * 2. **출고할 품목은 오른쪽에서 품목코드로 재고를 불러와 고른다.** 같은 품목이 창고·롯트별로
 *    여러 줄이면 그중 하나를 고른다. 출고 원장에 그 창고·롯트·단가가 그대로 들어간다.
 * 3. **라인·공정·설비·출고계정은 반드시 넣어야 한다.** 비우면 어디로 나갔는지
 *    모르는 출고가 생긴다. 출고계정 M001·M002 는 '정상출고' 체크가 켜져 정상출고(N)로,
 *    체크를 끄거나 다른 계정이면 기타출고(E)로 남는다.
 * 4. **수량이 음수면 반납이다.** 라인에서 되돌려 받은 자재를 넣을 때 쓴다.
 * 5. **포장 단위 적용을 켜면 실제 출고 수량이 올라간다.** 250개들이 부품을 300개
 *    요청하면 500개가 나간다. 화면이 미리 보여주는 값과 서버가 넣는 값은 **같은
 *    함수**로 계산한다.
 *    **반납(음수)에는 켤 수 없다** — 음수에 포장 단위를 적용하면 양수가 나와 반납이
 *    출고로 뒤집힌다. 여기서는 막는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, PackageMinus, Search } from 'lucide-react';
import { applyIssuePacking } from '@smt/shared';
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
import type { IssueInventoryRow, IssueRow } from '../issue-manage-columns';
import PartSearchField from '@/components/shared/PartSearchField';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import EquipSelect from '@/components/shared/EquipSelect';

import { getTodayLocal } from '@/utils/date';
const today = () => getTodayLocal();
/** 정상출고(N)를 고를 수 있는 출고계정. 그 밖의 계정은 기타출고(E)다. */
const NORMAL_ISSUE_ACCOUNTS = ['M001', 'M002'];

/** 재고 한 줄을 고르는 키 — 같은 품목도 창고·롯트가 다르면 다른 줄이다. */
const stockKey = (row: IssueInventoryRow) =>
  `${row.locationCode ?? ''}|${row.materialMfs ?? ''}|${row.lineType ?? ''}`;

const errorMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function EtcIssuePage() {
  // 출고이력 조회
  const [itemCode, setItemCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');
  // 기타출고는 한 달에 수십 건이라 기본은 이번 달 1일부터다.
  const [dateFrom, setDateFrom] = useState(today());
  const [dateTo, setDateTo] = useState(today());
  const [histLineCode, setHistLineCode] = useState('');
  const [histInvoiceNo, setHistInvoiceNo] = useState('');

  const [history, setHistory] = useState<IssueRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 출고 품목 — 품목코드로 재고를 불러와 한 줄을 고른다
  const [stockItemCode, setStockItemCode] = useState('');
  const [stocks, setStocks] = useState<IssueInventoryRow[]>([]);
  const [stockLoading, setStockLoading] = useState(false);
  const [stockSearched, setStockSearched] = useState(false);
  const [picked, setPicked] = useState<IssueInventoryRow | null>(null);

  // 등록 폼
  const [issueDate, setIssueDate] = useState(today());
  const [issueQty, setIssueQty] = useState('');
  const [applyPacking, setApplyPacking] = useState(true);
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [machineCode, setMachineCode] = useState('');
  // 출고계정은 필수다. 기본은 M001 — 실제 출고가 거의 전부 이 계정이다.
  const [issueAccount, setIssueAccount] = useState('M001');
  const [normalIssue, setNormalIssue] = useState(true);
  const normalIssueAllowed = NORMAL_ISSUE_ACCOUNTS.includes(issueAccount);
  const [invoiceNo, setInvoiceNo] = useState('');
  const [comments, setComments] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const hist = await api.get('/warehouse/issue-manage/history', {
        params: {
          dateFrom,
          dateTo,
          itemCode: itemCode || undefined,
          materialMfs: materialMfs || undefined,
          lineCode: histLineCode || undefined,
          invoiceNo: histInvoiceNo.trim() || undefined,
          // 바코드 출고·공정 출고는 빼고 기타출고로 나간 것만 본다.
          etcOnly: true,
        },
      });
      setHistory(hist.data?.data ?? []);
      mark(hist);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [itemCode, materialMfs, dateFrom, dateTo, histLineCode, histInvoiceNo, mark]);

  /** 품목코드 하나의 재고를 창고·롯트별로 불러온다. */
  const loadStock = useCallback(async (code: string, keepKey?: string) => {
    const target = code.trim();
    if (!target) return;
    setStockLoading(true);
    try {
      const res = await api.get('/warehouse/issue-manage/inventory', {
        params: { itemCode: target },
      });
      const rows = ((res.data?.data ?? []) as IssueInventoryRow[])
        .filter((r) => r.itemCode === target);
      setStocks(rows);
      setStockSearched(true);
      const kept = keepKey ? rows.find((r) => stockKey(r) === keepKey) : undefined;
      setPicked(kept ?? (rows.length === 1 ? rows[0] : null));
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '재고를 불러오지 못했습니다.');
    } finally {
      setStockLoading(false);
    }
  }, []);

  const qty = Number(issueQty);
  const qtyValid = Number.isFinite(qty) && qty !== 0;

  /** 실제로 나갈 수량. 서버와 **같은 공유 함수**를 쓴다. */
  const finalQty = useMemo(() => {
    if (!qtyValid) return 0;
    if (!applyPacking || qty < 0) return qty;
    return applyIssuePacking(qty, picked?.issuePackingQty ?? 0);
  }, [qtyValid, applyPacking, qty, picked]);

  const blocker = useMemo(() => {
    if (!picked) return '품목코드로 재고를 불러와 출고할 줄을 고르세요.';
    if (!qtyValid) return '수량은 0 이 아닌 값이어야 합니다 (음수는 반납).';
    if (applyPacking && qty < 0) {
      return '반납(음수)에는 포장 단위를 적용할 수 없습니다.';
    }
    if (!lineCode) return '라인을 고르세요.';
    if (!workstageCode.trim()) return '공정을 넣으세요.';
    if (!machineCode.trim()) return '설비를 넣으세요.';
    if (!issueAccount) return '출고계정을 고르세요.';
    if (qty > 0 && finalQty > Number(picked.inventoryQty ?? 0)) {
      return `재고(${Number(picked.inventoryQty ?? 0).toLocaleString()})보다`
        + ` 많이 나갑니다 (${finalQty.toLocaleString()}).`;
    }
    return null;
  }, [picked, qtyValid, applyPacking, qty, lineCode, workstageCode, machineCode,
    issueAccount, finalQty]);

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
        issueAccount,
        normalIssue: normalIssueAllowed && normalIssue,
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
      // 바뀐 재고를 다시 보여준다. 이력은 조회한 적이 있을 때만 새로 고친다.
      void loadStock(picked.itemCode, stockKey(picked));
      if (searched) void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '출고에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [picked, issueDate, qty, lineCode, workstageCode, machineCode, applyPacking,
    issueAccount, normalIssueAllowed, normalIssue, invoiceNo, comments, loadStock,
    searched, search]);

  const stockOptions = useMemo(() => stocks.map((r) => ({
    value: stockKey(r),
    label: `창고 ${r.locationCode ?? '-'} · 롯트 ${r.materialMfs ?? '-'}`
      + ` · 재고 ${Number(r.inventoryQty ?? 0).toLocaleString()}`,
  })), [stocks]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재기타출고</h1>
        <p className="mt-1 text-sm text-text-muted">
          재고에서 자재를 빼거나 되돌려 받습니다. 수량이 음수면 반납입니다 ·{' '}
          {searched ? `출고 ${history.length.toLocaleString()}건` : '조건을 넣고 조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출고 기간" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="자재 롯트" placeholder="자재 롯트(MFS)" value={materialMfs}
            className="w-40"
            onChange={(e) => setMaterialMfs(e.target.value.toUpperCase())}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <LineSelect value={histLineCode} onChange={setHistLineCode} labelPrefix="라인" className="w-44" />
          <Input aria-label="전표번호" placeholder="전표번호" value={histInvoiceNo}
            className="w-36"
            onChange={(e) => setHistInvoiceNo(e.target.value.toUpperCase())}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Button size="sm" onClick={() => void search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-[1fr_340px]">
        <Card className="min-h-0 overflow-hidden" padding="none">
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
              emptyMessage={searched ? '기간 안에 출고가 없습니다.' : '조건을 넣고 조회하세요.'}
              rowClassName={(row) => (String((row as IssueRow).issueStatus ?? '') === 'C'
                ? 'bg-amber-500/5'
                : '')}
            />
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-auto" padding="none">
          <CardContent className="flex flex-col gap-3 p-3">
            <h2 className="flex items-center gap-1 text-sm font-semibold text-text">
              <PackageMinus className="h-4 w-4" />기타출고 등록
            </h2>

            <div className="flex items-end gap-2">
              <PartSearchField label="품목코드" placeholder="품목코드" value={stockItemCode}
                fullWidth
                onChange={(e) => {
                  setStockItemCode(e.target.value);
                  setStocks([]); setStockSearched(false); setPicked(null);
                }}
                onKeyDown={(e) => { if (e.key === 'Enter') void loadStock(stockItemCode); }} />
              <Button size="sm" variant="secondary" className="shrink-0 whitespace-nowrap"
                disabled={stockLoading || !stockItemCode.trim()}
                onClick={() => void loadStock(stockItemCode)}>
                재고
              </Button>
            </div>
            {stocks.length > 1 && (
              <Select label="창고·롯트" options={stockOptions} fullWidth
                value={picked ? stockKey(picked) : ''}
                placeholder="출고할 줄을 고르세요"
                onChange={(v) => setPicked(stocks.find((r) => stockKey(r) === v) ?? null)} />
            )}
            {stockSearched && stocks.length === 0 && (
              <p className="text-sm text-amber-500">재고가 있는 줄이 없습니다.</p>
            )}

            {picked && (
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
            )}

            <Input label="출고일" type="date" value={issueDate} fullWidth
              onChange={(e) => setIssueDate(e.target.value)} />
            <Input label="수량 (음수는 반납)" value={issueQty} inputMode="numeric" fullWidth
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

            <LineSelect label="라인" value={lineCode} onChange={setLineCode} fullWidth />
            <ProcessSelect label="공정코드" value={workstageCode}
              onChange={setWorkstageCode} fullWidth />
            <EquipSelect label="설비코드" value={machineCode}
              onChange={setMachineCode} fullWidth />
            <ComCodeSelect groupCode="ISSUE ACCOUNT" includeAll={false} label="출고계정"
              value={issueAccount} onChange={setIssueAccount} fullWidth />
            <label className={`flex items-center gap-2 text-sm ${normalIssueAllowed ? 'text-text' : 'text-text-muted'}`}>
              <input type="checkbox" checked={normalIssueAllowed && normalIssue}
                disabled={!normalIssueAllowed}
                onChange={(e) => setNormalIssue(e.target.checked)} />
              정상출고 (끄면 기타출고 · M001·M002 계정만)
            </label>
            <Input label="전표번호 (비우면 자동)" value={invoiceNo} fullWidth
              onChange={(e) => setInvoiceNo(e.target.value)} />
            <Input label="비고" value={comments} fullWidth
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
