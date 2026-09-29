"use client";

/**
 * @file src/app/(authenticated)/warehouse/msl-check/page.tsx
 * @description MSL 이상품목 처리이력관리 — PB w_mat_msl_item_check_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **MSL 시간을 넘긴 자재를 찾아 무엇을 했는지 남기는 화면이다.** MSL 은 습기에
 *    민감한 부품이 공기에 노출된 누적 시간이고, 품목마다 허용 시간이 있다.
 *    넘긴 자재는 **베이킹해서 시계를 되돌리거나**(베이킹이력관리) 폐기해야 한다.
 * 2. **탭 네 개**로 나뉜다.
 *      재고  — 창고에 있는데 MSL 이 넘은 릴
 *      투입  — 이미 라인에 나간 릴의 MSL 경과
 *      현황  — 라인·모델·피더 위치까지 붙은 전체 현황
 *      이력  — 무엇을 했는지 적어 둔 것
 * 3. **경과율이 100%를 넘으면 빨갛게 보인다** — 허용시간을 이미 지났다는 뜻이다.
 * 4. **처리이력은 아직 비어 있다.** 현장에서 쓰기 시작한 적이 없다 (표가 0행).
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { ClipboardCheck, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ModelSearchField from '@/components/shared/ModelSearchField';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input, Select } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  mslHistoryColumns,
  mslInventoryColumns,
  mslIssuedColumns,
  mslViewColumns,
} from '../reprint-msl-columns';
import type {
  MslHistoryRow,
  MslInventoryRow,
  MslIssuedRow,
  MslViewRow,
} from '../reprint-msl-columns';

type TabKey = 'inventory' | 'issued' | 'view' | 'history';

const TAB_LABELS: Record<TabKey, string> = {
  inventory: '재고 (MSL 초과)',
  issued: '투입 (MSL 경과)',
  view: '현황',
  history: '처리이력',
};

const LEVEL_OPTIONS = [
  { value: '2', label: 'MSL 2 이상' },
  { value: '2A', label: 'MSL 2A 이상' },
  { value: '3', label: 'MSL 3 이상' },
  { value: '1', label: 'MSL 1 이상 (전체)' },
];
const RATE_OPTIONS = [
  { value: '100', label: '경과율 100% 이상 (넘긴 것)' },
  { value: '80', label: '경과율 80% 이상' },
  { value: '50', label: '경과율 50% 이상' },
  { value: '0', label: '전체' },
];

export default function MslCheckPage() {
  const [tab, setTab] = useState<TabKey>('inventory');
  const [itemCode, setItemCode] = useState('');
  const [mslLevel, setMslLevel] = useState('2');
  const [passedRate, setPassedRate] = useState('100');
  const [lineCode, setLineCode] = useState('');
  const [modelName, setModelName] = useState('');

  const [inventory, setInventory] = useState<MslInventoryRow[]>([]);
  const [issued, setIssued] = useState<MslIssuedRow[]>([]);
  const [view, setView] = useState<MslViewRow[]>([]);
  const [history, setHistory] = useState<MslHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 처리이력 등록 (쓰기)
  const [barcode, setBarcode] = useState('');
  const [actionCode, setActionCode] = useState('');
  const [comments, setComments] = useState('');
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const overParams = {
        itemCode: itemCode || undefined,
        mslLevel,
        passedRate: Number(passedRate),
      };
      if (tab === 'inventory') {
        const r = await api.get('/warehouse/msl-check/inventory', { params: overParams });
        setInventory(r.data?.data ?? []); mark(r);
      } else if (tab === 'issued') {
        const r = await api.get('/warehouse/msl-check/issued', { params: overParams });
        setIssued(r.data?.data ?? []); mark(r);
      } else if (tab === 'view') {
        const r = await api.get('/warehouse/msl-check/view', {
          params: {
            itemCode: itemCode || undefined,
            lineCode: lineCode || undefined,
            modelName: modelName || undefined,
          },
        });
        setView(r.data?.data ?? []); mark(r);
      } else {
        const r = await api.get('/warehouse/msl-check/history', {
          params: { itemCode: itemCode || undefined, barcode: barcode || undefined },
        });
        setHistory(r.data?.data ?? []); mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, itemCode, mslLevel, passedRate, lineCode, modelName, barcode, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  const blocker = !barcode.trim()
    ? '자재 바코드를 넣으세요.'
    : !actionCode.trim()
      ? '처리코드를 넣으세요.'
      : null;

  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      await api.post('/warehouse/msl-check/history', {
        barcode: barcode.trim(),
        mslActionCode: actionCode.trim(),
        comments: comments.trim() || undefined,
      });
      toast.success('처리이력을 남겼습니다.');
      setComments('');
      if (tab === 'history') void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, actionCode, comments, tab, search]);

  const counts: Record<TabKey, number> = {
    inventory: inventory.length, issued: issued.length,
    view: view.length, history: history.length,
  };

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">MSL 이상품목 처리이력관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          MSL 허용시간을 넘긴 자재를 찾고 처리 결과를 남깁니다 ·{' '}
          {searched ? `${TAB_LABELS[tab]} ${counts[tab].toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 처리이력 등록 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ClipboardCheck className="h-4 w-4" />처리 등록
          </span>
          <Input aria-label="자재 바코드" placeholder="자재 바코드" value={barcode}
            className="w-64"
            onChange={(e) => setBarcode(e.target.value)} />
          <Input aria-label="처리코드" placeholder="처리코드 (베이킹·폐기 등)"
            value={actionCode} className="w-48"
            onChange={(e) => setActionCode(e.target.value)} />
          <Input aria-label="비고" placeholder="비고" value={comments}
            className="w-64"
            onChange={(e) => setComments(e.target.value)} />
          <Button size="sm" disabled={busy || Boolean(blocker)}
            onClick={() => setConfirmOpen(true)}>
            등록
          </Button>
          <span className="text-sm text-text-muted">
            품목·롯트·수량은 바코드에서 자동으로 채워집니다.
          </span>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={(Object.keys(TAB_LABELS) as TabKey[]).map((k) => ({
          key: k, label: TAB_LABELS[k], count: counts[k],
        }))}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          {(tab === 'inventory' || tab === 'issued') && (
            <>
              <Select options={LEVEL_OPTIONS} value={mslLevel} onChange={setMslLevel}
                className="w-44" />
              <Select options={RATE_OPTIONS} value={passedRate} onChange={setPassedRate}
                className="w-56" />
            </>
          )}
          {tab === 'view' && (
            <>
              <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
                className="w-32"
                onChange={(e) => setLineCode(e.target.value)} />
              <ModelSearchField aria-label="모델명" placeholder="모델명" value={modelName}
                className="w-48"
                onChange={(v) => setModelName(v)} />
            </>
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {tab === 'history' && searched && history.length === 0 && (
            <span className="text-sm text-text-muted">
              처리이력은 아직 비어 있습니다 — 현장에서 쓰기 시작한 적이 없습니다.
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'inventory' ? (
            <DataGrid data={inventory} columns={mslInventoryColumns}
              isLoading={loading} pageSize={100} enableColumnFilter enableExport
              exportFileName="MSL초과_재고"
              emptyMessage={searched ? '조건에 맞는 릴이 없습니다.' : '조회하세요.'}
              onRowClick={(row) => setBarcode(String((row as MslInventoryRow).itemBarcode ?? ''))} />
          ) : tab === 'issued' ? (
            <DataGrid data={issued} columns={mslIssuedColumns}
              isLoading={loading} pageSize={100} enableColumnFilter enableExport
              exportFileName="MSL경과_투입"
              emptyMessage={searched ? '조건에 맞는 릴이 없습니다.' : '조회하세요.'}
              onRowClick={(row) => setBarcode(String((row as MslIssuedRow).itemBarcode ?? ''))} />
          ) : tab === 'view' ? (
            <DataGrid data={view} columns={mslViewColumns}
              isLoading={loading} pageSize={100} enableColumnFilter enableExport
              exportFileName="MSL현황"
              emptyMessage={searched ? '현황이 없습니다.' : '조회하세요.'}
              onRowClick={(row) => setBarcode(String((row as MslViewRow).itemBarcode ?? ''))} />
          ) : (
            <DataGrid data={history} columns={mslHistoryColumns}
              isLoading={loading} pageSize={100} enableExport
              exportFileName="MSL처리이력"
              emptyMessage={searched ? '처리이력이 없습니다.' : '조회하세요.'} />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="MSL 처리이력 등록"
        message={`${barcode} 에 처리코드 ${actionCode} 를 남깁니다.`}
        confirmText="등록"
      />
    </div>
  );
}
