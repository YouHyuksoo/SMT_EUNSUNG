"use client";

/**
 * @file src/app/(authenticated)/smt/nc-upload/page.tsx
 * @description SMT 피더레이아웃 등록 — PB w_smt_upload_nc_master 이식 (부분)
 *
 * 초보자 가이드:
 * 1. **이관된 것**: 이미 적재된 마운터 배치표 조회 · 중복 검증 · SMT BOM 대조.
 * 2. **이관되지 않은 것 — 마운터 벤더별 NC 파일 파싱.** PB 원본의 대부분이
 *    Yamaha·NPM·LG 마운터가 뱉는 텍스트/CSV 를 한 줄씩 끊어 읽는 코드다.
 *    포맷 샘플이 없어 옮겨도 맞는지 확인할 방법이 없으므로 제외했다.
 *    **적재는 아직 PB 화면으로 한다.** 이 화면은 적재 결과를 보고 검증하는 쪽이다.
 * 3. **중복 검증이 왜 필요한가**: 이 표에는 유일제약이 없다. NC 파일을 두 번 올리면
 *    같은 자리가 두 줄이 되고, 그러면 대조 수량이 부풀어 배포가 틀린다.
 * 4. **대조 탭**은 설계 BOM(전개값)과 적재된 피더 배치를 품목 단위로 맞춰 본다.
 *    한쪽에만 있는 품목과 수량이 다른 품목을 판정 컬럼에 적는다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtMachineSelect, SmtModelSelect, SmtPcbItemSelect } from '../components/SmtSelects';
import { smtNcColumns, smtNcCompareColumns, smtNcDuplicateColumns } from '../columns';
import type { SmtNcCompareRow, SmtNcDuplicateRow, SmtNcRow } from '../types';

type Tab = 'list' | 'duplicates' | 'compare';

const TABS: Array<{ key: Tab; label: string; hint: string }> = [
  { key: 'list', label: '적재 배치표', hint: '마운터에서 올라온 피더 배치를 본다' },
  { key: 'duplicates', label: '중복 검증', hint: '같은 자리가 두 줄 이상인 것을 찾는다' },
  { key: 'compare', label: 'BOM 대조', hint: '설계 BOM 과 적재 배치를 품목 단위로 맞춘다' },
];

export default function SmtNcUploadPage() {
  const [tab, setTab] = useState<Tab>('list');

  const [lineCode, setLineCode] = useState('');
  const [machineCode, setMachineCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [lotName, setLotName] = useState('');
  const [pcbItem, setPcbItem] = useState('');

  const [rows, setRows] = useState<SmtNcRow[]>([]);
  const [duplicates, setDuplicates] = useState<SmtNcDuplicateRow[]>([]);
  const [compare, setCompare] = useState<SmtNcCompareRow[]>([]);
  const [diffCount, setDiffCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState<Record<Tab, boolean>>({
    list: false, duplicates: false, compare: false,
  });

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (tab === 'list') {
        const response = await api.get('/smt/nc', {
          params: {
            lineCode: lineCode || undefined,
            machineCode: machineCode || undefined,
            modelName: modelName || undefined,
            lotName: lotName || undefined,
          },
        });
        setRows(response.data?.data ?? []);
      } else if (tab === 'duplicates') {
        const response = await api.get('/smt/nc/duplicates', {
          params: {
            lineCode: lineCode || undefined,
            machineCode: machineCode || undefined,
            modelName: modelName || undefined,
          },
        });
        setDuplicates(response.data?.data ?? []);
      } else {
        if (modelName.trim() === '') {
          toast.error('대조할 모델을 고르세요. BOM 전개에 필요합니다.');
          return;
        }
        const response = await api.get('/smt/nc/bom-compare', {
          params: {
            setItemCode: modelName.trim(),
            lineCode: lineCode || undefined,
            pcbItem: pcbItem || undefined,
          },
        });
        const data = response.data?.data;
        setCompare(data?.data ?? []);
        setDiffCount(Number(data?.diffCount ?? 0));
      }
      setSearched((prev) => ({ ...prev, [tab]: true }));
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, lineCode, machineCode, modelName, lotName, pcbItem]);

  const summary = useMemo(() => {
    if (tab === 'list') return searched.list ? `${rows.length}건` : '조회하세요';
    if (tab === 'duplicates') {
      if (!searched.duplicates) return '조회하세요';
      return duplicates.length === 0 ? '중복 없음' : `중복 ${duplicates.length}건`;
    }
    if (!searched.compare) return '모델을 고르고 조회하세요';
    return `품목 ${compare.length}건 중 ${diffCount}건이 다릅니다`;
  }, [tab, searched, rows.length, duplicates.length, compare.length, diffCount]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">SMT 피더레이아웃 등록</h1>
          <p className="mt-1 text-sm text-text-muted">
            {TABS.find((t) => t.key === tab)?.hint} · {summary}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <div className="rounded border border-amber-500/40 bg-amber-500/10 p-3 text-sm text-text">
        마운터 벤더별 NC 파일 파싱(Yamaha · NPM · LG)은 이관 범위 밖입니다.
        적재는 기존 PB 화면으로 하고, 이 화면에서는 적재 결과를 조회·검증·대조합니다.
      </div>

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
          {tab !== 'compare' && (
            <SmtMachineSelect labelPrefix="설비" value={machineCode}
              onChange={setMachineCode} className="w-52" />
          )}
          <SmtModelSelect labelPrefix="모델" value={modelName}
            onChange={setModelName} className="w-64" />
          {tab === 'list' && (
            <Input aria-label="LOT명" placeholder="LOT명" value={lotName}
              className="w-40" onChange={(e) => setLotName(e.target.value)} />
          )}
          {tab === 'compare' && (
            <SmtPcbItemSelect labelPrefix="PCB면" value={pcbItem}
              onChange={setPcbItem} className="w-44" />
          )}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'list' && (
            <DataGrid
              data={rows}
              columns={smtNcColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SMT적재배치표"
              emptyMessage="조회 버튼을 눌러 적재 배치를 확인하세요."
              getRowId={(row) => {
                const r = row as SmtNcRow;
                return [r.lineCode, r.machineCode, r.tableId, r.address, r.position].join('|');
              }}
            />
          )}
          {tab === 'duplicates' && (
            <DataGrid
              data={duplicates}
              columns={smtNcDuplicateColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SMT적재중복검증"
              emptyMessage={searched.duplicates ? '중복이 없습니다.' : '조회 버튼을 누르세요.'}
              getRowId={(row) => {
                const r = row as SmtNcDuplicateRow;
                return [r.lineCode, r.machineCode, r.lotName, r.tableId,
                  r.address, r.position, r.pcbItem].join('|');
              }}
            />
          )}
          {tab === 'compare' && (
            <DataGrid
              data={compare}
              columns={smtNcCompareColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SMT피더BOM대조"
              emptyMessage="모델을 고르고 조회 버튼을 누르세요."
              getRowId={(row) => String((row as SmtNcCompareRow).itemCode)}
            />
          )}
        </CardContent>
      </Card>
    </div>
  );
}
