"use client";

/**
 * @file src/app/(authenticated)/mold/repair/page.tsx
 * @description S-PARTS 수리관리 — PB w_mcn_mold_repair_master 이식
 *
 * 초보자 가이드:
 * 1. **접수는 수리신청관리 화면에서 한다.** 여기는 접수된 건의 처리 내용을 채우고
 *    확정하는 화면이다. 상태 흐름은 신청 → 수리중 → 수리완료.
 * 2. **기간 조건은 신청일 기준이다** — 수리일이 아니다. PB 조건 그대로다.
 * 3. 하단은 선택 수리건의 수리품목이다. 기본키 제약 때문에 수리 1건당 1행이다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search, Wrench } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import MoldCodeField from '../components/MoldCodeField';
import { moldRepairColumns, moldRepairItemColumns } from '../columns';
import type { MoldRepairItemRow, MoldRepairRow } from '../types';
import RepairProcessPanel from './components/RepairProcessPanel';

const isoDate = (date: Date) => date.toISOString().slice(0, 10);
const today = () => isoDate(new Date());
const monthsAgo = (months: number) => {
  const date = new Date();
  date.setMonth(date.getMonth() - months);
  return isoDate(date);
};

export default function MoldRepairPage() {
  const [rows, setRows] = useState<MoldRepairRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [dateFrom, setDateFrom] = useState(() => monthsAgo(3));
  const [dateTo, setDateTo] = useState(today);
  const [moldCode, setMoldCode] = useState('');
  const [moldGroup, setMoldGroup] = useState('');
  const [repairStatus, setRepairStatus] = useState('');
  const [lineCode, setLineCode] = useState('');

  const [selected, setSelected] = useState<MoldRepairRow | null>(null);
  const [items, setItems] = useState<MoldRepairItemRow[]>([]);
  const [itemsLoading, setItemsLoading] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/mold/repair', {
        params: {
          dateFrom,
          dateTo,
          moldCode: moldCode || undefined,
          moldGroup: moldGroup || undefined,
          repairStatus: repairStatus || undefined,
          lineCode: lineCode || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
      setItems([]);
    } catch {
      toast.error('S-PARTS 수리 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, moldCode, moldGroup, repairStatus, lineCode]);

  useEffect(() => {
    if (!selected) return;
    let cancelled = false;
    setItemsLoading(true);
    api.get('/mold/repair/items', {
      params: { moldCode: selected.moldCode, repairSequence: selected.repairSequence },
    })
      .then((response) => { if (!cancelled) setItems(response.data?.data ?? []); })
      .catch(() => { if (!cancelled) toast.error('수리품목 조회에 실패했습니다.'); })
      .finally(() => { if (!cancelled) setItemsLoading(false); });
    return () => { cancelled = true; };
  }, [selected]);

  const columns = useMemo(() => moldRepairColumns, []);
  const itemCols = useMemo(() => moldRepairItemColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <Wrench className="h-6 w-6 text-primary" />S-PARTS 수리관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            접수된 S-PARTS 수리의 처리 내용을 채우고 완료로 확정합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="신청일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <MoldCodeField popupId="mold-search" returnKey="moldCode"
            label="S-PARTS 코드" placeholder="S-PARTS 코드" className="w-44"
            value={moldCode} onChange={setMoldCode} />
          <ComCodeSelect groupCode="MOLD GROUP" labelPrefix="그룹"
            value={moldGroup} onChange={setMoldGroup} className="w-52" />
          <ComCodeSelect groupCode="REPAIR STATUS" labelPrefix="수리상태"
            value={repairStatus} onChange={setRepairStatus} className="w-52" />
          <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-40" />
        </CardContent>
      </Card>

      <RepairProcessPanel selected={selected} onChanged={search} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="S-PARTS수리"
            emptyMessage="조회 버튼을 눌러 수리건을 확인하세요."
            onRowClick={(row) => setSelected(row as MoldRepairRow)}
            getRowId={(row) => {
              const repair = row as MoldRepairRow;
              return `${repair.moldCode}|${repair.repairSequence}`;
            }}
          />
        </CardContent>
      </Card>

      <Card padding="none" className="h-48 shrink-0 overflow-hidden">
        <CardContent className="flex h-full flex-col p-3">
          <b className="mb-2 text-sm text-text">
            수리품목{selected ? ` — ${selected.moldCode} / 수리항번 ${selected.repairSequence}` : ''}
          </b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={items}
              columns={itemCols}
              isLoading={itemsLoading}
              pageSize={20}
              emptyMessage={selected ? '수리품목이 없습니다.' : '수리건을 선택하세요.'}
              getRowId={(row) => (row as MoldRepairItemRow).repairItemCode}
            />
          </div>
        </CardContent>
      </Card>
    </main>
  );
}
