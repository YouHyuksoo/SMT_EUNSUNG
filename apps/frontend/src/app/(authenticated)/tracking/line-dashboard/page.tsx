"use client";

/**
 * @file src/app/(authenticated)/tracking/line-dashboard/page.tsx
 * @description 생산현황데쉬보드 — PB w_com_production_status_dashboard 이식
 *
 * 초보자 가이드:
 * 1. **라인 하나를 골라 그 라인의 지금 상태를 본다.** 위쪽은 라인 요약,
 *    아래쪽은 그 라인에서 돌고 있는 롯트의 상세 8개 탭이다.
 * 2. **자동갱신은 켜고 끌 수 있다** (PB 의 Interval / Start / Stop 과 같다).
 *    기본 60초. 요약은 뷰를 직접 읽으므로 갱신할 때마다 새 값이다 —
 *    '읽은 시각' 을 화면에 적어 두어 실제로 돌고 있는지 보인다.
 * 3. **'상세 읽기' 를 누르면 탭 8개를 한 번에 받아온다.** PB 는 DataWindow 를
 *    9번 각각 retrieve 했다. 자동갱신에 상세까지 물리면 요청이 매번 몰리므로
 *    상세는 기본 수동이고, 원하면 함께 갱신하도록 켤 수 있다 (PB 의 Detail Auto Query).
 * 4. **NSNP 잠금·해제는 사용자 레벨 8 이상만 할 수 있다** (PB 가드 유지).
 *    라인을 세우는 일이라 아무나 누르면 안 된다. 권한이 없으면 서버가 거부한다.
 * 5. **인터록 탭은 PB 에서 항상 비어 있었다.** DataWindow 가 LINE_CODE 로 거르는데
 *    PB 가 Run No 를 넘겼기 때문이다 (Run No 는 라인코드와 같을 수 없다).
 *    라인코드로 찾도록 고쳤다 — 실측 라인 8곳에서 PB 0행 → 135~98,985행.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import { useActiveInterval } from '@/hooks/useTabActive';
import toast from 'react-hot-toast';
import { Lock, RefreshCw, Search, Unlock } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  interlockTabColumns,
  jigCheckColumns,
  mslTabColumns,
  pcbInputTabColumns,
  pickupRateColumns,
  reelChangeTabColumns,
  sampleTabColumns,
  solderTabColumns,
} from '../tracking-columns';
import type { DashboardDetail, LineStatusRow, PickupRateRow } from '../tracking-types';

const EMPTY_DETAIL: DashboardDetail = {
  solder: [], mask: [], squeeze: [], msl: [], pcb: [], sample: [], reel: [], interlock: [],
};

type TabKey = keyof DashboardDetail | 'pickup';

const TABS: { key: TabKey; label: string }[] = [
  { key: 'pickup', label: '픽업률' },
  { key: 'solder', label: '솔더' },
  { key: 'mask', label: '마스크 점검' },
  { key: 'squeeze', label: '스퀴지 점검' },
  { key: 'msl', label: 'MSL' },
  { key: 'pcb', label: 'PCB 투입' },
  { key: 'sample', label: '샘플' },
  { key: 'reel', label: '릴교환' },
  { key: 'interlock', label: '인터록' },
];

/** 점검 플래그를 배지로. 뷰가 'Y'/'N' 또는 경고 문구를 담는다. */
function CheckBadge({ label, value }: { label: string; value: string | null }) {
  const ok = value === 'Y' || value === 'OK';
  const empty = !value;
  const cls = empty
    ? 'bg-surface text-text-muted'
    : ok
      ? 'bg-emerald-500/15 text-emerald-600'
      : 'bg-red-500/15 text-red-600';
  return (
    <span className={`rounded px-2 py-1 text-xs font-semibold ${cls}`}>
      {label} {empty ? '-' : value}
    </span>
  );
}

function Field({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div className="min-w-28">
      <div className="text-xs text-text-muted">{label}</div>
      <div className="text-sm font-semibold text-text">{value ?? '-'}</div>
    </div>
  );
}

