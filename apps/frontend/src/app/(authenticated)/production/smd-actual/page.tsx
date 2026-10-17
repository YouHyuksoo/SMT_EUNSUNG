"use client";

/**
 * @file src/app/(authenticated)/production/smd-actual/page.tsx
 * @description 반제품생산실적관리 — PB w_pln_assembly_actual_master 이식
 *
 * 초보자 가이드:
 * 1. **이 표는 생산실적(조립실적)이다.** AOI 양품이 실시간으로 더해지고(구분 'AOI 자동'),
 *    작업실적 수기 입력('수기')과 보정('보정')도 같은 표에 쌓인다. 기간을 정해 조회한다.
 * 2. **행을 고치거나 지우지 않는다. 보정 행을 더한다.** 수정은 (새 수량 − 지금 수량),
 *    삭제는 −지금 수량, 보정 등록은 입력한 수량만큼 '보정' 행이 생긴다. 사유는 필수다.
 *    전환 이후 실적이면 공정재고(반제품 입고·자품목 출고)도 같이 움직인다.
 * 3. **합계 탭**은 같은 조건으로 라인·모델별로 접어 본다. 목록 행수가 많을 때
 *    먼저 여기서 보고 이상한 라인만 목록으로 내려간다.
 * 4. **계획별 주야 실적 탭**은 반제품생산계획 한 건당 한 줄이다. 자동 실적은 조회 시점의
 *    생산실적(주간 08:30~20:30 / 야간 20:30~다음날 08:30)이고, 마운터 기준과 다르면
 *    '수기실적' 으로 근무조별 수량을 넣는다. 수기를 비우면 자동으로 돌아간다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Edit2, PencilLine, Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { smdActualColumns, smdActualSummaryColumns } from '../planning-columns';
import type { SmdActualRow, SmdActualSummaryRow } from '../planning-types';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { smdShiftActualColumns, type SmdShiftActualRow } from './shift-actual-columns';

import { getTodayLocal } from '@/utils/date';
type Tab = 'shift' | 'list' | 'summary';

/** 수기 입력칸 — 비우면 null(자동으로 돌아감). 빈 문자열을 0 으로 보내지 않는다. */
const manualValue = (text: string) => (text.trim() === '' ? null : Number(text));

const errorMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

const isoDate = (date: Date) => getTodayLocal(date);
const today = () => isoDate(new Date());

