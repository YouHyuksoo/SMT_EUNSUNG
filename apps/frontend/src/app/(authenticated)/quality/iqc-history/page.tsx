"use client";

/**
 * @file src/app/(authenticated)/quality/iqc-history/page.tsx
 * @description IQC 이력등록관리 — PB w_qc_iqc_inspect_history_master 이식
 *
 * 초보자 가이드:
 * 1. **PB 는 상세/집계 두 모드로 갈려 있었지만 같은 테이블이다.** 컬럼 집합만 달랐고
 *    집계 모드에서만 검사일시·항번을 채워줬다. 웹은 한 경로로 합치고 항상 서버가 채운다.
 * 2. **검사일시와 검사항번은 입력하지 않는다.** 등록 시 서버가 지금 시각과
 *    SEQ_IQC_INSPECT_HISTORY_SEQ 채번값을 넣는다. 그 둘이 이 행의 키다.
 * 3. 이 테이블은 이 DB 에서 0행이다 — 은성에서 아직 쓰지 않은 기능이다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardList, Edit2, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { iqcInspectHistoryColumns, type IqcInspectHistoryRow } from '../pid-columns';
import IqcHistoryFormPanel, {
  emptyIqcHistoryForm,
  toIqcHistoryForm,
  type IqcHistoryForm,
} from './components/IqcHistoryFormPanel';
import PartSearchField from '@/components/shared/PartSearchField';
import { getTodayLocal } from '@/utils/date';

/** 로컬(KST) 오늘 — toISOString 은 UTC 라 오전 9시 전엔 어제가 된다 */
const today = () => getTodayLocal();

export default function IqcHistoryPage() {
  const [rows, setRows] = useState<IqcInspectHistoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [modelName, setModelName] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [itemClass, setItemClass] = useState('');
  const [inspectResult, setInspectResult] = useState('');
  const [lotNo, setLotNo] = useState('');

  const [selected, setSelected] = useState<IqcInspectHistoryRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: IqcHistoryForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  /** 조회 — 받은 행을 돌려준다 (등록 직후 새 행이 보이는지 확인용) */
  const search = useCallback(async (): Promise<IqcInspectHistoryRow[] | null> => {
    setLoading(true);
    try {
      const response = await api.get('/quality/iqc-history', {
        params: {
          dateFrom, dateTo,
          modelName: modelName || undefined,
          itemCode: itemCode || undefined,
          itemClass: itemClass || undefined,
          inspectResult: inspectResult || undefined,
          lotNo: lotNo || undefined,
        },
      });
      const data: IqcInspectHistoryRow[] = response.data?.data ?? [];
      setRows(data);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
      return data;
    } catch {
      toast.error('IQC 검사이력 조회에 실패했습니다.');
      return null;
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, modelName, itemCode, itemClass, inspectResult, lotNo]);

  /** 저장 후 다시 조회한다. 새로 등록한 행이 지금 조회조건에 걸려 안 보이면 알려 준다. */
  const afterSave = useCallback(async (createdSequence?: number) => {
    setPanel(null);
    const data = await search();
    if (createdSequence == null || !data) return;
    if (data.some((row) => Number(row.inspectSequence) === createdSequence)) return;
    const active = [
      dateTo < today() ? `검사일(~${dateTo})` : '',
      modelName ? '모델명' : '', itemCode ? '품목코드' : '', itemClass ? '품목분류' : '',
      inspectResult ? '판정' : '', lotNo ? 'LOT번호' : '',
    ].filter(Boolean);
    toast(`검사항번 ${createdSequence}번은 저장됐지만 지금 조회조건(${active.join(', ') || '기간'})에 맞지 않아 목록에 보이지 않습니다.`,
      { icon: 'ℹ️', duration: 6000 });
  }, [search, dateTo, modelName, itemCode, itemClass, inspectResult, lotNo]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/quality/iqc-history', {
        data: {
          inspectDateKey: selected.inspectDateKey,
          inspectSequence: selected.inspectSequence,
        },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch {
      toast.error('삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => iqcInspectHistoryColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <ClipboardList className="h-6 w-6 text-primary" />IQC 이력등록관리
            </h1>
            <p className="mt-1 text-sm text-text-muted">
              수입검사 결과 이력을 직접 등록하고 조회합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
            </p>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={() => void search()} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected && setPanel({ mode: 'edit', form: toIqcHistoryForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm"
              onClick={() => setPanel({ mode: 'create', form: emptyIqcHistoryForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <DateRangeFilter label="검사일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
            <ModelSearchField value={modelName} onChange={(v) => setModelName(v)}
              className="w-44" aria-label="모델명" placeholder="모델명" />
            <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
              className="w-40" onChange={(e) => setItemCode(e.target.value)} />
            <ComCodeSelect groupCode="ITEM CLASS" labelPrefix="품목분류"
              value={itemClass} onChange={setItemClass} className="w-48" />
            <ComCodeSelect groupCode="INSPECT RESULT" labelPrefix="판정"
              value={inspectResult} onChange={setInspectResult} className="w-40" />
            <Input aria-label="LOT번호" placeholder="LOT번호" value={lotNo}
              className="w-40" onChange={(e) => setLotNo(e.target.value)} />
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
              exportFileName="IQC이력등록"
              emptyMessage="조회 버튼을 눌러 검사이력을 확인하세요."
              onRowClick={(row) => setSelected(row as IqcInspectHistoryRow)}
              getRowId={(row) => {
                const r = row as IqcInspectHistoryRow;
                return `${r.inspectDate}|${r.inspectSequence}`;
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <IqcHistoryFormPanel
          key={`${panel.mode}-${panel.form.inspectSequence}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={(createdSequence) => { void afterSave(createdSequence); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="검사이력 삭제"
        message={selected
          ? `검사항번 ${selected.inspectSequence} 이력을 삭제할까요?`
          : ''}
        variant="danger"
      />
    </div>
  );
}
