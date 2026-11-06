"use client";

/**
 * @file src/app/(authenticated)/quality/temperature/page.tsx
 * @description 온도상태조회 — PB w_pln_product_tempreture_history_query 이식
 *
 * 초보자 가이드:
 * 1. **탭 3개** — 노드현황(지금 값) / 원시데이터(기간 이력) / 점검이력.
 * 2. **원시데이터는 노드를 반드시 골라야 한다.** 원시 테이블이 1,700만 행이고
 *    인덱스가 (노드ID, 수집일시) 하나뿐이라 노드를 안 고르면 전체를 훑는다.
 *    그래서 노드현황에서 노드를 골라 넘어오는 흐름으로 만들었다.
 * 3. **기준초과(NG)는 설비의 최소·최대 온도·습도와 비교한 계산값이다** — PB 식 그대로다.
 *    온도·습도 칸은 기준범위를 벗어나면 빨간 바탕, 안이면 초록 글씨다.
 * 4. **이상 점검이력은 등록·수정·삭제한다** (PB dw_5). 원시데이터에서 행을 고르고
 *    '이상 점검 등록'을 누르면 그 노드와 수집일시가 채워진다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Edit2, Plus, Search, Thermometer, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import EquipSelect from '@/components/shared/EquipSelect';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import TemperatureCheckFormPanel, {
  emptyTemperatureCheckForm,
  toTemperatureCheckForm,
  type TemperatureCheckForm,
} from './components/TemperatureCheckFormPanel';
import {
  temperatureCheckColumns,
  temperatureNodeColumns,
  temperatureRawColumns,
  type TemperatureCheckRow,
  type TemperatureNodeRow,
  type TemperatureRawRow,
} from '../qc-columns';

type Mode = 'nodes' | 'raw' | 'checks';

/** 로컬(KST) 오늘 — toISOString 은 UTC 라 오전 9시 전엔 어제가 된다 */
const today = () => getTodayLocal();

