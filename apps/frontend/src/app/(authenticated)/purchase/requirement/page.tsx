"use client";

/**
 * @file src/app/(authenticated)/purchase/requirement/page.tsx
 * @description 477 자재소요량관리 — PB w_mat_requirment_plan_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **"이 제품을 이만큼 만들려면 자재가 얼마나 드는가"를 계산하는 화면이다.**
 *    기준계획(제품·수량)을 넣고 전개하면 BOM 을 타고 내려가 자재별 소요량이 나온다.
 * 2. **순서가 있다.** 기준계획 등록 → (재고 반영) → 소요량 전개. 전개는 그 일자의
 *    소요량표를 통째로 갈아끼운다.
 * 3. **전개는 되돌릴 수 없다.** PB 도 전개하면서 그 일자 이전의 기준계획을 함께
 *    지운다 (`<=` 조건). 버그로 보이지만 PB 와 값을 맞추려고 그대로 뒀다.
 * 4. **재고 반영은 안전재고만 채운다.** PB 에서 실재고를 읽는 부분이 주석 처리돼
 *    있어서다. 실재고를 쓰려면 현장 합의가 먼저다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Boxes, FilePlus, Play, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import ScreenTabs from '@/components/shared/ScreenTabs';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { masterPlanColumns, requirementColumns } from '../purchase-columns';
import type {
  MasterPlanRow,
  RequirementMatrixRow,
  RequirementRow,
} from '../purchase-columns';

type Tab = 'master' | 'requirement' | 'matrix';

const today = () => new Date().toISOString().slice(0, 10);
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function RequirementPlanPage() {
  const [tab, setTab] = useState<Tab>('master');
  const [planDate, setPlanDate] = useState(today());
  const [supplierCond, setSupplierCond] = useState('');
  const [itemCond, setItemCond] = useState('');
  const [lineTypeCond, setLineTypeCond] = useState('');

  const [masterRows, setMasterRows] = useState<MasterPlanRow[]>([]);
  const [requirementRows, setRequirementRows] = useState<RequirementRow[]>([]);
  const [matrixRows, setMatrixRows] = useState<RequirementMatrixRow[]>([]);
  const [matrixDates, setMatrixDates] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 기준계획 등록 폼
  const [itemCode, setItemCode] = useState('');
  const [rowPlanDate, setRowPlanDate] = useState(today());
  const [orderQty, setOrderQty] = useState('');
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [pending, setPending] = useState<'explode' | 'inventory' | 'delete' | null>(null);
  const [busy, setBusy] = useState(false);

  const rowKey = (row: MasterPlanRow) =>
    `${row.planDate ?? ''}|${row.itemCode ?? ''}`;

  const search = useCallback(async (nextTab: Tab = tab) => {
    setLoading(true);
    try {
      if (nextTab === 'master') {
        const r = await api.get('/purchase/requirement/master-plan', {
          params: { requirementPlanDate: planDate },
        });
        setMasterRows(r.data?.data ?? []);
        setSelected(new Set());
        mark(r);
      } else {
        const params = {
          requirementPlanDate: planDate,
          supplierCode: supplierCond || undefined,
          itemCode: itemCond.trim() || undefined,
          lineType: lineTypeCond || undefined,
        };
        if (nextTab === 'requirement') {
          const r = await api.get('/purchase/requirement', { params });
          setRequirementRows(r.data?.data ?? []);
          mark(r);
        } else {
          const r = await api.get('/purchase/requirement/matrix', { params });
          setMatrixRows(r.data?.data ?? []);
          setMatrixDates(r.data?.meta?.planDates ?? []);
          mark(r);
        }
      }
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, planDate, supplierCond, itemCond, lineTypeCond, mark]);

  useEffect(() => { void search('master'); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 탭을 바꾸면 이전 결과를 비운다 — PB 라디오버튼도 그랬다. */
  const changeTab = useCallback((nextTab: Tab) => {
    setTab(nextTab);
    setSearched(false);
    setSelected(new Set());
    void search(nextTab);
  }, [search]);

  /** 계획일을 가로로 편 열. 날짜 수가 조회마다 달라 런타임에 만든다. */
  const matrixColumns = useMemo(() => [
    { accessorKey: 'itemCode', header: '품목코드', size: 150 },
    { accessorKey: 'itemName', header: '품목명', size: 200 },
    { accessorKey: 'supplierName', header: '공급처', size: 150 },
    {
      accessorKey: 'totalQty',
      header: '합계',
      size: 110,
      meta: { align: 'right' } as const,
      cell: (c: { getValue: () => unknown }) => (
        <span className="font-semibold">
          {Number(c.getValue() ?? 0).toLocaleString()}
        </span>
      ),
    },
    ...matrixDates.map((date) => ({
      id: date,
      header: date.slice(5),
      size: 100,
      meta: { align: 'right' } as const,
      accessorFn: (row: RequirementMatrixRow) => row.qtyByDate?.[date] ?? 0,
      cell: (c: { getValue: () => unknown }) => {
        const value = Number(c.getValue() ?? 0);
        return value ? value.toLocaleString() : '';
      },
    })),
  ], [matrixDates]);

  const qty = Number(orderQty);
  const blocker = !itemCode.trim()
    ? '품목을 넣으세요.'
    : !Number.isFinite(qty) || qty < 0
      ? '주문수량은 0 이상입니다.'
      : null;

  const saveRow = useCallback(async () => {
    if (blocker) return;
    setBusy(true);
    try {
      await api.post('/purchase/requirement/master-plan', {
        requirementPlanDate: planDate,
        planDate: rowPlanDate,
        itemCode: itemCode.trim(),
        orderQty: qty,
      });
      toast.success('기준계획을 저장했습니다.');
      setItemCode('');
      setOrderQty('');
      await search('master');
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [blocker, planDate, rowPlanDate, itemCode, qty, search]);

  const run = useCallback(async () => {
    if (!pending) return;
    setBusy(true);
    try {
      if (pending === 'delete') {
        const rows = masterRows
          .filter((row) => selected.has(rowKey(row)))
          .map((row) => ({
            requirementPlanDate: planDate,
            planDate: row.planDate,
            itemCode: row.itemCode,
          }));
        const r = await api.delete('/purchase/requirement/master-plan', { data: { rows } });
        toast.success(`${r.data?.data?.deleted ?? rows.length}건 지웠습니다.`);
        await search('master');
      } else if (pending === 'explode') {
        const r = await api.post('/purchase/requirement/explode', {
          requirementPlanDate: planDate,
        });
        const d = r.data?.data ?? {};
        toast.success(
          `전개했습니다 — 기준계획 ${d.planRows ?? 0}건 → 소요량 ${d.requirementRows ?? 0}건.`,
        );
        changeTab('requirement');
      } else {
        const r = await api.post('/purchase/requirement/inventory', {
          requirementPlanDate: planDate,
        });
        toast.success(`재고를 반영했습니다 (${r.data?.data?.planRows ?? 0}건).`);
        await search('master');
      }
      setPending(null);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [pending, masterRows, selected, planDate, search, changeTab]);

  const confirmText = {
    explode: {
      title: '소요량 전개',
      message: `${planDate} 기준계획을 BOM 으로 펴서 소요량표를 만듭니다.`
        + ' 그 일자의 기존 소요량은 지워집니다.'
        + ' PB 와 같은 동작이라, 그 일자 **이전**의 기준계획도 함께 지워집니다.',
    },
    inventory: {
      title: '재고 반영',
      message: `${planDate} 기준계획에 재고를 배정합니다.`
        + ' PB 에서 실재고를 읽는 부분이 막혀 있어 안전재고만 채워집니다.',
    },
    delete: {
      title: '기준계획 삭제',
      message: `고른 ${selected.size}건을 지웁니다.`,
    },
  }[pending ?? 'explode'];

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재소요량관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          기준계획을 BOM 으로 펴서 자재 소요량을 산출합니다 ·{' '}
          {searched
            ? `${(tab === 'master' ? masterRows.length
              : tab === 'requirement' ? requirementRows.length
                : matrixRows.length).toLocaleString()}건`
            : '조회하세요'}
        </p>
      </header>

      <ScreenTabs<Tab>
        active={tab}
        onChange={changeTab}
        tabs={[
          { key: 'master', label: '기준계획' },
          { key: 'requirement', label: '소요량' },
          { key: 'matrix', label: '소요량 매트릭스' },
        ]}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <label className="text-sm font-semibold text-text" htmlFor="requirement-date">
            소요일자
          </label>
          <Input id="requirement-date" type="date" value={planDate}
            className="w-40" onChange={(e) => setPlanDate(e.target.value)} />
          {tab !== 'master' && (
            <>
              <SupplierSelect aria-label="공급처" includeAll labelPrefix="공급처"
                value={supplierCond} className="w-48" onChange={setSupplierCond} />
              <Input aria-label="품목코드" placeholder="품목코드" value={itemCond}
                className="w-40" onChange={(e) => setItemCond(e.target.value)} />
              <ComCodeSelect groupCode="LINE TYPE" labelPrefix="거래유형"
                aria-label="거래유형" value={lineTypeCond} className="w-40"
                onChange={setLineTypeCond} />
            </>
          )}
          <Button size="sm" onClick={() => search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      {tab === 'master' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <FilePlus className="h-4 w-4" />기준계획
            </span>
            <Input aria-label="계획일" type="date" value={rowPlanDate}
              className="w-40" onChange={(e) => setRowPlanDate(e.target.value)} />
            <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
              className="w-40" onChange={(e) => setItemCode(e.target.value)} />
            <Input aria-label="주문수량" type="number" min={0} placeholder="주문수량"
              value={orderQty} className="w-32"
              onChange={(e) => setOrderQty(e.target.value)} />
            <Button size="sm" disabled={busy || Boolean(blocker)} onClick={saveRow}>
              저장
            </Button>
            {blocker && itemCode && (
              <span className="flex items-center gap-1 text-sm text-amber-500">
                <AlertTriangle className="h-4 w-4" />{blocker}
              </span>
            )}

            <span className="ml-auto flex items-center gap-3">
              <Button size="sm" variant="danger"
                disabled={busy || selected.size === 0}
                onClick={() => setPending('delete')}>
                선택 삭제 ({selected.size})
              </Button>
              <Button size="sm" variant="secondary" disabled={busy || masterRows.length === 0}
                onClick={() => setPending('inventory')}>
                <Boxes className="mr-1 h-4 w-4" />재고 반영
              </Button>
              <Button size="sm" disabled={busy || masterRows.length === 0}
                onClick={() => setPending('explode')}>
                <Play className="mr-1 h-4 w-4" />소요량 전개
              </Button>
            </span>
          </CardContent>
        </Card>
      )}

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'master' && (
            <DataGrid
              data={masterRows}
              columns={masterPlanColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="기준계획"
              emptyMessage={searched ? '이 일자에 기준계획이 없습니다.' : '조회하세요.'}
              onRowClick={(row) => {
                const key = rowKey(row as MasterPlanRow);
                setSelected((prev) => {
                  const next = new Set(prev);
                  if (next.has(key)) next.delete(key); else next.add(key);
                  return next;
                });
              }}
              rowClassName={(row) => (selected.has(rowKey(row as MasterPlanRow))
                ? 'bg-primary/10' : '')}
            />
          )}
          {tab === 'requirement' && (
            <DataGrid
              data={requirementRows}
              columns={requirementColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재소요량"
              emptyMessage={searched ? '이 일자에 소요량이 없습니다. 전개했는지 확인하세요.' : '조회하세요.'}
            />
          )}
          {tab === 'matrix' && (
            <DataGrid
              data={matrixRows}
              columns={matrixColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="소요량매트릭스"
              emptyMessage={searched ? '이 일자에 소요량이 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={Boolean(pending)}
        onClose={() => setPending(null)}
        onConfirm={run}
        title={confirmText.title}
        message={confirmText.message}
        confirmText={confirmText.title}
      />
    </div>
  );
}