export default function SmdActualPage() {
  const [tab, setTab] = useState<Tab>('shift');

  const [rows, setRows] = useState<SmdActualRow[]>([]);
  const [summary, setSummary] = useState<SmdActualSummaryRow[]>([]);
  const [shiftRows, setShiftRows] = useState<SmdShiftActualRow[]>([]);
  const [searchedAt, setSearchedAt] = useState('');
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');

  const [selected, setSelected] = useState<SmdActualRow | null>(null);
  const [editOpen, setEditOpen] = useState(false);
  const [editQty, setEditQty] = useState('');
  const [editReason, setEditReason] = useState('');
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [deleteReason, setDeleteReason] = useState('');

  const [adjustOpen, setAdjustOpen] = useState(false);
  const [adjustRunNo, setAdjustRunNo] = useState('');
  const [adjustLine, setAdjustLine] = useState('');
  const [adjustTime, setAdjustTime] = useState('');
  const [adjustQty, setAdjustQty] = useState('');
  const [adjustReason, setAdjustReason] = useState('');
  const [busy, setBusy] = useState(false);

  const [shiftSelected, setShiftSelected] = useState<SmdShiftActualRow | null>(null);
  const [manualOpen, setManualOpen] = useState(false);
  const [dayManual, setDayManual] = useState('');
  const [nightManual, setNightManual] = useState('');

  const params = useMemo(
    () => ({
      dateFrom,
      dateTo,
      lineCode: lineCode || undefined,
      modelName: modelName || undefined,
      workstageCode: workstageCode || undefined,
    }),
    [dateFrom, dateTo, lineCode, modelName, workstageCode],
  );

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (tab === 'shift') {
        const response = await api.get('/production/smd-actual/shift', {
          params: {
            dateFrom,
            dateTo,
            lineCode: lineCode || undefined,
            modelName: modelName || undefined,
          },
        });
        setShiftRows(response.data?.data ?? []);
        setSearchedAt(new Date().toLocaleTimeString('ko-KR', { hour12: false }));
      } else if (tab === 'list') {
        const response = await api.get('/production/smd-actual', { params });
        setRows(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      } else {
        const response = await api.get('/production/smd-actual/summary', { params });
        setSummary(response.data?.data ?? []);
      }
      setSearched(true);
      setSelected(null);
      setShiftSelected(null);
    } catch {
      toast.error('생산실적 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, params, dateFrom, dateTo, lineCode, modelName]);

  const openManual = useCallback(() => {
    if (!shiftSelected) return;
    setDayManual(shiftSelected.dayManualQty == null ? '' : String(shiftSelected.dayManualQty));
    setNightManual(shiftSelected.nightManualQty == null ? '' : String(shiftSelected.nightManualQty));
    setManualOpen(true);
  }, [shiftSelected]);

  const saveManual = useCallback(async () => {
    if (!shiftSelected) return;
    const day = manualValue(dayManual);
    const night = manualValue(nightManual);
    const invalid = [day, night].some(
      (v) => v !== null && (!Number.isInteger(v) || v < 0),
    );
    if (invalid) {
      toast.error('수기 실적은 0 이상의 정수로 넣으세요.');
      return;
    }
    setBusy(true);
    try {
      await api.put('/production/smd-actual/shift-manual', {
        planDate: shiftSelected.planDate,
        planSequence: shiftSelected.planSequence,
        dayManualQty: day,
        nightManualQty: night,
      });
      toast.success('수기 실적을 저장했습니다.');
      setManualOpen(false);
      void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '수기 실적 저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [shiftSelected, dayManual, nightManual, search]);

  const clearManual = useCallback(async () => {
    if (!shiftSelected) return;
    setBusy(true);
    try {
      await api.delete('/production/smd-actual/shift-manual', {
        data: { planDate: shiftSelected.planDate, planSequence: shiftSelected.planSequence },
      });
      toast.success('수기 실적을 지웠습니다. 자동 실적으로 계산합니다.');
      setManualOpen(false);
      void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '수기 실적 삭제에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [shiftSelected, search]);

  const openEdit = useCallback(() => {
    if (!selected) return;
    setEditQty(String(selected.productActualQty ?? 0));
    setEditReason('');
    setEditOpen(true);
  }, [selected]);

  const saveEdit = useCallback(async () => {
    if (!selected) return;
    const qty = Number(editQty);
    if (editQty.trim() === '' || !Number.isInteger(qty) || qty < 0) {
      toast.error('실적수량은 0 이상의 정수로 넣으세요.');
      return;
    }
    if (!editReason.trim()) {
      toast.error('수정 사유를 넣으세요.');
      return;
    }
    setBusy(true);
    try {
      await api.put('/production/smd-actual', {
        receiptDateKey: selected.receiptDateKey,
        receiptSequence: selected.receiptSequence,
        productActualQty: qty,
        reason: editReason.trim(),
      });
      toast.success('보정 행을 더했습니다.');
      setEditOpen(false);
      void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '수정에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, editQty, editReason, search]);

  const openDelete = useCallback(() => {
    setDeleteReason('');
    setDeleteOpen(true);
  }, []);

  const remove = useCallback(async () => {
    if (!selected) return;
    if (!deleteReason.trim()) {
      toast.error('삭제 사유를 넣으세요.');
      return;
    }
    setBusy(true);
    try {
      await api.delete('/production/smd-actual', {
        data: {
          receiptDateKey: selected.receiptDateKey,
          receiptSequence: selected.receiptSequence,
          reason: deleteReason.trim(),
        },
      });
      toast.success('음수 보정 행을 더했습니다.');
      setDeleteOpen(false);
      void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '삭제에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, deleteReason, search]);

  /** 보정 등록 — 고른 행이 있으면 런카드·라인·시각을 채워 둔다 */
  const openAdjust = useCallback(() => {
    const pad = (n: number) => String(n).padStart(2, '0');
    const now = new Date();
    setAdjustRunNo(selected?.runNo ?? '');
    setAdjustLine(selected?.lineCode ?? '');
    setAdjustTime(selected?.actualTime?.replace(' ', 'T')
      ?? `${getTodayLocal(now)}T${pad(now.getHours())}:${pad(now.getMinutes())}`);
    setAdjustQty('');
    setAdjustReason('');
    setAdjustOpen(true);
  }, [selected]);

  const saveAdjust = useCallback(async () => {
    const qty = Number(adjustQty);
    if (!adjustRunNo.trim()) { toast.error('런카드 번호를 넣으세요.'); return; }
    if (!adjustTime) { toast.error('실적 시각을 넣으세요.'); return; }
    if (adjustQty.trim() === '' || !Number.isInteger(qty) || qty === 0) {
      toast.error('보정 수량은 0 이 아닌 정수로 넣으세요 (줄이면 음수).');
      return;
    }
    if (!adjustReason.trim()) { toast.error('보정 사유를 넣으세요.'); return; }
    setBusy(true);
    try {
      await api.post('/production/assembly-results/adjust', {
        runNo: adjustRunNo.trim(),
        lineCode: adjustLine || undefined,
        actualTime: adjustTime.replace('T', ' ').slice(0, 16),
        qty,
        reason: adjustReason.trim(),
      });
      toast.success('보정 행을 등록했습니다.');
      setAdjustOpen(false);
      void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '보정 등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [adjustRunNo, adjustLine, adjustTime, adjustQty, adjustReason, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">반제품생산실적관리</h1>
          <p className="mt-1 text-sm text-text-muted">
            생산실적(AOI 자동·수기·보정)을 확인하고 보정합니다 ·{' '}
            {!searched
              ? '기간을 정하고 조회하세요'
              : tab === 'shift'
                ? `계획 ${shiftRows.length}건 · 자동 실적 ${searchedAt} 기준`
                : tab === 'list'
                  ? `${rows.length}/${total}건`
                  : `${summary.length}개 라인·모델`}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {tab === 'shift' ? (
            <Button size="sm" variant="secondary" disabled={!shiftSelected} onClick={openManual}>
              <PencilLine className="mr-1 h-4 w-4" />수기실적
            </Button>
          ) : (
            <>
              <Button size="sm" variant="secondary" disabled={tab !== 'list'} onClick={openAdjust}>
                <Plus className="mr-1 h-4 w-4" />보정 등록
              </Button>
              <Button size="sm" variant="secondary" disabled={!selected || tab !== 'list'}
                onClick={openEdit}>
                <Edit2 className="mr-1 h-4 w-4" />수정
              </Button>
              <Button size="sm" variant="secondary" disabled={!selected || tab !== 'list'}
                onClick={openDelete}>
                <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
              </Button>
            </>
          )}
        </div>
      </header>

      <ScreenTabs
        tabs={[
          { key: 'shift', label: '계획별 주야 실적', count: shiftRows.length },
          { key: 'list', label: '실적 목록', count: total },
          { key: 'summary', label: '라인·모델 합계', count: summary.length },
        ]}
        active={tab}
        onChange={(key) => { setTab(key); setSelected(null); setShiftSelected(null); }}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label={tab === 'shift' ? '계획일' : '집계일'} from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <ProdLineSelect labelPrefix="라인" value={lineCode}
            onChange={setLineCode} className="w-56" />
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName}
            className="w-48" onChange={(v) => setModelName(v)} />
          {tab !== 'shift' && (
            <ProcessSelect labelPrefix="공정" value={workstageCode} onChange={setWorkstageCode} className="w-44" />
          )}
          {tab === 'shift' && (
            <span className="text-xs text-text-muted">
              주간 08:30~20:30 · 야간 20:30~다음날 08:30 · 실적은 수기가 있으면 수기, 없으면 자동
            </span>
          )}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'shift' ? (
            <DataGrid
              data={shiftRows}
              columns={smdShiftActualColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="반제품생산실적_계획별주야"
              emptyMessage="조회 버튼을 눌러 계획별 실적을 확인하세요."
              onRowClick={(row) => setShiftSelected(row as SmdShiftActualRow)}
              selectedRowId={shiftSelected
                ? `${shiftSelected.planDate}|${shiftSelected.planSequence}` : undefined}
              getRowId={(row) => {
                const r = row as SmdShiftActualRow;
                return `${r.planDate}|${r.planSequence}`;
              }}
            />
          ) : tab === 'list' ? (
            <DataGrid
              data={rows}
              columns={smdActualColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="반제품생산실적"
              emptyMessage="조회 버튼을 눌러 실적을 확인하세요."
              onRowClick={(row) => setSelected(row as SmdActualRow)}
              getRowId={(row) => {
                const r = row as SmdActualRow;
                return `${r.receiptDateKey}|${r.receiptSequence}`;
              }}
            />
          ) : (
            <DataGrid
              data={summary}
              columns={smdActualSummaryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="반제품생산실적_합계"
              emptyMessage="조회 버튼을 눌러 합계를 확인하세요."
              getRowId={(row) => {
                const r = row as SmdActualSummaryRow;
                return `${r.lineCode}|${r.modelName}`;
              }}
            />
          )}
        </CardContent>
      </Card>

      <Modal isOpen={editOpen} onClose={() => setEditOpen(false)} title="실적 수정">
        <div className="space-y-4">
          {selected && (
            <p className="text-sm text-text-muted">
              {selected.actualTime} / 순번 {selected.receiptSequence} · {selected.lineCode}
              {' '}/ {selected.modelName} · {selected.runNo}
            </p>
          )}
          <label className="block text-sm">
            <span className="text-text-muted">
              실적수량 (지금 {Number(selected?.productActualQty ?? 0).toLocaleString()})
            </span>
            <Input type="number" min={0} step={1} value={editQty}
              onChange={(e) => setEditQty(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">수정 사유</span>
            <Input value={editReason} maxLength={200} placeholder="예: AOI 재검사 중복 집계"
              onChange={(e) => setEditReason(e.target.value)} />
          </label>
          <p className="text-xs text-text-muted">
            이 행은 그대로 두고 (새 수량 − 지금 수량)만큼 같은 런카드·시각으로 보정 행을 더합니다.
            작업일·시간대가 같고, 공정재고도 같은 수량만큼 움직입니다.
          </p>
        </div>
        <div className="mt-6 flex justify-end gap-2">
          <Button variant="secondary" onClick={() => setEditOpen(false)} disabled={busy}>
            취소
          </Button>
          <Button onClick={saveEdit} disabled={busy}>저장</Button>
        </div>
      </Modal>

      <Modal isOpen={manualOpen} onClose={() => setManualOpen(false)} title="수기 실적 입력">
        <div className="space-y-4">
          {shiftSelected && (
            <p className="text-sm text-text-muted">
              {shiftSelected.planDate} / 순번 {shiftSelected.planSequence} ·{' '}
              {shiftSelected.lineCode} / {shiftSelected.modelName} · 계획{' '}
              {Number(shiftSelected.planQty ?? 0).toLocaleString()}
            </p>
          )}
          <label className="block text-sm">
            <span className="text-text-muted">
              주간 수기 실적 (08:30~20:30) · 자동 {Number(shiftSelected?.dayAutoQty ?? 0).toLocaleString()}
            </span>
            <Input type="number" min={0} step={1} value={dayManual} placeholder="비우면 자동 실적 사용"
              onChange={(e) => setDayManual(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">
              야간 수기 실적 (20:30~다음날 08:30) · 자동 {Number(shiftSelected?.nightAutoQty ?? 0).toLocaleString()}
            </span>
            <Input type="number" min={0} step={1} value={nightManual} placeholder="비우면 자동 실적 사용"
              onChange={(e) => setNightManual(e.target.value)} />
          </label>
          <p className="text-xs text-text-muted">
            수기 값을 넣은 근무조는 자동 실적 대신 수기 값으로 잔량을 계산합니다.
            칸을 비우고 저장하면 그 근무조는 자동 실적으로 돌아갑니다.
            생산실적 자체는 바꾸지 않습니다.
          </p>
          {shiftSelected && shiftSelected.samePlanCount > 1 && (
            <p className="text-xs text-amber-600">
              같은 날·라인·모델 계획이 {shiftSelected.samePlanCount}건이라 자동 실적이 계획마다 똑같이
              붙어 있습니다. 계획별 실제 수량을 수기로 나눠 넣으세요.
            </p>
          )}
        </div>
        <div className="mt-6 flex justify-between gap-2">
          <Button variant="secondary" onClick={clearManual}
            disabled={busy || (shiftSelected?.dayManualQty == null
              && shiftSelected?.nightManualQty == null)}>
            수기 모두 지우기
          </Button>
          <div className="flex gap-2">
            <Button variant="secondary" onClick={() => setManualOpen(false)} disabled={busy}>
              취소
            </Button>
            <Button onClick={saveManual} disabled={busy}>저장</Button>
          </div>
        </div>
      </Modal>

      <Modal isOpen={deleteOpen} onClose={() => setDeleteOpen(false)} title="실적 삭제">
        <div className="space-y-4">
          {selected && (
            <p className="text-sm text-text-muted">
              {selected.actualTime} / 순번 {selected.receiptSequence} · {selected.lineCode}
              {' '}/ {selected.modelName} · 수량 {Number(selected.productActualQty ?? 0).toLocaleString()}
            </p>
          )}
          <label className="block text-sm">
            <span className="text-text-muted">삭제 사유</span>
            <Input value={deleteReason} maxLength={200}
              onChange={(e) => setDeleteReason(e.target.value)} />
          </label>
          <p className="text-xs text-text-muted">
            행을 지우지 않고 같은 수량의 음수 보정 행을 더해 0 으로 만듭니다. 공정재고도 되돌립니다.
          </p>
        </div>
        <div className="mt-6 flex justify-end gap-2">
          <Button variant="secondary" onClick={() => setDeleteOpen(false)} disabled={busy}>
            취소
          </Button>
          <Button variant="danger" onClick={remove} disabled={busy}>삭제</Button>
        </div>
      </Modal>

      <Modal isOpen={adjustOpen} onClose={() => setAdjustOpen(false)} title="보정 등록">
        <div className="space-y-4">
          <label className="block text-sm">
            <span className="text-text-muted">런카드 번호 (스캔 가능)</span>
            <Input value={adjustRunNo} maxLength={50}
              onChange={(e) => setAdjustRunNo(e.target.value)} />
          </label>
          <div className="block text-sm">
            <span className="text-text-muted">라인 (비우면 런카드 라인)</span>
            <ProdLineSelect value={adjustLine} onChange={setAdjustLine} />
          </div>
          <label className="block text-sm">
            <span className="text-text-muted">실적 시각 — 작업일·시간대가 이 시각으로 정해집니다</span>
            <Input type="datetime-local" value={adjustTime}
              onChange={(e) => setAdjustTime(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">보정 수량 (늘리면 +, 줄이면 −)</span>
            <Input type="number" step={1} value={adjustQty}
              onChange={(e) => setAdjustQty(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">보정 사유</span>
            <Input value={adjustReason} maxLength={200}
              onChange={(e) => setAdjustReason(e.target.value)} />
          </label>
          <p className="text-xs text-text-muted">
            생산 품목은 런카드 모델·면으로 정해지고, 전환 이후 시각이면 공정재고(반제품 입고·자품목 출고)도
            같은 수량만큼 움직입니다.
          </p>
        </div>
        <div className="mt-6 flex justify-end gap-2">
          <Button variant="secondary" onClick={() => setAdjustOpen(false)} disabled={busy}>
            취소
          </Button>
          <Button onClick={saveAdjust} disabled={busy}>등록</Button>
        </div>
      </Modal>
    </div>
  );
}
