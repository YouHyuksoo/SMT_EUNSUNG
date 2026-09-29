"use client";

/**
 * @file src/app/(authenticated)/report/mold/page.tsx
 * @description S-PARTS관리리포트 — PB w_mcn_mold_rpt 이식
 *
 * 초보자 가이드:
 * 1. **두 갈래로 본다.** 마스터+재고 목록과 이력카드(재고+수리)다.
 * 2. **두 표 모두 현재 0행이다** (IMCN_MOLD · IMCN_MOLD_INVENTORY 실측 0건).
 *    화면은 동작하지만 볼 것이 없다 — 조건이 틀린 게 아니다.
 * 3. **재고가 없는 S-PARTS 도 목록에 남긴다** (외부조인 — PB 는 내부조인이었다).
 *    마스터에는 있는데 재고가 안 잡힌 품목을 찾는 것이 관리 리포트의 목적이다.
 *    그런 행은 버전 칸에 '재고 없음' 으로 보인다.
 * 4. **실적값이 한계값을 넘으면 빨강으로 보인다** — 교체 대상이다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import { moldCardColumns, moldReportColumns } from '../report-b-columns';
import type { MoldCardRow, MoldReportRow } from '../report-b-types';

type Tab = 'list' | 'card';

export default function MoldReportPage() {
  const [moldCode, setMoldCode] = useState('');
  const [moldGroup, setMoldGroup] = useState('');

  const [tab, setTab] = useState<Tab>('list');
  const [list, setList] = useState<MoldReportRow[]>([]);
  const [cards, setCards] = useState<MoldCardRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const params = {
        moldCode: moldCode || undefined,
        moldGroup: moldGroup || undefined,
      };
      const [l, c] = await Promise.all([
        api.get('/report/mold', { params }),
        api.get('/report/mold/card', { params }),
      ]);
      setList(l.data?.data ?? []);
      setCards(c.data?.data ?? []);
      mark(l, c);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? 'S-PARTS 관리 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [moldCode, moldGroup]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const noInventory = list.filter((r) => r.moldVersion == null).length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">S-PARTS관리리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          S-PARTS 마스터와 재고·수리이력을 봅니다 ·{' '}
          {searched
            ? `${list.length.toLocaleString()}건${noInventory > 0 ? ` · 재고 미등록 ${noInventory}건` : ''}`
            : '조회하세요'}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} what="재고 미등록 건수" />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="S-PARTS 코드" placeholder="S-PARTS 코드" value={moldCode}
            className="w-44"
            onChange={(e) => setMoldCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <ComCodeSelect groupCode="MOLD GROUP" labelPrefix="그룹" value={moldGroup}
            onChange={setMoldGroup} className="w-52" />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'list', label: '마스터 + 재고', count: list.length },
          { key: 'card', label: '이력카드', count: cards.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'list' ? (
            <DataGrid
              data={list}
              columns={moldReportColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS관리"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['moldCode'] }}
              emptyMessage={searched
                ? 'S-PARTS 가 없습니다 (이 표는 현재 비어 있습니다).'
                : '조회하세요.'}
              rowClassName={(row) => ((row as MoldReportRow).moldVersion == null
                ? 'bg-amber-500/5'
                : '')}
            />
          ) : (
            <DataGrid
              data={cards}
              columns={moldCardColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="S-PARTS이력카드"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['moldCode'] }}
              emptyMessage={searched
                ? 'S-PARTS 재고가 없습니다 (이 표는 현재 비어 있습니다).'
                : '조회하세요.'}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
