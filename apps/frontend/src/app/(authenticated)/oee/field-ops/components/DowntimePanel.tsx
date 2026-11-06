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
import DataGrid from '@/components/data-grid/DataGrid';
import DowntimeReasonGrid from '@/components/shared/DowntimeReasonGrid';
import api from '@/services/api';
import type { OpsMachine } from '../../equip-ops-status/types';
import { targetMachineColumns } from '../../equip-ops-status/components/downtime-columns';

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

  async function apply() {
    if (!actionTargets.length) return;
    if (willEnd && !reasonCode) return toast.error('비가동 사유를 선택하세요');
    setBusy(true);
    try {
      const res = await api.post('/oee/work-result/downtimes/bulk', {
        action: willEnd ? 'END' : 'START',
        machineCodes: actionTargets.map((m) => m.machineCode),
        reasonCode: reasonCode || undefined,
        worker: workerCode || undefined,
      });
      const d = res.data?.data ?? {};
      const verb = willEnd ? '가동 전환' : '비가동 시작';
      toast.success(d.skipped ? `${d.affected}대 ${verb} (${d.skipped}대는 이미 해당 상태)` : `${d.affected}대 ${verb}`);
      setReasonPick(null);
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
          </span>
        </div>

        {/* 대상 설비 목록 — 여기만 스크롤한다 (사유/전환 버튼은 항상 보인다) */}
        <div className="flex-1 min-h-0">
          <DataGrid
            data={targets}
            columns={targetMachineColumns}
            pageSize={1000}
            showFooter={false}
            enableColumnFilter={false}
            enableFullscreen={false}
            enableColumnReordering={false}
            enableColumnPinning={false}
            getRowId={(m) => m.machineCode}
            emptyMessage={mode === 'LINE' ? '라인을 선택하세요' : '설비를 선택하세요'}
          />
        </div>

        {/* 비가동 사유 — 사유가 많아 자리가 모자라면 여기가 줄어들고 스크롤한다 */}
        <div className="min-h-0 overflow-y-auto">
          <span className="text-xs text-text-muted">비가동 사유
            <span className="text-[11px]"> {willEnd ? '(종료 시 필수 — 대상 전체에 기록)' : '(선택)'}</span>
          </span>
          <div className="mt-1">
            <DowntimeReasonGrid reasons={reasons} value={reasonCode} onChange={setReasonPick} columns={3} dense />
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
