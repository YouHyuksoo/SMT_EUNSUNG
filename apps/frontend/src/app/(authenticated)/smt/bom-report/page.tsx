"use client";

/**
 * @file src/app/(authenticated)/smt/bom-report/page.tsx
 * @description SMT BOM 관리리포트 — PB w_smt_bom_master_rpt 이식
 *
 * 초보자 가이드:
 * 1. **이 화면은 배포된 계획을 라벨·바코드 형태로 뽑는 목록이다.** 설계 BOM 이 아니라
 *    현장 계획(IB_PRODUCT_PLANDATA)을 읽는다. 계획이 없으면 아무것도 안 나온다.
 * 2. **소요량은 캐리어 크기가 반영된 값이다.** PB 가 SQL 안에서 부르던
 *    f_get_carrier_size 를 그대로 호출한다 — 다시 계산하면 라벨이 PB 와 갈린다.
 *    확정단가와 PCB면 판정도 같은 이유로 DB 함수를 그대로 쓴다.
 * 3. **바코드 컬럼은 코드39 문자열이다** (`*값*`). PB 가 만들던 것과 같다.
 *    PB 의 프린터 드라이버 라벨 레이아웃은 이관 범위 밖이다 — 목록을 내보내
 *    라벨 도구에 넘기거나 브라우저 인쇄를 쓴다.
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import { SmtModelSelect, SmtPcbItemSelect } from '../components/SmtSelects';
import { smtBomReportColumns } from '../columns';
import type { SmtBomReportRow } from '../types';

export default function SmtBomReportPage() {
  const [rows, setRows] = useState<SmtBomReportRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [pcbItem, setPcbItem] = useState('');
  const [revision, setRevision] = useState('');

  const search = useCallback(async () => {
    if (modelName.trim() === '') {
      toast.error('모델을 먼저 고르세요. 배포계획은 18,607행이라 모델 없이 조회하지 않습니다.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/smt/bom/report', {
        params: {
          modelName,
          lineCode: lineCode || undefined,
          pcbItem: pcbItem || undefined,
          revision: revision || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('BOM 리포트 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, lineCode, pcbItem, revision]);

  const columns = useMemo(() => smtBomReportColumns, []);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">SMT BOM 관리리포트</h1>
          <p className="mt-1 text-sm text-text-muted">
            배포된 계획을 라벨·바코드 목록으로 뽑습니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '모델을 고르고 조회하세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <SmtModelSelect labelPrefix="모델" value={modelName}
            onChange={setModelName} className="w-64" />
          <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
            className="w-36" onChange={(e) => setLineCode(e.target.value)} />
          <SmtPcbItemSelect labelPrefix="PCB면" value={pcbItem}
            onChange={setPcbItem} className="w-44" />
          <Input aria-label="리비전" placeholder="리비전" value={revision}
            className="w-32" onChange={(e) => setRevision(e.target.value)} />
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
            exportFileName="SMT_BOM관리리포트"
            emptyMessage="모델을 고르고 조회 버튼을 누르세요."
            getRowId={(row) => {
              const r = row as SmtBomReportRow;
              return [r.lineCode, r.machine, r.locationCode, r.itemCode, r.replaceYn].join('|');
            }}
          />
        </CardContent>
      </Card>
    </div>
  );
}
