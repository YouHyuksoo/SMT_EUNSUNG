'use client';

/**
 * @file (authenticated)/oee/equip-ops-status/components/DowntimeTab.tsx
 * @description 설비 운영 현황 - 비가동 처리 탭. 라인/설비 선택(바코드) 후 지표·현재상태·이전 30일 이력
 *
 * 라인 모드는 대상 설비 전체에 일괄 적용하고, 설비 모드는 그 설비만 처리한다.
 * 토글은 하나만 두되 "하나라도 비가동이면 가동 전환"으로 판정한다 (결정 #11).
 * 종료는 공통 사유 1개를 필수로 받아 대상 전체에 덮어쓴다 (결정 #12).
 */

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Barcode, Factory, PauseCircle, PlayCircle, Wrench } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent, Input, Select } from '@/components/ui';
import { ElapsedTime, parseLocalTime } from '@/components/shared/EquipDowntimePanel';
import api from '@/services/api';
import DailyMetrics from './DailyMetrics';
import type { OpsLine, OpsMachine, RecentRow, RefreshInterval } from '../types';

interface Code { code: string; name: string; }
type ScopeMode = 'LINE' | 'MACHINE';

interface Props {
  machines: OpsMachine[];
  lines: OpsLine[];
  refreshSec: RefreshInterval;
  onChanged: () => void | Promise<void>;
}

