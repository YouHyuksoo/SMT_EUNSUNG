"use client";

/**
 * @file src/app/(authenticated)/tracking/material-dynamic/page.tsx
 * @description 자재추적조회(동적) — PB w_product_material_tracking_rpt 이식
 *
 * 초보자 가이드:
 * 1. **완제품에서 거꾸로 올라간다.** 불량이 난 PID 를 넣으면 그 제품이 지나간
 *    공정 시점(SPI·AOI·투입)이 위 표에 나온다.
 * 2. **공정을 고르면 그 순간 라인에 물려 있던 자재가 아래에 나온다.**
 *    이게 '동적' 의 뜻이다 — 지금 물려 있는 자재가 아니라 **그때** 물려 있던 자재다.
 * 3. **두 갈래로 보여준다.**
 *    MIN    = 기준시각 이전의 가장 최근 투입 → 그 순간 물려 있던 릴
 *    APPEND = 기준시각 이후 N분 안의 추가 투입 → 검사 직후 바뀐 릴
 *    두 번째가 있어야 '불량 시점 전후에 무엇이 바뀌었나' 가 보인다.
 * 4. **라인·모델 무시 체크박스**는 PB 와 같다. 켜면 그 조건을 빼고 전체에서 찾는다 —
 *    라인을 옮겨 가며 만든 제품을 추적할 때 쓴다.
 * 5. **'이후 N분' 기본값은 0 이다** (PB 와 같다). 0 이면 APPEND 갈래가 비어 있다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import { Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import TrackingKeySearch from '../components/TrackingKeySearch';
import { dynamicMaterialColumns, stageTimelineColumns } from '../tracking-columns';
import type { DynamicMaterialRow, StageTimelineRow } from '../tracking-types';

export default function MaterialDynamicTrackingPage() {
  const [serialNo, setSerialNo] = useState('');
  const [stages, setStages] = useState<StageTimelineRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [ignoreLine, setIgnoreLine] = useState(false);
  const [ignoreModel, setIgnoreModel] = useState(false);
  const [timeMinutes, setTimeMinutes] = useState('0');

  const [selected, setSelected] = useState<StageTimelineRow | null>(null);
  const [materials, setMaterials] = useState<DynamicMaterialRow[]>([]);
  const [matLoading, setMatLoading] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    setSelected(null);
    setMaterials([]);
    try {
      const response = await api.get('/tracking/material/stage-timeline', {
        params: { serialNo },
      });
      setStages(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '공정 시점 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [serialNo]);

  const pick = useCallback(async (row: StageTimelineRow) => {
    setSelected(row);
    if (!row.maxDatetimeKey) {
      setMaterials([]);
      toast.error('이 공정에는 기준시각이 없어 자재를 되짚을 수 없습니다.');
      return;
    }
    setMatLoading(true);
    try {
      const response = await api.get('/tracking/material/dynamic', {
        params: {
          maxDatetime: row.maxDatetimeKey,
          minDatetime: row.minDatetimeKey || undefined,
          lineCode: ignoreLine ? undefined : row.lineCode || undefined,
          modelName: ignoreModel ? undefined : row.smtModelName || undefined,
          timeMinutes: Number(timeMinutes) || 0,
        },
      });
      setMaterials(response.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재 조회에 실패했습니다.');
      setMaterials([]);
    } finally {
      setMatLoading(false);
    }
  }, [ignoreLine, ignoreModel, timeMinutes]);

  const stageKey = (r: StageTimelineRow) =>
    [r.workstageName, r.lineCode, r.inspectDate, r.cstId, r.seqNo].join('|');

  const minCount = materials.filter((m) => m.branch === 'MIN').length;
  const appendCount = materials.length - minCount;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재추적조회(동적)</h1>
        <p className="mt-1 text-sm text-text-muted">
          완제품 PID 에서 거꾸로 올라가 그 순간 라인에 물려 있던 자재를 찾습니다 ·{' '}
          {searched ? `공정 시점 ${stages.length}건` : 'PID 를 입력하세요'}
        </p>
      </header>

      <TrackingKeySearch
        label="PID (2D 바코드)"
        keyKind="serialNo"
        value={serialNo}
        onChange={setSerialNo}
        onSearch={search}
        loading={loading}
      >
        <label className="flex items-center gap-2 text-sm text-text">
          <input type="checkbox" checked={ignoreLine}
            onChange={(e) => setIgnoreLine(e.target.checked)} />
          라인 무시
        </label>
        <label className="flex items-center gap-2 text-sm text-text">
          <input type="checkbox" checked={ignoreModel}
            onChange={(e) => setIgnoreModel(e.target.checked)} />
          모델 무시
        </label>
        <label className="flex items-center gap-2 text-sm text-text">
          이후
          <Input aria-label="이후 분" value={timeMinutes} className="w-20"
            onChange={(e) => setTimeMinutes(e.target.value.replace(/\D/g, ''))} />
          분까지
        </label>
      </TrackingKeySearch>

      <Card className="h-56 shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">이 PID 가 지나간 공정</b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={stages}
              columns={stageTimelineColumns}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              emptyMessage={searched
                ? '이 PID 의 검사·투입 이력이 없습니다.'
                : 'PID 를 넣고 조회하세요.'}
              onRowClick={(row) => void pick(row as StageTimelineRow)}
              rowClassName={(row) =>
                selected && stageKey(row as StageTimelineRow) === stageKey(selected)
                  ? 'bg-primary/10' : ''}
              getRowId={(row) => stageKey(row as StageTimelineRow)}
            />
          </div>
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <div className="flex flex-wrap items-baseline gap-3">
            <b className="text-sm text-text">그 시점의 라인 자재</b>
            {selected && (
              <span className="text-sm text-text-muted">
                {selected.workstageName} · 기준시각 {selected.maxDatetime}
                {' · '}MIN {minCount}건 / APPEND {appendCount}건
                {ignoreLine && <span className="ml-2 text-primary">라인 무시</span>}
                {ignoreModel && <span className="ml-2 text-primary">모델 무시</span>}
              </span>
            )}
          </div>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={materials}
              columns={dynamicMaterialColumns}
              isLoading={matLoading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="동적자재추적"
              emptyMessage={selected
                ? '이 시점에 이 라인·모델로 투입된 자재가 없습니다.'
                : '위에서 공정을 고르세요.'}
              rowClassName={(row) =>
                (row as DynamicMaterialRow).branch === 'APPEND' ? 'bg-amber-500/5' : ''}
              getRowId={(row) => {
                const r = row as DynamicMaterialRow;
                return [r.branch, r.checkDate, r.lineCode, r.pcbItem, r.locationCode].join('|');
              }}
            />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
