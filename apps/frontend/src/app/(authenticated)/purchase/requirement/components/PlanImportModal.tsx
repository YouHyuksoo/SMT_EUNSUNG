"use client";

/**
 * @file src/app/(authenticated)/purchase/requirement/components/PlanImportModal.tsx
 * @description 477 자재소요량관리 — 제품생산계획에서 골라 기준계획으로 가져오기
 *
 * 초보자 가이드:
 * 1. **조회**: 제품생산계획(/production/master-plan)을 기간·라인·모델로 조회한다.
 * 2. **선택**: 체크한 계획만 가져온다. 품목코드가 없는 계획(BOM 전개 불가)은 고를 수 없다.
 * 3. **합치기**: 기준계획은 (기준일자·계획일·품목)이 같으면 수량을 덮어쓴다.
 *    그래서 같은 날 같은 품목이 여러 라인에 있으면 수량을 합쳐 한 줄로 보낸다.
 * 4. 기준일자는 화면 맨 위 값(requirementPlanDate)을 그대로 쓴다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import type { ColumnDef } from '@tanstack/react-table';
import { Download, Search } from 'lucide-react';
import { Button, Modal } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import api from '@/services/api';
import type { PlanRow } from '../../../production/planning-types';

interface PlanImportModalProps {
  isOpen: boolean;
  onClose: () => void;
  /** 기준일자 — 가져온 계획을 묶는 번호표 */
  requirementPlanDate: string;
  /** 가져오기 완료 후 (등록 건수) */
  onImported: (count: number) => void;
}

const ymd = (v: unknown) => (v ? String(v).slice(0, 10) : '');
const today = () => new Date().toISOString().slice(0, 10);
const plusDays = (d: string, n: number) => {
  const t = new Date(`${d}T00:00:00`);
  t.setDate(t.getDate() + n);
  return t.toISOString().slice(0, 10);
};
const rowKey = (r: PlanRow) => `${r.planDate}|${r.planSequence}|${r.lineCode}`;

export default function PlanImportModal({ isOpen, onClose, requirementPlanDate, onImported }: PlanImportModalProps) {
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(() => plusDays(today(), 7));
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [rows, setRows] = useState<PlanRow[]>([]);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/production/master-plan', {
        params: { dateFrom, dateTo, lineCode: lineCode || undefined, modelName: modelName || undefined },
      });
      setRows((res.data?.data ?? []) as PlanRow[]);
      setSelected(new Set());
      setSearched(true);
    } catch {
      toast.error('제품생산계획 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, modelName]);

  const selectable = useMemo(() => rows.filter((r) => r.itemCode && Number(r.planQty) > 0), [rows]);
  const allChecked = selectable.length > 0 && selectable.every((r) => selected.has(rowKey(r)));

  const toggle = useCallback((r: PlanRow) => {
    setSelected((prev) => {
      const next = new Set(prev);
      const k = rowKey(r);
      if (next.has(k)) next.delete(k);
      else next.add(k);
      return next;
    });
  }, []);

  const columns = useMemo<ColumnDef<PlanRow>[]>(() => [
    {
      id: 'select',
      size: 44,
      enableSorting: false,
      meta: { filterType: 'none' },
      header: () => (
        <input
          type="checkbox"
          aria-label="전체 선택"
          checked={allChecked}
          onChange={() => setSelected(allChecked ? new Set() : new Set(selectable.map(rowKey)))}
        />
      ),
      cell: ({ row }) => {
        const r = row.original;
        const disabled = !r.itemCode || !(Number(r.planQty) > 0);
        return (
          <input
            type="checkbox"
            aria-label="선택"
            disabled={disabled}
            title={disabled ? '품목코드나 계획수량이 없어 가져올 수 없습니다' : undefined}
            checked={selected.has(rowKey(r))}
            onClick={(e) => e.stopPropagation()} // 행 클릭(toggle)과 겹쳐 두 번 바뀌지 않게
            onChange={() => toggle(r)}
          />
        );
      },
    },
    { accessorKey: 'itemCode', header: '품목코드', size: 140 },
    { accessorKey: 'itemName', header: '품목명', size: 180 },
    { id: 'planDate', header: '계획일', size: 100, accessorFn: (r) => ymd(r.planDate) },
    { id: 'lineName', header: '라인', size: 120, accessorFn: (r) => r.lineName ?? r.lineCode },
    { accessorKey: 'modelName', header: '모델명', size: 170 },
    { accessorKey: 'planQty', header: '계획수량', size: 90, meta: { align: 'right' } },
    { accessorKey: 'planStatusName', header: '계획상태', size: 90 },
  ], [allChecked, selectable, selected, toggle]);

  /** 선택 계획을 (계획일·품목) 으로 합쳐 기준계획으로 등록 */
  const importSelected = useCallback(async () => {
    const picked = rows.filter((r) => selected.has(rowKey(r)) && r.itemCode);
    if (!picked.length) return;
    const merged = new Map<string, { planDate: string; itemCode: string; orderQty: number }>();
    for (const r of picked) {
      const planDate = ymd(r.planDate);
      const k = `${planDate}|${r.itemCode}`;
      const cur = merged.get(k);
      if (cur) cur.orderQty += Number(r.planQty) || 0;
      else merged.set(k, { planDate, itemCode: String(r.itemCode), orderQty: Number(r.planQty) || 0 });
    }
    setSaving(true);
    let ok = 0;
    const failed: string[] = [];
    for (const m of merged.values()) {
      try {
        await api.post('/purchase/requirement/master-plan', { requirementPlanDate, ...m }, { suppressErrorModal: true });
        ok += 1;
      } catch {
        failed.push(`${m.planDate} ${m.itemCode}`);
      }
    }
    setSaving(false);
    if (failed.length) toast.error(`${failed.length}건 실패: ${failed.slice(0, 3).join(', ')}${failed.length > 3 ? ' …' : ''}`);
    if (ok) {
      toast.success(`기준계획 ${ok}건을 가져왔습니다.`);
      onImported(ok);
      onClose();
    }
  }, [rows, selected, requirementPlanDate, onImported, onClose]);

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="기준계획 가져오기"
      subtitle={`제품생산계획에서 골라 기준일자 ${requirementPlanDate} 로 등록합니다. 같은 날·같은 품목은 수량을 합칩니다.`}
      size="2xl"
      bodyMaxHeightClass="max-h-[80vh]"
      footer={
        <div className="flex w-full items-center justify-between">
          <span className="text-sm text-text-muted">선택 {selected.size}건</span>
          <div className="flex gap-2">
            <Button variant="secondary" onClick={onClose}>취소</Button>
            <Button onClick={importSelected} disabled={saving || selected.size === 0}>
              <Download className="mr-1 h-4 w-4" />{saving ? '가져오는 중…' : '가져오기'}
            </Button>
          </div>
        </div>
      }
    >
      <div className="flex flex-col gap-3">
        <div className="flex flex-wrap items-center gap-2">
          <DateRangeFilter label="계획일" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
          <ModelSearchField value={modelName} onChange={setModelName} className="w-48" />
          <Button size="sm" variant="secondary" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
        <div className="h-[55vh] min-h-0">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={100}
            getRowId={(r) => rowKey(r as PlanRow)}
            onRowClick={(r) => toggle(r as PlanRow)}
            emptyMessage={searched ? '해당 기간에 제품생산계획이 없습니다.' : '기간을 정하고 조회하세요.'}
          />
        </div>
      </div>
    </Modal>
  );
}
