"use client";

/**
 * @file src/app/(authenticated)/warehouse/solder-label/page.tsx
 * @description 솔더라벨 발행 — PB w_mat_receipt_slip_master_onetek_solder 이식
 *
 * 초보자 가이드:
 * 1. **솔더 통에 붙일 라벨을 찍는 화면이다.** 전표를 새로 만들고 그 전표에 딸린
 *    라벨 장수만큼 바코드를 만든다. **입고는 여기서 생기지 않는다** — 그 라벨을
 *    나중에 자재바코드입고관리(237)에서 대조할 때 입고가 된다.
 * 2. **라벨 바코드는 11자 고정이다.** `종류(1) + YYMMDD(6) + 그날 일련번호(3) +
 *    공장(1)` — 예 `S260928120A`. 무연(F)은 앞자리를 `S` 로 찍는다.
 * 3. **하루 999장이 상한이다.** 세 자리가 넘치면 다음 날 번호를 잘못 읽어 바코드가
 *    겹친다. PB 는 경고만 하고 그냥 찍었지만 여기서는 거절한다.
 * 4. **찍을 바코드를 미리 보여준다.** 화면과 서버가 같은 규칙 함수(`@smt/shared`)를
 *    쓰므로 보여준 것과 실제로 들어가는 것이 같다. 다만 미리 보기와 발행 사이에
 *    다른 사람이 찍으면 번호가 밀린다 — 서버가 발행 순간에 다시 읽어 계산한다.
 * 5. **장수·수량 규칙은 자재입고전표관리(235)와 같다.** 수동 분할 목록을 적으면
 *    장마다 다른 수량, 안 적으면 장수 × 한 통 수량이다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Search, Tags } from 'lucide-react';
import {
  buildSolderBarcode,
  checkReelPlan,
  checkSolderLabelPlan,
  planReelQuantities,
  SOLDER_FACTORIES,
  totalReelQty,
} from '@smt/shared';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { solderLabelColumns, solderSlipColumns } from '../solder-label-columns';
import type {
  SolderIssueContext,
  SolderIssueResult,
  SolderLabelRow,
  SolderSlipRow,
} from '../solder-label-columns';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

const FACTORY_OPTIONS = SOLDER_FACTORIES.map((f) => ({ value: f, label: `공장 ${f}` }));

/** 수동 분할 입력을 숫자 목록으로 바꾼다 (쉼표·공백·줄바꿈 구분). */
const parseDivide = (text: string) => text
  .split(/[\s,]+/)
  .filter((s) => s.length > 0)
  .map((s) => Number(s))
  .filter((n) => Number.isFinite(n));

