'use client';

/**
 * @file (authenticated)/production/run-card/page.tsx
 * @description 작업지시관리(롯트카드관리) — PB w_product_run_card_duckil
 *
 * 초보자 가이드:
 * 1. **롯트카드는 [계획에서 생성]으로 만든다.** 계획의 남은 수량·제조번호(LOT_NO)·근무조가 그대로 들어가고
 *    투입 자재(상세)도 함께 생긴다. [직접 등록]은 계획 없이 한 장을 손으로 넣는 예외 경로다.
 * 2. **행을 누르면 그 롯트카드가 '현재 행'이 된다.** 상세 생성·PID 생성·PID 라벨·마킹기 파일은 현재 행에,
 *    롯트카드 출력·출고계획은 체크한 행들(없으면 현재 행)에 적용된다.
 * 3. 삭제는 PID·작업실적·상세가 있으면 막히고, 강제삭제는 PID·상세를 함께 지운다 (QC 검사·공정실적이 있으면 거부).
 *
 * API: /production/run-card (목록·수정·삭제), /production/lot-card (PB 버튼 기능)
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import {
  Barcode, Edit2, FileDown, ListTree, Plus, Printer, QrCode, Search, Tags, Trash2,
} from 'lucide-react';
import toast from 'react-hot-toast';
import Modal from '@/components/ui/Modal';
import { Button, Card, CardContent, Input } from '@/components/ui';
import Select from '@/components/ui/Select';
import { useSupplierOptions } from '@/hooks/useMasterOptions';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import ModelSearchModal from '@/components/shared/ModelSearchModal';
import ModelSearchField from '@/components/shared/ModelSearchField';
import DataGrid from '@/components/data-grid/DataGrid';
import { useComCodeMap } from '@/hooks/useComCode';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import PartSearchField from '@/components/shared/PartSearchField';
import CustomerSelect from '@/components/shared/CustomerSelect';
import PlanPickerModal from './components/PlanPickerModal';
import PrintPreviewModal from './components/PrintPreviewModal';
import {
  IssuePlanSheets, PidLabels, RunCardSheets,
  type IssuePlanRow, type LotCardPrintRow, type PidRow,
} from './components/LotCardSheets';

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

const today = () => getTodayLocal();


type PrintState =
  | { kind: 'card'; rows: LotCardPrintRow[] }
  | { kind: 'issue'; rows: IssuePlanRow[] }
  | { kind: 'label'; rows: PidRow[]; runNo: string };

/** 라벨 미리보기 한 번에 그리는 장수 — QR 을 장마다 그리므로 너무 많으면 브라우저가 멈춘다 */
const LABEL_CHUNK = 1000;



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
  const { options: supplierOptions, isLoading: supplierLoading } = useSupplierOptions();
  const [saving, setSaving] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState<RunCard | null>(null);
  const [modelPickerOpen, setModelPickerOpen] = useState(false);

  // 현재 행(행 클릭) · 체크한 행(출력 대상)
  const [active, setActive] = useState<RunCard | null>(null);
  const [checked, setChecked] = useState<Set<string>>(new Set());

  const [planOpen, setPlanOpen] = useState(false);
  const [detailOpen, setDetailOpen] = useState(false);
  const [pidOpen, setPidOpen] = useState(false);
  const [startSerial, setStartSerial] = useState('');
  const [regenerate, setRegenerate] = useState(false);
  const [busy, setBusy] = useState(false);
  const [print, setPrint] = useState<PrintState | null>(null);
  const [labelFrom, setLabelFrom] = useState(1);

  // 검색 조건 — PB Where Condition 과 동일
  const [fromDate, setFromDate] = useState(today());
  const [toDate, setToDate] = useState(today());
  const [runNo, setRunNo] = useState('');
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [customerCode, setCustomerCode] = useState('');

  const statusMap = useComCodeMap('RUN STATUS');
  const runTypeMap = useComCodeMap('PRODUCT RUN TYPE');

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/production/run-card', {
        params: { fromDate, toDate, runNo, modelName, lineCode, lotNo, customerCode },
      });
      const list: RunCard[] = res.data?.data?.list ?? [];
      setRows(list);
      setChecked((prev) => new Set([...prev].filter((key) => list.some((r) => r.runNo === key))));
      setActive((prev) => (prev ? list.find((r) => r.runNo === prev.runNo) ?? null : null));
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : '작업지시 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [fromDate, toDate, runNo, modelName, lineCode, lotNo, customerCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps


  /** 출력 대상 — 체크한 행, 없으면 현재 행 */
  const targets = useMemo(() => {
    if (checked.size > 0) return rows.filter((r) => checked.has(r.runNo)).map((r) => r.runNo);
    return active ? [active.runNo] : [];
  }, [checked, rows, active]);

  const generateDetail = async (source: 'BOM' | 'FEEDER') => {
    if (!active) return;
    setBusy(true);
    try {
      const res = await api.post(`/production/lot-card/${encodeURIComponent(active.runNo)}/detail`, { source });
      toast.success(`${active.runNo} 상세를 ${source === 'BOM' ? '설계 BOM' : '피더 레이아웃'}으로 ${res.data?.data?.count ?? 0}건 만들었습니다.`);
      setDetailOpen(false);
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setBusy(false);
    }
  };

  const openPid = () => {
    setStartSerial('');
    setRegenerate(false);
    setPidOpen(true);
  };

  const createPids = async () => {
    if (!active) return;
    setBusy(true);
    try {
      const res = await api.post(`/production/lot-card/${encodeURIComponent(active.runNo)}/pids`, {
        regenerate: active.pidCount > 0 ? regenerate : false,
        startSerial: startSerial ? Number(startSerial) : undefined,
      });
      const d = res.data?.data ?? {};
      toast.success(`PID ${Number(d.count ?? 0).toLocaleString()}개를 만들었습니다 (${d.firstSerial} ~ ${d.lastSerial}).`);
      setPidOpen(false);
      await search();
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setBusy(false);
    }
  };

  const openPrint = async (kind: 'card' | 'issue') => {
    if (targets.length === 0) return;
    setBusy(true);
    try {
      const res = await api.get(`/production/lot-card/${kind === 'card' ? 'print' : 'issue-plan'}`, {
        params: { runNos: targets.join(',') },
      });
      const data = res.data?.data ?? [];
      if (data.length === 0) {
        toast.error(kind === 'card' ? '출력할 롯트카드가 없습니다.' : '투입 자재(상세)가 없습니다. [상세 생성]을 먼저 하세요.');
        return;
      }
      setPrint(kind === 'card' ? { kind: 'card', rows: data } : { kind: 'issue', rows: data });
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setBusy(false);
    }
  };

  const openLabels = async () => {
    if (!active) return;
    if (active.pidCount === 0) { toast.error('PID 가 없습니다. [PID 생성]을 먼저 하세요.'); return; }
    setBusy(true);
    try {
      const res = await api.get(`/production/lot-card/${encodeURIComponent(active.runNo)}/pids`);
      setLabelFrom(1);
      setPrint({ kind: 'label', rows: res.data?.data ?? [], runNo: active.runNo });
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setBusy(false);
    }
  };

  /** 마킹기 파일 — PB 처럼 <RUN_NO>.JOB (머리글 없는 CSV 한 줄) 로 내려받는다 */
  const downloadMarkingFile = async () => {
    if (!active) return;
    try {
      const res = await api.get(`/production/lot-card/${encodeURIComponent(active.runNo)}/marking-file`);
      const { fileName, content } = res.data?.data ?? {};
      const url = URL.createObjectURL(new Blob([content ?? ''], { type: 'text/plain' }));
      const a = document.createElement('a');
      a.href = url;
      a.download = fileName ?? `${active.runNo}.JOB`;
      a.click();
      URL.revokeObjectURL(url);
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    }
  };

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
      await search();
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
      await search();
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : '삭제에 실패했습니다.');
    }
  };

  /**
   * 강제삭제 — PB w_product_run_card_duckil 의 cbx_force_delete 경로.
   * PID 매핑과 런카드 상세를 함께 지운다. QC 검사된 PID 나 공정실적이 있으면
   * 서버가 여전히 409 로 막는다 — 지우면 되돌릴 수 없는 이력이다.
   */
  const removeForce = async () => {
    if (!deleteTarget) return;
    try {
      const response = await api.delete(
        `/production/run-card/${encodeURIComponent(deleteTarget.runNo)}/force`,
      );
      toast.success(
        `작업지시와 연결 데이터 ${response.data?.data?.deleted ?? 0}건을 삭제했습니다.`,
      );
      setDeleteTarget(null);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? (error instanceof Error ? error.message : '강제삭제에 실패했습니다.'));
    }
  };

  const allChecked = rows.length > 0 && rows.every((r) => checked.has(r.runNo));
  const columns = useMemo<ColumnDef<RunCard>[]>(() => [
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
    {
      id: 'select', size: 40, enableSorting: false, meta: { filterType: 'none' as const },
      header: () => (
        <input type="checkbox" aria-label="전체 선택" checked={allChecked}
          onChange={() => setChecked(allChecked ? new Set() : new Set(rows.map((r) => r.runNo)))} />
      ),
      cell: ({ row }) => (
        <input type="checkbox" aria-label="선택" checked={checked.has(row.original.runNo)}
          onClick={(e) => e.stopPropagation()}
          onChange={() => setChecked((prev) => {
            const next = new Set(prev);
            if (next.has(row.original.runNo)) next.delete(row.original.runNo);
            else next.add(row.original.runNo);
            return next;
          })} />
      ),
    },
    { accessorKey: 'itemCode', header: '품목코드', size: 140, meta: { filterType: 'text' } },
    { accessorKey: 'itemName', header: '품명', size: 220, meta: { filterType: 'text' } },
    { accessorKey: 'runNo', header: '작업지시번호', size: 130, meta: { filterType: 'text' } },
    { accessorKey: 'runDate', header: '지시일자', size: 110, meta: { filterType: 'date' } },
    { accessorKey: 'lotNo', header: 'LOT번호', size: 120, meta: { filterType: 'text' } },
    {
      id: 'line', header: '라인', size: 110, meta: { filterType: 'text' },
      accessorFn: (r) => (r.lineName ? `${r.lineCode} - ${r.lineName}` : r.lineCode),
    },
    { accessorKey: 'modelName', header: '모델명', size: 220, meta: { filterType: 'text' } },
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
  ], [statusMap, runTypeMap, checked, allChecked, rows]);

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4">
      <div className="flex justify-between items-center flex-shrink-0">
        <div>
          <h1 className="text-xl font-bold text-text">작업지시관리</h1>
          <p className="text-text-muted mt-1 text-sm">
            생산계획으로 롯트카드를 만들고 상세·PID·출력물을 만듭니다 ·{' '}
            {active ? `현재 ${active.runNo}` : '행을 누르면 현재 롯트카드가 됩니다'}
            {checked.size > 0 ? ` · 체크 ${checked.size}장` : ''}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={() => setPlanOpen(true)}>
            <Plus className="w-4 h-4 mr-1" />계획에서 생성
          </Button>
          <Button size="sm" variant="secondary" onClick={() => setForm(emptyForm())}>
            <Plus className="w-4 h-4 mr-1" />직접 등록
          </Button>
          <Button size="sm" variant="secondary" disabled={!active || busy} onClick={() => setDetailOpen(true)}>
            <ListTree className="w-4 h-4 mr-1" />상세 생성
          </Button>
          <Button size="sm" variant="secondary" disabled={!active || busy} onClick={openPid}>
            <QrCode className="w-4 h-4 mr-1" />PID 생성
          </Button>
          <Button size="sm" variant="secondary" disabled={targets.length === 0 || busy} onClick={() => void openPrint('card')}>
            <Printer className="w-4 h-4 mr-1" />롯트카드 출력
          </Button>
          <Button size="sm" variant="secondary" disabled={targets.length === 0 || busy} onClick={() => void openPrint('issue')}>
            <Printer className="w-4 h-4 mr-1" />출고계획 출력
          </Button>
          <Button size="sm" variant="secondary" disabled={!active || busy} onClick={() => void openLabels()}>
            <Tags className="w-4 h-4 mr-1" />PID 라벨 출력
          </Button>
          <Button size="sm" variant="secondary" disabled={!active || busy} onClick={() => void downloadMarkingFile()}>
            <FileDown className="w-4 h-4 mr-1" />마킹기 파일
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
            selectedRowId={active?.runNo}
            onRowClick={(r) => setActive(r)}
            toolbarLeft={
              <div className="flex flex-wrap items-center gap-2">
                <Input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} />
                <span className="text-text-muted">~</span>
                <Input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} />
                <Input placeholder="작업지시번호" value={runNo} onChange={(e) => setRunNo(e.target.value)} />
                <ModelSearchField placeholder="모델명" value={modelName} className="w-44" onChange={(v) => setModelName(v)} />
                <Input placeholder="LOT번호" value={lotNo} onChange={(e) => setLotNo(e.target.value)} />
                <ProdLineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} />
                <CustomerSelect includeAll value={customerCode} onChange={setCustomerCode} className="w-48" />
                <Button size="sm" onClick={() => void search()}>
                  <Search className="w-4 h-4 mr-1" />
                  조회
                </Button>
              </div>
            }
          />
        </CardContent>
      </Card>


      <PlanPickerModal
        isOpen={planOpen}
        onClose={() => setPlanOpen(false)}
        onCreated={(newRunNo) => {
          setPlanOpen(false);
          toast(`${newRunNo} 는 계획일자로 만들어집니다. 조회 기간에 그 날짜가 들어 있어야 목록에 보입니다.`);
          void search();
        }}
      />

      {/* 상세 생성 */}
      <Modal isOpen={detailOpen} onClose={() => setDetailOpen(false)} title={`상세 생성 — ${active?.runNo ?? ''}`} size="sm">
        <div className="space-y-4 text-sm">
          <p className="text-text">투입 자재 목록을 지우고 다시 만듭니다.</p>
          <ul className="list-disc space-y-1 pl-5 text-text-muted">
            <li><b className="text-text">설계 BOM</b>: 롯트카드 품목의 BOM 을 끝까지 전개합니다.</li>
            <li><b className="text-text">피더 레이아웃</b>: 이 라인·모델의 피더 배치 자재로 만듭니다.</li>
          </ul>
          <div className="flex justify-end gap-2">
            <Button variant="secondary" onClick={() => setDetailOpen(false)}>취소</Button>
            <Button variant="secondary" disabled={busy} onClick={() => void generateDetail('FEEDER')}>피더 레이아웃</Button>
            <Button disabled={busy} onClick={() => void generateDetail('BOM')}>설계 BOM</Button>
          </div>
        </div>
      </Modal>

      {/* PID 생성 */}
      <Modal isOpen={pidOpen} onClose={() => setPidOpen(false)} title={`PID 생성 — ${active?.runNo ?? ''}`} size="sm">
        {active && (
          <div className="space-y-4 text-sm">
            <p className="text-text">
              지시수량 <b>{active.lotSize.toLocaleString()}</b>개만큼 PID 를 만듭니다. 번호와 라벨 문자열은 모델 규칙(DB 함수)을 따릅니다.
            </p>
            <label className="flex flex-col gap-1">
              <span className="text-xs text-text-muted">시작 일련번호 (비우면 같은 날 마지막 번호 다음부터)</span>
              <Input type="number" min={0} max={9999} value={startSerial} onChange={(e) => setStartSerial(e.target.value)} />
            </label>
            {active.pidCount > 0 && (
              <label className="flex items-start gap-2 rounded border border-red-300 bg-red-50 p-2 text-red-700 dark:border-red-800 dark:bg-red-950 dark:text-red-300">
                <input type="checkbox" checked={regenerate} onChange={(e) => setRegenerate(e.target.checked)} className="mt-0.5" />
                <span>이미 PID {active.pidCount.toLocaleString()}개가 있습니다. 지우고 다시 만들기 — 공정에 투입된 PID 가 있으면 거부됩니다.</span>
              </label>
            )}
            <div className="flex justify-end gap-2">
              <Button variant="secondary" onClick={() => setPidOpen(false)}>취소</Button>
              <Button disabled={busy || (active.pidCount > 0 && !regenerate)} onClick={() => void createPids()}>
                <Barcode className="mr-1 h-4 w-4" />PID 생성
              </Button>
            </div>
          </div>
        )}
      </Modal>

      {/* 출력 미리보기 */}
      {print && (
        <PrintPreviewModal
          isOpen
          onClose={() => setPrint(null)}
          title={print.kind === 'card' ? '롯트카드 출력' : print.kind === 'issue' ? '출고계획 출력' : `PID 라벨 출력 — ${print.runNo}`}
          pageSize={print.kind === 'label' ? '9mm 12mm' : 'A4 portrait'}
          summary={print.kind === 'label' ? (
            <span className="flex flex-wrap items-center gap-2">
              전체 {print.rows.length.toLocaleString()}장 중
              <Input type="number" min={1} max={print.rows.length} value={labelFrom} className="w-24"
                onChange={(e) => setLabelFrom(Math.max(1, Math.min(print.rows.length, Number(e.target.value) || 1)))} />
              번부터 {Math.min(LABEL_CHUNK, print.rows.length - labelFrom + 1).toLocaleString()}장 (한 번에 {LABEL_CHUNK.toLocaleString()}장까지)
            </span>
          ) : print.kind === 'card' ? `${new Set(print.rows.map((r) => r.runNo)).size}장` : `자재 ${print.rows.length}종`}
        >
          {print.kind === 'card' && <RunCardSheets rows={print.rows} />}
          {print.kind === 'issue' && <IssuePlanSheets rows={print.rows} />}
          {print.kind === 'label' && <PidLabels rows={print.rows.slice(labelFrom - 1, labelFrom - 1 + LABEL_CHUNK)} />}
        </PrintPreviewModal>
      )}

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
                <PartSearchField value={form.itemCode} onChange={(e) => set('itemCode', e.target.value)} />
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
                <Select value={form.pcbSupplierCode} onChange={(v) => set('pcbSupplierCode', v)} fullWidth
                  disabled={supplierLoading}
                  options={[{ value: '', label: 'PCB 공급상 없음' }, ...supplierOptions]} />
              </Field>

              <Field label="대표모델명">
                <Input value={form.masterModelName} onChange={(e) => set('masterModelName', e.target.value)} />
              </Field>
              <Field label="모부품코드">
                <PartSearchField value={form.parentItemCode} onChange={(e) => set('parentItemCode', e.target.value)} />
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
              <>
                <p className="text-sm text-red-500">
                  PID {deleteTarget.pidCount}건 · 작업실적 {deleteTarget.resultCount}건이 연결되어 있어 삭제가 차단됩니다.
                </p>
                <p className="text-sm text-text-muted">
                  강제삭제는 PID 매핑과 런카드 상세를 함께 지웁니다. QC 검사된 PID 나
                  공정실적이 있으면 그때도 거부됩니다.
                </p>
              </>
            )}
            <div className="flex justify-end gap-2">
              <Button variant="secondary" onClick={() => setDeleteTarget(null)}>취소</Button>
              {(deleteTarget.pidCount > 0 || deleteTarget.resultCount > 0) && (
                <Button variant="danger" onClick={() => void removeForce()}>강제삭제</Button>
              )}
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
