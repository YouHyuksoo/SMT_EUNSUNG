"use client";

/**
 * @file src/app/(authenticated)/tracking/material-usage/page.tsx
 * @description 자재사용이력조회 — PB w_product_material_tracking_msl_rpt 이식
 *
 * 초보자 가이드:
 * 1. **제조번호 하나의 전 생애를 시간순으로 본다.** 입고 → 출고 → SMT 투입 →
 *    (반품·폐기) 를 원장 세 곳에서 모아 한 줄씩 늘어놓는다.
 * 2. **'원장' 컬럼이 어디서 온 기록인지 알려준다** — SMT(투입 이력) / ISSUE(출고) /
 *    RECEIPT(입고). 구분 이름은 공통코드에서 가져온다.
 * 3. **MSL 이 이 화면의 핵심이다.** 흡습 자재는 개봉 후 허용시간(한도)이 있고
 *    넘기면 베이킹을 해야 한다. 경과/잔여 시간과 베이킹 이력을 같이 본다.
 * 4. **PB 는 품목·바코드가 없는 기록을 버렸다** (내부조인). 여기서는 LEFT JOIN 으로
 *    두어 이력 자체가 사라지지 않게 했다. 실측 표본 100건에서 결과는 같았다
 *    (389행 = 389행) — 손실 없이 안전한 쪽으로 옮긴 것이다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import { Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import TrackingKeySearch from '../components/TrackingKeySearch';
import { materialUsageColumns } from '../tracking-columns';
import type { MaterialUsageRow } from '../tracking-types';

export default function MaterialUsagePage() {
  const [lotNo, setLotNo] = useState('');
  const [rows, setRows] = useState<MaterialUsageRow[]>([]);
  const [resolved, setResolved] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/tracking/material/usage', { params: { lotNo } });
      setRows(response.data?.data ?? []);
      setResolved(response.data?.meta?.resolvedLotNo ?? null);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재사용이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lotNo]);

  const byKind = rows.reduce<Record<string, number>>((acc, r) => {
    acc[r.sourceKind] = (acc[r.sourceKind] ?? 0) + 1;
    return acc;
  }, {});

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재사용이력조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          제조번호 하나의 입고·출고·SMT 투입을 시간순으로 모아 보여줍니다 ·{' '}
          {searched
            ? `${rows.length}건 (SMT ${byKind.SMT ?? 0} · 출고 ${byKind.ISSUE ?? 0}`
              + ` · 입고 ${byKind.RECEIPT ?? 0})`
            : '제조번호를 입력하세요'}
        </p>
      </header>

      <TrackingKeySearch
        label="자재 제조번호 / 바코드"
        keyKind="lotNo"
        value={lotNo}
        onChange={setLotNo}
        onSearch={search}
        loading={loading}
        resolvedNote={resolved && resolved !== lotNo ? `제조번호 ${resolved} 로 찾았습니다` : null}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={materialUsageColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="자재사용이력"
            emptyMessage={searched
              ? '이 제조번호의 이력이 없습니다.'
              : '제조번호를 넣고 조회하세요.'}
            rowClassName={(row) => {
              const r = row as MaterialUsageRow;
              if (r.mslMaxTime && r.mslPassedTime && r.mslPassedTime >= r.mslMaxTime) {
                return 'bg-red-500/5';
              }
              return '';
            }}
            getRowId={(row) => {
              const r = row as MaterialUsageRow;
              return [r.sourceKind, r.procDate, r.itemCode, r.locationCode, r.qty].join('|');
            }}
          />
        </CardContent>
      </Card>
    </div>
  );
}
