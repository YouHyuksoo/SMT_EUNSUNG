'use client';

/**
 * @file (authenticated)/oee/master/equip-reason-map/page.tsx
 * @description 설비별 비가동 사유 연계 — 설비마스터 × 비가동사유코드 매핑 등록·조회 (Mock-up, 실 DB 미연결)
 */
import { useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, Edit2 } from 'lucide-react';
import Modal from '@/components/ui/Modal';
import { Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';

// 로그인 사용자(최종수정자 자동 적용) — Mock. 실 구현 시 인증 스토어에서 취득.
const CURRENT_USER = '관리자';

// 비가동 사유 구분 — 계획/비계획
const REASON_TYPES = [
  { code: 'PLAN', name: '계획' },
  { code: 'UNPLAN', name: '비계획' },
] as const;
type ReasonTypeCode = (typeof REASON_TYPES)[number]['code'];
const reasonTypeName = (c: string) => REASON_TYPES.find((t) => t.code === c)?.name ?? c;
const oeeReflectName = (v: string) => (v === 'Y' ? '반영' : '미반영');

// 설비마스터 샘플 (IMCN_MACHINE 참조) — 설비선택 팝업용 (Mock)
interface MachineRef {
  machineCode: string;
  machineName: string;
  machineType: string; // 설비유형 코드
  machineTypeName: string;
  lineCode: string;
  lineName: string;
  processCode: string;
  processName: string;
}
const SAMPLE_MACHINES: MachineRef[] = [
  { machineCode: 'CV-0541-J2', machineName: 'MOUNTER B라인 1호기', machineType: 'M0130', machineTypeName: 'MOUNTER', lineCode: '02', lineName: 'B', processCode: 'W040', processName: '마운트' },
  { machineCode: 'HIT-188E03', machineName: 'A라인 SCREEN PRINTER', machineType: 'M0110', machineTypeName: 'SP', lineCode: '01', lineName: 'A', processCode: 'W020', processName: '인쇄' },
  { machineCode: '17090805-0434', machineName: 'A라인 AOI', machineType: 'M0150', machineTypeName: 'AOI', lineCode: '01', lineName: 'A', processCode: 'W060', processName: '검사' },
  { machineCode: 'PMX12-018', machineName: 'A라인 SPI', machineType: 'M0120', machineTypeName: 'SPI', lineCode: '01', lineName: 'A', processCode: 'W030', processName: 'SPI검사' },
  { machineCode: 'CV-1478-B4', machineName: 'MOUNTER C라인 1호기', machineType: 'M0130', machineTypeName: 'MOUNTER', lineCode: '03', lineName: 'C', processCode: 'W040', processName: '마운트' },
  { machineCode: 'ICT01', machineName: '2층 ICT 1호기', machineType: 'M0160', machineTypeName: 'ICT', lineCode: '26', lineName: 'ICT', processCode: 'W090', processName: '기능검사' },
];

// 비가동사유코드 샘플 (설비 비가동 사유코드 등록 데이터) — 사유선택 팝업용 (Mock)
interface ReasonRef {
  reasonCode: string;
  reasonName: string;
  reasonType: ReasonTypeCode;
  oeeReflect: 'Y' | 'N';
}
const SAMPLE_REASONS: ReasonRef[] = [
  { reasonCode: 'DWN-CHG', reasonName: '모델 교체', reasonType: 'PLAN', oeeReflect: 'Y' },
  { reasonCode: 'DWN-MAT', reasonName: '자재 대기', reasonType: 'UNPLAN', oeeReflect: 'Y' },
  { reasonCode: 'DWN-BRK', reasonName: '설비 고장', reasonType: 'UNPLAN', oeeReflect: 'Y' },
  { reasonCode: 'DWN-CLN', reasonName: '청소/5S', reasonType: 'PLAN', oeeReflect: 'N' },
];

interface MachineReasonRecord extends MachineRef {
  id: number;
  reasons: ReasonRef[]; // 연계된 비가동사유코드 (복수)
  updatedAt: string; // YYYY-MM-DD HH:mm
  updatedBy: string;
}

// 화면 검증용 샘플 데이터
const SEED: MachineReasonRecord[] = [
  {
    id: 1,
    ...SAMPLE_MACHINES[0],
    reasons: [SAMPLE_REASONS[0], SAMPLE_REASONS[2]],
    updatedAt: '2026-07-10 09:20',
    updatedBy: '김생기',
  },
  {
    id: 2,
    ...SAMPLE_MACHINES[1],
    reasons: [SAMPLE_REASONS[1]],
    updatedAt: '2026-07-12 14:05',
    updatedBy: '박공정',
  },
  {
    id: 3,
    ...SAMPLE_MACHINES[2],
    reasons: [SAMPLE_REASONS[0], SAMPLE_REASONS[3]],
    updatedAt: '2026-07-13 11:41',
    updatedBy: '이설비',
  },
];

function nowStamp() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}

