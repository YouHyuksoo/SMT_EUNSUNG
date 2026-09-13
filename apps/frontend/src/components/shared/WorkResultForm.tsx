'use client';

/**
 * @file components/shared/WorkResultForm.tsx
 * @description 작업 실적 등록 폼 — 실적 이력 그리드 + 상세 입력/저장을 담는다.
 *
 * 초보자 가이드:
 * 1. 껍데기(슬라이드 패널/모달)는 쓰는 쪽이 정한다. 이 컴포넌트는 본문만 그린다.
 *    - 설비별 작업 실적관리: 우측 560px 슬라이드 패널
 *    - 현장 설비 운영 및 실적관리: Modal
 * 2. 이미 저장된 상태가 '완료'인 실적만 잠근다. 폼에서 방금 '완료'로 바꾼 값으로는
 *    잠그지 않는다 — 저장 전에 되돌릴 수 있어야 하기 때문이다.
 * 3. 저장 후 이력을 다시 읽고 onSaved()로 부모 목록 갱신을 알린다.
 * 4. fieldMode(현장 화면 전용): 신규 실적 폼을 펼친 채로 열어 탭을 한 번 줄이고,
 *    모달(max-h-75vh) 안에서 스크롤이 생기지 않도록 조밀한 열 배치를 쓴다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import { Plus, ChevronDown, ChevronUp } from 'lucide-react';
import toast from 'react-hot-toast';
import api from '@/services/api';

/** 실적 등록에 필요한 작업지시 정보. 목록 행(RunRow)의 부분집합이다. */
export interface WorkResultRun {
  runNo: string;
  machineCode: string | null; machineName: string | null;
  workstageCode: string | null; workstageName: string | null;
  runDate: string; lineCode: string | null; shiftCode: string | null;
  itemCode: string | null; revision: string | null; modelName: string | null;
  itemName?: string | null;
  unit: string | null; itemClass: string | null; carModel: string | null;
  ct: number | null; planQty: number | null;
}

export interface WorkResultMachine {
  machineCode: string; machineName: string; workstageCode: string; workstageName: string; lineCode: string;
}

interface ResultRow {
  seqNo: string; machineCode: string; workstageCode: string; resultQty: number; workTime: number;
  workerCount: number; workerName: string; resultStatus: string; itemCode: string; modelName: string;
  defectQty: number; updatedAt: string;
}

interface ResultForm {
  seqNo: string | null; machineCode: string; machineName: string;
  workstageCode: string; workstageName: string;
  resultQty: number; workTime: number; workerCount: number; workerName: string;
  resultStatus: 'WIP' | 'DONE'; savedStatus: 'WIP' | 'DONE';
}

/** 설비 검색 콤보 (native input + 필터 리스트) */
function MachineCombo({ machines, value, onSelect, disabled }: {
  machines: WorkResultMachine[]; value: string; onSelect: (m: WorkResultMachine) => void; disabled?: boolean;
}) {
  const [q, setQ] = useState('');
  const [open, setOpen] = useState(false);
  const list = useMemo(() => {
    const s = q.trim().toLowerCase();
    return (s ? machines.filter((m) => `${m.machineCode} ${m.machineName}`.toLowerCase().includes(s)) : machines).slice(0, 100);
  }, [machines, q]);
  const picked = machines.find((m) => m.machineCode === value);
  return (
    <div className="relative">
      <button type="button" disabled={disabled} onClick={() => setOpen((o) => !o)}
        className="w-full border border-border rounded p-2 bg-background text-text text-left flex items-center justify-between disabled:opacity-50 disabled:bg-surface">
        <span className={picked ? '' : 'text-text-muted'}>{picked ? `${picked.machineCode} · ${picked.machineName}` : '설비를 선택하세요'}</span>
        <ChevronDown className="w-4 h-4 text-text-muted" />
      </button>
      {open && !disabled && (
        <div className="absolute z-20 mt-1 w-full max-h-64 overflow-auto border border-border rounded bg-background shadow-lg">
          <input autoFocus value={q} onChange={(e) => setQ(e.target.value)} placeholder="설비코드·설비명 검색"
            className="w-full border-b border-border p-2 bg-background text-text text-sm" />
          {list.map((m) => (
            <button key={m.machineCode} type="button" onClick={() => { onSelect(m); setOpen(false); setQ(''); }}
              className="w-full text-left px-2 py-1.5 text-sm hover:bg-surface">
              <span className="font-mono">{m.machineCode}</span> · {m.machineName}
              <span className="text-text-muted"> · {m.workstageCode}</span>
            </button>
          ))}
          {!list.length && <div className="p-3 text-center text-text-muted text-sm">검색 결과가 없습니다</div>}
        </div>
      )}
    </div>
  );
}

