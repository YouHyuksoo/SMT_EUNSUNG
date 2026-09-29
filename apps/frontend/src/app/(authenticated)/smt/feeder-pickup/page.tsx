"use client";

/**
 * @file src/app/(authenticated)/smt/feeder-pickup/page.tsx
 * @description 마운터 픽업정보관리 — PB w_mcn_feeder_pickup_master 이식
 *
 * 초보자 가이드:
 * 1. **'흡착에러율' 은 PB 의 PICKUP_RATE 컬럼이다.** PB 식이
 *    `흡착에러 / 이송횟수 × 100` 이라 이름과 달리 에러율이다. 값은 PB 와 똑같이
 *    넣고 화면 라벨만 사실대로 적었다 — 식을 뒤집으면 PB 화면과 숫자가 갈린다.
 * 2. **적재는 (생산일 + 라인) 단위로 갈아끼운다.** 같은 날 같은 라인을 두 번 올리면
 *    앞의 것이 지워지고 새로 들어간다. 이 표에는 유일제약이 없어서다.
 * 3. **이 표는 이 DB 에서 0행이다** — 은성에서 아직 쓰지 않은 기능이다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search, Trash2, Upload } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtModelSelect } from '../components/SmtSelects';
import { smtPickupColumns } from '../columns';
import type { SmtPickupRow } from '../types';
import SmtPickupUploadModal from './components/SmtPickupUploadModal';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthAgo = () => {
  const date = new Date();
  date.setMonth(date.getMonth() - 1);
  return isoDate(date);
};

export default function SmtFeederPickupPage() {
  const [rows, setRows] = useState<SmtPickupRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(monthAgo);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [feederId, setFeederId] = useState('');

  const [selected, setSelected] = useState<SmtPickupRow | null>(null);
  const [uploadOpen, setUploadOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/smt/pickup', {
        params: {
          dateFrom, dateTo,
          lineCode: lineCode || undefined,
          modelName: modelName || undefined,
          itemCode: itemCode || undefined,
          feederId: feederId || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
    } catch {
      toast.error('픽업정보 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, modelName, itemCode, feederId]);

  const remove = useCallback(async () => {
    if (!selected?.productDate || !selected.lineCode) return;
    setDeleteOpen(false);
    try {
      const response = await api.delete('/smt/pickup', {
        data: {
          productDate: String(selected.productDate).slice(0, 10),
          lineCode: selected.lineCode,
        },
      });
      toast.success(`${response.data?.data?.deleted ?? 0}건을 지웠습니다.`);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '삭제에 실패했습니다.');
    }
  }, [selected, search]);

  const columns = useMemo(() => smtPickupColumns, []);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">마운터 픽업정보관리</h1>
          <p className="mt-1 text-sm text-text-muted">
            마운터 피더별 이송·흡착에러 실적을 관리합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '기간을 정하고 조회하세요'}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" onClick={() => setUploadOpen(true)}>
            <Upload className="mr-1 h-4 w-4" />엑셀 업로드
          </Button>
          <Button size="sm" variant="secondary" disabled={!selected}
            onClick={() => setDeleteOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />생산일·라인 삭제
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="생산일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
            className="w-36" onChange={(e) => setLineCode(e.target.value)} />
          <SmtModelSelect labelPrefix="모델" value={modelName}
            onChange={setModelName} className="w-60" />
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-40" onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="피더 ID" placeholder="피더 ID" value={feederId}
            className="w-40" onChange={(e) => setFeederId(e.target.value)} />
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
            exportFileName="마운터픽업정보"
            emptyMessage="조회 버튼을 눌러 픽업정보를 확인하세요."
            onRowClick={(row) => setSelected(row as SmtPickupRow)}
            getRowId={(row) => {
              const r = row as SmtPickupRow;
              return [r.productDate, r.lineCode, r.feederId, r.itemCode].join('|');
            }}
          />
        </CardContent>
      </Card>

      {uploadOpen && (
        <SmtPickupUploadModal
          defaultLineCode={lineCode}
          onClose={() => setUploadOpen(false)}
          onDone={() => { setUploadOpen(false); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="픽업정보 삭제"
        message={selected
          ? `${String(selected.productDate).slice(0, 10)} / ${selected.lineCode} 의`
            + ' 픽업정보를 전부 지울까요? 선택한 한 줄이 아니라 그 날 그 라인 전체입니다.'
          : ''}
        variant="danger"
      />
    </div>
  );
}