export default function LineDashboardPage() {
  const [lineCode, setLineCode] = useState('');
  const [status, setStatus] = useState<LineStatusRow | null>(null);
  const [detail, setDetail] = useState<DashboardDetail>(EMPTY_DETAIL);
  const [pickup, setPickup] = useState<PickupRateRow[]>([]);
  const [pickupDate, setPickupDate] = useState<string | null>(null);
  const [tab, setTab] = useState<TabKey>('pickup');

  const [loading, setLoading] = useState(false);
  const [detailLoading, setDetailLoading] = useState(false);
  const [busy, setBusy] = useState(false);

  const [intervalSec, setIntervalSec] = useState('60');
  const [autoOn, setAutoOn] = useState(false);
  const [autoDetail, setAutoDetail] = useState(false);
  const [nsnpOpen, setNsnpOpen] = useState<'lock' | 'unlock' | null>(null);

  const loadStatus = useCallback(async (code: string) => {
    if (!code) return;
    setLoading(true);
    try {
      const response = await api.get('/tracking/dashboard/line', { params: { lineCode: code } });
      setStatus(response.data?.data?.[0] ?? null);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '라인 현황 조회에 실패했습니다.');
      setStatus(null);
    } finally {
      setLoading(false);
    }
  }, []);

  const loadDetail = useCallback(async (row: LineStatusRow | null) => {
    if (!row?.runningRunNo) {
      setDetail(EMPTY_DETAIL);
      return;
    }
    setDetailLoading(true);
    try {
      const [d, p] = await Promise.all([
        api.get('/tracking/dashboard/detail', {
          params: {
            runNo: row.runningRunNo,
            lineCode: row.lineCode,
            solderLotNo: row.solderLotNo || undefined,
            maskLotNo: row.maskLotNo || undefined,
            squeezeLotNo: row.squeezeLotNo || undefined,
            squeezeLotNo2: row.squeezeLotNo2 || undefined,
          },
        }),
        api.get('/tracking/dashboard/pickup-rate', { params: { lineCode: row.lineCode } }),
      ]);
      setDetail({ ...EMPTY_DETAIL, ...(d.data?.data ?? {}) });
      setPickup(p.data?.data ?? []);
      setPickupDate(p.data?.meta?.workDate ?? null);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '상세 조회에 실패했습니다.');
    } finally {
      setDetailLoading(false);
    }
  }, []);

  // 자동갱신. PB 의 Timer(interval) / Start / Stop 과 같다.
  // 상세까지 함께 갱신할지는 따로 켠다 — 매번 8개 쿼리를 다시 돌리면 무겁다.
  const autoRef = useRef<{ code: string; detail: boolean; status: LineStatusRow | null }>({
    code: '', detail: false, status: null,
  });
  autoRef.current = { code: lineCode, detail: autoDetail, status };

  const autoSec = Math.max(5, Number(intervalSec) || 60);
  useActiveInterval(() => {
    const { code, detail: withDetail, status: current } = autoRef.current;
    void loadStatus(code).then(() => {
      if (withDetail) void loadDetail(current);
    });
  }, autoOn && lineCode ? autoSec * 1000 : null, { catchUp: true });

  const applyNsnp = useCallback(async (lock: boolean) => {
    setNsnpOpen(null);
    if (!status) return;
    setBusy(true);
    try {
      const response = await api.put('/tracking/dashboard/nsnp', {
        lineCode: status.lineCode,
        lock,
      });
      const after = response.data?.data?.status;
      toast.success(
        `${lock ? '잠금' : '해제'} 처리했습니다 — 상태 `
        + `${after?.nsnpStatusName ?? after?.nsnpStatus ?? '(확인 불가)'}`,
      );
      void loadStatus(status.lineCode);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'NSNP 처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [status, loadStatus]);

  const rate = (v: number | null) => (v == null ? '-' : `${Number(v).toFixed(2)}%`);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">생산현황데쉬보드</h1>
          <p className="mt-1 text-sm text-text-muted">
            라인 하나의 진행 롯트·점검 상태·인터록을 한 화면에서 봅니다
            {status?.readAt && <span> · 읽은 시각 {status.readAt}</span>}
            {autoOn && <span className="ml-1 text-primary">· 자동갱신 {intervalSec}초</span>}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <div className="w-40">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Button size="sm" onClick={() => void loadStatus(lineCode)}
            disabled={!lineCode || loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" variant="secondary" onClick={() => void loadDetail(status)}
            disabled={!status?.runningRunNo || detailLoading}>
            <RefreshCw className="mr-1 h-4 w-4" />상세 읽기
          </Button>
          <label className="flex items-center gap-1 text-sm text-text">
            <Input aria-label="갱신 주기(초)" value={intervalSec} className="w-16"
              onChange={(e) => setIntervalSec(e.target.value.replace(/\D/g, ''))} />
            초
          </label>
          <Button size="sm" variant={autoOn ? 'secondary' : 'primary'}
            onClick={() => setAutoOn((v) => !v)} disabled={!lineCode}>
            {autoOn ? '자동갱신 정지' : '자동갱신 시작'}
          </Button>
          <label className="flex items-center gap-2 text-sm text-text">
            <input type="checkbox" checked={autoDetail}
              onChange={(e) => setAutoDetail(e.target.checked)} />
            상세도 함께
          </label>
        </div>
      </header>

      {!lineCode && (
        <div className="rounded border border-border bg-surface p-3 text-sm text-text-muted">
          라인을 고르면 그 라인의 현황이 나옵니다.
        </div>
      )}

      {status && (
        <>
          <Card padding="none">
            <CardContent className="flex flex-col gap-3 p-4">
              <div className="flex flex-wrap gap-6">
                <Field label="라인" value={status.lineName ?? status.lineCode} />
                <Field label="라인상태" value={status.lineStatusName ?? status.lineStatus} />
                <Field label="Run No" value={status.runningRunNo} />
                <Field label="모델" value={status.runningModelName} />
                <Field label="고객" value={status.customerName} />
                <Field label="진행상태" value={status.runStatusName ?? status.runStatus} />
                <Field label="계획" value={status.planQty?.toLocaleString()} />
                <Field label="투입" value={status.inputQty?.toLocaleString()} />
                <Field label="실적" value={status.actualQty?.toLocaleString()} />
                <Field label="불량" value={status.ngQty?.toLocaleString()} />
                <Field label="목표수량" value={status.targetQty?.toLocaleString()} />
                <Field label="표준 택트(초)" value={status.modelSt?.toLocaleString()} />
                <Field label="실제 택트(초)" value={status.realSt?.toLocaleString()} />
                <Field label="SPI 양품률" value={rate(status.spiPassRate)} />
                <Field label="AOI 양품률" value={rate(status.aoiPassRate)} />
              </div>

              <div className="flex flex-wrap items-center gap-2 border-t border-border pt-3">
                <CheckBadge label="솔더" value={status.solderCheck} />
                <CheckBadge label="마스크" value={status.maskCheck} />
                <CheckBadge label="스퀴지" value={status.squeezeCheck} />
                <CheckBadge label="CCS" value={status.ccsCheck} />
                <CheckBadge label="풀체크" value={status.fullCheck} />
                <CheckBadge label="X-RAY" value={status.xrayCheck} />
                <CheckBadge label="사양" value={status.specCheck} />
                <CheckBadge label="샘플" value={status.sampleCheck} />
                <CheckBadge label="노즐" value={status.nozzleCheck} />
                <CheckBadge label="백업블록" value={status.backupBlockCheck} />
                {status.solderRemainTime && (
                  <span className="ml-2 text-sm text-text-muted">
                    솔더 잔여 {status.solderRemainTime}
                  </span>
                )}
                {status.qcComments && (
                  <span className="ml-2 text-sm text-amber-500">QC: {status.qcComments}</span>
                )}
              </div>

              <div className="flex flex-wrap items-center gap-3 border-t border-border pt-3">
                <b className="text-sm text-text">
                  인터록 {status.nsnpStatusName ?? status.nsnpStatus ?? '-'}
                </b>
                {status.nsnpLockTypeName && (
                  <span className="text-sm text-text-muted">
                    유형 {status.nsnpLockTypeName}
                  </span>
                )}
                {status.nsnpReason && (
                  <span className="text-sm text-text-muted">사유 {status.nsnpReason}</span>
                )}
                {status.nsnpStartDate && (
                  <span className="text-sm text-text-muted">시작 {status.nsnpStartDate}</span>
                )}
                <Button size="sm" variant="secondary" disabled={busy}
                  onClick={() => setNsnpOpen('lock')}>
                  <Lock className="mr-1 h-4 w-4" />NSNP 잠금
                </Button>
                <Button size="sm" variant="secondary" disabled={busy}
                  onClick={() => setNsnpOpen('unlock')}>
                  <Unlock className="mr-1 h-4 w-4" />NSNP 해제
                </Button>
                <span className="text-sm text-text-muted">사용자 레벨 8 이상만 가능합니다</span>
              </div>
            </CardContent>
          </Card>

          <div className="flex flex-wrap gap-1 border-b border-border">
            {TABS.map((t) => {
              const count = t.key === 'pickup' ? pickup.length : detail[t.key].length;
              return (
                <button
                  key={t.key}
                  type="button"
                  onClick={() => setTab(t.key)}
                  className={`px-3 py-2 text-sm ${tab === t.key
                    ? 'border-b-2 border-primary font-semibold text-text'
                    : 'text-text-muted hover:text-text'}`}
                >
                  {t.label}
                  {count > 0 && <span className="ml-1 text-xs text-text-muted">{count}</span>}
                </button>
              );
            })}
          </div>

          <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
            <CardContent className="flex h-full flex-col gap-2 p-3">
              {tab === 'pickup' && (
                <>
                  <span className="text-sm text-text-muted">
                    업무일 {pickupDate ?? '-'} 기준 (자정이 아니라 교대 기준 —
                    DB 함수 F_GET_WORK_ACTUAL_DATE 가 정한다)
                  </span>
                  <div className="min-h-0 flex-1">
                    <DataGrid data={pickup} columns={pickupRateColumns}
                      isLoading={detailLoading} pageSize={20}
                      emptyMessage="이 업무일에 픽업 데이터가 없습니다."
                      getRowId={(r) => (r as PickupRateRow).lineCode} />
                  </div>
                </>
              )}
              {tab === 'solder' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.solder} columns={solderTabColumns}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter enableExport
                    exportFileName="솔더이력"
                    emptyMessage="이 롯트에 물린 솔더 바코드가 없습니다." />
                </div>
              )}
              {tab === 'mask' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.mask} columns={jigCheckColumns('mask')}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter
                    emptyMessage="이 마스크 지그의 점검 이력이 없습니다." />
                </div>
              )}
              {tab === 'squeeze' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.squeeze} columns={jigCheckColumns('squeeze')}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter
                    emptyMessage="이 스퀴지 지그의 점검 이력이 없습니다." />
                </div>
              )}
              {tab === 'msl' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.msl} columns={mslTabColumns}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter enableExport
                    exportFileName="MSL경과"
                    emptyMessage="이 라인에 MSL 관리 대상 자재가 없습니다." />
                </div>
              )}
              {tab === 'pcb' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.pcb} columns={pcbInputTabColumns}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter
                    emptyMessage="이 롯트에 스캔된 PCB 가 없습니다." />
                </div>
              )}
              {tab === 'sample' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.sample} columns={sampleTabColumns}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter
                    emptyMessage="이 롯트에 투입된 샘플이 없습니다." />
                </div>
              )}
              {tab === 'reel' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.reel} columns={reelChangeTabColumns}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter enableExport
                    exportFileName="릴교환이력"
                    emptyMessage="이 롯트의 자재 투입·교환 이력이 없습니다." />
                </div>
              )}
              {tab === 'interlock' && (
                <div className="min-h-0 flex-1">
                  <DataGrid data={detail.interlock} columns={interlockTabColumns}
                    isLoading={detailLoading} pageSize={50} enableColumnFilter
                    emptyMessage="이 라인의 인터록 이력이 없습니다." />
                </div>
              )}
            </CardContent>
          </Card>
        </>
      )}

      <ConfirmModal
        isOpen={nsnpOpen !== null}
        onClose={() => setNsnpOpen(null)}
        onConfirm={() => applyNsnp(nsnpOpen === 'lock')}
        title={nsnpOpen === 'lock' ? 'NSNP 잠금' : 'NSNP 강제해제'}
        message={status
          ? `라인 ${status.lineName ?? status.lineCode} 의 인터록을 `
            + `${nsnpOpen === 'lock' ? '잠급니다' : '해제합니다'}. `
            + (nsnpOpen === 'lock'
              ? '잠그면 이 라인의 생산이 멈춥니다.'
              : '해제하면 오삽 방지 잠금이 풀립니다. 원인을 확인한 뒤 누르세요.')
          : ''}
        variant={nsnpOpen === 'unlock' ? 'danger' : undefined}
      />
    </div>
  );
}
