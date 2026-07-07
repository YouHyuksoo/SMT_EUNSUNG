'use client';

/**
 * @file (authenticated)/oee/entry/page.tsx
 * @description OEE 가동일지 입력 — 단말 프로파일(공정·리소스·근무조) 고정 후
 *              근무조별 가동/비가동 구간 + 작업자 사번으로 저장.
 *              검증은 @smt/shared validateIntervals(백엔드와 동일 정의)를 프론트에서 즉시 재사용.
 */
import { useEffect, useState } from 'react';
import useSWR from 'swr';
import { validateIntervals } from '@smt/shared';
import { api } from '@/services/api';
import { useOeeProfile } from '@/hooks/useOeeProfile';
import IntervalEditor from './_components/IntervalEditor';

export interface SaveInterval {
  startMin: number;
  endMin: number;
  status: 'RUN' | 'DOWN';
  reasonCode: string | null;
  runNo: string | null;
  remark: string | null;
}

interface ResourceRow { resourceId: number; processCode: string; resourceName: string; }
interface ReasonRow { reasonCode: string; reasonName: string; }
interface ShiftLogRow { startMin: number; endMin: number; status: 'RUN' | 'DOWN'; reasonCode: string | null; runNo: string | null; remark: string | null; }

const fetcher = (url: string) => api.get(url).then((r) => r.data?.data ?? r.data);
const todayStr = () => {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};

export default function OeeEntryPage() {
  const { profile, setProfile, loaded } = useOeeProfile();
  const { data: resData } = useSWR<{ resources: ResourceRow[] }>('/oee/resource', fetcher);
  const { data: reasonData } = useSWR<{ reasons: ReasonRow[] }>('/oee/reason', fetcher);

  const [workDate, setWorkDate] = useState(todayStr());
  const [worker, setWorker] = useState('');
  const [netLoad, setNetLoad] = useState(480);
  const [intervals, setIntervals] = useState<SaveInterval[]>([]);
  const [msg, setMsg] = useState<{ text: string; ok: boolean } | null>(null);

  const resource = resData?.resources?.find((r) => r.resourceId === profile?.resourceId);

  useEffect(() => {
    if (!profile) return;
    api
      .get(`/oee/log?resourceId=${profile.resourceId}&workDate=${workDate}&shift=${profile.shift}`)
      .then((r) => {
        const d = (r.data?.data ?? r.data) as { rows: ShiftLogRow[] };
        setIntervals(d.rows.map((row) => ({ startMin: row.startMin, endMin: row.endMin, status: row.status, reasonCode: row.reasonCode, runNo: row.runNo, remark: row.remark })));
      })
      .catch(() => setIntervals([]));
  }, [profile, workDate]);

  async function save() {
    setMsg(null);
    if (!profile || !resource) { setMsg({ text: '단말 프로파일을 먼저 설정하세요', ok: false }); return; }
    if (!worker) { setMsg({ text: '작업자 사번을 입력하세요', ok: false }); return; }
    const errs = validateIntervals(
      intervals.map((iv) => ({ startMin: iv.startMin, endMin: iv.endMin, status: iv.status, reasonCode: iv.reasonCode })),
      netLoad,
    );
    if (errs.length > 0) { setMsg({ text: errs.map((e) => e.message).join(' / '), ok: false }); return; }
    try {
      await api.post('/oee/log', {
        organizationId: 1,
        resourceId: profile.resourceId,
        processCode: resource.processCode,
        workDate,
        shift: profile.shift,
        netLoadMinutes: netLoad,
        createdBy: worker,
        intervals,
      });
      setMsg({ text: '저장 완료', ok: true });
    } catch (e: unknown) {
      const err = e as { response?: { data?: { message?: unknown } } };
      const m = err.response?.data?.message;
      setMsg({ text: typeof m === 'string' ? m : '저장 실패', ok: false });
    }
  }

  if (!loaded) return null;

  // 프로파일 미설정 → 설정 화면
  if (!profile) {
    return (
      <div className="p-6 space-y-4 max-w-md">
        <h1 className="text-xl font-bold text-text">단말 프로파일 설정</h1>
        <p className="text-sm text-text-muted">이 단말에서 입력할 공정·리소스·근무조를 선택하세요. 이후 고정됩니다.</p>
        <select id="oee-res" className="border border-border rounded p-2 w-full bg-background text-text">
          {resData?.resources?.map((r) => (
            <option key={r.resourceId} value={r.resourceId}>{r.processCode} · {r.resourceName}</option>
          ))}
        </select>
        <select id="oee-shift" className="border border-border rounded p-2 w-full bg-background text-text">
          <option value="DAY">주간</option>
          <option value="NIGHT">야간</option>
        </select>
        <button
          className="bg-primary text-white px-4 py-2 rounded w-full"
          onClick={() => {
            const rid = Number((document.getElementById('oee-res') as HTMLSelectElement).value);
            const shift = (document.getElementById('oee-shift') as HTMLSelectElement).value;
            const r = resData?.resources?.find((x) => x.resourceId === rid);
            if (r) setProfile({ resourceId: rid, processCode: r.processCode, resourceName: r.resourceName, shift });
          }}
        >
          설정
        </button>
        {!resData?.resources?.length && (
          <p className="text-sm text-amber-600">등록된 리소스가 없습니다. 먼저 &apos;OEE 리소스 마스터&apos;에서 리소스를 등록하세요.</p>
        )}
      </div>
    );
  }

  return (
    <div className="p-6 space-y-4">
      <div className="flex justify-between items-center">
        <h1 className="text-xl font-bold text-text">{profile.processCode} · {profile.resourceName} 가동일지</h1>
        <button className="text-sm text-text-muted hover:text-text" onClick={() => setProfile(null)}>프로파일 변경</button>
      </div>

      <div className="flex flex-wrap gap-3 items-end bg-surface border border-border rounded-lg p-3">
        <label className="text-sm text-text-muted flex flex-col gap-1">
          일자
          <input type="date" value={workDate} onChange={(e) => setWorkDate(e.target.value)} className="border border-border rounded p-2 bg-background text-text" />
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          작업자 사번
          <input value={worker} onChange={(e) => setWorker(e.target.value)} className="border border-border rounded p-2 bg-background text-text" placeholder="스캔/입력" />
        </label>
        <label className="text-sm text-text-muted flex flex-col gap-1">
          계획가동(분)
          <input type="number" value={netLoad} onChange={(e) => setNetLoad(Number(e.target.value))} className="border border-border rounded p-2 w-28 bg-background text-text" />
        </label>
      </div>

      <IntervalEditor intervals={intervals} reasons={reasonData?.reasons ?? []} onChange={setIntervals} />

      {msg && <p className={`text-sm ${msg.ok ? 'text-green-600' : 'text-red-600'}`}>{msg.text}</p>}

      <button onClick={save} className="bg-green-600 text-white px-6 py-2 rounded">저장</button>
    </div>
  );
}
