'use client';

/**
 * @file (authenticated)/oee/equip-ops-analysis/page.tsx
 * @description 설비별 운영 현황 및 분석 — 설비별 실적 집계 + 작업지시/비가동 상세 (Mock-up, 실 DB 미연결)
 *
 * 지표 계산식(참고, 시드에 계산완료값 입력):
 *  - 계획달성율 = 실적수량 / 계획수량 × 100
 *  - 가동율   = 총작업시간 / (표준근무시간 − 설비비가동시간)
 *  - 성능율   = (표준CT × 실적수량) / 총작업시간
 *  - 양품율   = 양품수량 / 실적수량
 *  - OEE종합지수 = 가동율 × 성능율 × 양품율
 */
import { useMemo, useState } from 'react';
import type { ColumnDef } from '@tanstack/react-table';
import { Search, Activity } from 'lucide-react';
import { Card, CardContent, Input } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';

// 하단 좌측 — 작업지시서 현황
interface WorkOrderRow { woNo: string; itemNo: string; planQty: number; resultQty: number; tt: number; actualTt: number; }
// 하단 우측 — 설비 비가동 현황
interface DowntimeRow { reasonName: string; startTime: string; endTime: string; totalIdleSec: number; breakSec: number; }

// 상단 — 설비별 실적 집계 현황 (행별 상세 포함)
interface OpsAgg {
  id: number;
  machineCode: string; machineName: string; lineCode: string; lineName: string;
  planDate: string; week: string; shift: string; startTime: string; endTime: string;
  planQty: number; resultQty: number; defectQty: number; achieveRate: number;
  totalWorkSec: number; netWorkSec: number; breakSec: number; downPlanSec: number; downUnplanSec: number;
  workers: number; uph: number; upd: number;
  availability: number; performance: number; quality: number; oee: number; // %
  workOrders: WorkOrderRow[];
  downtimes: DowntimeRow[];
}

