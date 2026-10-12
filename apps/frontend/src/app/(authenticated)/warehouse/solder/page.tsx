"use client";

/**
 * @file src/app/(authenticated)/warehouse/solder/page.tsx
 * @description 솔더입출고조회 — PB w_mat_solder_receipt_issue_master 이식
 *
 * 초보자 가이드:
 * 1. **솔더 한 통의 생애를 쫓는 화면이다.** 입고(냉장고에 넣음) → 출고(꺼냄) →
 *    해동 → 교반 → 점도측정 → 라인투입 → 반납/폐기. 솔더는 굳으면 못 쓰므로
 *    **각 단계에 머문 시간**이 핵심이다.
 * 2. **위 표는 단계별로 몇 통이 멈춰 있나**를 보여준다 (설비·라인·종류별).
 *    투입대기가 쌓이면 굳기 전에 써야 한다는 뜻이다.
 * 3. **스캔으로 입고·출고를 한다** (쓰기). 입고는 자재 바코드 표에 있는 롯트만
 *    되고, 이미 입고된 롯트를 다시 입고하면 거절한다 — 같은 통이 두 번 등록되면
 *    단계 집계가 두 배로 잡힌다.
 * 4. **'지금 쓰이는 것만' 을 켜면 PB Running 탭과 같아진다** (꺼냈고 아직 버리지
 *    않은 통).
 * 5. **교반 소요시간은 PB 가 24시간을 버렸다.** 실측 최대 163시간이 `19:12` 로
 *    보였다 — 고쳤다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { PackageCheck, PackageOpen, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import api from '@/services/api';
import { solderColumns, solderStageCountColumns } from '../solder-columns';
import type {
  SolderRow,
  SolderScanResult,
  SolderStageCountRow,
} from '../warehouse-types';

const monthsAgo = (n: number) => {
  const d = new Date();
  d.setMonth(d.getMonth() - n);
  return d.toISOString().slice(0, 10);
};
const today = () => new Date().toISOString().slice(0, 10);

const TYPE_OPTIONS = [
  { value: '', label: '종류: 전체' },
  { value: 'F', label: '무연(F)' },
  { value: 'P', label: '유연(P)' },
];

export default function SolderPage() {
  const [dateFrom, setDateFrom] = useState(monthsAgo(3));
  const [dateTo, setDateTo] = useState(today());
  const [solderLotNo, setSolderLotNo] = useState('');
  const [itemBarcode, setItemBarcode] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [solderType, setSolderType] = useState('');
  const [runningOnly, setRunningOnly] = useState(false);

  const [stages, setStages] = useState<SolderStageCountRow[]>([]);
  const [rows, setRows] = useState<SolderRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  // 스캔(쓰기)
  const [scanLotNo, setScanLotNo] = useState('');
  const [scanType, setScanType] = useState<'R' | 'I'>('R');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        solderLotNo: solderLotNo || undefined,
        itemBarcode: itemBarcode || undefined,
        lineCode: lineCode || undefined,
        solderType: solderType || undefined,
        runningOnly,
      };
      const [s, l] = await Promise.all([
        api.get('/warehouse/solder/stage-counts'),
        api.get('/warehouse/solder', { params }),
      ]);
      setStages(s.data?.data ?? []);
      setRows(l.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '솔더 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, solderLotNo, itemBarcode, lineCode, solderType, runningOnly]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 입고·출고 스캔 (쓰기). 확인 모달을 거친다. */
  const scan = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const response = await api.post('/warehouse/solder/scan', {
        solderLotNo: scanLotNo.trim(),
        scanType,
      });
      const result = response.data?.data as SolderScanResult | undefined;
      toast.success(
        scanType === 'R'
          ? `입고했습니다: ${result?.solderLotNo} (품목 ${result?.itemCode})`
          : `출고했습니다: ${result?.solderLotNo}`,
      );
      setScanLotNo('');
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '스캔 처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [scanLotNo, scanType, search]);

  const totalStage = stages.reduce((sum, r) => sum
    + Number(r.refrigeratorCnt ?? 0) + Number(r.unfreezingCnt ?? 0)
    + Number(r.mixCnt ?? 0) + Number(r.viscosityWaitCnt ?? 0)
    + Number(r.inputWaitCnt ?? 0), 0);
  const expired = rows.filter((r) => Number(r.validCount ?? 1) < 0).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">솔더입출고조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          솔더 한 통의 입고부터 폐기까지를 봅니다 ·{' '}
          {searched
            ? `진행중 ${totalStage}통 · 목록 ${rows.length.toLocaleString()}건`
              + (expired > 0 ? ` · 유효기한 지남 ${expired}건` : '')
            : '조회하세요'}
        </p>
      </header>

      {/* 스캔(쓰기). 스캐너는 키보드처럼 입력되므로 입력칸에서 Enter 로 처리한다. */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="text-sm font-semibold text-text">스캔</span>
          <Input aria-label="솔더 롯트번호" placeholder="솔더 롯트번호를 찍으세요"
            value={scanLotNo} className="w-64"
            onChange={(e) => setScanLotNo(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter' && scanLotNo.trim()) setConfirmOpen(true);
            }} />
          <Button size="sm" variant={scanType === 'R' ? 'primary' : 'secondary'}
            onClick={() => setScanType('R')}>
            <PackageCheck className="mr-1 h-4 w-4" />입고 (냉장고에 넣음)
          </Button>
          <Button size="sm" variant={scanType === 'I' ? 'primary' : 'secondary'}
            onClick={() => setScanType('I')}>
            <PackageOpen className="mr-1 h-4 w-4" />출고 (꺼냄)
          </Button>
          <Button size="sm" disabled={busy || !scanLotNo.trim()}
            onClick={() => setConfirmOpen(true)}>
            처리
          </Button>
          <span className="text-sm text-text-muted">
            입고는 자재 바코드에 있는 롯트만 됩니다. 이미 입고된 롯트는 거절합니다.
          </span>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="입고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="솔더 롯트" placeholder="솔더 롯트" value={solderLotNo}
            className="w-44"
            onChange={(e) => setSolderLotNo(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="솔더 바코드" placeholder="솔더 바코드" value={itemBarcode}
            className="w-48"
            onChange={(e) => setItemBarcode(e.target.value)} />
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Select options={TYPE_OPTIONS} value={solderType} onChange={setSolderType}
            className="w-36" />
          <label className="flex items-center gap-2 text-sm text-text">
            <input type="checkbox" checked={runningOnly}
              onChange={(e) => setRunningOnly(e.target.checked)} />
            지금 쓰이는 것만
          </label>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      {/* 단계별 대기 수량 — 어디에 몇 통이 멈춰 있나 */}
      <Card className="shrink-0 overflow-hidden" padding="none">
        <CardContent className="p-3">
          <DataGrid
            data={stages}
            columns={solderStageCountColumns}
            isLoading={loading}
            pageSize={10}
            enableExport
            exportFileName="솔더_단계별현황"
            emptyMessage={searched ? '진행중인 솔더가 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={solderColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="솔더입출고"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['solderLotNo'] }}
            emptyMessage={searched ? '조건에 맞는 솔더가 없습니다.' : '조회하세요.'}
            rowClassName={(row) => (Number((row as SolderRow).validCount ?? 1) < 0
              ? 'bg-red-500/5'
              : '')}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={scan}
        title={scanType === 'R' ? '솔더 입고' : '솔더 출고'}
        message={scanType === 'R'
          ? `롯트 ${scanLotNo} 를 입고 처리합니다 (냉장고에 넣음).`
            + ' 자재 바코드에 없는 롯트이거나 이미 입고된 롯트면 거절됩니다.'
          : `롯트 ${scanLotNo} 를 출고 처리합니다 (냉장고에서 꺼냄).`
            + ' 꺼낸 시각부터 솔더 수명이 깎입니다.'}
      />
    </div>
  );
}
