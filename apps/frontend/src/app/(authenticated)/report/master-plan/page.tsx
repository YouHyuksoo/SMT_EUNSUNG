"use client";

/**
 * @file src/app/(authenticated)/report/master-plan/page.tsx
 * @description 생산계획리포트 — PB w_pln_master_plan_rpt 이식
 *
 * 초보자 가이드:
 * 1. **하루치 생산계획을 시간대별로 펼쳐 본다.** 시간대 10칸은 **고정**이다 —
 *    생산 대분류의 MI/SMD 계획 화면과 같은 구조라 크로스탭이 아니다.
 * 2. **날짜는 하루다.** PB 도 등호로 걸었다 (기간이 아니다). 계획은 하루 단위로
 *    세우므로 여러 날을 겹쳐 보면 시간대 칸의 뜻이 사라진다.
 * 3. **0 은 흐리게 보여준다.** 10칸 대부분이 0 이라 숫자가 있는 칸이 눈에 들어와야 한다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import CustomerSelect from '@/components/shared/CustomerSelect';
import DateFilter from '@/components/shared/DateFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { useRunAfterRender } from '@/hooks/useRunAfterRender';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { masterPlanColumns } from '../report-columns';
import type { MasterPlanRow } from '../report-types';

const today = () => new Date().toISOString().slice(0, 10);

export default function MasterPlanReportPage() {
  const [planDate, setPlanDate] = useState(today());
  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [customerCode, setCustomerCode] = useState('');

  const [rows, setRows] = useState<MasterPlanRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/master-plan', {
        params: {
          planDate,
          modelName: modelName || undefined,
          lineCode: lineCode || undefined,
          customerCode: customerCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      mark(response);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '생산계획리포트 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [planDate, modelName, lineCode, customerCode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const totalPlan = rows.reduce((sum, r) => sum + Number(r.planQty ?? 0), 0);

  // 모델을 고르면 새 모델명으로 바로 조회한다 (Enter 조회를 대신함)
  const searchAfterModelSelect = useRunAfterRender(search);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">생산계획리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          하루치 생산계획을 시간대 10칸으로 펼쳐 봅니다 ·{' '}
          {searched
            ? `${rows.length}건 · 계획 합계 ${totalPlan.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="계획 합계" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          {/* PB 도 하루를 등호로 걸었다 — 기간 필터가 아니다. */}
          <label className="flex items-center gap-2 text-sm text-text">
            계획일
            <DateFilter value={planDate} onChange={setPlanDate} />
          </label>
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName} className="w-40"
            onChange={(v) => { setModelName(v); if (v) searchAfterModelSelect(); }} />
          <div className="w-44">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <div className="w-52">
            <CustomerSelect includeAll value={customerCode} onChange={setCustomerCode} />
          </div>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={masterPlanColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="생산계획"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['lineName', 'modelName'] }}
            emptyMessage={searched ? '그 날짜의 생산계획이 없습니다.' : '조회하세요.'}
          />
        </CardContent>
      </Card>
    </div>
  );
}
