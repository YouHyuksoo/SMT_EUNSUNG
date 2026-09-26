"use client";

/**
 * @file src/app/(authenticated)/smt/bom-comparison/page.tsx
 * @description 피더레이아웃 비교 — PB w_smt_bom_comparison_master_rpt 이식
 *
 * 초보자 가이드:
 * 1. **무엇을 비교하나**: 같은 라인에서 여러 모델의 "부품이 물리는 자리"를 나란히
 *    놓고 다른 자리를 쓰는 부품을 찾는다. 모델을 바꿔 생산할 때 피더를 옮겨야 하는
 *    부품이 그것이다.
 * 2. **모델은 `모델명 + PCB면` 으로 묶인다.** 같은 모델도 앞면·뒷면이 다른
 *    레이아웃이라 면까지 붙여야 한 덩어리가 된다. PB 도 같은 방식이었다.
 * 3. **PB 의 두 모드(그룹기준 / 위치기준)는 같은 데이터다.** DataWindow 두 개가
 *    묶는 기준만 달랐다. 여기서는 한 번 조회해 탭으로 보기만 바꾼다.
 *    탭을 바꿔도 다시 조회하지 않는다.
 * 4. **BOM 전개 탭**은 설계 BOM 을 펼쳐 각 부품이 실제로 어느 피더 자리에 있는지
 *    함께 보여준다. 전개는 PB 와 같은 DB 함수(PKG_DESIGN.BOM_QUERY)를 쓴다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtModelSelect, SmtPcbItemSelect } from '../components/SmtSelects';
import { smtBomExplodeColumns } from '../columns';
import type { SmtBomExplodeRow, SmtCompareRow } from '../types';

type Tab = 'group' | 'location' | 'explode';

const TABS: Array<{ key: Tab; label: string; hint: string }> = [
  { key: 'group', label: '그룹기준', hint: '부품별로 모델을 나란히 본다' },
  { key: 'location', label: '위치기준', hint: '자리가 다른 부품만 본다' },
  { key: 'explode', label: 'BOM 전개', hint: '설계 BOM 을 펼쳐 실제 피더 자리와 맞춰 본다' },
];

export default function SmtBomComparisonPage() {
  const [tab, setTab] = useState<Tab>('group');

  const [lineCode, setLineCode] = useState('');
  const [pcbItem, setPcbItem] = useState('');
  const [modelA, setModelA] = useState('');
  const [modelB, setModelB] = useState('');
  const [extraModels, setExtraModels] = useState('');

  const [models, setModels] = useState<string[]>([]);
  const [rows, setRows] = useState<SmtCompareRow[]>([]);
  const [diffCount, setDiffCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [explodeModel, setExplodeModel] = useState('');
  const [explodeRows, setExplodeRows] = useState<SmtBomExplodeRow[]>([]);
  const [explodeLoading, setExplodeLoading] = useState(false);
  const [explodeSearched, setExplodeSearched] = useState(false);

  const searchCompare = useCallback(async () => {
    const list = [modelA, modelB, ...extraModels.split(',')]
      .map((m) => m.trim())
      .filter(Boolean);
    if (lineCode.trim() === '') {
      toast.error('라인코드를 입력하세요.');
      return;
    }
    if (list.length < 2) {
      toast.error('비교할 모델을 2개 이상 고르세요.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/smt/comparison/locations', {
        params: {
          lineCode: lineCode.trim(),
          models: list.join(','),
          pcbItem: pcbItem || undefined,
        },
      });
      const data = response.data?.data;
      setModels(data?.models ?? list);
      setRows(data?.data ?? []);
      setDiffCount(Number(data?.diffCount ?? 0));
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '비교 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [lineCode, modelA, modelB, extraModels, pcbItem]);

  const searchExplode = useCallback(async () => {
    if (explodeModel.trim() === '' || lineCode.trim() === '') {
      toast.error('전개할 모델과 라인코드를 지정하세요.');
      return;
    }
    setExplodeLoading(true);
    try {
      const response = await api.get('/smt/comparison/bom-explode', {
        params: {
          setItemCode: explodeModel.trim(),
          lineCode: lineCode.trim(),
          pcbItem: pcbItem || undefined,
        },
      });
      setExplodeRows(response.data?.data ?? []);
      setExplodeSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'BOM 전개에 실패했습니다.');
    } finally {
      setExplodeLoading(false);
    }
  }, [explodeModel, lineCode, pcbItem]);

  /** 모델 수가 조회할 때 정해지므로 컬럼도 그때 만든다. */
  const compareColumns = useMemo<ColumnDef<SmtCompareRow>[]>(() => {
    const base: ColumnDef<SmtCompareRow>[] = [
      {
        id: 'diff',
        header: '판정',
        size: 110,
        accessorFn: (r) => (r.diff ? (r.missingIn.length > 0 ? '한쪽만' : '자리 다름') : '같음'),
      },
      { accessorKey: 'childItemCode', header: '부품코드', size: 160 },
      { accessorKey: 'itemName', header: '부품명', size: 190 },
      { accessorKey: 'itemSpec', header: '규격', size: 160 },
    ];
    return [
      ...base,
      ...models.map<ColumnDef<SmtCompareRow>>((model) => ({
        id: `model-${model}`,
        header: model,
        size: 180,
        // 그 모델에 그 부품이 없으면 빈칸이 아니라 '없음' 이라고 적는다 —
        // 자리 목록이 빈 것과 부품이 없는 것은 다른 뜻이다.
        accessorFn: (r) => r.byModel[model] ?? '없음',
      })),
    ];
  }, [models]);

  const visibleRows = useMemo(
    () => (tab === 'location' ? rows.filter((r) => r.diff) : rows),
    [tab, rows],
  );

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">피더레이아웃 비교</h1>
          <p className="mt-1 text-sm text-text-muted">
            {TABS.find((t) => t.key === tab)?.hint}
            {tab !== 'explode' && searched
              ? ` · 부품 ${rows.length}건 중 ${diffCount}건이 다릅니다`
              : ''}
            {tab === 'explode' && explodeSearched ? ` · ${explodeRows.length}건` : ''}
          </p>
        </div>
        <Button size="sm" onClick={tab === 'explode' ? searchExplode : searchCompare}
          disabled={tab === 'explode' ? explodeLoading : loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <div className="flex gap-1 border-b border-border">
        {TABS.map((t) => (
          <button
            key={t.key}
            type="button"
            onClick={() => setTab(t.key)}
            className={`px-4 py-2 text-sm ${
              tab === t.key
                ? 'border-b-2 border-primary font-semibold text-text'
                : 'text-text-muted'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
            className="w-36" onChange={(e) => setLineCode(e.target.value)} />
          <SmtPcbItemSelect labelPrefix="PCB면" value={pcbItem}
            onChange={setPcbItem} className="w-44" />
          {tab === 'explode' ? (
            <SmtModelSelect labelPrefix="전개 모델" value={explodeModel}
              onChange={setExplodeModel} className="w-72" />
          ) : (
            <>
              <SmtModelSelect labelPrefix="모델 1" value={modelA}
                onChange={setModelA} className="w-64" />
              <SmtModelSelect labelPrefix="모델 2" value={modelB}
                onChange={setModelB} className="w-64" />
              <Input aria-label="추가 모델" placeholder="추가 모델 (쉼표 구분, 최대 8개)"
                value={extraModels} className="w-72"
                onChange={(e) => setExtraModels(e.target.value)} />
            </>
          )}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'explode' ? (
            <DataGrid
              data={explodeRows}
              columns={smtBomExplodeColumns}
              isLoading={explodeLoading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SMT_BOM전개"
              emptyMessage="전개할 모델과 라인을 지정하고 조회하세요."
              getRowId={(row) => {
                const r = row as SmtBomExplodeRow;
                return `${r.parentItemCode}|${r.childItemCode}|${r.sortOrder}`;
              }}
            />
          ) : (
            <DataGrid
              data={visibleRows}
              columns={compareColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SMT_피더레이아웃비교"
              emptyMessage={
                searched
                  ? '차이가 없습니다.'
                  : '라인과 모델 2개 이상을 고르고 조회하세요.'
              }
              getRowId={(row) => String((row as SmtCompareRow).childItemCode)}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
