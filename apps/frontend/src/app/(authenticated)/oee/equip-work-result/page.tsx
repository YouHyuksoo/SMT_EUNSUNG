'use client';

/**
 * @file (authenticated)/oee/equip-work-result/page.tsx
 * @description 설비별 작업 실적관리 — IP_PRODUCT_RUN_CARD 기준 실적/불량/설비비가동 실 DB 연결
 *
 * API(글로벌 prefix /api → 백엔드 /api/v1) : /oee/work-result
 *   목록 GET ?fromDate&toDate&lineCode&keyword · 실적이력 GET /results?runNo
 *   실적상세 GET /results/:runNo/:seqNo · 실적 POST/PUT /results
 *   부적합유형 GET /bad-reasons(WQC) · 후공정설비 GET /machines · 비가동사유 GET /downtime-reasons
 *   비가동 GET /downtimes?runNo · POST/PUT /downtimes
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { Search, Factory, FileText, AlertTriangle, PauseCircle, RefreshCw, Plus } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent, Input } from '@/components/ui';
import { ProdLineSelect } from '@/components/shared';
import api from '@/services/api';

function todayStr() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}
function nowMinute() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}

interface RunRow {
  runNo: string; machineCode: string | null; machineName: string | null;
  workstageCode: string | null; workstageName: string | null; workstageGroup: string | null;
  runDate: string; lineCode: string | null; shiftCode: string | null;
  itemCode: string | null; revision: string | null; modelName: string | null;
  unit: string | null; itemClass: string | null; carModel: string | null;
  ct: number | null; planQty: number | null; resultQty: number; defectQty: number; openDowntime: number;
  resultCount: number; wipCount: number;
}
interface ResultRow { seqNo: string; machineCode: string; workstageCode: string; resultQty: number; workTime: number; workerCount: number; workerName: string; resultStatus: string; itemCode: string; modelName: string; defectQty: number; updatedAt: string; }
interface Machine { machineCode: string; machineName: string; workstageCode: string; workstageName: string; lineCode: string; }
interface Code { code: string; name: string; }
interface DowntimeRow { dtSeq: number; machineCode: string; workstageCode: string | null; reasonCode: string | null; reasonName: string | null; startTime: string | null; endTime: string | null; memo: string | null; worker: string | null; }

interface ResultForm { seqNo: string | null; machineCode: string; machineName: string; workstageCode: string; workstageName: string; resultQty: number; workTime: number; workerCount: number; workerName: string; resultStatus: 'WIP' | 'DONE'; savedStatus: 'WIP' | 'DONE'; }

type PanelMode = 'result' | 'defect' | 'downtime';

/** 목록 셀 */
function Cell({ label, children, className = '', style }: { label: string; children: React.ReactNode; className?: string; style?: React.CSSProperties }) {
  return (
    <div className={`px-2 py-1 border-r border-b border-border min-w-0 ${className}`} style={style}>
      <div className="text-[10px] text-text-muted leading-tight truncate">{label}</div>
      <div className="text-xs text-text font-medium leading-tight truncate">{children}</div>
    </div>
  );
}