interface Props {
  run: WorkResultRun;
  machines: WorkResultMachine[];
  /** 현장 화면 모드 — 신규 실적 폼을 펼친 채 시작하고 조밀한 레이아웃을 쓴다 */
  fieldMode?: boolean;
  /** 신규 실적의 작업자 기본값. 현장 앱이 상단에서 고른 작업자를 넣는다 */
  defaultWorkerName?: string;
  /** 저장 성공 후 부모 목록을 갱신하라는 신호 */
  onSaved?: () => void | Promise<void>;
}

export default function WorkResultForm({ run, machines, defaultWorkerName, onSaved, fieldMode }: Props) {
  const newResultForm = useCallback(
    (): ResultForm => ({
      seqNo: null,
      machineCode: run.machineCode ?? '', machineName: run.machineName ?? '',
      workstageCode: run.workstageCode ?? '', workstageName: run.workstageName ?? '',
      resultQty: 0, workTime: 0, workerCount: 0,
      workerName: defaultWorkerName ?? '',
      resultStatus: 'WIP', savedStatus: 'WIP',
    }),
    [run, defaultWorkerName],
  );

  const [history, setHistory] = useState<ResultRow[]>([]);
  // 현장 모드는 최신 1건만 보이고 나머지는 접어둔다
  const [historyOpen, setHistoryOpen] = useState(false);
  // 현장 모드는 신규 실적 폼을 펼친 채로 연다 — [신규 실적] 탭 한 번을 줄인다.
  const [form, setForm] = useState<ResultForm | null>(() => (fieldMode ? newResultForm() : null));

  const loadHistory = useCallback(async () => {
    try {
      const res = await api.get('/oee/work-result/results', { params: { runNo: run.runNo } });
      setHistory(res.data?.data?.list ?? []);
    } catch { setHistory([]); }
  }, [run.runNo]);

  // 이력만 읽는다(비동기라 동기 setState가 아니다). 작업지시가 바뀌면 쓰는 쪽이
  // key={run.runNo}로 remount시켜 폼이 초기화된다.
  useEffect(() => { void loadHistory(); }, [loadHistory]);

  async function selectHistory(row: ResultRow) {
    try {
      const res = await api.get(`/oee/work-result/results/${encodeURIComponent(run.runNo)}/${row.seqNo}`);
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

  // 이미 저장된 상태가 '완료'인 실적만 잠금(수정불가).
  const readOnly = form?.savedStatus === 'DONE';

  async function saveResult() {
    if (!form) return;
    if (!(form.resultQty >= 0)) return toast.error('실적수량을 입력하세요');
    const payload = {
      runNo: run.runNo, seqNo: form.seqNo ?? undefined,
      machineCode: form.machineCode || undefined, workstageCode: form.workstageCode,
      resultQty: form.resultQty, workTime: form.workTime, workerCount: form.workerCount,
      workerName: form.workerName, resultStatus: form.resultStatus,
    };
    try {
      if (form.seqNo) await api.put('/oee/work-result/results', payload);
      else await api.post('/oee/work-result/results', payload);
      toast.success('실적이 저장되었습니다');
      await loadHistory();
      setForm(null);
      await onSaved?.();
    } catch (e: unknown) {
      const msg = e && typeof e === 'object' && 'response' in e
        ? (e as { response?: { data?: { message?: string } } }).response?.data?.message : undefined;
      toast.error(msg || '저장에 실패했습니다');
    }
  }

  return (
    <div className="space-y-4">
      {/* 실적 이력 그리드 */}
      <div>
        <div className="flex items-center justify-between mb-1">
          <span className="text-sm font-semibold text-text">실적 이력</span>
          {fieldMode ? (
            history.length > 1 && (
              <button type="button" onClick={() => setHistoryOpen((v) => !v)}
                className="text-xs border border-border text-text-muted rounded px-2 py-1 hover:bg-surface flex items-center gap-1">
                {historyOpen
                  ? <><ChevronUp className="w-3 h-3" />접기</>
                  : <><ChevronDown className="w-3 h-3" />이전 이력 {history.length - 1}건</>}
              </button>
            )
          ) : (
            <button onClick={() => setForm(newResultForm())} className="text-xs border border-primary text-primary rounded px-2 py-1 hover:bg-surface flex items-center gap-1"><Plus className="w-3 h-3" />신규 실적</button>
          )}
        </div>
        <div className={fieldMode && historyOpen ? 'max-h-[132px] overflow-y-auto border border-border rounded' : ''}>
        <table className="w-full text-xs border border-border">
          <thead><tr className="bg-surface text-text-muted"><th className="p-1.5 text-center">일련</th><th className="p-1.5 text-left">품번/품명</th><th className="p-1.5 text-right">실적수량</th><th className="p-1.5 text-center">처리구분</th></tr></thead>
          <tbody>
            {(fieldMode && !historyOpen ? history.slice(0, 1) : history).map((h) => (
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
          <div className={`grid gap-x-4 text-sm border border-border rounded bg-surface/40 ${
            fieldMode ? 'grid-cols-4 gap-y-2 p-3' : 'grid-cols-2 gap-y-1.5 p-3'
          }`}>
            {([
              ['라인', run.lineCode ?? '-'],
              ['교대조', run.shiftCode ?? '-'],
              ['품번 | 리비전', `${run.itemCode ?? ''} | ${run.revision ?? ''}`],
              ['품명', run.itemName ?? run.modelName ?? '-'],
              ['차종', run.carModel ?? '-'],
              ['품목분류', run.itemClass ?? '-'],
              ['단위', run.unit ?? '-'],
              ['표준시간(C/T)', run.ct != null ? `${run.ct}s` : '-'],
              ['계획일', run.runDate],
              ['계획수량', (run.planQty ?? 0).toLocaleString()],
            ] as [string, string][]).map(([k, v]) => (
              // 현장 모드는 라벨과 값을 한 줄에 붙여 행 수를 줄인다(모달 스크롤 방지).
              // 길이가 긴 품번·품명만 2칸을 줘서 잘리지 않게 한다 — 행 수는 그대로 3행이다.
              <div key={k} className={
                fieldMode
                  ? `flex items-baseline gap-1 min-w-0 ${k === '품명' || k === '품번 | 리비전' ? 'col-span-2' : ''}`
                  : 'flex flex-col'
              }>
                <span className={`text-text-muted flex-shrink-0 ${fieldMode ? 'text-xs' : 'text-[11px]'}`}>{k}</span>
                <span className={`text-text ${fieldMode ? 'text-sm font-medium truncate' : ''}`} title={fieldMode ? v : undefined}>{v}</span>
              </div>
            ))}
          </div>
          {/* 설비선택 → 공정 자동 */}
          <label className="text-sm text-text-muted flex flex-col gap-1"><span>설비선택</span>
            <MachineCombo machines={machines} value={form.machineCode} disabled={readOnly}
              onSelect={(m) => setForm({ ...form, machineCode: m.machineCode, machineName: m.machineName, workstageCode: m.workstageCode, workstageName: m.workstageName })} />
          </label>
          <div className="text-xs text-text-muted">공정: <b className="text-text">{form.workstageCode ? `${form.workstageCode} · ${form.workstageName}` : '-'}</b></div>
          <div className={`grid gap-3 ${fieldMode ? 'grid-cols-3' : 'grid-cols-2'}`}>
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
  );
}
