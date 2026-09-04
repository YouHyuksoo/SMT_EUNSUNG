'use client';

/**
 * @file (authenticated)/production/run-card/page.tsx
 * @description 작업지시관리 — IP_PRODUCT_RUN_CARD 조회·등록·수정·삭제 (실 DB 연결)
 *
 * PowerBuilder 원본 w_product_run_card 를 참조한다.
 *  - 검색 조건은 PB 의 Where Condition(기간 + Run No/Model/Line/Lot)과 동일
 *  - 작업지시번호(RUN_NO)는 서버가 F_GET_NEW_RUN_NO 로 채번하므로 입력받지 않는다
 *  - 삭제는 PID·작업실적·런카드상세가 있으면 서버가 409 로 차단한다
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1):
 *   GET /production/run-card , POST/PUT /production/run-card , DELETE /production/run-card/:runNo
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Edit2, Plus, RefreshCw, Search, Trash2 } from 'lucide-react';
import toast from 'react-hot-toast';
import Modal from '@/components/ui/Modal';
import { Button, Card, CardContent, Input } from '@/components/ui';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import ModelSearchModal from '@/components/shared/ModelSearchModal';
import DataGrid from '@/components/data-grid/DataGrid';
import { useComCodeMap } from '@/hooks/useComCode';
import api from '@/services/api';

/** 목록 행 — 백엔드 RunCardRow 와 1:1 */
interface RunCard {
  runNo: string; runDate: string; lotNo: string; itemCode: string; itemName: string | null;
  itemSpec: string | null; unit: string | null; modelName: string; modelSpec: string | null;
  customerName: string | null; lineCode: string; lineName: string | null; lotSize: number;
  charger: string; shiftCode: string | null; markingNo: string | null; pcbSupplierCode: string | null;
  runStatus: string | null; carrierSize: number | null; productRunType: string | null;
  arrayType: string | null; activeYn: string | null; parentItemCode: string | null;
  pcbItem: string | null; masterModelName: string | null; mfsGroupNo: string | null;
  revision: string | null; modelClass: string | null; pcbWeek: string | null; comments: string | null;
  pidCount: number; resultCount: number; updatedBy: string | null; updatedAt: string | null;
}

interface EditForm {
  isEdit: boolean;
  runNo: string; runDate: string; lotNo: string; itemCode: string; modelName: string;
  lineCode: string; lotSize: string; charger: string; shiftCode: string; markingNo: string;
  pcbSupplierCode: string; runStatus: string; carrierSize: string; productRunType: string;
  arrayType: string; activeYn: string; parentItemCode: string; pcbItem: string;
  masterModelName: string; mfsGroupNo: string; revision: string; modelClass: string;
  pcbWeek: string; comments: string;
}

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => new Date(Date.now() - n * 86400000).toISOString().slice(0, 10);

const emptyForm = (): EditForm => ({
  isEdit: false, runNo: '', runDate: today(), lotNo: '', itemCode: '', modelName: '',
  lineCode: '', lotSize: '', charger: '', shiftCode: 'A', markingNo: '', pcbSupplierCode: '',
  runStatus: '1', carrierSize: '', productRunType: 'P', arrayType: '', activeYn: 'N',
  parentItemCode: '', pcbItem: '', masterModelName: '', mfsGroupNo: '', revision: '',
  modelClass: '', pcbWeek: '', comments: '',
});

const toForm = (r: RunCard): EditForm => ({
  isEdit: true, runNo: r.runNo, runDate: r.runDate, lotNo: r.lotNo, itemCode: r.itemCode,
  modelName: r.modelName, lineCode: r.lineCode, lotSize: String(r.lotSize ?? ''),
  charger: r.charger ?? '', shiftCode: r.shiftCode ?? '', markingNo: r.markingNo ?? '',
  pcbSupplierCode: r.pcbSupplierCode ?? '', runStatus: r.runStatus ?? '',
  carrierSize: r.carrierSize != null ? String(r.carrierSize) : '',
  productRunType: r.productRunType ?? '', arrayType: r.arrayType ?? '', activeYn: r.activeYn ?? 'N',
  parentItemCode: r.parentItemCode ?? '', pcbItem: r.pcbItem ?? '',
  masterModelName: r.masterModelName ?? '', mfsGroupNo: r.mfsGroupNo ?? '',
  revision: r.revision ?? '', modelClass: r.modelClass ?? '', pcbWeek: r.pcbWeek ?? '',
  comments: r.comments ?? '',
});

