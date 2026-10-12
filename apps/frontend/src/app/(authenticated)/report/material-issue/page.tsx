"use client";

/**
 * @file src/app/(authenticated)/report/material-issue/page.tsx
 * @description 자재출고리포트 — PB w_mat_issue_report 이식
 *
 * 초보자 가이드:
 * 1. **기간은 출고일이 아니라 등록일이다** (PB 그대로). 뒤늦게 입력한 출고는
 *    등록한 날에 잡힌다.
 * 2. **풀체크 시각은 행을 고르면 따로 조회한다.** PB 는 목록의 한 열로 뽑았지만
 *    그 형태로는 1만행에 367초가 걸린다 (LIKE 접두어가 컬럼 연결식이라 인덱스를
 *    못 쓴다 — 실측). 한 건은 즉시 나오고 값은 PB 와 같다.
 *    **비어 있으면 출고만 되고 라인에 안 올라갔다는 뜻이다.**
 * 3. **간이 탭은 단가 하한을 건다** (PB 간이 DataWindow). 단가는 DB 함수가 계산한다.
 * 4. **미출고·풀체크이력은 별개 자료다.** 미출고가 읽는 표는 현재 0행이고,
 *    풀체크이력은 기간이 없어 바코드가 필수다 (312만행).
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { Clock, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { TruncationNotice, useTruncation } from '../components/TruncationNotice';
import {
  materialIssueColumns,
  materialNotIssuedColumns,
  smtCheckHistoryColumns,
} from '../report-b-columns';
import type {
  MaterialIssueRow,
  MaterialNotIssuedRow,
  SmtCheckHistoryRow,
} from '../report-b-types';
import PartSearchField from '@/components/shared/PartSearchField';

const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type Tab = 'detail' | 'simple' | 'notIssued' | 'smtCheck';

export default function MaterialIssueReportPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(daysAgo(0));
  const [itemCode, setItemCode] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [materialMfs, setMaterialMfs] = useState('');
  const [locationCode, setLocationCode] = useState('');
  const [minUnitPrice, setMinUnitPrice] = useState('0');
  const [barcode, setBarcode] = useState('');

  const [tab, setTab] = useState<Tab>('detail');
  const [detail, setDetail] = useState<MaterialIssueRow[]>([]);
  const [simple, setSimple] = useState<MaterialIssueRow[]>([]);
  const [notIssued, setNotIssued] = useState<MaterialNotIssuedRow[]>([]);
  const [smtCheck, setSmtCheck] = useState<SmtCheckHistoryRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const [selected, setSelected] = useState<MaterialIssueRow | null>(null);
  const [fullCheck, setFullCheck] = useState<string | null>(null);
  const [checking, setChecking] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    setSelected(null);
    setFullCheck(null);
    try {
      const params = {
        dateFrom,
        dateTo,
        itemCode: itemCode || undefined,
        lineCode: lineCode || undefined,
        materialMfs: materialMfs || undefined,
        locationCode: locationCode || undefined,
      };
      const [d, s, n] = await Promise.all([
        api.get('/report/material-issue/detail', { params }),
        api.get('/report/material-issue/simple', {
          // 단가 하한은 함수 결과에 거는 조건이라 기간 전체에 함수가 돈다
          // (실측 16.4초). 기본 타임아웃 30초로는 부족할 수 있다.
          timeout: 120_000,
          params: { ...params, minUnitPrice: Number(minUnitPrice) || 0 },
        }),
        api.get('/report/material-issue/not-issued', { params }),
      ]);
      setDetail(d.data?.data ?? []);
      setSimple(s.data?.data ?? []);
      setNotIssued(n.data?.data ?? []);
      mark(d, s, n);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '자재출고 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, itemCode, lineCode, materialMfs, locationCode, minUnitPrice]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  /** 풀체크 이력은 기간이 없어 바코드가 필수다 — 별도 조회다. */
  const searchSmtCheck = useCallback(async () => {
    if (!barcode.trim()) {
      toast.error('자재 바코드를 입력하세요 (이 탭에는 기간 조건이 없습니다).');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/report/material-issue/smt-check', {
        params: { barcode: barcode.trim() },
      });
      setSmtCheck(response.data?.data ?? []);
      mark(response);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '풀체크 이력 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [barcode]);

  /** 고른 출고 한 건의 풀체크 시각. 목록에 열로 붙이면 367초가 걸린다. */
  const loadFullCheck = useCallback(async (row: MaterialIssueRow) => {
    setSelected(row);
    setFullCheck(null);
    if (!row.itemCode || !row.materialMfs || !row.issueDateKey) {
      toast.error('이 행에는 품목·자재롯트·출고시각이 없어 풀체크를 조회할 수 없습니다.');
      return;
    }
    setChecking(true);
    try {
      const response = await api.get('/report/material-issue/full-check', {
        params: {
          itemCode: row.itemCode,
          materialMfs: row.materialMfs,
          issueDateKey: row.issueDateKey,
        },
      });
      setFullCheck(response.data?.data?.fullCheckDate ?? '');
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '풀체크 시각 조회에 실패했습니다.');
    } finally {
      setChecking(false);
    }
  }, []);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재출고리포트</h1>
        <p className="mt-1 text-sm text-text-muted">
          자재 출고를 등록일 기준으로 봅니다 ·{' '}
          {searched ? `상세 ${detail.length.toLocaleString()}건` : '조회하세요'}
          {selected ? ` · 선택 ${selected.itemCode} / ${selected.materialMfs}` : ''}
        </p>
      </header>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="등록일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-40"
            onChange={(e) => setItemCode(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
          <div className="w-40">
            <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
          </div>
          <Input aria-label="자재 롯트" placeholder="자재 롯트" value={materialMfs} className="w-40"
            onChange={(e) => setMaterialMfs(e.target.value)} />
          <ComCodeSelect groupCode="MATERIAL LOCATION CODE" labelPrefix="창고"
            value={locationCode} onChange={setLocationCode} className="w-48" />
          {/* 단가 하한은 함수 결과에 거는 조건이라 인덱스를 못 쓴다 — 기간 전체를
              훑으므로 하한을 걸면 간이 탭이 느려진다 (31일치 16초 실측). 그래도
              **상한을 자르기 전에** 걸어야 한다: 뒤에 걸면 조건에 맞는 건이
              조용히 빠진다 (실측 16,925건 중 12,786건 누락). */}
          <Input aria-label="단가 이상 (간이 탭)" placeholder="단가 이상 (간이)"
            value={minUnitPrice} className="w-36"
            onChange={(e) => setMinUnitPrice(e.target.value.replace(/[^\d.]/g, ''))} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={[
          { key: 'detail', label: '상세', count: detail.length },
          { key: 'simple', label: '간이 (단가 하한)', count: simple.length },
          { key: 'notIssued', label: '미출고', count: notIssued.length },
          { key: 'smtCheck', label: '풀체크 이력', count: smtCheck.length },
        ]}
        active={tab}
        onChange={setTab}
      />

      {tab === 'detail' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <span className="text-sm text-text-muted">
              행을 고르면 그 자재의 풀체크 시각을 조회합니다 (목록 열로 붙이면 367초가 걸립니다).
            </span>
            {checking && <span className="text-sm text-text-muted">조회 중…</span>}
            {!checking && fullCheck !== null && (
              fullCheck
                ? (
                  <span className="flex items-center gap-1 text-sm text-text">
                    <Clock className="h-4 w-4" />풀체크 시각 {fullCheck}
                  </span>
                )
                : (
                  <span className="text-sm font-semibold text-amber-500">
                    라인 스캔 기록이 없습니다 — 출고만 되고 라인에 올라가지 않았습니다.
                  </span>
                )
            )}
          </CardContent>
        </Card>
      )}

      {tab === 'smtCheck' && (
        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <Input aria-label="자재 바코드" placeholder="자재 바코드 (필수)" value={barcode}
              className="w-72"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void searchSmtCheck(); }} />
            <Button size="sm" onClick={searchSmtCheck} disabled={loading || !barcode.trim()}>
              <Search className="mr-1 h-4 w-4" />풀체크 이력 조회
            </Button>
            <span className="text-sm text-text-muted">
              스캔·협력사·이전 바코드 세 컬럼을 함께 찾습니다 (312만행이라 기간 대신 바코드로 막습니다).
            </span>
          </CardContent>
        </Card>
      )}

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'detail' && (
            <DataGrid
              data={detail}
              columns={materialIssueColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재출고상세"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['issueDate'] }}
              emptyMessage={searched ? '기간에 출고가 없습니다.' : '조회하세요.'}
              onRowClick={(row) => void loadFullCheck(row as MaterialIssueRow)}
              rowClassName={(row) => {
                const r = row as MaterialIssueRow;
                return r.issueDateKey === selected?.issueDateKey
                  && r.issueSequence === selected?.issueSequence
                  ? 'bg-primary/10'
                  : '';
              }}
            />
          )}
          {tab === 'simple' && (
            <DataGrid
              data={simple}
              columns={materialIssueColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재출고간이"
              emptyMessage={searched ? '조건에 맞는 출고가 없습니다.' : '조회하세요.'}
            />
          )}
          {tab === 'notIssued' && (
            <DataGrid
              data={notIssued}
              columns={materialNotIssuedColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재미출고"
              emptyMessage={searched
                ? '미출고가 없습니다 (이 표는 현재 비어 있습니다).'
                : '조회하세요.'}
            />
          )}
          {tab === 'smtCheck' && (
            <DataGrid
              data={smtCheck}
              columns={smtCheckHistoryColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="풀체크이력"
              emptyMessage="자재 바코드를 넣고 조회하세요."
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
