"use client";

/**
 * @file src/app/(authenticated)/quality/product-destroy/components/LcrDestroyTab.tsx
 * @description LCR 폐기 — 생산1팀 LCR 측정용 L/C/R 칩 자재 폐기 등록과 월 누계 (요청서 26.10.22 4·5번 시트)
 *
 * 초보자 가이드:
 * 1. 입력은 측정일자 · 품번 · LCR 진행 수량(연배 수) · 측정자뿐이다. 실장수·단가·폐기금액은 서버가 BOM·단가표로 계산한다.
 * 2. 품번은 BOM 에 L/C/R 위치가 직접 달린 면 품목(TOP/BOT)이다. 검색칸에 품번·품명·모델명 일부를 넣고 Enter.
 * 3. 품번을 고르면 대상 자재와 1연배 금액을 오른쪽에 미리 보여준다. 단가가 없는 자재는 0원으로 계산된다.
 * 4. 아래 목록은 고른 달의 등록분, 합계 행이 그 달 누계다. 오른쪽 표는 그 해 월별 누계다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import type { ColumnDef } from '@tanstack/react-table';
import { Plus, Search, Trash2 } from 'lucide-react';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import QtyInput from '@/components/shared/QtyInput';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import type { LcrDestroyRow, LcrItem, LcrMonthlyRow, LcrPart, LcrPreview } from '../types';

const num = (value: unknown, digits = 1) =>
  value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: digits });
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const sumOf = (rows: LcrDestroyRow[], key: 'arrayQty' | 'useQty' | 'destroyAmount') =>
  rows.reduce((sum, r) => sum + Number(r[key] ?? 0), 0);

const partColumns: ColumnDef<LcrPart>[] = [
  { accessorKey: 'childItemCode', header: '품번', size: 130 },
  { accessorKey: 'locationInfo', header: '위치', size: 150 },
  { accessorKey: 'mountQty', header: '실장', size: 60, meta: { align: 'right' }, cell: ctx => num(ctx.getValue(), 3) },
  { accessorKey: 'unitPrice', header: '단가', size: 80, meta: { align: 'right' }, cell: ctx => ctx.getValue() == null ? '없음' : num(ctx.getValue()) },
  { accessorKey: 'amount', header: '1연배 금액', size: 90, meta: { align: 'right' }, cell: ctx => num(ctx.getValue()) },
];

export default function LcrDestroyTab() {
  // 등록 입력
  const [measureDate, setMeasureDate] = useState(getTodayLocal);
  const [search, setSearch] = useState('');
  const [candidates, setCandidates] = useState<LcrItem[]>([]);
  const [itemCode, setItemCode] = useState('');
  const [arrayQty, setArrayQty] = useState(1);
  const [measurer, setMeasurer] = useState('');
  const [comments, setComments] = useState('');
  const [preview, setPreview] = useState<LcrPreview | null>(null);
  const [saving, setSaving] = useState(false);

  // 목록
  const [month, setMonth] = useState(() => getTodayLocal().slice(0, 7));
  const [rows, setRows] = useState<LcrDestroyRow[]>([]);
  const [monthly, setMonthly] = useState<LcrMonthlyRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<LcrDestroyRow | null>(null);
  const [selectedParts, setSelectedParts] = useState<LcrPart[] | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const searchItems = useCallback(async () => {
    try {
      const response = await api.get('/quality/lcr-destroy/items', { params: { search: search.trim() || undefined } });
      const list: LcrItem[] = response.data?.data ?? [];
      setCandidates(list);
      if (list.length === 1) setItemCode(list[0].itemCode);
      if (list.length === 0) toast.error('L/C/R 자재가 BOM 에 있는 품번이 없습니다');
    } catch {
      setCandidates([]);
      toast.error('품번 조회에 실패했습니다');
    }
  }, [search]);

  useEffect(() => { void searchItems(); }, []); // eslint-disable-line react-hooks/exhaustive-deps -- 처음 한 번 전체 후보를 띄운다

  useEffect(() => {
    if (!itemCode || !measureDate) { setPreview(null); return; }
    let cancelled = false;
    api.get('/quality/lcr-destroy/preview', { params: { itemCode, measureDate } })
      .then(response => { if (!cancelled) setPreview(response.data?.data ?? null); })
      .catch(() => { if (!cancelled) { setPreview(null); toast.error('BOM 자재 계산에 실패했습니다'); } });
    return () => { cancelled = true; };
  }, [itemCode, measureDate]);

  const loadList = useCallback(async () => {
    setLoading(true);
    try {
      const [listResponse, monthlyResponse] = await Promise.all([
        api.get('/quality/lcr-destroy', { params: { month } }),
        api.get('/quality/lcr-destroy/monthly', { params: { year: month.slice(0, 4) } }),
      ]);
      setRows(listResponse.data?.data ?? []);
      setMonthly(monthlyResponse.data?.data ?? []);
      setSelected(null);
      setSelectedParts(null);
    } catch {
      setRows([]);
      setMonthly([]);
      toast.error('LCR 폐기 목록 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, [month]);

  useEffect(() => { if (/^\d{4}-\d{2}$/.test(month)) void loadList(); }, [loadList, month]);

  const save = useCallback(async () => {
    setSaving(true);
    try {
      await api.post('/quality/lcr-destroy', {
        measureDate, itemCode, arrayQty, measurer: measurer.trim(), comments: comments.trim() || undefined,
      });
      toast.success('LCR 폐기를 등록했습니다');
      setComments('');
      if (measureDate.slice(0, 7) !== month) setMonth(measureDate.slice(0, 7));
      else await loadList();
    } catch (error: unknown) {
      toast.error(apiMessage(error) || 'LCR 폐기 등록에 실패했습니다');
    } finally {
      setSaving(false);
    }
  }, [arrayQty, comments, itemCode, loadList, measureDate, measurer, month]);

  const remove = useCallback(async () => {
    if (!selected) return;
    try {
      await api.delete(`/quality/lcr-destroy/${selected.lcrSeq}`);
      toast.success('삭제했습니다');
      setDeleteOpen(false);
      await loadList();
    } catch (error: unknown) {
      toast.error(apiMessage(error) || '삭제에 실패했습니다');
    }
  }, [loadList, selected]);

  const selectRow = useCallback(async (row: LcrDestroyRow) => {
    setSelected(row);
    try {
      const response = await api.get(`/quality/lcr-destroy/${row.lcrSeq}/detail`);
      const detail: { childItemCode: string; childItemName: string | null; locationInfo: string | null; mountQty: number; unitPrice: number | null; destroyAmount: number; useQty: number }[] =
        response.data?.data ?? [];
      // 1연배 금액으로 보여준다 (등록 시점 스냅샷)
      setSelectedParts(detail.map(d => ({
        childItemCode: d.childItemCode, childItemName: d.childItemName, locationInfo: d.locationInfo,
        mountQty: d.mountQty, unitPrice: d.unitPrice, amount: row.arrayQty > 0 ? d.destroyAmount / row.arrayQty : 0,
      })));
    } catch {
      setSelectedParts(null);
    }
  }, []);

  const itemOptions = useMemo(() => candidates.map(c => ({
    value: c.itemCode,
    label: `${c.itemCode} · ${c.itemName ?? c.modelName ?? ''}`,
  })), [candidates]);

  const listColumns = useMemo<ColumnDef<LcrDestroyRow>[]>(() => [
    { accessorKey: 'measureDate', header: '측정일자', size: 100, footer: '합계' },
    { accessorKey: 'customerName', header: '고객사', size: 90, cell: ctx => ctx.getValue() ?? ctx.row.original.customerCode ?? '' },
    { accessorKey: 'itemCode', header: '품번', size: 150 },
    { accessorKey: 'itemName', header: '품명', size: 220 },
    { accessorKey: 'arrayQty', header: 'LCR 진행 수량', size: 100, meta: { align: 'right' }, cell: ctx => num(ctx.getValue(), 0), footer: () => num(sumOf(rows, 'arrayQty'), 0) },
    { accessorKey: 'mountQty', header: '실장수 (1연배)', size: 100, meta: { align: 'right' }, cell: ctx => num(ctx.getValue(), 3) },
    { accessorKey: 'useQty', header: '실 사용 수량', size: 100, meta: { align: 'right' }, cell: ctx => num(ctx.getValue(), 3), footer: () => num(sumOf(rows, 'useQty'), 3) },
    { accessorKey: 'unitPriceSum', header: '실장 자재 총 단가', size: 120, meta: { align: 'right' }, cell: ctx => num(ctx.getValue()) },
    { accessorKey: 'destroyAmount', header: '폐기금액', size: 110, meta: { align: 'right' }, cell: ctx => num(ctx.getValue()), footer: () => num(sumOf(rows, 'destroyAmount')) },
    { accessorKey: 'measurer', header: '측정자', size: 90 },
    { accessorKey: 'comments', header: '비고', size: 160 },
    { accessorKey: 'enterBy', header: '등록자', size: 90 },
  ], [rows]);

  const canSave = Boolean(measureDate && itemCode && arrayQty > 0 && measurer.trim() && preview && preview.parts.length > 0);
  const previewParts = selectedParts ?? preview?.parts ?? [];

  return (
    <>
      <Card className="shrink-0" padding="sm">
        <div className="flex flex-wrap items-center gap-2">
          <Input type="date" aria-label="측정일자" value={measureDate} onChange={e => setMeasureDate(e.target.value)} className="w-40" />
          <Input aria-label="품번 검색" placeholder="품번·품명·모델 검색" value={search} onChange={e => setSearch(e.target.value)}
            onKeyDown={e => { if (e.key === 'Enter') void searchItems(); }} className="w-44" />
          <Button size="sm" variant="secondary" onClick={() => void searchItems()} aria-label="품번 검색">
            <Search className="h-4 w-4" />
          </Button>
          <Select aria-label="품번" placeholder={`품번 선택 (${candidates.length}건)`} options={itemOptions} value={itemCode}
            onChange={value => { setItemCode(value); setSelected(null); setSelectedParts(null); }} className="w-80" />
          <QtyInput aria-label="LCR 진행 수량" placeholder="진행 수량" value={arrayQty} onChange={setArrayQty} className="w-24" />
          <Input aria-label="측정자" placeholder="측정자" maxLength={16} value={measurer} onChange={e => setMeasurer(e.target.value)} className="w-28" />
          <Input aria-label="비고" placeholder="비고" maxLength={150} value={comments} onChange={e => setComments(e.target.value)} className="w-40" />
          <Button size="sm" onClick={() => void save()} disabled={!canSave || saving}>
            <Plus className="mr-1 h-4 w-4" />등록
          </Button>
        </div>
        {preview && (
          <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-sm text-text">
            <span>고객사 <strong>{preview.item.customerName ?? '-'}</strong></span>
            <span>품명 <strong>{preview.item.itemName ?? '-'}</strong></span>
            <span>L/C/R 자재 <strong>{preview.parts.length}</strong>종 · 실장 <strong>{num(preview.mountQty, 3)}</strong></span>
            <span>단가 합 <strong>{num(preview.unitPriceSum)}</strong>원</span>
            <span>1연배 <strong>{num(preview.amountPerArray)}</strong>원</span>
            <span>폐기금액 <strong>{num(preview.amountPerArray * arrayQty)}</strong>원 (× {arrayQty.toLocaleString()})</span>
            {preview.missingPriceCount > 0 && <span className="text-amber-600">단가 없는 자재 {preview.missingPriceCount}종은 0원으로 계산</span>}
            {preview.parts.length === 0 && <span className="text-red-600">이 품번 BOM 에 L/C/R 위치 자재가 없습니다</span>}
          </div>
        )}
      </Card>

      <div className="flex min-h-0 flex-1 gap-3">
        <Card className="flex min-h-0 flex-1 flex-col overflow-hidden" padding="none">
          <div className="flex flex-wrap items-center gap-2 border-b border-border px-3 py-2">
            <span className="text-sm font-semibold text-text">LCR 폐기 목록</span>
            <Input type="month" aria-label="조회월" value={month} onChange={e => setMonth(e.target.value)} className="w-36" />
            <span className="text-sm text-text-muted">
              {rows.length}건 · 월 누계 {num(sumOf(rows, 'destroyAmount'))}원
            </span>
            <Button size="sm" variant="secondary" className="ml-auto" onClick={() => setDeleteOpen(true)} disabled={!selected}>
              <Trash2 className="mr-1 h-4 w-4" />삭제
            </Button>
          </div>
          <CardContent className="min-h-0 flex-1 p-3">
            <DataGrid data={rows} columns={listColumns} isLoading={loading} pageSize={50}
              getRowId={row => String(row.lcrSeq)} selectedRowId={selected ? String(selected.lcrSeq) : undefined}
              onRowClick={row => void selectRow(row)} enableExport exportFileName={`LCR폐기_${month}`}
              emptyMessage="등록된 LCR 폐기가 없습니다." />
          </CardContent>
        </Card>

        <div className="flex w-[440px] shrink-0 flex-col gap-3">
          <Card className="flex min-h-0 flex-1 flex-col overflow-hidden" padding="none">
            <div className="border-b border-border px-3 py-2 text-sm font-semibold text-text">
              {selected ? `${selected.itemCode} 자재 (등록 시점)` : '대상 자재 (BOM L/C/R)'}
            </div>
            <CardContent className="min-h-0 flex-1 p-3">
              <DataGrid data={previewParts} columns={partColumns} pageSize={100}
                emptyMessage="품번을 고르면 L/C/R 자재가 나옵니다." />
            </CardContent>
          </Card>
          <Card className="shrink-0" padding="sm">
            <div className="mb-1 text-sm font-semibold text-text">{month.slice(0, 4)}년 월별 누계</div>
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border text-text-muted">
                  <th className="py-1 text-left font-medium">월</th>
                  <th className="py-1 text-right font-medium">건수</th>
                  <th className="py-1 text-right font-medium">진행 수량</th>
                  <th className="py-1 text-right font-medium">실 사용</th>
                  <th className="py-1 text-right font-medium">폐기금액</th>
                </tr>
              </thead>
              <tbody>
                {monthly.length === 0 && (
                  <tr><td colSpan={5} className="py-2 text-center text-text-muted">등록 실적이 없습니다.</td></tr>
                )}
                {monthly.map(m => (
                  <tr key={m.month} className="border-b border-border">
                    <td className="py-1">{m.month}</td>
                    <td className="py-1 text-right tabular-nums">{num(m.count, 0)}</td>
                    <td className="py-1 text-right tabular-nums">{num(m.arrayQty, 0)}</td>
                    <td className="py-1 text-right tabular-nums">{num(m.useQty, 3)}</td>
                    <td className="py-1 text-right tabular-nums">{num(m.destroyAmount)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </Card>
        </div>
      </div>

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        variant="danger"
        title="LCR 폐기 삭제"
        confirmText="삭제"
        message={selected ? <span>{selected.measureDate} · {selected.itemCode} · 진행 {selected.arrayQty} 건을 삭제합니다.</span> : ''}
      />
    </>
  );
}
