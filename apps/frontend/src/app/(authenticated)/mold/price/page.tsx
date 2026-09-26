"use client";

/**
 * @file src/app/(authenticated)/mold/price/page.tsx
 * @description S-PARTS 구매단가관리 — PB w_mcn_mold_buy_price_master 이식
 *
 * 초보자 가이드:
 * 1. **적용상태(적용중·적용예정·만료)는 계산값이다.** PB 트리가 이 값으로 묶여 있었으므로
 *    목록을 상태로 정렬해 같은 묶음이 붙어 보이게 했고, 조회조건으로도 좁힐 수 있게 했다.
 * 2. **일괄작업 2개**
 *    - 단가행 생성: 단가가 없는 (S-PARTS, 공급처) 조합에 임시단가 0원 행을 만든다.
 *      PB 원본은 NOT IN 비교의 컬럼 순서가 어긋나 이미 단가가 있는 조합도 걸러지지 않았다.
 *      웹은 바로잡았으므로 여러 번 눌러도 중복이 생기지 않는다.
 *    - 공급처 일괄변경: 오늘 유효한 단가행의 공급처를 통째로 바꾼다.
 * 3. **승인된 단가는 삭제되지 않는다** — 서버가 막는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { BadgeDollarSign, Edit2, ListPlus, Plus, Search, Trash2, Users } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { moldPriceColumns } from '../columns';
import type { MoldPriceRow } from '../types';
import PriceFormPanel, {
  emptyPriceForm,
  toPriceForm,
  type PriceForm,
} from './components/PriceFormPanel';

const STATUS_OPTIONS = [
  { value: '', label: '적용상태 전체' },
  { value: 'RUNNING', label: '적용중' },
  { value: 'FUTURE', label: '적용예정' },
  { value: 'EXPIRED', label: '만료' },
];

export default function MoldPricePage() {
  const [rows, setRows] = useState<MoldPriceRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [moldCode, setMoldCode] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [status, setStatus] = useState('');

  const [selected, setSelected] = useState<MoldPriceRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: PriceForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [generateOpen, setGenerateOpen] = useState(false);
  const [changeOpen, setChangeOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const [generateCurrency, setGenerateCurrency] = useState('KRW');
  const [beforeSupplier, setBeforeSupplier] = useState('');
  const [afterSupplier, setAfterSupplier] = useState('');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/mold/price', {
        params: {
          moldCode: moldCode || undefined,
          supplierCode: supplierCode || undefined,
          status: status || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('구매단가 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [moldCode, supplierCode, status]);

  const removePrice = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    setBusy(true);
    try {
      await api.delete('/mold/price', {
        data: {
          moldCode: selected.moldCode,
          supplierCode: selected.supplierCode,
          dateset: String(selected.dateset).slice(0, 10),
        },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch {
      toast.error('승인된 단가는 삭제할 수 없습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, search]);

  const generate = useCallback(async () => {
    setGenerateOpen(false);
    setBusy(true);
    try {
      const response = await api.post('/mold/price/generate', { currency: generateCurrency });
      const created = Number(response.data?.data?.created ?? 0);
      toast.success(created > 0 ? `단가행 ${created}건을 만들었습니다.` : '새로 만들 단가행이 없습니다.');
      void search();
    } catch {
      toast.error('단가행 생성에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [generateCurrency, search]);

  const changeSupplier = useCallback(async () => {
    setChangeOpen(false);
    setBusy(true);
    try {
      const response = await api.put('/mold/price/supplier-change', {
        beforeSupplierCode: beforeSupplier,
        afterSupplierCode: afterSupplier,
      });
      const changed = Number(response.data?.data?.changed ?? 0);
      toast.success(`${changed}건의 공급처를 바꿨습니다.`);
      void search();
    } catch {
      toast.error('공급처 변경에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [beforeSupplier, afterSupplier, search]);

  const columns = useMemo(() => moldPriceColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <BadgeDollarSign className="h-6 w-6 text-primary" />S-PARTS 구매단가관리
            </h1>
            <p className="mt-1 text-sm text-text-muted">
              S-PARTS 공급처별 구매단가와 적용 기간을 관리합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
            </p>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected || busy}
              onClick={() => selected && setPanel({ mode: 'edit', form: toPriceForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected || busy}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm" onClick={() => setPanel({ mode: 'create', form: emptyPriceForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <Input aria-label="S-PARTS 코드" placeholder="S-PARTS 코드" value={moldCode}
              className="w-48" onChange={(e) => setMoldCode(e.target.value)} />
            <SupplierSelect labelPrefix="공급처" value={supplierCode}
              onChange={setSupplierCode} className="w-56" />
            <label className="text-sm">
              <span className="sr-only">적용상태</span>
              <select
                aria-label="적용상태"
                className="h-9 rounded border border-border bg-surface px-2 text-sm text-text"
                value={status}
                onChange={(e) => setStatus(e.target.value)}
              >
                {STATUS_OPTIONS.map((option) => (
                  <option key={option.value} value={option.value}>{option.label}</option>
                ))}
              </select>
            </label>
          </CardContent>
        </Card>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-end gap-3 p-3">
            <div className="flex items-center gap-2 self-center">
              <ListPlus className="h-5 w-5 text-primary" />
              <span className="text-sm font-semibold text-text">단가행 일괄생성</span>
            </div>
            <label className="text-xs text-text-muted">
              통화
              <ComCodeSelect groupCode="CURRENCY" includeAll={false}
                value={generateCurrency} onChange={setGenerateCurrency} className="w-32" />
            </label>
            <Button size="sm" variant="secondary" disabled={busy}
              onClick={() => setGenerateOpen(true)}>
              <ListPlus className="mr-1 h-4 w-4" />생성
            </Button>

            <div className="mx-2 h-9 w-px bg-border" />

            <div className="flex items-center gap-2 self-center">
              <Users className="h-5 w-5 text-primary" />
              <span className="text-sm font-semibold text-text">공급처 일괄변경</span>
            </div>
            <label className="text-xs text-text-muted">
              이전 공급처
              <SupplierSelect includeAll={false} value={beforeSupplier}
                onChange={setBeforeSupplier} className="w-48" />
            </label>
            <label className="text-xs text-text-muted">
              이후 공급처
              <SupplierSelect includeAll={false} value={afterSupplier}
                onChange={setAfterSupplier} className="w-48" />
            </label>
            <Button size="sm" variant="secondary" disabled={busy || !beforeSupplier || !afterSupplier}
              onClick={() => setChangeOpen(true)}>
              <Users className="mr-1 h-4 w-4" />변경
            </Button>
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
              exportFileName="S-PARTS구매단가"
              emptyMessage="조회 버튼을 눌러 구매단가를 확인하세요."
              onRowClick={(row) => setSelected(row as MoldPriceRow)}
              getRowId={(row) => {
                const price = row as MoldPriceRow;
                return `${price.moldCode}|${price.supplierCode}|${String(price.dateset).slice(0, 10)}`;
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <PriceFormPanel
          key={`${panel.mode}-${panel.form.moldCode}-${panel.form.supplierCode}-${panel.form.dateset}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={removePrice}
        title="구매단가 삭제"
        message={selected
          ? `${selected.moldCode} / ${selected.supplierCode} / 적용일 ${String(selected.dateset).slice(0, 10)} 단가를 삭제할까요?`
          : ''}
        variant="danger"
      />

      <ConfirmModal
        isOpen={generateOpen}
        onClose={() => setGenerateOpen(false)}
        onConfirm={generate}
        title="단가행 일괄생성"
        message="단가가 없는 (S-PARTS, 공급처) 조합에 임시단가 0원 행을 만듭니다. 적용일은 오늘, 종료일은 9999-12-31, 승인여부는 '아니오'로 시작합니다."
      />

      <ConfirmModal
        isOpen={changeOpen}
        onClose={() => setChangeOpen(false)}
        onConfirm={changeSupplier}
        title="공급처 일괄변경"
        message={`오늘 유효한 단가행의 공급처를 ${beforeSupplier} → ${afterSupplier} 로 바꿉니다.`}
        variant="danger"
      />
    </div>
  );
}
