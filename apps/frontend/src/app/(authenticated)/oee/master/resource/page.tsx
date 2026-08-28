'use client';

/**
 * @file (authenticated)/oee/master/resource/page.tsx
 * @description OEE 리소스(LINE/CELL) 마스터 관리 — 라인 후보를 선택해 작업장별 리소스를 등록·수정·삭제한다.
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1):
 *   GET /oee/resource, GET /oee/resource/candidates
 *   POST /oee/resource, PUT /oee/resource/:resourceId, DELETE /oee/resource/:resourceId
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Edit2, RefreshCw, Search, Trash2 } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import Modal from '@/components/ui/Modal';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';

const PROCESS_CODES = ['SMT', 'ASSY'] as const;
const RESOURCE_TYPES = ['LINE', 'CELL'] as const;

type OeeProcessCode = (typeof PROCESS_CODES)[number];
type OeeResourceType = (typeof RESOURCE_TYPES)[number];

interface ResourceRecord {
  resourceId: number;
  lineCode: string;
  lineName: string;
  resourceName: string;
  processCode: OeeProcessCode;
  resourceType: OeeResourceType;
  parentLineCode: string;
}

interface ResourceForm {
  isEdit: boolean;
  resourceId: number | null;
  lineCode: string;
  lineName: string;
  resourceName: string;
  processCode: OeeProcessCode;
  resourceType: OeeResourceType;
  parentLineCode: string;
}

interface ApiResourceRow {
  resourceId?: number | string | null;
  lineCode?: string | null;
  lineName?: string | null;
  resourceCode?: string | null;
  resourceName?: string | null;
  refCode?: string | null;
  processCode?: string | null;
  resourceType?: string | null;
  parentLineCode?: string | null;
}

interface ApiCandidateRow {
  lineCode?: string | null;
  lineName?: string | null;
  resourceCode?: string | null;
  resourceName?: string | null;
  parentLineCode?: string | null;
}

interface LineCandidate {
  lineCode: string;
  lineName: string;
  parentLineCode: string;
}

const emptyForm = (): ResourceForm => ({
  isEdit: false,
  resourceId: null,
  lineCode: '',
  lineName: '',
  resourceName: '',
  processCode: 'SMT',
  resourceType: 'LINE',
  parentLineCode: '',
});

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function text(value: unknown): string {
  return typeof value === 'string' ? value : '';
}

function isProcessCode(value: unknown): value is OeeProcessCode {
  return PROCESS_CODES.some((code) => code === value);
}

function isResourceType(value: unknown): value is OeeResourceType {
  return RESOURCE_TYPES.some((type) => type === value);
}

function readRows<T>(response: unknown, keys: string[]): T[] {
  if (!isRecord(response)) return [];
  const body = response.data;
  const payload = isRecord(body) && 'data' in body ? body.data : body;
  if (Array.isArray(payload)) return payload as T[];
  if (isRecord(payload)) {
    for (const key of keys) {
      if (Array.isArray(payload[key])) return payload[key] as T[];
    }
  }
  if (isRecord(body)) {
    for (const key of keys) {
      if (Array.isArray(body[key])) return body[key] as T[];
    }
  }
  return [];
}

function toResourceRecord(row: ApiResourceRow, index: number): ResourceRecord | null {
  const lineCode = text(row.lineCode ?? row.resourceCode ?? row.refCode).trim();
  const processCode = row.processCode;
  const resourceType = row.resourceType;
  if (!lineCode || !isProcessCode(processCode) || !isResourceType(resourceType)) return null;

  const parsedId = Number(row.resourceId);
  return {
    resourceId: Number.isFinite(parsedId) ? parsedId : index,
    lineCode,
    lineName: text(row.lineName).trim(),
    resourceName: text(row.resourceName).trim(),
    processCode,
    resourceType,
    parentLineCode: text(row.parentLineCode).trim(),
  };
}

function toCandidate(row: ApiCandidateRow): LineCandidate | null {
  const lineCode = text(row.lineCode ?? row.resourceCode).trim();
  if (!lineCode) return null;
  return {
    lineCode,
    lineName: text(row.lineName ?? row.resourceName).trim(),
    parentLineCode: text(row.parentLineCode).trim(),
  };
}

function apiErrorMessage(error: unknown): string | undefined {
  if (!isRecord(error) || !isRecord(error.response) || !isRecord(error.response.data)) return undefined;
  return typeof error.response.data.message === 'string' ? error.response.data.message : undefined;
}

export default function OeeResourceMasterPage() {
  const [records, setRecords] = useState<ResourceRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState('');
  const [form, setForm] = useState<ResourceForm | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<ResourceRecord | null>(null);
  const [candidatePickerOpen, setCandidatePickerOpen] = useState(false);
  const [candidateLoading, setCandidateLoading] = useState(false);
  const [candidates, setCandidates] = useState<LineCandidate[]>([]);
  const [candidateQuery, setCandidateQuery] = useState('');

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/oee/resource');
      const rows = readRows<ApiResourceRow>(response, ['resources', 'list']);
      setRecords(rows.map(toResourceRecord).filter((row): row is ResourceRecord => row !== null));
    } catch (error: unknown) {
      toast.error(apiErrorMessage(error) || 'OEE 리소스 목록 조회에 실패했습니다');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    const initialLoad = window.setTimeout(() => {
      void load();
    }, 0);
    return () => window.clearTimeout(initialLoad);
  }, [load]);

  const loadCandidates = useCallback(async () => {
    if (candidates.length) return;
    setCandidateLoading(true);
    try {
      const response = await api.get('/oee/resource/candidates');
      const rows = readRows<ApiCandidateRow>(response, ['candidates', 'lines', 'list']);
      const nextCandidates = rows
        .map(toCandidate)
        .filter((candidate): candidate is LineCandidate => candidate !== null);
      setCandidates(nextCandidates);
    } catch (error: unknown) {
      toast.error(apiErrorMessage(error) || '라인 후보 조회에 실패했습니다');
    } finally {
      setCandidateLoading(false);
    }
  }, [candidates.length]);

  const filtered = useMemo(() => {
    const query = search.trim().toLowerCase();
    if (!query) return records;
    return records.filter((record) => [
      record.lineCode,
      record.lineName,
      record.resourceName,
      record.processCode,
      record.resourceType,
      record.parentLineCode,
    ].join(' ').toLowerCase().includes(query));
  }, [records, search]);

  const candidateItems = useMemo(() => {
    const query = candidateQuery.trim().toLowerCase();
    const filteredCandidates = query
      ? candidates.filter((candidate) => `${candidate.lineCode} ${candidate.lineName}`.toLowerCase().includes(query))
      : candidates;
    return filteredCandidates.slice(0, 300);
  }, [candidateQuery, candidates]);

  const columns = useMemo<ColumnDef<ResourceRecord>[]>(
    () => [
      {
        id: 'actions',
        header: '관리',
        size: 84,
        meta: { align: 'center' as const, filterType: 'none' as const },
        cell: ({ row }) => (
          <div className="flex justify-center gap-1">
            <button
              type="button"
              onClick={(event) => { event.stopPropagation(); openEdit(row.original); }}
              className="rounded p-1 text-primary hover:bg-surface"
              title="편집"
            >
              <Edit2 className="h-4 w-4" />
            </button>
            <button
              type="button"
              onClick={(event) => { event.stopPropagation(); setDeleteTarget(row.original); }}
              className="rounded p-1 text-red-500 hover:bg-surface"
              title="삭제"
            >
              <Trash2 className="h-4 w-4" />
            </button>
          </div>
        ),
      },
      { accessorKey: 'lineCode', header: '라인코드', cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'lineName', header: '라인명' },
      { accessorKey: 'resourceName', header: '리소스명' },
      { accessorKey: 'processCode', header: '작업장', size: 90, meta: { align: 'center' as const }, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'resourceType', header: '리소스 유형', size: 110, meta: { align: 'center' as const }, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'parentLineCode', header: '상위라인', size: 100, meta: { align: 'center' as const }, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '') || '-'}</span> },
    ],
    [],
  );

  function openCreate() {
    setForm(emptyForm());
  }

  function openEdit(record: ResourceRecord) {
    setForm({
      isEdit: true,
      resourceId: record.resourceId,
      lineCode: record.lineCode,
      lineName: record.lineName,
      resourceName: record.resourceName,
      processCode: record.processCode,
      resourceType: record.resourceType,
      parentLineCode: record.parentLineCode,
    });
  }

  function openCandidatePicker() {
    setCandidateQuery('');
    setCandidatePickerOpen(true);
    void loadCandidates();
  }

  function pickCandidate(candidate: LineCandidate) {
    if (!form || form.isEdit) return;
    setForm({
      ...form,
      lineCode: candidate.lineCode,
      lineName: candidate.lineName,
      parentLineCode: candidate.parentLineCode,
    });
    setCandidatePickerOpen(false);
  }

  async function save() {
    if (!form) return;
    if (!form.lineCode) {
      toast.error('라인을 선택하세요');
      return;
    }
    if (!isProcessCode(form.processCode) || !isResourceType(form.resourceType)) {
      toast.error('작업장과 리소스 유형을 확인하세요');
      return;
    }
    if (form.isEdit && !form.resourceName.trim()) {
      toast.error('리소스명을 입력하세요');
      return;
    }

    const payload = {
      lineCode: form.lineCode,
      ...(form.isEdit ? { resourceName: form.resourceName.trim() } : {}),
      processCode: form.processCode,
      resourceType: form.resourceType,
    };

    try {
      if (form.isEdit && form.resourceId !== null) {
        await api.put(`/oee/resource/${encodeURIComponent(String(form.resourceId))}`, payload, { skipSuccessToast: true });
      } else {
        await api.post('/oee/resource', payload, { skipSuccessToast: true });
      }
      toast.success('저장되었습니다');
      setForm(null);
      setCandidates([]);
      await load();
    } catch (error: unknown) {
      toast.error(apiErrorMessage(error) || '저장에 실패했습니다');
    }
  }

  async function remove() {
    if (!deleteTarget) return;
    try {
      await api.delete(`/oee/resource/${encodeURIComponent(String(deleteTarget.resourceId))}`, { skipSuccessToast: true });
      toast.success('삭제되었습니다');
      setDeleteTarget(null);
      setCandidates([]);
      await load();
    } catch (error: unknown) {
      toast.error(apiErrorMessage(error) || '삭제에 실패했습니다');
    }
  }

  return (
      <div className="flex h-full overflow-hidden">
       <div className="flex min-w-0 flex-1 flex-col gap-4 overflow-hidden p-3 sm:p-6">
        <div className="flex flex-shrink-0 items-center justify-between">
          <div>
            <h1 className="text-xl font-bold text-text">OEE 리소스 관리</h1>
            <p className="mt-1 text-sm text-text-muted">작업장별 라인·셀 리소스 기준정보를 관리합니다.</p>
          </div>
          <div className="flex items-center gap-2">
            <button type="button" onClick={() => void load()} className="flex h-10 items-center gap-1 rounded border border-border px-3 text-text-muted hover:bg-surface">
              <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침
            </button>
            <button type="button" onClick={openCreate} className="h-10 rounded bg-primary px-4 py-2 text-white">리소스 등록</button>
          </div>
        </div>

        <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
          <CardContent className="h-full p-4">
            <DataGrid
              data={filtered}
              columns={columns}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              enableFullscreen
              exportFileName="OEE리소스관리"
              emptyMessage={records.length ? '조회 결과가 없습니다' : '등록된 OEE 리소스가 없습니다'}
              getRowId={(record) => `${record.resourceId}-${record.processCode}-${record.resourceType}-${record.lineCode}`}
              toolbarLeft={
                <div className="flex min-w-0 flex-1 flex-wrap gap-3">
                  <div className="w-96 flex-shrink-0">
                    <Input
                      placeholder="통합검색 (라인코드·라인명·리소스명·작업장·유형)"
                      value={search}
                      onChange={(event) => setSearch(event.target.value)}
                      leftIcon={<Search className="h-4 w-4" />}
                      fullWidth
                    />
                  </div>
                </div>
              }
            />
          </CardContent>
        </Card>
      </div>

      {form && (
        <aside className="absolute inset-0 z-20 flex h-full w-full flex-shrink-0 animate-slide-in-right flex-col overflow-hidden border-l border-border bg-background shadow-2xl sm:static sm:w-[540px]">
          <div className="flex flex-shrink-0 items-center justify-between border-b border-border px-5 py-3">
            <h2 className="text-sm font-bold text-text">{form.isEdit ? 'OEE 리소스 수정' : 'OEE 리소스 등록'}</h2>
            <div className="flex items-center gap-2">
              <button type="button" onClick={() => setForm(null)} className="rounded border border-border px-3 py-2 text-sm text-text-muted">취소</button>
              <button type="button" onClick={() => void save()} className="rounded bg-primary px-4 py-2 text-sm text-white">저장</button>
            </div>
          </div>

          <div className="min-h-0 flex-1 space-y-4 overflow-y-auto px-5 py-4">
            <div>
              <span className="text-sm font-semibold text-text">리소스 기준정보</span>
              <div className="mt-2 space-y-3">
                <label className="flex flex-col gap-1 text-sm text-text-muted">
                  <span>라인코드 <span className="text-red-500">*</span></span>
                  <div className="flex items-center gap-2">
                    <input
                      value={form.lineCode}
                      disabled={form.isEdit}
                      readOnly
                      placeholder="라인 선택"
                      className="min-w-0 flex-1 rounded border border-border bg-surface p-2 font-mono text-text disabled:cursor-not-allowed disabled:opacity-60"
                    />
                    <button type="button" onClick={openCandidatePicker} disabled={form.isEdit} className="rounded border border-border px-3 py-2 text-sm text-primary hover:bg-surface disabled:cursor-not-allowed disabled:opacity-50">라인 선택</button>
                  </div>
                </label>

                <label className="flex flex-col gap-1 text-sm text-text-muted">
                  라인명
                  <input value={form.lineName} readOnly className="rounded border border-border bg-surface p-2 text-text" />
                </label>

                {form.isEdit && (
                  <label className="flex flex-col gap-1 text-sm text-text-muted">
                    <span>리소스명 <span className="text-red-500">*</span></span>
                    <input
                      value={form.resourceName}
                      onChange={(event) => setForm({ ...form, resourceName: event.target.value })}
                      maxLength={100}
                      required
                      className="rounded border border-border bg-background p-2 text-text"
                    />
                  </label>
                )}

                <div className="grid grid-cols-2 gap-3">
                  <label className="flex flex-col gap-1 text-sm text-text-muted">
                    <span>작업장 <span className="text-red-500">*</span></span>
                    <select value={form.processCode} onChange={(event) => setForm({ ...form, processCode: event.target.value as OeeProcessCode })} className="rounded border border-border bg-background p-2 text-text">
                      <option value="SMT">SMT</option>
                      <option value="ASSY">ASSY</option>
                    </select>
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-text-muted">
                    <span>리소스 유형 <span className="text-red-500">*</span></span>
                    <select value={form.resourceType} onChange={(event) => setForm({ ...form, resourceType: event.target.value as OeeResourceType })} className="rounded border border-border bg-background p-2 text-text">
                      <option value="LINE">LINE</option>
                      <option value="CELL">CELL</option>
                    </select>
                  </label>
                </div>

                {form.parentLineCode && (
                  <label className="flex flex-col gap-1 text-sm text-text-muted">
                    상위라인코드
                    <input value={form.parentLineCode} readOnly className="rounded border border-border bg-surface p-2 font-mono text-text" />
                  </label>
                )}
              </div>
            </div>

            <p className="border-t border-border pt-4 text-xs text-text-muted">라인코드는 수정할 수 없습니다. 다른 라인을 사용하려면 기존 리소스를 삭제하고 새로 등록하세요.</p>
          </div>
        </aside>
      )}

      <Modal isOpen={candidatePickerOpen} onClose={() => setCandidatePickerOpen(false)} title="라인 후보 선택" size="2xl">
        <div className="space-y-3">
          <Input
            placeholder="라인코드/라인명 검색"
            value={candidateQuery}
            onChange={(event) => setCandidateQuery(event.target.value)}
            leftIcon={<Search className="h-4 w-4" />}
            fullWidth
          />
          <div className="max-h-[50vh] overflow-auto rounded border border-border">
            <table className="w-full text-sm">
              <thead className="sticky top-0">
                <tr className="bg-surface text-text-muted">
                  <th className="p-2 text-left">라인코드</th>
                  <th className="p-2 text-left">라인명</th>
                  <th className="p-2 text-left">상위라인</th>
                  <th className="w-20 p-2 text-center">선택</th>
                </tr>
              </thead>
              <tbody>
                {candidateItems.map((candidate) => (
                  <tr key={`${candidate.lineCode}-${candidate.parentLineCode}`} className="border-t border-border">
                    <td className="whitespace-nowrap p-2 font-mono">{candidate.lineCode}</td>
                    <td className="p-2">{candidate.lineName || '-'}</td>
                    <td className="p-2 font-mono">{candidate.parentLineCode || '-'}</td>
                    <td className="w-20 p-2 text-center">
                      <button type="button" onClick={() => pickCandidate(candidate)} className="whitespace-nowrap rounded border border-primary px-3 py-1 text-xs text-primary hover:bg-surface">선택</button>
                    </td>
                  </tr>
                ))}
                {candidateLoading && <tr><td colSpan={4} className="p-4 text-center text-text-muted">라인 후보를 불러오는 중입니다.</td></tr>}
                {!candidateLoading && !candidateItems.length && <tr><td colSpan={4} className="p-4 text-center text-text-muted">선택 가능한 라인이 없습니다.</td></tr>}
              </tbody>
            </table>
          </div>
          <p className="text-[11px] text-text-muted">최대 300건 표시. 검색으로 후보를 좁혀 선택하세요.</p>
        </div>
      </Modal>

      <ConfirmModal
        isOpen={!!deleteTarget}
        onClose={() => setDeleteTarget(null)}
        onConfirm={() => void remove()}
        title="OEE 리소스 삭제"
        message={deleteTarget ? `${deleteTarget.lineCode} (${deleteTarget.processCode}/${deleteTarget.resourceType}) 리소스를 삭제하시겠습니까?` : ''}
        confirmText="삭제"
        cancelText="취소"
        variant="danger"
      />
    </div>
  );
}
