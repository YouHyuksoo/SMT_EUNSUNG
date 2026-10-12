"use client";

/**
 * @file src/app/(authenticated)/production/daily-report/page.tsx
 * @description 생산일보 리포트 — PB w_pln_product_pcb_result_report 이식
 *
 * 초보자 가이드:
 * 1. **종합효율 = 시간가동률 × 성능가동률 × 양품률.** 세 값이 모두 옆에 있으니
 *    낮은 쪽이 어디인지 바로 보인다.
 *      시간가동률 = 실가동시간 / 가용시간      (가용 = 생산 - 휴게, 실가동 = 가용 - 로스)
 *      성능가동률 = 실적수량 / (실가동시간 × 캐리어)
 *      양품률     = 1 - 불량수량 / 실적수량
 * 2. **하루 단위다.** PB 도 기준일 하나를 받았다. 기준이 두 가지라 탭으로 고른다.
 *      작업지시일 — 롯트카드에 적힌 작업일(RUN_DATE)이 그 날
 *      실생산일   — 생산시작(PDA ON) 시각의 날짜가 그 날
 *    둘은 다른 집합이다. 전날 지시가 자정을 넘겨 생산되면 한쪽에만 잡힌다.
 * 3. **비율은 소수 한 자리다.** PB 는 정수로 끊었다. 55.4 와 54.6 이 같은 55 가 되면
 *    라인 간 비교가 무의미해지므로 한 자리를 남긴다 — 값이 다른 게 아니라 자리수다.
 * 4. **PB 의 프린터 라벨 레이아웃은 이관 범위 밖이다.** 목록을 내보내 쓴다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateFilter from '@/components/shared/DateFilter';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { dailyReportColumns } from '../planning-columns';
import type { DailyReportRow } from '../planning-types';

type Basis = 'run' | 'actual';

const BASES: Array<{ key: Basis; label: string; hint: string }> = [
  { key: 'run', label: '작업지시일 기준', hint: '롯트카드에 적힌 작업일로 묶는다' },
  { key: 'actual', label: '실생산일 기준', hint: '생산시작(PDA ON) 시각의 날짜로 묶는다' },
];

const today = () => new Date().toISOString().slice(0, 10);

export default function DailyReportPage() {
  const [basis, setBasis] = useState<Basis>('run');
  const [reportDate, setReportDate] = useState(today);
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [runNo, setRunNo] = useState('');

  const [rows, setRows] = useState<DailyReportRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/production/daily-report', {
        params: {
          reportDate,
          dateBasis: basis,
          lineCode: lineCode || undefined,
          modelName: modelName || undefined,
          runNo: runNo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('생산일보 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [reportDate, basis, lineCode, modelName, runNo]);

  /** 헤더 요약 — 실적·불량 합계와 종합효율 평균. 일보를 열면 먼저 보는 숫자다. */
  const summary = useMemo(() => {
    if (rows.length === 0) return null;
    const resultQty = rows.reduce((s, r) => s + Number(r.resultQty ?? 0), 0);
    const badQty = rows.reduce((s, r) => s + Number(r.badQty ?? 0), 0);
    // 종합효율은 실가동시간이 0 인 행(생산 안 한 작업지시)을 평균에서 뺀다 —
    // 넣으면 0 이 섞여 평균이 실제보다 낮게 나온다.
    const worked = rows.filter((r) => Number(r.actualTime ?? 0) > 0);
    const avg = worked.length === 0
      ? null
      : worked.reduce((s, r) => s + Number(r.overallEfficiency ?? 0), 0) / worked.length;
    return { resultQty, badQty, worked: worked.length, avg };
  }, [rows]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">생산일보 리포트</h1>
          <p className="mt-1 text-sm text-text-muted">
            {BASES.find((b) => b.key === basis)?.hint} ·{' '}
            {searched ? `${rows.length}/${total}건` : '기준일을 정하고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <div className="flex gap-1 border-b border-border">
        {BASES.map((b) => (
          <button
            key={b.key}
            type="button"
            onClick={() => setBasis(b.key)}
            className={`px-4 py-2 text-sm ${
              basis === b.key
                ? 'border-b-2 border-primary font-semibold text-text'
                : 'text-text-muted'
            }`}
          >
            {b.label}
          </button>
        ))}
      </div>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <label className="flex items-center gap-2 text-sm text-text-muted">
            기준일
            <DateFilter value={reportDate} onChange={setReportDate} />
          </label>
          <ProdLineSelect labelPrefix="라인" value={lineCode}
            onChange={setLineCode} className="w-56" />
          <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName}
            className="w-48" onChange={(v) => setModelName(v)} />
          <Input aria-label="작업지시번호" placeholder="작업지시번호" value={runNo}
            className="w-44" onChange={(e) => setRunNo(e.target.value)} />
        </CardContent>
      </Card>

      {summary && (
        <Card padding="none">
          <CardContent className="flex flex-wrap gap-6 p-4 text-sm">
            <div>
              <div className="text-text-muted">실적수량 합</div>
              <div className="text-lg font-semibold text-text">
                {summary.resultQty.toLocaleString()}
              </div>
            </div>
            <div>
              <div className="text-text-muted">불량수량 합</div>
              <div className="text-lg font-semibold text-text">
                {summary.badQty.toLocaleString()}
              </div>
            </div>
            <div>
              <div className="text-text-muted">
                종합효율 평균 <span className="text-xs">(가동한 {summary.worked}건)</span>
              </div>
              <div className="text-lg font-semibold text-text">
                {summary.avg === null ? '가동 없음' : `${summary.avg.toFixed(1)}%`}
              </div>
            </div>
            <div className="max-w-md text-xs text-text-muted">
              가동하지 않은 작업지시(실가동시간 0)는 종합효율 평균에서 뺐습니다 —
              넣으면 0 이 섞여 실제보다 낮게 나옵니다.
            </div>
          </CardContent>
        </Card>
      )}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={dailyReportColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="생산일보"
            emptyMessage="기준일을 정하고 조회 버튼을 누르세요."
            getRowId={(row) => {
              const r = row as DailyReportRow;
              return `${r.runNo}|${r.lineCode}`;
            }}
          />
        </CardContent>
      </Card>
    </div>
  );
}
