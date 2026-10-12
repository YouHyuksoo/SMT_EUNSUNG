"use client";

/**
 * @file src/app/(authenticated)/tracking/lot-all/page.tsx
 * @description 롯트추적조회(ALL) — PB w_pln_product_all_barcode_tracking 이식
 *
 * 초보자 가이드:
 * 1. **세 단계로 좁힌다.** 롯트카드를 고르면 그 롯트의 PID 별 전 공정 시각이 나오고,
 *    PID 를 고르면 그 롯트에 투입된 자재가 아래에 나온다.
 * 2. **가운데 표가 이 화면의 본체다.** 마킹 → SPI → AOI → 박스 → 출하 시각과
 *    구간별 경과시간(SPI→AOI, 마킹→AOI, 마킹→출하)을 한 줄에 늘어놓는다.
 *    경과시간은 DB 함수 F_GET_TIME_TERM_HHHMISS 가 계산한다 — PB 와 같은 값이어야 한다.
 * 3. **지그·솔더는 롯트 단위 값이다.** 마스크·스퀴지 지그는 지그유형(M/S)별로,
 *    솔더 롯트는 LISTAGG 로 모아 붙인다. PID 마다 다른 값이 아니다.
 * 4. **은성판 DataWindow(`_es`, 45컬럼)를 옮겼다.** 41컬럼 버전은 대시보드의
 *    Lot Tracking 탭이 쓰는 것이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import { Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import RunCardPicker from '../components/RunCardPicker';
import { lotDetailColumns, pidMaterialColumns } from '../tracking-columns';
import type { LotDetailRow, PidMaterialRow, RunCardRow } from '../tracking-types';

export default function LotAllTrackingPage() {
  const [runCard, setRunCard] = useState<RunCardRow | null>(null);
  const [details, setDetails] = useState<LotDetailRow[]>([]);
  const [loading, setLoading] = useState(false);

  const [pid, setPid] = useState<string | null>(null);
  const [materials, setMaterials] = useState<PidMaterialRow[]>([]);
  const [matLoading, setMatLoading] = useState(false);

  const loadDetails = useCallback(async (runNo: string) => {
    setLoading(true);
    setPid(null);
    setMaterials([]);
    try {
      const response = await api.get('/tracking/pid/lot-detail', { params: { runNo } });
      setDetails(response.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '롯트 상세 조회에 실패했습니다.');
      setDetails([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!runCard) {
      setDetails([]);
      return;
    }
    void loadDetails(runCard.runNo);
  }, [runCard, loadDetails]);

  const pickPid = useCallback(async (serialNo: string) => {
    setPid(serialNo);
    setMatLoading(true);
    try {
      const response = await api.get('/tracking/pid/materials', { params: { serialNo } });
      setMaterials(response.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '투입 자재 조회에 실패했습니다.');
      setMaterials([]);
    } finally {
      setMatLoading(false);
    }
  }, []);

  const ngCount = details.filter(
    (d) => (d.aoiResult && d.aoiResult !== 'OK' && d.aoiResult !== 'PASS')
      || (d.spiResult && d.spiResult !== 'OK' && d.spiResult !== 'PASS'),
  ).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">롯트추적조회(ALL)</h1>
        <p className="mt-1 text-sm text-text-muted">
          롯트 하나의 PID 별 전 공정 시각과 그 PID 에 투입된 자재를 단계로 좁혀 봅니다 ·{' '}
          {runCard
            ? `${runCard.runNo} · PID ${details.length}건${ngCount > 0 ? ` · 검사 NG ${ngCount}건` : ''}`
            : '롯트카드를 고르세요'}
        </p>
      </header>

      <RunCardPicker selected={runCard} onSelect={setRunCard} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">
            PID 별 전 공정 시각{' '}
            <span className="font-normal text-text-muted">
              — 행을 클릭하면 아래에 그 PID 의 투입 자재가 나옵니다
            </span>
          </b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={details}
              columns={lotDetailColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="롯트추적ALL"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['serialNo'] }}
              onRowClick={(row) => void pickPid((row as LotDetailRow).serialNo)}
              rowClassName={(row) => {
                const r = row as LotDetailRow;
                if (r.serialNo === pid) return 'bg-primary/10';
                const ng = (v: string | null) => v && v !== 'OK' && v !== 'PASS';
                return ng(r.aoiResult) || ng(r.spiResult) ? 'bg-red-500/5' : '';
              }}
              getRowId={(row) => (row as LotDetailRow).serialNo}
            />
          </div>
        </CardContent>
      </Card>

      <Card className="h-64 shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <div className="flex flex-wrap items-baseline gap-3">
            <b className="text-sm text-text">투입 자재</b>
            {pid && <span className="text-sm text-text-muted">PID {pid}</span>}
          </div>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={materials}
              columns={pidMaterialColumns}
              isLoading={matLoading}
              pageSize={50}
              enableColumnFilter
              emptyMessage={pid
                ? '이 롯트의 자재 투입 이력이 없습니다.'
                : '위에서 PID 를 고르세요.'}
              getRowId={(row) => {
                const r = row as PidMaterialRow;
                return [r.feedingDate, r.locationCode, r.pcbItem, r.lotNo].join('|');
              }}
            />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
