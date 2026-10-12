"use client";

/**
 * @file src/app/(authenticated)/report/material-inventory/page.tsx
 * @description 재고리포트 — PB w_mat_current_inventory_report 이식
 *
 * 초보자 가이드:
 * 1. **네 갈래로 본다.** 롯트별 상세 · 품목별 합계 · 일일(기준일 입출고) · 불용재고다.
 * 2. **이 표에는 날짜 인덱스가 없다** (183만행 — 실측). 그래서 기간이 아니라
 *    **품목·창고 조건**으로 막는다. 품목 조건 없이 열면 느리다.
 * 3. **불용재고는 20초 정도 걸린다.** 판정에 쓰는 DB 함수를 재고 롯트마다 한 번씩
 *    부르기 때문이다 (PB 는 다섯 번 불렀다). 멈춘 것이 아니다.
 * 4. **일일 탭의 공정재공은 PB 와 집계 기준이 다르다.** PB 가 부르는
 *    `F_GET_MAT_WS_ITEM_INV_QTY` 는 INVALID 상태라 (없는 컬럼을 참조한다) 쓸 수
 *    없어 품목+조직으로 직접 합산한다. 머리글에 그 사실을 적어 두었다.
 * 5. **음수 재고는 기본으로 감춘다** (PB `SIGN(qty) >= :arg_sign`). 음수는 입출고가
 *    어긋난 자리라 따로 찾아볼 때만 켠다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateFilter from '@/components/shared/DateFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import {
  materialDisusedColumns,
  materialInventoryColumns,
  materialInventoryDailyColumns,
  materialInventorySummaryColumns,
} from '../report-b-columns';
import type {
  MaterialDisusedRow,
  MaterialInventoryDailyRow,
  MaterialInventoryRow,
  MaterialInventorySummaryRow,
} from '../report-b-types';
import PartSearchField from '@/components/shared/PartSearchField';

const today = () => new Date().toISOString().slice(0, 10);

type Tab = 'detail' | 'summary' | 'daily' | 'disused';

export default function MaterialInventoryReportPage() {
  const [itemCode, setItemCode] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [itemClass, setItemClass] = useState('');
  const [includeNegative, setIncludeNegative] = useState(false);
  const [baseDate, setBaseDate] = useState(today());
  const [termMonths, setTermMonths] = useState('6');
  const [maxIssueRate, setMaxIssueRate] = useState('0');

  const [tab, setTab] = useState<Tab>('summary');
  const [detail, setDetail] = useState<MaterialInventoryRow[]>([]);
  const [summary, setSummary] = useState<MaterialInventorySummaryRow[]>([]);
  const [daily, setDaily] = useState<MaterialInventoryDailyRow[]>([]);
  const [disused, setDisused] = useState<MaterialDisusedRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [disusedLoading, setDisusedLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        itemCode: itemCode || undefined,
        locationCode: locationCode || undefined,
        itemClass: itemClass || undefined,
        sign: includeNegative ? -1 : 0,
      };
      const [d, s, y] = await Promise.all([
        api.get('/report/material-inventory/detail', { params }),
        api.get('/report/material-inventory/summary', { params }),
        api.get('/report/material-inventory/daily', { params: { ...params, baseDate } }),
      ]);
      setDetail(d.data?.data ?? []);
      setSummary(s.data?.data ?? []);
      setDaily(y.data?.data ?? []);
      mark(d, s, y);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '재고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [itemCode, locationCode, itemClass, includeNegative, baseDate]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /**
   * 불용재고는 따로 조회한다 — 판정 함수가 재고 롯트마다 돌아 20초쯤 걸린다.
   * 다른 세 탭과 함께 부르면 화면 전체가 그만큼 늦게 뜬다.
   */
  const searchDisused = useCallback(async () => {
    setDisusedLoading(true);
    try {
      const response = await api.get('/report/material-inventory/disused', {
        // 판정 함수가 재고 롯트마다 돌아 실측 22초다. axios 기본 타임아웃이
        // 30초라 현장 부하에서 넘길 수 있어 이 조회만 넉넉히 둔다.
        timeout: 120_000,
        params: {
          termMonths: Number(termMonths) || 0,
          maxIssueRate: Number(maxIssueRate) || 0,
          itemCode: itemCode || undefined,
        },
      });
      setDisused(response.data?.data ?? []);
      mark(response);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '불용재고 조회에 실패했습니다.');
    } finally {
      setDisusedLoading(false);
    }
  }, [termMonths, maxIssueRate, itemCode]);

  const totalQty = summary.reduce((sum, r) => sum + Number(r.inventoryQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">재고리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 재고를 롯트별·품목별·일일·불용으로 봅니다 ·{' '}
          {searched
            ? `품목별 ${summary.length.toLocaleString()}건 · 재고수량 합계 ${totalQty.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="재고수량 합계" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ComCodeSelect groupCode="MATERIAL LOCATION CODE" labelPrefix="창고"
            value={locationCode} onChange={setLocationCode} className="w-48" />
          <ComCodeSelect groupCode="ITEM CLASS" labelPrefix="품목분류" value={itemClass}
            onChange={setItemClass} className="w-48" />
          <label className="flex items-center gap-2 text-sm text-text">
            <input type="checkbox" checked={includeNegative}
              onChange={(e) => setIncludeNegative(e.target.checked)} />
            음수 재고까지 보기
          </label>
          <label className="flex items-center gap-2 text-sm text-text">
            일일 기준일
            <DateFilter value={baseDate} onChange={setBaseDate} />
          </label>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'summary', label: '품목별 합계', count: summary.length },
          { key: 'detail', label: '롯트별 상세', count: detail.length },
          { key: 'daily', label: '일일 입출고', count: daily.length },
          { key: 'disused', label: '불용재고', count: disused.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      {tab === 'disused' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <label className="flex items-center gap-1 text-sm text-text">
              <Input aria-label="개월수" value={termMonths} className="w-16"
                onChange={(e) => setTermMonths(e.target.value.replace(/\D/g, ''))} />
              개월 안 출고 기준
            </label>
            <label className="flex items-center gap-1 text-sm text-text">
              <Input aria-label="출고율 상한" value={maxIssueRate} className="w-16"
                onChange={(e) => setMaxIssueRate(e.target.value.replace(/[^\d.]/g, ''))} />
              % 이하 출고율
            </label>
            <Button size="sm" onClick={searchDisused} disabled={disusedLoading}>
              <Search className="mr-1 h-4 w-4" />불용재고 조회
            </Button>
            <span className="text-sm text-text-muted">
              판정 함수를 재고 롯트마다 부르므로 20초쯤 걸립니다 (개월수를 0 으로 두면
              출고량 조건을 걸지 않습니다).
            </span>
          </CardContent>
        </Card>
      )}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'summary' && (
            <DataGrid
              data={summary}
              columns={materialInventorySummaryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="재고_품목별합계"
              emptyMessage={searched ? '조건에 맞는 재고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'detail' && (
            <DataGrid
              data={detail}
              columns={materialInventoryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="재고_롯트별"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['itemCode'] }}
              emptyMessage={searched ? '조건에 맞는 재고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'daily' && (
            <DataGrid
              data={daily}
              columns={materialInventoryDailyColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="재고_일일입출고"
              emptyMessage={searched ? '조건에 맞는 재고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'disused' && (
            <DataGrid
              data={disused}
              columns={materialDisusedColumns}
              isLoading={disusedLoading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="불용재고"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['itemCode'] }}
              emptyMessage="조건을 정하고 불용재고를 조회하세요."
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
