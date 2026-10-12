"use client";

/**
 * @file src/app/(authenticated)/mold/inventory/page.tsx
 * @description S-PARTS 재고관리 — PB w_mcn_mold_inventory_master 이식
 *
 * 초보자 가이드:
 * 1. 재고 1행의 키는 **S-PARTS 코드 + 버전 + SET번호**다. 같은 코드에 여러 행이 있다.
 * 2. 하단 두 탭은 선택 행 기준이고 PB 가 못박아 둔 조건을 그대로 쓴다 —
 *    출고이력은 **최근 30일**, 청구는 **미처리 건만**.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { PackageSearch, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import MoldCodeField from '../components/MoldCodeField';
import { moldInventoryColumns, moldIssueColumns, moldRequestColumns } from '../columns';
import type { MoldInventoryRow, MoldIssueRow, MoldRequestRow } from '../types';

type DetailTab = 'issues' | 'requests';

export default function MoldInventoryPage() {
  const [rows, setRows] = useState<MoldInventoryRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [moldCode, setMoldCode] = useState('');
  const [moldUseStatus, setMoldUseStatus] = useState('');
  const [moldGroup, setMoldGroup] = useState('');

  const [selected, setSelected] = useState<MoldInventoryRow | null>(null);
  const [tab, setTab] = useState<DetailTab>('issues');
  const [issues, setIssues] = useState<MoldIssueRow[]>([]);
  const [requests, setRequests] = useState<MoldRequestRow[]>([]);
  const [detailLoading, setDetailLoading] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/mold/inventory', {
        params: {
          moldCode: moldCode || undefined,
          moldUseStatus: moldUseStatus || undefined,
          moldGroup: moldGroup || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
      setIssues([]);
      setRequests([]);
    } catch {
      toast.error('S-PARTS 재고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [moldCode, moldUseStatus, moldGroup]);

  useEffect(() => {
    if (!selected) return;
    let cancelled = false;
    setDetailLoading(true);
    const path = tab === 'issues' ? '/mold/inventory/issue-history' : '/mold/inventory/requests';
    api.get(path, { params: { moldCode: selected.moldCode } })
      .then((response) => {
        if (cancelled) return;
        const data = response.data?.data ?? [];
        if (tab === 'issues') setIssues(data);
        else setRequests(data);
      })
      .catch(() => { if (!cancelled) toast.error('상세 조회에 실패했습니다.'); })
      .finally(() => { if (!cancelled) setDetailLoading(false); });
    return () => { cancelled = true; };
  }, [selected, tab]);

  const columns = useMemo(() => moldInventoryColumns, []);
  const issueCols = useMemo(() => moldIssueColumns, []);
  const requestCols = useMemo(() => moldRequestColumns, []);

  const qtyTotal = useMemo(
    () => rows.reduce((sum, row) => sum + Number(row.inventoryQty ?? 0), 0),
    [rows],
  );

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <PackageSearch className="h-6 w-6 text-primary" />S-PARTS 재고관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            S-PARTS 의 버전·SET별 재고와 출고이력·청구를 확인합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <MoldCodeField popupId="mold-search" returnKey="moldCode"
            label="S-PARTS 코드" placeholder="S-PARTS 코드"
            value={moldCode} onChange={setMoldCode} />
          <ComCodeSelect groupCode="MOLD USE STATUS" labelPrefix="사용상태"
            value={moldUseStatus} onChange={setMoldUseStatus} className="w-52" />
          <ComCodeSelect groupCode="MOLD GROUP" labelPrefix="그룹"
            value={moldGroup} onChange={setMoldGroup} className="w-56" />
        </CardContent>
      </Card>

      {searched && (
        <div className="flex gap-4 text-sm text-text-muted">
          <span>재고수량 합계: <strong className="text-text">{qtyTotal.toLocaleString()}</strong></span>
          <span>조회 건수: <strong className="text-text">{total.toLocaleString()}</strong></span>
        </div>
      )}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="S-PARTS재고"
            emptyMessage="조회 버튼을 눌러 재고를 확인하세요."
            onRowClick={(row) => setSelected(row as MoldInventoryRow)}
            getRowId={(row) => {
              const inv = row as MoldInventoryRow;
              return `${inv.moldCode}|${inv.moldVersion ?? ''}|${inv.moldSetSerial ?? ''}`;
            }}
          />
        </CardContent>
      </Card>

      <Card padding="none" className="h-60 shrink-0 overflow-hidden">
        <CardContent className="flex h-full flex-col p-3">
          <nav className="mb-2 flex gap-1 border-b border-border" aria-label="상세 탭">
            {([['issues', '출고이력 (최근 30일)'], ['requests', '미처리 청구']] as const)
              .map(([key, label]) => (
                <button
                  key={key}
                  type="button"
                  onClick={() => setTab(key)}
                  className={`px-3 py-1.5 text-sm ${
                    tab === key
                      ? 'border-b-2 border-primary font-semibold text-text'
                      : 'text-text-muted'
                  }`}
                >
                  {label}
                </button>
              ))}
            <span className="ml-auto self-center text-xs text-text-muted">
              {selected ? selected.moldCode : '재고를 선택하세요'}
            </span>
          </nav>
          <div className="min-h-0 flex-1">
            {tab === 'issues' ? (
              <DataGrid
                data={issues}
                columns={issueCols}
                isLoading={detailLoading}
                pageSize={20}
                emptyMessage={selected ? '최근 30일 출고이력이 없습니다.' : '재고를 선택하세요.'}
                getRowId={(row) => {
                  const issue = row as MoldIssueRow;
                  return `${issue.issueDate}|${issue.issueSequence}`;
                }}
              />
            ) : (
              <DataGrid
                data={requests}
                columns={requestCols}
                isLoading={detailLoading}
                pageSize={20}
                emptyMessage={selected ? '미처리 청구가 없습니다.' : '재고를 선택하세요.'}
                getRowId={(row) => {
                  const req = row as MoldRequestRow;
                  return `${req.requestDate}|${req.requestSequence}`;
                }}
              />
            )}
          </div>
        </CardContent>
      </Card>
    </main>
  );
}
