"use client";

/**
 * @file src/app/(authenticated)/purchase/requirement/page.tsx
 * @description 477 자재소요량관리 — PB w_mat_requirment_plan_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **"이 제품을 이만큼 만들려면 자재가 얼마나 드는가"를 계산하는 화면이다.**
 *    기준계획(제품·수량)을 넣고 전개하면 BOM 을 타고 내려가 자재별 소요량이 나온다.
 * 2. **세 표를 한 화면에 같이 본다.** 왼쪽이 넣는 것(기준계획), 오른쪽이 나온 것
 *    (위: 소요량, 아래: 계획일을 가로로 편 것). 전개 결과를 바로 옆에서 확인한다.
 *    PB 는 라디오버튼으로 하나씩 바꿔 봤지만, 원인과 결과를 나란히 두는 쪽이 낫다.
 * 3. **순서가 있다.** ① 기준계획 등록 → ② 재고 표시(선택) → ③ 소요량 전개.
 * 4. **날짜가 두 개인 것이 이 화면에서 가장 헷갈리는 부분이다.**
 *    - **기준일자**: 이번 계산을 묶는 번호표. 이 값이 같은 기준계획이 한 묶음으로 전개된다.
 *    - **계획일**: 그 자재가 실제로 필요한 날. 한 묶음 안에 여러 날이 들어간다.
 *    그래서 기준일자는 화면 맨 위에 한 번만, 계획일은 입력 줄에 둔다.
 * 5. **이 화면이 내는 것은 순소요다 — 재고를 빼지 않은 총 필요량이다.**
 *    재고 차감은 478 자재발주계획이 한다 (2026-09-30 사용자 확정). 그래서 '재고 표시'
 *    버튼은 참고용 컬럼만 채우고 소요량 숫자를 바꾸지 않는다 — 의도된 동작이다.
 *    (그 버튼도 PB 에서 실재고를 읽는 부분이 주석 처리돼 안전재고만 채운다.)
 * 6. **전개는 되돌릴 수 없다.** PB 도 전개하면서 그 일자 이전의 기준계획을 함께
 *    지운다 (`<=` 조건). 버그로 보이지만 PB 와 값을 맞추려고 그대로 뒀다.
 * 7. 버튼 설명은 `data-tooltip` 으로 붙였다 (전역 툴팁 시스템).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Boxes, Download, Play, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import PlanImportModal from './components/PlanImportModal';
import RequirementPlanFormPanel from './components/RequirementPlanFormPanel';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { masterPlanColumns, requirementColumns, selectColumn } from '../purchase-columns';
import type {
  MasterPlanRow,
  RequirementMatrixRow,
  RequirementRow,
} from '../purchase-columns';
import PartSearchField from '@/components/shared/PartSearchField';

const TIP = {
  baseDate: '이번 계산을 묶는 번호표입니다. 이 날짜로 묶인 기준계획을 한 번에 전개합니다.'
    + ' 아래 "계획일"과 다릅니다 — 계획일은 그 자재가 실제로 필요한 날입니다.',
  register: '기준계획 한 줄을 오른쪽 패널에서 등록합니다. 같은 기준일자·계획일·품목이면 수량만 바뀝니다.',
  importPlan: '제품생산계획에서 골라 이 기준일자의 기준계획으로 한 번에 등록합니다. 같은 날·같은 품목은 수량을 합칩니다.',
  search: '세 표를 다시 읽어옵니다.',
  remove: '고른 기준계획 줄을 지웁니다. 왼쪽 표에서 줄을 눌러 고릅니다.',
  inventory: '기준계획 줄에 현재 재고를 참고용으로 표시합니다. 계획일이 이른 것부터'
    + ' 배정해 보여 줍니다. 소요량 숫자는 바뀌지 않습니다 — 순소요는 재고를 감안하지'
    + ' 않는 것이 맞고, 재고 차감은 자재발주계획(478) 에서 합니다.',
  explode: 'BOM 을 타고 내려가 자재별 소요량을 만듭니다. 그 기준일자의 기존 소요량은 지워지고'
    + ' 새로 만들어집니다. 이 기준일자보다 앞선 기준일자의 기준계획은 지워지고, 이 기준일자'
    + ' 계획은 품목·계획일별로 합쳐 다시 저장됩니다.',
  filter: '오른쪽 두 표(소요량·날짜별)에만 걸립니다. 왼쪽 기준계획은 기준일자로만 봅니다.',
  gridMaster: '무엇을 얼마나 만들지 넣는 표입니다. 여기서 시작합니다. 줄을 누르면 골라집니다.',
  gridRequirement: '전개 결과입니다. 자재별로 언제 얼마가 필요한지 나옵니다.',
  gridMatrix: '같은 결과를 계획일을 가로로 펴서 봅니다. 날짜별 흐름을 볼 때 씁니다.',
} as const;

const today = () => getTodayLocal();
const rowKey = (row: MasterPlanRow) =>
  `${row.planDate ?? ''}|${row.itemCode ?? ''}`;
const apiMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function RequirementPlanPage() {
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

  const [formOpen, setFormOpen] = useState(false);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [pending, setPending] = useState<'explode' | 'inventory' | 'delete' | null>(null);
  const [busy, setBusy] = useState(false);
  const [importOpen, setImportOpen] = useState(false);

  const toggleRow = useCallback((row: MasterPlanRow) => {
    const key = rowKey(row);
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key); else next.add(key);
      return next;
    });
  }, []);

  const allSelected = masterRows.length > 0 && selected.size === masterRows.length;
  const masterColumns = useMemo(() => [
    selectColumn<MasterPlanRow>({
      isSelected: (row) => selected.has(rowKey(row)),
      onToggle: toggleRow,
      allSelected,
      onToggleAll: () => setSelected(allSelected ? new Set() : new Set(masterRows.map(rowKey))),
    }),
    ...masterPlanColumns,
  ], [selected, toggleRow, allSelected, masterRows]);

  /** 세 표를 한 번에 읽는다. 원인(기준계획)과 결과(소요량)를 같이 보는 화면이다. */
  const search = useCallback(async () => {
    setLoading(true);
    try {
      const resultParams = {
        requirementPlanDate: planDate,
        supplierCode: supplierCond || undefined,
        itemCode: itemCond.trim() || undefined,
        lineType: lineTypeCond || undefined,
      };
      const [master, requirement, matrix] = await Promise.all([
        api.get('/purchase/requirement/master-plan', {
          params: { requirementPlanDate: planDate },
        }),
        api.get('/purchase/requirement', { params: resultParams }),
        api.get('/purchase/requirement/matrix', { params: resultParams }),
      ]);
      setMasterRows(master.data?.data ?? []);
      setRequirementRows(requirement.data?.data ?? []);
      setMatrixRows(matrix.data?.data ?? []);
      setMatrixDates(matrix.data?.meta?.planDates ?? []);
      setSelected(new Set());
      mark(requirement);
      setSearched(true);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [planDate, supplierCond, itemCond, lineTypeCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 계획일을 가로로 편 열. 날짜 수가 조회마다 달라 런타임에 만든다. */
  const matrixColumns = useMemo(() => [
    { accessorKey: 'itemCode', header: '품목코드', size: 140 },
    // 표 너비는 내용에 맞춰 늘어난다. 긴 품목명이 날짜 열을 밀어내지 않게 잘라 보이고 전체는 툴팁으로.
    {
      accessorKey: 'itemName',
      header: '품목명',
      size: 170,
      cell: (c: { getValue: () => unknown }) => (
        <span className="block max-w-[160px] truncate" title={String(c.getValue() ?? '')}>
          {String(c.getValue() ?? '')}
        </span>
      ),
    },
    {
      accessorKey: 'totalQty',
      header: '합계',
      size: 100,
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
      size: 90,
      meta: { align: 'right' } as const,
      accessorFn: (row: RequirementMatrixRow) => row.qtyByDate?.[date] ?? 0,
      cell: (c: { getValue: () => unknown }) => {
        const value = Number(c.getValue() ?? 0);
        return value ? value.toLocaleString() : '';
      },
    })),
  ], [matrixDates]);

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
      } else if (pending === 'explode') {
        const r = await api.post('/purchase/requirement/explode', {
          requirementPlanDate: planDate,
        });
        const d = r.data?.data ?? {};
        toast.success(
          `전개했습니다 — 기준계획 ${d.planRows ?? 0}건 → 소요량 ${d.requirementRows ?? 0}건.`,
        );
      } else {
        const r = await api.post('/purchase/requirement/inventory', {
          requirementPlanDate: planDate,
        });
        toast.success(`재고를 표시했습니다 (${r.data?.data?.planRows ?? 0}건).`);
      }
      setPending(null);
      await search();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [pending, masterRows, selected, planDate, search]);

  const confirmText = {
    explode: {
      title: '소요량 전개',
      message: `기준일자 ${planDate} 의 기준계획을 BOM 으로 펴서 소요량을 만듭니다.`
        + '\n\n· 그 기준일자의 기존 소요량은 지워지고 새로 만들어집니다.'
        + '\n· 이 기준일자보다 앞선 기준일자의 기준계획은 지워집니다.'
        + '\n· 이 기준일자 계획은 품목·계획일별로 합쳐 다시 저장됩니다.',
    },
    inventory: {
      title: '재고 표시',
      message: `기준일자 ${planDate} 의 기준계획 줄에 현재 재고를 참고용으로 채웁니다.`
        + ' 계획일이 이른 것부터 배정해 보여 줍니다.'
        + '\n\n· 소요량 숫자는 바뀌지 않습니다. 순소요는 재고를 감안하지 않습니다.'
        + '\n· 재고를 빼고 발주량을 내는 것은 자재발주계획(478) 이 합니다.'
        + '\n· 지금은 실재고를 읽지 않아 안전재고만 채워집니다.',
    },
    delete: {
      title: '기준계획 삭제',
      message: `고른 ${selected.size}건을 지웁니다.`,
    },
  }[pending ?? 'explode'];

  const count = (n: number) => (searched ? `${n.toLocaleString()}건` : '');

  return (
    // 등록 패널은 표 위에 겹쳐 띄운다 — 기준계획 고정 폭 때문에 밀어내면 오른쪽 표가 0 폭이 된다
    <div className="relative flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-3 p-6">
      <header className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-text">자재소요량관리</h1>
          <p className="mt-1 text-sm text-text-muted">
            제품 생산계획을 BOM 으로 펴서 <span className="text-text">순소요</span>를 산출합니다
            (재고를 빼지 않은 총 필요량) ·{' '}
            <span className="text-text">① 기준계획 등록 → ② 재고 표시(선택) → ③ 소요량 전개</span>
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <Button size="sm" data-tooltip={TIP.register} onClick={() => setFormOpen(true)}>
            <Plus className="mr-1 h-4 w-4" />① 기준계획 등록
          </Button>
          <Button size="sm" variant="secondary" disabled={busy}
            data-tooltip={TIP.importPlan} onClick={() => setImportOpen(true)}>
            <Download className="mr-1 h-4 w-4" />기준계획 가져오기
          </Button>
          <Button size="sm" variant="danger"
            disabled={busy || selected.size === 0}
            data-tooltip={TIP.remove}
            onClick={() => setPending('delete')}>
            <Trash2 className="mr-1 h-4 w-4" />선택 삭제 ({selected.size})
          </Button>
          <Button size="sm" variant="secondary"
            disabled={busy || masterRows.length === 0}
            data-tooltip={TIP.inventory}
            onClick={() => setPending('inventory')}>
            <Boxes className="mr-1 h-4 w-4" />② 재고 표시
          </Button>
          <Button size="sm" disabled={busy || masterRows.length === 0}
            data-tooltip={TIP.explode}
            onClick={() => setPending('explode')}>
            <Play className="mr-1 h-4 w-4" />③ 소요량 전개
          </Button>
        </div>
      </header>

      {/* 기준일자 — 이 화면 전체를 묶는 값이라 맨 위에 한 번만 둔다 */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <label className="text-sm font-semibold text-text" htmlFor="base-date"
            data-tooltip={TIP.baseDate}>
            기준일자
          </label>
          <Input id="base-date" type="date" value={planDate} className="w-40"
            data-tooltip={TIP.baseDate}
            onChange={(e) => setPlanDate(e.target.value)} />

          <span className="mx-2 h-4 w-px bg-border" />
          <span className="text-sm text-text-muted" data-tooltip={TIP.filter}>
            오른쪽 표 걸러보기
          </span>
          <SupplierSelect aria-label="공급처" includeAll labelPrefix="공급처"
            value={supplierCond} className="w-44" onChange={setSupplierCond} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCond}
            className="w-36" onChange={(e) => setItemCond(e.target.value)} />
          <ComCodeSelect groupCode="LINE TYPE" labelPrefix="거래유형"
            aria-label="거래유형" value={lineTypeCond} className="w-36"
            onChange={setLineTypeCond} />

          <Button size="sm" variant="secondary" className="ml-auto"
            data-tooltip={TIP.search}
            onClick={() => search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      {/* 왼쪽 넣는 것 / 오른쪽 나온 것 (위: 소요량, 아래: 날짜별) */}
      {/* 기준계획은 고정 폭 — 창이 좁아져도 줄지 않고 오른쪽(소요량)이 줄어든다 */}
      <div className="grid min-h-0 flex-1 gap-3 lg:grid-cols-[640px_minmax(0,1fr)]">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col p-3">
            <div className="min-h-0 flex-1">
              <DataGrid
                toolbarLeft={(
                  <span className="text-sm font-semibold text-text"
                    data-tooltip={`${TIP.gridMaster} 맨 앞 체크박스나 줄을 누르면 골라집니다.`}>
                    ① 기준계획 {count(masterRows.length)}
                  </span>
                )}
                data={masterRows}
                columns={masterColumns}
                isLoading={loading}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="기준계획"
                emptyMessage={searched
                  ? '이 기준일자에 기준계획이 없습니다. ① 기준계획 등록이나 가져오기로 넣으세요.'
                  : '조회하세요.'}
                onRowClick={(row) => toggleRow(row as MasterPlanRow)}
                rowClassName={(row) => (selected.has(rowKey(row as MasterPlanRow))
                  ? 'bg-primary/15' : '')}
              />
            </div>
          </CardContent>
        </Card>

        <div className="flex min-h-0 flex-col gap-3">
          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="flex h-full flex-col p-3">
              <div className="min-h-0 flex-1">
                <DataGrid
                  toolbarLeft={(
                    <span className="text-sm font-semibold text-text" data-tooltip={TIP.gridRequirement}>
                      ③ 소요량 {count(requirementRows.length)}
                    </span>
                  )}
                  data={requirementRows}
                  columns={requirementColumns}
                  isLoading={loading}
                  pageSize={100}
                  enableColumnFilter
                  enableExport
                  exportFileName="자재소요량"
                  emptyMessage={searched
                    ? '소요량이 없습니다. ③ 소요량 전개를 먼저 실행하세요.'
                    : '조회하세요.'}
                />
              </div>
            </CardContent>
          </Card>

          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="flex h-full flex-col p-3">
              <div className="min-h-0 flex-1">
                <DataGrid
                  toolbarLeft={(
                    <span className="text-sm font-semibold text-text" data-tooltip={TIP.gridMatrix}>
                      ③ 소요량 (날짜별) {count(matrixRows.length)}
                      {matrixDates.length > 0 && (
                        <span className="ml-2 text-xs font-normal text-text-muted">계획일 {matrixDates.length}개</span>
                      )}
                    </span>
                  )}
                  data={matrixRows}
                  columns={matrixColumns}
                  isLoading={loading}
                  pageSize={100}
                  enableColumnFilter
                  enableExport
                  exportFileName="소요량매트릭스"
                  fillWidth={false}
                  emptyMessage={searched
                    ? '소요량이 없습니다. ③ 소요량 전개를 먼저 실행하세요.'
                    : '조회하세요.'}
                />
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      </main>

      {formOpen && (
        <div className="absolute inset-y-0 right-0 z-20">
        <RequirementPlanFormPanel
          requirementPlanDate={planDate}
          onClose={() => setFormOpen(false)}
          onSaved={() => { void search(); }}
        />
        </div>
      )}

      <PlanImportModal
        isOpen={importOpen}
        onClose={() => setImportOpen(false)}
        requirementPlanDate={planDate}
        onImported={() => { void search(); }}
      />

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
