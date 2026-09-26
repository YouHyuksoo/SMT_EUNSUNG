"use client";

/**
 * @file src/app/(authenticated)/jig/sample/page.tsx
 * @description 샘플마스터 관리 — PB w_mcn_sample_master 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **잔여일**: 적용일 + 유효개월 - 오늘. PB 는 이 값이 조회조건 이하인 것만 본다.
 *    0 이하면 만료라 그리드에서 빨간색으로 보인다.
 * 2. 샘플유형·상태·사용상태는 기초코드 선택이다. 자유 입력은 코드·이름·보관위치뿐이다.
 * 3. 행을 고르면 하단에서 그 샘플의 적용모델을 조회한다.
 * 4. 등록·수정은 PB 원본에 있으나 이번 범위에서 제외했다(조회 먼저).
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { FlaskConical, RefreshCw, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  sampleApplyModelColumns,
  sampleMasterColumns,
  type SampleApplyModelRow,
  type SampleMasterRow,
} from './columns';

export default function SampleMasterPage() {
  const [rows, setRows] = useState<SampleMasterRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [sampleCode, setSampleCode] = useState('');
  const [sampleName, setSampleName] = useState('');
  const [sampleType, setSampleType] = useState('');
  const [sampleStatus, setSampleStatus] = useState('');
  const [useStatus, setUseStatus] = useState('');
  const [remainDays, setRemainDays] = useState('');

  const [selected, setSelected] = useState<SampleMasterRow | null>(null);
  const [applyModels, setApplyModels] = useState<SampleApplyModelRow[]>([]);
  const [applyLoading, setApplyLoading] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/sample', {
        params: {
          sampleCode: sampleCode || undefined,
          sampleName: sampleName || undefined,
          sampleType: sampleType || undefined,
          sampleStatus: sampleStatus || undefined,
          useStatus: useStatus || undefined,
          remainDays: remainDays.trim() === '' ? undefined : Number(remainDays),
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
      setApplyModels([]);
    } catch {
      toast.error('샘플마스터 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [sampleCode, sampleName, sampleType, sampleStatus, useStatus, remainDays]);

  /** 선택 행이 바뀌면 그 샘플의 적용모델을 다시 읽는다 */
  useEffect(() => {
    if (!selected) return;
    let cancelled = false;
    setApplyLoading(true);
    api.get('/jig/sample/apply-models', {
      params: { sampleCode: selected.sampleCode, sampleLotNo: selected.sampleLotNo ?? '' },
    })
      .then((response) => { if (!cancelled) setApplyModels(response.data?.data ?? []); })
      .catch(() => { if (!cancelled) toast.error('적용모델 조회에 실패했습니다.'); })
      .finally(() => { if (!cancelled) setApplyLoading(false); });
    return () => { cancelled = true; };
  }, [selected]);

  const columns = useMemo(() => sampleMasterColumns, []);
  const applyColumns = useMemo(() => sampleApplyModelColumns, []);

  return (
    <div className="flex h-full min-h-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <FlaskConical className="h-6 w-6 text-primary" />샘플마스터 관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            샘플마스터의 유효기간·잔여일과 적용모델을 조회합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="secondary" size="sm" onClick={search} disabled={loading}>
            <RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침
          </Button>
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input placeholder="샘플코드" value={sampleCode} className="w-40"
            onChange={(e) => setSampleCode(e.target.value)} />
          <Input placeholder="샘플명" value={sampleName} className="w-40"
            onChange={(e) => setSampleName(e.target.value)} />
          <ComCodeSelect groupCode="SAMPLE TYPE" value={sampleType} onChange={setSampleType} className="w-44" />
          <ComCodeSelect groupCode="SAMPLE STATUS" value={sampleStatus} onChange={setSampleStatus} className="w-44" />
          <ComCodeSelect groupCode="USE STATUS" value={useStatus} onChange={setUseStatus} className="w-44" />
          <Input placeholder="잔여일 이하" type="number" value={remainDays} className="w-32"
            onChange={(e) => setRemainDays(e.target.value)} />
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={columns}
            isLoading={loading}
            pageSize={50}
            enableColumnFilter
            enableExport
            exportFileName="샘플마스터"
            emptyMessage="조회 버튼을 눌러 샘플을 확인하세요."
            onRowClick={(row) => setSelected(row as SampleMasterRow)}
            getRowId={(row) => {
              const sample = row as SampleMasterRow;
              return `${sample.sampleCode}|${sample.sampleLotNo ?? ''}`;
            }}
          />
        </CardContent>
      </Card>

      <Card padding="none" className="h-56 shrink-0 overflow-hidden">
        <CardContent className="flex h-full flex-col p-3">
          <b className="mb-2 text-sm text-text">
            적용모델{selected ? ` — ${selected.sampleCode} / ${selected.sampleLotNo ?? ''}` : ''}
          </b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={applyModels}
              columns={applyColumns}
              isLoading={applyLoading}
              pageSize={20}
              emptyMessage={selected ? '적용모델이 없습니다.' : '샘플을 선택하세요.'}
              getRowId={(row) => (row as SampleApplyModelRow).itemCode}
            />
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
