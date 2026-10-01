"use client";

/**
 * @file src/app/(authenticated)/quality/notify/page.tsx
 * @description 품질이상발생관리 — PB w_qc_notify_master 이식
 *
 * 초보자 가이드:
 * 1. **키는 발생일자 + 발생항번**이다. 등록하면 오늘 날짜와 SEQ_QC_NOTIFY_SEQUENCE 채번값이
 *    서버에서 붙는다. 그 둘은 나중에 바꿀 수 없다.
 * 2. **조치상태와 완료여부는 별도 버튼으로 바꾼다.** 완료로 바꾸면 완료일시가 서버에서 찍힌다.
 * 3. **첨부파일(NG·검사·문서 이미지)은 이관 범위 밖이다.** 목록에 종류만 보여준다 —
 *    PB 에서는 여기서 파일을 내려받을 수 있었다.
 * 4. 키워드는 불량내용·비고·QC의견 세 컬럼을 한 번에 훑는다 (PB 조건 그대로).
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, Edit2, Plus, Search, Siren, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { qcNotifyColumns, type QcNotifyRow } from '../notify-columns';
import QcNotifyFormPanel, {
  emptyQcNotifyForm,
  toQcNotifyForm,
  type QcNotifyForm,
} from './components/QcNotifyFormPanel';
import PartSearchField from '@/components/shared/PartSearchField';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function QcNotifyPage() {
  const [rows, setRows] = useState<QcNotifyRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [notifyStatus, setNotifyStatus] = useState('');
  const [keyword, setKeyword] = useState('');

  const [selected, setSelected] = useState<QcNotifyRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: QcNotifyForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [completeOpen, setCompleteOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/notify', {
        params: {
          dateFrom, dateTo,
          modelName: modelName || undefined,
          lineCode: lineCode || undefined,
          workstageCode: workstageCode || undefined,
          itemCode: itemCode || undefined,
          notifyStatus: notifyStatus || undefined,
          keyword: keyword || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('품질이상발생 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, modelName, lineCode, workstageCode, itemCode, notifyStatus, keyword]);

  const remove = useCallback(async () => {
    if (!selected) return;
    setDeleteOpen(false);
    try {
      await api.delete('/quality/notify', {
        data: {
          actionDate: String(selected.actionDate).slice(0, 10),
          notifySequence: selected.notifySequence,
        },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch {
      toast.error('삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const complete = useCallback(async () => {
    if (!selected) return;
    setCompleteOpen(false);
    try {
      await api.put('/quality/notify/status', {
        actionDate: String(selected.actionDate).slice(0, 10),
        notifySequence: selected.notifySequence,
        notifyStatus: 'C',
        completeYn: 'Y',
      });
      toast.success('완료 처리했습니다.');
      void search();
    } catch {
      toast.error('완료 처리에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => qcNotifyColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <Siren className="h-6 w-6 text-primary" />품질이상발생관리
            </h1>
            <p className="mt-1 text-sm text-text-muted">
              품질 이상을 접수하고 조치 진행상태를 관리합니다 ·{' '}
              {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
            </p>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected && setPanel({ mode: 'edit', form: toQcNotifyForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" variant="secondary"
              disabled={!selected || selected?.completeYn === 'Y'}
              onClick={() => setCompleteOpen(true)}>
              <CheckCircle2 className="mr-1 h-4 w-4 text-green-600" />완료처리
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
            </Button>
            <Button size="sm" onClick={() => setPanel({ mode: 'create', form: emptyQcNotifyForm() })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <DateRangeFilter label="발생일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
            <ModelSearchField value={modelName} onChange={(v) => setModelName(v)}
              className="w-44" aria-label="모델명" placeholder="모델명" />
            <LineSelect labelPrefix="라인" value={lineCode}
              onChange={setLineCode} className="w-40" />
            <ProcessSelect labelPrefix="공정" value={workstageCode}
              onChange={setWorkstageCode} className="w-44" />
            <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
              className="w-40" onChange={(e) => setItemCode(e.target.value)} />
            <ComCodeSelect groupCode="NOTIFY STATUS" labelPrefix="조치상태"
              value={notifyStatus} onChange={setNotifyStatus} className="w-44" />
            <Input aria-label="내용 검색" placeholder="불량내용·비고 검색" value={keyword}
              className="w-52" onChange={(e) => setKeyword(e.target.value)} />
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
              exportFileName="품질이상발생"
              emptyMessage="조회 버튼을 눌러 이상발생 건을 확인하세요."
              onRowClick={(row) => setSelected(row as QcNotifyRow)}
              rowClassName={(row) =>
                (row as QcNotifyRow).completeYn === 'Y'
                  ? ''
                  : 'bg-amber-50 dark:bg-amber-950/20'}
              getRowId={(row) => {
                const r = row as QcNotifyRow;
                return `${r.actionDate}|${r.notifySequence}`;
              }}
            />
          </CardContent>
        </Card>
      </main>

      {panel && (
        <QcNotifyFormPanel
          key={`${panel.mode}-${panel.form.notifySequence}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="품질이상발생 삭제"
        message={selected ? `발생항번 ${selected.notifySequence} 건을 삭제할까요?` : ''}
        variant="danger"
      />
      <ConfirmModal
        isOpen={completeOpen}
        onClose={() => setCompleteOpen(false)}
        onConfirm={complete}
        title="완료 처리"
        message={selected
          ? `발생항번 ${selected.notifySequence} 건을 완료로 바꿉니다. 완료일시가 지금으로 찍힙니다.`
          : ''}
      />
    </div>
  );
}
