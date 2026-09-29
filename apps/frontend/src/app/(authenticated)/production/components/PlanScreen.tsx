"use client";

/**
 * @file src/app/(authenticated)/production/components/PlanScreen.tsx
 * @description 제품생산계획(MI)·반제품생산계획(SMD) 공용 화면
 *              PB w_pln_product_master_plan_master / w_pln_assembly_master_plan_master
 *
 * 초보자 가이드:
 * 1. **두 화면은 조회조건·그리드·확정처리가 같다.** 다른 것은 API 경로와
 *    MI 의 공정코드 / SMD 의 교대·생산유형뿐이라 설정으로 받는다.
 *    한쪽만 고쳐지는 일을 막으려고 화면을 하나로 둔다.
 * 2. **시간대 보기**를 켜면 10칸(계획/실적)이 그리드 뒤에 붙는다. 컬럼이 20개
 *    늘어나 기본은 끈 상태다.
 * 3. **롯트카드 컬럼이 '미발행' 이 아니면 그 계획은 지울 수 없다.** 서버가
 *    거부한다 — 롯트카드가 없는 계획을 가리키게 되기 때문이다.
 * 4. **월 계획은 없다.** PB 에 월계획 서브그리드가 있었지만 원천 테이블
 *    (IP_PRODUCT_MI_MONTH_PLAN / IP_PRODUCT_SMD_MONTH_PLAN)이 둘 다 0행이다 —
 *    은성에서 쓴 적이 없어 이관 범위에서 뺐다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, Edit2, Plus, Search, Trash2, XCircle } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { miPlanColumns, planTimeSlotColumns, smdPlanColumns } from '../planning-columns';
import type { PlanRow } from '../planning-types';
import PlanFormPanel, { emptyPlanForm, toPlanForm, type PlanForm } from './PlanFormPanel';

export interface PlanScreenConfig {
  /** 화면 제목 */
  title: string;
  /** 한 줄 설명 */
  subtitle: string;
  /** API 경로 — /production/master-plan 또는 /production/smd-plan */
  path: string;
  variant: 'mi' | 'smd';
}

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function PlanScreen({ config }: { config: PlanScreenConfig }) {
  const isMi = config.variant === 'mi';

  const [rows, setRows] = useState<PlanRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [planStatus, setPlanStatus] = useState('');
  const [showSlots, setShowSlots] = useState(false);

  const [selected, setSelected] = useState<PlanRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: PlanForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [confirmOpen, setConfirmOpen] = useState<'Y' | 'N' | null>(null);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get(config.path, {
        params: {
          dateFrom,
          dateTo,
          lineCode: lineCode || undefined,
          modelName: modelName || undefined,
          workstageCode: isMi ? workstageCode || undefined : undefined,
          planStatus: planStatus || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error(`${config.title} 조회에 실패했습니다.`);
    } finally {
      setLoading(false);
    }
  }, [config.path, config.title, dateFrom, dateTo, lineCode, modelName, workstageCode, planStatus, isMi]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete(config.path, {
        data: { planDate: selected.planDate, planSequence: selected.planSequence },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '삭제에 실패했습니다.');
    }
  }, [selected, config.path, search]);

  const setConfirm = useCallback(async (confirmYn: 'Y' | 'N') => {
    if (!selected) return;
    setConfirmOpen(null);
    try {
      const response = await api.put(`${config.path}/confirm`, {
        planDate: selected.planDate,
        planSequence: selected.planSequence,
        confirmYn,
      });
      const data = response.data?.data;
      toast.success(
        data?.alreadySet
          ? `이미 ${confirmYn === 'Y' ? '확정' : '해제'} 상태입니다.`
          : `${confirmYn === 'Y' ? '확정' : '해제'}되었습니다.`,
      );
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
    }
  }, [selected, config.path, search]);

  const columns = useMemo<ColumnDef<PlanRow>[]>(() => {
    const base = isMi ? miPlanColumns : smdPlanColumns;
    return showSlots ? [...base, ...planTimeSlotColumns] : base;
  }, [isMi, showSlots]);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="text-xl font-bold text-text">{config.title}</h1>
            <p className="mt-1 text-sm text-text-muted">
              {config.subtitle} · {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
            </p>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected && setPanel({ mode: 'edit', form: toPlanForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setConfirmOpen('Y')}>
              <CheckCircle2 className="mr-1 h-4 w-4" />확정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setConfirmOpen('N')}>
              <XCircle className="mr-1 h-4 w-4" />확정해제
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm"
              onClick={() => setPanel({ mode: 'create', form: emptyPlanForm(config.variant) })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <DateRangeFilter label="계획일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
            <ProdLineSelect labelPrefix="라인" value={lineCode}
              onChange={setLineCode} className="w-56" />
            <Input aria-label="모델명" placeholder="모델명" value={modelName}
              className="w-48" onChange={(e) => setModelName(e.target.value)} />
            {isMi && (
              <Input aria-label="공정코드" placeholder="공정코드" value={workstageCode}
                className="w-36" onChange={(e) => setWorkstageCode(e.target.value)} />
            )}
            <ComCodeSelect groupCode="PLAN STATUS" labelPrefix="계획상태"
              value={planStatus} onChange={setPlanStatus} className="w-48" />
            <label className="flex items-center gap-2 text-sm text-text">
              <input type="checkbox" checked={showSlots}
                onChange={(e) => setShowSlots(e.target.checked)} />
              시간대 10칸 보기
            </label>
          </CardContent>
        </Card>

        <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={rows}
              columns={columns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={config.title}
              emptyMessage="조회 버튼을 눌러 계획을 확인하세요."
              onRowClick={(row) => setSelected(row as PlanRow)}
              getRowId={(row) => {
                const r = row as PlanRow;
                return `${r.planDate}|${r.planSequence}`;
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <PlanFormPanel
          key={`${panel.mode}-${panel.form.planDate}-${panel.form.planSequence}`}
          mode={panel.mode}
          variant={config.variant}
          path={config.path}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="계획 삭제"
        message={selected
          ? `${selected.planDate} / 순번 ${selected.planSequence} (${selected.modelName}) 계획을 지울까요?`
            + (selected.mfs && selected.mfs !== '*'
              ? ` 롯트카드 ${selected.mfs} 가 이 계획을 쓰고 있어 삭제가 거부됩니다.`
              : '')
          : ''}
        variant="danger"
      />

      <ConfirmModal
        isOpen={confirmOpen !== null}
        onClose={() => setConfirmOpen(null)}
        onConfirm={() => confirmOpen && setConfirm(confirmOpen)}
        title={confirmOpen === 'Y' ? '계획 확정' : '계획 확정해제'}
        message={selected
          ? `${selected.planDate} / 순번 ${selected.planSequence} 계획을`
            + ` ${confirmOpen === 'Y' ? '확정' : '확정해제'}합니까?`
          : ''}
      />
    </div>
  );
}
