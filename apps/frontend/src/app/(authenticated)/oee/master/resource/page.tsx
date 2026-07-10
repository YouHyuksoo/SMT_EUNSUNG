'use client';

/**
 * @file (authenticated)/oee/master/resource/page.tsx
 * @description OEE 리소스 마스터 — 공정별 관리 단위(설비/라인/작업그룹) CRUD.
 */
import { useState } from 'react';
import useSWR from 'swr';
import { api } from '@/services/api';

const PROCESSES = ['SMT', 'PERF', 'COAT', 'ROUTER', 'ASSY', 'PACK'];
const TYPES = ['MACHINE', 'LINE', 'WORKGROUP'];

const fetcher = (url: string) => api.get(url).then((r) => r.data?.data ?? r.data);

interface ResourceRow {
  resourceId: number;
  processCode: string;
  resourceType: string;
  refCode: string | null;
  resourceName: string;
  idealCt: number | null;
  sortOrder: number;
}

const EMPTY = {
  resourceId: 0,
  organizationId: 1,
  processCode: 'SMT',
  resourceType: 'LINE',
  refCode: '',
  resourceName: '',
  idealCt: '',
  sortOrder: 0,
};

export default function OeeResourceMasterPage() {
  const { data, mutate } = useSWR<{ resources: ResourceRow[] }>('/oee/resource', fetcher);
  const [form, setForm] = useState({ ...EMPTY });
  const editing = form.resourceId > 0;

  async function save() {
    if (!form.resourceName) {
      alert('리소스명은 필수입니다');
      return;
    }
    const body = {
      ...form,
      refCode: form.refCode || null,
      idealCt: form.idealCt ? Number(form.idealCt) : null,
    };
    await api[editing ? 'put' : 'post']('/oee/resource', body);
    setForm({ ...EMPTY });
    mutate();
  }

  return (
    <div className="p-6 space-y-4">
      <h1 className="text-xl font-bold text-text">OEE 리소스 마스터</h1>

      <div className="flex flex-wrap gap-2 items-end bg-surface border border-border rounded-lg p-3">
        <label className="text-sm text-text-muted flex flex-col gap-1">
          공정
          <select value={form.processCode} onChange={(e) => setForm({ ...form, processCode: e.target.value })} className="border border-border rounded p-2 bg-background text-text">
            {PROCESSES.map((p) => <option key={p}>{p}</option>)}
          </select>
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          유형
          <select value={form.resourceType} onChange={(e) => setForm({ ...form, resourceType: e.target.value })} className="border border-border rounded p-2 bg-background text-text">
            {TYPES.map((t) => <option key={t}>{t}</option>)}
          </select>
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          참조코드(설비/라인)
          <input value={form.refCode} onChange={(e) => setForm({ ...form, refCode: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          리소스명
          <input value={form.resourceName} onChange={(e) => setForm({ ...form, resourceName: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          이론CT(초)
          <input value={form.idealCt} onChange={(e) => setForm({ ...form, idealCt: e.target.value })} className="border border-border rounded p-2 w-28 bg-background text-text" />
        </label>
        <button onClick={save} className="bg-primary text-white px-4 py-2 rounded h-10">
          {editing ? '수정' : '추가'}
        </button>
        {editing && (
          <button onClick={() => setForm({ ...EMPTY })} className="px-3 py-2 rounded h-10 border border-border text-text-muted">
            취소
          </button>
        )}
      </div>

      <table className="w-full text-sm border border-border">
        <thead>
          <tr className="bg-surface text-text-muted">
            <th className="p-2 text-left">공정</th>
            <th className="p-2 text-left">유형</th>
            <th className="p-2 text-left">참조</th>
            <th className="p-2 text-left">리소스명</th>
            <th className="p-2 text-right">이론CT</th>
            <th className="p-2"></th>
          </tr>
        </thead>
        <tbody>
          {data?.resources?.map((r) => (
            <tr key={r.resourceId} className="border-t border-border">
              <td className="p-2">{r.processCode}</td>
              <td className="p-2">{r.resourceType}</td>
              <td className="p-2">{r.refCode}</td>
              <td className="p-2">{r.resourceName}</td>
              <td className="p-2 text-right">{r.idealCt}</td>
              <td className="p-2 text-right">
                <button
                  onClick={() => setForm({ resourceId: r.resourceId, organizationId: 1, processCode: r.processCode, resourceType: r.resourceType, refCode: r.refCode ?? '', resourceName: r.resourceName, idealCt: r.idealCt?.toString() ?? '', sortOrder: r.sortOrder })}
                  className="text-primary"
                >
                  편집
                </button>
              </td>
            </tr>
          ))}
          {!data?.resources?.length && (
            <tr><td colSpan={6} className="p-4 text-center text-text-muted">등록된 리소스가 없습니다</td></tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
