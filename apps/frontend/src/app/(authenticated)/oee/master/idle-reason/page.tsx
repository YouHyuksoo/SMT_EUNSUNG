'use client';

/**
 * @file (authenticated)/oee/master/idle-reason/page.tsx
 * @description 무작업 사유코드 관리 — 사유코드·표준시간(대상/비대상)·매뉴얼 첨부 등록·조회 (Mock-up, 실 DB 미연결)
 */
import { useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, Edit2, Paperclip } from 'lucide-react';
import { Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import { FileAttachment, type AttachedFile } from '@/components/shared';

// 로그인 사용자(최종수정자 자동 적용) — Mock. 실 구현 시 인증 스토어에서 취득.
const CURRENT_USER = '관리자';

// 무작업 표준시간 단위 구분
const UNITS = [
  { code: 'HOUR', name: '시간' },
  { code: 'MIN', name: '분' },
  { code: 'SEC', name: '초' },
] as const;
type UnitCode = (typeof UNITS)[number]['code'];
const unitName = (c: string) => UNITS.find((u) => u.code === c)?.name ?? c;

interface IdleReasonRecord {
  id: number;
  reasonCode: string;
  reasonName: string;
  description: string;
  stdTimeEnabled: boolean; // 무작업 표준시간 대상 여부
  stdTimeValue: number;
  stdTimeUnit: UnitCode;
  manualFiles: AttachedFile[]; // 분류별 매뉴얼 첨부 (복수, 공통 컴포넌트)
  useYn: 'Y' | 'N'; // 코드 사용구분
  updatedAt: string; // YYYY-MM-DD HH:mm
  updatedBy: string;
}

// 화면 검증용 샘플 데이터
const SEED: IdleReasonRecord[] = [
  { id: 1, reasonCode: 'DWN-CHG', reasonName: '모델 교체', description: '생산 모델 전환에 따른 셋업 정지', stdTimeEnabled: true, stdTimeValue: 30, stdTimeUnit: 'MIN', manualFiles: [{ id: 's1a', name: '모델교체_절차서.pdf' }, { id: 's1b', name: '셋업_체크리스트.xlsx' }], useYn: 'Y', updatedAt: '2026-07-01 09:20', updatedBy: '김생기' },
  { id: 2, reasonCode: 'DWN-MAT', reasonName: '자재 대기', description: '자재 미공급으로 인한 대기', stdTimeEnabled: false, stdTimeValue: 0, stdTimeUnit: 'MIN', manualFiles: [], useYn: 'Y', updatedAt: '2026-07-05 14:05', updatedBy: '박공정' },
  { id: 3, reasonCode: 'DWN-BRK', reasonName: '설비 고장', description: '설비 이상으로 인한 비가동', stdTimeEnabled: true, stdTimeValue: 2, stdTimeUnit: 'HOUR', manualFiles: [{ id: 's3a', name: '설비고장_대응매뉴얼.pdf' }], useYn: 'Y', updatedAt: '2026-07-09 11:41', updatedBy: '이설비' },
  { id: 4, reasonCode: 'DWN-CLN', reasonName: '청소/5S', description: '라인 청소 및 정리정돈', stdTimeEnabled: true, stdTimeValue: 600, stdTimeUnit: 'SEC', manualFiles: [], useYn: 'N', updatedAt: '2026-06-20 17:30', updatedBy: '김생기' },
];

function nowStamp() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}
const stdTimeText = (r: IdleReasonRecord) => (r.stdTimeEnabled ? `${r.stdTimeValue} ${unitName(r.stdTimeUnit)}` : '비대상');

interface EditForm {
  id: number | null;
  reasonCode: string;
  reasonName: string;
  description: string;
  stdTimeEnabled: boolean;
  stdTimeValue: number;
  stdTimeUnit: UnitCode;
  manualFiles: AttachedFile[];
  useYn: 'Y' | 'N';
}
const emptyForm = (): EditForm => ({ id: null, reasonCode: '', reasonName: '', description: '', stdTimeEnabled: false, stdTimeValue: 0, stdTimeUnit: 'MIN', manualFiles: [], useYn: 'Y' });

