"use client";

/**
 * @file src/app/(authenticated)/confirm/components/PriceConfirmScreen.tsx
 * @description 단가승인 공용 화면 — 구매·판매·S-PARTS
 *              PB w_mat_buy_price_confirm / w_sal_sale_price_confirm
 *                 w_mcn_mold_buy_price_confirm
 *
 * 초보자 가이드:
 * 1. **승인은 여러 건을 한꺼번에 한다.** PB 도 체크박스로 고른 행을 일괄 처리했다.
 *    그리드에서 행을 고르고 '승인' 또는 '승인취소' 를 누른다.
 * 2. **이전단가와 변화율이 핵심이다.** 얼마였는데 얼마가 되는지 보고 승인한다.
 *    이전단가는 테이블에 컬럼이 없어 서버가 DB 함수로 가져온다.
 * 3. **라인유형은 구매·판매에서 키의 일부다.** 그리드에 '(키)' 로 표시한다 —
 *    같은 품목·거래처라도 라인유형이 다르면 다른 단가다.
 * 4. **결과를 세 갈래로 보여준다.** 바뀐 건수 / 이미 그 상태였던 건수 /
 *    없는 단가. 하나로 뭉치면 화면이 거짓말을 한다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { CheckCircle2, Search, XCircle } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import Select from '@/components/ui/Select';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import PartSearchField from '@/components/shared/PartSearchField';
import api from '@/services/api';
import { priceConfirmColumns } from '../confirm-columns';
import type { PriceConfirmRow } from '../confirm-types';

export interface PriceConfirmScreenConfig {
  title: string;
  subtitle: string;
  /** API 경로 — /confirm/buy-price 등 */
  path: string;
  variant: 'buy' | 'sale' | 'mold';
  /** 거래처 라벨 — 공급처 / 고객 */
  partnerLabel: string;
  /** 표가 비었을 때 덧붙일 설명 (S-PARTS 는 0행이라 이유를 적는다) */
  emptyNote?: string;
}

const CONFIRM_OPTIONS = [
  { value: '', label: '승인상태: 전체' },
  { value: 'N', label: '승인상태: 미승인' },
  { value: 'Y', label: '승인상태: 승인됨' },
];

/** 행을 잇는 문자열 키. 라인유형이 키인 테이블은 그것까지 넣는다. */
const keyOf = (row: PriceConfirmRow) =>
  [row.itemCode, row.partnerCode, String(row.dateSet).slice(0, 10), row.lineType ?? ''].join('|');

/** 행 하나를 API 키로 줄인다. */
const toKey = (row: PriceConfirmRow) => ({
  itemCode: row.itemCode,
  partnerCode: row.partnerCode,
  dateSet: String(row.dateSet).slice(0, 10),
  lineType: row.lineType ?? undefined,
});

