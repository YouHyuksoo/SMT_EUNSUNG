'use client';

/**
 * @file (authenticated)/oee/equip-work-result/page.tsx
 * @description 설비별 작업 실적관리 — 작업지시별 실적 등록·조회 (Mock-up, 실 DB 미연결)
 *
 * 초보자 가이드:
 * 1. 좌측 75%: 작업지시 1건을 2줄 커스텀 그리드로 표시(9번째 셀=실적등록 버튼 셀병합)
 * 2. 설비코드 셀 배경 — 정지=빨강 / 가동=초록
 * 3. 우측 25%: 작업지시서·불량등록·설비비가동 액션 버튼(우측 슬라이드 패널)
 * 4. 실적등록/액션은 우측 슬라이드 패널에서 처리(목업)
 */
import { useMemo, useState } from 'react';
import { Search, Factory, FileText, AlertTriangle, PauseCircle } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent, Input } from '@/components/ui';

const CURRENT_USER = '관리자';

// 목업 회사 목록
const COMPANIES = [{ code: 'ES', name: '은성전장' }];

// 부적합(불량) 유형 — 자동차 하네스/전장부품 기준 (Mock, 10종)
const DEFECT_TYPES = [
  '납땜불량(냉납)', '미삽(부품 누락)', '오삽(오부착)', '극성 반대', '솔더 브릿지(단락)',
  '부품 들뜸(Tombstone)', '크림프 불량', '커넥터 체결불량', '피복 손상', '외관/이물',
];

// 정지(비가동) 사유코드 — 설비 비가동 사유코드에서 코드·사유명·사유구분을 가져옴 (Mock)
const STOP_REASONS = [
  { code: 'DWN-CHG', name: '모델 교체', type: '계획' },
  { code: 'DWN-MAT', name: '자재 대기', type: '비계획' },
  { code: 'DWN-BRK', name: '설비 고장', type: '비계획' },
  { code: 'DWN-CLN', name: '청소/5S', type: '계획' },
];

interface WorkResult {
  id: number;
  woNo: string;              // 작업지시 발행번호
  machineCode: string; machineName: string; machineRunning: boolean;
  lineCode: string; lineName: string;
  processCode: string; processName: string;
  shift: string;             // 교대조
  itemNo: string; revision: string; itemName: string;
  carModel: string; itemClass: string; unit: string;
  ctSec: number;             // 표준시간(C/T)
  planDate: string;
  planQty: number; resultQty: number; defectQty: number;
  done: boolean;             // 실적처리 완료 여부
  // 실적등록 입력값 (목업)
  workTime: number; breakTime: number; workers: number; workerName: string;
  updatedAt: string; updatedBy: string;
}