export default function IdleReasonMasterPage() {
  const [records, setRecords] = useState<IdleReasonRecord[]>(SEED);
  const [form, setForm] = useState<EditForm | null>(null);
  const [search, setSearch] = useState({ reasonCode: '', reasonName: '' });

  const filtered = useMemo(
    () =>
      records.filter(
        (r) =>
          (!search.reasonCode || r.reasonCode.toLowerCase().includes(search.reasonCode.toLowerCase())) &&
          (!search.reasonName || r.reasonName.toLowerCase().includes(search.reasonName.toLowerCase())),
      ),
    [records, search],
  );

  const columns = useMemo<ColumnDef<IdleReasonRecord>[]>(
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
      { accessorKey: 'reasonCode', header: '사유코드', cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'reasonName', header: '사유명' },
      { accessorKey: 'description', header: '설명' },
      { id: 'stdTime', header: '표준시간', meta: { align: 'center' as const, filterType: 'none' as const }, cell: ({ row }) => stdTimeText(row.original) },
      {
        id: 'manual',
        header: '매뉴얼',
        size: 90,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (row.original.manualFiles.length ? <span className="inline-flex items-center gap-1 text-primary text-xs"><Paperclip className="w-3 h-3" />첨부 {row.original.manualFiles.length}</span> : <span className="text-text-muted">-</span>),
      },
      { id: 'useYn', header: '사용구분', size: 90, meta: { align: 'center' as const }, cell: ({ row }) => (row.original.useYn === 'Y' ? '사용' : '미사용') },
      { accessorKey: 'updatedAt', header: '최종수정일', cell: ({ getValue }) => <span className="font-mono text-text-muted">{String(getValue() ?? '')}</span> },
      { accessorKey: 'updatedBy', header: '최종수정자' },
    ],
    [],
  );

  function openCreate() {
    setForm(emptyForm());
  }
  function openEdit(r: IdleReasonRecord) {
    setForm({
      id: r.id,
      reasonCode: r.reasonCode,
      reasonName: r.reasonName,
      description: r.description,
      stdTimeEnabled: r.stdTimeEnabled,
      stdTimeValue: r.stdTimeValue,
      stdTimeUnit: r.stdTimeUnit,
      manualFiles: r.manualFiles,
      useYn: r.useYn,
    });
  }

  function save() {
    if (!form) return;
    if (!form.reasonCode) return alert('무작업 사유코드를 입력하세요');
    if (!form.reasonName) return alert('무작업 사유명을 입력하세요');

    const stamp = nowStamp();
    const payload = {
      reasonCode: form.reasonCode,
      reasonName: form.reasonName,
      description: form.description,
      stdTimeEnabled: form.stdTimeEnabled,
      stdTimeValue: form.stdTimeEnabled ? form.stdTimeValue : 0,
      stdTimeUnit: form.stdTimeUnit,
      manualFiles: form.manualFiles,
      useYn: form.useYn,
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
            <h1 className="text-xl font-bold text-text">무작업 사유코드 관리</h1>
            <p className="text-sm text-text-muted mt-1">무작업(비가동) 사유코드 · 표준시간 · 분류별 매뉴얼 관리 (Mock-up)</p>
          </div>
          <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10">사유코드 등록</button>
        </div>

        {/* 목록 화면 — 표준시간관리와 동일한 DataGrid 형식 */}
        <Card className="flex-1 min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-4">
            <DataGrid
              data={filtered}
              columns={columns}
              pageSize={50}
              enableColumnFilter
              enableExport
              enableFullscreen
              exportFileName="무작업사유코드관리"
              emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 사유코드가 없습니다'}
              getRowId={(r) => String(r.id)}
              toolbarLeft={
                <div className="flex flex-wrap gap-3 flex-1 min-w-0">
                  <div className="w-44 flex-shrink-0">
                    <Input placeholder="사유코드" value={search.reasonCode} onChange={(e) => setSearch({ ...search, reasonCode: e.target.value })} leftIcon={<Search className="w-4 h-4" />} fullWidth />
                  </div>
                  <div className="w-56 flex-shrink-0">
                    <Input placeholder="사유명" value={search.reasonName} onChange={(e) => setSearch({ ...search, reasonName: e.target.value })} leftIcon={<Search className="w-4 h-4" />} fullWidth />
                  </div>
                </div>
              }
            />
          </CardContent>
        </Card>
      </div>

      {/* 등록/수정 — 우측 슬라이드 패널 (표준시간관리 방식) */}
      {form && (
        <div className="w-[540px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          {/* 헤더: 저장/닫기 (상단) */}
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">{form.id == null ? '무작업 사유코드 등록' : '무작업 사유코드 수정'}</h2>
            <div className="flex items-center gap-2">
              <button onClick={save} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
              <button onClick={() => setForm(null)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">닫기</button>
            </div>
          </div>
          {/* 바디 — 독립 세로 스크롤 */}
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 사유코드 / 사유명 */}
            <div className="flex gap-3">
              <label className="text-sm text-text-muted flex flex-col gap-1 w-40">
                무작업 사유코드
                <input value={form.reasonCode} disabled={form.id != null} onChange={(e) => setForm({ ...form, reasonCode: e.target.value.toUpperCase() })} className="border border-border rounded p-2 bg-background text-text disabled:opacity-50 disabled:bg-surface" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                무작업 사유명
                <input value={form.reasonName} onChange={(e) => setForm({ ...form, reasonName: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
              </label>
            </div>

            {/* 설명 */}
            <label className="text-sm text-text-muted flex flex-col gap-1">
              무작업 사유 코드 설명
              <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} rows={2} className="border border-border rounded p-2 bg-background text-text resize-none" />
            </label>

            {/* 무작업 표준시간 — 대상/비대상 라디오(기본 비대상) + 수치/단위(대상일 때만 활성화) */}
            <div className="border border-border rounded p-3 space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-sm font-semibold text-text">무작업 표준시간</span>
                <div className="flex items-center gap-4 text-sm text-text-muted">
                  <label className="flex items-center gap-1.5 cursor-pointer">
                    <input type="radio" name="stdTimeTarget" checked={!form.stdTimeEnabled} onChange={() => setForm({ ...form, stdTimeEnabled: false })} className="w-4 h-4 accent-primary" />
                    비대상
                  </label>
                  <label className="flex items-center gap-1.5 cursor-pointer">
                    <input type="radio" name="stdTimeTarget" checked={form.stdTimeEnabled} onChange={() => setForm({ ...form, stdTimeEnabled: true })} className="w-4 h-4 accent-primary" />
                    대상
                  </label>
                </div>
              </div>
              <div className="flex items-end gap-2">
                <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                  수치
                  <input type="number" step="1" min="0" value={form.stdTimeValue} disabled={!form.stdTimeEnabled} onChange={(e) => setForm({ ...form, stdTimeValue: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono disabled:opacity-50 disabled:bg-surface disabled:cursor-not-allowed" />
                </label>
                <label className="text-sm text-text-muted flex flex-col gap-1 w-28">
                  단위
                  <select value={form.stdTimeUnit} disabled={!form.stdTimeEnabled} onChange={(e) => setForm({ ...form, stdTimeUnit: e.target.value as UnitCode })} className="border border-border rounded p-2 bg-background text-text disabled:opacity-50 disabled:bg-surface disabled:cursor-not-allowed">
                    {UNITS.map((u) => (
                      <option key={u.code} value={u.code}>{u.name}</option>
                    ))}
                  </select>
                </label>
              </div>
            </div>

            {/* 분류별 매뉴얼 첨부 — 파일첨부 공통 컴포넌트 (복수 첨부) */}
            <FileAttachment
              label="무작업 분류별 매뉴얼 첨부"
              businessType="무작업사유"
              refKey={form.reasonCode}
              value={form.manualFiles}
              onChange={(files) => setForm({ ...form, manualFiles: files })}
              mock
            />

            {/* 코드 사용구분 */}
            <label className="text-sm text-text-muted flex flex-col gap-1 w-40">
              코드 사용구분
              <select value={form.useYn} onChange={(e) => setForm({ ...form, useYn: e.target.value as 'Y' | 'N' })} className="border border-border rounded p-2 bg-background text-text">
                <option value="Y">사용</option>
                <option value="N">미사용</option>
              </select>
            </label>

            {/* 최종수정자/일 — 자동 */}
            <div className="flex gap-6 text-sm text-text-muted border-t border-border pt-4">
              <span>최종수정자 <b className="text-text">{CURRENT_USER}</b> (로그인 사용자 자동)</span>
              <span>최종수정일 <b className="text-text">저장 시 자동 기록</b></span>
            </div>
          </div>
          {/* 패널 최하단 라인 */}
          <div className="flex-shrink-0 border-t border-border" />
        </div>
      )}
    </div>
  );
}
