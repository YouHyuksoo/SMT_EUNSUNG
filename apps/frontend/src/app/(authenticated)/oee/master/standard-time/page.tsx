'use client';

/**
 * @file (authenticated)/oee/master/standard-time/page.tsx
 * @description 표준시간 관리 — 품목(모델) 기준 ST/CT/NT/TT 표준시간 등록·조회 (IP_PRODUCT_ST_MASTER 실 DB 연결)
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1):
 *   GET/POST/PUT/DELETE /oee/standard-time , GET /oee/standard-time/items (모델선택)
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, Edit2, RefreshCw } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import { ModelSearchModal } from '@/components/shared';
import api from '@/services/api';

// 표준시간 분류코드 — ST/CT/NT/TT 4개 고정 컬럼. 각 분류는 시간(초)만 관리한다.
const TIME_CATEGORIES = [
  { code: 'ST', name: 'Standard Time' },
  { code: 'CT', name: 'Cycle Time' },
  { code: 'NT', name: 'Neck Time' },
  { code: 'TT', name: 'Takt Time' },
] as const;
type CategoryCode = (typeof TIME_CATEGORIES)[number]['code'];
type StdTimes = Record<CategoryCode, number>;
const emptyTimes = (): StdTimes => ({ ST: 0, CT: 0, NT: 0, TT: 0 });

const OPEN_END = '9999-12-31';
const periodText = (f: string, t: string) => `${f} ~ ${t === OPEN_END ? '현재 적용' : t}`;

interface StdTimeRecord {
  id: string;            // itemCode__validFrom (행 키)
  modelCode: string;     // 품목코드(모델코드)
  modelName: string;
  validFrom: string;
  validTo: string;       // 개방형 '9999-12-31'
  times: StdTimes;
  remark: string;
  registeredBy: string;
  updatedAt: string;
}
interface EditForm {
  originalItemCode: string | null; // 수정 시 원본 키
  originalValidFrom: string | null;
  modelCode: string;
  modelName: string;
  validFrom: string;
  validTo: string;
  times: StdTimes;
  remark: string;
  registeredBy: string; // 편집 시 표시용(읽기전용)
  updatedAt: string;    // 편집 시 표시용(읽기전용)
}
const emptyForm = (): EditForm => ({ originalItemCode: null, originalValidFrom: null, modelCode: '', modelName: '', validFrom: '', validTo: OPEN_END, times: emptyTimes(), remark: '', registeredBy: '', updatedAt: '' });

// API 응답 타입
interface ApiStdRow { itemCode: string; modelName: string | null; validFrom: string; validTo: string; st: number | null; ct: number | null; nt: number | null; tt: number | null; remark: string | null; registeredBy: string | null; updatedAt: string | null; }

export default function StandardTimeMasterPage() {
  const [records, setRecords] = useState<StdTimeRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState<EditForm | null>(null);
  const [modelPickerOpen, setModelPickerOpen] = useState(false);
  const [search, setSearch] = useState('');

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/oee/standard-time');
      const list: ApiStdRow[] = res.data?.data?.list ?? [];
      setRecords(list.map((r) => ({
        id: `${r.itemCode}__${r.validFrom}`,
        modelCode: r.itemCode,
        modelName: r.modelName ?? '',
        validFrom: r.validFrom,
        validTo: r.validTo,
        times: { ST: r.st ?? 0, CT: r.ct ?? 0, NT: r.nt ?? 0, TT: r.tt ?? 0 },
        remark: r.remark ?? '',
        registeredBy: r.registeredBy ?? '',
        updatedAt: r.updatedAt ?? '',
      })));
    } catch {
      toast.error('표준시간 목록 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, []);
  useEffect(() => { load(); }, [load]);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return records;
    return records.filter((r) => [r.modelCode, r.modelName].join(' ').toLowerCase().includes(q));
  }, [records, search]);

  const columns = useMemo<ColumnDef<StdTimeRecord>[]>(
    () => [
      {
        id: 'actions', header: '관리', size: 70,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (
          <button onClick={(e) => { e.stopPropagation(); openEdit(row.original); }} className="p-1 hover:bg-surface rounded" title="편집">
            <Edit2 className="w-4 h-4 text-primary" />
          </button>
        ),
      },
      { accessorKey: 'modelCode', header: '모델코드', cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'modelName', header: '모델명' },
      ...TIME_CATEGORIES.map((c) => ({
        id: `time_${c.code}`, header: `${c.code}(초)`, size: 80,
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

  function openCreate() { setForm(emptyForm()); }
  function openEdit(r: StdTimeRecord) {
    setForm({
      originalItemCode: r.modelCode, originalValidFrom: r.validFrom,
      modelCode: r.modelCode, modelName: r.modelName, validFrom: r.validFrom, validTo: r.validTo,
      times: { ...r.times }, remark: r.remark,
      registeredBy: r.registeredBy, updatedAt: r.updatedAt,
    });
  }
  function openPicker() { setModelPickerOpen(true); }

  async function save() {
    if (!form) return;
    if (!form.modelCode) return alert('모델을 선택하세요');
    if (!form.validFrom) return alert('적용 시작일을 입력하세요');
    if (form.validTo !== OPEN_END && form.validTo < form.validFrom) return alert('적용 종료일은 적용 시작일보다 빠를 수 없습니다');
    if (!TIME_CATEGORIES.some((c) => form.times[c.code] > 0)) return alert('분류별 표준시간을 1개 이상 입력하세요');

    const payload = {
      itemCode: form.modelCode, validFrom: form.validFrom, validTo: form.validTo,
      st: form.times.ST, ct: form.times.CT, nt: form.times.NT, tt: form.times.TT, remark: form.remark,
    };
    try {
      if (form.originalItemCode == null) {
        await api.post('/oee/standard-time', payload);
      } else {
        await api.put('/oee/standard-time', { ...payload, originalItemCode: form.originalItemCode, originalValidFrom: form.originalValidFrom });
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
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
        <div className="flex items-center justify-between flex-shrink-0">
          <div>
            <h1 className="text-xl font-bold text-text">표준시간 관리</h1>
            <p className="text-sm text-text-muted mt-1">품목(모델) 기준 ST/CT/NT/TT 표준시간 · 적용기간 리비전 관리</p>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={load} className="border border-border rounded px-3 h-10 text-text-muted hover:bg-surface flex items-center gap-1"><RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />새로고침</button>
            <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10">표준시간 등록</button>
          </div>
        </div>

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
              exportFileName="표준시간관리"
              emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 표준시간이 없습니다'}
              getRowId={(r) => r.id}
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

      {form && (
        <div className="w-[540px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">{form.originalItemCode == null ? '표준시간 등록' : '표준시간 수정'}</h2>
            <div className="flex items-center gap-2">
              <button onClick={() => setForm(null)} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>
              <button onClick={save} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
            </div>
          </div>
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            <div className="flex items-end gap-2">
              <label className="text-sm text-text-muted flex flex-col gap-1">
                <span>모델코드 <span className="text-red-500">*</span></span>
                <input value={form.modelCode} readOnly placeholder="모델선택" className="border border-border rounded p-2 bg-surface text-text w-40" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                모델명
                <input value={form.modelName} readOnly className="border border-border rounded p-2 bg-surface text-text w-full" />
              </label>
              <button onClick={openPicker} className="border border-border rounded px-3 py-2 h-10 text-primary hover:bg-surface">모델선택</button>
            </div>

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

            <div>
              <span className="text-sm font-semibold text-text">표준시간 분류 (초)</span>
              <div className="grid grid-cols-2 gap-3 mt-2">
                {TIME_CATEGORIES.map((c) => (
                  <label key={c.code} className="text-sm text-text-muted flex flex-col gap-1">
                    <span className="font-mono text-text">{c.code} <span className="text-text-muted font-sans">— {c.name}</span></span>
                    <input type="number" step="0.1" min="0" value={form.times[c.code]}
                      onChange={(e) => setForm({ ...form, times: { ...form.times, [c.code]: Number(e.target.value) } })}
                      className="border border-border rounded p-2 bg-background text-text text-right font-mono" />
                  </label>
                ))}
              </div>
            </div>

            <label className="text-sm text-text-muted flex flex-col gap-1">
              비고
              <textarea value={form.remark} onChange={(e) => setForm({ ...form, remark: e.target.value })} rows={2} placeholder="분류 기준·특이사항 등" className="border border-border rounded p-2 bg-background text-text resize-none" />
            </label>

            <div className="flex gap-6 text-sm text-text-muted border-t border-border pt-4">
              <span>등록자 <b className="text-text">{form.originalItemCode == null ? '저장 시 자동(로그인 사용자)' : (form.registeredBy || '-')}</b></span>
              <span>업데이트일시 <b className="text-text">{form.originalItemCode == null ? '저장 시 자동 기록' : (form.updatedAt || '-')}</b></span>
            </div>
          </div>
          <div className="flex-shrink-0 border-t border-border" />
        </div>
      )}

      {/* 모델선택 팝업 — IP_PRODUCT_MODEL_MASTER 참조 공용 모달, 단일 선택 */}
      <ModelSearchModal
        isOpen={modelPickerOpen}
        onClose={() => setModelPickerOpen(false)}
        onSelect={(m) => setForm((prev) => (prev ? { ...prev, modelCode: m.partNo, modelName: m.modelName } : prev))}
      />
    </div>
  );
}