const SEED: OpsAgg[] = [
  {
    id: 1, machineCode: 'E01', machineName: '마운터 B라인 1호기', lineCode: '02', lineName: 'B라인',
    planDate: '2026-07-27', week: '2026-W30', shift: '주간', startTime: '08:00', endTime: '17:00',
    planQty: 500, resultQty: 480, defectQty: 8, achieveRate: 96.0,
    totalWorkSec: 28800, netWorkSec: 25200, breakSec: 1800, downPlanSec: 900, downUnplanSec: 900,
    workers: 3, uph: 60, upd: 480, availability: 92.5, performance: 88.0, quality: 98.3, oee: 80.0,
    workOrders: [
      { woNo: 'WO-2607-001', itemNo: 'DN8-PE', planQty: 300, resultQty: 290, tt: 12.5, actualTt: 13.1 },
      { woNo: 'WO-2607-011', itemNo: 'MV-PRA', planQty: 200, resultQty: 190, tt: 11.0, actualTt: 11.8 },
    ],
    downtimes: [
      { reasonName: '모델 교체', startTime: '10:20', endTime: '10:35', totalIdleSec: 900, breakSec: 0 },
      { reasonName: '자재 대기', startTime: '14:00', endTime: '14:15', totalIdleSec: 900, breakSec: 0 },
    ],
  },
  {
    id: 2, machineCode: 'E02', machineName: '스크린프린터 A라인', lineCode: '01', lineName: 'A라인',
    planDate: '2026-07-27', week: '2026-W30', shift: '야간', startTime: '20:00', endTime: '05:00',
    planQty: 300, resultQty: 300, defectQty: 2, achieveRate: 100.0,
    totalWorkSec: 27000, netWorkSec: 24600, breakSec: 1200, downPlanSec: 600, downUnplanSec: 600,
    workers: 2, uph: 45, upd: 300, availability: 95.2, performance: 90.5, quality: 99.3, oee: 85.6,
    workOrders: [
      { woNo: 'WO-2607-002', itemNo: 'MV-PRA', planQty: 300, resultQty: 300, tt: 8.0, actualTt: 8.4 },
    ],
    downtimes: [
      { reasonName: '청소/5S', startTime: '00:00', endTime: '00:10', totalIdleSec: 600, breakSec: 0 },
      { reasonName: '설비 고장', startTime: '02:30', endTime: '02:40', totalIdleSec: 600, breakSec: 0 },
    ],
  },
  {
    id: 3, machineCode: 'E03', machineName: 'AOI A라인', lineCode: '01', lineName: 'A라인',
    planDate: '2026-07-26', week: '2026-W30', shift: '주간', startTime: '08:00', endTime: '17:00',
    planQty: 200, resultQty: 150, defectQty: 5, achieveRate: 75.0,
    totalWorkSec: 28800, netWorkSec: 21600, breakSec: 1800, downPlanSec: 1800, downUnplanSec: 3600,
    workers: 1, uph: 20, upd: 150, availability: 81.3, performance: 78.0, quality: 96.7, oee: 61.3,
    workOrders: [
      { woNo: 'WO-2607-003', itemNo: 'SM200', planQty: 200, resultQty: 150, tt: 15.0, actualTt: 17.2 },
    ],
    downtimes: [
      { reasonName: '설비 고장', startTime: '11:00', endTime: '12:00', totalIdleSec: 3600, breakSec: 0 },
      { reasonName: '청소/5S', startTime: '15:00', endTime: '15:30', totalIdleSec: 1800, breakSec: 0 },
    ],
  },
  {
    id: 4, machineCode: 'E04', machineName: 'SPI A라인', lineCode: '01', lineName: 'A라인',
    planDate: '2026-07-27', week: '2026-W30', shift: '주간', startTime: '08:00', endTime: '17:00',
    planQty: 800, resultQty: 790, defectQty: 10, achieveRate: 98.8,
    totalWorkSec: 28800, netWorkSec: 26400, breakSec: 1800, downPlanSec: 300, downUnplanSec: 300,
    workers: 3, uph: 99, upd: 790, availability: 97.9, performance: 92.0, quality: 98.7, oee: 88.9,
    workOrders: [
      { woNo: 'WO-2607-004', itemNo: 'N91H00', planQty: 800, resultQty: 790, tt: 6.5, actualTt: 6.7 },
    ],
    downtimes: [
      { reasonName: '모델 교체', startTime: '09:30', endTime: '09:35', totalIdleSec: 300, breakSec: 0 },
      { reasonName: '자재 대기', startTime: '13:10', endTime: '13:15', totalIdleSec: 300, breakSec: 0 },
    ],
  },
  {
    id: 5, machineCode: 'E05', machineName: 'ICT 1호기', lineCode: '26', lineName: 'ICT라인',
    planDate: '2026-07-25', week: '2026-W30', shift: '야간', startTime: '20:00', endTime: '05:00',
    planQty: 150, resultQty: 60, defectQty: 1, achieveRate: 40.0,
    totalWorkSec: 27000, netWorkSec: 12000, breakSec: 1200, downPlanSec: 1800, downUnplanSec: 12000,
    workers: 1, uph: 8, upd: 60, availability: 55.6, performance: 70.0, quality: 98.3, oee: 38.2,
    workOrders: [
      { woNo: 'WO-2607-005', itemNo: 'X9800', planQty: 150, resultQty: 60, tt: 20.0, actualTt: 24.5 },
    ],
    downtimes: [
      { reasonName: '설비 고장', startTime: '21:00', endTime: '00:20', totalIdleSec: 12000, breakSec: 0 },
      { reasonName: '청소/5S', startTime: '03:00', endTime: '03:30', totalIdleSec: 1800, breakSec: 0 },
    ],
  },
  {
    id: 6, machineCode: 'E01', machineName: '마운터 B라인 1호기', lineCode: '02', lineName: 'B라인',
    planDate: '2026-07-24', week: '2026-W29', shift: '주간', startTime: '08:00', endTime: '17:00',
    planQty: 450, resultQty: 450, defectQty: 3, achieveRate: 100.0,
    totalWorkSec: 28800, netWorkSec: 26100, breakSec: 1800, downPlanSec: 450, downUnplanSec: 450,
    workers: 2, uph: 56, upd: 450, availability: 96.9, performance: 90.0, quality: 99.3, oee: 86.6,
    workOrders: [
      { woNo: 'WO-2607-006', itemNo: 'DN8-PE', planQty: 450, resultQty: 450, tt: 12.5, actualTt: 12.9 },
    ],
    downtimes: [
      { reasonName: '모델 교체', startTime: '10:00', endTime: '10:07', totalIdleSec: 450, breakSec: 0 },
      { reasonName: '자재 대기', startTime: '15:20', endTime: '15:27', totalIdleSec: 450, breakSec: 0 },
    ],
  },
];

const pct = (v: number) => `${v.toFixed(1)}%`;
const num = (v: number) => v.toLocaleString();

