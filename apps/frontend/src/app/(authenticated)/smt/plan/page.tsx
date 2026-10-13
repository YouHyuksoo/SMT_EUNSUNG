"use client";

/**
 * @file src/app/(authenticated)/smt/plan/page.tsx
 * @description SMT 계획배포관리 — PB w_smt_plan_master 이식
 *
 * 초보자 가이드:
 * 1. **"배포" 는 설계 BOM 을 현장용 계획으로 펼치는 일이다.**
 *    펼친 뒤에는 현장이 이 표를 보고 자재를 물린다.
 * 2. **활성(ACTIVE_YN='Y') 이 현장이 쓰는 계획이다.**
 *    - 배포: 활성 계획이 있거나 이미 배포된 행이 있으면 거부된다.
 *    - 배포취소: 비활성 행만 지우고 백업 테이블로 옮긴다. 활성은 건드리지 않는다.
 *    - 활성화: 한 라인에 두 모델이 동시에 활성일 수 없다. 그러면 현장이 어느
 *      계획으로 자재를 물릴지 알 수 없다.
 * 3. **배치는 PB 와 같다.** 왼쪽 위 '라인'에서 라인을 고르면 오른쪽 위 'Summary'에 그 라인의
 *    배포계획이 모델·PCB면별로 나오고, Summary 한 줄을 고르면 아래 '피더 배치'에 그 계획 상세가 나온다.
 *    버튼(Line On/Off · Restore · 배포취소 · 피더 레이아웃 출력)은 Summary 에서 고른 라인·모델·면에 적용한다.
 * 5. **Line On/Off 는 현장 PDA 와 같은 프로시저를 런카드로 부른다.** 장착하면 계획이 활성이 되고 라인 ON 이력이 남는다.
 *    PB 의 Line On/Off 는 다른 스키마의 프로시저를 가리켜 은성에서는 동작하지 않았다.
 * 6. **Restore** 는 활성인데 CCS 가 안 끝난 피더를 체크 완료로 바꾸고, 자재 바코드를 체크이력에서 다시 채운다.
 * 4. 체크상태·CCS 는 보기만 한다 — Restore 외에 그 값을 바꾸는 것은 현장 스캔·풀체크 화면이다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { History, Play, Power, PowerOff, Printer, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import Select from '@/components/ui/Select';
import api from '@/services/api';
import { SmtModelSelect, SmtPcbItemSelect } from '../components/SmtSelects';
import { smtPlanColumns, smtPlanLineColumns, smtPlanSummaryColumns } from '../columns';
import type { SmtPlanLineRow, SmtPlanRow, SmtPlanSummaryRow } from '../types';
import SmtPlanDeployModal from './components/SmtPlanDeployModal';
import LineOnOffModal from './components/LineOnOffModal';
import FeederLayoutPrintModal from './components/FeederLayoutPrintModal';
import LineSelect from '@/components/shared/LineSelect';

const YN_OPTIONS = [
  { value: '', label: '전체' },
  { value: 'Y', label: '예' },
  { value: 'N', label: '아니오' },
];

const planKey = (r: SmtPlanSummaryRow) =>
  [r.lineCode, r.modelName, r.pcbItem, r.smtModelName, r.masterSmtModelName].join('|');

export default function SmtPlanPage() {
  const [lines, setLines] = useState<SmtPlanLineRow[]>([]);
  const [summary, setSummary] = useState<SmtPlanSummaryRow[]>([]);
  const [rows, setRows] = useState<SmtPlanRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [summaryLoading, setSummaryLoading] = useState(false);

  // 조회 조건 (PB Where Condition: 라인 · 모델 · 리비전)
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [revision, setRevision] = useState('');
  // 피더 배치 거르기
  const [pcbItem, setPcbItem] = useState('');
  const [replaceYn, setReplaceYn] = useState('');
  const [activeYn, setActiveYn] = useState('');

  /** 왼쪽 위에서 고른 라인, 오른쪽 위에서 고른 계획 — 버튼 동작의 대상이다 */
  const [selectedLine, setSelectedLine] = useState('');
  const [selectedPlan, setSelectedPlan] = useState<SmtPlanSummaryRow | null>(null);

  const [deployOpen, setDeployOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [lineOnOff, setLineOnOff] = useState<'ON' | 'OFF' | null>(null);
  const [restoreOpen, setRestoreOpen] = useState(false);
  const [printOpen, setPrintOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  /** 라인 목록 (PB dw_1). 라인 조건은 화면에서 거른다. */
  const loadLines = useCallback(async () => {
    try {
      const response = await api.get('/smt/plan/lines');
      setLines(response.data?.data ?? []);
    } catch {
      setLines([]);
    }
  }, []);

  useEffect(() => { void loadLines(); }, [loadLines]);

  /** Summary (PB dw_2) — 고른 라인의 계획. 라인 없이 모델만 골랐으면 그 모델의 전 라인 */
  const loadSummary = useCallback(async (line: string) => {
    setSelectedPlan(null);
    setRows([]);
    if (!line && !modelName) { setSummary([]); return; }
    setSummaryLoading(true);
    try {
      const response = await api.get('/smt/plan/summary', {
        params: { lineCode: line || undefined, modelName: modelName || undefined, revision: revision || undefined },
      });
      setSummary(response.data?.data ?? []);
    } catch {
      setSummary([]);
      toast.error('배포 요약 조회에 실패했습니다.');
    } finally {
      setSummaryLoading(false);
    }
  }, [modelName, revision]);

  /** 피더 배치 (PB dw_3) — Summary 에서 고른 계획의 라인·모델·면·피더축 */
  const loadDetail = useCallback(async (plan: SmtPlanSummaryRow | null) => {
    if (!plan) { setRows([]); return; }
    setLoading(true);
    try {
      const shaft = (plan.feederShaft ?? '').trim();
      const response = await api.get('/smt/plan', {
        params: {
          modelName: plan.modelName,
          lineCode: plan.lineCode,
          pcbItem: (pcbItem || plan.pcbItem) || undefined,
          feederShaft: shaft && shaft !== '*' ? shaft : undefined,
          replaceYn: replaceYn || undefined,
          activeYn: activeYn || undefined,
        },
      });
      setRows(response.data?.data ?? []);
    } catch {
      toast.error('피더 배치 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [pcbItem, replaceYn, activeYn]);

  // 계획을 고르거나 피더 배치 거르기 조건이 바뀌면 다시 읽는다
  useEffect(() => { void loadDetail(selectedPlan); }, [loadDetail, selectedPlan]);

  const search = useCallback(async () => {
    const line = lineCode || selectedLine;
    if (lineCode) setSelectedLine(lineCode);
    await loadLines();
    await loadSummary(line);
  }, [loadLines, loadSummary, lineCode, selectedLine]);

  const visibleLines = useMemo(
    () => (lineCode ? lines.filter((l) => String(l.lineCode).startsWith(lineCode)) : lines),
    [lines, lineCode],
  );

  const afterChange = useCallback(() => {
    void loadLines();
    void loadSummary(selectedLine);
  }, [loadLines, loadSummary, selectedLine]);

  const remove = useCallback(async () => {
    if (!selectedPlan) return;
    setDeleteOpen(false);
    setBusy(true);
    try {
      const response = await api.delete('/smt/plan', {
        data: {
          lineCode: selectedPlan.lineCode,
          modelName: selectedPlan.modelName,
          pcbItem: selectedPlan.pcbItem || undefined,
        },
      });
      const data = response.data?.data;
      toast.success(
        `비활성 계획 ${data?.deleted ?? 0}행을 지웠습니다`
        + (Number(data?.remainingActive ?? 0) > 0
          ? ` (활성 ${data.remainingActive}행은 남겼습니다).`
          : '.'),
      );
      afterChange();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '배포 취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selectedPlan, afterChange]);

  const restore = useCallback(async () => {
    if (!selectedPlan) return;
    setRestoreOpen(false);
    setBusy(true);
    try {
      const response = await api.put('/smt/plan/restore', {
        lineCode: selectedPlan.lineCode,
        modelName: selectedPlan.modelName,
        pcbItem: selectedPlan.pcbItem === 'B' ? 'B' : 'T',
      });
      const data = response.data?.data;
      toast.success(`Restore 완료 — 체크 완료 ${data?.checkedRows ?? 0}행 · 자재 바코드 복원 ${data?.restoredRows ?? 0}행`);
      void loadDetail(selectedPlan);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'Restore 에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selectedPlan, loadDetail]);

  const columns = useMemo(() => smtPlanColumns, []);
  const lineColumns = useMemo(() => smtPlanLineColumns, []);
  const summaryColumns = useMemo(() => smtPlanSummaryColumns, []);
  const scopeReady = selectedPlan !== null;
  const scopeLabel = selectedPlan
    ? `${selectedPlan.lineCode} / ${selectedPlan.modelName}${selectedPlan.pcbItem ? ` / ${selectedPlan.pcbItem}면` : ' / 양면'}`
    : '';

  return (
    <div className="flex h-full flex-col gap-3 p-5">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">SMT 계획배포관리</h1>
          <p className="mt-1 text-sm text-text-muted">
            SMT BOM 을 현장 피더 계획으로 배포합니다 ·{' '}
            {selectedPlan ? `선택: ${scopeLabel} · 피더 ${rows.length}행` : '라인을 고르고 Summary 에서 계획을 고르세요'}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={() => void search()} disabled={loading || summaryLoading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" onClick={() => setDeployOpen(true)} disabled={busy}>
            <Play className="mr-1 h-4 w-4" />배포
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setDeleteOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />배포취소
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setPrintOpen(true)}>
            <Printer className="mr-1 h-4 w-4" />피더 레이아웃 출력
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setRestoreOpen(true)}>
            <History className="mr-1 h-4 w-4" />Restore
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setLineOnOff('ON')}>
            <Power className="mr-1 h-4 w-4 text-emerald-600" />Line On
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setLineOnOff('OFF')}>
            <PowerOff className="mr-1 h-4 w-4 text-red-500" />Line Off
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
          <SmtModelSelect labelPrefix="모델" value={modelName} onChange={setModelName} className="w-64" />
          <Input aria-label="리비전" placeholder="리비전" value={revision}
            onChange={(e) => setRevision(e.target.value)} className="w-28" />
        </CardContent>
      </Card>

      {/* PB 와 같은 배치: 왼쪽 위 라인 · 오른쪽 위 Summary */}
      <div className="grid h-[38%] min-h-56 shrink-0 grid-cols-2 gap-3">
        <Card className="min-h-0 min-w-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <b className="text-sm text-text">라인 ({visibleLines.length})</b>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={visibleLines}
                columns={lineColumns}
                pageSize={50}
                emptyMessage="생산라인이 없습니다."
                getRowId={(row) => String((row as SmtPlanLineRow).lineCode)}
                selectedRowId={selectedLine || undefined}
                onRowClick={(row) => {
                  const line = String((row as SmtPlanLineRow).lineCode);
                  setSelectedLine(line);
                  void loadSummary(line);
                }}
              />
            </div>
          </CardContent>
        </Card>
        <Card className="min-h-0 min-w-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <b className="text-sm text-text">
              Summary{selectedLine ? ` — ${selectedLine} 라인` : modelName ? ` — ${modelName}` : ''} ({summary.length})
            </b>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={summary}
                columns={summaryColumns}
                isLoading={summaryLoading}
                pageSize={100}
                enableColumnFilter
                emptyMessage="왼쪽에서 라인을 고르세요."
                getRowId={(row) => planKey(row as SmtPlanSummaryRow)}
                selectedRowId={selectedPlan ? planKey(selectedPlan) : undefined}
                onRowClick={(row) => setSelectedPlan(row as SmtPlanSummaryRow)}
              />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* 아래 전체 폭: 피더 배치 */}
      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <b className="text-sm text-text">피더 배치{selectedPlan ? ` — ${scopeLabel}` : ''}</b>
            <SmtPcbItemSelect labelPrefix="PCB면" value={pcbItem}
              onChange={setPcbItem} className="w-40" />
            <div className="w-32">
              <Select options={YN_OPTIONS.map((o) => ({
                ...o, label: o.value === '' ? '대체: 전체' : `대체: ${o.label}`,
              }))} value={replaceYn} onChange={setReplaceYn} />
            </div>
            <div className="w-32">
              <Select options={YN_OPTIONS.map((o) => ({
                ...o, label: o.value === '' ? '활성: 전체' : `활성: ${o.label}`,
              }))} value={activeYn} onChange={setActiveYn} />
            </div>
          </div>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={rows}
              columns={columns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SMT피더배치"
              emptyMessage="Summary 에서 계획을 고르세요."
              getRowId={(row) => {
                const r = row as SmtPlanRow;
                return [r.modelName, r.lineCode, r.machine, r.locationCode,
                  r.itemCode, r.pcbItem, r.replaceYn].join('|');
              }}
            />
          </div>
        </CardContent>
      </Card>

      {deployOpen && (
        <SmtPlanDeployModal
          defaultModelName={selectedPlan?.modelName ?? modelName}
          defaultLineCode={selectedPlan?.lineCode ?? (lineCode || selectedLine)}
          onClose={() => setDeployOpen(false)}
          onDone={() => { setDeployOpen(false); afterChange(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="배포 취소"
        message={`${scopeLabel} 의 비활성 계획을 지울까요? 활성 계획은 그대로 남습니다.`
          + ' 지우는 행은 백업 테이블로 옮겨집니다.'}
        variant="danger"
      />

      <ConfirmModal
        isOpen={restoreOpen}
        onClose={() => setRestoreOpen(false)}
        onConfirm={restore}
        title="Restore"
        message={`${scopeLabel} — 활성인데 CCS 가 끝나지 않은 피더를 체크 완료(합격)로 바꾸고,`
          + ' 피더의 자재 바코드·LOT 를 체크이력에서 다시 채웁니다. 체크이력이 없는 피더는 그대로 둡니다.'}
      />

      {lineOnOff && selectedPlan && (
        <LineOnOffModal
          mode={lineOnOff}
          plan={selectedPlan}
          onClose={() => setLineOnOff(null)}
          onDone={() => { setLineOnOff(null); afterChange(); }}
        />
      )}

      {printOpen && selectedPlan && (
        <FeederLayoutPrintModal plan={selectedPlan} revision={revision} onClose={() => setPrintOpen(false)} />
      )}
    </div>
  );
}
