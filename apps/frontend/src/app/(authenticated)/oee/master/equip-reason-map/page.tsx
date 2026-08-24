'use client';

/**
 * @file (authenticated)/oee/master/equip-reason-map/page.tsx
 * @description 설비별 비가동 사유 연계 — 설비마스터(IMCN_MACHINE) × 비가동사유코드(IP_EQUIP_DOWNTIME_REASON) 매핑 등록·조회 (실 DB 연결)
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
interface ApiEquip { equipCode: string; equipName: string | null; equipType: string | null; lineCode: string | null; processCode: string | null; }
interface ApiReason { reasonCode: string; reasonName: string | null; reasonType: string | null; oeeReflect: 'Y' | 'N' | null; useYn: 'Y' | 'N' | null; }

interface EditForm extends MachineRef {
  isEdit: boolean;
  reasons: MapReason[];
  updatedAt: string;
  updatedBy: string;
}
const emptyForm = (): EditForm => ({ isEdit: false, machineCode: '', machineName: '', machineType: '', lineCode: '', processCode: '', reasons: [], updatedAt: '', updatedBy: '' });

export default function EquipReasonMapPage() {
  const [records, setRecords] = useState<MachineReasonRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState<EditForm | null>(null);
  const [search, setSearch] = useState('');
  const [viewCode, setViewCode] = useState<string | null>(null); // 목록 사유 팝업
  const [deleteTarget, setDeleteTarget] = useState<MachineReasonRecord | null>(null);
  const [machinePickerOpen, setMachinePickerOpen] = useState(false);
  const [reasonPickerOpen, setReasonPickerOpen] = useState(false);
  const [machines, setMachines] = useState<MachineRef[]>([]);
  const [machineQuery, setMachineQuery] = useState('');
  const [activeReasons, setActiveReasons] = useState<MapReason[]>([]);
  const [pickerChecked, setPickerChecked] = useState<string[]>([]); // 사유선택 팝업 체크
  const [gridChecked, setGridChecked] = useState<string[]>([]); // 등록 그리드 삭제 체크

  const load = useCallback(async () => {
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
  useEffect(() => { load(); }, [load]);

  const viewRec = useMemo(() => records.find((r) => r.machineCode === viewCode) ?? null, [records, viewCode]);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return records;
    // 통합검색 — 설비코드·설비명 + 연계 사유코드·사유명에서 매칭
    return records.filter((r) => {
      const hay = [r.machineCode, r.machineName, ...r.reasons.flatMap((x) => [x.reasonCode, x.reasonName])].join(' ').toLowerCase();
      return hay.includes(q);
    });
  }, [records, search]);

  const columns = useMemo<ColumnDef<MachineReasonRecord>[]>(
    () => [
      {
        id: 'actions',
        header: '관리',
        size: 84,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (
          <div className="flex gap-1 justify-center">
            <button onClick={(e) => { e.stopPropagation(); openEdit(row.original); }} className="p-1 hover:bg-surface rounded text-primary" title="편집">
              <Edit2 className="w-4 h-4" />
            </button>
            <button onClick={(e) => { e.stopPropagation(); setDeleteTarget(row.original); }} className="p-1 hover:bg-surface rounded text-red-500" title="삭제">
              <Trash2 className="w-4 h-4" />
            </button>
          </div>
        ),
      },
      { accessorKey: 'machineCode', header: '설비코드', cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'machineName', header: '설비명' },
      { accessorKey: 'machineType', header: '설비유형', size: 100, meta: { align: 'center' as const }, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'lineCode', header: '라인', size: 70, meta: { align: 'center' as const }, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'processCode', header: '공정', size: 80, meta: { align: 'center' as const }, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      {
        id: 'reasons',
        header: '비가동 사유코드',
        size: 110,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (
          <button onClick={(e) => { e.stopPropagation(); setViewCode(row.original.machineCode); }} className="border border-border rounded px-2 py-0.5 text-primary hover:bg-surface text-xs">
            사유 {row.original.reasons.length}건
          </button>
        ),
      },
      { accessorKey: 'updatedAt', header: '최종수정일', cell: ({ getValue }) => <span className="font-mono text-text-muted">{String(getValue() ?? '')}</span> },
      { accessorKey: 'updatedBy', header: '최종수정자' },
    ],
    [],
  );

  function openCreate() {
    setGridChecked([]);
    setForm(emptyForm());
  }
  function openEdit(r: MachineReasonRecord) {
    setGridChecked([]);
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

  // 설비선택 팝업 — 설비마스터 로드
  const loadMachines = useCallback(async () => {
    if (machines.length) return;
    try {
      const res = await api.get('/equipment/equips', { params: { limit: 1000 } });
      const rows: ApiEquip[] = res.data?.data ?? res.data ?? [];
      setMachines(rows.map((e) => ({
        machineCode: e.equipCode,
        machineName: e.equipName ?? '',
        machineType: e.equipType ?? '',
        lineCode: e.lineCode ?? '',
        processCode: e.processCode ?? '',
      })));
    } catch {
      toast.error('설비마스터 조회에 실패했습니다');
    }
  }, [machines.length]);
  function openMachinePicker() { setMachineQuery(''); loadMachines(); setMachinePickerOpen(true); }

  const machineItems = useMemo(() => {
    const q = machineQuery.trim().toLowerCase();
    const base = q ? machines.filter((m) => `${m.machineCode} ${m.machineName}`.toLowerCase().includes(q)) : machines;
    return base.slice(0, 300);
  }, [machines, machineQuery]);

  // 설비 선택 (단일). 신규 시 이미 연계된 설비면 차단.
  function pickMachine(m: MachineRef) {
    if (!form) return;
    if (!form.isEdit && records.some((r) => r.machineCode === m.machineCode)) {
      toast.error('이미 연계된 설비입니다. 목록에서 수정하세요.');
      return;
    }
    setForm({ ...form, ...m });
    setMachinePickerOpen(false);
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
      await load();
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
      await load();
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
            <h1 className="text-xl font-bold text-text">설비별 비가동 사유 연계</h1>
            <p className="text-sm text-text-muted mt-1">설비마스터 × 비가동사유코드 매핑 관리</p>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={load} className="border border-border rounded px-3 h-10 text-text-muted hover:bg-surface flex items-center gap-1"><RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />새로고침</button>
            <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10">연계 등록</button>
          </div>
        </div>

        {/* 목록 화면 — 설비 비가동 사유코드 관리와 동일한 DataGrid 형식 */}
        <Card className="flex-1 min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-4">
            <DataGrid
              data={filtered}
              columns={columns}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              enableFullscreen
              exportFileName="설비별비가동사유연계"
              emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 연계가 없습니다'}
              getRowId={(r) => r.machineCode}
              toolbarLeft={
                <div className="flex flex-wrap gap-3 flex-1 min-w-0">
                  <div className="w-96 flex-shrink-0">
                    <Input placeholder="통합검색 (설비코드·설비명·사유코드·사유명)" value={search} onChange={(e) => setSearch(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
                  </div>
                </div>
              }
            />
          </CardContent>
        </Card>
      </div>

      {/* 사유코드 확인 팝업 (목록) — 연계 사유 복수 출력 */}
      <Modal isOpen={!!viewRec} onClose={() => setViewCode(null)} title={viewRec ? `비가동 사유 — ${viewRec.machineCode} ${viewRec.machineName}` : ''} size="lg">
        {viewRec && (
          <table className="w-full text-sm border border-border">
            <thead>
              <tr className="bg-surface text-text-muted">
                <th className="p-2 text-left">사유코드</th>
                <th className="p-2 text-left">사유명</th>
                <th className="p-2 text-center">사유구분</th>
                <th className="p-2 text-center">OEE 반영</th>
                <th className="p-2 text-center">사용</th>
              </tr>
            </thead>
            <tbody>
              {viewRec.reasons.map((r) => (
                <tr key={r.reasonCode} className={`border-t border-border ${r.useYn === 'N' ? 'text-text-muted' : ''}`}>
                  <td className="p-2 font-mono">{r.reasonCode}</td>
                  <td className="p-2">{r.reasonName}</td>
                  <td className="p-2 text-center">{reasonTypeName(r.reasonType)}</td>
                  <td className="p-2 text-center">{oeeReflectName(r.oeeReflect)}</td>
                  <td className="p-2 text-center">{r.useYn === 'N' ? '미사용' : '사용'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </Modal>

      {/* 삭제 확인 팝업 */}
      <Modal isOpen={!!deleteTarget} onClose={() => setDeleteTarget(null)} title="연계 삭제" size="sm">
        {deleteTarget && (
          <div className="space-y-4">
            <p className="text-sm text-text">
              <b className="font-mono">{deleteTarget.machineCode}</b> {deleteTarget.machineName} 설비의 비가동 사유 연계({deleteTarget.reasons.length}건)를 삭제할까요?
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
            <h2 className="text-sm font-bold text-text">{form.isEdit ? '설비별 비가동 사유 연계 수정' : '설비별 비가동 사유 연계 등록'}</h2>
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
                <label className="text-sm text-text-muted flex flex-col gap-1">
                  설비코드
                  <div className="flex items-center gap-2">
                    <input value={form.machineCode} readOnly placeholder="설비선택" className="border border-border rounded p-2 bg-surface text-text flex-1 min-w-0 font-mono" />
                    {!form.isEdit && <button onClick={openMachinePicker} className="border border-border rounded px-3 py-2 text-primary hover:bg-surface text-sm whitespace-nowrap">설비선택</button>}
                  </div>
                </label>
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

            {/* 비가동사유코드 선택 — 그리드(체크박스 삭제, 중복 1건) */}
            <div>
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-semibold text-text">비가동 사유코드 <span className="text-red-500">*</span></span>
                <div className="flex items-center gap-2">
                  <button onClick={deleteCheckedReasons} disabled={!gridChecked.length} className="text-sm border border-border rounded px-2 py-1 text-red-500 hover:bg-surface disabled:opacity-40 disabled:cursor-not-allowed">선택삭제</button>
                  <button onClick={openReasonPicker} className="text-sm border border-border rounded px-2 py-1 text-primary hover:bg-surface">사유코드선택</button>
                </div>
              </div>
              <table className="w-full text-sm border border-border">
                <thead>
                  <tr className="bg-surface text-text-muted">
                    <th className="p-2 w-9 text-center">
                      <input
                        type="checkbox"
                        className="w-4 h-4 accent-primary"
                        checked={form.reasons.length > 0 && gridChecked.length === form.reasons.length}
                        onChange={(e) => setGridChecked(e.target.checked ? form.reasons.map((r) => r.reasonCode) : [])}
                      />
                    </th>
                    <th className="p-2 text-left">사유코드</th>
                    <th className="p-2 text-left">사유명</th>
                    <th className="p-2 text-center">사유구분</th>
                    <th className="p-2 text-center">OEE 반영</th>
                  </tr>
                </thead>
                <tbody>
                  {form.reasons.map((r) => (
                    <tr key={r.reasonCode} className={`border-t border-border ${r.useYn === 'N' ? 'text-text-muted' : ''}`}>
                      <td className="p-2 text-center">
                        <input
                          type="checkbox"
                          className="w-4 h-4 accent-primary"
                          checked={gridChecked.includes(r.reasonCode)}
                          onChange={(e) => setGridChecked((prev) => (e.target.checked ? [...prev, r.reasonCode] : prev.filter((c) => c !== r.reasonCode)))}
                        />
                      </td>
                      <td className="p-2 font-mono">{r.reasonCode}</td>
                      <td className="p-2">{r.reasonName}{r.useYn === 'N' && <span className="ml-1 text-[11px] text-red-400">(미사용)</span>}</td>
                      <td className="p-2 text-center">{reasonTypeName(r.reasonType)}</td>
                      <td className="p-2 text-center">{oeeReflectName(r.oeeReflect)}</td>
                    </tr>
                  ))}
                  {!form.reasons.length && (
                    <tr><td colSpan={5} className="p-3 text-center text-text-muted">사유코드선택으로 비가동 사유를 추가하세요</td></tr>
                  )}
                </tbody>
              </table>
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

      {/* 설비선택 팝업 — 설비마스터(IMCN_MACHINE) 참조, 단일 선택 */}
      <Modal isOpen={machinePickerOpen} onClose={() => setMachinePickerOpen(false)} title="설비 선택" size="2xl">
        <div className="space-y-2">
          <Input placeholder="설비코드/설비명 검색" value={machineQuery} onChange={(e) => setMachineQuery(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
          <div className="max-h-[50vh] overflow-auto border border-border rounded">
            <table className="w-full text-sm">
              <thead className="sticky top-0">
                <tr className="bg-surface text-text-muted">
                  <th className="p-2 text-left whitespace-nowrap">설비코드</th>
                  <th className="p-2 text-left">설비명</th>
                  <th className="p-2 text-center">유형</th>
                  <th className="p-2 text-center">라인</th>
                  <th className="p-2 text-center">공정</th>
                  <th className="p-2 text-center w-20">선택</th>
                </tr>
              </thead>
              <tbody>
                {machineItems.map((m) => (
                  <tr key={m.machineCode} className="border-t border-border">
                    <td className="p-2 font-mono whitespace-nowrap">{m.machineCode}</td>
                    <td className="p-2">{m.machineName}</td>
                    <td className="p-2 text-center font-mono">{m.machineType}</td>
                    <td className="p-2 text-center font-mono">{m.lineCode}</td>
                    <td className="p-2 text-center font-mono">{m.processCode}</td>
                    <td className="p-2 text-center w-20">
                      <button onClick={() => pickMachine(m)} className="px-3 py-1 rounded border border-primary text-primary hover:bg-surface text-xs whitespace-nowrap">선택</button>
                    </td>
                  </tr>
                ))}
                {!machineItems.length && <tr><td colSpan={6} className="p-4 text-center text-text-muted">설비가 없습니다</td></tr>}
              </tbody>
            </table>
          </div>
          <p className="text-[11px] text-text-muted">최대 300건 표시. 검색으로 좁혀 선택하세요.</p>
        </div>
      </Modal>

      {/* 사유코드선택 팝업 — 설비 비가동 사유코드(사용중) 참조, 복수 선택 */}
      <Modal isOpen={reasonPickerOpen} onClose={() => setReasonPickerOpen(false)} title="비가동 사유코드 선택 (복수)" size="lg">
        <div className="space-y-3">
          <table className="w-full text-sm border border-border">
            <thead>
              <tr className="bg-surface text-text-muted">
                <th className="p-2 w-9 text-center">
                  <input
                    type="checkbox"
                    className="w-4 h-4 accent-primary"
                    checked={activeReasons.length > 0 && pickerChecked.length === activeReasons.length}
                    onChange={(e) => setPickerChecked(e.target.checked ? activeReasons.map((r) => r.reasonCode) : [])}
                  />
                </th>
                <th className="p-2 text-left">사유코드</th>
                <th className="p-2 text-left">사유명</th>
                <th className="p-2 text-center">사유구분</th>
                <th className="p-2 text-center">OEE 반영</th>
              </tr>
            </thead>
            <tbody>
              {activeReasons.map((r) => (
                <tr key={r.reasonCode} className="border-t border-border cursor-pointer hover:bg-surface" onClick={() => setPickerChecked((prev) => (prev.includes(r.reasonCode) ? prev.filter((c) => c !== r.reasonCode) : [...prev, r.reasonCode]))}>
                  <td className="p-2 text-center">
                    <input type="checkbox" className="w-4 h-4 accent-primary" checked={pickerChecked.includes(r.reasonCode)} readOnly />
                  </td>
                  <td className="p-2 font-mono">{r.reasonCode}</td>
                  <td className="p-2">{r.reasonName}</td>
                  <td className="p-2 text-center">{reasonTypeName(r.reasonType)}</td>
                  <td className="p-2 text-center">{oeeReflectName(r.oeeReflect)}</td>
                </tr>
              ))}
              {!activeReasons.length && <tr><td colSpan={5} className="p-4 text-center text-text-muted">사용중인 비가동 사유코드가 없습니다</td></tr>}
            </tbody>
          </table>
          <div className="flex justify-end gap-2">
            <button onClick={() => setReasonPickerOpen(false)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>
            <button onClick={confirmReasonPicker} disabled={!pickerChecked.length} className="px-4 py-2 rounded bg-primary text-white text-sm disabled:opacity-40 disabled:cursor-not-allowed">선택완료 ({pickerChecked.length})</button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
