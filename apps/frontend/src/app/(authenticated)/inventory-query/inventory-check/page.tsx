"use client";

/**
 * @file src/app/(authenticated)/inventory-query/inventory-check/page.tsx
 * @description 자재재고실사 — 창고 자재 릴을 바코드로 세어 자재재고를 맞춘다
 *
 * 초보자 가이드:
 * 1. **순서**: 실사 시작(지금 재고를 장부로 고정) → 릴 바코드 스캔·엑셀(PDA 로도 가능) → 일괄 조정.
 *    공정재고실사·제품재고실사 화면과 같은 구성이다.
 * 2. **차이 = 실사 − 장부.** 실제가 많으면(+) 재고가 늘고, 적으면(−) 준다. 안 찍은 롯트는 없는 것으로 본다.
 * 3. **조정은 마감월의 마지막 날짜로 들어간다.** 오늘 날짜로 넣으면 다음 달 수불로 새어 나가기 때문이다.
 *    마감된 달은 조정되지 않는다.
 * 4. 실사 진행은 stocktake-panel.tsx, 바코드 입력은 scan-card.tsx, API 는 ../stocktake.ts.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import DataGrid from '@/components/data-grid/DataGrid';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { useTruncation } from '../../report/components/TruncationNotice';
import { barcodeCheckColumns, inventoryCheckColumns } from '../inventory-query-columns';
import type { BarcodeCheckRow, InventoryCheckRow } from '../inventory-query-columns';
import StocktakeFilterBar, { startsWithCond, type StocktakeStatusFilter } from '@/components/shared/StocktakeFilterBar';
import StocktakePanel from './stocktake-panel';
import ScanCard from './scan-card';
import { apiMessage, stocktakeApi, type StocktakeSession } from '../stocktake';

type TabKey = 'check' | 'scan';

export default function InventoryCheckPage() {
  const [session, setSession] = useState<StocktakeSession | null>(null);
  const [tab, setTab] = useState<TabKey>('check');
  const [checks, setChecks] = useState<InventoryCheckRow[]>([]);
  const [scans, setScans] = useState<BarcodeCheckRow[]>([]);
  const [loading, setLoading] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();
  const [status, setStatus] = useState<StocktakeStatusFilter>('');
  const [itemCodeCond, setItemCodeCond] = useState('');
  const [lotNoCond, setLotNoCond] = useState('');

  const shownChecks = useMemo(() => checks.filter((r) =>
    (status !== 'diff' || Number(r.differenceQty ?? 0) !== 0)
    && (status !== 'unscanned' || r.scannedYn !== 'Y')
    && startsWithCond(r.itemCode, itemCodeCond)
    && startsWithCond(r.lotNo, lotNoCond)), [checks, status, itemCodeCond, lotNoCond]);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const s = await stocktakeApi.active();
      setSession(s);
      if (!s) {
        setChecks([]);
        setScans([]);
        return;
      }
      const params = { yyyymm: s.yyyymm };
      const [c, b] = await Promise.all([
        api.get('/inventory-query/check', { params }),
        api.get('/inventory-query/barcode', { params }),
      ]);
      setChecks(c.data?.data ?? []);
      setScans(b.data?.data ?? []);
      mark(c);
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mark]);

  useEffect(() => { void load(); }, [load]);

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재재고실사</h1>
        <p className="mt-1 text-sm text-text-muted">
          창고 자재 릴을 바코드로 세어 자재재고를 맞춥니다 · 차이 = 실사 − 장부
        </p>
      </header>

      <StocktakePanel session={session} onChanged={() => { void load(); }} />

      {session && <ScanCard session={session} onScanned={() => { void load(); }} />}

      <ScreenTabs
        tabs={[
          { key: 'check' as TabKey, label: '실사표', count: shownChecks.length },
          { key: 'scan' as TabKey, label: '입력 기록', count: scans.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      {tab === 'check' && (
        <StocktakeFilterBar
          status={status}
          onStatusChange={setStatus}
          fields={[
            { key: 'itemCode', label: '품목코드', value: itemCodeCond, onChange: setItemCodeCond },
            { key: 'lotNo', label: '롯트번호', value: lotNoCond, onChange: setLotNoCond },
          ]}
          truncatedLimit={truncated ? rowLimit : null}
        />
      )}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'check' ? (
            <DataGrid
              data={shownChecks}
              columns={inventoryCheckColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={`자재재고실사_${session?.yyyymm ?? ''}`}
              emptyMessage="실사표가 없습니다. 실사를 시작하세요."
              rowClassName={(row) => (Number((row as InventoryCheckRow).differenceQty ?? 0) !== 0
                ? 'bg-amber-500/5'
                : '')}
            />
          ) : (
            <DataGrid
              data={scans}
              columns={barcodeCheckColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName={`자재재고실사_입력_${session?.yyyymm ?? ''}`}
              emptyMessage="입력이 없습니다."
              rowClassName={(row) => (Number((row as BarcodeCheckRow).differenceQty ?? 0) !== 0
                ? 'bg-amber-500/5'
                : '')}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