const SEED: WorkResult[] = [
  { id: 1, woNo: 'WO-2607-001', machineCode: 'E01', machineName: '마운터 B라인 1호기', machineRunning: true, lineCode: '02', lineName: 'B라인', processCode: 'W040', processName: '마운트', shift: '주간', itemNo: 'DN8-PE', revision: 'A', itemName: 'DN8 PE 컨트롤러', carModel: '아반떼', itemClass: '전장', unit: 'EA', ctSec: 12.5, planDate: '2026-07-27', planQty: 500, resultQty: 320, defectQty: 4, done: false, workTime: 0, breakTime: 0, workers: 0, workerName: '', updatedAt: '', updatedBy: '' },
  { id: 2, woNo: 'WO-2607-002', machineCode: 'E02', machineName: '스크린프린터 A라인', machineRunning: false, lineCode: '01', lineName: 'A라인', processCode: 'W020', processName: '인쇄', shift: '야간', itemNo: 'MV-PRA', revision: 'B', itemName: 'MV PRA 모듈', carModel: '쏘나타', itemClass: '전장', unit: 'EA', ctSec: 8.0, planDate: '2026-07-27', planQty: 300, resultQty: 300, defectQty: 2, done: true, workTime: 420, breakTime: 40, workers: 2, workerName: '김작업', updatedAt: '2026-07-27 18:20', updatedBy: '김작업' },
  { id: 3, woNo: 'WO-2607-003', machineCode: 'E03', machineName: 'AOI A라인', machineRunning: true, lineCode: '01', lineName: 'A라인', processCode: 'W060', processName: '검사', shift: '주간', itemNo: 'SM200', revision: 'A', itemName: 'SM200 센서보드', carModel: '그랜저', itemClass: '센서', unit: 'EA', ctSec: 15.0, planDate: '2026-07-26', planQty: 200, resultQty: 0, defectQty: 0, done: false, workTime: 0, breakTime: 0, workers: 0, workerName: '', updatedAt: '', updatedBy: '' },
  { id: 4, woNo: 'WO-2607-004', machineCode: 'E04', machineName: 'SPI A라인', machineRunning: true, lineCode: '01', lineName: 'A라인', processCode: 'W030', processName: 'SPI검사', shift: '주간', itemNo: 'N91H00', revision: 'C', itemName: 'N91 하네스', carModel: 'K5', itemClass: '하네스', unit: 'EA', ctSec: 6.5, planDate: '2026-07-27', planQty: 800, resultQty: 800, defectQty: 10, done: true, workTime: 450, breakTime: 30, workers: 3, workerName: '박세일', updatedAt: '2026-07-27 17:05', updatedBy: '박세일' },
  { id: 5, woNo: 'WO-2607-005', machineCode: 'E05', machineName: 'ICT 1호기', machineRunning: false, lineCode: '26', lineName: 'ICT라인', processCode: 'W090', processName: '기능검사', shift: '야간', itemNo: 'X9800', revision: 'A', itemName: 'X9800 인버터', carModel: '팰리세이드', itemClass: '전장', unit: 'EA', ctSec: 20.0, planDate: '2026-07-25', planQty: 150, resultQty: 60, defectQty: 1, done: false, workTime: 0, breakTime: 0, workers: 0, workerName: '', updatedAt: '', updatedBy: '' },
  { id: 6, woNo: 'WO-2607-006', machineCode: 'E01', machineName: '마운터 B라인 1호기', machineRunning: true, lineCode: '02', lineName: 'B라인', processCode: 'W040', processName: '마운트', shift: '주간', itemNo: 'DN8-PE', revision: 'A', itemName: 'DN8 PE 컨트롤러', carModel: '아반떼', itemClass: '전장', unit: 'EA', ctSec: 12.5, planDate: '2026-07-24', planQty: 450, resultQty: 450, defectQty: 3, done: true, workTime: 400, breakTime: 35, workers: 2, workerName: '이담당', updatedAt: '2026-07-24 19:40', updatedBy: '이담당' },
];

function nowStamp() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}
// datetime-local(초 포함) 값
function nowLocal() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}T${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}

interface DowntimeState {
  status: 'RUNNING' | 'STOPPED';   // 편집 중(미저장) 상태
  savedStatus: 'RUNNING' | 'STOPPED'; // 마지막 저장된 상태 — 토글 잠금 기준
  initialStatus: 'RUNNING' | 'STOPPED'; // 팝업 최초 구성 시점 상태 — '현재 상태' 표기용(토글/저장에도 불변)
  stopAt: string; stopReasonCode: string; stopMemo: string; stopWorker: string; stopBy: string;
  resumeAt: string; resumeBy: string;
}

type PanelMode = 'result' | 'workorder' | 'defect' | 'downtime';

interface ResultForm { resultQty: number; workTime: number; breakTime: number; workers: number; workerName: string; done: boolean; }

/** 셀: 라벨 + 값 */
function Cell({ label, children, className = '' }: { label: string; children: React.ReactNode; className?: string }) {
  return (
    <div className={`px-2 py-1 border-r border-b border-border min-w-0 ${className}`}>
      <div className="text-[10px] text-text-muted leading-tight truncate">{label}</div>
      <div className="text-xs text-text font-medium leading-tight truncate">{children}</div>
    </div>
  );
}

