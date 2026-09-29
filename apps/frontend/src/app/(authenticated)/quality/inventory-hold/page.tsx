"use client";

/**
 * @file src/app/(authenticated)/quality/inventory-hold/page.tsx
 * @description 재고통제관리 — PB w_qc_inventory_hold_master 이식
 *
 * 초보자 가이드:
 * 1. **통제는 별도 테이블에 행을 만드는 것이다** — `IM_ITEM_INVENTORY_HOLD`.
 *    재고 자체는 건드리지 않는다. 해제하면 그 행을 지운다 (PB 와 같다).
 * 2. **대상 조회는 품목코드나 자재LOT 중 하나가 필요하다.** 자재재고가 180만 행이고
 *    그 둘에만 인덱스가 있다.
 * 3. **탭 2개** — 통제대상(재고에서 고르기) / 통제목록(이미 통제된 LOT).
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Ban, PackageX, Search, Undo2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  inventoryHoldColumns,
  inventoryHoldTargetColumns,
  type InventoryHoldRow,
  type InventoryHoldTargetRow,
} from '../notify-columns';

type Mode = 'targets' | 'holds';
type Key = { itemCode: string; materialMfs: string };

const keyOf = (row: Key) => `${row.itemCode}|${row.materialMfs}`;

export default function InventoryHoldPage() {
  const [mode, setMode] = useState<Mode>('targets');
  const [targets, setTargets] = useState<InventoryHoldTargetRow[]>([]);
  const [holds, setHolds] = useState<InventoryHoldRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [itemCode, setItemCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');
  const [inventoryStatus, setInventoryStatus] = useState('');

  const [picked, setPicked] = useState<Map<string, Key>>(new Map());
  const [holdStatus, setHoldStatus] = useState('B');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);
  const [confirm, setConfirm] = useState<'apply' | 'release' | null>(null);

  const hasRequired = Boolean(itemCode.trim() || materialMfs.trim());

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (mode === 'targets') {
        if (!hasRequired) {
          toast.error('품목코드 또는 자재LOT 중 하나를 입력하세요.');
          return;
        }
        const response = await api.get('/quality/inventory-hold/targets', {
          params: {
            itemCode: itemCode || undefined,
            materialMfs: materialMfs || undefined,
          },
        });
        setTargets(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      } else {
        const response = await api.get('/quality/inventory-hold', {
          params: {
            itemCode: itemCode || undefined,
            materialMfs: materialMfs || undefined,
            inventoryStatus: inventoryStatus || undefined,
          },
        });
        setHolds(response.data?.data ?? []);
        setTotal(Number(response.data?.meta?.total ?? 0));
      }
      setSearched(true);
      setPicked(new Map());
    } catch {
      toast.error('조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [mode, hasRequired, itemCode, materialMfs, inventoryStatus]);

  const changeMode = useCallback((next: Mode) => {
    setMode(next);
    setTargets([]);
    setHolds([]);
    setTotal(0);
    setSearched(false);
    setPicked(new Map());
  }, []);

  const toggle = useCallback((row: Key) => {
    setPicked((prev) => {
      const next = new Map(prev);
      const key = keyOf(row);
      if (next.has(key)) next.delete(key);
      else next.set(key, { itemCode: row.itemCode, materialMfs: row.materialMfs });
      return next;
    });
  }, []);

  const applyHold = useCallback(async () => {
    setConfirm(null);
    if (picked.size === 0) return;
    setBusy(true);
    try {
      const response = await api.post('/quality/inventory-hold', {
        materialMfsList: [...picked.values()],
        inventoryStatus: holdStatus,
        comments: comments || undefined,
      });
      toast.success(`${response.data?.data?.applied ?? 0}건을 통제했습니다.`);
      void search();
    } catch {
      toast.error('통제 등록에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [picked, holdStatus, comments, search]);

  const releaseHold = useCallback(async () => {
    setConfirm(null);
    if (picked.size === 0) return;
    setBusy(true);
    try {
      const response = await api.delete('/quality/inventory-hold', {
        data: { materialMfsList: [...picked.values()] },
      });
      toast.success(`${response.data?.data?.released ?? 0}건의 통제를 해제했습니다.`);
      void search();
    } catch {
      toast.error('통제 해제에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [picked, search]);

  const targetCols = useMemo(() => inventoryHoldTargetColumns, []);
  const holdCols = useMemo(() => inventoryHoldColumns, []);
  const shown = mode === 'targets' ? targets.length : holds.length;

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <PackageX className="h-6 w-6 text-primary" />재고통제관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            자재 LOT 단위로 사용을 막고 해제합니다 ·{' '}
            {searched ? `${shown}/${total}건 · ${picked.size}건 선택` : '조회조건을 입력하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44" onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="자재LOT" placeholder="자재LOT" value={materialMfs}
            className="w-52" onChange={(e) => setMaterialMfs(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          {mode === 'holds' && (
            <ComCodeSelect groupCode="INVENTORY STATUS" labelPrefix="통제상태"
              value={inventoryStatus} onChange={setInventoryStatus} className="w-44" />
          )}
          {mode === 'targets' && !hasRequired && (
            <span className="text-xs text-amber-600">
              자재재고는 180만 행입니다. 품목코드 또는 자재LOT 을 입력하세요.
            </span>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-end gap-3 p-3">
          <span className="self-center text-sm text-text-muted">
            {picked.size > 0 ? `${picked.size}건 선택` : '행을 클릭해 선택하세요'}
          </span>
          {mode === 'targets' ? (
            <>
              <label className="text-xs text-text-muted">
                통제상태
                <ComCodeSelect groupCode="INVENTORY STATUS" includeAll={false}
                  value={holdStatus} onChange={setHoldStatus} className="w-36" />
              </label>
              <label className="text-xs text-text-muted">
                통제사유
                <Input value={comments} className="w-64"
                  onChange={(e) => setComments(e.target.value)} />
              </label>
              <Button size="sm" disabled={picked.size === 0 || busy}
                onClick={() => setConfirm('apply')}>
                <Ban className="mr-1 h-4 w-4" />통제
              </Button>
            </>
          ) : (
            <Button size="sm" variant="secondary" disabled={picked.size === 0 || busy}
              onClick={() => setConfirm('release')}>
              <Undo2 className="mr-1 h-4 w-4" />통제해제
            </Button>
          )}
          {picked.size > 0 && (
            <Button size="sm" variant="secondary" onClick={() => setPicked(new Map())}>
              선택 해제
            </Button>
          )}
        </CardContent>
      </Card>

      <nav className="flex gap-1 border-b border-border" aria-label="조회 모드">
        {([['targets', '통제대상'], ['holds', '통제목록']] as const).map(([key, label]) => (
          <button
            key={key}
            type="button"
            onClick={() => changeMode(key)}
            className={`px-3 py-1.5 text-sm ${
              mode === key
                ? 'border-b-2 border-primary font-semibold text-text'
                : 'text-text-muted'
            }`}
          >
            {label}
          </button>
        ))}
      </nav>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {mode === 'targets' ? (
            <DataGrid
              data={targets}
              columns={targetCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="재고통제대상"
              emptyMessage="품목코드 또는 자재LOT 을 넣고 조회하세요."
              onRowClick={(row) => toggle(row as InventoryHoldTargetRow)}
              rowClassName={(row) => {
                const r = row as InventoryHoldTargetRow;
                if (picked.has(keyOf(r))) return 'bg-primary/10';
                return r.heldYn === 'Y' ? 'bg-amber-50 dark:bg-amber-950/20' : '';
              }}
              getRowId={(row) => keyOf(row as InventoryHoldTargetRow)}
            />
          ) : (
            <DataGrid
              data={holds}
              columns={holdCols}
              isLoading={loading}
              pageSize={50}
              enableColumnFilter
              enableExport
              exportFileName="재고통제목록"
              emptyMessage="조회 버튼을 눌러 통제 LOT 을 확인하세요."
              onRowClick={(row) => toggle(row as InventoryHoldRow)}
              rowClassName={(row) =>
                picked.has(keyOf(row as InventoryHoldRow)) ? 'bg-primary/10' : ''}
              getRowId={(row) => keyOf(row as InventoryHoldRow)}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirm === 'apply'}
        onClose={() => setConfirm(null)}
        onConfirm={applyHold}
        title="재고통제 등록"
        message={`선택한 ${picked.size}건의 자재 LOT 을 통제합니다. 통제된 LOT 은 사용을 막습니다.`}
        variant="danger"
      />
      <ConfirmModal
        isOpen={confirm === 'release'}
        onClose={() => setConfirm(null)}
        onConfirm={releaseHold}
        title="재고통제 해제"
        message={`선택한 ${picked.size}건의 통제를 해제합니다. 통제 이력 행이 지워집니다.`}
        variant="danger"
      />
    </main>
  );
}
