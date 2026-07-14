'use client';

/**
 * @file (authenticated)/oee/master/standard-time/page.tsx
 * @description 표준시간 관리 — 모델 기준 ST/CT/NT/TT 표준시간 등록·조회 (Mock-up, 실 DB 미연결)
 */
import { useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, Edit2 } from 'lucide-react';
import Modal from '@/components/ui/Modal';
import { Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';

// 로그인 사용자(등록자 자동 적용) — Mock. 실 구현 시 인증 스토어에서 취득.
const CURRENT_USER = '관리자';

// 표준시간 분류코드 — ST/CT/NT/TT 4개 고정 컬럼. 각 분류는 시간(초)만 관리한다.
const TIME_CATEGORIES = [
  { code: 'ST', name: 'Standard Time' },
  { code: 'CT', name: 'Cycle Time' },
  { code: 'NT', name: 'Neck Time' },
  { code: 'TT', name: 'Takt Time' },
] as const;
type CategoryCode = (typeof TIME_CATEGORIES)[number]['code'];

// 분류별 시간(초) — 4개 컬럼 고정
type StdTimes = Record<CategoryCode, number>;
const emptyTimes = (): StdTimes => ({ ST: 0, CT: 0, NT: 0, TT: 0 });

// 모델선택 팝업용 샘플 모델 마스터 (Mock)
const SAMPLE_MODELS = [
  { modelCode: 'DN8-PE', modelName: 'DN8 PE 컨트롤러' },
  { modelCode: 'MV-PRA', modelName: 'MV PRA 모듈' },
  { modelCode: 'SM200', modelName: 'SM200 센서보드' },
  { modelCode: 'N91H00', modelName: 'N91 H00 하네스' },
  { modelCode: 'X9800', modelName: 'X9800 인버터' },
];

interface StdTimeRecord {
  id: number;
  modelCode: string;
  modelName: string;
  validFrom: string;
  validTo: string; // 개방형은 '9999-12-31'
  times: StdTimes; // 분류별 시간(초) — ST/CT/NT/TT
  remark: string; // 비고
  registeredBy: string;
  updatedAt: string; // YYYY-MM-DD HH:mm
}

const OPEN_END = '9999-12-31';

// 화면 검증용 샘플 데이터 (미입력 분류는 0)
const SEED: StdTimeRecord[] = [
  { id: 1, modelCode: 'DN8-PE', modelName: 'DN8 PE 컨트롤러', validFrom: '2026-07-01', validTo: OPEN_END, times: { ST: 13.5, CT: 12.0, NT: 0, TT: 15.0 }, remark: 'SMT 기준', registeredBy: '김생기', updatedAt: '2026-07-01 09:20' },
  { id: 2, modelCode: 'DN8-PE', modelName: 'DN8 PE 컨트롤러', validFrom: '2026-04-01', validTo: '2026-06-30', times: { ST: 14.0, CT: 12.6, NT: 0, TT: 0 }, remark: '', registeredBy: '김생기', updatedAt: '2026-04-01 10:05' },
  { id: 3, modelCode: 'MV-PRA', modelName: 'MV PRA 모듈', validFrom: '2026-07-01', validTo: OPEN_END, times: { ST: 0, CT: 11.4, NT: 18.2, TT: 0 }, remark: '병목 검사', registeredBy: '박공정', updatedAt: '2026-07-09 14:41' },
];

function nowStamp() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}
const periodText = (f: string, t: string) => `${f} ~ ${t === OPEN_END ? '현재 적용' : t}`;

interface EditForm {
  id: number | null;
  modelCode: string;
  modelName: string;
  validFrom: string;
  validTo: string;
  times: StdTimes;
  remark: string;
}
const emptyForm = (): EditForm => ({ id: null, modelCode: '', modelName: '', validFrom: '', validTo: OPEN_END, times: emptyTimes(), remark: '' });

