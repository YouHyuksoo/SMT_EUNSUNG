"use client";

/**
 * @file src/app/(authenticated)/report/machine/page.tsx
 * @description 설비리포트 — PB w_mcn_machine_rpt 이식
 *
 * 초보자 가이드:
 * 1. **두 갈래로 본다.** 설비 마스터(무엇이 있나)와 일일가동(언제 얼마나 돌았나)이다.
 * 2. **가동 기록이 없는 설비도 남는다.** 외부조인으로 붙여서 '기록 없음' 으로 보인다 —
 *    가동 기록이 빠진 설비를 찾는 것이 이 리포트의 목적이기 때문이다. 기간·상태
 *    조건을 WHERE 에 두면 그 설비가 사라져 버린다.
 * 3. **IMCN_MACHINE_DAILY_OPERATION 은 현재 1행뿐이다** (실측). 표가 비어 보이는
 *    것은 조건이 틀린 게 아니라 설비 인터페이스가 아직 이 표를 채우지 않기 때문이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { machineColumns, machineOperationColumns } from '../report-columns';
import type { MachineOperationRow, MachineRow } from '../report-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'master' | 'operation';

export default function MachineReportPage() {
  const [machineCode, setMachineCode] = useState('');
  const [machineType, setMachineType] = useState('');
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));

  const [tab, setTab] = useState<Tab>('master');
  const [machines, setMachines] = useState<MachineRow[]>([]);
  const [operations, setOperations] = useState<MachineOperationRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const base = {
        machineCode: machineCode || undefined,
        machineType: machineType || undefined,
      };
      const [m, o] = await Promise.all([
        api.get('/report/machine', { params: base }),
        api.get('/report/machine/operation', { params: { ...base, dateFrom, dateTo } }),
      ]);
      setMachines(m.data?.data ?? []);
      setOperations(o.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '설비리포트 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [machineCode, machineType, dateFrom, dateTo]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const withRecord = operations.filter((r) => r.planDate).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">설비리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          설비 마스터와 일일가동 이력을 뽑습니다 ·{' '}
          {searched
            ? `설비 ${machines.length}대 · 기간 내 가동기록 ${withRecord}건`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="설비코드" placeholder="설비코드" value={machineCode} className="w-40"
            onChange={(e) => setMachineCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ComCodeSelect groupCode="MACHINE TYPE" labelPrefix="설비유형" value={machineType}
            onChange={setMachineType} className="w-52" />
          <DateRangeFilter label="가동일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'master', label: '설비 마스터', count: machines.length },
          { key: 'operation', label: '일일가동', count: operations.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'master' ? (
            <DataGrid
              data={machines}
              columns={machineColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="설비마스터"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['machineCode'] }}
              emptyMessage={searched ? '조건에 맞는 설비가 없습니다.' : '조회하세요.'}
              getRowId={(row) => (row as MachineRow).machineCode}
            />
          ) : (
            <DataGrid
              data={operations}
              columns={machineOperationColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="설비일일가동"
              emptyMessage={searched
                ? '조건에 맞는 설비가 없습니다.'
                : '조회하세요.'}
              rowClassName={(row) => ((row as MachineOperationRow).planDate
                ? ''
                : 'text-text-muted')}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
