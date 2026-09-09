'use client';

/**
 * @file (authenticated)/oee/field-ops/components/DowntimePanel.tsx
 * @description 현장 화면 중앙 — 비가동 대상 설비 목록 + 사유 선택 + 전환 처리.
 *
 * 설비 운영 현황의 비가동 처리 영역을 그대로 옮겼다. 다른 점은 두 가지다.
 * 1. 타이틀 옆 [이력보기]로 이전 30일 이력을 팝업으로 연다 (우측은 작업실적이 차지한다).
 * 2. 상단에서 고른 작업자의 사번을 비가동 행의 WORKER로 함께 보낸다.
 */
import { useEffect, useState } from 'react';
import { History, PauseCircle, PlayCircle } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import type { OpsMachine } from '../../equip-ops-status/types';

interface Code { code: string; name: string; }

interface Props {
  /** 처리 대상 설비 (라인 모드면 그 라인 전체, 설비 모드면 1대) */
  targets: OpsMachine[];
  mode: 'LINE' | 'MACHINE';
  /** 비가동 행에 남길 작업자 사번 */
  workerCode: string;
  onHistoryClick: () => void;
  onChanged: () => void | Promise<void>;
}

export default function DowntimePanel({ targets, mode, workerCode, onHistoryClick, onChanged }: Props) {
  const [reasons, setReasons] = useState<Code[]>([]);
  const [reasonPick, setReasonPick] = useState<string | null>(null);
  const [causeCodes, setCauseCodes] = useState<Set<string>>(new Set());
  const [busy, setBusy] = useState(false);

  const downTargets = targets.filter((m) => m.openDtSeq != null);
  // 하나라도 비가동이면 '가동 전환'을 가리킨다 (결정 #11)
  const willEnd = downTargets.length > 0;
  const actionTargets = willEnd ? downTargets : targets.filter((m) => m.openDtSeq == null);

  // 종료 화면은 첫 대상 설비가 '시작할 때 고른 사유'를 기본값으로 물고 온다.
  const openReasonCode = willEnd ? (actionTargets[0]?.openReasonCode ?? '') : '';
  const reasonCode = reasonPick ?? openReasonCode;

  // 비가동 사유는 대표 설비 1대 기준으로 읽는다 (설비별 연계 사유가 있으면 그것, 없으면 전체)
  const reasonSeed = targets[0]?.machineCode ?? '';
  useEffect(() => {
    api.get('/oee/work-result/downtime-reasons', { params: { machineCode: reasonSeed || undefined } })
      .then((r) => setReasons(r.data?.data?.list ?? []))
      .catch(() => setReasons([]));
  }, [reasonSeed]);

  const toggleCause = (code: string) =>
    setCauseCodes((prev) => {
      const next = new Set(prev);
      if (next.has(code)) next.delete(code); else next.add(code);
      return next;
    });

  async function apply() {
    if (!actionTargets.length) return;
    if (willEnd && !reasonCode) return toast.error('비가동 사유를 선택하세요');
    setBusy(true);
    try {
      const res = await api.post('/oee/work-result/downtimes/bulk', {
        action: willEnd ? 'END' : 'START',
        machineCodes: actionTargets.map((m) => m.machineCode),
        // 원인설비는 비가동 시작에서만 의미가 있다
        causeMachineCodes: willEnd
          ? undefined
          : actionTargets.filter((m) => causeCodes.has(m.machineCode)).map((m) => m.machineCode),
        reasonCode: reasonCode || undefined,
        worker: workerCode || undefined,
      });
      const d = res.data?.data ?? {};
      const verb = willEnd ? '가동 전환' : '비가동 시작';
      toast.success(d.skipped ? `${d.affected}대 ${verb} (${d.skipped}대는 이미 해당 상태)` : `${d.affected}대 ${verb}`);
      setReasonPick(null);
      setCauseCodes(new Set());
      await onChanged();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '처리에 실패했습니다');
    } finally { setBusy(false); }
  }

  return (
    <Card className="h-full overflow-hidden" padding="none">
      <CardContent className="h-full p-4 overflow-hidden flex flex-col gap-3">
        <div className="flex items-center justify-between flex-shrink-0 gap-2">
          <div className="flex items-center gap-2">
            <span className="text-sm font-semibold text-text">비가동 대상 설비</span>
            <button type="button" onClick={onHistoryClick}
              className="flex items-center gap-1 rounded border border-border px-2 py-1 text-[11px] text-text-muted hover:bg-surface hover:text-text">
              <History className="w-3 h-3" />이력보기
            </button>
          </div>
          <span className="text-[11px] text-text-muted">
            대상 {targets.length}대 · 비가동 <span className={downTargets.length ? 'text-red-500 font-semibold' : ''}>{downTargets.length}</span>대
            {!willEnd && causeCodes.size > 0 && <> · 원인설비 <span className="text-amber-600 font-semibold">{causeCodes.size}</span>대</>}
          </span>
        </div>

        {/* 대상 설비 목록 — 여기만 스크롤한다 (사유/전환 버튼은 항상 보인다) */}
        <div className="border border-border rounded flex-1 min-h-0 overflow-y-auto">
          <table className="w-full table-fixed text-xs">
            <thead className="bg-surface text-text-muted sticky top-0 z-10">
              <tr><th className="py-1.5 px-0.5 text-center font-medium w-8">원인</th><th className="py-1.5 px-0.5 text-center font-medium w-[76px]">설비코드</th><th className="py-1.5 px-1 text-center font-medium">설비명</th><th className="py-1.5 px-0 text-center font-medium w-12">유형</th><th className="py-1.5 pl-0 pr-0.5 text-center font-medium w-16">상태</th></tr>
            </thead>
            <tbody>
              {targets.map((m) => {
                const down = m.openDtSeq != null;
                return (
                  <tr key={m.machineCode} className="border-t border-border">
                    <td className="py-1.5 px-0.5 text-center">
                      <input type="checkbox" checked={causeCodes.has(m.machineCode)}
                        onChange={() => toggleCause(m.machineCode)}
                        disabled={willEnd || down}
                        title={willEnd ? '종료 처리에는 원인설비를 지정하지 않습니다' : down ? '이미 비가동 중인 설비입니다' : '이 설비를 라인 정지의 원인으로 표시'}
                        aria-label={`${m.machineCode} 원인설비`}
                        className="w-3.5 h-3.5 cursor-pointer rounded border-border disabled:cursor-not-allowed disabled:opacity-40" />
                    </td>
                    <td className="py-1.5 px-0.5 text-center font-mono truncate">{m.machineCode}</td>
                    <td className="py-1.5 px-1 text-center truncate">{m.machineName ?? '-'}</td>
                    <td className="py-1.5 px-0 text-center truncate">{m.machineTypeName ?? m.machineType ?? '-'}</td>
                    <td className="py-1.5 pl-0 pr-0.5 text-center">
                      {down ? (
                        <span className="px-1.5 py-0.5 rounded bg-red-500 text-white">비가동</span>
                      ) : (
                        <span className="px-1.5 py-0.5 rounded bg-emerald-500 text-white">가동</span>
                      )}
                    </td>
                  </tr>
                );
              })}
              {!targets.length && (
                <tr><td colSpan={5} className="p-6 text-center text-text-muted">
                  {mode === 'LINE' ? '라인을 선택하세요' : '설비를 선택하세요'}
                </td></tr>
              )}
            </tbody>
          </table>
        </div>

        {/* 비가동 사유 — 사유가 많아 자리가 모자라면 여기가 줄어들고 스크롤한다 */}
        <div className="min-h-0 overflow-y-auto">
          <span className="text-xs text-text-muted">비가동 사유
            <span className="text-[11px]"> {willEnd ? '(종료 시 필수 — 대상 전체에 기록)' : '(선택)'}</span>
          </span>
          <div className="grid grid-cols-3 gap-2 mt-1">
            {reasons.map((r) => {
              const active = reasonCode === r.code;
              return (
                <button key={r.code} type="button" onClick={() => setReasonPick(active ? '' : r.code)}
                  className={`px-2 py-[5.5px] rounded border text-[11px] text-center transition-colors ${active ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'}`}>
                  <span className="block font-medium leading-tight">{r.name}</span>
                  <span className={`block text-[9px] font-mono ${active ? 'text-white/80' : 'text-text-muted'}`}>{r.code}</span>
                </button>
              );
            })}
            {!reasons.length && <span className="col-span-3 text-xs text-text-muted py-2">연계된 비가동 사유가 없습니다</span>}
          </div>
        </div>

        <button type="button" onClick={apply} disabled={busy || !actionTargets.length}
          className={`mt-auto flex-shrink-0 h-12 rounded-lg text-sm font-semibold text-white flex items-center justify-center gap-2 disabled:opacity-40 ${willEnd ? 'bg-emerald-600 hover:bg-emerald-700' : 'bg-red-500 hover:bg-red-600'}`}>
          {willEnd ? <PlayCircle className="w-5 h-5" /> : <PauseCircle className="w-5 h-5" />}
          {actionTargets.length
            ? `${willEnd ? '가동 전환' : '비가동 시작'} · ${actionTargets.length}대`
            : (targets.length ? '처리할 설비가 없습니다' : '대상을 선택하세요')}
        </button>
      </CardContent>
    </Card>
  );
}
