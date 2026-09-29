"use client";

/**
 * @file src/app/(authenticated)/tracking/run-no/page.tsx
 * @description 생산이력조회(Run No) — PB w_pln_product_barcode_tracking 이식
 *
 * 초보자 가이드:
 * 1. **위에서 롯트카드를 고르면 그 롯트의 PID 마다 공정별 데이터 보유 건수가 나온다.**
 *    어느 PID 가 어느 공정에서 멈췄는지, 데이터가 빠진 공정이 있는지 보는 표다.
 * 2. **숫자는 '값' 이 아니라 '건수' 다.** F_GET_PID_* 는 전부 COUNT(*) 를 돌려준다.
 *    PB DataWindow 의 컬럼 별칭이 RUN_NO·BARCODE·MK 라서 값처럼 보이지만 아니다.
 * 3. **PID 500장에서 끊는다.** 한 줄마다 DB 함수 18개가 각각 COUNT 쿼리를 돈다 —
 *    PID 500장이면 9,000번이다. PB 는 상한이 없어 큰 롯트에서 화면이 멈췄다.
 *    잘리면 화면에 그대로 적는다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import { Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import RunCardPicker from '../components/RunCardPicker';
import { stageCountColumns } from '../tracking-columns';
import type { RunCardRow, StageColumnDef, StageCountRow } from '../tracking-types';

export default function RunNoTrackingPage() {
  const [selected, setSelected] = useState<RunCardRow | null>(null);
  const [rows, setRows] = useState<StageCountRow[]>([]);
  const [stages, setStages] = useState<StageColumnDef[]>([]);
  const [loading, setLoading] = useState(false);
  const [truncated, setTruncated] = useState(false);
  const [limit, setLimit] = useState(0);

  useEffect(() => {
    void (async () => {
      try {
        const response = await api.get('/tracking/pid/stage-columns');
        setStages(response.data?.data ?? []);
      } catch {
        toast.error('공정 컬럼 정의를 읽지 못했습니다.');
      }
    })();
  }, []);

  const load = useCallback(async (runNo: string) => {
    setLoading(true);
    try {
      const response = await api.get('/tracking/pid/stage-counts-by-run', { params: { runNo } });
      setRows(response.data?.data ?? []);
      setTruncated(Boolean(response.data?.meta?.truncated));
      setLimit(Number(response.data?.meta?.limit ?? 0));
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '공정 매트릭스 조회에 실패했습니다.');
      setRows([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!selected) {
      setRows([]);
      return;
    }
    void load(selected.runNo);
  }, [selected, load]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">생산이력조회(Run No)</h1>
        <p className="mt-1 text-sm text-text-muted">
          롯트카드를 고르면 그 롯트의 PID 마다 공정별 데이터 보유 건수를 보여줍니다 ·{' '}
          {selected ? `${selected.runNo} · PID ${rows.length}건` : '롯트카드를 고르세요'}
        </p>
      </header>

      <RunCardPicker selected={selected} onSelect={setSelected} />

      {truncated && (
        <div className="rounded border border-amber-500/40 bg-amber-500/10 p-3 text-sm text-text">
          이 롯트의 PID 가 {limit}장을 넘어 앞의 {limit}장만 보여줍니다. 한 줄마다 공정
          함수 {stages.length}개가 각각 세기 때문에 그 이상은 화면이 멈춥니다.
        </div>
      )}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">
            공정별 데이터 보유 건수{' '}
            <span className="font-normal text-text-muted">
              — 값은 건수다 (0 이면 그 공정 데이터가 없다)
            </span>
          </b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={rows}
              columns={stageCountColumns(stages)}
              isLoading={loading || stages.length === 0}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="공정별데이터건수"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['serialNo'] }}
              emptyMessage={selected
                ? '이 롯트에 등록된 PID 가 없습니다.'
                : '위에서 롯트카드를 고르세요.'}
              getRowId={(row) => (row as StageCountRow).serialNo}
            />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