export default function DowntimeTab({ machines, lines, refreshSec, onChanged }: Props) {
  const [mode, setMode] = useState<ScopeMode>('MACHINE');
  const [lineCode, setLineCode] = useState('');
  const [machineCode, setMachineCode] = useState('');
  const [scan, setScan] = useState('');
  const scanRef = useRef<HTMLInputElement>(null);

  const [reasons, setReasons] = useState<Code[]>([]);
  const [reasonCode, setReasonCode] = useState('');
  const [summary, setSummary] = useState({ downMinutes: 0, stopCount: 0 });
  const [recent, setRecent] = useState<{ list: RecentRow[]; totalCount: number; totalMinutes: number }>({ list: [], totalCount: 0, totalMinutes: 0 });
  const [openStarts, setOpenStarts] = useState<Record<string, string | null>>({});
  const [clockSkew, setClockSkew] = useState(0);
  const [busy, setBusy] = useState(false);

  const selectedLine = lines.find((l) => l.lineCode === lineCode) ?? null;
  const selectedMachine = machines.find((m) => m.machineCode === machineCode) ?? null;

  // 처리 대상 설비 — 라인 모드면 그 라인 배정 설비 전체, 설비 모드면 1대
  const targets = useMemo(() => {
    if (mode === 'LINE') return lineCode ? machines.filter((m) => m.lineCode === lineCode) : [];
    return selectedMachine ? [selectedMachine] : [];
  }, [mode, lineCode, machines, selectedMachine]);

  const downTargets = targets.filter((m) => m.openDtSeq != null);
  // 하나라도 비가동이면 '가동 전환'을 가리킨다 (결정 #11)
  const willEnd = downTargets.length > 0;
  const actionTargets = willEnd ? downTargets : targets.filter((m) => m.openDtSeq == null);

  const scopeLabel = mode === 'LINE'
    ? (selectedLine ? `${selectedLine.lineCode} · ${selectedLine.lineName ?? ''}` : null)
    : (selectedMachine ? `${selectedMachine.machineCode} · ${selectedMachine.machineName ?? ''}` : null);

  const scopeParams = useMemo(
    () => (mode === 'LINE' ? (lineCode ? { lineCode } : null) : (machineCode ? { machineCode } : null)),
    [mode, lineCode, machineCode],
  );

  /** 지표·이전 30일 이력·사유·진행중 시작시각을 한 번에 읽는다 */
  const loadScope = useCallback(async () => {
    if (!scopeParams) {
      setSummary({ downMinutes: 0, stopCount: 0 });
      setRecent({ list: [], totalCount: 0, totalMinutes: 0 });
      setOpenStarts({});
      return;
    }
    try {
      const [s, m] = await Promise.all([
        api.get('/oee/equip-ops/summary', { params: scopeParams }),
        api.get('/oee/equip-ops/recent', { params: scopeParams }),
      ]);
      setSummary(s.data?.data ?? { downMinutes: 0, stopCount: 0 });
      setRecent(m.data?.data ?? { list: [], totalCount: 0, totalMinutes: 0 });
    } catch { /* 조회 실패는 빈 화면으로 둔다 */ }
  }, [scopeParams]);

  useEffect(() => { loadScope(); }, [loadScope]);

  // 비가동 사유는 대표 설비 1대 기준으로 읽는다 (설비별 연계 사유가 있으면 그것, 없으면 전체)
  const reasonSeed = targets[0]?.machineCode ?? '';
  useEffect(() => {
    api.get('/oee/work-result/downtime-reasons', { params: { machineCode: reasonSeed || undefined } })
      .then((r) => setReasons(r.data?.data?.list ?? []))
      .catch(() => setReasons([]));
  }, [reasonSeed]);

  // 진행중 비가동의 시작시각(초 단위) — 경과 타이머용. DB 시각 기준이라 오차도 함께 받는다
  const openCodes = downTargets.map((m) => m.machineCode).join(',');
  useEffect(() => {
    if (!openCodes) { setOpenStarts({}); return; }
    const codes = openCodes.split(',');
    Promise.all(codes.map((c) => api.get('/oee/work-result/downtimes', { params: { machineCode: c } })))
      .then((res) => {
        const next: Record<string, string | null> = {};
        let skew = 0;
        res.forEach((r, i) => {
          const list = (r.data?.data?.list ?? []) as Array<{ endTime: string | null; startAt: string | null }>;
          next[codes[i]] = list.find((d) => !d.endTime)?.startAt ?? null;
          const sn: string | undefined = r.data?.data?.serverNow;
          const t = sn ? parseLocalTime(sn) : null;
          if (t != null) skew = t - Date.now();
        });
        setOpenStarts(next);
        setClockSkew(skew);
      })
      .catch(() => setOpenStarts({}));
  }, [openCodes]);

  // 자동갱신 — 페이지 헤더의 주기 설정을 그대로 따른다
  useEffect(() => {
    if (!refreshSec) return;
    const id = setInterval(() => { loadScope(); }, refreshSec * 1000);
    return () => clearInterval(id);
  }, [refreshSec, loadScope]);

  /** 바코드/수기 입력 → 선택 모드에 맞는 코드로 대상 확정 (라인 모드=라인코드, 설비 모드=설비코드) */
  function resolveScan(raw: string) {
    const code = raw.trim().toUpperCase();
    if (!code) return;
    if (mode === 'LINE') {
      const line = lines.find((l) => l.lineCode.toUpperCase() === code);
      if (!line) { toast.error(`라인코드 '${raw.trim()}'를 찾을 수 없습니다`); return; }
      setLineCode(line.lineCode);
      setScan('');
      toast.success(`${line.lineCode} · ${line.lineName ?? ''} 선택`);
      return;
    }
    const machine = machines.find((m) => m.machineCode.toUpperCase() === code);
    if (!machine) { toast.error(`설비코드 '${raw.trim()}'를 찾을 수 없습니다`); return; }
    setMachineCode(machine.machineCode);
    setScan('');
    toast.success(`${machine.machineCode} · ${machine.machineName ?? ''} 선택`);
  }

  async function apply() {
    if (!actionTargets.length) return;
    if (willEnd && !reasonCode) return toast.error('비가동 사유를 선택하세요');
    setBusy(true);
    try {
      const res = await api.post('/oee/work-result/downtimes/bulk', {
        action: willEnd ? 'END' : 'START',
        machineCodes: actionTargets.map((m) => m.machineCode),
        reasonCode: reasonCode || undefined,
      });
      const d = res.data?.data ?? {};
      const verb = willEnd ? '가동 전환' : '비가동 시작';
      toast.success(d.skipped ? `${d.affected}대 ${verb} (${d.skipped}대는 이미 해당 상태)` : `${d.affected}대 ${verb}`);
      setReasonCode('');
      await onChanged();
      await loadScope();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '처리에 실패했습니다');
    } finally { setBusy(false); }
  }

  return (
    <div className="h-full flex flex-col gap-3 overflow-hidden">
      {/* 상단 — 라인/설비 선택 + 바코드 */}
      <div className="flex items-end gap-3 flex-wrap flex-shrink-0 border border-border rounded-lg p-3">
        <div className="flex gap-2">
          {([['LINE', '라인', Factory], ['MACHINE', '설비', Wrench]] as const).map(([key, label, Icon]) => (
            <button key={key} type="button"
              onClick={() => { setMode(key); setLineCode(''); setMachineCode(''); }}
              className={`w-24 h-[68px] rounded-lg border flex flex-col items-center justify-center gap-1 text-sm font-semibold transition-colors ${
                mode === key ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'
              }`}>
              <Icon className="w-5 h-5" />{label}
            </button>
          ))}
        </div>

        {mode === 'LINE' ? (
          <label className="text-xs text-text-muted flex flex-col gap-1 w-72">라인 선택 (라인코드 · 라인명 · 라인구분)
            <Select
              options={[{ value: '', label: '라인을 선택하세요' },
                ...lines.map((l) => ({ value: l.lineCode, label: `${l.lineCode} · ${l.lineName ?? ''} · ${l.lineDivision ?? '-'} (${l.machineCount}대)` }))]}
              value={lineCode} onChange={setLineCode} fullWidth />
          </label>
        ) : (
          <label className="text-xs text-text-muted flex flex-col gap-1 w-72">설비 선택 (설비코드 · 설비명 · 유형)
            <Select
              options={[{ value: '', label: '설비를 선택하세요' },
                ...machines.map((m) => ({ value: m.machineCode, label: `${m.machineCode} · ${m.machineName ?? ''} · ${m.machineTypeName ?? m.machineType ?? '-'}` }))]}
              value={machineCode} onChange={setMachineCode} fullWidth />
          </label>
        )}

        <label className="text-xs text-text-muted flex flex-col gap-1">바코드 ({mode === 'LINE' ? '라인코드' : '설비코드'} 스캔 또는 직접 입력)
          <div className="w-64">
            <Input ref={scanRef} placeholder="스캔 후 Enter" value={scan}
              onChange={(e) => setScan(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') { e.preventDefault(); resolveScan(scan); } }}
              leftIcon={<Barcode className="w-4 h-4" />} fullWidth />
          </div>
        </label>
      </div>

      {/* 본문 3분할 */}
      <div className="flex-1 min-h-0 grid grid-cols-[minmax(0,1fr)_minmax(0,1.4fr)_minmax(0,1.2fr)] gap-3 overflow-hidden">
        {/* 좌 — 당일 지표 */}
        <DailyMetrics downMinutes={summary.downMinutes} stopCount={summary.stopCount} scopeLabel={scopeLabel} />

        {/* 중앙 — 현재 상태 + 처리 */}
        <Card className="h-full overflow-hidden" padding="none">
          <CardContent className="h-full p-4 overflow-y-auto flex flex-col gap-3">
            <div className="flex items-baseline justify-between flex-shrink-0">
              <span className="text-sm font-semibold text-text">현재 상태</span>
              <span className="text-[11px] text-text-muted">
                대상 {targets.length}대 · 비가동 <span className={downTargets.length ? 'text-red-500 font-semibold' : ''}>{downTargets.length}</span>대
              </span>
            </div>

            {/* 대상 설비 목록 */}
            <div className="border border-border rounded overflow-hidden flex-shrink-0">
              <table className="w-full text-xs">
                <thead className="bg-surface text-text-muted">
                  <tr><th className="p-1.5 text-left font-medium">설비코드</th><th className="p-1.5 text-left font-medium">설비명</th><th className="p-1.5 text-left font-medium">유형</th><th className="p-1.5 text-center font-medium w-28">상태</th></tr>
                </thead>
                <tbody>
                  {targets.map((m) => {
                    const down = m.openDtSeq != null;
                    return (
                      <tr key={m.machineCode} className="border-t border-border">
                        <td className="p-1.5 font-mono">{m.machineCode}</td>
                        <td className="p-1.5">{m.machineName ?? '-'}</td>
                        <td className="p-1.5">{m.machineTypeName ?? m.machineType ?? '-'}</td>
                        <td className="p-1.5 text-center">
                          {down ? (
                            <span className="px-2 py-0.5 rounded bg-red-500 text-white">
                              <span className="font-mono tabular-nums"><ElapsedTime startAt={openStarts[m.machineCode] ?? null} skewMs={clockSkew} /></span>
                            </span>
                          ) : (
                            <span className="px-2 py-0.5 rounded bg-emerald-500 text-white">가동</span>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                  {!targets.length && (
                    <tr><td colSpan={4} className="p-6 text-center text-text-muted">
                      {scopeParams
                        ? (mode === 'LINE' ? '이 라인에 배정된 설비가 없습니다' : '설비를 찾을 수 없습니다')
                        : (mode === 'LINE' ? '라인을 선택하세요' : '설비를 선택하세요')}
                    </td></tr>
                  )}
                </tbody>
              </table>
            </div>

            {/* 비가동 사유 */}
            <div className="flex flex-col gap-1.5 border-t border-border pt-3">
              <span className="text-sm text-text-muted">
                비가동 사유 {willEnd && <span className="text-red-500">*</span>}
                <span className="text-[11px]"> {willEnd ? '(종료 시 필수 — 대상 전체에 기록)' : '(선택)'}</span>
              </span>
              <div className="grid grid-cols-2 gap-2">
                {reasons.map((r) => {
                  const active = reasonCode === r.code;
                  return (
                    <button key={r.code} type="button" onClick={() => setReasonCode(active ? '' : r.code)}
                      className={`px-2 py-2 rounded border text-xs text-center transition-colors ${active ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'}`}>
                      <span className="block font-medium leading-tight">{r.name}</span>
                      <span className={`block text-[10px] font-mono ${active ? 'text-white/80' : 'text-text-muted'}`}>{r.code}</span>
                    </button>
                  );
                })}
                {!reasons.length && <span className="col-span-2 text-xs text-text-muted py-2">연계된 비가동 사유가 없습니다</span>}
              </div>
            </div>

            {/* 처리 토글 */}
            <button onClick={apply} disabled={busy || !actionTargets.length}
              className={`w-full py-5 rounded text-sm font-semibold text-white flex items-center justify-center gap-2 disabled:bg-surface disabled:text-text-muted disabled:cursor-not-allowed ${
                willEnd ? 'bg-emerald-500 hover:bg-emerald-600' : 'bg-rose-500 hover:bg-rose-600'
              }`}>
              {willEnd ? <PlayCircle className="w-5 h-5" /> : <PauseCircle className="w-5 h-5" />}
              {actionTargets.length
                ? `${willEnd ? '가동 전환' : '비가동 시작'} · ${actionTargets.length}대`
                : (targets.length ? '처리할 설비가 없습니다' : '대상을 선택하세요')}
            </button>
            {mode === 'LINE' && !!actionTargets.length && (
              <p className="text-[11px] text-text-muted">라인 대상 설비 전체에 적용됩니다.</p>
            )}
          </CardContent>
        </Card>

        {/* 우 — 이전 30일 이력 */}
        <Card className="h-full overflow-hidden" padding="none">
          <CardContent className="h-full p-4 overflow-hidden flex flex-col gap-2">
            <div className="flex items-baseline justify-between flex-shrink-0">
              <span className="text-sm font-semibold text-text">이전 30일</span>
              <span className="text-[11px] text-text-muted">
                총 <span className="font-semibold text-text">{recent.totalCount}</span>회 ·
                <span className="font-semibold text-text"> {recent.totalMinutes.toLocaleString()}</span>분
              </span>
            </div>
            <div className="flex-1 min-h-0 overflow-auto border border-border rounded">
              <table className="w-full text-xs">
                <thead className="sticky top-0 bg-surface text-text-muted">
                  <tr><th className="p-1.5 text-left font-medium">설비</th><th className="p-1.5 text-left font-medium">시작</th><th className="p-1.5 text-left font-medium">종료</th><th className="p-1.5 text-right font-medium">소요</th></tr>
                </thead>
                <tbody>
                  {recent.list.map((d) => (
                    <tr key={d.dtSeq} className="border-t border-border">
                      <td className="p-1.5 font-mono">{d.machineCode}</td>
                      <td className="p-1.5 font-mono">{d.startTime ?? '-'}</td>
                      <td className="p-1.5 font-mono">{d.endTime ?? <span className="text-red-500">진행중</span>}</td>
                      <td className="p-1.5 text-right font-mono tabular-nums">{d.durationMin.toLocaleString()}분</td>
                    </tr>
                  ))}
                  {!recent.list.length && (
                    <tr><td colSpan={4} className="p-6 text-center text-text-muted">
                      {scopeParams ? '이전 30일 비가동 이력이 없습니다' : '대상을 선택하세요'}
                    </td></tr>
                  )}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