export default function EquipWorkResultPage() {
  const [records, setRecords] = useState<WorkResult[]>(SEED);
  const [company, setCompany] = useState('ES');
  const [equipSearch, setEquipSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<'ALL' | 'DONE' | 'PENDING'>('ALL');
  const [selectedId, setSelectedId] = useState<number | null>(null);
  const [panelMode, setPanelMode] = useState<PanelMode | null>(null);
  const [panelId, setPanelId] = useState<number | null>(null);
  const [form, setForm] = useState<ResultForm | null>(null);
  const [defectRows, setDefectRows] = useState<{ name: string; qty: number; remark: string }[]>([]);
  const [downtime, setDowntime] = useState<DowntimeState | null>(null);

  const filtered = useMemo(() => {
    const q = equipSearch.trim().toLowerCase();
    return records.filter((r) => {
      if (statusFilter === 'DONE' && !r.done) return false;
      if (statusFilter === 'PENDING' && r.done) return false;
      if (q && !(`${r.machineCode} ${r.machineName}`.toLowerCase().includes(q))) return false;
      return true;
    });
  }, [records, equipSearch, statusFilter]);

  const panelRec = useMemo(() => records.find((r) => r.id === panelId) ?? null, [records, panelId]);
  // 토글 표시 규칙: 미전환이면 '선택 가능한 반대 상태'를, 전환됨(미저장)이면 '선택한 현재 상태'를 그대로 표시
  const dtToggled = !!downtime && downtime.status !== downtime.savedStatus;
  const dtLabelStop = downtime ? (dtToggled ? downtime.status === 'STOPPED' : downtime.status === 'RUNNING') : false;

  function openResult(r: WorkResult) {
    setSelectedId(r.id);
    setPanelId(r.id);
    setPanelMode('result');
    setForm({ resultQty: r.resultQty, workTime: r.workTime, breakTime: r.breakTime, workers: r.workers, workerName: r.workerName, done: r.done });
  }
  function openAction(mode: PanelMode) {
    if (selectedId == null) { toast('작업지시 행을 먼저 선택하세요'); return; }
    setPanelId(selectedId);
    setPanelMode(mode);
    if (mode === 'defect') setDefectRows(DEFECT_TYPES.map((name) => ({ name, qty: 0, remark: '' })));
    if (mode === 'downtime') {
      const rec = records.find((r) => r.id === selectedId);
      const running = rec?.machineRunning ?? true;
      setDowntime({
        status: running ? 'RUNNING' : 'STOPPED', savedStatus: running ? 'RUNNING' : 'STOPPED',
        initialStatus: running ? 'RUNNING' : 'STOPPED',
        stopAt: running ? '' : nowLocal(), stopReasonCode: '', stopMemo: '', stopWorker: '',
        stopBy: running ? '' : CURRENT_USER, resumeAt: '', resumeBy: '',
      });
    }
  }
  function toggleDowntime() {
    setDowntime((d) => {
      if (!d) return d;
      if (d.status !== d.savedStatus) return d; // 이미 전환됨 — 저장 전까지 최초 토글값 유지(잠금)
      return d.status === 'RUNNING'
        ? { ...d, status: 'STOPPED', stopAt: nowLocal(), stopBy: CURRENT_USER, resumeAt: '', resumeBy: '' }
        : { ...d, status: 'RUNNING', resumeAt: nowLocal(), resumeBy: CURRENT_USER };
    });
  }
  function saveDowntime() {
    if (!panelRec || !downtime) return;
    setRecords((prev) => prev.map((r) => (r.id === panelRec.id ? { ...r, machineRunning: downtime.status === 'RUNNING' } : r)));
    setDowntime({ ...downtime, savedStatus: downtime.status });
    toast.success('설비 가동상태가 저장되었습니다');
  }
  function closePanel() { setPanelMode(null); setPanelId(null); setForm(null); }

  function saveResult() {
    if (!panelRec || !form) return;
    const stamp = nowStamp();
    setRecords((prev) => prev.map((r) => r.id === panelRec.id ? {
      ...r, resultQty: form.resultQty, workTime: form.workTime, breakTime: form.breakTime,
      workers: form.workers, workerName: form.workerName, done: form.done,
      updatedAt: stamp, updatedBy: CURRENT_USER,
    } : r));
    toast.success('실적이 저장되었습니다');
    closePanel();
  }

  return (
    <div className="flex h-full overflow-hidden">
      <div className="flex-1 min-w-0 flex flex-col overflow-hidden p-6 gap-4">
        {/* 헤더 + 조회조건 */}
        <div className="flex items-center justify-between flex-shrink-0 gap-4 flex-wrap">
          <div>
            <h1 className="text-xl font-bold text-text flex items-center gap-2"><Factory className="w-6 h-6 text-primary" /> 설비별 작업 실적관리</h1>
            <p className="text-sm text-text-muted mt-1">작업지시별 설비 가동상태 · 계획/실적 조회 및 실적 등록 (Mock-up)</p>
          </div>
          <div className="flex items-end gap-2 flex-wrap">
            <label className="text-xs text-text-muted flex flex-col gap-1">회사
              <select value={company} onChange={(e) => setCompany(e.target.value)} className="border border-border rounded p-2 bg-background text-text text-sm h-10">
                {COMPANIES.map((c) => <option key={c.code} value={c.code}>{c.name}</option>)}
              </select>
            </label>
            <label className="text-xs text-text-muted flex flex-col gap-1">설비(코드/명)
              <div className="w-56"><Input placeholder="설비코드 또는 설비명" value={equipSearch} onChange={(e) => setEquipSearch(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth /></div>
            </label>
            <label className="text-xs text-text-muted flex flex-col gap-1">처리상태
              <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value as 'ALL' | 'DONE' | 'PENDING')} className="border border-border rounded p-2 bg-background text-text text-sm h-10">
                <option value="ALL">전체</option>
                <option value="DONE">처리</option>
                <option value="PENDING">미처리</option>
              </select>
            </label>
          </div>
        </div>

        {/* 본문: 좌 75% 그리드 / 우 25% 액션 */}
        <div className="flex-1 min-h-0 flex gap-4 overflow-hidden">
          {/* 좌측 75% — 작업지시 2줄 커스텀 그리드 */}
          <Card className="flex-[3] min-w-0 overflow-hidden" padding="none">
            <CardContent className="h-full p-3 overflow-auto">
              <div className="flex flex-col gap-2">
                {filtered.map((r) => {
                  const selected = selectedId === r.id;
                  return (
                    <div key={r.id} onClick={() => setSelectedId(r.id)}
                      className={`border rounded overflow-hidden cursor-pointer ${selected ? 'border-primary ring-1 ring-primary' : 'border-border'}`}>
                      <div className="grid" style={{ gridTemplateColumns: 'repeat(8, minmax(0,1fr)) 96px', gridTemplateRows: 'auto auto' }}>
                        {/* 실적등록 버튼 — 9번째 셀, 2줄 병합 */}
                        <div style={{ gridColumn: 9, gridRow: '1 / 3' }} className="flex items-center justify-center border-l border-border p-1">
                          <button
                            onClick={(e) => { e.stopPropagation(); openResult(r); }}
                            className={`w-full h-full rounded text-xs font-semibold ${r.done ? 'bg-blue-600 text-white' : 'border border-primary text-primary hover:bg-surface'}`}>
                            {r.done ? '완료' : '실적등록'}
                          </button>
                        </div>
                        {/* 1줄 */}
                        <Cell label="작업지시번호"><span className="font-mono">{r.woNo}</span></Cell>
                        <div className={`px-2 py-1 border-r border-b border-border min-w-0 ${r.machineRunning ? 'bg-emerald-500 text-white' : 'bg-red-500 text-white'}`}>
                          <div className="text-[10px] leading-tight truncate opacity-90">설비 {r.machineRunning ? '(가동)' : '(정지)'}</div>
                          <div className="text-xs font-semibold leading-tight truncate">{r.machineCode} · {r.machineName}</div>
                        </div>
                        <Cell label="라인">{r.lineCode} · {r.lineName}</Cell>
                        <Cell label="공정">{r.processCode} · {r.processName}</Cell>
                        <Cell label="교대조">{r.shift}</Cell>
                        <Cell label="품번 | 리비전"><span className="font-mono">{r.itemNo} | {r.revision}</span></Cell>
                        <Cell label="품명">{r.itemName}</Cell>
                        <Cell label="계획일"><span className="font-mono">{r.planDate}</span></Cell>
                        {/* 2줄 */}
                        <Cell label="차종">{r.carModel}</Cell>
                        <Cell label="품목분류">{r.itemClass}</Cell>
                        <Cell label="단위">{r.unit}</Cell>
                        <Cell label="표준시간(C/T)"><span className="font-mono">{r.ctSec.toFixed(1)}s</span></Cell>
                        <div className="px-2 py-1 border-r border-b border-border min-w-0" style={{ gridColumn: '5 / 9' }}>
                          <div className="text-[10px] text-text-muted leading-tight">계획수량 / 실적수량 / 부적합수량</div>
                          <div className="text-xs font-medium leading-tight font-mono">
                            {r.planQty.toLocaleString()} / <span className="text-primary">{r.resultQty.toLocaleString()}</span> / <span className="text-red-500">{r.defectQty.toLocaleString()}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  );
                })}
                {!filtered.length && <div className="p-8 text-center text-text-muted text-sm">조회 결과가 없습니다</div>}
              </div>
            </CardContent>
          </Card>

          {/* 우측 25% — 액션 박스 버튼 */}
          <div className="flex-1 min-w-[180px] flex flex-col gap-3">
            {[
              { mode: 'workorder' as const, label: '작업지시서', icon: FileText, color: 'text-sky-600' },
              { mode: 'defect' as const, label: '불량 등록', icon: AlertTriangle, color: 'text-amber-600' },
              { mode: 'downtime' as const, label: '설비비가동', icon: PauseCircle, color: 'text-rose-600' },
            ].map((b) => (
              <button key={b.mode} onClick={() => openAction(b.mode)}
                className="flex flex-col items-center justify-center gap-2 border border-border rounded-lg bg-surface hover:bg-background hover:border-primary transition-colors py-6">
                <b.icon className={`w-8 h-8 ${b.color}`} />
                <span className="text-sm font-semibold text-text">{b.label}</span>
              </button>
            ))}
            <p className="text-[11px] text-text-muted mt-1 px-1">좌측 작업지시 행을 선택한 뒤 버튼을 누르세요.</p>
          </div>
        </div>
      </div>

      {/* 우측 슬라이드 패널 — 컨텍스트별 */}
      {panelMode && panelRec && (
        <div className="w-[520px] flex-shrink-0 border-l border-border bg-background flex flex-col h-full overflow-hidden shadow-2xl animate-slide-in-right">
          <div className="px-5 py-3 border-b border-border flex items-center justify-between flex-shrink-0">
            <h2 className="text-sm font-bold text-text">
              {panelMode === 'result' && '실적 등록'}
              {panelMode === 'workorder' && '작업지시서'}
              {panelMode === 'defect' && '불량 등록'}
              {panelMode === 'downtime' && '설비비가동'}
              <span className="ml-2 font-mono text-text-muted text-xs">{panelRec.woNo}</span>
            </h2>
            <div className="flex items-center gap-2">
              {(panelMode === 'result' || panelMode === 'downtime') && <button onClick={closePanel} className="px-3 py-2 rounded border border-border text-text-muted text-sm">취소</button>}
              {panelMode === 'result'
                ? <button onClick={saveResult} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
                : panelMode === 'downtime'
                  ? <button onClick={saveDowntime} className="px-4 py-2 rounded bg-primary text-white text-sm">저장</button>
                  : <button onClick={closePanel} className="px-4 py-2 rounded border border-border text-text-muted text-sm">닫기</button>}
            </div>
          </div>
          <div className="flex-1 min-h-0 overflow-y-auto px-5 py-4 space-y-4">
            {/* 공통: 작업지시 헤더 정보 (읽기전용) — 실적등록·작업지시서만 */}
            {(panelMode === 'result' || panelMode === 'workorder') && (
            <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
              {[
                ['설비', `${panelRec.machineCode} · ${panelRec.machineName}`],
                ['라인', `${panelRec.lineCode} · ${panelRec.lineName}`],
                ['공정', `${panelRec.processCode} · ${panelRec.processName}`],
                ['교대조', panelRec.shift],
                ['품번 | 리비전', `${panelRec.itemNo} | ${panelRec.revision}`],
                ['품명', panelRec.itemName],
                ['차종', panelRec.carModel],
                ['품목분류', panelRec.itemClass],
                ['단위', panelRec.unit],
                ['표준시간(C/T)', `${panelRec.ctSec.toFixed(1)}s`],
                ['계획일', panelRec.planDate],
                ['계획수량', panelRec.planQty.toLocaleString()],
                ['부적합수량', panelRec.defectQty.toLocaleString()],
              ].map(([k, v]) => (
                <div key={k} className="flex flex-col">
                  <span className="text-[11px] text-text-muted">{k}</span>
                  <span className="text-text">{v}</span>
                </div>
              ))}
            </div>
            )}

            {/* 실적등록 입력 */}
            {panelMode === 'result' && form && (
              <div className="border-t border-border pt-4 space-y-3">
                <div className="grid grid-cols-2 gap-3">
                  <label className="text-sm text-text-muted flex flex-col gap-1"><span>실적수량 <span className="text-red-500">*</span></span>
                    <input type="number" min="0" value={form.resultQty} onChange={(e) => setForm({ ...form, resultQty: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1">작업시간(분)
                    <input type="number" min="0" value={form.workTime} onChange={(e) => setForm({ ...form, workTime: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1">비작업시간(휴식, 분)
                    <input type="number" min="0" value={form.breakTime} onChange={(e) => setForm({ ...form, breakTime: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1">투입인원
                    <input type="number" min="0" value={form.workers} onChange={(e) => setForm({ ...form, workers: Number(e.target.value) })} className="border border-border rounded p-2 bg-background text-text text-right font-mono" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1 col-span-2">작업자
                    <input value={form.workerName} onChange={(e) => setForm({ ...form, workerName: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1 col-span-2">처리구분
                    <select value={form.done ? 'DONE' : 'PENDING'} onChange={(e) => setForm({ ...form, done: e.target.value === 'DONE' })} className="border border-border rounded p-2 bg-background text-text">
                      <option value="PENDING">미완료</option>
                      <option value="DONE">완료</option>
                    </select>
                  </label>
                </div>
                <div className="flex gap-6 text-sm text-text-muted border-t border-border pt-3">
                  <span>최종수정일 <b className="text-text">{panelRec.updatedAt || '저장 시 자동'}</b></span>
                  <span>최종수정자 <b className="text-text">{panelRec.updatedBy || CURRENT_USER}</b></span>
                </div>
              </div>
            )}

            {/* 작업지시서 (목업 문서 뷰) */}
            {panelMode === 'workorder' && (
              <div className="border-t border-border pt-4 text-sm text-text-muted">
                <p>작업지시서 상세 문서 (Mock-up). 상단 헤더 정보가 작업지시 내용입니다.</p>
                <div className="mt-2 flex flex-col gap-1">
                  <span>발행번호 <b className="text-text font-mono">{panelRec.woNo}</b></span>
                  <span>계획수량 <b className="text-text">{panelRec.planQty.toLocaleString()} {panelRec.unit}</b> · 계획일 <b className="text-text">{panelRec.planDate}</b></span>
                </div>
              </div>
            )}

            {/* 불량 등록 (목업) — 전용 헤더 + 부적합 유형 리스트 */}
            {panelMode === 'defect' && (
              <div className="space-y-4">
                {/* 최상단 헤더 (읽기전용) */}
                <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
                  {[
                    ['작업지시번호', panelRec.woNo],
                    ['설비코드', panelRec.machineCode],
                    ['설비명', panelRec.machineName],
                    ['라인코드', panelRec.lineCode],
                    ['라인명', panelRec.lineName],
                    ['공정명', panelRec.processName],
                    ['품번', panelRec.itemNo],
                    ['품명', panelRec.itemName],
                  ].map(([k, v]) => (
                    <div key={k} className="flex flex-col">
                      <span className="text-[11px] text-text-muted">{k}</span>
                      <span className="text-text">{v}</span>
                    </div>
                  ))}
                </div>

                {/* 부적합 유형별 발생수량·비고 (1열 세로) */}
                <div className="border-t border-border pt-4">
                  <span className="text-sm font-semibold text-text">부적합 유형별 발생 등록</span>
                  <div className="flex flex-col gap-2 mt-2">
                    {defectRows.map((d, i) => (
                      <div key={d.name} className="border border-border rounded p-2 flex items-center gap-2">
                        <div className="w-36 flex-shrink-0 text-sm font-medium text-text truncate" title={d.name}>{d.name}</div>
                        <label className="text-[11px] text-text-muted flex flex-col gap-0.5">발생수량
                          <input type="number" min="0" value={d.qty}
                            onChange={(e) => setDefectRows((prev) => prev.map((x, j) => j === i ? { ...x, qty: Number(e.target.value) } : x))}
                            className="w-20 border border-border rounded p-1.5 bg-background text-text text-right font-mono" />
                        </label>
                        <label className="text-[11px] text-text-muted flex flex-col gap-0.5 flex-1 min-w-0">비고
                          <input value={d.remark}
                            onChange={(e) => setDefectRows((prev) => prev.map((x, j) => j === i ? { ...x, remark: e.target.value } : x))}
                            className="w-full border border-border rounded p-1.5 bg-background text-text" />
                        </label>
                      </div>
                    ))}
                  </div>
                  <p className="text-[11px] text-text-muted mt-2">부적합 유형은 자동차 하네스/전장부품 기준 예시입니다 (Mock-up).</p>
                </div>
              </div>
            )}

            {/* 설비비가동 (목업) — 상태 토글 + 정지사유/작업자/처리담당자 */}
            {panelMode === 'downtime' && downtime && (
              <div className="space-y-4">
                {/* 설비코드/설비명/라인코드/라인명 */}
                <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">설비코드</span><span className="text-text font-mono">{panelRec.machineCode}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">설비명</span><span className="text-text">{panelRec.machineName}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">라인코드</span><span className="text-text font-mono">{panelRec.lineCode}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">라인명</span><span className="text-text">{panelRec.lineName}</span></div>
                </div>

                {/* 상태 토글 (큰 버튼) — 현재 상태의 반대(선택 가능한) 상태를 표시 */}
                <div>
                  <span className="text-sm font-semibold text-text">설비 가동 상태</span>
                  <div className="text-xs text-text-muted mt-1">현재 상태: <b className={downtime.initialStatus === 'RUNNING' ? 'text-emerald-600' : 'text-red-600'}>{downtime.initialStatus === 'RUNNING' ? '정상가동' : '정지(비가동)'}</b>{dtToggled && <span className="text-amber-600"> · 전환 대기(미저장)</span>}</div>
                  <button onClick={toggleDowntime} disabled={dtToggled}
                    className={`w-full mt-2 py-5 rounded-lg text-lg font-bold text-white ${dtLabelStop ? 'bg-red-500 hover:bg-red-600' : 'bg-emerald-500 hover:bg-emerald-600'} ${dtToggled ? 'opacity-60 cursor-not-allowed' : ''}`}>
                    {dtLabelStop ? '■ 정지' : '● 정상'}
                    <span className="block text-xs font-normal opacity-90 mt-1">{dtToggled ? '선택된 상태 · 저장 전까지 유지' : (downtime.status === 'RUNNING' ? '클릭하면 비가동 시작 · 시작일시 기록' : '클릭하면 비가동 종료 · 종료일시 기록')}</span>
                  </button>
                  {dtToggled && <p className="text-[11px] text-amber-600 mt-1">전환 값은 저장 전까지 유지됩니다. 저장하면 상태를 다시 전환할 수 있습니다.</p>}
                </div>

                {/* 시작일시 + 처리담당자(정지) — 정지 이력 (정상 전환 후에도 유지) */}
                {downtime.stopAt && (
                  <div className="border border-red-300 rounded p-3 space-y-2 bg-red-500/5">
                    <label className="text-sm text-text-muted flex flex-col gap-1">시작일시 (비가동 시작)
                      <input type="datetime-local" step={1} value={downtime.stopAt} onChange={(e) => setDowntime({ ...downtime, stopAt: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
                    </label>
                    <div className="text-sm text-text-muted">처리담당자(정지) <b className="text-text">{downtime.stopBy || CURRENT_USER}</b> (자동)</div>
                  </div>
                )}

                {/* 정지 상태 입력: 정지사유 그리드 + 상세 + 작업자 */}
                {downtime.status === 'STOPPED' && (
                  <div className="space-y-3">
                    <div className="flex flex-col gap-1">
                      <span className="text-sm text-text-muted">정지 사유 <span className="text-red-500">*</span></span>
                      <div className="border border-border rounded overflow-hidden bg-background">
                        <div className="flex bg-surface text-text-muted text-xs font-semibold">
                          <div className="flex-1 p-2">비가동 사유</div>
                          <div className="w-24 p-2 text-center">사유구분</div>
                          <div className="w-20 p-2 text-center">선택</div>
                        </div>
                        {STOP_REASONS.map((r) => {
                          const sel = downtime.stopReasonCode === r.code;
                          return (
                            <div key={r.code} className={`flex items-center text-sm border-t border-border ${sel ? 'ring-2 ring-inset ring-primary bg-primary/10' : ''}`}>
                              <div className="flex-1 p-2"><span className="font-mono">{r.code}</span> · {r.name}</div>
                              <div className="w-24 p-2 text-center">{r.type}</div>
                              <div className="w-20 p-2 text-center">
                                <button onClick={() => setDowntime({ ...downtime, stopReasonCode: r.code })}
                                  className={`px-2 py-0.5 rounded text-xs ${sel ? 'bg-primary text-white' : 'border border-primary text-primary hover:bg-surface'}`}>
                                  {sel ? '선택됨' : '선택'}
                                </button>
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                    <label className="text-sm text-text-muted flex flex-col gap-1">비가동 사유(상세)
                      <textarea rows={2} value={downtime.stopMemo} onChange={(e) => setDowntime({ ...downtime, stopMemo: e.target.value })} className="border border-border rounded p-2 bg-background text-text resize-none" />
                    </label>
                    <label className="text-sm text-text-muted flex flex-col gap-1">작업자
                      <input value={downtime.stopWorker} onChange={(e) => setDowntime({ ...downtime, stopWorker: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
                    </label>
                  </div>
                )}

                {/* 종료일시 + 처리담당자(정상전환) — 정상 클릭 시점 (정지 이력과 함께 표시) */}
                {downtime.resumeAt && (
                  <div className="border border-emerald-300 rounded p-3 space-y-2 bg-emerald-500/5">
                    <label className="text-sm text-text-muted flex flex-col gap-1">종료일시 (비가동 종료)
                      <input type="datetime-local" step={1} value={downtime.resumeAt} onChange={(e) => setDowntime({ ...downtime, resumeAt: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
                    </label>
                    <div className="text-sm text-text-muted">처리담당자(정상전환) <b className="text-text">{downtime.resumeBy || CURRENT_USER}</b> (자동)</div>
                  </div>
                )}

                <p className="text-[11px] text-text-muted">정지 클릭 시 시작일시, 정상 클릭 시 종료일시와 처리담당자가 자동 기록됩니다 (Mock-up).</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
