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
 * 4. 조회 전용 화면이다. PB 에도 저장 경로가 없다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search, Thermometer } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import EquipSelect from '@/components/shared/EquipSelect';
import api from '@/services/api';
import {
  temperatureCheckColumns,
  temperatureNodeColumns,
  temperatureRawColumns,
  type TemperatureCheckRow,
  type TemperatureNodeRow,
  type TemperatureRawRow,
} from '../qc-columns';

type Mode = 'nodes' | 'raw' | 'checks';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const weekAgo = () => {
  const date = new Date();
  date.setDate(date.getDate() - 7);
  return isoDate(date);
};

export default function TemperaturePage() {
  const [mode, setMode] = useState<Mode>('nodes');
  const [nodes, setNodes] = useState<TemperatureNodeRow[]>([]);
  const [raw, setRaw] = useState<TemperatureRawRow[]>([]);
  const [checks, setChecks] = useState<TemperatureCheckRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [nodeId, setNodeId] = useState('');
  const [dateFrom, setDateFrom] = useState(weekAgo);
  const [dateTo, setDateTo] = useState(today);
  const [ngOnly, setNgOnly] = useState(false);
  const [machineCode, setMachineCode] = useState('');
  const [confirmYn, setConfirmYn] = useState('');

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
    if (next === 'raw') setRaw([]);
    if (next === 'checks') setChecks([]);
  }, []);

  const nodeCols = useMemo(() => temperatureNodeColumns, []);
  const rawCols = useMemo(() => temperatureRawColumns, []);
  const checkCols = useMemo(() => temperatureCheckColumns, []);
  const shown = mode === 'nodes' ? nodes.length : mode === 'raw' ? raw.length : checks.length;

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
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
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

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

      <nav className="flex gap-1 border-b border-border" aria-label="조회 모드">
        {([['nodes', '노드현황'], ['raw', '원시데이터'], ['checks', '점검이력']] as const)
          .map(([key, label]) => (
            <button
              key={key}
              type="button"
              onClick={() => changeMode(key)}
              className={`px-3 py-1.5 text-sm ${
                mode === key
                  ? 'border-b-2 border-primary font-semibold text-text'
                  : 'text-text-muted'
              }`}
            >
              {label}
            </button>
          ))}
      </nav>

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
              getRowId={(row) => {
                const c = row as TemperatureCheckRow;
                return `${c.machineCode}|${c.checkSequence}`;
              }}
            />
          )}
        </CardContent>
      </Card>
    </main>
  );
}