export default function StandardTimeMasterPage() {
  const [records, setRecords] = useState<StdTimeRecord[]>(SEED);
  const [form, setForm] = useState<EditForm | null>(null);
  const [modelPickerOpen, setModelPickerOpen] = useState(false);
  const [search, setSearch] = useState('');

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return records;
    // 통합검색 — 모델코드·모델명에서 매칭
    return records.filter((r) => {
      const hay = [r.modelCode, r.modelName].join(' ').toLowerCase();
      return hay.includes(q);
    });
  }, [records, search]);

  const columns = useMemo<ColumnDef<StdTimeRecord>[]>(
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
      { accessorKey: 'modelCode', header: '모델코드', cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'modelName', header: '모델명' },
      // 분류별 시간(초) — ST/CT/NT/TT 4개 컬럼
      ...TIME_CATEGORIES.map((c) => ({
        id: `time_${c.code}`,
        header: `${c.code}(초)`,
        size: 80,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }: { row: { original: StdTimeRecord } }) => {
          const v = row.original.times[c.code];
          return <span className="font-mono">{v > 0 ? v : '-'}</span>;
        },
      })),
      { id: 'period', header: '적용기간', cell: ({ row }) => periodText(row.original.validFrom, row.original.validTo) },
      { accessorKey: 'registeredBy', header: '등록자' },
      { accessorKey: 'updatedAt', header: '최근업데이트일자', cell: ({ getValue }) => <span className="font-mono text-text-muted">{String(getValue() ?? '')}</span> },
    ],
    [],
  );

  function openCreate() {
    setForm(emptyForm());
  }
  function openEdit(r: StdTimeRecord) {
    setForm({
      id: r.id,
      modelCode: r.modelCode,
      modelName: r.modelName,
      validFrom: r.validFrom,
      validTo: r.validTo,
      times: { ...r.times },
      remark: r.remark,
    });
  }

  function save() {
    if (!form) return;
    if (!form.modelCode) return alert('모델을 선택하세요');
    if (!form.validFrom) return alert('적용 시작일을 입력하세요');
    if (form.validTo !== OPEN_END && form.validTo < form.validFrom) return alert('적용 종료일은 적용 시작일보다 빠를 수 없습니다');
    if (!TIME_CATEGORIES.some((c) => form.times[c.code] > 0)) return alert('분류별 표준시간을 1개 이상 입력하세요');

    const stamp = nowStamp();
    if (form.id == null) {
      const id = Math.max(0, ...records.map((r) => r.id)) + 1;
      setRecords((prev) => [
        { id, modelCode: form.modelCode, modelName: form.modelName, validFrom: form.validFrom, validTo: form.validTo, times: form.times, remark: form.remark, registeredBy: CURRENT_USER, updatedAt: stamp },
        ...prev,
      ]);
    } else {
      setRecords((prev) =>
        prev.map((r) =>
          r.id === form.id ? { ...r, modelCode: form.modelCode, modelName: form.modelName, validFrom: form.validFrom, validTo: form.validTo, times: form.times, remark: form.remark, updatedAt: stamp } : r,
        ),
      );
    }
    setForm(null);
  }

  return (
    <div className="flex h-full overflow-hidden">
      {/* 좌측: 메인 콘텐츠 (목록) — 독립 세로 스크롤 */}
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
      <div className="flex items-center justify-between flex-shrink-0">
        <div>
          <h1 className="text-xl font-bold text-text">표준시간 관리</h1>
          <p className="text-sm text-text-muted mt-1">모델 기준 ST/CT/NT/TT 표준시간 · 적용기간 리비전 관리 (Mock-up)</p>
        </div>
        <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10">표준시간 등록</button>
      </div>

      {/* 목록 화면 — 품목관리와 동일한 DataGrid 형식 */}
      <Card className="flex-1 min-h-0 overflow-hidden" padding="none">
        <CardContent className="h-full p-4">
          <DataGrid
            data={filtered}
            columns={columns}
            pageSize={50}
            enableColumnFilter
            enableExport
            enableFullscreen
            exportFileName="표준시간관리"
            emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 표준시간이 없습니다'}
            getRowId={(r) => String(r.id)}
            toolbarLeft={
              <div className="flex flex-wrap gap-3 flex-1 min-w-0">
                <div className="w-96 flex-shrink-0">
                  <Input placeholder="통합검색 (모델코드·모델명)" value={search} onChange={(e) => setSearch(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
                </div>
              </div>
            }
          />
        </CardContent>
      </Card>
      </div>

      {/* 등록/수정 — 우측 슬라이드 패널 (품목관리 방식) */}
      {form && (
        <div className="w-[540px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          {/* 헤더: 취소/저장 (상단) */}
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">{form.id == null ? '표준시간 등록' : '표준시간 수정'}</h2>
            <div className="flex items-center gap-2">
              <button onClick={() => setForm(null)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>
              <button onClick={save} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
            </div>
          </div>
          {/* 바디 — 독립 세로 스크롤 */}
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 모델선택 */}
            <div className="flex items-end gap-2">
              <label className="text-sm text-text-muted flex flex-col gap-1">
                <span>모델코드 <span className="text-red-500">*</span></span>
                <input value={form.modelCode} readOnly placeholder="모델선택" className="border border-border rounded p-2 bg-surface text-text w-40" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                모델명
                <input value={form.modelName} readOnly className="border border-border rounded p-2 bg-surface text-text w-full" />
              </label>
              <button onClick={() => setModelPickerOpen(true)} className="border border-border rounded px-3 py-2 h-10 text-primary hover:bg-surface">모델선택</button>
            </div>

            {/* 적용기간 (리비전) */}
            <div className="flex items-end gap-3">
              <label className="text-sm text-text-muted flex flex-col gap-1">
                <span>적용 시작일 <span className="text-red-500">*</span></span>
                <input type="date" value={form.validFrom} onChange={(e) => setForm({ ...form, validFrom: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1">
                적용 종료일
                <input type="date" value={form.validTo === OPEN_END ? '' : form.validTo} placeholder="미지정=현재적용" onChange={(e) => setForm({ ...form, validTo: e.target.value || OPEN_END })} className="border border-border rounded p-2 bg-background text-text" />
              </label>
              <p className="text-xs text-text-muted pb-2">종료일 미입력 시 현재 적용(리비전 개방)</p>
            </div>

            {/* 표준시간 분류 — ST/CT/NT/TT 4개 컬럼, 분류별 시간(초)만 입력 */}
            <div>
              <span className="text-sm font-semibold text-text">표준시간 분류 (초)</span>
              <div className="grid grid-cols-2 gap-3 mt-2">
                {TIME_CATEGORIES.map((c) => (
                  <label key={c.code} className="text-sm text-text-muted flex flex-col gap-1">
                    <span className="font-mono text-text">{c.code} <span className="text-text-muted font-sans">— {c.name}</span></span>
                    <input
                      type="number"
                      step="0.1"
                      min="0"
                      value={form.times[c.code]}
                      onChange={(e) => setForm({ ...form, times: { ...form.times, [c.code]: Number(e.target.value) } })}
                      className="border border-border rounded p-2 bg-background text-text text-right font-mono"
                    />
                  </label>
                ))}
              </div>
            </div>

            {/* 비고 */}
            <label className="text-sm text-text-muted flex flex-col gap-1">
              비고
              <textarea value={form.remark} onChange={(e) => setForm({ ...form, remark: e.target.value })} rows={2} placeholder="분류 기준·특이사항 등" className="border border-border rounded p-2 bg-background text-text resize-none" />
            </label>

            {/* 등록자/업데이트 — 자동 */}
            <div className="flex gap-6 text-sm text-text-muted border-t border-border pt-4">
              <span>등록자 <b className="text-text">{form.id == null ? CURRENT_USER : records.find((r) => r.id === form.id)?.registeredBy}</b> (로그인 사용자 자동)</span>
              <span>업데이트일시 <b className="text-text">저장 시 자동 기록</b></span>
            </div>
          </div>
          {/* 패널 최하단 라인 */}
          <div className="flex-shrink-0 border-t border-border" />
        </div>
      )}

      {/* 모델선택 팝업 — 기존 마스터 참조, 단일 선택 */}
      <Modal isOpen={modelPickerOpen} onClose={() => setModelPickerOpen(false)} title="모델 선택" size="lg">
        <table className="w-full text-sm border border-border">
          <thead>
            <tr className="bg-surface text-text-muted">
              <th className="p-2 text-left">모델코드</th>
              <th className="p-2 text-left">모델명</th>
              <th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {SAMPLE_MODELS.map((m) => (
              <tr key={m.modelCode} className="border-t border-border">
                <td className="p-2 font-mono">{m.modelCode}</td>
                <td className="p-2">{m.modelName}</td>
                <td className="p-2 text-right">
                  <button
                    onClick={() => { if (form) setForm({ ...form, modelCode: m.modelCode, modelName: m.modelName }); setModelPickerOpen(false); }}
                    className="text-primary"
                  >
                    선택
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Modal>
    </div>
  );
}