export default function SolderLabelPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(30));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [slipNoCond, setSlipNoCond] = useState('');
  const [itemCodeCond, setItemCodeCond] = useState('');

  const [slips, setSlips] = useState<SolderSlipRow[]>([]);
  const [labels, setLabels] = useState<SolderLabelRow[]>([]);
  const [selected, setSelected] = useState<SolderSlipRow | null>(null);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 발행(쓰기)
  const [itemCode, setItemCode] = useState('');
  const [factory, setFactory] = useState<string>(SOLDER_FACTORIES[0]);
  const [reelQty, setReelQty] = useState('');
  const [unitQty, setUnitQty] = useState('');
  const [divideText, setDivideText] = useState('');
  const [validDate, setValidDate] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [supplierBarcode, setSupplierBarcode] = useState('');
  const [context, setContext] = useState<SolderIssueContext | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/warehouse/solder-label', {
        params: {
          dateFrom,
          dateTo,
          itemCode: itemCodeCond || undefined,
          slipNo: slipNoCond || undefined,
        },
      });
      setSlips(r.data?.data ?? []);
      setLabels([]);
      setSelected(null);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '전표 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, itemCodeCond, slipNoCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 전표를 고르면 그 전표로 찍힌 라벨을 본다. */
  const selectSlip = useCallback(async (row: SolderSlipRow) => {
    setSelected(row);
    try {
      const r = await api.get('/warehouse/solder-label/barcodes', {
        params: { slipNo: row.receiptSlipNo, itemCode: row.itemCode },
      });
      setLabels(r.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '라벨 조회에 실패했습니다.');
      setLabels([]);
    }
  }, []);

  /** 품목·공장이 정해지면 그날 마지막 일련번호를 받아 미리 보기를 만든다. */
  const loadContext = useCallback(async () => {
    const code = itemCode.trim();
    if (!code) { setContext(null); return; }
    try {
      const r = await api.get('/warehouse/solder-label/context', {
        params: { itemCode: code, factory },
      });
      setContext((r.data?.data as SolderIssueContext) ?? null);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '품목 확인에 실패했습니다.');
      setContext(null);
    }
  }, [itemCode, factory]);

  // 화면과 서버가 **같은 함수**로 계획을 만든다 — 보여준 것과 들어가는 것이 같다.
  const plan = useMemo(() => {
    const divideQty = parseDivide(divideText);
    const input = divideQty.length > 0
      ? { divideQty }
      : { reelQty: Number(reelQty) || 0, unitQty: Number(unitQty) || 0 };
    const quantities = planReelQuantities(input);
    const labelVerdict = context
      ? checkSolderLabelPlan({
        solderType: context.item?.solderType,
        dateYymmdd: context.dateYymmdd,
        lastSequence: context.lastSequence,
        count: quantities.length,
        factory,
      })
      : { ok: false, reason: '품목을 확인하세요.' };
    const preview = context && labelVerdict.ok
      ? quantities.map((_, i) => buildSolderBarcode(
        context.solderTypeCode, context.dateYymmdd, context.lastSequence + i + 1, factory))
      : [];
    return {
      input,
      quantities,
      total: totalReelQty(input),
      planVerdict: checkReelPlan(input),
      labelVerdict,
      preview,
    };
  }, [divideText, reelQty, unitQty, context, factory]);

  const blocker = useMemo(() => {
    if (!itemCode.trim()) return '품목코드를 넣으세요.';
    if (!context) return '품목을 확인하세요 (확인 버튼).';
    if (context.item?.itemClass !== 'SOLDER') return '솔더 품목이 아닙니다.';
    if (!plan.planVerdict.ok) return plan.planVerdict.reason ?? null;
    if (!plan.labelVerdict.ok) return plan.labelVerdict.reason ?? null;
    return null;
  }, [itemCode, context, plan]);

  /** 전표 생성 + 라벨 발행 (쓰기). */
  const issue = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const divideQty = parseDivide(divideText);
      const r = await api.post('/warehouse/solder-label/issue', {
        itemCode: itemCode.trim(),
        factory,
        ...(divideQty.length > 0
          ? { divideQty }
          : { reelQty: Number(reelQty), unitQty: Number(unitQty) }),
        totalQty: plan.total,
        validDate: validDate || undefined,
        supplierCode: supplierCode.trim() || undefined,
        supplierBarcode: supplierBarcode.trim() || undefined,
      });
      const result = r.data?.data as SolderIssueResult | undefined;
      toast.success(
        `${result?.issued}장 발행했습니다: ${result?.firstBarcode} ~ ${result?.lastBarcode}`
        + ` (전표 ${result?.slipNo})`,
      );
      void search();
      void loadContext();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '라벨 발행에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [divideText, itemCode, factory, reelQty, unitQty, plan.total, validDate,
    supplierCode, supplierBarcode, search, loadContext]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">솔더라벨 발행</h1>
        <p className="mt-1 text-sm text-text-muted">
          솔더 통에 붙일 라벨을 찍습니다. 입고는 자재바코드입고관리에서 대조할 때 생깁니다 ·{' '}
          {searched ? `전표 ${slips.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="전표일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCodeCond}
            className="w-44"
            onChange={(e) => setItemCodeCond(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="전표번호" placeholder="전표번호" value={slipNoCond}
            className="w-44"
            onChange={(e) => setSlipNoCond(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-[1fr_360px]">
        <div className="flex min-h-0 flex-col gap-4">
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={slips}
                columns={solderSlipColumns}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="솔더전표"
                enableColumnPinning
                defaultPinnedColumns={{ left: ['receiptSlipNo'] }}
                emptyMessage={searched ? '조건에 맞는 전표가 없습니다.' : '조회하세요.'}
                onRowClick={(row) => void selectSlip(row as SolderSlipRow)}
              />
            </CardContent>
          </Card>

          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="h-full p-3">
              <DataGrid
                data={labels}
                columns={solderLabelColumns}
                pageSize={50}
                enableExport
                exportFileName="솔더라벨"
                emptyMessage={selected
                  ? '이 전표로 찍힌 라벨이 없습니다.'
                  : '위에서 전표를 고르세요.'}
              />
            </CardContent>
          </Card>
        </div>

        {/* 발행 패널 (쓰기) */}
        <Card className="min-h-0 overflow-auto" padding="none">
          <CardContent className="flex flex-col gap-3 p-3">
            <h2 className="flex items-center gap-1 text-sm font-semibold text-text">
              <Tags className="h-4 w-4" />라벨 발행
            </h2>

            <div className="flex gap-2">
              <Input aria-label="품목코드" placeholder="솔더 품목코드" value={itemCode}
                onChange={(e) => setItemCode(e.target.value)}
                onKeyDown={(e) => { if (e.key === 'Enter') void loadContext(); }} />
              <Button size="sm" variant="secondary" onClick={loadContext}
                disabled={!itemCode.trim()}>
                확인
              </Button>
            </div>
            <Select options={FACTORY_OPTIONS} value={factory} onChange={setFactory} />

            {context && (
              <div className="rounded border border-border bg-surface-muted px-3 py-2 text-sm">
                <div>{context.item?.itemName ?? '품목 없음'}
                  {context.item?.itemSpec ? ` · ${context.item.itemSpec}` : ''}</div>
                <div className="mt-1 text-text-muted">
                  종류 {context.item?.solderType ?? '-'} → 바코드 앞자리{' '}
                  <b>{context.solderTypeCode || '없음'}</b> · 오늘{' '}
                  {context.dateYymmdd} · 이미 <b>{context.lastSequence}</b>장 발행됨
                </div>
              </div>
            )}

            <Input label="한 통 수량" value={unitQty} inputMode="numeric"
              onChange={(e) => setUnitQty(e.target.value)} />
            <Input label="라벨 장수" value={reelQty} inputMode="numeric"
              onChange={(e) => setReelQty(e.target.value)} />
            <Input label="수동 분할 (쉼표로 구분 · 넣으면 위 두 값을 무시)"
              value={divideText}
              placeholder="예: 300, 200"
              onChange={(e) => setDivideText(e.target.value)} />
            <Input label="유효기한" type="date" value={validDate}
              onChange={(e) => setValidDate(e.target.value)} />
            <Input label="협력사코드" value={supplierCode}
              onChange={(e) => setSupplierCode(e.target.value)} />
            <Input label="협력사 바코드" value={supplierBarcode}
              onChange={(e) => setSupplierBarcode(e.target.value)} />

            {/* 미리 보기 — 화면과 서버가 같은 함수를 쓴다 */}
            {plan.preview.length > 0 && (
              <div className="rounded border border-border bg-surface-muted px-3 py-2 text-sm">
                <div>
                  <b>{plan.quantities.length}</b>장 · 합계{' '}
                  <b>{plan.total.toLocaleString()}</b>
                </div>
                <div className="mt-1 font-mono text-xs text-text-muted">
                  {plan.preview[0]}
                  {plan.preview.length > 1 && ` ~ ${plan.preview[plan.preview.length - 1]}`}
                </div>
                <div className="mt-1 text-xs text-text-muted">
                  수량 {plan.quantities.slice(0, 8).map((q) => q.toLocaleString()).join(' · ')}
                  {plan.quantities.length > 8 && ' …'}
                </div>
              </div>
            )}

            {blocker && (
              <p className="flex items-start gap-1 text-sm text-amber-500">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />{blocker}
              </p>
            )}

            <Button disabled={busy || Boolean(blocker)} onClick={() => setConfirmOpen(true)}>
              전표 생성 + 라벨 발행
            </Button>
            <p className="text-xs text-text-muted">
              하루 999장까지 찍을 수 있습니다. 발행 순간에 번호를 다시 읽으므로 다른
              사람이 먼저 찍으면 미리 보기와 번호가 밀릴 수 있습니다.
            </p>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={issue}
        title="솔더라벨 발행"
        message={`${itemCode} · ${plan.quantities.length}장 (합계`
          + ` ${plan.total.toLocaleString()})을 발행합니다.`
          + ` 전표가 새로 만들어집니다. 되돌릴 수 없습니다.`}
        confirmText="발행"
      />
    </div>
  );
}
