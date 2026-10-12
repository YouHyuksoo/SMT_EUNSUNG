"use client";

/**
 * @file src/app/(authenticated)/product/pack/page.tsx
 * @description 299 제품포장관리(PID) — PB w_prd_product_packing_create_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **완성된 기판을 박스에 담는 화면이다.** ① 박스를 하나 만들고 ② 담을 기판의
 *    PID 를 하나씩 찍고 ③ 다 담으면 포장완료를 누른다.
 * 2. **박스는 만드는 순간 확정된다.** 번호를 DB 함수가 만드는데 그 안이
 *    자기만의 트랜잭션이라 되돌지 않는다 (PB 도 같다). 잘못 만들었으면
 *    **빈 박스 삭제**로 지운다 — 담긴 PID 가 있으면 지워지지 않는다.
 * 3. **한 PID 는 한 박스에만.** 이미 담긴 PID 를 찍으면 거절한다.
 * 4. **포장완료 후에는 뺄 수 없다.** 완료·입고된 박스에서 PID 를 빼면 박스 수량과
 *    실제 내용이 어긋난 채 입고로 넘어가기 때문이다.
 * 5. **담기 전에 인터락 검사를 거친다.** 라인·공정에 걸린 검사 항목을 서버가
 *    차례로 보고 하나라도 NG 면 담기지 않는다 — PB 가 막던 것과 같다.
 * 6. **수리품은 수리품으로 찍어야 한다.** 공정 수리 이력 유무와 체크가 어긋나면 거절한다.
 * 7. **라벨 인쇄는 없다.** PB 는 BarTender 로 찍는다 — 여기서는 재출력 횟수만 올린다.
 * 8. **기본 기간이 7일이다.** 이 표는 기간 컬럼에 인덱스가 없어 한 달을 보면
 *    9,000행에 8.7초가 걸린다 (7일이면 2.4초).
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { Box, PackageCheck, Printer, ScanLine, Search, Trash2, Undo2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ProcessSelect from '@/components/shared/ProcessSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import ModelSearchField from '@/components/shared/ModelSearchField';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { packColumns, packSerialColumns } from '../shipping-columns';
import type { PackRow, PackSerialRow } from '../shipping-columns';
import PartSearchField from '@/components/shared/PartSearchField';

/** 오늘 / 7일 전 — 기본 기간을 좁게 잡는 이유는 파일 상단 주석 6번. */
const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

/** 현장 PC 는 같은 라인·공정만 계속 쓴다 — PB 의 WORKENV.INI 를 브라우저로 옮긴 것. */
const LINE_KEY = 'mes-product-pack-line';
const WORKSTAGE_KEY = 'mes-product-pack-workstage';

