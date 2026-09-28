"use client";

/**
 * @file src/app/(authenticated)/process-transaction/magazine-split/page.tsx
 * @description 230 매거진라벨 분할 — PB w_pln_product_magazine_label_split_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **상자 하나를 여러 상자로 쪼갠다.** 400개 매거진에서 50개가 불량이면
 *    350(정상) + 50(불량) 두 라벨이 된다.
 * 2. **수량은 절대 늘지 않는다.** 잔량 + 분할 + 불량 + 폐기 = 원본 수량이다.
 *    화면이 미리 보여 주는 조각과 실제로 들어가는 조각이 같은 함수로 계산된다.
 * 3. **원본 라벨은 없어진다.** 이력표로 옮겨지고 목록에서 사라진다. 새 조각에는
 *    원본 라벨번호가 남아 되짚을 수 있다.
 * 4. **공정 재고도 같이 갈라진다.** 마지막에 DB 프로시저가 공정 투입 이력을
 *    조각에 맞춰 나눈다 — 실패하면 분할 전체가 취소된다.
 * 5. **현장은 이 화면을 거의 쓰지 않는다** — 분할된 라벨이 6년간 6건이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, ScanLine, Scissors, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { LABEL_TYPE_NAME, magazineSplitColumns } from '../magazine-columns';
import type { MagazineSplitRow } from '../magazine-columns';

interface SplitTarget {
  magazineLabelNo: string;
  runNo: string | null;
  itemCode: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  pcbItem: string | null;
  lotQty: number | null;
  magazineSetNo: string | null;
  receiptDate: string | null;
}

/** 이번 달 1일 / 오늘 — 분할은 드물어 기간을 넓게 잡는다. */
const today = () => new Date().toISOString().slice(0, 10);
const yearStart = () => `${new Date().getFullYear()}-01-01`;

