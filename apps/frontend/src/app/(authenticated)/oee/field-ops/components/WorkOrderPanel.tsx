'use client';

/**
 * @file (authenticated)/oee/field-ops/components/WorkOrderPanel.tsx
 * @description 현장 화면 우측 — 작업실적 관리. 선택한 라인/설비의 작업지시를 두 줄 그리드로
 *   보여주고, 행을 고른 뒤 하단 고정 버튼으로 실적 등록 팝업을 연다.
 *
 * 타이틀 옆 날짜(기본 당일)와 조회 버튼으로 이 영역만 따로 조회한다 — 화면 상단에는
 * 조회 기능을 두지 않기 때문이다.
 */
import { useCallback, useEffect, useState } from 'react';
import { ClipboardList, RefreshCw } from 'lucide-react';
import toast from 'react-hot-toast';
import { Card, CardContent, Modal } from '@/components/ui';
import { WorkResultForm, type WorkResultMachine, type WorkResultRun } from '@/components/shared';
import api from '@/services/api';

/** 목록 한 행 — 실적 폼이 쓰는 필드(WorkResultRun)에 그리드 표시용을 더한다 */
interface RunRow extends WorkResultRun {
  machineName: string | null;
  workstageGroup: string | null;
}

interface Props {
  /** 조회 범위. 라인 모드면 lineCode, 설비 모드면 machineCode가 채워진다 */
  scope: { lineCode?: string; machineCode?: string } | null;
  /** 실적 폼의 작업자 기본값 (상단에서 고른 작업자 이름) */
  workerName: string;
}

function todayStr() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}

export default function WorkOrderPanel({ scope, workerName }: Props) {
  const [date, setDate] = useState(todayStr());
  const [rows, setRows] = useState<RunRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<string | null>(null);
  const [machines, setMachines] = useState<WorkResultMachine[]>([]);
  const [formRun, setFormRun] = useState<RunRow | null>(null);

  const load = useCallback(async () => {
    if (!scope) { setRows([]); setSelected(null); return; }
    setLoading(true);
    try {
      const res = await api.get('/oee/work-result', {
        params: { fromDate: date, toDate: date, ...scope },
      });
      setRows(res.data?.data?.list ?? []);
    } catch { toast.error('작업지시 목록 조회에 실패했습니다'); }
    finally { setLoading(false); }
  }, [date, scope]);

  // 대상이 바뀌면 자동으로 다시 읽는다. 날짜만 바꿨을 때는 [조회]를 눌러야 한다.
  useEffect(() => { void load(); }, [load]);

  // 실적 폼의 설비 콤보용 목록 (최초 1회)
  useEffect(() => {
    api.get('/oee/work-result/machines').then((r) => setMachines(r.data?.data?.list ?? [])).catch(() => {});
  }, []);

  const selectedRow = rows.find((r) => r.runNo === selected) ?? null;

  function openForm() {
    if (!selectedRow) return toast.error('작업지시를 선택하세요');
    setFormRun(selectedRow);
  }

  return (
    <Card className="h-full overflow-hidden" padding="none">
      <CardContent className="h-full p-4 overflow-hidden flex flex-col gap-2">
        <div className="flex items-center justify-between flex-shrink-0 gap-2">
          <span className="text-sm font-semibold text-text flex-shrink-0">작업실적 관리</span>
          <div className="flex items-center gap-1">
            <input type="date" value={date} onChange={(e) => setDate(e.target.value)}
              aria-label="계획일"
              className="border border-border rounded px-2 h-8 bg-background text-text text-xs" />
            <button type="button" onClick={() => void load()}
              className="border border-border rounded px-2 h-8 text-text-muted hover:bg-surface flex items-center gap-1 text-xs">
              <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />조회
            </button>
          </div>
        </div>

        {/* 작업지시 목록 — 한 건이 두 줄이다 */}
        <div className="flex-1 min-h-0 overflow-auto border border-border rounded">
          {rows.map((r) => {
            const active = r.runNo === selected;
            return (
              <button key={r.runNo} type="button" onClick={() => setSelected(r.runNo)}
                className={`w-full text-left border-b border-border px-2 py-1.5 transition-colors ${
                  active ? 'bg-primary/10 ring-1 ring-inset ring-primary' : 'hover:bg-surface'
                }`}>
                <div className="flex items-center gap-2 text-xs">
                  <span className="font-mono font-semibold text-text">{r.runNo}</span>
                  <span className="text-text-muted">{r.runDate}</span>
                  <span className="text-text-muted">교대 {r.shiftCode ?? '-'}</span>
                </div>
                <div className="flex items-center gap-2 text-[11px] mt-0.5 min-w-0">
                  <span className="font-mono text-text-muted flex-shrink-0">{r.itemCode ?? '-'} | {r.revision ?? '-'}</span>
                  <span className="text-text truncate">{r.itemName ?? r.modelName ?? '-'}</span>
                </div>
              </button>
            );
          })}
          {!rows.length && (
            <div className="p-6 text-center text-text-muted text-xs">
              {scope ? '해당 일자의 작업지시가 없습니다' : '라인 또는 설비를 선택하세요'}
            </div>
          )}
        </div>

        {/* 하단 고정 — 좌측 '비가동 전환' 버튼과 같은 높이 */}
        <button type="button" onClick={openForm} disabled={!selectedRow}
          className="flex-shrink-0 h-12 rounded-lg bg-primary text-white text-sm font-semibold flex items-center justify-center gap-2 hover:bg-primary/90 disabled:opacity-40">
          <ClipboardList className="w-5 h-5" />
          {selectedRow ? `작업 실적 등록 · ${selectedRow.runNo}` : '작업 실적 등록'}
        </button>
      </CardContent>

      <Modal isOpen={!!formRun} onClose={() => setFormRun(null)} size="lg"
        title="작업 실적 등록" subtitle={formRun?.runNo}>
        {formRun && (
          <WorkResultForm key={formRun.runNo} run={formRun} machines={machines}
            defaultWorkerName={workerName} onSaved={load} />
        )}
      </Modal>
    </Card>
  );
}
