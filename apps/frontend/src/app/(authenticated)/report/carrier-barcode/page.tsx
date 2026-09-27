"use client";

/**
 * @file src/app/(authenticated)/report/carrier-barcode/page.tsx
 * @description 캐리어바코드 — PB w_product_carrier_barcode 이식
 *
 * 초보자 가이드:
 * 1. **리포트 메뉴에 있지만 리포트가 아니다.** 캐리어(제품 운반 트레이) 바코드를
 *    **새로 발행하는 쓰기 화면**이다. 라벨 레이아웃만 보고 '인쇄물' 로 넘기면
 *    쓰기 화면이 조용히 빠진다.
 * 2. **형식은 `접두어 + 3자리 0채움 순번 + 접미어` 다.** 아래에 실제로 만들어질
 *    첫 번호와 끝 번호를 미리 보여준다 — 발행하고 나서 알면 늦다.
 * 3. **PB 는 1000번부터 깨졌다.** `TO_CHAR(1000,'000')` 이 '###' 을 돌려줘
 *    바코드가 '###' 으로 찍혔다. 지금은 3자리를 넘으면 자리수가 늘어난다
 *    (1~999 는 PB 와 완전히 같다).
 * 4. **이미 있는 바코드는 건너뛴다.** PB 는 그대로 넣다가 PK 충돌이 나면 루프
 *    중간에 멈췄다 (앞부분만 들어간 상태로). 새로 넣은 수와 이미 있던 수를
 *    나눠 알려준다.
 * 5. **발행 취소는 앞부분 일치로 지운다.** 되돌릴 수 없으므로 지울 건수를 먼저
 *    세어 확인 모달에 보여준다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Plus, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, CardHeader, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { carrierBarcodeColumns } from '../report-columns';
import type { CarrierBarcodeCreateResult, CarrierBarcodeRow } from '../report-types';

/** 백엔드와 같은 상한. 여기서 먼저 막아 왕복을 줄인다 (판정은 백엔드가 다시 한다). */
const MAX_CREATE = 5000;

const serialOf = (prefix: string, serial: string, suffix: string) => {
  const n = Number(serial);
  if (!prefix || !serial || Number.isNaN(n) || n < 1) return '';
  return `${prefix}${String(n).padStart(3, '0')}${suffix}`;
};

