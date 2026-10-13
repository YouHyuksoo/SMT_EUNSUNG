'use client';

/**
 * @file (authenticated)/oee/master/equip-reason-map/page.tsx
 * @description 설비별 비가동코드 관리 — 설비마스터(IMCN_MACHINE) × 비가동사유코드(IP_EQUIP_DOWNTIME_REASON) 매핑 등록·조회 (실 DB 연결)
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1):
 *   GET/POST/PUT /oee/equip-reason-map , DELETE /oee/equip-reason-map/:machineCode
 *   설비 피커: GET /equipment/equips (설비마스터 재사용) · 사유 피커: GET /oee/idle-reason 중 USE_YN='Y'
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, Edit2, Trash2, RefreshCw } from 'lucide-react';
import toast from 'react-hot-toast';
import Modal from '@/components/ui/Modal';
import { Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import EquipSearchModal, { type EquipItem } from '@/components/shared/EquipSearchModal';
import api from '@/services/api';

// 비가동 사유 구분 — 계획/비계획 (소스 고정 코드)
const REASON_TYPES = [
  { code: 'PLAN', name: '계획' },
  { code: 'UNPLAN', name: '비계획' },
] as const;
const reasonTypeName = (c: string) => REASON_TYPES.find((t) => t.code === c)?.name ?? c;
const oeeReflectName = (v: string) => (v === 'Y' ? '반영' : '미반영');

// 설비마스터 참조 (GET /equipment/equips)
interface MachineRef {
  machineCode: string;
  machineName: string;
  machineType: string;
  lineCode: string;
  processCode: string;
}
// 연계 사유 (목록/편집 그리드)
interface MapReason {
  reasonCode: string;
  reasonName: string;
  reasonType: string;
  oeeReflect: string;
  useYn: string;
}
interface MachineReasonRecord extends MachineRef {
  reasons: MapReason[];
  updatedAt: string;
  updatedBy: string;
}

// API 응답 타입
interface ApiMapRow {
  machineCode: string; machineName: string | null; machineType: string | null;
  lineCode: string | null; processCode: string | null;
  reasons: Array<{ reasonCode: string; reasonName: string | null; reasonType: string | null; oeeReflect: string | null; useYn: string | null }>;
  updatedBy: string | null; updatedAt: string | null;
}
interface ApiReason { reasonCode: string; reasonName: string | null; reasonType: string | null; oeeReflect: 'Y' | 'N' | null; useYn: 'Y' | 'N' | null; }

interface EditForm extends MachineRef {
  isEdit: boolean;
  reasons: MapReason[];
  updatedAt: string;
  updatedBy: string;
}
// 사유 목록 공용 컬럼 — 사유코드 · 사유명 · 사유구분 · OEE 반영
const reasonCodeColumn: ColumnDef<MapReason> = { accessorKey: 'reasonCode', header: '사유코드', cell: ({ row }) => <span className="font-mono">{row.original.reasonCode}</span> };
const reasonTailColumns: ColumnDef<MapReason>[] = [
  { id: 'reasonType', header: '사유구분', accessorFn: (r) => reasonTypeName(r.reasonType), meta: { align: 'center' } },
  { id: 'oeeReflect', header: 'OEE 반영', accessorFn: (r) => oeeReflectName(r.oeeReflect), meta: { align: 'center' } },
];
// 미사용 사유는 흐리게 — td 의 text-inherit 보다 우선하도록 td 에 직접 건다
const unusedRowClass = (r: MapReason) => (r.useYn === 'N' ? '[&>td]:text-text-muted' : '');

/** 우측 — 선택한 설비의 비가동코드 */
const detailReasonColumns: ColumnDef<MapReason>[] = [
  reasonCodeColumn,
  { accessorKey: 'reasonName', header: '사유명' },
  ...reasonTailColumns,
  { id: 'useYn', header: '사용', accessorFn: (r) => (r.useYn === 'N' ? '미사용' : '사용'), meta: { align: 'center' } },
];

const emptyForm = (): EditForm =>({ isEdit: false, machineCode: '', machineName: '', machineType: '', lineCode: '', processCode: '', reasons: [], updatedAt: '', updatedBy: '' });