/** 설비 검색 콤보 (native input + 필터 리스트) */
function MachineCombo({ machines, value, onSelect, disabled }: { machines: Machine[]; value: string; onSelect: (m: Machine) => void; disabled?: boolean }) {
  const [q, setQ] = useState('');
  const [open, setOpen] = useState(false);
  const list = useMemo(() => {
    const s = q.trim().toLowerCase();
    return (s ? machines.filter((m) => `${m.machineCode} ${m.machineName}`.toLowerCase().includes(s)) : machines).slice(0, 100);
  }, [machines, q]);
  const sel = machines.find((m) => m.machineCode === value);
  return (
    <div className="relative">
      <button type="button" disabled={disabled} onClick={() => setOpen((o) => !o)}
        className="w-full border border-border rounded p-2 bg-background text-text text-left text-sm disabled:opacity-50 disabled:bg-surface flex justify-between items-center">
        <span className={sel ? '' : 'text-text-muted'}>{sel ? `${sel.machineCode} · ${sel.machineName}` : '설비선택 (후공정)'}</span>
        <Search className="w-4 h-4 text-text-muted" />
      </button>
      {open && !disabled && (
        <div className="absolute z-20 mt-1 w-full bg-background border border-border rounded shadow-lg max-h-64 overflow-auto">
          <div className="p-1 sticky top-0 bg-background border-b border-border">
            <Input placeholder="설비코드/명 검색" value={q} onChange={(e) => setQ(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth />
          </div>
          {list.map((m) => (
            <button key={m.machineCode} type="button" onClick={() => { onSelect(m); setOpen(false); setQ(''); }}
              className="w-full text-left px-3 py-1.5 text-sm hover:bg-surface border-b border-border last:border-0">
              <span className="font-mono">{m.machineCode}</span> · {m.machineName}
              <span className="text-text-muted text-xs"> ({m.workstageCode} {m.workstageName})</span>
            </button>
          ))}
          {!list.length && <div className="p-3 text-center text-text-muted text-xs">설비 없음</div>}
        </div>
      )}
    </div>
  );
}

export default function EquipWorkResultPage() {
  const [fromDate, setFromDate] = useState(todayStr());
  const [toDate, setToDate] = useState(todayStr());
  const [lineCode, setLineCode] = useState('');
  const [keyword, setKeyword] = useState('');
  const [rows, setRows] = useState<RunRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedRun, setSelectedRun] = useState<string | null>(null);

  const [panelMode, setPanelMode] = useState<PanelMode | null>(null);
  const [panelRun, setPanelRun] = useState<RunRow | null>(null);

  // 공용 코드/콤보
  const [machines, setMachines] = useState<Machine[]>([]);
  const [badReasons, setBadReasons] = useState<Code[]>([]);

  // 실적 패널
  const [history, setHistory] = useState<ResultRow[]>([]);
  const [form, setForm] = useState<ResultForm | null>(null);

  // 불량 패널 (작업지시 단위 대표불량 단일)
  const [defect, setDefect] = useState<{ badCode: string; badQty: number; remark: string }>({ badCode: '', badQty: 0, remark: '' });

  // 비가동 패널
  const [downtimes, setDowntimes] = useState<DowntimeRow[]>([]);
  const [dtReasons, setDtReasons] = useState<Code[]>([]);
  const [dtForm, setDtForm] = useState<{ machineCode: string; machineName: string; workstageCode: string; reasonCode: string; memo: string; worker: string }>({ machineCode: '', machineName: '', workstageCode: '', reasonCode: '', memo: '', worker: '' });

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get('/oee/work-result', { params: { fromDate, toDate, lineCode: lineCode || undefined, keyword: keyword || undefined } });
      setRows(res.data?.data?.list ?? []);
    } catch { toast.error('작업지시 목록 조회에 실패했습니다'); }
    finally { setLoading(false); }
  }, [fromDate, toDate, lineCode, keyword]);
  useEffect(() => { load(); }, [load]);

  // 공용 콤보 최초 1회
  useEffect(() => {
    api.get('/oee/work-result/machines').then((r) => setMachines(r.data?.data?.list ?? [])).catch(() => {});
    api.get('/oee/work-result/bad-reasons').then((r) => setBadReasons(r.data?.data?.list ?? [])).catch(() => {});
  }, []);

  const canRegister = (r: RunRow) => !r.machineCode || r.workstageGroup === 'PBA';
  const statusClass = (r: RunRow) => !r.machineCode ? 'bg-slate-400 text-white' : r.openDowntime > 0 ? 'bg-red-500 text-white' : 'bg-emerald-500 text-white';
  const statusLabel = (r: RunRow) => !r.machineCode ? '(미배정)' : r.openDowntime > 0 ? '(정지)' : '(가동)';
  // 진행상태 색상(초기=테두리 / 진행중=노랑 / 완료=파랑) — 실적·불량 버튼 공통
  const btnStateCls = (r: RunRow) => r.resultCount === 0 ? 'border border-primary text-primary hover:bg-surface' : r.wipCount > 0 ? 'bg-amber-400 text-white hover:bg-amber-500' : 'bg-blue-600 text-white hover:bg-blue-700';

  // ---- 실적 패널 ----
  async function openResult(r: RunRow) {
    if (!canRegister(r)) { toast('후공정 대상이 아닙니다 (대상 제외)'); return; }
    setSelectedRun(r.runNo); setPanelRun(r); setPanelMode('result');
    setForm(null);
    try { const res = await api.get('/oee/work-result/results', { params: { runNo: r.runNo } }); setHistory(res.data?.data?.list ?? []); }
    catch { setHistory([]); }
  }
  function newResultForm(r: RunRow): ResultForm {
    return {
      seqNo: null,
      machineCode: r.machineCode ?? '', machineName: r.machineName ?? '',
      workstageCode: r.workstageCode ?? '', workstageName: r.workstageName ?? '',
      resultQty: 0, workTime: 0, workerCount: 0, workerName: '', resultStatus: 'WIP', savedStatus: 'WIP',
    };
  }
  async function selectHistory(row: ResultRow) {
    if (!panelRun) return;
    try {
      const res = await api.get(`/oee/work-result/results/${encodeURIComponent(panelRun.runNo)}/${row.seqNo}`);
      const h = res.data?.data?.header;
      const mc = machines.find((m) => m.machineCode === h.machineCode);
      setForm({
        seqNo: h.seqNo, machineCode: h.machineCode ?? '', machineName: mc?.machineName ?? '',
        workstageCode: h.workstageCode ?? '', workstageName: mc?.workstageName ?? '',
        resultQty: h.resultQty ?? 0, workTime: h.workTime ?? 0, workerCount: h.workerCount ?? 0,
        workerName: h.workerName ?? '', resultStatus: (h.resultStatus ?? 'WIP') as 'WIP' | 'DONE',
        savedStatus: (h.resultStatus ?? 'WIP') as 'WIP' | 'DONE',
      });
    } catch { toast.error('실적 상세 조회 실패'); }
  }
  // 이미 저장된 상태가 '완료'인 실적만 잠금(수정불가). 폼에서 방금 '완료'로 바꾼 값으로는 잠그지 않는다.
  const readOnly = form?.savedStatus === 'DONE';

  async function saveResult() {
    if (!form || !panelRun) return;
    if (!form.machineCode) return toast.error('설비를 선택하세요');
    if (!(form.resultQty >= 0)) return toast.error('실적수량을 입력하세요');
    const payload = { runNo: panelRun.runNo, seqNo: form.seqNo ?? undefined, machineCode: form.machineCode, workstageCode: form.workstageCode, resultQty: form.resultQty, workTime: form.workTime, workerCount: form.workerCount, workerName: form.workerName, resultStatus: form.resultStatus };
    try {
      if (form.seqNo) await api.put('/oee/work-result/results', payload);
      else await api.post('/oee/work-result/results', payload);
      toast.success('실적이 저장되었습니다');
      const res = await api.get('/oee/work-result/results', { params: { runNo: panelRun.runNo } });
      setHistory(res.data?.data?.list ?? []);
      setForm(null);
      await load();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '저장에 실패했습니다');
    }
  }

  // ---- 불량 패널 (작업지시 단위 대표불량 단일, 실적과 독립) ----
  async function openDefect(r: RunRow) {
    setSelectedRun(r.runNo); setPanelRun(r); setPanelMode('defect');
    setDefect({ badCode: '', badQty: 0, remark: '' });
    try {
      const res = await api.get('/oee/work-result/defect', { params: { runNo: r.runNo } });
      const d = res.data?.data?.defect;
      if (d) setDefect({ badCode: d.badCode ?? '', badQty: d.badQty ?? 0, remark: d.remark ?? '' });
    } catch { /* 없음 */ }
  }
  async function saveDefect() {
    if (!panelRun) return;
    if (!defect.badCode) return toast.error('대표 불량유형을 선택하세요');
    try {
      await api.post('/oee/work-result/defect', { runNo: panelRun.runNo, badCode: defect.badCode, badQty: defect.badQty, remark: defect.remark || undefined });
      toast.success('불량이 저장되었습니다');
      await load();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '불량 저장에 실패했습니다');
    }
  }

  // ---- 비가동 패널 ----
  async function openDowntimePanel(r: RunRow) {
    setSelectedRun(r.runNo); setPanelRun(r); setPanelMode('downtime');
    setDtForm({ machineCode: r.machineCode ?? '', machineName: r.machineName ?? '', workstageCode: r.workstageCode ?? '', reasonCode: '', memo: '', worker: '' });
    try { const res = await api.get('/oee/work-result/downtimes', { params: { runNo: r.runNo } }); setDowntimes(res.data?.data?.list ?? []); } catch { setDowntimes([]); }
    try { const res = await api.get('/oee/work-result/downtime-reasons', { params: { machineCode: r.machineCode || undefined } }); setDtReasons(res.data?.data?.list ?? []); } catch { setDtReasons([]); }
  }
  async function reloadDowntimes() {
    if (!panelRun) return;
    const res = await api.get('/oee/work-result/downtimes', { params: { runNo: panelRun.runNo } });
    setDowntimes(res.data?.data?.list ?? []);
    await load();
  }
  async function startDowntime() {
    if (!panelRun) return;
    if (!dtForm.machineCode) return toast.error('설비를 선택하세요');
    if (!dtForm.reasonCode) return toast.error('비가동 사유를 선택하세요');
    try {
      await api.post('/oee/work-result/downtimes', { runNo: panelRun.runNo, machineCode: dtForm.machineCode, workstageCode: dtForm.workstageCode || undefined, reasonCode: dtForm.reasonCode, memo: dtForm.memo || undefined, worker: dtForm.worker || undefined });
      toast.success('비가동 시작 등록');
      setDtForm({ ...dtForm, reasonCode: '', memo: '', worker: '' });
      await reloadDowntimes();
    } catch { toast.error('비가동 시작 실패'); }
  }
  async function endDowntime(dtSeq: number, machineCode: string) {
    if (!panelRun) return;
    try {
      await api.put('/oee/work-result/downtimes', { runNo: panelRun.runNo, dtSeq, machineCode, endTime: nowMinute() });
      toast.success('비가동 종료');
      await reloadDowntimes();
    } catch { toast.error('비가동 종료 실패'); }
  }

  function closePanel() { setPanelMode(null); setPanelRun(null); setForm(null); }

  return (
    <div className="flex h-full overflow-hidden">
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
        {/* 헤더 + 조회조건 */}
        <div className="flex items-start justify-between flex-shrink-0 gap-4 flex-wrap">
          <div>
            <h1 className="text-xl font-bold text-text flex items-center gap-2"><Factory className="w-6 h-6 text-primary" /> 설비별 작업 실적관리</h1>
            <p className="text-sm text-text-muted mt-1">작업지시(IP_PRODUCT_RUN_CARD) 기준 설비 가동상태 · 계획/실적 · 실적/불량/비가동 등록</p>
          </div>
          <div className="flex items-end gap-2 flex-wrap">
            <label className="text-xs text-text-muted flex flex-col gap-1">계획일(From)
              <input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} className="border border-border rounded p-2 bg-background text-text text-sm h-10" />
            </label>
            <label className="text-xs text-text-muted flex flex-col gap-1">계획일(To)
              <input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} className="border border-border rounded p-2 bg-background text-text text-sm h-10" />
            </label>
            <label className="text-xs text-text-muted flex flex-col gap-1 w-44">라인
              <ProdLineSelect value={lineCode} onChange={setLineCode} fullWidth />
            </label>
            <label className="text-xs text-text-muted flex flex-col gap-1">통합검색
              <div className="w-56"><Input placeholder="품번·품명·설비코드/명" value={keyword} onChange={(e) => setKeyword(e.target.value)} onKeyDown={(e) => e.key === 'Enter' && load()} leftIcon={<Search className="w-4 h-4" />} fullWidth /></div>
            </label>
            <button onClick={load} className="border border-border rounded px-3 h-10 text-text-muted hover:bg-surface flex items-center gap-1"><RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />조회</button>
          </div>
        </div>

        {/* 본문: 좌 목록 / 우 액션 */}
        <div className="flex-1 min-h-0 flex gap-4 overflow-hidden">
          <Card className="flex-[3] min-w-0 overflow-hidden" padding="none">
            <CardContent className="h-full p-3 overflow-auto">
              <div className="flex flex-col gap-2">
                {rows.map((r) => {
                  const selected = selectedRun === r.runNo;
                  const reg = canRegister(r);
                  return (
                    <div key={r.runNo} onClick={() => setSelectedRun(r.runNo)}
                      className={`border rounded overflow-hidden cursor-pointer ${selected ? 'border-primary ring-1 ring-primary' : 'border-border'}`}>
                      <div className="grid" style={{ gridTemplateColumns: 'minmax(0,0.7fr) minmax(0,0.7fr) minmax(0,0.6fr) minmax(0,1fr) minmax(0,1fr) minmax(0,1fr) minmax(0,1fr) minmax(0,1.2fr) 168px', gridTemplateRows: 'auto auto auto' }}>
                        {/* 실적등록 버튼 — 9번째 셀, 3줄 병합 */}
                        <div style={{ gridColumn: 9, gridRow: '1 / 4' }} className="flex items-center justify-center gap-1.5 border-l border-border p-1">
                          {reg ? (
                            <>
                              <button onClick={(e) => { e.stopPropagation(); openResult(r); }}
                                className={`flex-1 h-full rounded text-[11px] font-semibold flex flex-col items-center justify-center gap-0.5 ${btnStateCls(r)}`}>
                                <Factory className="w-4 h-4" />실적등록
                              </button>
                              <button onClick={(e) => { e.stopPropagation(); openDefect(r); }}
                                className={`flex-1 h-full rounded text-[11px] font-semibold flex flex-col items-center justify-center gap-0.5 ${btnStateCls(r)}`}>
                                <AlertTriangle className="w-4 h-4" />불량등록
                              </button>
                            </>
                          ) : (
                            <span className="w-full h-full rounded text-[11px] font-semibold text-text-muted bg-surface flex items-center justify-center text-center">대상<br/>제외</span>
                          )}
                        </div>
                        {/* 1줄: 작업지시번호, 라인, 설비, 공정, 계획일 */}
                        <Cell label="작업지시번호" style={{ gridColumn: '1 / 3' }}><span className="font-mono">{r.runNo}</span></Cell>
                        <Cell label="라인">{r.lineCode ?? '-'}</Cell>
                        <div className={`px-2 py-1 border-r border-b border-border min-w-0 ${statusClass(r)}`} style={{ gridColumn: '4 / 6' }}>
                          <div className="text-[10px] leading-tight truncate opacity-90">설비 {statusLabel(r)}</div>
                          <div className="text-xs font-semibold leading-tight truncate">{r.machineCode ? `${r.machineCode} · ${r.machineName ?? ''}` : '-'}</div>
                        </div>
                        <Cell label="공정" style={{ gridColumn: '6 / 8' }}>{r.workstageCode ? `${r.workstageCode} · ${r.workstageName ?? ''}` : '-'}</Cell>
                        <Cell label="계획일"><span className="font-mono">{r.runDate}</span></Cell>
                        {/* 2줄: 교대조, 품번/리비전, 품명, 품목분류 */}
                        <Cell label="교대조">{r.shiftCode ?? '-'}</Cell>
                        <Cell label="품번 | 리비전" style={{ gridColumn: '2 / 5' }}><span className="font-mono">{r.itemCode} | {r.revision}</span></Cell>
                        <Cell label="품명" style={{ gridColumn: '5 / 8' }}>{r.modelName}</Cell>
                        <Cell label="품목분류">{r.itemClass ?? '-'}</Cell>
                        {/* 3줄: 차종, 표준시간, 계획/실적/부적합, 단위 */}
                        <Cell label="차종" style={{ gridColumn: '1 / 3' }}>{r.carModel ?? '-'}</Cell>
                        <Cell label="표준시간(C/T)"><span className="font-mono">{r.ct != null ? `${r.ct}s` : '-'}</span></Cell>
                        <div className="px-2 py-1 border-r border-b border-border min-w-0" style={{ gridColumn: '4 / 8' }}>
                          <div className="text-[10px] text-text-muted leading-tight">계획수량 / 실적수량 / 부적합수량</div>
                          <div className="text-xs font-medium leading-tight font-mono">
                            {(r.planQty ?? 0).toLocaleString()} / <span className="text-primary">{r.resultQty.toLocaleString()}</span> / <span className="text-red-500">{r.defectQty.toLocaleString()}</span>
                          </div>
                        </div>
                        <Cell label="단위">{r.unit ?? '-'}</Cell>
                      </div>
                    </div>
                  );
                })}
                {loading && <div className="p-8 text-center text-text-muted text-sm">조회 중…</div>}
                {!loading && !rows.length && <div className="p-8 text-center text-text-muted text-sm">조회 결과가 없습니다 (계획일 범위를 확인하세요)</div>}
              </div>
            </CardContent>
          </Card>

          {/* 우측 액션 (가로폭 축소) */}
          <div className="w-[112px] flex-shrink-0 flex flex-col gap-3">
            <button disabled className="flex flex-col items-center justify-center gap-1.5 border border-border rounded-lg bg-surface py-5 opacity-50 cursor-not-allowed">
              <FileText className="w-7 h-7 text-sky-600" /><span className="text-xs font-semibold text-text text-center leading-tight">작업지시서<br/>상세보기</span><span className="text-[10px] text-text-muted">추후</span>
            </button>
            <button onClick={() => { const r = rows.find((x) => x.runNo === selectedRun); if (!r) return toast('작업지시를 먼저 선택하세요'); openDowntimePanel(r); }}
              className="flex flex-col items-center justify-center gap-1.5 border border-border rounded-lg bg-surface hover:bg-background hover:border-primary transition-colors py-5">
              <PauseCircle className="w-7 h-7 text-rose-600" /><span className="text-xs font-semibold text-text text-center leading-tight">설비<br/>비가동</span>
            </button>
            <p className="text-[11px] text-text-muted mt-1 px-1">실적·불량은 행의 버튼을 누르세요.</p>
          </div>
        </div>
      </div>

      {/* 실적 패널 */}
      {panelMode === 'result' && panelRun && (
        <div className="w-[560px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">실적등록 <span className="ml-2 font-mono text-text-muted text-xs">{panelRun.runNo}</span></h2>
            <button onClick={closePanel} className="px-3 py-2 rounded border border-border text-text-muted text-sm">닫기</button>
          </div>
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 실적 이력 그리드 */}
            <div>
              <div className="flex items-center justify-between mb-1">
                <span className="text-sm font-semibold text-text">실적 이력</span>
                <button onClick={() => setForm(newResultForm(panelRun))} className="text-xs border border-primary text-primary rounded px-2 py-1 hover:bg-surface flex items-center gap-1"><Plus className="w-3 h-3" />신규 실적</button>
              </div>
              <table className="w-full text-xs border border-border">
                <thead><tr className="bg-surface text-text-muted"><th className="p-1.5 text-center">일련</th><th className="p-1.5 text-left">품번/품명</th><th className="p-1.5 text-right">실적수량</th><th className="p-1.5 text-center">처리구분</th></tr></thead>
                <tbody>
                  {history.map((h) => (
                    <tr key={h.seqNo} onClick={() => selectHistory(h)} className={`border-t border-border cursor-pointer hover:bg-surface ${form?.seqNo === h.seqNo ? 'bg-primary/10' : ''}`}>
                      <td className="p-1.5 text-center font-mono">{h.seqNo}</td>
                      <td className="p-1.5"><span className="font-mono">{h.itemCode}</span> {h.modelName}</td>
                      <td className="p-1.5 text-right font-mono">{h.resultQty?.toLocaleString()}</td>
                      <td className="p-1.5 text-center">{h.resultStatus === 'DONE' ? <span className="text-blue-600 font-semibold">완료</span> : '진행'}</td>
                    </tr>
                  ))}
                  {!history.length && <tr><td colSpan={4} className="p-3 text-center text-text-muted">등록된 실적이 없습니다. [신규 실적]으로 등록하세요.</td></tr>}
                </tbody>
              </table>
            </div>

            {/* 실적 상세 입력 */}
            {form && (
              <div className="border-t border-border pt-4 space-y-3">
                <div className="flex items-center justify-between">
                  <span className="text-sm font-semibold text-text">{form.seqNo ? `실적 상세 (일련 ${form.seqNo})` : '신규 실적'}</span>
                  {!readOnly && <button onClick={saveResult} className="px-3 py-1.5 rounded bg-primary text-white text-sm">저장</button>}
                  {readOnly && <span className="text-xs text-blue-600 font-semibold">완료 · 수정불가</span>}
                </div>
                {/* 작업지시 기본 정보 (읽기전용, 설비/공정 제외) */}
                <div className="grid grid-cols-2 gap-x-4 gap-y-1.5 text-sm border border-border rounded p-3 bg-surface/40">
                  {([
                    ['라인', panelRun.lineCode ?? '-'],
                    ['교대조', panelRun.shiftCode ?? '-'],
                    ['품번 | 리비전', `${panelRun.itemCode ?? ''} | ${panelRun.revision ?? ''}`],
                    ['품명', panelRun.modelName ?? '-'],
                    ['차종', panelRun.carModel ?? '-'],
                    ['품목분류', panelRun.itemClass ?? '-'],
                    ['단위', panelRun.unit ?? '-'],
                    ['표준시간(C/T)', panelRun.ct != null ? `${panelRun.ct}s` : '-'],
                    ['계획일', panelRun.runDate],
                    ['계획수량', (panelRun.planQty ?? 0).toLocaleString()],
                  ] as [string, string][]).map(([k, v]) => (
                    <div key={k} className="flex flex-col">
                      <span className="text-[11px] text-text-muted">{k}</span>
                      <span className="text-text">{v}</span>
                    </div>
                  ))}
                </div>
                {/* 설비선택 → 공정 자동 */}
                <label className="text-sm text-text-muted flex flex-col gap-1"><span>설비선택 <span className="text-red-500">*</span></span>
                  <MachineCombo machines={machines} value={form.machineCode} disabled={readOnly}
                    onSelect={(m) => setForm({ ...form, machineCode: m.machineCode, machineName: m.machineName, workstageCode: m.workstageCode, workstageName: m.workstageName })} />
                </label>
                <div className="text-xs text-text-muted">공정: <b className="text-text">{form.workstageCode ? `${form.workstageCode} · ${form.workstageName}` : '-'}</b></div>
                <div className="grid grid-cols-2 gap-3">
                  <label className="text-sm text-text-muted flex flex-col gap-1"><span>실적수량 <span className="text-red-500">*</span></span>
                    <input type="number" min="0" value={form.resultQty} disabled={readOnly} onChange={(e) => setForm({ ...form, resultQty: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono disabled:opacity-50 disabled:bg-surface" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1">작업시간(분)
                    <input type="number" min="0" value={form.workTime} disabled={readOnly} onChange={(e) => setForm({ ...form, workTime: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono disabled:opacity-50 disabled:bg-surface" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1">투입인원
                    <input type="number" min="0" value={form.workerCount} disabled={readOnly} onChange={(e) => setForm({ ...form, workerCount: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono disabled:opacity-50 disabled:bg-surface" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1">처리구분
                    <select value={form.resultStatus} disabled={readOnly} onChange={(e) => setForm({ ...form, resultStatus: e.target.value as 'WIP' | 'DONE' })} className="border border-border rounded p-2 bg-background text-text disabled:opacity-50 disabled:bg-surface">
                      <option value="WIP">진행</option><option value="DONE">완료</option>
                    </select>
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1 col-span-2">작업자
                    <input value={form.workerName} disabled={readOnly} onChange={(e) => setForm({ ...form, workerName: e.target.value })} className="border border-border rounded p-2 bg-background text-text disabled:opacity-50 disabled:bg-surface" />
                  </label>
                </div>

              </div>
            )}
          </div>
        </div>
      )}

      {/* 불량 패널 (작업지시 단위 대표불량 단일, 실적과 독립) */}
      {panelMode === 'defect' && panelRun && (
        <div className="w-[560px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">불량등록 <span className="ml-2 font-mono text-text-muted text-xs">{panelRun.runNo}</span></h2>
            <div className="flex items-center gap-2">
              <button onClick={closePanel} className="px-3 py-2 rounded border border-border text-text-muted text-sm">닫기</button>
              <button onClick={saveDefect} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
            </div>
          </div>
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 작업지시 기본 정보 (읽기전용, 설비/공정 포함) */}
            <div className="grid grid-cols-2 gap-x-4 gap-y-1.5 text-sm border border-border rounded p-3 bg-surface/40">
              {([
                ['설비', panelRun.machineCode ? `${panelRun.machineCode} · ${panelRun.machineName ?? ''}` : '-'],
                ['공정', panelRun.workstageCode ? `${panelRun.workstageCode} · ${panelRun.workstageName ?? ''}` : '-'],
                ['라인', panelRun.lineCode ?? '-'],
                ['교대조', panelRun.shiftCode ?? '-'],
                ['품번 | 리비전', `${panelRun.itemCode ?? ''} | ${panelRun.revision ?? ''}`],
                ['품명', panelRun.modelName ?? '-'],
                ['차종', panelRun.carModel ?? '-'],
                ['품목분류', panelRun.itemClass ?? '-'],
                ['단위', panelRun.unit ?? '-'],
                ['표준시간(C/T)', panelRun.ct != null ? `${panelRun.ct}s` : '-'],
                ['계획일', panelRun.runDate],
                ['계획수량', (panelRun.planQty ?? 0).toLocaleString()],
                ['실적수량', panelRun.resultQty.toLocaleString()],
              ] as [string, string][]).map(([k, v]) => (
                <div key={k} className="flex flex-col">
                  <span className="text-[11px] text-text-muted">{k}</span>
                  <span className="text-text">{v}</span>
                </div>
              ))}
            </div>

            {/* 대표불량 단일 등록 */}
            <div className="border-t border-border pt-4 space-y-3">
              <span className="text-sm font-semibold text-text">대표 불량 (단일 등록)</span>
              <label className="text-sm text-text-muted flex flex-col gap-1"><span>대표 불량유형 (WQC) <span className="text-red-500">*</span></span>
                <select value={defect.badCode} onChange={(e) => setDefect({ ...defect, badCode: e.target.value })} className="border border-border rounded p-2 bg-background text-text">
                  <option value="">선택</option>
                  {badReasons.map((b) => <option key={b.code} value={b.code}>{b.code} · {b.name}</option>)}
                </select>
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1"><span>불량수량 <span className="text-red-500">*</span></span>
                <input type="number" min="0" value={defect.badQty} onChange={(e) => setDefect({ ...defect, badQty: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1">비고
                <textarea rows={2} value={defect.remark} onChange={(e) => setDefect({ ...defect, remark: e.target.value })} className="border border-border rounded p-2 bg-background text-text resize-none" />
              </label>
              <p className="text-[11px] text-text-muted">불량수량은 계획수량({(panelRun.planQty ?? 0).toLocaleString()}){panelRun.resultQty > 0 ? ` · 실적수량(${panelRun.resultQty.toLocaleString()})` : ''}을 초과할 수 없습니다. 실적과 무관하게 등록 가능합니다.</p>
            </div>
          </div>
        </div>
      )}

      {/* 설비비가동 패널 */}
      {panelMode === 'downtime' && panelRun && (
        <div className="w-[560px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">설비비가동 <span className="ml-2 font-mono text-text-muted text-xs">{panelRun.runNo}</span></h2>
            <button onClick={closePanel} className="px-3 py-2 rounded border border-border text-text-muted text-sm">닫기</button>
          </div>
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 설비: 기본 고정 or 선택 */}
            <div>
              <span className="text-sm font-semibold text-text">설비 {panelRun.machineCode ? '(작업지시 등록 설비)' : '(설비 선택)'}</span>
              {panelRun.machineCode ? (
                <div className="mt-1 border border-border rounded p-2 bg-surface text-sm"><span className="font-mono">{panelRun.machineCode}</span> · {panelRun.machineName} <span className="text-text-muted text-xs">({panelRun.workstageCode})</span></div>
              ) : (
                <div className="mt-1">
                  <MachineCombo machines={machines} value={dtForm.machineCode}
                    onSelect={(m) => { setDtForm({ ...dtForm, machineCode: m.machineCode, machineName: m.machineName, workstageCode: m.workstageCode }); api.get('/oee/work-result/downtime-reasons', { params: { machineCode: m.machineCode } }).then((r) => setDtReasons(r.data?.data?.list ?? [])).catch(() => {}); }} />
                </div>
              )}
            </div>

            {/* 비가동 이력 */}
            <div>
              <span className="text-sm font-semibold text-text">비가동 이력</span>
              <table className="w-full text-xs border border-border mt-1">
                <thead><tr className="bg-surface text-text-muted"><th className="p-1.5">사유</th><th className="p-1.5">시작</th><th className="p-1.5">종료</th><th className="p-1.5 text-center">처리</th></tr></thead>
                <tbody>
                  {downtimes.map((d) => (
                    <tr key={d.dtSeq} className="border-t border-border">
                      <td className="p-1.5">{d.reasonName ?? d.reasonCode ?? '-'}</td>
                      <td className="p-1.5 font-mono">{d.startTime ?? '-'}</td>
                      <td className="p-1.5 font-mono">{d.endTime ?? <span className="text-red-500">진행중</span>}</td>
                      <td className="p-1.5 text-center">{!d.endTime && <button onClick={() => endDowntime(d.dtSeq, d.machineCode)} className="px-2 py-0.5 rounded bg-emerald-500 text-white text-xs">종료</button>}</td>
                    </tr>
                  ))}
                  {!downtimes.length && <tr><td colSpan={4} className="p-3 text-center text-text-muted">비가동 이력이 없습니다</td></tr>}
                </tbody>
              </table>
            </div>

            {/* 비가동 시작 등록 */}
            <div className="border-t border-border pt-3 space-y-2">
              <span className="text-sm font-semibold text-text">비가동 시작 등록</span>
              <label className="text-sm text-text-muted flex flex-col gap-1"><span>비가동 사유 <span className="text-red-500">*</span></span>
                <select value={dtForm.reasonCode} onChange={(e) => setDtForm({ ...dtForm, reasonCode: e.target.value })} className="border border-border rounded p-2 bg-background text-text">
                  <option value="">선택</option>
                  {dtReasons.map((r) => <option key={r.code} value={r.code}>{r.code} · {r.name}</option>)}
                </select>
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1">메모
                <textarea rows={2} value={dtForm.memo} onChange={(e) => setDtForm({ ...dtForm, memo: e.target.value })} className="border border-border rounded p-2 bg-background text-text resize-none" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1">작업자
                <input value={dtForm.worker} onChange={(e) => setDtForm({ ...dtForm, worker: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
              </label>
              <button onClick={startDowntime} className="w-full py-2.5 rounded bg-rose-500 text-white text-sm font-semibold hover:bg-rose-600">비가동 시작 (현재시각)</button>
              <p className="text-[11px] text-text-muted">시작 시각은 현재시각으로 기록됩니다. 종료는 이력의 [종료] 버튼으로 처리합니다.</p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