export default function CarrierBarcodeReportPage() {
  const [barcode, setBarcode] = useState('');
  const [rows, setRows] = useState<CarrierBarcodeRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [prefix, setPrefix] = useState('');
  const [suffix, setSuffix] = useState('');
  const [startSerial, setStartSerial] = useState('1');
  const [endSerial, setEndSerial] = useState('100');
  const [busy, setBusy] = useState(false);

  const [deleteOpen, setDeleteOpen] = useState(false);
  const [deleteTarget, setDeleteTarget] = useState('');
  const [deleteCount, setDeleteCount] = useState(0);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/report/carrier-barcode', {
        params: { barcode: barcode || undefined },
      });
      setRows(response.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '캐리어바코드 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [barcode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const first = serialOf(prefix, startSerial, suffix);
  const last = serialOf(prefix, endSerial, suffix);
  const count = Number(endSerial) - Number(startSerial) + 1;
  const rangeOk = Boolean(first && last) && count >= 1 && count <= MAX_CREATE;

  const create = useCallback(async () => {
    setBusy(true);
    try {
      const response = await api.post('/report/carrier-barcode', {
        prefix,
        suffix: suffix || undefined,
        startSerial: Number(startSerial),
        endSerial: Number(endSerial),
      });
      const result = response.data?.data as CarrierBarcodeCreateResult | undefined;
      const created = Number(result?.created ?? 0);
      const existed = Number(result?.alreadyExisted ?? 0);
      if (created === 0) {
        toast.success(`새로 발행한 것이 없습니다 (요청 ${count}장 모두 이미 있음).`);
      } else {
        toast.success(
          `${created.toLocaleString()}장을 발행했습니다`
          + `${existed > 0 ? ` · 이미 있던 ${existed.toLocaleString()}장은 건너뜀` : ''}.`,
        );
      }
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '캐리어바코드 발행에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [prefix, suffix, startSerial, endSerial, count, search]);

  /** 지울 건수를 먼저 센다. 되돌릴 수 없는 작업에 '몇 건인지 모르고 누르기' 를 없앤다. */
  const askDelete = useCallback(async () => {
    const target = barcode.trim();
    if (!target) {
      toast.error('지울 바코드의 앞부분을 입력하세요 (전체 삭제는 막아 둡니다).');
      return;
    }
    setBusy(true);
    try {
      const response = await api.get('/report/carrier-barcode/count', {
        params: { barcode: target },
      });
      const rowCount = Number(response.data?.data?.rows ?? 0);
      if (rowCount === 0) {
        toast.success(`'${target}' 로 시작하는 바코드가 없습니다.`);
        return;
      }
      setDeleteTarget(target);
      setDeleteCount(rowCount);
      setDeleteOpen(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '삭제 대상 건수 조회에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode]);

  const remove = useCallback(async () => {
    setDeleteOpen(false);
    setBusy(true);
    try {
      const response = await api.delete('/report/carrier-barcode', {
        data: { barcode: deleteTarget },
      });
      const deleted = Number(response.data?.data?.deleted ?? 0);
      toast.success(`${deleted.toLocaleString()}건을 지웠습니다.`);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '발행 취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [deleteTarget, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">캐리어바코드</h1>
        <p className="mt-1 text-sm text-text-muted">
          캐리어 바코드를 범위로 발행하고 목록을 확인합니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="바코드" placeholder="바코드 앞부분" value={barcode} className="w-56"
            onChange={(e) => setBarcode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" variant="danger" onClick={askDelete} disabled={busy || !barcode.trim()}>
            <Trash2 className="mr-1 h-4 w-4" />발행 취소
          </Button>
        </CardContent>
      </Card>

      <div className="flex min-h-0 flex-1 gap-4">
        <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={rows}
              columns={carrierBarcodeColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="캐리어바코드"
              emptyMessage={searched
                ? '발행된 캐리어 바코드가 없습니다.'
                : '조회하세요.'}
              getRowId={(row) => (row as CarrierBarcodeRow).serialNo}
            />
          </CardContent>
        </Card>

        <Card className="w-80 shrink-0 overflow-y-auto">
          <CardHeader title="바코드 발행" />
          <CardContent className="flex flex-col gap-3">
            <Input label="접두어" value={prefix} placeholder="예: CB2609"
              onChange={(e) => setPrefix(e.target.value)} />
            <Input label="접미어 (없으면 비움)" value={suffix}
              onChange={(e) => setSuffix(e.target.value)} />
            <div className="flex gap-2">
              <Input label="시작 순번" value={startSerial} className="w-full"
                onChange={(e) => setStartSerial(e.target.value.replace(/\D/g, ''))} />
              <Input label="끝 순번" value={endSerial} className="w-full"
                onChange={(e) => setEndSerial(e.target.value.replace(/\D/g, ''))} />
            </div>

            {/* 만들어질 값을 미리 보여준다. 발행하고 나서 형식을 알면 지우고 다시 해야 한다. */}
            <div className="rounded-lg border border-border p-2 text-sm">
              {rangeOk ? (
                <>
                  <div className="text-text">
                    {count.toLocaleString()}장 · <span className="font-mono">{first}</span>
                    {' ~ '}<span className="font-mono">{last}</span>
                  </div>
                  <div className="mt-1 text-xs text-text-muted">
                    이미 있는 바코드는 건너뜁니다.
                  </div>
                </>
              ) : (
                <span className="text-amber-500">
                  {!prefix
                    ? '접두어를 넣으세요.'
                    : count > MAX_CREATE
                      ? `한 번에 ${MAX_CREATE.toLocaleString()}장까지 발행할 수 있습니다.`
                      : '순번 범위를 확인하세요 (끝 순번이 시작 순번보다 커야 합니다).'}
                </span>
              )}
            </div>

            <Button onClick={create} disabled={!rangeOk || busy}>
              <Plus className="mr-1 h-4 w-4" />발행
            </Button>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="캐리어바코드 발행 취소"
        message={`'${deleteTarget}' 로 시작하는 바코드 ${deleteCount.toLocaleString()}건을 지웁니다.`
          + ' 되돌릴 수 없습니다.'}
        variant="danger"
      />
    </div>
  );
}
