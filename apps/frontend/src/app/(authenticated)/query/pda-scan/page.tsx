"use client";

/**
 * @file src/app/(authenticated)/query/pda-scan/page.tsx
 * @description SMT 오장착 스캔 현황 조회 — PB w_pln_product_pda_scan_query 이식
 *
 * 초보자 가이드:
 * 1. **PDA 가 찍은 자재 스캔 이력을 본다.** 오장착(잘못된 자재를 물린 것)을 찾는
 *    화면이다. 상태가 'E'(오류) 인 행이 빨갛게 보인다.
 * 2. **네 갈래로 본다** (PB 탭 4개):
 *      상세    스캔 한 건씩
 *      그룹    풀체크 회차별로 묶어 시작·종료 시각까지
 *      바코드  바코드 하나로 자사·공급처·이전 바코드를 한꺼번에
 *      출고    그 자재의 출고 이력
 * 3. **NG 사유·메모를 적을 수 있다** (쓰기). 행을 고르고 아래 칸에 적어 저장한다.
 *    **그 두 컬럼만 바꾼다** — DataWindow 의 update=yes 를 실측해 맞췄다.
 *    IB_SMT_CHECKHIST 에는 수정자 컬럼이 없어 메모 끝에 작성자를 붙인다.
 * 4. **기간이 필수다.** 이 표는 (CHECK_DATE, ...) 인덱스가 있어 구간이 닫혀 있어야
 *    인덱스를 탄다. PB 는 빈 조건을 `'%'` 로 보내 전체를 훑을 수 있었다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Save, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { QueryTabs } from '../components/QueryTabs';
import {
  barcodeMatchColumns,
  issueHistoryColumns,
  scanDetailColumns,
  scanGroupColumns,
} from '../query-columns';
import type {
  BarcodeMatchRow,
  IssueHistoryRow,
  ScanDetailRow,
  ScanGroupRow,
} from '../query-types';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'detail' | 'group' | 'barcode' | 'issue';

export default function PdaScanQueryPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(3));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [lineCode, setLineCode] = useState('');
  const [itemCode, setItemCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [checkStatus, setCheckStatus] = useState('');
  const [checkType, setCheckType] = useState('');
  const [scanBarcode, setScanBarcode] = useState('');

  const [tab, setTab] = useState<Tab>('detail');
  const [detail, setDetail] = useState<ScanDetailRow[]>([]);
  const [group, setGroup] = useState<ScanGroupRow[]>([]);
  const [matches, setMatches] = useState<BarcodeMatchRow[]>([]);
  const [issues, setIssues] = useState<IssueHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [selected, setSelected] = useState<ScanDetailRow | null>(null);
  const [ngReason, setNgReason] = useState('');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    setSelected(null);
    try {
      const params = {
        dateFrom,
        dateTo,
        lineCode: lineCode || undefined,
        itemCode: itemCode || undefined,
        modelName: modelName || undefined,
        locationCode: locationCode || undefined,
        checkStatus: checkStatus || undefined,
        checkType: checkType || undefined,
        scanBarcode: scanBarcode || undefined,
      };
      const [d, g] = await Promise.all([
        api.get('/query/pda-scan/detail', { params }),
        api.get('/query/pda-scan/group', { params }),
      ]);
      setDetail(d.data?.data ?? []);
      setGroup(g.data?.data ?? []);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '스캔 이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, lineCode, itemCode, modelName, locationCode,
      checkStatus, checkType, scanBarcode]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 바코드·출고 탭은 바코드 하나로 따로 찾는다 (기간과 무관하다). */
  const searchByBarcode = useCallback(async () => {
    if (!scanBarcode) {
      toast.error('바코드를 입력하세요.');
      return;
    }
    setLoading(true);
    try {
      const params = { barcode: scanBarcode };
      const [m, i] = await Promise.all([
        api.get('/query/pda-scan/by-barcode', { params }),
        api.get('/query/pda-scan/issue-history', { params }),
      ]);
      setMatches(m.data?.data ?? []);
      setIssues(i.data?.data ?? []);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [scanBarcode]);

  const pick = useCallback((row: ScanDetailRow) => {
    setSelected(row);
    setNgReason(row.ngReason ?? '');
    setComments(row.comments ?? '');
  }, []);

  const save = useCallback(async () => {
    if (!selected?.checkDateKey) return;
    setBusy(true);
    try {
      const response = await api.put('/query/pda-scan/notes', {
        rows: [{
          lineCode: selected.lineCode,
          lotName: selected.lotName,
          checkSequence: selected.checkSequence,
          checkDateKey: selected.checkDateKey,
          ngReason: ngReason || undefined,
          comments: comments || undefined,
        }],
      });
      const data = response.data?.data;
      if (Number(data?.changed ?? 0) > 0) {
        toast.success(`${data.changed}건 저장했습니다.`);
      } else {
        toast.error('그 행을 찾을 수 없었습니다 (키가 바뀌었을 수 있습니다).');
      }
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '저장에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [selected, ngReason, comments, search]);

  const rowKey = (r: ScanDetailRow) =>
    [r.lineCode, r.lotName, r.checkSequence, r.checkDateKey].join('|');
  const ngCount = detail.filter((r) => r.checkStatus === 'E').length;

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">SMT 오장착 스캔 현황 조회</h1>
        <p className="mt-1 text-sm text-text-muted">
          PDA 자재 스캔 이력에서 오장착을 찾고 NG 사유를 적습니다 ·{' '}
          {searched ? `상세 ${detail.length}건` : '조회하세요'}
          {ngCount > 0 && <span className="ml-1 text-red-500">· 오류 {ngCount}건</span>}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="스캔일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <div className="w-40">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <div className="w-44">
            <ComCodeSelect groupCode="CHECK TYPE" value={checkType}
              onChange={setCheckType} labelPrefix="구분" />
          </div>
          <div className="w-44">
            <ComCodeSelect groupCode="CHECK STATUS" value={checkStatus}
              onChange={setCheckStatus} labelPrefix="상태" />
          </div>
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-36"
            onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="설비 롯트명" placeholder="설비 롯트명" value={modelName}
            className="w-40" onChange={(e) => setModelName(e.target.value)} />
          <Input aria-label="피더위치" placeholder="피더위치" value={locationCode}
            className="w-28" onChange={(e) => setLocationCode(e.target.value)} />
          <Input aria-label="바코드" placeholder="바코드" value={scanBarcode} className="w-44"
            onChange={(e) => setScanBarcode(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" variant="secondary" onClick={searchByBarcode} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />바코드로 찾기
          </Button>
        </CardContent>
      </Card>

      <QueryTabs
        tabs={[
          { key: 'detail', label: '상세', count: detail.length },
          { key: 'group', label: '풀체크 회차', count: group.length },
          { key: 'barcode', label: '바코드', count: matches.length },
          { key: 'issue', label: '출고 이력', count: issues.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'detail' && (
            <DataGrid
              data={detail}
              columns={scanDetailColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="오장착스캔상세"
              emptyMessage={searched ? '이 조건에 스캔 기록이 없습니다.' : '조회하세요.'}
              onRowClick={(row) => pick(row as ScanDetailRow)}
              rowClassName={(row) => {
                const r = row as ScanDetailRow;
                if (selected && rowKey(r) === rowKey(selected)) return 'bg-primary/10';
                return r.checkStatus === 'E' ? 'bg-red-500/5' : '';
              }}
              getRowId={(row) => rowKey(row as ScanDetailRow)}
            />
          )}
          {tab === 'group' && (
            <DataGrid data={group} columns={scanGroupColumns} isLoading={loading}
              pageSize={100} enableColumnFilter enableExport exportFileName="풀체크회차"
              emptyMessage={searched ? '이 조건에 스캔 기록이 없습니다.' : '조회하세요.'} />
          )}
          {tab === 'barcode' && (
            <DataGrid data={matches} columns={barcodeMatchColumns} isLoading={loading}
              pageSize={100} enableColumnFilter
              emptyMessage="바코드를 넣고 '바코드로 찾기' 를 누르세요." />
          )}
          {tab === 'issue' && (
            <DataGrid data={issues} columns={issueHistoryColumns} isLoading={loading}
              pageSize={100} enableColumnFilter
              emptyMessage="바코드를 넣고 '바코드로 찾기' 를 누르세요." />
          )}
        </CardContent>
      </Card>

      {tab === 'detail' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <b className="text-sm text-text">NG 사유·메모</b>
            {selected ? (
              <span className="text-sm text-text-muted">
                {selected.checkDate} · {selected.lineName ?? selected.lineCode} ·{' '}
                {selected.locationCode} · {selected.partName}
              </span>
            ) : (
              <span className="text-sm text-text-muted">위에서 행을 고르세요.</span>
            )}
            <Input aria-label="NG 사유" placeholder="NG 사유" value={ngReason} className="w-56"
              disabled={!selected} onChange={(e) => setNgReason(e.target.value)} />
            <Input aria-label="메모" placeholder="메모" value={comments} className="w-72"
              disabled={!selected} onChange={(e) => setComments(e.target.value)} />
            <Button size="sm" onClick={save} disabled={!selected || busy}>
              <Save className="mr-1 h-4 w-4" />저장
            </Button>
            <span className="text-sm text-text-muted">
              이 두 컬럼만 바뀝니다 · 메모 끝에 작성자가 붙습니다
            </span>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