export default function RunCardPage() {
  const [rows, setRows] = useState<RunCard[]>([]);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState<EditForm | null>(null);
  const [saving, setSaving] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState<RunCard | null>(null);
  const [modelPickerOpen, setModelPickerOpen] = useState(false);

  // 검색 조건 — PB Where Condition 과 동일
  const [fromDate, setFromDate] = useState(daysAgo(30));
  const [toDate, setToDate] = useState(today());
  const [runNo, setRunNo] = useState('');
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [lotNo, setLotNo] = useState('');

  const statusMap = useComCodeMap('RUN STATUS');
  const runTypeMap = useComCodeMap('PRODUCT RUN TYPE');

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/production/run-card', {
        params: { fromDate, toDate, runNo, modelName, lineCode, lotNo },
      });
      setRows(res.data?.data?.list ?? []);
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : '작업지시 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [fromDate, toDate, runNo, modelName, lineCode, lotNo]);

  useEffect(() => { void load(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const set = (key: keyof EditForm, value: string) =>
    setForm((prev) => (prev ? { ...prev, [key]: value } : prev));

  const save = async () => {
    if (!form) return;
    if (!form.runDate || !form.lotNo || !form.itemCode || !form.modelName || !form.lineCode) {
      toast.error('지시일자·LOT번호·품목코드·모델명·라인은 필수입니다.');
      return;
    }
    const lotSize = Number(form.lotSize);
    if (!Number.isFinite(lotSize) || lotSize <= 0) {
      toast.error('지시수량은 1 이상이어야 합니다.');
      return;
    }
    if (!form.charger.trim()) {
      toast.error('담당자는 필수입니다.');
      return;
    }
    setSaving(true);
    try {
      const payload = {
        ...(form.isEdit ? { runNo: form.runNo } : {}),
        runDate: form.runDate, lotNo: form.lotNo, itemCode: form.itemCode,
        modelName: form.modelName, lineCode: form.lineCode, lotSize,
        charger: form.charger, shiftCode: form.shiftCode || undefined,
        markingNo: form.markingNo || undefined, pcbSupplierCode: form.pcbSupplierCode || undefined,
        runStatus: form.runStatus || undefined,
        carrierSize: form.carrierSize ? Number(form.carrierSize) : undefined,
        productRunType: form.productRunType || undefined, arrayType: form.arrayType || undefined,
        activeYn: form.activeYn || undefined, parentItemCode: form.parentItemCode || undefined,
        pcbItem: form.pcbItem || undefined, masterModelName: form.masterModelName || undefined,
        mfsGroupNo: form.mfsGroupNo || undefined, revision: form.revision || undefined,
        modelClass: form.modelClass || undefined, pcbWeek: form.pcbWeek || undefined,
        comments: form.comments || undefined,
      };
      if (form.isEdit) {
        await api.put('/production/run-card', payload);
        toast.success('작업지시를 수정했습니다.');
      } else {
        const res = await api.post('/production/run-card', payload);
        toast.success(`작업지시 ${res.data?.data?.runNo ?? ''} 를 등록했습니다.`);
      }
      setForm(null);
      await load();
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : '저장에 실패했습니다.');
    } finally {
      setSaving(false);
    }
  };

  const remove = async () => {
    if (!deleteTarget) return;
    try {
      await api.delete(`/production/run-card/${encodeURIComponent(deleteTarget.runNo)}`);
      toast.success('작업지시를 삭제했습니다.');
      setDeleteTarget(null);
      await load();
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : '삭제에 실패했습니다.');
    }
  };

  const columns = useMemo<ColumnDef<RunCard>[]>(() => [
    { accessorKey: 'runNo', header: '작업지시번호', size: 130, meta: { filterType: 'text' } },
    { accessorKey: 'runDate', header: '지시일자', size: 110, meta: { filterType: 'date' } },
    { accessorKey: 'lotNo', header: 'LOT번호', size: 120, meta: { filterType: 'text' } },
    {
      id: 'line', header: '라인', size: 110, meta: { filterType: 'text' },
      accessorFn: (r) => (r.lineName ? `${r.lineCode} - ${r.lineName}` : r.lineCode),
    },
    { accessorKey: 'modelName', header: '모델명', size: 220, meta: { filterType: 'text' } },
    { accessorKey: 'itemCode', header: '품목코드', size: 140, meta: { filterType: 'text' } },
    { accessorKey: 'itemName', header: '품명', size: 220, meta: { filterType: 'text' } },
    { accessorKey: 'lotSize', header: '지시수량', size: 100, meta: { filterType: 'number', align: 'right' } },
    { accessorKey: 'unit', header: '단위', size: 70, meta: { filterType: 'select' } },
    {
      id: 'runStatus', header: '진행상태', size: 110, meta: { filterType: 'select' },
      accessorFn: (r) => (r.runStatus ? statusMap[r.runStatus] ?? r.runStatus : ''),
    },
    {
      id: 'productRunType', header: '제조유형', size: 110, meta: { filterType: 'select' },
      accessorFn: (r) => (r.productRunType ? runTypeMap[r.productRunType] ?? r.productRunType : ''),
    },
    { accessorKey: 'charger', header: '담당자', size: 90, meta: { filterType: 'text' } },
    { accessorKey: 'customerName', header: '고객사', size: 140, meta: { filterType: 'text' } },
    { accessorKey: 'pidCount', header: 'PID', size: 80, meta: { filterType: 'number', align: 'right' } },
    { accessorKey: 'resultCount', header: '실적', size: 80, meta: { filterType: 'number', align: 'right' } },
    { accessorKey: 'updatedBy', header: '수정자', size: 90, meta: { filterType: 'text' } },
    { accessorKey: 'updatedAt', header: '수정일시', size: 140, meta: { filterType: 'text' } },
    {
      id: 'actions', header: '작업', size: 80, enableSorting: false, meta: { filterType: 'none' as const },
      cell: ({ row }) => (
        <div className="flex gap-1 justify-center">
          <button
            onClick={(e) => { e.stopPropagation(); setForm(toForm(row.original)); }}
            className="p-1 hover:bg-surface rounded text-primary" title="수정"
          >
            <Edit2 className="w-3.5 h-3.5" />
          </button>
          <button
            onClick={(e) => { e.stopPropagation(); setDeleteTarget(row.original); }}
            className="p-1 hover:bg-surface rounded text-red-500" title="삭제"
          >
            <Trash2 className="w-3.5 h-3.5" />
          </button>
        </div>
      ),
    },
  ], [statusMap, runTypeMap]);

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4">
      <div className="flex justify-between items-center flex-shrink-0">
        <div>
          <h1 className="text-xl font-bold text-text">작업지시관리</h1>
          <p className="text-text-muted mt-1 text-sm">
            생산 작업지시(런카드)를 조회·등록·수정·삭제합니다. 작업지시번호는 저장 시 자동 채번됩니다.
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={() => void load()}>
            <RefreshCw className={`w-4 h-4 mr-1 ${loading ? 'animate-spin' : ''}`} />
            새로고침
          </Button>
          <Button size="sm" onClick={() => setForm(emptyForm())}>
            <Plus className="w-4 h-4 mr-1" />
            등록
          </Button>
        </div>
      </div>

      <Card padding="none" className="flex-1 flex flex-col min-h-0">
        <CardContent className="flex-1 flex flex-col min-h-0 p-4">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            enableColumnFilter
            enableExport
            getRowId={(r) => r.runNo}
            onRowClick={(r) => setForm(toForm(r))}
            toolbarLeft={
              <div className="flex flex-wrap items-center gap-2">
                <Input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} />
                <span className="text-text-muted">~</span>
                <Input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} />
                <Input placeholder="작업지시번호" value={runNo} onChange={(e) => setRunNo(e.target.value)} />
                <Input placeholder="모델명" value={modelName} onChange={(e) => setModelName(e.target.value)} />
                <Input placeholder="LOT번호" value={lotNo} onChange={(e) => setLotNo(e.target.value)} />
                <ProdLineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} />
                <Button size="sm" onClick={() => void load()}>
                  <Search className="w-4 h-4 mr-1" />
                  조회
                </Button>
              </div>
            }
          />
        </CardContent>
      </Card>

      {/* 등록/수정 */}
      <Modal
        isOpen={form !== null}
        onClose={() => setForm(null)}
        title={form?.isEdit ? `작업지시 수정 — ${form.runNo}` : '작업지시 등록'}
        size="lg"
      >
        {form && (
          <div className="space-y-4">
            <div className="grid grid-cols-3 gap-3">
              <Field label="작업지시번호">
                <Input value={form.isEdit ? form.runNo : '저장 시 자동 채번'} disabled />
              </Field>
              <Field label="지시일자 *">
                <Input type="date" value={form.runDate} onChange={(e) => set('runDate', e.target.value)} />
              </Field>
              <Field label="LOT번호 *">
                <Input value={form.lotNo} onChange={(e) => set('lotNo', e.target.value)} />
              </Field>

              <Field label="모델명 *">
                <div className="flex gap-1">
                  <Input value={form.modelName} onChange={(e) => set('modelName', e.target.value)} />
                  <Button variant="secondary" size="sm" onClick={() => setModelPickerOpen(true)}>
                    <Search className="w-4 h-4" />
                  </Button>
                </div>
              </Field>
              <Field label="품목코드 *">
                <Input value={form.itemCode} onChange={(e) => set('itemCode', e.target.value)} />
              </Field>
              <Field label="라인 *">
                <ProdLineSelect value={form.lineCode} onChange={(v) => set('lineCode', v)} fullWidth />
              </Field>

              <Field label="지시수량 *">
                <Input type="number" value={form.lotSize} onChange={(e) => set('lotSize', e.target.value)} />
              </Field>
              <Field label="담당자 *">
                <Input value={form.charger} onChange={(e) => set('charger', e.target.value)} />
              </Field>
              <Field label="교대조">
                <ComCodeSelect groupCode="SHIFT CODE" includeAll={false} value={form.shiftCode} onChange={(v) => set('shiftCode', v)} fullWidth />
              </Field>

              <Field label="진행상태">
                <ComCodeSelect groupCode="RUN STATUS" includeAll={false} value={form.runStatus} onChange={(v) => set('runStatus', v)} fullWidth />
              </Field>
              <Field label="제조유형">
                <ComCodeSelect groupCode="PRODUCT RUN TYPE" includeAll={false} value={form.productRunType} onChange={(v) => set('productRunType', v)} fullWidth />
              </Field>
              <Field label="활성유무">
                <ComCodeSelect groupCode="ACTIVE YN" includeAll={false} value={form.activeYn} onChange={(v) => set('activeYn', v)} fullWidth />
              </Field>

              <Field label="연배열수">
                <Input type="number" value={form.carrierSize} onChange={(e) => set('carrierSize', e.target.value)} />
              </Field>
              <Field label="에레이타입">
                <ComCodeSelect groupCode="ARRAY TYPE" includeAll={false} value={form.arrayType} onChange={(v) => set('arrayType', v)} fullWidth />
              </Field>
              <Field label="T/B">
                <ComCodeSelect groupCode="PCB ITEM" includeAll={false} value={form.pcbItem} onChange={(v) => set('pcbItem', v)} fullWidth />
              </Field>

              <Field label="모델클래스">
                <ComCodeSelect groupCode="MODEL CLASS" includeAll={false} value={form.modelClass} onChange={(v) => set('modelClass', v)} fullWidth />
              </Field>
              <Field label="마킹번호">
                <Input value={form.markingNo} onChange={(e) => set('markingNo', e.target.value)} />
              </Field>
              <Field label="PCB 공급상">
                <Input value={form.pcbSupplierCode} onChange={(e) => set('pcbSupplierCode', e.target.value)} />
              </Field>

              <Field label="대표모델명">
                <Input value={form.masterModelName} onChange={(e) => set('masterModelName', e.target.value)} />
              </Field>
              <Field label="모부품코드">
                <Input value={form.parentItemCode} onChange={(e) => set('parentItemCode', e.target.value)} />
              </Field>
              <Field label="제조그룹번호">
                <Input value={form.mfsGroupNo} onChange={(e) => set('mfsGroupNo', e.target.value)} />
              </Field>

              <Field label="Revision">
                <Input value={form.revision} onChange={(e) => set('revision', e.target.value)} />
              </Field>
              <Field label="PCB 주차">
                <Input value={form.pcbWeek} onChange={(e) => set('pcbWeek', e.target.value)} />
              </Field>
            </div>

            <Field label="설명">
              <Input value={form.comments} onChange={(e) => set('comments', e.target.value)} fullWidth />
            </Field>

            <div className="flex justify-end gap-2 pt-2">
              <Button variant="secondary" onClick={() => setForm(null)}>취소</Button>
              <Button onClick={() => void save()} disabled={saving}>
                {saving ? '저장 중...' : '저장'}
              </Button>
            </div>
          </div>
        )}
      </Modal>

      {/* 모델 검색 */}
      <ModelSearchModal
        isOpen={modelPickerOpen}
        onClose={() => setModelPickerOpen(false)}
        onSelect={(m) => {
          setForm((prev) => (prev ? { ...prev, modelName: m.modelName || prev.modelName } : prev));
          setModelPickerOpen(false);
        }}
      />

      {/* 삭제 확인 */}
      <Modal isOpen={deleteTarget !== null} onClose={() => setDeleteTarget(null)} title="작업지시 삭제" size="sm">
        {deleteTarget && (
          <div className="space-y-4">
            <p className="text-text">
              작업지시 <strong>{deleteTarget.runNo}</strong>({deleteTarget.modelName})를 삭제할까요?
            </p>
            {(deleteTarget.pidCount > 0 || deleteTarget.resultCount > 0) && (
              <p className="text-sm text-red-500">
                PID {deleteTarget.pidCount}건 · 작업실적 {deleteTarget.resultCount}건이 연결되어 있어 삭제가 차단됩니다.
              </p>
            )}
            <div className="flex justify-end gap-2">
              <Button variant="secondary" onClick={() => setDeleteTarget(null)}>취소</Button>
              <Button onClick={() => void remove()}>삭제</Button>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="flex flex-col gap-1">
      <label className="text-xs text-text-muted">{label}</label>
      {children}
    </div>
  );
}
