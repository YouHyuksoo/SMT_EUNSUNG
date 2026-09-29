"use client";

/**
 * @file src/app/(authenticated)/query/pid-info/page.tsx
 * @description PID 정보조회 — PB w_pln_product_barcode_query 이식
 *
 * 초보자 가이드:
 * 1. **PID(2D 바코드) 한 장의 모든 정보를 본다.** Run No·모델·매거진·박스·출하시각까지
 *    한 줄에 들어 있다.
 * 2. **조건 하나는 반드시 넣어야 한다.** Run No · PID · 매거진 중 하나다.
 *    이 표는 1.8억행이고 이 화면에는 날짜 조건이 없다 — 조건 없이 열면 화면이
 *    아니라 DB 가 멈춘다. 모델·라인만으로는 열리지 않는다 (선택도가 낮다).
 * 3. **'X-OUT 해제' 는 쓰기다** (PB 'X-OUT Repair'). X-OUT 불량으로 잡힌 PID 를
 *    되살린다. X-OUT 열에 숫자가 있는 행만 누를 수 있다.
 * 4. **해제하면 2D바코드 메모에 누가 언제 풀었는지 남는다.** PB 는 화면에만 띄우고
 *    아무 곳에도 적지 않아 나중에 추적할 수 없었다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Search, Wrench } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import { checkTrackingFilter } from '@smt/shared';
import api from '@/services/api';
import { pidInfoColumns } from '../query-columns';
import type { PidInfoRow } from '../query-types';

export default function PidInfoQueryPage() {
  const [runNo, setRunNo] = useState('');
  const [serialNo, setSerialNo] = useState('');
  const [magazineNo, setMagazineNo] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');

  const [rows, setRows] = useState<PidInfoRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [selected, setSelected] = useState<PidInfoRow | null>(null);
  const [repairOpen, setRepairOpen] = useState(false);
  const [repairNote, setRepairNote] = useState('');
  const [busy, setBusy] = useState(false);

  // 백엔드와 같은 함수로 판정한다 — 규칙을 두 곳에 두면 한쪽만 고쳐진다.
  const verdict = checkTrackingFilter({ runNo, serialNo, magazineNo });

  const search = useCallback(async () => {
    setLoading(true);
    setSelected(null);
    try {
      const response = await api.get('/query/pid-info', {
        params: {
          runNo: runNo || undefined,
          serialNo: serialNo || undefined,
          magazineNo: magazineNo || undefined,
          lineCode: lineCode || undefined,
          modelName: modelName || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'PID 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [runNo, serialNo, magazineNo, lineCode, modelName]);

  const repair = useCallback(async () => {
    if (!selected) return;
    setRepairOpen(false);
    setBusy(true);
    try {
      const response = await api.delete('/query/pid-info/x-out', {
        data: { serialNo: selected.serialNo, comments: repairNote || undefined },
      });
      const deleted = Number(response.data?.data?.deleted ?? 0);
      if (deleted === 0) {
        toast.success(`${selected.serialNo} 에 X-OUT 불량이 없었습니다 (지운 것 없음).`);
      } else {
        toast.success(`${selected.serialNo} 의 X-OUT 불량 ${deleted}건을 해제했습니다.`);
      }
      setRepairNote('');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'X-OUT 해제에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, repairNote, search]);

  const canRepair = Boolean(selected) && Number(selected?.xOutCount ?? 0) > 0;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">PID 정보조회</h1>
          <p className="mt-1 text-sm text-text-muted">
            2D 바코드 한 장의 생산·출하 정보를 봅니다 ·{' '}
            {searched ? `${rows.length}건` : '조건을 넣고 조회하세요'}
            {selected ? ` · 선택 ${selected.serialNo}` : ''}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={search} disabled={!verdict.ok || loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" variant="secondary" disabled={!canRepair || busy}
            onClick={() => setRepairOpen(true)}>
            <Wrench className="mr-1 h-4 w-4" />X-OUT 해제
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="Run No" placeholder="Run No" value={runNo} className="w-40"
            onChange={(e) => setRunNo(e.target.value)} />
          <Input aria-label="PID" placeholder="PID (2D 바코드)" value={serialNo} className="w-48"
            onChange={(e) => setSerialNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter' && verdict.ok) void search(); }} />
          <Input aria-label="매거진" placeholder="매거진" value={magazineNo} className="w-36"
            onChange={(e) => setMagazineNo(e.target.value)} />
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName} className="w-40"
            onChange={(v) => setModelName(v)} />
          {/* X-OUT 해제 메모. PB 는 sle_message 를 화면에만 띄우고 저장하지 않았다 —
              여기서는 2D바코드 메모에 함께 남겨 누가 왜 풀었는지 추적할 수 있게 한다. */}
          <Input aria-label="X-OUT 해제 메모" placeholder="X-OUT 해제 메모"
            value={repairNote} className="w-56"
            onChange={(e) => setRepairNote(e.target.value)} />
          {!verdict.ok && (
            <span className="text-sm text-amber-500">{verdict.reason}</span>
          )}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={pidInfoColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="PID정보"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['serialNo'] }}
            emptyMessage={searched ? '조건에 맞는 PID 가 없습니다.' : '조건을 넣고 조회하세요.'}
            onRowClick={(row) => setSelected(row as PidInfoRow)}
            rowClassName={(row) => {
              const r = row as PidInfoRow;
              if (r.serialNo === selected?.serialNo) return 'bg-primary/10';
              return Number(r.xOutCount ?? 0) > 0 ? 'bg-red-500/5' : '';
            }}
            getRowId={(row) => (row as PidInfoRow).serialNo}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={repairOpen}
        onClose={() => setRepairOpen(false)}
        onConfirm={repair}
        title="X-OUT 불량 해제"
        message={selected
          ? `PID ${selected.serialNo} 의 X-OUT 불량 ${selected.xOutCount}건을 지웁니다.`
            + ' 되돌릴 수 없습니다 — 해제 기록은 2D바코드 메모에 남습니다.'
          : ''}
        variant="danger"
      />
    </div>
  );
}
