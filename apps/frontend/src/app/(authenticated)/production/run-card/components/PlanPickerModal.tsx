"use client";

/**
 * @file production/run-card/components/PlanPickerModal.tsx
 * @description 생산계획 한 줄을 골라 롯트카드를 만든다 (PB Show Plan + New Project)
 *
 * 초보자 가이드:
 * 1. **라인을 먼저 고른다.** 라인 구분이 SMD(D)면 반제품(SMD) 계획, 그 외는 제품(조립) 계획이 나온다.
 * 2. **수량은 고르지 않는다.** 계획의 남은 수량(계획 - 이미 만든 롯트카드)이 그대로 롯트카드 수량이 된다.
 *    지시일자는 계획일자, 롯트카드 번호는 서버가 채번한다.
 * 3. 투입 자재(상세)는 계획 품목의 BOM 1단계로 함께 만들어진다. 다른 기준이 필요하면 [상세 생성]을 쓴다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import type { ColumnDef } from '@tanstack/react-table';
import { Plus, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import { Button, Input } from '@/components/ui';
import Modal from '@/components/ui/Modal';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';

export interface PlanRow {
  planType: 'SMD' | 'MI'; mfs: string; planDate: string; planSequence: number;
  lineCode: string | null; modelName: string | null; itemCode: string | null; itemName: string | null;
  workOrderNo: string | null; pcbItem: string | null; masterModelName: string | null;
  mfsGroupNo: string | null; shiftCode: string | null; customerCode: string | null; planStatus: string;
  planQty: number; lotQty: number | null; remainQty: number;
}

const shiftDays = (ymd: string, days: number) => {
  const d = new Date(`${ymd}T00:00:00`);
  d.setDate(d.getDate() + days);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};
const planKey = (p: PlanRow) => `${p.planDate}|${p.planSequence}|${p.mfs}`;

export default function PlanPickerModal({ isOpen, onClose, onCreated }: {
  isOpen: boolean;
  onClose: () => void;
  onCreated: (runNo: string) => void;
}) {
  const today = getTodayLocal();
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [dateFrom, setDateFrom] = useState(shiftDays(today, -7));
  const [dateTo, setDateTo] = useState(shiftDays(today, 7));
  const [rows, setRows] = useState<PlanRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [picked, setPicked] = useState<PlanRow | null>(null);
  const [productRunType, setProductRunType] = useState('P');
  const [modelClass, setModelClass] = useState('');
  const [pcbWeek, setPcbWeek] = useState('');
  const [saving, setSaving] = useState(false);

  const search = useCallback(async () => {
    if (!lineCode) { toast.error('라인을 고르세요.'); return; }
    setLoading(true);
    try {
      const res = await api.get('/production/lot-card/plans', { params: { lineCode, modelName: modelName || undefined, dateFrom, dateTo } });
      setRows(res.data?.data ?? []);
      setPicked(null);
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setLoading(false);
    }
  }, [lineCode, modelName, dateFrom, dateTo]);

  const create = useCallback(async () => {
    if (!picked) return;
    if (!productRunType) { toast.error('제조유형을 고르세요.'); return; }
    setSaving(true);
    try {
      const res = await api.post('/production/lot-card/from-plan', {
        planType: picked.planType, planDate: picked.planDate, planSequence: picked.planSequence, mfs: picked.mfs,
        productRunType, modelClass: modelClass || undefined, pcbWeek: pcbWeek || undefined,
      });
      const runNo = res.data?.data?.runNo as string;
      toast.success(`롯트카드 ${runNo} 를 만들었습니다 (${Number(res.data?.data?.lotSize ?? 0).toLocaleString()}개).`);
      onCreated(runNo);
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setSaving(false);
    }
  }, [picked, productRunType, modelClass, pcbWeek, onCreated]);

  /** 제조번호가 '*' 인 계획 — 롯트카드 LOT_NO 가 '*' 가 되어 다른 계획과 섞이므로 서버도 거부한다 */
  const noMfs = Boolean(picked && (!picked.mfs || picked.mfs === '*'));

  const columns = useMemo<ColumnDef<PlanRow>[]>(() => [
    { accessorKey: 'itemCode', header: '품목코드', size: 130 },
    { accessorKey: 'itemName', header: '품명', size: 200 },
    { accessorKey: 'planDate', header: '계획일자', size: 100 },
    { accessorKey: 'planSequence', header: '순번', size: 80 },
    { accessorKey: 'mfs', header: '제조번호', size: 110 },
    { accessorKey: 'lineCode', header: '라인', size: 70 },
    { accessorKey: 'modelName', header: '모델명', size: 200 },
    { accessorKey: 'shiftCode', header: '근무조', size: 70 },
    { accessorKey: 'pcbItem', header: 'T/B', size: 60 },
    { accessorKey: 'planQty', header: '계획수량', size: 90, meta: { align: 'right' }, cell: (c) => Number(c.getValue() ?? 0).toLocaleString() },
    { accessorKey: 'lotQty', header: '롯트카드', size: 90, meta: { align: 'right' }, cell: (c) => (c.getValue() == null ? '' : Number(c.getValue()).toLocaleString()) },
    { accessorKey: 'remainQty', header: '남은수량', size: 90, meta: { align: 'right' }, cell: (c) => Number(c.getValue() ?? 0).toLocaleString() },
    { accessorKey: 'workOrderNo', header: '작업지시번호', size: 140 },
    { accessorKey: 'mfsGroupNo', header: '제조그룹번호', size: 120 },
    { accessorKey: 'planStatus', header: '상태', size: 60 },
  ], []);

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="계획에서 롯트카드 생성" size="full">
      <div className="flex h-[72vh] flex-col gap-3">
        <div className="flex flex-wrap items-center gap-2">
          <ProdLineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-48" />
          <ModelSearchField placeholder="모델명" value={modelName} className="w-52" onChange={(v) => setModelName(v)} />
          <DateRangeFilter label="계획일" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={() => void search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
        <div className="min-h-0 flex-1">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            getRowId={(r) => planKey(r as PlanRow)}
            selectedRowId={picked ? planKey(picked) : undefined}
            onRowClick={(r) => setPicked(r as PlanRow)}
            emptyMessage={lineCode ? '남은 수량이 있는 계획이 없습니다.' : '라인을 고르고 조회하세요.'}
          />
        </div>
        <div className="flex flex-wrap items-center gap-2 border-t border-border pt-3">
          <span className={`text-sm ${noMfs ? 'text-red-500' : 'text-text-muted'}`}>
            {!picked
              ? '계획을 한 줄 고르세요.'
              : noMfs
                ? '이 계획은 제조번호가 없어(*) 롯트카드와 이을 수 없습니다.'
                : `${picked.mfs} · ${picked.modelName} · ${picked.remainQty.toLocaleString()}개 → 지시일 ${picked.planDate}`}
          </span>
          <div className="ml-auto flex flex-wrap items-center gap-2">
            <ComCodeSelect groupCode="PRODUCT RUN TYPE" labelPrefix="제조유형" includeAll={false}
              value={productRunType} onChange={setProductRunType} className="w-44" />
            <ComCodeSelect groupCode="MODEL CLASS" labelPrefix="모델클래스" value={modelClass} onChange={setModelClass} className="w-48" />
            <Input aria-label="PCB 주차" placeholder="PCB 주차" value={pcbWeek} className="w-28"
              onChange={(e) => setPcbWeek(e.target.value)} />
            <Button onClick={() => void create()} disabled={!picked || saving || noMfs || !(picked.remainQty > 0)}>
              <Plus className="mr-1 h-4 w-4" />롯트카드 생성
            </Button>
          </div>
        </div>
      </div>
    </Modal>
  );
}