export default function MagazineSplitPage() {
  const [dateFrom, setDateFrom] = useState(yearStart());
  const [dateTo, setDateTo] = useState(today());
  const [rows, setRows] = useState<MagazineSplitRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const [scan, setScan] = useState('');
  const [target, setTarget] = useState<SplitTarget | null>(null);
  const [divideQty, setDivideQty] = useState('');
  const [ngQty, setNgQty] = useState('');
  const [destroyQty, setDestroyQty] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/process-transaction/magazine-split', {
        params: { dateFrom, dateTo },
      });
      setRows(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const lookup = useCallback(async () => {
    const value = scan.trim();
    if (!value) return;
    try {
      const r = await api.post('/process-transaction/magazine-split/lookup', {
        magazineLabelNo: value,
      });
      const data = r.data?.data as {
        label: SplitTarget | null;
        splittable: boolean;
        reason: string | null;
      };
      if (!data?.splittable) {
        toast.error(data?.reason ?? '나눌 수 없는 라벨입니다.');
        setTarget(null);
        return;
      }
      setTarget(data.label);
      setDivideQty('');
      setNgQty('');
      setDestroyQty('');
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
      setTarget(null);
    }
  }, [scan]);

  const lotQty = Number(target?.lotQty ?? 0);
  const divide = Number(divideQty || 0);
  const ng = Number(ngQty || 0);
  const destroy = Number(destroyQty || 0);
  const taken = divide + ng + destroy;
  const remain = lotQty - taken;

  /** 서버와 같은 순서로 조각을 미리 보여 준다 — 잔량 → 분할 → 불량 → 폐기. */
  const pieces = (() => {
    if (!target || taken <= 0 || taken > lotQty) return [];
    const out: { type: string; qty: number }[] = [];
    if (remain > 0) out.push({ type: 'P', qty: remain });
    if (divide > 0) out.push({ type: 'P', qty: divide });
    if (ng > 0) out.push({ type: 'B', qty: ng });
    if (destroy > 0) out.push({ type: 'D', qty: destroy });
    return out;
  })();

  const blocker = !target
    ? '나눌 라벨을 먼저 찍으세요.'
    : [divide, ng, destroy].some((v) => !Number.isFinite(v) || v < 0)
      ? '수량에 음수를 넣을 수 없습니다.'
      : taken === 0
        ? '나눌 수량을 넣으세요.'
        : taken > lotQty
          ? `나눌 수량 합(${taken})이 원본 수량(${lotQty})보다 많습니다.`
          : null;

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    if (!target) return;
    setBusy(true);
    try {
      const r = await api.post('/process-transaction/magazine-split', {
        magazineLabelNo: target.magazineLabelNo,
        divideQty: divide,
        ngQty: ng,
        destroyQty: destroy,
      });
      const result = r.data?.data as {
        created?: { magazineLabelNo: string; qty: number }[];
        magazineSetNo?: string;
      };
      toast.success(
        `${(result?.created ?? []).length}조각으로 나눴습니다:`
        + ` ${(result?.created ?? []).map((c) => `${c.magazineLabelNo}(${c.qty})`).join(', ')}`,
      );
      setTarget(null);
      setScan('');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '분할에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [target, divide, ng, destroy, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">매거진라벨 분할</h1>
        <p className="mt-1 text-sm text-text-muted">
          상자 하나를 여러 상자로 나눕니다 (수량은 늘지 않습니다) ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 분할 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <ScanLine className="h-4 w-4" />나눌 라벨
            </span>
            <Input aria-label="매거진라벨번호" placeholder="매거진라벨번호"
              value={scan} className="w-56" autoFocus
              onChange={(e) => setScan(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void lookup(); }} />
            <Button size="sm" onClick={lookup}>조회</Button>
            {target && (
              <span className="text-sm text-text-muted">
                {target.modelName} · {target.lineName ?? target.lineCode} · 수량{' '}
                <span className="font-semibold text-text">
                  {lotQty.toLocaleString()}
                </span>
              </span>
            )}
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <Scissors className="h-4 w-4" />나눌 수량
            </span>
            <Input aria-label="분할 수량" placeholder="분할(정상)" value={divideQty}
              className="w-32" inputMode="numeric" disabled={!target}
              onChange={(e) => setDivideQty(e.target.value)} />
            <Input aria-label="불량 수량" placeholder="불량" value={ngQty}
              className="w-28" inputMode="numeric" disabled={!target}
              onChange={(e) => setNgQty(e.target.value)} />
            <Input aria-label="폐기 수량" placeholder="폐기" value={destroyQty}
              className="w-28" inputMode="numeric" disabled={!target}
              onChange={(e) => setDestroyQty(e.target.value)} />
            {pieces.length > 0 && (
              <span className="text-sm text-text-muted">
                조각 {pieces.length}개 ={' '}
                <span className="font-semibold text-text">
                  {pieces.map((p) => `${LABEL_TYPE_NAME[p.type]} ${p.qty}`).join(' + ')}
                </span>
                {' '}= {lotQty.toLocaleString()}
              </span>
            )}
            <Button size="sm" disabled={busy || Boolean(blocker)}
              onClick={() => setConfirmOpen(true)}>
              분할
            </Button>
            {blocker && target && (
              <span className="flex items-center gap-1 text-sm text-amber-500">
                <AlertTriangle className="h-4 w-4" />{blocker}
              </span>
            )}
          </div>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="시작일" type="date" value={dateFrom} className="w-44"
            onChange={(e) => setDateFrom(e.target.value)} />
          <span className="text-text-muted">~</span>
          <Input aria-label="종료일" type="date" value={dateTo} className="w-44"
            onChange={(e) => setDateTo(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {searched && rows.length === 0 && (
            <span className="text-sm text-text-muted">
              이 기간에 분할된 라벨이 없습니다 — 현장에서 드물게 쓰는 기능입니다.
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={magazineSplitColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="매거진라벨분할"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['magazineLabelNo'] }}
            emptyMessage={searched ? '분할 이력이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="매거진라벨 분할"
        message={`${target?.magazineLabelNo ?? ''} (${lotQty.toLocaleString()}) 를`
          + ` ${pieces.map((p) => `${LABEL_TYPE_NAME[p.type]} ${p.qty}`).join(' + ')}`
          + ' 로 나눕니다. 원본 라벨은 이력표로 옮겨지고 사라집니다.'
          + ' 공정 재고도 함께 갈라집니다.'}
        confirmText="분할"
      />
    </div>
  );
}