export default function ProductPackPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [packBarcodeCond, setPackBarcodeCond] = useState('');
  const [modelNameCond, setModelNameCond] = useState('');

  const [packs, setPacks] = useState<PackRow[]>([]);
  const [selected, setSelected] = useState<PackRow | null>(null);
  const [serials, setSerials] = useState<PackSerialRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 작업 조건 (박스를 만들 때와 담을 때 같이 쓴다)
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');

  // 박스 만들기
  const [modelName, setModelName] = useState('');
  const [modelSuffix, setModelSuffix] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [packUnitQty, setPackUnitQty] = useState('');

  // PID 스캔
  const [pid, setPid] = useState('');
  const [unpackMode, setUnpackMode] = useState(false);
  const [repairMode, setRepairMode] = useState(false);
  const [lastResult, setLastResult] = useState<string | null>(null);
  const pidRef = useRef<HTMLInputElement>(null);

  const [completeOpen, setCompleteOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  useEffect(() => {
    try {
      const l = window.localStorage.getItem(LINE_KEY);
      const w = window.localStorage.getItem(WORKSTAGE_KEY);
      if (l) setLineCode(l);
      if (w) setWorkstageCode(w);
    } catch { /* 저장소를 못 쓰면 그냥 고르게 둔다 */ }
  }, []);

  useEffect(() => {
    try {
      if (lineCode) window.localStorage.setItem(LINE_KEY, lineCode);
      if (workstageCode) window.localStorage.setItem(WORKSTAGE_KEY, workstageCode);
    } catch { /* 무시 */ }
  }, [lineCode, workstageCode]);

  const loadSerials = useCallback(async (packBarcode: string) => {
    try {
      const r = await api.get('/product/pack/serials', { params: { packBarcode } });
      setSerials(r.data?.data ?? []);
    } catch {
      setSerials([]);
    }
  }, []);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/product/pack', {
        params: {
          dateFrom,
          dateTo,
          packBarcode: packBarcodeCond || undefined,
          modelName: modelNameCond || undefined,
        },
      });
      setPacks(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, packBarcodeCond, modelNameCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const pick = useCallback(async (row: PackRow) => {
    setSelected(row);
    setLastResult(null);
    await loadSerials(row.packBarcode);
    pidRef.current?.focus();
  }, [loadSerials]);

  const createBlocker = !modelName.trim()
    ? '모델을 넣으세요.'
    : !itemCode.trim()
      ? '품목코드를 넣으세요.'
      : !lineCode
        ? '라인을 고르세요.'
        : !workstageCode
          ? '공정을 고르세요.'
          : !(Number(packUnitQty) > 0)
            ? '박스 정량을 1 이상으로 넣으세요.'
            : null;

  const createPack = useCallback(async () => {
    setBusy(true);
    try {
      const r = await api.post('/product/pack', {
        modelName: modelName.trim(),
        modelSuffix: modelSuffix.trim() || undefined,
        itemCode: itemCode.trim(),
        lineCode,
        workstageCode,
        packUnitQty: Number(packUnitQty),
      });
      const packBarcode = String(r.data?.data?.packBarcode ?? '');
      toast.success(`박스를 만들었습니다: ${packBarcode}`);
      await search();
      setSelected({ packBarcode } as PackRow);
      setSerials([]);
      pidRef.current?.focus();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '박스를 만들지 못했습니다.');
    } finally {
      setBusy(false);
    }
  }, [modelName, modelSuffix, itemCode, lineCode, workstageCode, packUnitQty, search]);

  /** PID 를 찍으면 바로 처리하고 입력칸을 비운다 (현장은 연속으로 찍는다). */
  const scanPid = useCallback(async () => {
    const serialNo = pid.trim();
    if (!selected || !serialNo) return;
    setBusy(true);
    try {
      await api.post(unpackMode ? '/product/pack/unpack' : '/product/pack/scan', {
        packBarcode: selected.packBarcode,
        serialNo,
        lineCode,
        workstageCode,
        repair: repairMode,
      });
      setLastResult(`${unpackMode ? '뺐습니다' : '담았습니다'}: ${serialNo}`);
      setPid('');
      await loadSerials(selected.packBarcode);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
      setLastResult(null);
      setPid('');
    } finally {
      setBusy(false);
      pidRef.current?.focus();
    }
  }, [pid, selected, unpackMode, repairMode, lineCode, workstageCode, loadSerials]);

  const act = useCallback(async (kind: 'complete' | 'reprint' | 'delete') => {
    if (!selected) return;
    setCompleteOpen(false);
    setDeleteOpen(false);
    setBusy(true);
    try {
      if (kind === 'delete') {
        await api.delete('/product/pack', {
          data: { packBarcode: selected.packBarcode },
        });
        toast.success(`빈 박스를 지웠습니다: ${selected.packBarcode}`);
        setSelected(null);
        setSerials([]);
      } else {
        const r = await api.post(`/product/pack/${kind}`, {
          packBarcode: selected.packBarcode,
        });
        toast.success(kind === 'complete'
          ? `포장완료 — 담긴 수량 ${r.data?.data?.packQty ?? serials.length}`
          : '재출력 횟수를 올렸습니다.');
      }
      await search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, serials.length, search]);

  const canEdit = Boolean(selected)
    && String(selected?.completeFlag ?? 'N') !== 'Y'
    && String(selected?.receiptFlag ?? 'N') !== 'Y';

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">제품포장관리(PID)</h1>
        <p className="mt-1 text-sm text-text-muted">
          완성된 기판을 박스에 담습니다 ·{' '}
          {selected
            ? `${selected.packBarcode} · ${serials.length.toLocaleString()}개 담김`
            : searched ? `박스 ${packs.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 작업 조건 + 박스 만들기 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <Box className="h-4 w-4" />박스 만들기
          </span>
          <LineSelect aria-label="라인" value={lineCode} className="w-36"
            onChange={setLineCode} />
          <ProcessSelect aria-label="공정" value={workstageCode} className="w-40"
            onChange={setWorkstageCode} />
          <Input aria-label="모델" placeholder="모델" value={modelName} className="w-40"
            onChange={(e) => setModelName(e.target.value)} />
          <Input aria-label="서픽스" placeholder="서픽스" value={modelSuffix}
            className="w-28"
            onChange={(e) => setModelSuffix(e.target.value)} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-36"
            onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="박스 정량" placeholder="박스 정량" value={packUnitQty}
            className="w-28" inputMode="numeric"
            onChange={(e) => setPackUnitQty(e.target.value)} />
          <Button size="sm" disabled={busy || Boolean(createBlocker)}
            onClick={createPack}>
            만들기
          </Button>
          {createBlocker && (modelName || itemCode) && (
            <span className="text-sm text-amber-500">{createBlocker}</span>
          )}
        </CardContent>
      </Card>

      {/* PID 스캔 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />PID 스캔
          </span>
          <span className="text-sm text-text-muted">
            {selected ? selected.packBarcode : '아래에서 박스를 고르세요'}
          </span>
          <div className="flex gap-1">
            <Button size="sm" variant={unpackMode ? 'secondary' : 'primary'}
              onClick={() => { setUnpackMode(false); pidRef.current?.focus(); }}>
              담기
            </Button>
            <Button size="sm" variant={unpackMode ? 'primary' : 'secondary'}
              onClick={() => { setUnpackMode(true); pidRef.current?.focus(); }}>
              <Undo2 className="mr-1 h-4 w-4" />빼기
            </Button>
          </div>
          {!unpackMode && (
            <Button size="sm" variant={repairMode ? 'primary' : 'secondary'}
              onClick={() => { setRepairMode(!repairMode); pidRef.current?.focus(); }}>
              수리품
            </Button>
          )}
          <Input ref={pidRef} aria-label="PID" placeholder="PID" value={pid}
            className="w-64" disabled={!canEdit || busy}
            onChange={(e) => setPid(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void scanPid(); }} />
          <Button size="sm" disabled={!canEdit || busy || !pid.trim()}
            onClick={scanPid}>
            {unpackMode ? '빼기' : '담기'}
          </Button>
          {lastResult && (
            <span className="text-sm font-medium text-emerald-500">{lastResult}</span>
          )}
          <span className="ml-auto flex gap-2">
            <Button size="sm" disabled={!canEdit || busy || serials.length === 0}
              onClick={() => setCompleteOpen(true)}>
              <PackageCheck className="mr-1 h-4 w-4" />포장완료
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected || busy}
              onClick={() => act('reprint')}>
              <Printer className="mr-1 h-4 w-4" />재출력
            </Button>
            <Button size="sm" variant="danger"
              disabled={!canEdit || busy || serials.length > 0}
              onClick={() => setDeleteOpen(true)}>
              <Trash2 className="mr-1 h-4 w-4" />빈 박스 삭제
            </Button>
          </span>
          {selected && !canEdit && (
            <span className="text-sm text-text-muted">
              이미 포장완료·입고된 박스입니다 — 담거나 뺄 수 없습니다.
            </span>
          )}
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="포장일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="박스 바코드" placeholder="박스 바코드"
            value={packBarcodeCond} className="w-52"
            onChange={(e) => setPackBarcodeCond(e.target.value)} />
          <ModelSearchField aria-label="모델 조건" placeholder="모델" value={modelNameCond}
            className="w-36"
            onChange={(v) => setModelNameCond(v)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            기간을 넓히면 느려집니다 (한 달 약 8.7초).
          </span>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-cols-[1.6fr_1fr]">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={packs}
              columns={packColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="제품포장"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['packBarcode'] }}
              emptyMessage={searched ? '이 기간에 포장한 박스가 없습니다.' : '조회하세요.'}
              onRowClick={(row) => void pick(row as PackRow)}
              rowClassName={(row) => ((row as PackRow).packBarcode === selected?.packBarcode
                ? 'bg-primary/10'
                : '')}
            />
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text">
              담긴 PID {serials.length.toLocaleString()}개
              {selected?.packingPcsQty
                ? ` / 정량 ${Number(selected.packingPcsQty).toLocaleString()}`
                : ''}
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={serials}
                columns={packSerialColumns}
                pageSize={100}
                enableExport
                exportFileName="제품포장_PID"
                emptyMessage={selected
                  ? '아직 담긴 PID 가 없습니다.'
                  : '왼쪽에서 박스를 고르세요.'}
                onRowClick={(row) => {
                  setPid((row as PackSerialRow).serialNo);
                  setUnpackMode(true);
                  pidRef.current?.focus();
                }}
              />
            </div>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={completeOpen}
        onClose={() => setCompleteOpen(false)}
        onConfirm={() => act('complete')}
        title="포장완료"
        message={`${selected?.packBarcode ?? ''} 를 포장완료합니다.`
          + ` 담긴 ${serials.length}개로 수량이 확정되고, 이후에는 담거나 뺄 수 없습니다.`}
        confirmText="완료"
      />

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={() => act('delete')}
        title="빈 박스 삭제"
        message={`${selected?.packBarcode ?? ''} 를 지웁니다.`
          + ' 담긴 PID 가 하나라도 있으면 지워지지 않습니다.'}
        confirmText="삭제"
      />
    </div>
  );
}