export default function TemperaturePage() {
  const [mode, setMode] = useState<Mode>('nodes');
  const [nodes, setNodes] = useState<TemperatureNodeRow[]>([]);
  const [raw, setRaw] = useState<TemperatureRawRow[]>([]);
  const [checks, setChecks] = useState<TemperatureCheckRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [nodeId, setNodeId] = useState('');
  const [dateFrom, setDateFrom] = useState(today);
  const [dateTo, setDateTo] = useState(today);
  const [ngOnly, setNgOnly] = useState(false);
  const [machineCode, setMachineCode] = useState('');
  const [confirmYn, setConfirmYn] = useState('');

  const [selectedRaw, setSelectedRaw] = useState<TemperatureRawRow | null>(null);
  const [selectedCheck, setSelectedCheck] = useState<TemperatureCheckRow | null>(null);
  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: TemperatureCheckForm } | null>(null);
  const [deleteOpen, setDeleteOpen] = useState(false);

  /** 노드현황은 조건이 없다 — 탭에 들어오면 바로 읽는다 */
  const loadNodes = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/temperature/nodes');
      const data: TemperatureNodeRow[] = response.data?.data ?? [];
      setNodes(data);
      setTotal(data.length);
      setSearched(true);
    } catch {
      toast.error('노드 현황 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (mode !== 'nodes' || nodes.length > 0) return;
    void loadNodes();
  }, [mode, nodes.length, loadNodes]);

  const search = useCallback(async () => {
    if (mode === 'nodes') return loadNodes();
    setLoading(true);
    try {
      if (mode === 'raw') {
        if (!nodeId.trim()) {
          toast.error('노드를 고르세요. 원시데이터는 노드 없이 조회할 수 없습니다.');
          return;
        }
        const response = await api.get('/quality/temperature/raw', {
          params: { nodeId, dateFrom, dateTo, ngOnly: ngOnly ? 'true' : undefined },
        });
        setRaw(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
        setSelectedRaw(null);
      } else {
        const response = await api.get('/quality/temperature/checks', {
          params: {
            dateFrom, dateTo,
            machineCode: machineCode || undefined,
            confirmYn: confirmYn || undefined,
          },
        });
        setChecks(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
        setSelectedCheck(null);
      }
      setSearched(true);
    } catch {
      toast.error('조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mode, nodeId, dateFrom, dateTo, ngOnly, machineCode, confirmYn, loadNodes]);

  const changeMode = useCallback((next: Mode) => {
    setMode(next);
    setTotal(0);
    setSearched(false);
    setSelectedRaw(null);
    setSelectedCheck(null);
    if (next === 'raw') setRaw([]);
    if (next === 'checks') setChecks([]);
  }, []);

  /** 이상 점검 등록 — 원시데이터에서 고른 행이 있으면 그 노드·수집일시를 채운다 */
  const openCreate = useCallback(() => {
    const form = mode === 'raw' && selectedRaw
      ? emptyTemperatureCheckForm(selectedRaw.nodeId, selectedRaw.gatherDate)
      : emptyTemperatureCheckForm(mode === 'raw' ? nodeId : '');
    setPanel({ mode: 'create', form });
  }, [mode, selectedRaw, nodeId]);

  const removeCheck = useCallback(async () => {
    if (!selectedCheck) return;
    setDeleteOpen(false);
    try {
      await api.delete('/quality/temperature/checks', {
        data: { machineCode: selectedCheck.machineCode, checkSequence: selectedCheck.checkSequence },
      });
      toast.success('삭제되었습니다.');
      void search();
    } catch {
      toast.error('삭제에 실패했습니다.');
    }
  }, [selectedCheck, search]);

  const afterSave = useCallback(() => {
    setPanel(null);
    if (mode === 'checks') void search();
  }, [mode, search]);

  const nodeCols = useMemo(() => temperatureNodeColumns, []);
  const rawCols = useMemo(() => temperatureRawColumns, []);
  const checkCols = useMemo(() => temperatureCheckColumns, []);
  const shown = mode === 'nodes' ? nodes.length : mode === 'raw' ? raw.length : checks.length;

  return (
    <div className="flex h-full">
      <main className="flex h-full min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <Thermometer className="h-6 w-6 text-primary" />온도상태조회
            </h1>
            <p className="mt-1 text-sm text-text-muted">
              설비별 온습도 현황과 기준초과 이력을 조회합니다 ·{' '}
              {searched ? `${shown}/${total}건` : '조회 버튼을 누르세요'}
            </p>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            {mode === 'checks' && (
              <>
                <Button size="sm" variant="secondary" disabled={!selectedCheck}
                  onClick={() => selectedCheck && setPanel({ mode: 'edit', form: toTemperatureCheckForm(selectedCheck) })}>
                  <Edit2 className="mr-1 h-4 w-4" />수정
                </Button>
                <Button size="sm" variant="secondary" disabled={!selectedCheck}
                  onClick={() => setDeleteOpen(true)}>
                  <Trash2 className="mr-1 h-4 w-4 text-red-500" />삭제
                </Button>
              </>
            )}
            {mode !== 'nodes' && (
              <Button size="sm" onClick={openCreate}>
                <Plus className="mr-1 h-4 w-4" />이상 점검 등록
              </Button>
            )}
          </div>
        </header>

        <ScreenTabs
          tabs={[
            { key: 'nodes', label: '노드현황' },
            { key: 'raw', label: '원시데이터' },
            { key: 'checks', label: '점검이력' },
          ]}
          active={mode}
          onChange={changeMode}
        />

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            {mode === 'raw' && (
              <>
                <label className="text-xs text-text-muted">
                  노드ID (필수)
                  <Input value={nodeId} className="w-48" placeholder="노드현황에서 고르세요"
                    onChange={(e) => setNodeId(e.target.value)} />
                </label>
                <DateRangeFilter label="수집일" from={dateFrom} to={dateTo}
                  onFromChange={setDateFrom} onToChange={setDateTo} />
                <label className="flex items-center gap-1 self-end text-sm text-text">
                  <input type="checkbox" checked={ngOnly}
                    onChange={(e) => setNgOnly(e.target.checked)} />
                  기준초과만
                </label>
              </>
            )}
            {mode === 'checks' && (
              <>
                <DateRangeFilter label="확인일" from={dateFrom} to={dateTo}
                  onFromChange={setDateFrom} onToChange={setDateTo} />
                <EquipSelect labelPrefix="설비" value={machineCode} onChange={setMachineCode} className="w-44" />
                <ComCodeSelect groupCode="CONFIRM YN" labelPrefix="확인"
                  value={confirmYn} onChange={setConfirmYn} className="w-40" />
              </>
            )}
            {mode === 'nodes' && (
              <span className="text-sm text-text-muted">
                조회조건이 없습니다. 행을 클릭하면 그 노드의 원시데이터로 넘어갑니다.
              </span>
            )}
          </CardContent>
        </Card>

        <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            {mode === 'nodes' && (
              <DataGrid
                data={nodes}
                columns={nodeCols}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="온도노드현황"
                emptyMessage="노드 현황이 없습니다."
                onRowClick={(row) => {
                  // 노드를 고르면 원시데이터 탭으로 넘어간다 (필수 조건을 채워 준다)
                  setNodeId((row as TemperatureNodeRow).nodeId);
                  setMode('raw');
                  setRaw([]);
                  setSearched(false);
                }}
                getRowId={(row) => (row as TemperatureNodeRow).nodeId}
              />
            )}
            {mode === 'raw' && (
              <DataGrid
                data={raw}
                columns={rawCols}
                isLoading={loading}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="온습도원시데이터"
                emptyMessage="노드를 고르고 조회 버튼을 누르세요."
                onRowClick={(row) => setSelectedRaw(row as TemperatureRawRow)}
                rowClassName={(row) =>
                  (row as TemperatureRawRow).ngYn === 'Y'
                    ? 'bg-red-50 dark:bg-red-950/20'
                    : ''}
                getRowId={(row) => {
                  const r = row as TemperatureRawRow;
                  return `${r.nodeId}|${String(r.gatherDate ?? '')}`;
                }}
              />
            )}
            {mode === 'checks' && (
              <DataGrid
                data={checks}
                columns={checkCols}
                isLoading={loading}
                pageSize={50}
                enableColumnFilter
                enableExport
                exportFileName="온도점검이력"
                emptyMessage="조회 버튼을 눌러 점검이력을 확인하세요."
                onRowClick={(row) => setSelectedCheck(row as TemperatureCheckRow)}
                getRowId={(row) => {
                  const c = row as TemperatureCheckRow;
                  return `${c.machineCode}|${c.checkSequence}`;
                }}
              />
            )}
          </CardContent>
        </Card>
      </main>

      {panel && (
        <TemperatureCheckFormPanel
          key={`${panel.mode}-${panel.form.machineCode}-${panel.form.checkSequence ?? 'new'}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={afterSave}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={removeCheck}
        title="이상 점검이력 삭제"
        message={selectedCheck ? `점검항번 ${selectedCheck.checkSequence} 이력을 삭제할까요?` : ''}
        variant="danger"
      />
    </div>
  );
}
