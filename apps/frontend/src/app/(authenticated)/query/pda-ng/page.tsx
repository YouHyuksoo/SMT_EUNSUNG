"use client";

/**
 * @file src/app/(authenticated)/query/pda-ng/page.tsx
 * @description PDA 검사오류내역조회 — PB w_smt_plan_ng_check_master 이식
 *
 * 초보자 가이드:
 * 1. **모델 하나의 피더 배치 계획을 펼쳐 놓고 검사 설정을 본다.** 자리마다
 *    '검사를 하는가(검사 Y/N)'·'CCS 를 쓰는가' 가 있고, 꺼져 있으면 오삽을
 *    못 잡는다 — N 인 자리가 노랗게 보인다.
 * 2. **세 갈래로 본다.** 모델별 계획 · 라인별 목록 · 배치 이미지 메모.
 * 3. **검사 플래그 3개를 고칠 수 있다** (쓰기). 행을 고르고 아래에서 바꿔 저장한다.
 *    **그 셋만 바꾼다** — DataWindow 의 update=yes 를 실측해 맞췄다.
 * 4. **키가 7컬럼이다** (모델+라인+위치+품목+설비+테이블+PCB면). 일부만 보내면
 *    같은 자리의 다른 설비·테이블 계획까지 함께 바뀐다 — 그래서 행 전체를 보낸다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { useRunAfterRender } from '@/hooks/useRunAfterRender';
import Select from '@/components/ui/Select';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { QueryTabs } from '../components/QueryTabs';
import { planDataColumns, workflowColumns } from '../query-columns';
import type { PlanDataRow, WorkflowRow } from '../query-types';

const YN_OPTIONS = [
  { value: '', label: '바꾸지 않음' },
  { value: 'Y', label: 'Y' },
  { value: 'N', label: 'N' },
];
const PCB_OPTIONS = [
  { value: '', label: 'PCB면: 전체' },
  { value: 'T', label: 'PCB면: 상(T)' },
  { value: 'B', label: 'PCB면: 하(B)' },
];

type Tab = 'model' | 'line' | 'workflow';

export default function PdaNgQueryPage() {
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [pcbItem, setPcbItem] = useState('');
  const [revision, setRevision] = useState('');

  const [tab, setTab] = useState<Tab>('model');
  const [byModel, setByModel] = useState<PlanDataRow[]>([]);
  const [byLine, setByLine] = useState<PlanDataRow[]>([]);
  const [workflow, setWorkflow] = useState<WorkflowRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  // 모델 조회(모델별·배치 메모)와 라인 조회는 따로 돌므로 잘림 표시도 따로 둔다.
  const modelCut = useTruncation();
  const lineCut = useTruncation();
  const cut = tab === 'line' ? lineCut : modelCut;

  const [selected, setSelected] = useState<PlanDataRow | null>(null);
  const [checkYn, setCheckYn] = useState('');
  const [ccsYn, setCcsYn] = useState('');
  const [checkStatus, setCheckStatus] = useState('');
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    if (!modelName) {
      toast.error('모델명을 입력하세요 (PB 도 모델을 등호로 걸었습니다).');
      return;
    }
    setLoading(true);
    setSelected(null);
    try {
      const params = {
        modelName,
        lineCode: lineCode || undefined,
        pcbItem: pcbItem || undefined,
        revision: revision || undefined,
      };
      const [m, w] = await Promise.all([
        api.get('/query/pda-ng', { params }),
        api.get('/query/pda-ng/workflow', { params }),
      ]);
      setByModel(m.data?.data ?? []);
      setWorkflow(w.data?.data ?? []);
      modelCut.mark(m, w);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '계획 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, lineCode, pcbItem, revision, modelCut.mark]);

  const searchByLine = useCallback(async () => {
    if (!lineCode) {
      toast.error('라인을 고르세요.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/query/pda-ng/line', { params: { lineCode } });
      setByLine(response.data?.data ?? []);
      lineCut.mark(response);
      setTab('line');
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '라인별 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, lineCut.mark]);

  const pick = useCallback((row: PlanDataRow) => {
    setSelected(row);
    setCheckYn('');
    setCcsYn('');
    setCheckStatus('');
  }, []);

  const save = useCallback(async () => {
    if (!selected) return;
    if (!checkYn && !ccsYn && !checkStatus) {
      toast.error('바꿀 값을 하나 이상 고르세요.');
      return;
    }
    setBusy(true);
    try {
      const response = await api.put('/query/pda-ng/flags', {
        rows: [{
          lineCode: selected.lineCode,
          modelName: selected.modelName,
          locationCode: selected.locationCode,
          itemCode: selected.itemCode,
          machine: selected.machine,
          tableId: selected.tableId,
          pcbItem: selected.pcbItem,
          checkYn: checkYn || undefined,
          ccsYn: ccsYn || undefined,
          checkStatus: checkStatus || undefined,
        }],
      });
      const data = response.data?.data;
      if (Number(data?.changed ?? 0) > 0) {
        toast.success(`${data.changed}건 저장했습니다.`);
      } else {
        toast.error('그 계획 행을 찾을 수 없었습니다 (키 7컬럼을 확인하세요).');
      }
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, checkYn, ccsYn, checkStatus, search]);

  const rows = tab === 'line' ? byLine : byModel;
  const rowKey = (r: PlanDataRow) =>
    [r.modelName, r.lineCode, r.locationCode, r.itemCode, r.machine, r.tableId, r.pcbItem]
      .join('|');
  const offCount = rows.filter((r) => r.checkYn === 'N' || r.ccsYn === 'N').length;

  // 모델을 고르면 새 모델명으로 바로 조회한다 (Enter 조회를 대신함)
  const searchAfterModelSelect = useRunAfterRender(search);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">PDA 검사오류내역조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          피더 자리별 검사 설정을 보고 조정합니다 ·{' '}
          {searched ? `${rows.length}건` : '모델명을 넣고 조회하세요'}
          {offCount > 0 && (
            <span className="ml-1 text-amber-500">· 검사·CCS 꺼진 자리 {offCount}곳</span>
          )}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <ModelSearchField aria-label="모델명" placeholder="모델명 (필수)" value={modelName}
            className="w-52" onChange={(v) => { setModelName(v); if (v) searchAfterModelSelect(); }} />
          <div className="w-40">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <div className="w-40">
            <Select options={PCB_OPTIONS} value={pcbItem} onChange={setPcbItem} />
          </div>
          <Input aria-label="리비전" placeholder="리비전" value={revision} className="w-28"
            onChange={(e) => setRevision(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />모델로 조회
          </Button>
          <Button size="sm" variant="secondary" onClick={searchByLine} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />라인으로 조회
          </Button>
        </CardContent>
      </Card>

      <QueryTabs
        tabs={[
          { key: 'model', label: '모델별 계획', count: byModel.length },
          { key: 'line', label: '라인별 목록', count: byLine.length },
          { key: 'workflow', label: '배치 메모', count: workflow.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <TruncationNotice truncated={cut.truncated} rowLimit={cut.rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'workflow' ? (
            <DataGrid data={workflow} columns={workflowColumns} isLoading={loading}
              pageSize={100} enableColumnFilter
              emptyMessage={searched ? '이 모델에 배치 이미지가 없습니다.' : '조회하세요.'} />
          ) : (
            <DataGrid
              data={rows}
              columns={planDataColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="피더계획"
              emptyMessage={searched ? '이 조건에 계획이 없습니다.' : '조회하세요.'}
              onRowClick={(row) => pick(row as PlanDataRow)}
              rowClassName={(row) => {
                const r = row as PlanDataRow;
                if (selected && rowKey(r) === rowKey(selected)) return 'bg-primary/10';
                return r.checkYn === 'N' || r.ccsYn === 'N' ? 'bg-amber-500/5' : '';
              }}
              getRowId={(row) => rowKey(row as PlanDataRow)}
            />
          )}
        </CardContent>
      </Card>

      {tab !== 'workflow' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <b className="text-sm text-text">검사 설정</b>
            {selected ? (
              <span className="text-sm text-text-muted">
                {selected.lineName ?? selected.lineCode} · {selected.machine} ·{' '}
                {selected.tableId} · {selected.locationCode} · {selected.itemCode}
              </span>
            ) : (
              <span className="text-sm text-text-muted">위에서 행을 고르세요.</span>
            )}
            <label className="flex items-center gap-2 text-sm text-text">
              검사
              <div className="w-36">
                <Select options={YN_OPTIONS} value={checkYn} onChange={setCheckYn}
                  disabled={!selected} />
              </div>
            </label>
            <label className="flex items-center gap-2 text-sm text-text">
              CCS
              <div className="w-36">
                <Select options={YN_OPTIONS} value={ccsYn} onChange={setCcsYn}
                  disabled={!selected} />
              </div>
            </label>
            <Input aria-label="검사상태" placeholder="검사상태" value={checkStatus}
              className="w-32" disabled={!selected}
              onChange={(e) => setCheckStatus(e.target.value)} />
            <Button size="sm" onClick={save} disabled={!selected || busy}>
              <Save className="mr-1 h-4 w-4" />저장
            </Button>
            <span className="text-sm text-text-muted">이 세 컬럼만 바뀝니다</span>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
