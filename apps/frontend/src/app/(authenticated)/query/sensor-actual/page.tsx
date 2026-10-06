"use client";

/**
 * @file src/app/(authenticated)/query/sensor-actual/page.tsx
 * @description SMT 제품실적센서이력조회 — PB w_pln_product_sensor_actual_master 이식
 *
 * 초보자 가이드:
 * 1. **라인 끝 센서가 세는 생산 실적을 본다.** 네 갈래가 같은 값을 다른 단위로
 *    보여준다 — 현재 / 이력(일자 마감 후 백업) / 1시간 / 교대 시간대.
 * 2. **'실적 보정' 은 쓰기다** (PB 'Actual Adjust'). 센서가 잘못 센 수량을 손으로
 *    맞춘다. **실적수량·보정수량 두 컬럼만 바꾼다** — DataWindow 의 update=yes 를
 *    실측해 맞췄다.
 * 3. **키는 수집시각 + 순번이다** (실측 PK). 라인·공정으로 잡으면 같은 라인의 다른
 *    시점 실적까지 바뀐다. 보정 전후 값을 결과로 돌려받아 화면에 띄운다.
 * 4. **자동갱신이 있다** (PB Interval 기본 20초 / Start / Stop).
 * 5. **이력(백업) 탭에는 설비·작업자 칸이 비어 있다.** 백업 테이블에 그 컬럼이
 *    없다 (실측) — 화면이 숨기지 않고 비워 둔다.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import { useActiveInterval } from '@/hooks/useTabActive';
import toast from 'react-hot-toast';
import { Save, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateFilter from '@/components/shared/DateFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { AutoRefreshControl, QueryTabs } from '../components/QueryTabs';
import { sensorActualColumns, sensorBucketColumns } from '../query-columns';
import type { SensorActualRow, SensorBucketRow } from '../query-types';

const today = () => new Date().toISOString().slice(0, 10);

type Tab = 'current' | 'history' | 'hourly' | 'timeSlot';

export default function SensorActualPage() {
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [dateFrom, setDateFrom] = useState(today());

  const [tab, setTab] = useState<Tab>('current');
  const [current, setCurrent] = useState<SensorActualRow[]>([]);
  const [history, setHistory] = useState<SensorActualRow[]>([]);
  const [hourly, setHourly] = useState<SensorBucketRow[]>([]);
  const [timeSlot, setTimeSlot] = useState<SensorBucketRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const [selected, setSelected] = useState<SensorActualRow | null>(null);
  const [actualQty, setActualQty] = useState('');
  const [adjustQty, setAdjustQty] = useState('');
  const [busy, setBusy] = useState(false);

  const [intervalSec, setIntervalSec] = useState('20');
  const [autoOn, setAutoOn] = useState(false);

  const search = useCallback(async () => {
    if (!lineCode) return;
    setLoading(true);
    setSelected(null);
    try {
      const params = {
        lineCode,
        modelName: modelName || undefined,
        dateFrom: dateFrom || undefined,
      };
      const [c, h, hr, t] = await Promise.all([
        api.get('/query/sensor-actual/current', { params }),
        api.get('/query/sensor-actual/history', { params }),
        api.get('/query/sensor-actual/hourly', { params }),
        api.get('/query/sensor-actual/time-slot', { params }),
      ]);
      setCurrent(c.data?.data ?? []);
      setHistory(h.data?.data ?? []);
      setHourly(hr.data?.data ?? []);
      setTimeSlot(t.data?.data ?? []);
      mark(c, h, hr, t);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '센서 실적 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, modelName, dateFrom, mark]);

  const autoRef = useRef(search);
  autoRef.current = search;
  const autoSec = Math.max(5, Number(intervalSec) || 20);
  useActiveInterval(() => { void autoRef.current(); }, autoOn && lineCode ? autoSec * 1000 : null, { catchUp: true });

  const pick = useCallback((row: SensorActualRow) => {
    setSelected(row);
    setActualQty(row.productActualQty == null ? '' : String(row.productActualQty));
    setAdjustQty(row.adjustQty == null ? '' : String(row.adjustQty));
  }, []);

  const save = useCallback(async () => {
    if (!selected) return;
    setBusy(true);
    try {
      const response = await api.put('/query/sensor-actual/adjust', {
        receiptDateKey: selected.receiptDateKey,
        receiptSequence: selected.receiptSequence,
        productActualQty: actualQty === '' ? undefined : Number(actualQty),
        adjustQty: adjustQty === '' ? undefined : Number(adjustQty),
      });
      const data = response.data?.data;
      if (!data?.found) {
        toast.error('그 실적 행을 찾을 수 없었습니다 (수집시각·순번을 확인하세요).');
      } else {
        toast.success(
          `보정했습니다 — 실적 ${data.before?.productActualQty ?? 0}`
          + ` → ${data.after?.productActualQty ?? 0}`
          + ` · 보정 ${data.before?.adjustQty ?? 0} → ${data.after?.adjustQty ?? 0}`,
        );
      }
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '실적 보정에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, actualQty, adjustQty, search]);

  const rowKey = (r: SensorActualRow) => `${r.receiptDateKey}|${r.receiptSequence}`;
  const editable = tab === 'current';
  const rows = tab === 'current' ? current : history;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">SMT 제품실적센서이력조회</h1>
          <p className="mt-1 text-sm text-text-muted">
            라인 끝 센서가 센 생산 실적을 네 단위로 봅니다 ·{' '}
            {searched ? `현재 ${current.length}건` : '라인을 고르세요'}
            {autoOn && <span className="ml-1 text-primary">· 자동갱신 {intervalSec}초</span>}
          </p>
        </div>
        <AutoRefreshControl
          intervalSec={intervalSec}
          onIntervalChange={setIntervalSec}
          running={autoOn}
          onToggle={() => setAutoOn((v) => !v)}
          disabled={!lineCode}
        />
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <ModelSearchField aria-label="모델명" placeholder="모델명 (시간·시간대 탭)" value={modelName}
            className="w-52" onChange={(v) => setModelName(v)} />
          <label className="flex items-center gap-2 text-sm text-text">
            기준일
            <DateFilter value={dateFrom} onChange={setDateFrom} />
          </label>
          <Button size="sm" onClick={search} disabled={!lineCode || loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <QueryTabs
        tabs={[
          { key: 'current', label: '현재 실적', count: current.length },
          { key: 'history', label: '실적 이력', count: history.length },
          { key: 'hourly', label: '1시간 단위', count: hourly.length },
          { key: 'timeSlot', label: '시간대 단위', count: timeSlot.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {(tab === 'current' || tab === 'history') && (
            <DataGrid
              data={rows}
              columns={sensorActualColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={tab === 'current' ? '센서실적현재' : '센서실적이력'}
              emptyMessage={searched ? '이 라인에 실적이 없습니다.' : '라인을 고르세요.'}
              onRowClick={(row) => editable && pick(row as SensorActualRow)}
              rowClassName={(row) =>
                selected && rowKey(row as SensorActualRow) === rowKey(selected)
                  ? 'bg-primary/10' : ''}
              getRowId={(row) => rowKey(row as SensorActualRow)}
            />
          )}
          {tab === 'hourly' && (
            <DataGrid data={hourly} columns={sensorBucketColumns} isLoading={loading}
              pageSize={100} enableColumnFilter enableExport exportFileName="센서실적시간"
              emptyMessage={searched ? '이 기준일 이후 1시간 실적이 없습니다.' : '조회하세요.'} />
          )}
          {tab === 'timeSlot' && (
            <DataGrid data={timeSlot} columns={sensorBucketColumns} isLoading={loading}
              pageSize={100} enableColumnFilter enableExport exportFileName="센서실적시간대"
              emptyMessage={searched ? '이 기준일 이후 시간대 실적이 없습니다.' : '조회하세요.'} />
          )}
        </CardContent>
      </Card>

      {editable && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <b className="text-sm text-text">실적 보정</b>
            {selected ? (
              <span className="text-sm text-text-muted">
                {selected.receiptDate} · 순번 {selected.receiptSequence} ·{' '}
                {selected.workstageCode} · {selected.modelName ?? '-'}
              </span>
            ) : (
              <span className="text-sm text-text-muted">
                현재 실적 탭에서 행을 고르세요.
              </span>
            )}
            <label className="flex items-center gap-2 text-sm text-text">
              실적수량
              <Input aria-label="실적수량" value={actualQty} className="w-28"
                disabled={!selected}
                onChange={(e) => setActualQty(e.target.value.replace(/[^\d]/g, ''))} />
            </label>
            <label className="flex items-center gap-2 text-sm text-text">
              보정수량
              <Input aria-label="보정수량" value={adjustQty} className="w-28"
                disabled={!selected}
                onChange={(e) => setAdjustQty(e.target.value.replace(/[^-\d]/g, ''))} />
            </label>
            <Button size="sm" onClick={save} disabled={!selected || busy}>
              <Save className="mr-1 h-4 w-4" />보정
            </Button>
            <span className="text-sm text-text-muted">
              이 두 컬럼만 바뀝니다 · 보정 전후 값이 결과에 나옵니다
            </span>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
