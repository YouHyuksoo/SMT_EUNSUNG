"use client";

/**
 * @file src/app/(authenticated)/design/apply-item/page.tsx
 * @description 149 적용모델관리 — PB w_des_apply_item_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **"이 자재가 어느 제품에 들어가나"를 거슬러 올라가는 화면이다.** 자재코드를
 *    넣으면 그 자재를 쓰는 상위 품목을 BOM 을 타고 끝까지 찾아 올라간다.
 * 2. **설계변경·단종 검토에 쓴다.** 자재 하나를 바꾸면 무엇이 영향을 받는지 본다.
 * 3. **오늘 유효한 BOM 만 본다.** 끝난 BOM 까지 올라가면 이미 단종된 제품이 섞인다.
 * 4. **자재코드는 필수다.** 비우면 BOM 전체를 모든 방향으로 전개하게 된다.
 * 5. 위에서 품목을 고르면 아래에 그 품목의 제품모델 기준정보가 나온다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { GitBranch, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { applyItemColumns, applyModelColumns } from '../design-columns';
import type { ApplyItemRow, ApplyModelRow } from '../design-columns';

export default function ApplyItemPage() {
  const [itemCode, setItemCode] = useState('');
  const [rows, setRows] = useState<ApplyItemRow[]>([]);
  const [models, setModels] = useState<ApplyModelRow[]>([]);
  const [selected, setSelected] = useState<ApplyItemRow | null>(null);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    if (!itemCode.trim()) {
      toast.error('자재(품목)코드를 넣으세요.');
      return;
    }
    setLoading(true);
    try {
      const r = await api.get('/design/apply-item', {
        params: { itemCode: itemCode.trim() },
      });
      setRows(r.data?.data ?? []);
      setSelected(null);
      setModels([]);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [itemCode, mark]);

  const pick = useCallback(async (row: ApplyItemRow) => {
    setSelected(row);
    try {
      const r = await api.get('/design/apply-item/models', {
        params: { itemCode: row.itemCode },
      });
      setModels(r.data?.data ?? []);
    } catch {
      setModels([]);
    }
  }, []);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">적용모델관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          이 자재를 쓰는 상위 품목을 BOM 을 거슬러 올라가 찾습니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '자재코드를 넣으세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <GitBranch className="h-4 w-4" />자재코드
          </span>
          <Input aria-label="자재코드" placeholder="자재(품목)코드" value={itemCode}
            className="w-64" autoFocus
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <span className="text-sm text-text-muted">
            오늘 유효한 BOM 만 거슬러 올라갑니다.
          </span>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-rows-[1.4fr_1fr]">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={rows}
              columns={applyItemColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="적용모델_상위품목"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['itemCode'] }}
              emptyMessage={searched
                ? '이 자재를 쓰는 상위 품목이 없습니다.'
                : '자재코드를 넣고 조회하세요.'}
              onRowClick={(row) => void pick(row as ApplyItemRow)}
              rowClassName={(row) => ((row as ApplyItemRow).itemCode === selected?.itemCode
                ? 'bg-primary/10'
                : '')}
            />
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <span className="text-sm font-semibold text-text">
              제품모델 {models.length.toLocaleString()}건
              {selected ? ` · ${selected.itemCode}` : ''}
            </span>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={models}
                columns={applyModelColumns}
                pageSize={50}
                enableExport
                exportFileName="적용모델_모델정보"
                emptyMessage={selected
                  ? '이 품목으로 등록된 제품모델이 없습니다.'
                  : '위에서 품목을 고르세요.'}
              />
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
