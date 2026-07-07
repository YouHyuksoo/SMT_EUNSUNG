'use client';

/**
 * @file (authenticated)/oee/master/reason/page.tsx
 * @description OEE 비가동사유 코드마스터 — 6대 로스 버킷/OEE 요소 귀속 관리 CRUD.
 */
import { useState } from 'react';
import useSWR from 'swr';
import { api } from '@/services/api';

const LOSS_BUCKETS = ['AVAIL_DOWN', 'SETUP', 'MATERIAL', 'PERF_MINOR_STOP', 'PERF_SPEED'];
const OEE_FACTORS = ['AVAILABILITY', 'PERFORMANCE'];

const fetcher = (url: string) => api.get(url).then((r) => r.data?.data ?? r.data);

interface ReasonRow {
  reasonCode: string;
  processCode: string;
  reasonName: string;
  lossBucket: string;
  oeeFactor: string;
  sortOrder: number;
}

const EMPTY = {
  reasonCode: '',
  organizationId: 1,
  processCode: '*',
  reasonName: '',
  lossBucket: 'AVAIL_DOWN',
  oeeFactor: 'AVAILABILITY',
  sortOrder: 0,
};

export default function OeeReasonMasterPage() {
  const { data, mutate } = useSWR<{ reasons: ReasonRow[] }>('/oee/reason', fetcher);
  const [form, setForm] = useState({ ...EMPTY });
  const [editing, setEditing] = useState(false);

  async function save() {
    if (!form.reasonCode || !form.reasonName) {
      alert('사유코드와 사유명은 필수입니다');
      return;
    }
    await api[editing ? 'put' : 'post']('/oee/reason', form);
    setForm({ ...EMPTY });
    setEditing(false);
    mutate();
  }

  return (
    <div className="p-6 space-y-4">
      <h1 className="text-xl font-bold text-text">OEE 비가동사유 마스터</h1>

      <div className="flex flex-wrap gap-2 items-end bg-surface border border-border rounded-lg p-3">
        <label className="text-sm text-text-muted flex flex-col gap-1">
          사유코드
          <input value={form.reasonCode} disabled={editing} onChange={(e) => setForm({ ...form, reasonCode: e.target.value.toUpperCase() })} className="border border-border rounded p-2 bg-background text-text disabled:opacity-50 w-32" />
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          사유명
          <input value={form.reasonName} onChange={(e) => setForm({ ...form, reasonName: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          공정
          <input value={form.processCode} onChange={(e) => setForm({ ...form, processCode: e.target.value })} className="border border-border rounded p-2 bg-background text-text w-24" />
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          로스버킷
          <select value={form.lossBucket} onChange={(e) => setForm({ ...form, lossBucket: e.target.value })} className="border border-border rounded p-2 bg-background text-text">
            {LOSS_BUCKETS.map((b) => <option key={b}>{b}</option>)}
          </select>
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          OEE요소
          <select value={form.oeeFactor} onChange={(e) => setForm({ ...form, oeeFactor: e.target.value })} className="border border-border rounded p-2 bg-background text-text">
            {OEE_FACTORS.map((f) => <option key={f}>{f}</option>)}
          </select>
        </label>
        <button onClick={save} className="bg-primary text-white px-4 py-2 rounded h-10">
          {editing ? '수정' : '추가'}
        </button>
        {editing && (
          <button onClick={() => { setForm({ ...EMPTY }); setEditing(false); }} className="px-3 py-2 rounded h-10 border border-border text-text-muted">
            취소
          </button>
        )}
      </div>

      <table className="w-full text-sm border border-border">
        <thead>
          <tr className="bg-surface text-text-muted">
            <th className="p-2 text-left">코드</th>
            <th className="p-2 text-left">사유명</th>
            <th className="p-2 text-left">공정</th>
            <th className="p-2 text-left">로스버킷</th>
            <th className="p-2 text-left">OEE요소</th>
            <th className="p-2"></th>
          </tr>
        </thead>
        <tbody>
          {data?.reasons?.map((r) => (
            <tr key={r.reasonCode} className="border-t border-border">
              <td className="p-2 font-mono">{r.reasonCode}</td>
              <td className="p-2">{r.reasonName}</td>
              <td className="p-2">{r.processCode}</td>
              <td className="p-2">{r.lossBucket}</td>
              <td className="p-2">{r.oeeFactor}</td>
              <td className="p-2 text-right">
                <button
                  onClick={() => { setForm({ reasonCode: r.reasonCode, organizationId: 1, processCode: r.processCode, reasonName: r.reasonName, lossBucket: r.lossBucket, oeeFactor: r.oeeFactor, sortOrder: r.sortOrder }); setEditing(true); }}
                  className="text-primary"
                >
                  편집
                </button>
              </td>
            </tr>
          ))}
          {!data?.reasons?.length && (
            <tr><td colSpan={6} className="p-4 text-center text-text-muted">등록된 사유가 없습니다</td></tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
