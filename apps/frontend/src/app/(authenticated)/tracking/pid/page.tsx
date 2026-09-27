"use client";

/**
 * @file src/app/(authenticated)/tracking/pid/page.tsx
 * @description 생산이력조회(PID) — PB w_product_pid_tracking_fpcb_rpt 자리
 *
 * 초보자 가이드:
 * 1. **PID 하나를 넣으면 그 제품의 Run No·모델과 공정별 데이터 보유 상태,
 *    그리고 그 롯트에 투입된 자재가 나온다.**
 * 2. **공정별 숫자는 '건수' 다.** F_GET_PID_* 함수는 전부 COUNT(*) 를 돌려준다 —
 *    0 이면 그 공정 데이터가 없다는 뜻이고, 0 인 칸은 흐리게 보인다.
 *    어디까지 진행됐는지, 어느 공정 데이터가 누락됐는지 한눈에 보려는 표다.
 * 3. **이 화면은 이식이 아니라 재구성이다.** PB DataWindow
 *    `d_ip_product_pid_tracking_fpcb_rpt_k` 는 SQL 이 없는 빈 껍데기다 —
 *    컬럼 `a char(10)` 하나에 retrieve 문이 없다 (형제 `_fpcb_rpt` · `_duckil` 도
 *    같다). 그래서 PB 에서 이 화면은 동작하지 않았다. PB 스크립트가 남긴
 *    계약(PID 를 넣으면 Run No·모델명을 채우고 추적을 보여준다)을 근거로
 *    생산이력조회(Run No) 의 매트릭스와 롯트추적조회(ALL) 의 자재 목록을 붙여 되살렸다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import { Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import TrackingKeySearch from '../components/TrackingKeySearch';
import { pidMaterialColumns, stageCountColumns } from '../tracking-columns';
import type {
  PidHeaderRow,
  PidMaterialRow,
  StageColumnDef,
  StageCountRow,
} from '../tracking-types';

/** 머리글 한 칸 */
function Field({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="min-w-32">
      <div className="text-xs text-text-muted">{label}</div>
      <div className="text-sm font-semibold text-text">{value || '-'}</div>
    </div>
  );
}

export default function PidTrackingPage() {
  const [serialNo, setSerialNo] = useState('');
  const [header, setHeader] = useState<PidHeaderRow | null>(null);
  const [counts, setCounts] = useState<StageCountRow[]>([]);
  const [materials, setMaterials] = useState<PidMaterialRow[]>([]);
  const [stages, setStages] = useState<StageColumnDef[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

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

  const search = useCallback(async () => {
    setLoading(true);
    setHeader(null);
    setCounts([]);
    setMaterials([]);
    try {
      const [h, c, m] = await Promise.all([
        api.get('/tracking/pid/header', { params: { serialNo } }),
        api.get('/tracking/pid/stage-counts-by-serial', { params: { serialNo } }),
        api.get('/tracking/pid/materials', { params: { serialNo } }),
      ]);
      setHeader(h.data?.data ?? null);
      setCounts(c.data?.data ?? []);
      setMaterials(m.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '생산이력 조회에 실패했습니다.');
      setSearched(true);
    } finally {
      setLoading(false);
    }
  }, [serialNo]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">생산이력조회(PID)</h1>
        <p className="mt-1 text-sm text-text-muted">
          PID 하나의 Run No·모델, 공정별 데이터 보유 건수, 투입 자재를 함께 봅니다 ·{' '}
          {searched ? `자재 ${materials.length}건` : 'PID 를 입력하세요'}
        </p>
      </header>

      <TrackingKeySearch
        label="PID (2D 바코드)"
        keyKind="serialNo"
        value={serialNo}
        onChange={setSerialNo}
        onSearch={search}
        loading={loading}
      />

      {header && (
        <Card padding="none">
          <CardContent className="flex flex-wrap gap-6 p-4">
            <Field label="Run No" value={header.runNo} />
            <Field label="모델" value={header.modelName} />
            <Field label="고객모델" value={header.customerModelName} />
            <Field label="품목" value={header.itemName ?? header.itemCode} />
            <Field label="라인" value={header.lineName ?? header.lineCode} />
            <Field label="지시일" value={header.runDate} />
            <Field label="롯트번호" value={header.lotNo} />
            <Field label="롯트수량" value={header.lotQty?.toLocaleString()} />
            <Field label="매거진" value={header.magazineNo} />
            <Field label="박스" value={header.boxNo} />
            <Field
              label="바코드 상태"
              value={header.barcodeStatusName ?? header.barcodeStatus}
            />
            <Field
              label="수리 이력"
              value={header.repairYn === 'Y'
                ? <span className="text-amber-500">있음</span>
                : '없음'}
            />
            <Field label="출하시각" value={header.shippingDate} />
          </CardContent>
        </Card>
      )}

      <Card className="shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex flex-col gap-2 p-3">
          <b className="text-sm text-text">
            공정별 데이터 보유 건수{' '}
            <span className="font-normal text-text-muted">
              — 값은 건수다 (0 이면 그 공정 데이터가 없다)
            </span>
          </b>
          <DataGrid
            data={counts}
            columns={stageCountColumns(stages)}
            isLoading={loading || stages.length === 0}
            pageSize={10}
            maxHeight="180px"
            emptyMessage={searched ? '이 PID 를 2D바코드에서 찾을 수 없습니다.' : 'PID 를 넣고 조회하세요.'}
            getRowId={(row) => (row as StageCountRow).serialNo}
          />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">이 롯트에 투입된 자재</b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={materials}
              columns={pidMaterialColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="PID투입자재"
              emptyMessage={searched
                ? '이 롯트의 자재 투입 이력이 없습니다.'
                : 'PID 를 넣고 조회하세요.'}
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
