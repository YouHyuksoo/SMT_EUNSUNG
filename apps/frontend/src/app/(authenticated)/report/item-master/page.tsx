"use client";

/**
 * @file src/app/(authenticated)/report/item-master/page.tsx
 * @description 품목마스터리포트 — PB w_des_item_master_rpt 이식
 *
 * 초보자 가이드:
 * 1. **품목 기준정보를 인쇄용으로 뽑는 화면이다.** 등록·수정은 기준정보 화면에서
 *    하고, 여기서는 보고 내보내기만 한다.
 * 2. **유효기간 상태는 계산값이다.** ID_ITEM 에 상태 컬럼은 없다 — 적용시작·종료일을
 *    오늘과 비교해 적용중/적용전/만료를 만든다 (PB 와 같은 식).
 * 3. **`LINE_TYPE` 은 라인이 아니라 구매유형이다** (F 무상구매 · G 국내구매 · T 자작
 *    · Y 유상사급). 이름만 보고 라인 필터를 붙이면 아무것도 안 걸린다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Card, CardContent, Input, Select } from '@/components/ui';
import api from '@/services/api';
import { itemMasterColumns } from '../report-columns';
import type { ItemMasterRow } from '../report-types';

const STATUS_OPTIONS = [
  { value: '', label: '유효기간: 전체' },
  { value: 'RUNNING', label: '적용중' },
  { value: 'FUTURE', label: '적용전' },
  { value: 'EXPIRED', label: '만료' },
];

export default function ItemMasterReportPage() {
  const [itemCode, setItemCode] = useState('');
  const [itemName, setItemName] = useState('');
  const [itemType, setItemType] = useState('');
  const [itemClass, setItemClass] = useState('');
  const [lineType, setLineType] = useState('');
  const [status, setStatus] = useState('');

  const [rows, setRows] = useState<ItemMasterRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/item-master', {
        params: {
          itemCode: itemCode || undefined,
          itemName: itemName || undefined,
          itemType: itemType || undefined,
          itemClass: itemClass || undefined,
          lineType: lineType || undefined,
          status: status || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '품목마스터 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [itemCode, itemName, itemType, itemClass, lineType, status]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const expired = rows.filter((r) => r.status === 'EXPIRED').length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">품목마스터리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          품목 기준정보를 조건별로 뽑습니다 ·{' '}
          {searched
            ? `${rows.length.toLocaleString()}건${expired > 0 ? ` · 유효기간 만료 ${expired}건` : ''}`
            : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Input aria-label="품목명" placeholder="품목명" value={itemName} className="w-44"
            onChange={(e) => setItemName(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ComCodeSelect groupCode="ITEM TYPE" labelPrefix="품목유형" value={itemType}
            onChange={setItemType} className="w-44" />
          <ComCodeSelect groupCode="ITEM CLASS" labelPrefix="품목분류" value={itemClass}
            onChange={setItemClass} className="w-48" />
          {/* 컬럼 이름은 LINE_TYPE 이지만 뜻은 구매유형이다. 라벨을 뜻대로 적는다. */}
          <ComCodeSelect groupCode="LINE TYPE" labelPrefix="구매유형" value={lineType}
            onChange={setLineType} className="w-48" />
          <Select options={STATUS_OPTIONS} value={status} onChange={setStatus}
            className="w-40" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={itemMasterColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="품목마스터"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['itemCode'] }}
            emptyMessage={searched ? '조건에 맞는 품목이 없습니다.' : '조회하세요.'}
            getRowId={(row) => (row as ItemMasterRow).itemCode}
          />
        </CardContent>
      </Card>
    </div>
  );
}