export default function PriceConfirmScreen({ config }: { config: PriceConfirmScreenConfig }) {
  const [rows, setRows] = useState<PriceConfirmRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [itemCode, setItemCode] = useState('');
  // 금형(S-PARTS) 모드는 품목마스터 조회 대상이 아니므로 일반 입력칸을 쓴다
  const CodeField = config.variant === 'mold' ? Input : PartSearchField;
  const [partnerCode, setPartnerCode] = useState('');
  const [confirmStatus, setConfirmStatus] = useState('N');
  const [dateFrom, setDateFrom] = useState('');
  const [dateTo, setDateTo] = useState('');

  // DataGrid 에 다중선택이 없다. 저장소 관례대로 행 클릭으로 토글하고
  // rowClassName 으로 표시한다 (품질 재고통제관리와 같은 방식).
  const [picked, setPicked] = useState<Map<string, PriceConfirmRow>>(new Map());
  const [applyOpen, setApplyOpen] = useState<'Y' | 'N' | null>(null);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get(config.path, {
        params: {
          itemCode: itemCode || undefined,
          partnerCode: partnerCode || undefined,
          confirmStatus: confirmStatus || undefined,
          dateFrom: dateFrom || undefined,
          dateTo: dateTo || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setPicked(new Map());
    } catch {
      toast.error(`${config.title} 조회에 실패했습니다.`);
    } finally {
      setLoading(false);
    }
  }, [config.path, config.title, itemCode, partnerCode, confirmStatus, dateFrom, dateTo]);

  const toggle = useCallback((row: PriceConfirmRow) => {
    const key = keyOf(row);
    setPicked((prev) => {
      const next = new Map(prev);
      if (next.has(key)) next.delete(key);
      else next.set(key, row);
      return next;
    });
  }, []);

  const apply = useCallback(async (confirmYn: 'Y' | 'N') => {
    setApplyOpen(null);
    if (picked.size === 0) return;
    setBusy(true);
    try {
      const response = await api.put(config.path, {
        keys: [...picked.values()].map(toKey),
        confirmYn,
      });
      const data = response.data?.data;
      const parts = [`${data?.changed ?? 0}건 ${confirmYn === 'Y' ? '승인' : '승인취소'}`];
      if (Number(data?.alreadySet ?? 0) > 0) {
        parts.push(`이미 그 상태 ${data.alreadySet}건`);
      }
      if (Number(data?.missing ?? 0) > 0) parts.push(`없는 단가 ${data.missing}건`);
      toast.success(parts.join(' · '));
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [picked, config.path, search]);

  const columns = useMemo(
    () => priceConfirmColumns(config.variant, config.partnerLabel),
    [config.variant, config.partnerLabel],
  );

  const emptyMessage = searched
    ? `조건에 맞는 단가가 없습니다.${config.emptyNote ? ` ${config.emptyNote}` : ''}`
    : '조회 버튼을 눌러 승인 대상을 확인하세요.';

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">{config.title}</h1>
          <p className="mt-1 text-sm text-text-muted">
            {config.subtitle} ·{' '}
            {searched ? `${rows.length}/${total}건` : '조회하세요'}
            {picked.size > 0 ? ` · ${picked.size}건 선택` : ' · 행을 클릭해 고르세요'}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" disabled={picked.size === 0 || busy}
            onClick={() => setApplyOpen('Y')}>
            <CheckCircle2 className="mr-1 h-4 w-4" />승인
          </Button>
          <Button size="sm" variant="secondary" disabled={picked.size === 0 || busy}
            onClick={() => setApplyOpen('N')}>
            <XCircle className="mr-1 h-4 w-4" />승인취소
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <CodeField
            aria-label={config.variant === 'mold' ? 'S-PARTS 코드' : '품목코드'}
            placeholder={config.variant === 'mold' ? 'S-PARTS 코드' : '품목코드'}
            value={itemCode} className="w-44"
            onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label={config.partnerLabel} placeholder={config.partnerLabel}
            value={partnerCode} className="w-40"
            onChange={(e) => setPartnerCode(e.target.value)} />
          <div className="w-44">
            <Select options={CONFIRM_OPTIONS} value={confirmStatus}
              onChange={setConfirmStatus} />
          </div>
          <DateRangeFilter label="적용시작" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName={config.title}
            emptyMessage={emptyMessage}
            onRowClick={(row) => toggle(row as PriceConfirmRow)}
            rowClassName={(row) =>
              picked.has(keyOf(row as PriceConfirmRow)) ? 'bg-primary/10' : ''}
            getRowId={(row) => keyOf(row as PriceConfirmRow)}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={applyOpen !== null}
        onClose={() => setApplyOpen(null)}
        onConfirm={() => applyOpen && apply(applyOpen)}
        title={applyOpen === 'Y' ? '단가 승인' : '단가 승인취소'}
        message={`선택한 ${picked.size}건을`
          + ` ${applyOpen === 'Y' ? '승인' : '승인취소'}합니까?`
          + (applyOpen === 'Y'
            ? ' 승인하면 승인자와 승인일시가 기록됩니다.'
            : ' 승인취소하면 승인자와 승인일시가 지워집니다.')}
      />
    </div>
  );
}
