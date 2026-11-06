"use client";

/**
 * @file src/app/(authenticated)/report/material-issue-sum/page.tsx
 * @description 자재출고합계리포트 — PB w_mat_issue_sum_report 이식
 *
 * 초보자 가이드:
 * 1. **두 갈래로 본다.** 품목별과 출고계정별이다. 계정별은 "어느 계정으로
 *    얼마가 나갔나" 를 보는 것이라 원가 확인에 쓴다.
 * 2. **기간은 출고일 기준이다** (상세 탭과 달리 등록일이 아니다 — PB 도 그렇다).
 *    출고일은 PK 선두라 인덱스를 타서 31일치 0.05s 다 (실측).
 * 3. **취소된 출고는 안 나온다** (PB 고정조건 `ISSUE_STATUS <> 'C'`).
 * 4. **출고 × 일자 탭은 입고합계의 입출고 매트릭스와 같은 모양이다.** 열은 일자이고
 *    조회 기간에 따라 달라지므로 피벗은 화면에서 돌린다. 줄은 품목·출고계정·창고·협력사다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import ScreenTabs from '@/components/shared/ScreenTabs';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { useCrosstab, type CrosstabSpec } from '../components/crosstab';
import {
  materialIssueSumAccountColumns,
  materialIssueSumItemColumns,
} from '../report-b-columns';
import type {
  MaterialIssueMatrixRow,
  MaterialIssueSumAccountRow,
  MaterialIssueSumItemRow,
} from '../report-b-types';
import PartSearchField from '@/components/shared/PartSearchField';

import { getTodayLocal } from '@/utils/date';
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return getTodayLocal(d);
};

type Tab = 'item' | 'account' | 'matrix';

export default function MaterialIssueSumPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(0));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [itemCode, setItemCode] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [issueAccount, setIssueAccount] = useState('');

  const [tab, setTab] = useState<Tab>('item');
  const [byItem, setByItem] = useState<MaterialIssueSumItemRow[]>([]);
  const [byAccount, setByAccount] = useState<MaterialIssueSumAccountRow[]>([]);
  const [matrix, setMatrix] = useState<MaterialIssueMatrixRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        dateFrom,
        dateTo,
        itemCode: itemCode || undefined,
        supplierCode: supplierCode || undefined,
        issueAccount: issueAccount || undefined,
      };
      const [i, a, m] = await Promise.all([
        api.get('/report/material-issue-sum/item', { params }),
        api.get('/report/material-issue-sum/account', { params }),
        api.get('/report/material-issue-sum/matrix', { params }),
      ]);
      setByItem(i.data?.data ?? []);
      setByAccount(a.data?.data ?? []);
      setMatrix(m.data?.data ?? []);
      mark(i, a, m);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재출고합계 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, itemCode, supplierCode, issueAccount]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const spec = useMemo<CrosstabSpec<MaterialIssueMatrixRow>>(() => ({
    // 출고계정을 줄로 나눈다 — 섞으면 양산과 롯트분할이 한 줄에 더해진다.
    rowKey: (r) => [r.itemCode, r.issueAccount, r.locationCode, r.supplierCode].join('|'),
    rowLabels: [
      { id: 'itemCode', header: '품목코드', value: (r) => r.itemCode ?? '', width: 150 },
      { id: 'itemName', header: '품목명', value: (r) => r.itemName ?? '', width: 180 },
      { id: 'issueAccount', header: '출고계정', value: (r) => r.issueAccountName ?? r.issueAccount ?? '', width: 110 },
      { id: 'location', header: '창고', value: (r) => r.locationName ?? r.locationCode ?? '', width: 120 },
      { id: 'supplier', header: '협력사', value: (r) => r.supplierName ?? r.supplierCode ?? '', width: 150 },
    ],
    colKey: (r) => r.txnDate,
    colHeader: (k) => k.slice(5),
    value: (r) => Number(r.qty ?? 0),
  }), []);
  const matrixGrid = useCrosstab(matrix, spec);

  const totalQty = byItem.reduce((sum, r) => sum + Number(r.issueQty ?? 0), 0);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재출고합계리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 출고를 품목·출고계정·일자별로 합계 냅니다 (출고일 기준) ·{' '}
          {searched
            ? `품목별 ${byItem.length.toLocaleString()}건 · 출고수량 합계 ${totalQty.toLocaleString()}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="출고수량 합계" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="출고일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <div className="w-52">
            <SupplierSelect includeAll value={supplierCode} onChange={setSupplierCode} />
          </div>
          <ComCodeSelect groupCode="ISSUE ACCOUNT" labelPrefix="출고계정"
            value={issueAccount} onChange={setIssueAccount} className="w-52" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'item', label: '품목별', count: byItem.length },
          { key: 'account', label: '출고계정별', count: byAccount.length },
          { key: 'matrix', label: '출고 × 일자', count: matrix.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'item' && (
            <DataGrid
              data={byItem}
              columns={materialIssueSumItemColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재출고합계_품목별"
              emptyMessage={searched ? '기간에 출고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'account' && (
            <DataGrid
              data={byAccount}
              columns={materialIssueSumAccountColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재출고합계_계정별"
              emptyMessage={searched ? '기간에 출고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'matrix' && (
            <DataGrid
              key={matrixGrid.gridKey}
              data={matrixGrid.data}
              columns={matrixGrid.columns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재출고_일자별"
              enableColumnPinning
              defaultPinnedColumns={matrixGrid.pinned}
              emptyMessage={searched ? '기간에 출고가 없습니다.' : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
