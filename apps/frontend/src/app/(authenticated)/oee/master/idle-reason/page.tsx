'use client';

/**
 * @file (authenticated)/oee/master/idle-reason/page.tsx
 * @description 설비 비가동 사유코드 관리 — 사유코드·표준시간(대상/비대상)·분류별 매뉴얼(BFILE) 등록·조회 (IP_EQUIP_DOWNTIME_REASON 실 DB 연결)
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1):
 *   GET/POST/PUT /oee/idle-reason , DELETE /oee/idle-reason/:reasonCode
 *   매뉴얼 첨부는 공통 파일첨부(BFILE): businessType='설비비가동사유', refKey=사유코드
 * 코드값(사유구분·OEE반영·사용구분·단위)은 기준정보가 아닌 소스 고정 코드다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, Edit2, Paperclip, RefreshCw } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import { FileAttachment, type AttachedFile } from '@/components/shared';
import api from '@/services/api';

// 매뉴얼 첨부 업무구분 — 백엔드 count 서브쿼리와 일치
const MANUAL_BIZ = '설비비가동사유';

// 설비 비가동 표준시간 단위 구분 (소스 고정 코드)
const UNITS = [
  { code: 'HOUR', name: '시간' },
  { code: 'MIN', name: '분' },
  { code: 'SEC', name: '초' },
] as const;
type UnitCode = (typeof UNITS)[number]['code'];
const unitName = (c: string) => UNITS.find((u) => u.code === c)?.name ?? c;

// 비가동 사유 구분 — 계획/비계획 (소스 고정 코드)
const REASON_TYPES = [
  { code: 'PLAN', name: '계획' },
  { code: 'UNPLAN', name: '비계획' },
] as const;
type ReasonTypeCode = (typeof REASON_TYPES)[number]['code'];
const reasonTypeName = (c: string) => REASON_TYPES.find((t) => t.code === c)?.name ?? c;

interface IdleReasonRecord {
  reasonCode: string;
  reasonName: string;
  description: string;
  reasonType: ReasonTypeCode; // 비가동 사유 구분 (계획/비계획)
  oeeReflect: 'Y' | 'N'; // OEE 반영여부 (반영/미반영)
  displayOrder: number; // 화면 표시 순서
  stdTimeEnabled: boolean; // 설비 비가동 표준시간 대상 여부
  stdTimeValue: number;
  stdTimeUnit: UnitCode;
  manualCount: number; // 분류별 매뉴얼 첨부 건수 (BFILE)
  useYn: 'Y' | 'N'; // 코드 사용구분
  updatedAt: string; // YYYY-MM-DD HH:mm
  updatedBy: string;
}

// API 응답 행 타입
interface ApiRow {
  reasonCode: string; reasonName: string; description: string | null;
  reasonType: ReasonTypeCode | null; oeeReflect: 'Y' | 'N' | null; displayOrder: number | null;
  stdTimeEnabled: boolean; stdTimeValue: number | null; stdTimeUnit: UnitCode | null;
  useYn: 'Y' | 'N' | null; manualCount: number; updatedBy: string | null; updatedAt: string | null;
}

const stdTimeText = (r: IdleReasonRecord) => (r.stdTimeEnabled ? `${r.stdTimeValue} ${unitName(r.stdTimeUnit)}` : '비대상');

interface EditForm {
  isEdit: boolean;
  reasonCode: string;
  reasonName: string;
  description: string;
  reasonType: ReasonTypeCode;
  oeeReflect: 'Y' | 'N';
  displayOrder: number;
  stdTimeEnabled: boolean;
  stdTimeValue: number;
  stdTimeUnit: UnitCode;
  manualFiles: AttachedFile[];
  useYn: 'Y' | 'N';
  updatedAt: string; // 편집 시 표시용(읽기전용)
  updatedBy: string;
}
const emptyForm = (): EditForm => ({ isEdit: false, reasonCode: '', reasonName: '', description: '', reasonType: 'PLAN', oeeReflect: 'Y', displayOrder: 0, stdTimeEnabled: false, stdTimeValue: 0, stdTimeUnit: 'MIN', manualFiles: [], useYn: 'Y', updatedAt: '', updatedBy: '' });

export default function IdleReasonMasterPage() {
  const [records, setRecords] = useState<IdleReasonRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState<EditForm | null>(null);
  const [search, setSearch] = useState('');

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/oee/idle-reason');
      const list: ApiRow[] = res.data?.data?.list ?? [];
      setRecords(list.map((r) => ({
        reasonCode: r.reasonCode,
        reasonName: r.reasonName ?? '',
        description: r.description ?? '',
        reasonType: r.reasonType ?? 'PLAN',
        oeeReflect: r.oeeReflect ?? 'N',
        displayOrder: r.displayOrder ?? 0,
        stdTimeEnabled: r.stdTimeEnabled,
        stdTimeValue: r.stdTimeValue ?? 0,
        stdTimeUnit: r.stdTimeUnit ?? 'MIN',
        manualCount: r.manualCount ?? 0,
        useYn: r.useYn ?? 'Y',
        updatedAt: r.updatedAt ?? '',
        updatedBy: r.updatedBy ?? '',
      })));
    } catch {
      toast.error('사유코드 목록 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, []);
  useEffect(() => { load(); }, [load]);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    // 통합검색 — 사유코드·사유명에서 매칭
    const base = q
      ? records.filter((r) => [r.reasonCode, r.reasonName].join(' ').toLowerCase().includes(q))
      : records;
    return [...base].sort((a, b) => a.displayOrder - b.displayOrder); // 화면 표시 순서 오름차순
  }, [records, search]);

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
      { accessorKey: 'displayOrder', header: '표시순서', size: 80, meta: { align: 'center' as const, filterType: 'none' as const }, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'reasonCode', header: '사유코드', cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'reasonName', header: '사유명' },
      { accessorKey: 'reasonType', header: '사유구분', size: 90, meta: { align: 'center' as const }, cell: ({ getValue }) => reasonTypeName(String(getValue() ?? '')) },
      { accessorKey: 'description', header: '설명' },
      { id: 'stdTime', header: '표준시간', meta: { align: 'center' as const, filterType: 'none' as const }, cell: ({ row }) => stdTimeText(row.original) },
      { accessorKey: 'oeeReflect', header: 'OEE반영', size: 90, meta: { align: 'center' as const }, cell: ({ getValue }) => (getValue() === 'Y' ? '반영' : '미반영') },
      {
        id: 'manual',
        header: '매뉴얼',
        size: 90,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (row.original.manualCount ? <span className="inline-flex items-center gap-1 text-primary text-xs"><Paperclip className="w-3 h-3" />첨부 {row.original.manualCount}</span> : <span className="text-text-muted">-</span>),
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
  async function openEdit(r: IdleReasonRecord) {
    setForm({
      isEdit: true,
      reasonCode: r.reasonCode,
      reasonName: r.reasonName,
      description: r.description,
      reasonType: r.reasonType,
      oeeReflect: r.oeeReflect,
      displayOrder: r.displayOrder,
      stdTimeEnabled: r.stdTimeEnabled,
      stdTimeValue: r.stdTimeValue,
      stdTimeUnit: r.stdTimeUnit,
      manualFiles: [],
      useYn: r.useYn,
      updatedAt: r.updatedAt,
      updatedBy: r.updatedBy,
    });
    // 기존 매뉴얼 첨부 로드 (BFILE)
    try {
      const res = await api.get('/files', { params: { businessType: MANUAL_BIZ, refKey: r.reasonCode } });
      const dtos = (res.data?.data ?? []) as Array<{ id: string; name: string; size: number | null; url: string }>;
      const files: AttachedFile[] = dtos.map((d) => ({ id: d.id, name: d.name, size: d.size ?? undefined, url: d.url }));
      setForm((prev) => (prev && prev.reasonCode === r.reasonCode ? { ...prev, manualFiles: files } : prev));
    } catch {
      // 첨부 조회 실패는 등록/수정 자체를 막지 않는다
    }
  }

  async function save() {
    if (!form) return;
    if (!form.reasonCode) return toast.error('설비 비가동 사유코드를 입력하세요');
    if (!form.reasonName) return toast.error('설비 비가동 사유명을 입력하세요');

    const payload = {
      reasonCode: form.reasonCode,
      reasonName: form.reasonName,
      description: form.description,
      reasonType: form.reasonType,
      oeeReflect: form.oeeReflect,
      displayOrder: form.displayOrder,
      stdTimeEnabled: form.stdTimeEnabled,
      stdTimeValue: form.stdTimeEnabled ? form.stdTimeValue : 0,
      stdTimeUnit: form.stdTimeUnit,
      useYn: form.useYn,
    };
    try {
      if (form.isEdit) {
        await api.put('/oee/idle-reason', payload);
      } else {
        await api.post('/oee/idle-reason', payload);
      }
      toast.success('저장되었습니다');
      setForm(null);
      await load();
    } catch (e: unknown) {
      // 서버가 내려준 메시지(중복 등) 우선 표시
      const msg =
        e && typeof e === 'object' && 'response' in e
          ? (e as { response?: { data?: { message?: string } } }).response?.data?.message
          : undefined;
      toast.error(msg || '저장에 실패했습니다');
    }
  }

  return (
    <div className="flex h-full overflow-hidden">
      {/* 좌측: 메인 콘텐츠 (목록) — 독립 세로 스크롤 */}
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
        <div className="flex items-center justify-between flex-shrink-0">
          <div>
            <h1 className="text-xl font-bold text-text">설비 비가동 사유코드 관리</h1>
            <p className="text-sm text-text-muted mt-1">설비 비가동 사유코드 · 표준시간 · 분류별 매뉴얼(BFILE) 관리</p>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={load} className="border border-border rounded px-3 h-10 text-text-muted hover:bg-surface flex items-center gap-1"><RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />새로고침</button>
            <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10">사유코드 등록</button>
          </div>
        </div>

        {/* 목록 화면 — 표준시간관리와 동일한 DataGrid 형식 */}
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
              exportFileName="설비비가동사유코드관리"
              emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 사유코드가 없습니다'}
              getRowId={(r) => r.reasonCode}
              toolbarLeft={
                <div className="flex flex-wrap gap-3 flex-1 min-w-0">
                  <div className="w-96 flex-shrink-0">
                    <Input placeholder="통합검색 (사유코드·사유명)" value={search} onChange={(e) => setSearch(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
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
          {/* 헤더: 취소/저장 (상단) */}
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">{form.isEdit ? '설비 비가동 사유코드 수정' : '설비 비가동 사유코드 등록'}</h2>
            <div className="flex items-center gap-2">
              <button onClick={() => setForm(null)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>
              <button onClick={save} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
            </div>
          </div>
          {/* 바디 — 독립 세로 스크롤 */}
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 사유코드 / 사유명 */}
            <div className="flex gap-3">
              <label className="text-sm text-text-muted flex flex-col gap-1 w-40">
                <span>설비 비가동 사유코드 <span className="text-red-500">*</span></span>
                <input value={form.reasonCode} disabled={form.isEdit} onChange={(e) => setForm({ ...form, reasonCode: e.target.value.toUpperCase() })} className="border border-border rounded p-2 bg-background text-text disabled:opacity-50 disabled:bg-surface" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                <span>설비 비가동 사유명 <span className="text-red-500">*</span></span>
                <input value={form.reasonName} onChange={(e) => setForm({ ...form, reasonName: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
              </label>
            </div>

            {/* 설명 */}
            <label className="text-sm text-text-muted flex flex-col gap-1">
              설비 비가동 사유 코드 설명
              <textarea value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} rows={2} className="border border-border rounded p-2 bg-background text-text resize-none" />
            </label>

            {/* 비가동 사유 구분 / OEE 반영여부 / 화면 표시 순서 */}
            <div className="flex gap-3">
              <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                비가동 사유 구분
                <select value={form.reasonType} onChange={(e) => setForm({ ...form, reasonType: e.target.value as ReasonTypeCode })} className="border border-border rounded p-2 bg-background text-text">
                  {REASON_TYPES.map((t) => (
                    <option key={t.code} value={t.code}>{t.name}</option>
                  ))}
                </select>
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                OEE 반영여부
                <select value={form.oeeReflect} onChange={(e) => setForm({ ...form, oeeReflect: e.target.value as 'Y' | 'N' })} className="border border-border rounded p-2 bg-background text-text">
                  <option value="Y">반영</option>
                  <option value="N">미반영</option>
                </select>
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1 w-28">
                화면 표시 순서
                <input type="number" step="1" min="0" value={form.displayOrder} onChange={(e) => setForm({ ...form, displayOrder: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono" />
              </label>
            </div>

            {/* 설비 비가동 표준시간 — 대상/비대상 라디오(기본 비대상) + 수치/단위(대상일 때만 활성화) */}
            <div className="border border-border rounded p-3 space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-sm font-semibold text-text">설비 비가동 표준시간</span>
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

            {/* 분류별 매뉴얼 첨부 — 파일첨부 공통 컴포넌트 (BFILE, 복수 첨부). 사유코드가 refKey이므로 코드 입력 후 첨부 */}
            {form.reasonCode ? (
              <FileAttachment
                label="설비 비가동 분류별 매뉴얼 첨부"
                businessType={MANUAL_BIZ}
                refKey={form.reasonCode}
                value={form.manualFiles}
                onChange={(files) => setForm({ ...form, manualFiles: files })}
              />
            ) : (
              <div className="border border-dashed border-border rounded p-4 text-center text-xs text-text-muted">사유코드를 먼저 입력하면 매뉴얼을 첨부할 수 있습니다.</div>
            )}

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
              <span>최종수정자 <b className="text-text">{form.isEdit ? (form.updatedBy || '-') : '저장 시 자동(로그인 사용자)'}</b></span>
              <span>최종수정일 <b className="text-text">{form.isEdit ? (form.updatedAt || '-') : '저장 시 자동 기록'}</b></span>
            </div>
          </div>
          {/* 패널 최하단 라인 */}
          <div className="flex-shrink-0 border-t border-border" />
        </div>
      )}
    </div>
  );
}