export default function EquipOpsAnalysisPage() {
  const [equipSearch, setEquipSearch] = useState('');
  const [dateFrom, setDateFrom] = useState('2026-07-20');
  const [dateTo, setDateTo] = useState('2026-07-31');
  const [selectedId, setSelectedId] = useState<number | null>(SEED[0]?.id ?? null);

  const filtered = useMemo(() => {
    const q = equipSearch.trim().toLowerCase();
    return SEED.filter((r) => {
      if (q && !(`${r.machineCode} ${r.machineName}`.toLowerCase().includes(q))) return false;
      if (dateFrom && r.planDate < dateFrom) return false;
      if (dateTo && r.planDate > dateTo) return false;
      return true;
    });
  }, [equipSearch, dateFrom, dateTo]);

  const selected = useMemo(() => SEED.find((r) => r.id === selectedId) ?? null, [selectedId]);

  const columns = useMemo<ColumnDef<OpsAgg>[]>(() => {
    const n = (key: keyof OpsAgg, header: string, size = 90) => ({
      accessorKey: key as string, header, size,
      meta: { align: 'right' as const, filterType: 'none' as const },
      cell: ({ getValue }: { getValue: () => unknown }) => <span className="font-mono">{num(Number(getValue()))}</span>,
    });
    const p = (key: keyof OpsAgg, header: string, size = 80) => ({
      accessorKey: key as string, header, size,
      meta: { align: 'right' as const, filterType: 'none' as const },
      cell: ({ getValue }: { getValue: () => unknown }) => <span className="font-mono">{pct(Number(getValue()))}</span>,
    });
    return [
      { accessorKey: 'machineCode', header: '설비코드', size: 80, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
      { accessorKey: 'machineName', header: '설비명', size: 150 },
      { accessorKey: 'lineCode', header: '라인코드', size: 80, meta: { align: 'center' as const } },
      { accessorKey: 'lineName', header: '라인명', size: 90 },
      { accessorKey: 'planDate', header: '계획일', size: 100, cell: ({ getValue }) => <span className="font-mono text-text-muted">{String(getValue() ?? '')}</span> },
      { accessorKey: 'week', header: '주차', size: 90, meta: { align: 'center' as const } },
      { accessorKey: 'shift', header: '교대조', size: 70, meta: { align: 'center' as const } },
      { accessorKey: 'startTime', header: '시작시간', size: 80, meta: { align: 'center' as const } },
      { accessorKey: 'endTime', header: '종료시간', size: 80, meta: { align: 'center' as const } },
      n('planQty', '계획수량'),
      n('resultQty', '실적수량'),
      n('defectQty', '불량수량'),
      p('achieveRate', '계획달성율'),
      n('totalWorkSec', '총작업시간(초)', 100),
      n('netWorkSec', '순작업시간(초)', 100),
      n('breakSec', '휴식시간(초)', 90),
      n('downPlanSec', '비가동계획(초)', 100),
      n('downUnplanSec', '비가동비계획(초)', 110),
      n('workers', '투입인원', 70),
      n('uph', 'UPH', 60),
      n('upd', 'UPD', 70),
      p('availability', '가동율'),
      p('performance', '성능율'),
      p('quality', '양품율'),
      {
        accessorKey: 'oee', header: 'OEE종합지수', size: 100,
        meta: { align: 'right' as const, filterType: 'none' as const },
        cell: ({ getValue }) => <span className={`font-mono font-bold ${Number(getValue()) >= 85 ? 'text-emerald-600' : Number(getValue()) >= 65 ? 'text-amber-600' : 'text-red-600'}`}>{pct(Number(getValue()))}</span>,
      },
    ];
  }, []);

  const woColumns = useMemo<ColumnDef<WorkOrderRow>[]>(() => [
    { accessorKey: 'woNo', header: '작업지시서번호', size: 130, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
    { accessorKey: 'itemNo', header: '품번', size: 90, cell: ({ getValue }) => <span className="font-mono">{String(getValue() ?? '')}</span> },
    { accessorKey: 'planQty', header: '계획수량', size: 80, meta: { align: 'right' as const }, cell: ({ getValue }) => <span className="font-mono">{num(Number(getValue()))}</span> },
    { accessorKey: 'resultQty', header: '실적수량', size: 80, meta: { align: 'right' as const }, cell: ({ getValue }) => <span className="font-mono">{num(Number(getValue()))}</span> },
    { accessorKey: 'tt', header: 'T/T', size: 70, meta: { align: 'right' as const }, cell: ({ getValue }) => <span className="font-mono">{Number(getValue()).toFixed(1)}</span> },
    { accessorKey: 'actualTt', header: '실적T/T', size: 80, meta: { align: 'right' as const }, cell: ({ getValue }) => <span className="font-mono">{Number(getValue()).toFixed(1)}</span> },
  ], []);

  const dtColumns = useMemo<ColumnDef<DowntimeRow>[]>(() => [
    { accessorKey: 'reasonName', header: '비가동 사유명', size: 130 },
    { accessorKey: 'startTime', header: '시작시간', size: 90, meta: { align: 'center' as const } },
    { accessorKey: 'endTime', header: '종료시간', size: 90, meta: { align: 'center' as const } },
    { accessorKey: 'totalIdleSec', header: '총 무작업시간(초)', size: 120, meta: { align: 'right' as const }, cell: ({ getValue }) => <span className="font-mono">{num(Number(getValue()))}</span> },
    { accessorKey: 'breakSec', header: '휴식시간(초)', size: 100, meta: { align: 'right' as const }, cell: ({ getValue }) => <span className="font-mono">{num(Number(getValue()))}</span> },
  ], []);

  return (
    <div className="h-full flex flex-col overflow-hidden p-6 gap-4">
      {/* 헤더 + 조회영역 */}
      <div className="flex items-center justify-between flex-shrink-0 gap-4 flex-wrap">
        <div>
          <h1 className="text-xl font-bold text-text flex items-center gap-2"><Activity className="w-6 h-6 text-primary" /> 설비별 운영 현황 및 분석</h1>
          <p className="text-sm text-text-muted mt-1">설비별 실적 집계 · 작업지시/비가동 상세 · OEE 분석 (Mock-up)</p>
        </div>
        <div className="flex items-end gap-2 flex-wrap">
          <label className="text-xs text-text-muted flex flex-col gap-1">설비코드
            <div className="w-48"><Input placeholder="설비코드 또는 설비명" value={equipSearch} onChange={(e) => setEquipSearch(e.target.value)} leftIcon={<Search className="w-4 h-4" />} fullWidth /></div>
          </label>
          <label className="text-xs text-text-muted flex flex-col gap-1">조회일자 (From)
            <input type="date" value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} className="border border-border rounded p-2 bg-background text-text text-sm h-10" />
          </label>
          <label className="text-xs text-text-muted flex flex-col gap-1">조회일자 (To)
            <input type="date" value={dateTo} onChange={(e) => setDateTo(e.target.value)} className="border border-border rounded p-2 bg-background text-text text-sm h-10" />
          </label>
        </div>
      </div>

      {/* 본문: 상단 70% / 하단 30% */}
      <div className="flex-1 min-h-0 flex flex-col gap-4">
        {/* 상단 — 설비별 실적 집계 현황 (70%) */}
        <Card className="flex-[7] min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-3 flex flex-col gap-2">
            <div className="text-sm font-semibold text-text flex-shrink-0">설비별 실적 집계 현황</div>
            <div className="flex-1 min-h-0">
              <DataGrid
                data={filtered}
                columns={columns}
                pageSize={50}
                enableColumnFilter={false}
                enableExport
                exportFileName="설비별운영현황"
                getRowId={(r) => String(r.id)}
                selectedRowId={selectedId != null ? String(selectedId) : undefined}
                onRowClick={(r) => setSelectedId(r.id)}
                emptyMessage="조회 결과가 없습니다"
              />
            </div>
          </CardContent>
        </Card>

        {/* 하단 — 좌: 작업지시서 / 우: 비가동 (30%) */}
        <div className="flex-[3] min-h-0 flex gap-4">
          <Card className="flex-1 min-w-0 overflow-hidden" padding="none">
            <CardContent className="h-full p-3 flex flex-col gap-2">
              <div className="text-sm font-semibold text-text flex-shrink-0">작업지시서 현황 {selected && <span className="text-text-muted font-normal">— {selected.machineCode} · {selected.machineName}</span>}</div>
              <div className="flex-1 min-h-0">
                <DataGrid data={selected?.workOrders ?? []} columns={woColumns} pageSize={100} enableColumnFilter={false} enableFullscreen={false} showFooter={false} getRowId={(r) => r.woNo} emptyMessage="상단에서 설비를 선택하세요" />
              </div>
            </CardContent>
          </Card>
          <Card className="flex-1 min-w-0 overflow-hidden" padding="none">
            <CardContent className="h-full p-3 flex flex-col gap-2">
              <div className="text-sm font-semibold text-text flex-shrink-0">설비 비가동 현황 {selected && <span className="text-text-muted font-normal">— {selected.machineCode} · {selected.machineName}</span>}</div>
              <div className="flex-1 min-h-0">
                <DataGrid data={selected?.downtimes ?? []} columns={dtColumns} pageSize={100} enableColumnFilter={false} enableFullscreen={false} showFooter={false} getRowId={(r) => `${r.reasonName}-${r.startTime}`} emptyMessage="상단에서 설비를 선택하세요" />
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
