"use client";

/**
 * @file src/app/(authenticated)/smt/plan/page.tsx
 * @description SMT 계획배포관리 — PB w_smt_plan_master 이식
 *
 * 초보자 가이드:
 * 1. **"배포" 는 설계 BOM 을 현장용 계획으로 펼치는 일이다.**
 *    펼친 뒤에는 현장이 이 표를 보고 자재를 물린다.
 * 2. **활성(ACTIVE_YN='Y') 이 현장이 쓰는 계획이다.**
 *    - 배포: 활성 계획이 있거나 이미 배포된 행이 있으면 거부된다.
 *    - 배포취소: 비활성 행만 지우고 백업 테이블로 옮긴다. 활성은 건드리지 않는다.
 *    - 활성화: 한 라인에 두 모델이 동시에 활성일 수 없다. 그러면 현장이 어느
 *      계획으로 자재를 물릴지 알 수 없다.
 * 3. **위 표는 라인별 현황이다.** 지금 어느 라인이 무슨 모델을 물고 있는지 본다.
 *    아래 표가 선택한 모델의 계획 상세다.
 * 4. 체크상태·CCS 는 보기만 한다 — 그 값을 바꾸는 것은 현장 스캔·풀체크 화면이다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Play, Power, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import Select from '@/components/ui/Select';
import api from '@/services/api';
import { SmtModelSelect, SmtPcbItemSelect } from '../components/SmtSelects';
import { smtPlanColumns, smtPlanLineColumns } from '../columns';
import type { SmtPlanLineRow, SmtPlanRow } from '../types';
import SmtPlanDeployModal from './components/SmtPlanDeployModal';

const YN_OPTIONS = [
  { value: '', label: '전체' },
  { value: 'Y', label: '예' },
  { value: 'N', label: '아니오' },
];

export default function SmtPlanPage() {
  const [lines, setLines] = useState<SmtPlanLineRow[]>([]);
  const [rows, setRows] = useState<SmtPlanRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [modelName, setModelName] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [pcbItem, setPcbItem] = useState('');
  const [replaceYn, setReplaceYn] = useState('');
  const [activeYn, setActiveYn] = useState('');

  const [deployOpen, setDeployOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [activateOpen, setActivateOpen] = useState<'Y' | 'N' | null>(null);
  const [busy, setBusy] = useState(false);

  /** 라인 현황은 화면을 열 때 한 번 읽고, 배포·취소·전환 뒤에 다시 읽는다. */
  const loadLines = useCallback(async () => {
    try {
      const response = await api.get('/smt/plan/lines');
      setLines(response.data?.data ?? []);
    } catch {
      setLines([]);
    }
  }, []);

  useEffect(() => { void loadLines(); }, [loadLines]);

  const search = useCallback(async () => {
    if (modelName.trim() === '') {
      toast.error('모델을 먼저 고르세요. 배포계획은 18,607행이라 모델 없이 조회하지 않습니다.');
      return;
    }
    setLoading(true);
    try {
      const response = await api.get('/smt/plan', {
        params: {
          modelName,
          lineCode: lineCode || undefined,
          pcbItem: pcbItem || undefined,
          replaceYn: replaceYn || undefined,
          activeYn: activeYn || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
    } catch {
      toast.error('배포계획 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [modelName, lineCode, pcbItem, replaceYn, activeYn]);

  const afterChange = useCallback(() => {
    void loadLines();
    if (searched) void search();
  }, [loadLines, search, searched]);

  const remove = useCallback(async () => {
    setDeleteOpen(false);
    setBusy(true);
    try {
      const response = await api.delete('/smt/plan', {
        data: {
          lineCode: lineCode.trim(),
          modelName: modelName.trim(),
          pcbItem: pcbItem || undefined,
        },
      });
      const data = response.data?.data;
      toast.success(
        `비활성 계획 ${data?.deleted ?? 0}행을 지웠습니다`
        + (Number(data?.remainingActive ?? 0) > 0
          ? ` (활성 ${data.remainingActive}행은 남겼습니다).`
          : '.'),
      );
      afterChange();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '배포 취소에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [lineCode, modelName, pcbItem, afterChange]);

  const setActive = useCallback(async (yn: 'Y' | 'N') => {
    setActivateOpen(null);
    setBusy(true);
    try {
      const response = await api.put('/smt/plan/active', {
        lineCode: lineCode.trim(),
        modelName: modelName.trim(),
        pcbItem: pcbItem || undefined,
        activeYn: yn,
      });
      const data = response.data?.data;
      toast.success(
        `${yn === 'Y' ? '활성화' : '비활성화'} 완료 — 활성 ${data?.active ?? 0}행 / 비활성 ${data?.inactive ?? 0}행`,
      );
      afterChange();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '전환에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [lineCode, modelName, pcbItem, afterChange]);

  const columns = useMemo(() => smtPlanColumns, []);
  const lineColumns = useMemo(() => smtPlanLineColumns, []);
  const scopeReady = modelName.trim() !== '' && lineCode.trim() !== '';

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">SMT 계획배포관리</h1>
          <p className="mt-1 text-sm text-text-muted">
            SMT BOM 을 현장 피더 계획으로 배포합니다 ·{' '}
            {searched ? `${rows.length}/${total}건` : '모델을 고르고 조회하세요'}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          <Button size="sm" onClick={() => setDeployOpen(true)} disabled={busy}>
            <Play className="mr-1 h-4 w-4" />배포
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setActivateOpen('Y')}>
            <Power className="mr-1 h-4 w-4" />활성화
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setActivateOpen('N')}>
            <Power className="mr-1 h-4 w-4" />비활성화
          </Button>
          <Button size="sm" variant="secondary" disabled={!scopeReady || busy}
            onClick={() => setDeleteOpen(true)}>
            <Trash2 className="mr-1 h-4 w-4 text-red-500" />배포취소
          </Button>
        </div>
      </header>

      <Card className="h-56 shrink-0 overflow-hidden" padding="none">
        <CardContent className="flex h-full flex-col gap-2 p-3">
          <b className="text-sm text-text">라인별 배포 현황 ({lines.length}개 라인)</b>
          <div className="min-h-0 flex-1">
            <DataGrid
              data={lines}
              columns={lineColumns}
              pageSize={50}
              emptyMessage="생산라인이 없습니다."
              onRowClick={(row) => setLineCode(String((row as SmtPlanLineRow).lineCode))}
              getRowId={(row) => String((row as SmtPlanLineRow).lineCode)}
            />
          </div>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <SmtModelSelect labelPrefix="모델" value={modelName}
            onChange={setModelName} className="w-64" />
          <Input aria-label="라인코드" placeholder="라인코드" value={lineCode}
            className="w-36" onChange={(e) => setLineCode(e.target.value)} />
          <SmtPcbItemSelect labelPrefix="PCB면" value={pcbItem}
            onChange={setPcbItem} className="w-44" />
          <div className="w-36">
            <Select options={YN_OPTIONS.map((o) => ({
              ...o, label: o.value === '' ? '대체: 전체' : `대체: ${o.label}`,
            }))} value={replaceYn} onChange={setReplaceYn} />
          </div>
          <div className="w-36">
            <Select options={YN_OPTIONS.map((o) => ({
              ...o, label: o.value === '' ? '활성: 전체' : `활성: ${o.label}`,
            }))} value={activeYn} onChange={setActiveYn} />
          </div>
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
            exportFileName="SMT계획배포"
            emptyMessage="모델을 고르고 조회 버튼을 누르세요."
            getRowId={(row) => {
              const r = row as SmtPlanRow;
              return [r.modelName, r.lineCode, r.machine, r.locationCode,
                r.itemCode, r.pcbItem, r.replaceYn].join('|');
            }}
          />
        </CardContent>
      </Card>

      {deployOpen && (
        <SmtPlanDeployModal
          defaultModelName={modelName}
          defaultLineCode={lineCode}
          onClose={() => setDeployOpen(false)}
          onDone={() => { setDeployOpen(false); afterChange(); }}
        />
      )}

      <ConfirmModal
        isOpen={deleteOpen}
        onClose={() => setDeleteOpen(false)}
        onConfirm={remove}
        title="배포 취소"
        message={`${lineCode} / ${modelName}${pcbItem ? ` / ${pcbItem}면` : ' / 양면'}`
          + ' 의 비활성 계획을 지울까요? 활성 계획은 그대로 남습니다.'
          + ' 지우는 행은 백업 테이블로 옮겨집니다.'}
        variant="danger"
      />

      <ConfirmModal
        isOpen={activateOpen !== null}
        onClose={() => setActivateOpen(null)}
        onConfirm={() => activateOpen && setActive(activateOpen)}
        title={activateOpen === 'Y' ? '계획 활성화' : '계획 비활성화'}
        message={activateOpen === 'Y'
          ? `${lineCode} 라인을 ${modelName} 계획으로 돌립니까?`
            + ' 같은 라인에 이미 활성인 다른 모델이 있으면 거부됩니다.'
          : `${lineCode} / ${modelName} 계획을 비활성으로 바꿉니까?`
            + ' 현장이 이 계획으로 자재를 물리지 않게 됩니다.'}
      />
    </div>
  );
}