export default function EquipReasonMapPage() {
  const [records, setRecords] = useState<MachineReasonRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState<EditForm | null>(null);
  const [searchText, setSearchText] = useState('');
  const [deleteTarget, setDeleteTarget] = useState<MachineReasonRecord | null>(null);
  const [machinePickerOpen, setMachinePickerOpen] = useState(false);
  const [reasonPickerOpen, setReasonPickerOpen] = useState(false);
  const [activeReasons, setActiveReasons] = useState<MapReason[]>([]);
  const [pickerChecked, setPickerChecked] = useState<string[]>([]); // 사유선택 팝업 체크
  const [gridChecked, setGridChecked] = useState<string[]>([]); // 등록 그리드 삭제 체크

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/oee/equip-reason-map');
      const list: ApiMapRow[] = res.data?.data?.list ?? [];
      setRecords(list.map((r) => ({
        machineCode: r.machineCode,
        machineName: r.machineName ?? '',
        machineType: r.machineType ?? '',
        lineCode: r.lineCode ?? '',
        processCode: r.processCode ?? '',
        reasons: r.reasons.map((x) => ({
          reasonCode: x.reasonCode,
          reasonName: x.reasonName ?? '',
          reasonType: x.reasonType ?? '',
          oeeReflect: x.oeeReflect ?? 'N',
          useYn: x.useYn ?? 'Y',
        })),
        updatedAt: r.updatedAt ?? '',
        updatedBy: r.updatedBy ?? '',
      })));
    } catch {
      toast.error('연계 목록 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, []);
  useEffect(() => { search(); }, [search]);

  const filtered = useMemo(() => {
    const q = searchText.trim().toLowerCase();
    if (!q) return records;
    // 통합검색 — 설비코드·설비명 + 연계 사유코드·사유명에서 매칭
    return records.filter((r) => {
      const hay = [r.machineCode, r.machineName, ...r.reasons.flatMap((x) => [x.reasonCode, x.reasonName])].join(' ').toLowerCase();
      return hay.includes(q);
    });
  }, [records, searchText]);

  // 좌측에서 고른 설비. 검색으로 목록에서 빠지면 첫 설비로 옮긴다
  const [selectedCode, setSelectedCode] = useState<string | null>(null);
  const selected = useMemo(
    () => filtered.find((r) => r.machineCode === selectedCode) ?? filtered[0] ?? null,
    [filtered, selectedCode],
  );

  const columns = useMemo<ColumnDef<MachineReasonRecord>[]>(() => {
    const mono = (v: string) => <span className="font-mono">{v}</span>;
    return [
      { accessorKey: 'machineCode', header: '설비코드', cell: ({ row }) => mono(row.original.machineCode) },
      {
        accessorKey: 'machineName',
        header: '설비명',
        cell: ({ row }) => row.original.machineName || <span className="text-red-500">설비마스터에 없는 코드</span>,
      },
      { accessorKey: 'machineType', header: '설비유형', size: 100, meta: { align: 'center' as const }, cell: ({ row }) => mono(row.original.machineType) },
      { accessorKey: 'lineCode', header: '라인', size: 70, meta: { align: 'center' as const }, cell: ({ row }) => mono(row.original.lineCode) },
      { accessorKey: 'processCode', header: '공정', size: 80, meta: { align: 'center' as const }, cell: ({ row }) => mono(row.original.processCode) },
      { id: 'reasonCount', header: '비가동코드', size: 90, accessorFn: (r) => r.reasons.length, meta: { align: 'right' as const, filterType: 'number' as const } },
      { accessorKey: 'updatedAt', header: '최종수정일', cell: ({ row }) => <span className="font-mono text-text-muted">{row.original.updatedAt}</span> },
      { accessorKey: 'updatedBy', header: '최종수정자' },
    ];
  }, []);

  function openCreate() {
    setGridChecked([]);
    setForm(emptyForm());
  }
  function openEdit(r: MachineReasonRecord) {
    setGridChecked([]);
    setSelectedCode(r.machineCode);
    setForm({
      isEdit: true,
      machineCode: r.machineCode,
      machineName: r.machineName,
      machineType: r.machineType,
      lineCode: r.lineCode,
      processCode: r.processCode,
      reasons: r.reasons.map((x) => ({ ...x })),
      updatedAt: r.updatedAt,
      updatedBy: r.updatedBy,
    });
  }

  // 설비 선택 (공용 설비 검색 모달, 단일). 신규 시 이미 연계된 설비면 차단.
  function pickMachine(e: EquipItem) {
    if (!form) return;
    if (!form.isEdit && records.some((r) => r.machineCode === e.equipCode)) {
      toast.error('이미 연계된 설비입니다. 목록에서 수정하세요.');
      return;
    }
    setForm({ ...form, machineCode: e.equipCode, machineName: e.equipName, machineType: e.equipType, lineCode: e.lineCode, processCode: e.processCode });
  }

  // 사유선택 팝업 — 사용중(USE_YN='Y') 사유 로드
  const loadReasons = useCallback(async () => {
    if (activeReasons.length) return;
    try {
      const res = await api.get('/oee/idle-reason');
      const rows: ApiReason[] = res.data?.data?.list ?? [];
      setActiveReasons(rows.filter((r) => (r.useYn ?? 'Y') === 'Y').map((r) => ({
        reasonCode: r.reasonCode,
        reasonName: r.reasonName ?? '',
        reasonType: r.reasonType ?? '',
        oeeReflect: r.oeeReflect ?? 'N',
        useYn: r.useYn ?? 'Y',
      })));
    } catch {
      toast.error('비가동 사유코드 조회에 실패했습니다');
    }
  }, [activeReasons.length]);
  function openReasonPicker() { setPickerChecked([]); loadReasons(); setReasonPickerOpen(true); }

  // 사유 선택 완료 — 그리드에 병합(사유코드 중복 제거)
  function confirmReasonPicker() {
    if (!form) return;
    const existing = new Set(form.reasons.map((r) => r.reasonCode));
    const added = activeReasons.filter((r) => pickerChecked.includes(r.reasonCode) && !existing.has(r.reasonCode));
    setForm({ ...form, reasons: [...form.reasons, ...added] });
    setReasonPickerOpen(false);
  }
  function togglePicker(code: string) {
    setPickerChecked((prev) => (prev.includes(code) ? prev.filter((c) => c !== code) : [...prev, code]));
  }

  // 등록·수정 중 우측 비가동코드 그리드 — 체크박스(전체선택) 로 골라 선택삭제
  const formReasons = form?.reasons;
  const editReasonColumns = useMemo<ColumnDef<MapReason>[]>(() => {
    const list = formReasons ?? [];
    const allChecked = list.length > 0 && gridChecked.length === list.length;
    return [
      {
        id: 'select',
        size: 44,
        enableSorting: false,
        enableResizing: false,
        meta: { align: 'center' as const, filterType: 'none' as const },
        header: () => (
          <input
            type="checkbox"
            aria-label="전체 선택"
            className="w-4 h-4 accent-primary"
            checked={allChecked}
            onClick={(e) => e.stopPropagation()}
            onChange={(e) => setGridChecked(e.target.checked ? list.map((r) => r.reasonCode) : [])}
          />
        ),
        cell: ({ row }) => (
          <input
            type="checkbox"
            aria-label="줄 선택"
            className="w-4 h-4 accent-primary"
            checked={gridChecked.includes(row.original.reasonCode)}
            onClick={(e) => e.stopPropagation()}
            onChange={(e) => {
              const code = row.original.reasonCode;
              setGridChecked((prev) => (e.target.checked ? [...prev, code] : prev.filter((c) => c !== code)));
            }}
          />
        ),
      },
      reasonCodeColumn,
      {
        accessorKey: 'reasonName',
        header: '사유명',
        cell: ({ row }) => (
          <>{row.original.reasonName}{row.original.useYn === 'N' && <span className="ml-1 text-[11px] text-red-400">(미사용)</span>}</>
        ),
      },
      ...reasonTailColumns,
    ];
  }, [formReasons, gridChecked]);

  // 사유선택 팝업 — 행을 눌러도 체크가 바뀐다
  const pickerReasonColumns = useMemo<ColumnDef<MapReason>[]>(() => {
    const allChecked = activeReasons.length > 0 && pickerChecked.length === activeReasons.length;
    return [
      {
        id: 'select',
        size: 44,
        enableSorting: false,
        enableResizing: false,
        meta: { align: 'center' as const, filterType: 'none' as const },
        header: () => (
          <input
            type="checkbox"
            aria-label="전체 선택"
            className="w-4 h-4 accent-primary"
            checked={allChecked}
            onClick={(e) => e.stopPropagation()}
            onChange={(e) => setPickerChecked(e.target.checked ? activeReasons.map((r) => r.reasonCode) : [])}
          />
        ),
        cell: ({ row }) => (
          <input
            type="checkbox"
            aria-label="줄 선택"
            className="w-4 h-4 accent-primary"
            checked={pickerChecked.includes(row.original.reasonCode)}
            onClick={(e) => e.stopPropagation()} // 행 클릭(toggle)과 겹쳐 두 번 바뀌지 않게
            onChange={() => togglePicker(row.original.reasonCode)}
          />
        ),
      },
      reasonCodeColumn,
      { accessorKey: 'reasonName', header: '사유명' },
      ...reasonTailColumns,
    ];
  }, [activeReasons, pickerChecked]);

  // 그리드 체크 삭제
  function deleteCheckedReasons() {
    if (!form) return;
    setForm({ ...form, reasons: form.reasons.filter((r) => !gridChecked.includes(r.reasonCode)) });
    setGridChecked([]);
  }

  async function save() {
    if (!form) return;
    if (!form.machineCode) return toast.error('설비를 선택하세요');
    if (!form.reasons.length) return toast.error('비가동 사유코드를 1건 이상 선택하세요');

    const payload = { machineCode: form.machineCode, reasonCodes: form.reasons.map((r) => r.reasonCode) };
    try {
      if (form.isEdit) await api.put('/oee/equip-reason-map', payload);
      else await api.post('/oee/equip-reason-map', payload);
      toast.success('저장되었습니다');
      setForm(null);
      await search();
    } catch (e: unknown) {
      const msg =
        e && typeof e === 'object' && 'response' in e
          ? (e as { response?: { data?: { message?: string } } }).response?.data?.message
          : undefined;
      toast.error(msg || '저장에 실패했습니다');
    }
  }

  async function confirmDelete() {
    if (!deleteTarget) return;
    try {
      await api.delete(`/oee/equip-reason-map/${encodeURIComponent(deleteTarget.machineCode)}`);
      toast.success('삭제되었습니다');
      setDeleteTarget(null);
      await search();
    } catch {
      toast.error('삭제에 실패했습니다');
    }
  }

  return (
    <div className="flex h-full overflow-hidden">
      {/* 좌측: 메인 콘텐츠 (목록) — 독립 세로 스크롤 */}
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
        <div className="flex items-center justify-between flex-shrink-0">
          <div>
            <h1 className="text-xl font-bold text-text">설비별 비가동코드 관리</h1>
            <p className="text-sm text-text-muted mt-1">설비마다 쓸 수 있는 비가동 사유코드를 지정합니다 · 설비 {filtered.length}대</p>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={search} className="border border-border rounded px-3 h-10 text-text-muted hover:bg-surface flex items-center gap-1 whitespace-nowrap"><RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />조회</button>
            <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10 whitespace-nowrap">비가동코드 등록</button>
          </div>
        </div>

        {/* 좌측 설비 목록 · 우측 선택 설비의 비가동코드 */}
        {/* 등록·수정 중에는 설비 목록을 숨기고 비가동코드 그리드를 넓게 쓴다 */}
        <div className={`flex-1 min-h-0 grid gap-4 ${form ? 'grid-cols-1' : 'grid-cols-[minmax(0,1fr)_minmax(0,1fr)]'}`}>
          <Card className={`min-h-0 overflow-hidden ${form ? 'hidden' : ''}`} padding="none">
            <CardContent className="h-full p-4">
              <DataGrid
                data={filtered}
                columns={columns}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                enableFullscreen
                exportFileName="설비별비가동코드_설비"
                emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 설비가 없습니다'}
                getRowId={(r) => r.machineCode}
                selectedRowId={selected?.machineCode}
                onRowClick={(r) => setSelectedCode(r.machineCode)}
                keyboardRowNavigation
                toolbarLeft={
                  <div className="flex flex-wrap gap-3 flex-1 min-w-0">
                    <div className="w-80 flex-shrink-0">
                      <Input placeholder="통합검색 (설비코드·설비명·사유코드·사유명)" value={searchText} onChange={(e) => setSearchText(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
                    </div>
                  </div>
                }
              />
            </CardContent>
          </Card>

          <Card className="min-h-0 overflow-hidden" padding="none">
            {/* 설비 정보·편집 버튼은 그리드 툴바와 한 줄에 둔다 */}
            <CardContent className="h-full p-4">
              {form ? (
                <DataGrid
                  key="edit-reasons"
                  data={form.reasons}
                  columns={editReasonColumns}
                  pageSize={1000}
                  showFooter={false}
                  enableColumnFilter={false}
                  enableFullscreen={false}
                  enableColumnReordering={false}
                  enableColumnPinning={false}
                  getRowId={(r) => r.reasonCode}
                  rowClassName={unusedRowClass}
                  emptyMessage="사유코드선택으로 비가동 사유를 추가하세요"
                  toolbarLeft={
                    <div className="flex items-center gap-2 flex-1 min-w-0">
                      <p className="text-xs text-text-muted truncate flex-1 min-w-0">
                        {form.machineCode
                          ? <><span className="font-mono">{form.machineCode}</span> {form.machineName || '설비마스터에 없는 코드'} · {form.reasons.length}건</>
                          : '설비를 선택하세요'} · 저장해야 반영됩니다
                      </p>
                      <button onClick={deleteCheckedReasons} disabled={!gridChecked.length} className="text-sm border border-border rounded px-2 py-1 text-red-500 hover:bg-surface whitespace-nowrap disabled:opacity-40 disabled:cursor-not-allowed">선택삭제</button>
                      <button onClick={openReasonPicker} className="text-sm border border-border rounded px-2 py-1 text-primary hover:bg-surface whitespace-nowrap">사유코드선택</button>
                    </div>
                  }
                />
              ) : (
                <DataGrid
                  key="view-reasons"
                  data={selected?.reasons ?? []}
                  columns={detailReasonColumns}
                  pageSize={1000}
                  showFooter={false}
                  enableColumnReordering={false}
                  enableColumnPinning={false}
                  enableExport
                  exportFileName={`설비별비가동코드_${selected?.machineCode ?? ''}`}
                  getRowId={(r) => r.reasonCode}
                  rowClassName={unusedRowClass}
                  emptyMessage={selected ? '연계된 비가동코드가 없습니다' : '설비를 선택하세요'}
                  toolbarLeft={
                    <div className="flex items-center gap-2 flex-1 min-w-0">
                      <p className="text-xs text-text-muted truncate flex-1 min-w-0">
                        {selected
                          ? <><span className="font-mono">{selected.machineCode}</span> {selected.machineName || '설비마스터에 없는 코드'} · {selected.reasons.length}건</>
                          : '왼쪽에서 설비를 선택하세요'}
                      </p>
                      <button onClick={() => selected && openEdit(selected)} disabled={!selected} className="text-sm border border-border rounded px-2 py-1 text-primary hover:bg-surface whitespace-nowrap inline-flex items-center gap-1 disabled:opacity-40 disabled:cursor-not-allowed"><Edit2 className="w-3.5 h-3.5" />수정</button>
                      <button onClick={() => selected && setDeleteTarget(selected)} disabled={!selected} className="text-sm border border-border rounded px-2 py-1 text-red-500 hover:bg-surface whitespace-nowrap inline-flex items-center gap-1 disabled:opacity-40 disabled:cursor-not-allowed"><Trash2 className="w-3.5 h-3.5" />삭제</button>
                    </div>
                  }
                />
              )}
            </CardContent>
          </Card>
        </div>
      </div>

      {/* 삭제 확인 팝업 */}
      <Modal isOpen={!!deleteTarget} onClose={() => setDeleteTarget(null)} title="연계 삭제" size="sm">
        {deleteTarget && (
          <div className="space-y-4">
            <p className="text-sm text-text">
              <b className="font-mono">{deleteTarget.machineCode}</b> {deleteTarget.machineName} 설비의 비가동코드({deleteTarget.reasons.length}건)를 모두 삭제할까요?
            </p>
            <div className="flex justify-end gap-2">
              <button onClick={() => setDeleteTarget(null)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>
              <button onClick={confirmDelete} className="px-4 py-2 rounded bg-red-500 text-white text-sm">삭제</button>
            </div>
          </div>
        )}
      </Modal>

      {/* 등록/수정 — 우측 슬라이드 패널 (설비 비가동 사유코드 관리 방식) */}
      {form && (
        <div className="w-[560px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          {/* 헤더: 취소/저장 (상단) */}
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">{form.isEdit ? '설비별 비가동코드 수정' : '설비별 비가동코드 등록'}</h2>
            <div className="flex items-center gap-2">
              <button onClick={() => setForm(null)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>
              <button onClick={save} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
            </div>
          </div>
          {/* 바디 — 독립 세로 스크롤 */}
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 설비 선택 */}
            <div>
              <span className="text-sm font-semibold text-text">설비 <span className="text-red-500">*</span></span>
              <div className="grid grid-cols-2 gap-3 mt-2">
                <div className="text-sm text-text-muted flex flex-col gap-1">
                  설비코드
                  <div className="flex items-center gap-2">
                    <input value={form.machineCode} readOnly placeholder="설비선택" aria-label="설비코드" className="border border-border rounded p-2 bg-surface text-text flex-1 min-w-0 font-mono" />
                    {!form.isEdit && <button onClick={() => setMachinePickerOpen(true)} className="border border-border rounded px-3 py-2 text-primary hover:bg-surface text-sm whitespace-nowrap">설비선택</button>}
                  </div>
                </div>
                <label className="text-sm text-text-muted flex flex-col gap-1">
                  설비명
                  <input value={form.machineName} readOnly className="border border-border rounded p-2 bg-surface text-text" />
                </label>
                <label className="text-sm text-text-muted flex flex-col gap-1">
                  설비유형 / 라인
                  <input value={[form.machineType, form.lineCode].filter(Boolean).join(' / ')} readOnly className="border border-border rounded p-2 bg-surface text-text font-mono" />
                </label>
                <label className="text-sm text-text-muted flex flex-col gap-1">
                  공정
                  <input value={form.processCode} readOnly className="border border-border rounded p-2 bg-surface text-text font-mono" />
                </label>
              </div>
            </div>

            {/* 비가동코드 — 편집은 화면의 비가동코드 그리드에서 한다 */}
            <div className="text-sm text-text-muted">
              비가동 사유코드 <span className="text-red-500">*</span> <b className="text-text">{form.reasons.length}건</b> · 왼쪽 비가동코드 목록에서 추가·삭제합니다
            </div>

            {/* 최종수정자/일 — 자동 */}
            <div className="flex gap-6 text-sm text-text-muted border-t border-border pt-4">
              <span>최종수정자 <b className="text-text">{form.isEdit ? (form.updatedBy || '-') : '저장 시 자동(로그인 사용자)'}</b></span>
              <span>최종수정일 <b className="text-text">{form.isEdit ? (form.updatedAt || '-') : '저장 시 자동 기록'}</b></span>
            </div>
          </div>
          {/* 패널 최하단 라인 */}
          <div className="flex-shrink-0 border-t border-border" />
        </div>
      )}

      {/* 설비선택 — 공용 설비 검색 모달 (설비마스터 IMCN_MACHINE) */}
      <EquipSearchModal isOpen={machinePickerOpen} onClose={() => setMachinePickerOpen(false)} onSelect={pickMachine} />

      {/* 사유코드선택 팝업 — 설비 비가동 사유코드(사용중) 참조, 복수 선택 */}
      <Modal isOpen={reasonPickerOpen} onClose={() => setReasonPickerOpen(false)} title="비가동 사유코드 선택 (복수)" size="2xl">
        <div className="space-y-3">
          <DataGrid
            data={activeReasons}
            columns={pickerReasonColumns}
            pageSize={1000}
            maxHeight="55vh"
            showFooter={false}
            enableFullscreen={false}
            getRowId={(r) => r.reasonCode}
            onRowClick={(r) => togglePicker(r.reasonCode)}
            emptyMessage="사용중인 비가동 사유코드가 없습니다"
          />
          <div className="flex justify-end gap-2">
            <button onClick={() => setReasonPickerOpen(false)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>
            <button onClick={confirmReasonPicker} disabled={!pickerChecked.length} className="px-4 py-2 rounded bg-primary text-white text-sm disabled:opacity-40 disabled:cursor-not-allowed">선택완료 ({pickerChecked.length})</button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
