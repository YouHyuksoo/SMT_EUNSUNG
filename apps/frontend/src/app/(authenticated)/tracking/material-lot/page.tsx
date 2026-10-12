"use client";

/**
 * @file src/app/(authenticated)/tracking/material-lot/page.tsx
 * @description 자재 제조번호 기준 추적 — PB w_product_pid_tracking_rpt 이식
 *
 * 초보자 가이드:
 * 1. **자재 제조번호로 시작한다.** 문제가 된 릴 하나를 넣으면 그것이 어느 라인
 *    어느 피더에 언제 물려 있었는지 위 표에 나온다.
 * 2. **위 표의 행을 클릭하면 아래에 그 구간의 SPI 검사데이터가 나온다.**
 *    그 시간에 그 라인에서 나온 PID 들이다 — 이 자재가 들어간 제품 목록이 된다.
 * 3. **구간 종료시각은 DB 함수가 정한다** (F_GET_CHECK_DATA_END). 다음 교체 시각이다.
 *    TypeScript 로 다시 계산하면 PB 화면과 값이 갈린다.
 * 4. **라인 31~34 는 SPI 장비라인 2개로 펼쳐진다** (31→01·02 …). PB 가 하드코딩한
 *    매핑이고, 펼친 결과를 화면에 적어 둔다.
 * 5. **기간을 직접 넓힐 수 없다.** 고른 행의 투입~교체 구간이 기간이다 —
 *    IQ_MACHINE_INSPECT_SPI 가 1억행이라 구간이 닫혀 있어야 열린다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import { Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import TrackingKeySearch from '../components/TrackingKeySearch';
import { feedingWindowColumns, lotSpiColumns } from '../tracking-columns';
import type { FeedingWindowRow, LotSpiRow } from '../tracking-types';

export default function MaterialLotTrackingPage() {
  const [lotNo, setLotNo] = useState('');
  const [windows, setWindows] = useState<FeedingWindowRow[]>([]);
  const [resolved, setResolved] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [selected, setSelected] = useState<FeedingWindowRow | null>(null);
  const [spiRows, setSpiRows] = useState<LotSpiRow[]>([]);
  const [spiLoading, setSpiLoading] = useState(false);
  const [expanded, setExpanded] = useState<string[]>([]);

  const search = useCallback(async () => {
    setLoading(true);
    setSelected(null);
    setSpiRows([]);
    try {
      const response = await api.get('/tracking/material/feeding-windows', {
        params: { lotNo },
      });
      setWindows(response.data?.data ?? []);
      setResolved(response.data?.meta?.resolvedLotNo ?? null);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '투입 구간 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lotNo]);

  const pick = useCallback(async (row: FeedingWindowRow) => {
    setSelected(row);
    setExpanded([]);
    if (!row.checkDateStartKey || !row.checkDateEndKey || !row.lineCode) {
      setSpiRows([]);
      toast.error('이 행에는 투입 구간이나 라인이 없어 SPI 데이터를 찾을 수 없습니다.');
      return;
    }
    setSpiLoading(true);
    try {
      const response = await api.get('/tracking/material/lot-spi', {
        params: {
          checkDateStart: row.checkDateStartKey,
          checkDateEnd: row.checkDateEndKey,
          lineCode: row.lineCode,
        },
      });
      setSpiRows(response.data?.data ?? []);
      setExpanded(response.data?.meta?.expandedLines ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'SPI 데이터 조회에 실패했습니다.');
      setSpiRows([]);
    } finally {
      setSpiLoading(false);
    }
  }, []);

  const rowKey = (r: FeedingWindowRow) =>
    [r.checkDateStartKey, r.lineCode, r.pcbItem, r.locationCode].join('|');

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재 제조번호 기준 추적</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 하나가 어느 라인·피더에 언제 물려 있었고, 그 시간에 어떤 제품이
          나왔는지 되짚습니다 ·{' '}
          {searched ? `투입 구간 ${windows.length}건` : '제조번호를 입력하세요'}
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

      <Card className="h-64 shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">투입 구간 (PDA 체크 이력)</b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={windows}
              columns={feedingWindowColumns}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="자재투입구간"
              emptyMessage={searched
                ? '이 제조번호로 투입된 이력이 없습니다.'
                : '제조번호를 넣고 조회하세요.'}
              onRowClick={(row) => void pick(row as FeedingWindowRow)}
              rowClassName={(row) =>
                selected && rowKey(row as FeedingWindowRow) === rowKey(selected)
                  ? 'bg-primary/10' : ''}
              getRowId={(row) => rowKey(row as FeedingWindowRow)}
            />
          </div>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <div className="flex flex-wrap items-baseline gap-3">
            <b className="text-sm text-text">SPI 검사데이터</b>
            {selected && (
              <span className="text-sm text-text-muted">
                {selected.checkDateStart} ~ {selected.checkDateEnd} ·{' '}
                라인 {selected.lineName ?? selected.lineCode}
                {expanded.length > 1 && (
                  <span className="ml-2 text-primary">
                    SPI 장비라인 {expanded.join(' · ')} 로 펼쳤습니다
                  </span>
                )}
              </span>
            )}
          </div>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={spiRows}
              columns={lotSpiColumns}
              isLoading={spiLoading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SPI검사데이터"
              emptyMessage={selected
                ? '이 구간·라인에 SPI 검사데이터가 없습니다.'
                : '위에서 투입 구간을 고르세요.'}
              getRowId={(row) => {
                const r = row as LotSpiRow;
                return [r.pid, r.inspectDate, r.cstId, r.seqNo].join('|');
              }}
            />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