interface EditForm extends MachineRef {
  id: number | null;
  reasons: ReasonRef[];
}
const emptyMachine = (): MachineRef => ({ machineCode: '', machineName: '', machineType: '', machineTypeName: '', lineCode: '', lineName: '', processCode: '', processName: '' });
const emptyForm = (): EditForm => ({ id: null, ...emptyMachine(), reasons: [] });

export default function EquipReasonMapPage() {
  const [records, setRecords] = useState<MachineReasonRecord[]>(SEED);
  const [form, setForm] = useState<EditForm | null>(null);
  const [search, setSearch] = useState('');
  const [viewId, setViewId] = useState<number | null>(null); // 목록 사유코드 팝업
  const [machinePickerOpen, setMachinePickerOpen] = useState(false);
  const [reasonPickerOpen, setReasonPickerOpen] = useState(false);
  const [pickerChecked, setPickerChecked] = useState<string[]>([]); // 사유선택 팝업 체크
  const [gridChecked, setGridChecked] = useState<string[]>([]); // 등록 그리드 삭제 체크

  const viewRec = useMemo(() => records.find((r) => r.id === viewId) ?? null, [records, viewId]);

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
        size: 70,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (
          <button onClick={(e) => { e.stopPropagation(); openEdit(row.original); }} className="p-1 hover:bg-surface rounded" title="편집">
            <Edit2 className="w-4 h-4 text-primary" />
          </button>
        ),
      },
      { accessorKey: 'machineCode', header: '설비코드', cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'machineName', header: '설비명' },
      { accessorKey: 'machineTypeName', header: '설비유형', size: 100, meta: { align: 'center' as const } },
      { accessorKey: 'lineName', header: '라인', size: 70, meta: { align: 'center' as const } },
      { accessorKey: 'processName', header: '공정명', size: 100, meta: { align: 'center' as const } },
      {
        id: 'reasons',
        header: '사유코드',
        size: 110,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (
          <button onClick={(e) => { e.stopPropagation(); setViewId(row.original.id); }} className="border border-border rounded px-2 py-0.5 text-primary hover:bg-surface text-xs">
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
      id: r.id,
      machineCode: r.machineCode,
      machineName: r.machineName,
      machineType: r.machineType,
      machineTypeName: r.machineTypeName,
      lineCode: r.lineCode,
      lineName: r.lineName,
      processCode: r.processCode,
      processName: r.processName,
      reasons: r.reasons.map((x) => ({ ...x })),
    });
  }

  // 설비 선택 (단일)
  function pickMachine(m: MachineRef) {
    if (form) setForm({ ...form, ...m });
    setMachinePickerOpen(false);
  }

  // 사유 선택 팝업 열기 — 체크 초기화
  function openReasonPicker() {
    setPickerChecked([]);
    setReasonPickerOpen(true);
  }
  // 사유 선택 완료 — 그리드에 병합(사유코드 중복 제거)
  function confirmReasonPicker() {
    if (!form) return;
    const existing = new Set(form.reasons.map((r) => r.reasonCode));
    const added = SAMPLE_REASONS.filter((r) => pickerChecked.includes(r.reasonCode) && !existing.has(r.reasonCode));
    setForm({ ...form, reasons: [...form.reasons, ...added] });
    setReasonPickerOpen(false);
  }
  // 그리드 체크 삭제
  function deleteCheckedReasons() {
    if (!form) return;
    setForm({ ...form, reasons: form.reasons.filter((r) => !gridChecked.includes(r.reasonCode)) });
    setGridChecked([]);
  }

  function save() {
    if (!form) return;
    if (!form.machineCode) return alert('설비를 선택하세요');
    if (!form.reasons.length) return alert('비가동 사유코드를 1건 이상 선택하세요');

    const stamp = nowStamp();
    const payload: Omit<MachineReasonRecord, 'id'> = {
      machineCode: form.machineCode,
      machineName: form.machineName,
      machineType: form.machineType,
      machineTypeName: form.machineTypeName,
      lineCode: form.lineCode,
      lineName: form.lineName,
      processCode: form.processCode,
      processName: form.processName,
      reasons: form.reasons,
      updatedAt: stamp,
      updatedBy: CURRENT_USER,
    };
    if (form.id == null) {
      const id = Math.max(0, ...records.map((r) => r.id)) + 1;
      setRecords((prev) => [{ id, ...payload }, ...prev]);
    } else {
      setRecords((prev) => prev.map((r) => (r.id === form.id ? { ...r, ...payload } : r)));
    }
    setForm(null);
  }

  return (
    <div className="flex h-full overflow-hidden">
      {/* 좌측: 메인 콘텐츠 (목록) — 독립 세로 스크롤 */}
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
        <div className="flex items-center justify-between flex-shrink-0">
          <div>
            <h1 className="text-xl font-bold text-text">설비별 비가동 사유 연계</h1>
            <p className="text-sm text-text-muted mt-1">설비마스터 × 비가동사유코드 매핑 관리 (Mock-up)</p>
          </div>
          <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10">연계 등록</button>
        </div>

        {/* 목록 화면 — 설비 비가동 사유코드 관리와 동일한 DataGrid 형식 */}
        <Card className="flex-1 min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-4">
            <DataGrid
              data={filtered}
              columns={columns}
              pageSize={50}
              enableColumnFilter
              enableExport
              enableFullscreen
              exportFileName="설비별비가동사유연계"
              emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 연계가 없습니다'}
              getRowId={(r) => String(r.id)}
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
      <Modal isOpen={!!viewRec} onClose={() => setViewId(null)} title={viewRec ? `비가동 사유 — ${viewRec.machineCode} ${viewRec.machineName}` : ''} size="lg">
        {viewRec && (
          <table className="w-full text-sm border border-border">
            <thead>
              <tr className="bg-surface text-text-muted">
                <th className="p-2 text-left">사유코드</th>
                <th className="p-2 text-left">사유명</th>
                <th className="p-2 text-center">사유구분</th>
                <th className="p-2 text-center">OEE 반영</th>
              </tr>
            </thead>
            <tbody>
              {viewRec.reasons.map((r) => (
                <tr key={r.reasonCode} className="border-t border-border">
                  <td className="p-2 font-mono">{r.reasonCode}</td>
                  <td className="p-2">{r.reasonName}</td>
                  <td className="p-2 text-center">{reasonTypeName(r.reasonType)}</td>
                  <td className="p-2 text-center">{oeeReflectName(r.oeeReflect)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </Modal>

      {/* 등록/수정 — 우측 슬라이드 패널 (설비 비가동 사유코드 관리 방식) */}
      {form && (
        <div className="w-[560px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          {/* 헤더: 취소/저장 (상단) */}
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">{form.id == null ? '설비별 비가동 사유 연계 등록' : '설비별 비가동 사유 연계 수정'}</h2>
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
                    <input value={form.machineCode} readOnly placeholder="설비선택" className="border border-border rounded p-2 bg-surface text-text flex-1 min-w-0" />
                    <button onClick={() => setMachinePickerOpen(true)} className="border border-border rounded px-3 py-2 text-primary hover:bg-surface text-sm whitespace-nowrap">설비선택</button>
                  </div>
                </label>
                <label className="text-sm text-text-muted flex flex-col gap-1">
                  설비명
                  <input value={form.machineName} readOnly className="border border-border rounded p-2 bg-surface text-text" />
                </label>
                <label className="text-sm text-text-muted flex flex-col gap-1">
                  라인
                  <input value={form.lineName} readOnly className="border border-border rounded p-2 bg-surface text-text" />
                </label>
                <label className="text-sm text-text-muted flex flex-col gap-1">
                  공정
                  <input value={form.processName} readOnly className="border border-border rounded p-2 bg-surface text-text" />
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
                    <tr key={r.reasonCode} className="border-t border-border">
                      <td className="p-2 text-center">
                        <input
                          type="checkbox"
                          className="w-4 h-4 accent-primary"
                          checked={gridChecked.includes(r.reasonCode)}
                          onChange={(e) => setGridChecked((prev) => (e.target.checked ? [...prev, r.reasonCode] : prev.filter((c) => c !== r.reasonCode)))}
                        />
                      </td>
                      <td className="p-2 font-mono">{r.reasonCode}</td>
                      <td className="p-2">{r.reasonName}</td>
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
              <span>최종수정자 <b className="text-text">{form.id == null ? CURRENT_USER : records.find((r) => r.id === form.id)?.updatedBy}</b> (로그인 사용자 자동)</span>
              <span>최종수정일 <b className="text-text">저장 시 자동 기록</b></span>
            </div>
          </div>
          {/* 패널 최하단 라인 */}
          <div className="flex-shrink-0 border-t border-border" />
        </div>
      )}

      {/* 설비선택 팝업 — 설비마스터 참조, 단일 선택 */}
      <Modal isOpen={machinePickerOpen} onClose={() => setMachinePickerOpen(false)} title="설비 선택" size="lg">
        <table className="w-full text-sm border border-border">
          <thead>
            <tr className="bg-surface text-text-muted">
              <th className="p-2 text-left">설비코드</th>
              <th className="p-2 text-left">설비명</th>
              <th className="p-2 text-center">라인</th>
              <th className="p-2 text-center">공정</th>
              <th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {SAMPLE_MACHINES.map((m) => (
              <tr key={m.machineCode} className="border-t border-border">
                <td className="p-2 font-mono">{m.machineCode}</td>
                <td className="p-2">{m.machineName}</td>
                <td className="p-2 text-center">{m.lineName}</td>
                <td className="p-2 text-center">{m.processName}</td>
                <td className="p-2 text-right">
                  <button onClick={() => pickMachine(m)} className="text-primary">선택</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Modal>

      {/* 사유코드선택 팝업 — 설비 비가동 사유코드 참조, 복수 선택 */}
      <Modal isOpen={reasonPickerOpen} onClose={() => setReasonPickerOpen(false)} title="비가동 사유코드 선택 (복수)" size="lg">
        <div className="space-y-3">
          <table className="w-full text-sm border border-border">
            <thead>
              <tr className="bg-surface text-text-muted">
                <th className="p-2 w-9 text-center">
                  <input
                    type="checkbox"
                    className="w-4 h-4 accent-primary"
                    checked={pickerChecked.length === SAMPLE_REASONS.length}
                    onChange={(e) => setPickerChecked(e.target.checked ? SAMPLE_REASONS.map((r) => r.reasonCode) : [])}
                  />
                </th>
                <th className="p-2 text-left">사유코드</th>
                <th className="p-2 text-left">사유명</th>
                <th className="p-2 text-center">사유구분</th>
                <th className="p-2 text-center">OEE 반영</th>
              </tr>
            </thead>
            <tbody>
              {SAMPLE_REASONS.map((r) => (
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
