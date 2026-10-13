"use client";

/**
 * @file src/app/(authenticated)/smt/nc-upload/page.tsx
 * @description SMT 피더레이아웃 등록 — PB w_smt_upload_nc_master 이식
 *
 * 초보자 가이드:
 * 1. **흐름**: 라인·PCB면·SMT 모델을 고르고, 설비그룹마다 마운터 NC 파일과 시작 테이블을 넣어 [생성] →
 *    아래 '피더 배치' 에서 확인(품번이 빨가면 품목마스터에 없다 → [품번 교체] 나 행 삭제) →
 *    [적용] 으로 SMT BOM 을 이 배치로 바꾼다.
 * 2. **파일은 삼성 마운터 NC 파일이다.** 은성 SMT BOM 은 전부 이 형식으로 만들어졌다 (자리 표기 실측).
 * 3. **시작 테이블**: 설비마다 앞(F) 피더는 시작 테이블, 뒤(R) 피더는 그 다음 글자다. 보통 그룹1=A, 2=C, 3=E, 4=G.
 * 4. **공급처**를 고르면 마운터 품번을 그 공급처 품목코드로 바꿔 넣는다 (품번·규격 일치 우선).
 * 5. **적용**은 이 모델·라인·면의 SMT BOM 을 지우고 다시 넣는다. Line Mixed 면 배치에 있는 자리만 바꾼다.
 *    피더 배치 작업표는 모두가 함께 쓰는 한 장이다 — 생성 후 바로 적용한다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import type { ColumnDef } from '@tanstack/react-table';
import { CheckCircle2, FileUp, Play, Replace, Search, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ScreenTabs from '@/components/shared/ScreenTabs';
import SupplierSelect from '@/components/shared/SupplierSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import Select from '@/components/ui/Select';
import api from '@/services/api';
import { SmtPcbItemSelect } from '../components/SmtSelects';
import { smtNcColumns, smtNcCompareColumns, smtNcDuplicateColumns } from '../columns';
import type { SmtNcCompareRow, SmtNcDuplicateRow, SmtNcRow } from '../types';
import LineSelect from '@/components/shared/LineSelect';

type Tab = 'list' | 'duplicates' | 'compare';

const TABS: Array<{ key: Tab; label: string; hint: string }> = [
  { key: 'list', label: '피더 배치', hint: '생성한 피더 배치(작업표)를 확인한다' },
  { key: 'duplicates', label: '중복 검증', hint: '같은 자리가 두 줄 이상인 것을 찾는다' },
  { key: 'compare', label: 'BOM 대조', hint: '설계 BOM 과 피더 배치를 품목 단위로 맞춘다' },
];

const TABLE_OPTIONS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((t) => ({ value: t, label: `시작 테이블 ${t}` }));

interface GroupInput { machineGroup: string; startTableId: string; file: File | null }

export default function SmtNcUploadPage() {
  const [tab, setTab] = useState<Tab>('list');

  // 생성 조건 (PB 의 라인·PCB 면·SMT 모델·레이아웃 모델·공급처)
  const [lineCode, setLineCode] = useState('');
  const [pcbItem, setPcbItem] = useState('');
  const [smtModels, setSmtModels] = useState<string[]>([]);
  const [smtModelName, setSmtModelName] = useState('');
  const [layoutModelName, setLayoutModelName] = useState('');
  const [supplierCode, setSupplierCode] = useState('');
  const [groups, setGroups] = useState<GroupInput[]>([]);
  const [revision, setRevision] = useState('');
  const [mixed, setMixed] = useState(false);

  const [rows, setRows] = useState<SmtNcRow[]>([]);
  const [duplicates, setDuplicates] = useState<SmtNcDuplicateRow[]>([]);
  const [compare, setCompare] = useState<SmtNcCompareRow[]>([]);
  const [diffCount, setDiffCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [applyOpen, setApplyOpen] = useState(false);
  const [deleteRow, setDeleteRow] = useState<SmtNcRow | null>(null);

  useEffect(() => {
    api.get('/smt/nc/smt-models')
      .then((res) => setSmtModels((res.data?.data ?? []).map((r: { smtModelName: string }) => r.smtModelName)))
      .catch(() => { /* 원인은 api 인터셉터의 오류 창이 보여 준다. */ });
  }, []);

  // 라인을 고르면 그 라인의 설비그룹마다 파일 칸을 만든다. 시작 테이블은 그룹마다 두 글자씩(F/R) 띄워 채운다.
  useEffect(() => {
    if (!lineCode) { setGroups([]); return; }
    api.get('/smt/nc/machine-groups', { params: { lineCode } })
      .then((res) => {
        const list: Array<{ machineGroup: string }> = res.data?.data ?? [];
        setGroups(list.map((g, i) => ({
          machineGroup: g.machineGroup,
          startTableId: String.fromCharCode(65 + i * 2),
          file: null,
        })));
      })
      .catch(() => setGroups([]));
  }, [lineCode]);

  const search = useCallback(async (which: Tab = tab) => {
    setLoading(true);
    try {
      if (which === 'list') {
        const response = await api.get('/smt/nc', { params: { lineCode: lineCode || undefined } });
        setRows(response.data?.data ?? []);
      } else if (which === 'duplicates') {
        const response = await api.get('/smt/nc/duplicates', { params: { lineCode: lineCode || undefined } });
        setDuplicates(response.data?.data ?? []);
      } else {
        const setItemCode = (layoutModelName || smtModelName).trim();
        if (!setItemCode) { toast.error('대조할 모델(SMT 모델)을 고르세요.'); return; }
        const response = await api.get('/smt/nc/bom-compare', {
          params: { setItemCode, lineCode: lineCode || undefined, pcbItem: pcbItem || undefined },
        });
        const data = response.data?.data;
        setCompare(data?.data ?? []);
        setDiffCount(Number(data?.diffCount ?? 0));
      }
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setLoading(false);
    }
  }, [tab, lineCode, layoutModelName, smtModelName, pcbItem]);

  useEffect(() => { void search('list'); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const generate = async () => {
    if (!lineCode || !pcbItem || !smtModelName || !layoutModelName.trim()) {
      toast.error('라인 / PCB 면 / SMT 모델 / 레이아웃 모델명을 넣으세요.');
      return;
    }
    const withFile = groups.filter((g) => g.file);
    if (withFile.length === 0) { toast.error('설비그룹에 NC 파일을 하나 이상 넣으세요.'); return; }
    const form = new FormData();
    const groupJson = groups.map((g) => ({
      machineGroup: g.machineGroup,
      startTableId: g.startTableId,
      fileIndex: g.file ? withFile.indexOf(g) : -1,
    }));
    withFile.forEach((g) => form.append('files', g.file as File));
    form.append('lineCode', lineCode);
    form.append('pcbItem', pcbItem);
    form.append('smtModelName', smtModelName);
    form.append('layoutModelName', layoutModelName.trim());
    if (supplierCode) form.append('supplierCode', supplierCode);
    form.append('groups', JSON.stringify(groupJson));
    setBusy(true);
    try {
      const res = await api.post('/smt/nc/generate', form, { headers: { 'Content-Type': 'multipart/form-data' } });
      toast.success(`피더 배치 ${res.data?.data?.count ?? 0}줄을 만들었습니다 (파일 ${res.data?.data?.files ?? 0}개).`);
      setTab('list');
      await search('list');
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setBusy(false);
    }
  };

  const replacePart = async () => {
    if (!supplierCode) { toast.error('품번을 바꿀 공급처를 고르세요.'); return; }
    setBusy(true);
    try {
      const res = await api.post('/smt/nc/replace-part', { supplierCode });
      toast.success(`${res.data?.data?.total ?? 0}줄 중 ${res.data?.data?.changed ?? 0}줄의 품번을 바꿨습니다.`);
      await search('list');
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setBusy(false);
    }
  };

  const removeRow = async () => {
    if (!deleteRow) return;
    setDeleteRow(null);
    try {
      await api.delete(`/smt/nc/rows/${encodeURIComponent(deleteRow.rowKey)}`);
      await search('list');
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    }
  };

  const apply = async () => {
    setApplyOpen(false);
    setBusy(true);
    try {
      const res = await api.post('/smt/nc/apply', {
        lineCode, layoutModelName: layoutModelName.trim(), smtModelName, revision: revision.trim(), mixed,
      });
      const d = res.data?.data ?? {};
      toast.success(`SMT BOM 에 ${d.inserted ?? 0}줄을 반영했습니다 (기존 ${d.deleted?.bom ?? 0}줄 교체).`);
    } catch {
      // 원인은 api 인터셉터의 오류 창이 보여 준다.
    } finally {
      setBusy(false);
    }
  };

  const unknownCount = rows.filter((r) => r.itemExists === 'N').length;
  const listColumns = useMemo<ColumnDef<SmtNcRow>[]>(() => [
    {
      id: 'actions', header: '작업', size: 60, enableSorting: false, meta: { filterType: 'none' as const },
      cell: ({ row }) => (
        <button type="button" title="이 줄 삭제" className="rounded p-1 text-red-500 hover:bg-surface"
          onClick={(e) => { e.stopPropagation(); setDeleteRow(row.original); }}>
          <Trash2 className="h-3.5 w-3.5" />
        </button>
      ),
    },
    ...smtNcColumns,
  ], []);

  const summary = tab === 'list'
    ? `${rows.length}줄${unknownCount > 0 ? ` · 품목마스터에 없는 품번 ${unknownCount}줄` : ''}`
    : tab === 'duplicates'
      ? (duplicates.length === 0 ? '중복 없음' : `중복 ${duplicates.length}건`)
      : `품목 ${compare.length}건 중 ${diffCount}건이 다릅니다`;

  return (
    <div className="flex h-full flex-col gap-4 overflow-auto p-6">
      <header className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">SMT 피더레이아웃 등록</h1>
          <p className="mt-1 text-sm text-text-muted">
            마운터 NC 파일로 피더 배치를 만들고 SMT BOM 에 반영합니다 · {summary}
          </p>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
            <SmtPcbItemSelect labelPrefix="PCB면" value={pcbItem} onChange={setPcbItem} className="w-40" />
            <Select
              aria-label="SMT 모델"
              value={smtModelName}
              onChange={(v) => { setSmtModelName(v); setLayoutModelName(v); }}
              className="w-72"
              options={[{ value: '', label: 'SMT 모델: 선택' }, ...smtModels.map((m) => ({ value: m, label: `SMT 모델: ${m}` }))]}
            />
            <Input aria-label="레이아웃 모델명" placeholder="레이아웃 모델명" value={layoutModelName}
              className="w-72" onChange={(e) => setLayoutModelName(e.target.value)} />
            <SupplierSelect includeAll labelPrefix="공급처" value={supplierCode} onChange={setSupplierCode} className="w-56" />
          </div>
          {groups.length > 0 && (
            <div className="grid gap-2 md:grid-cols-2">
              {groups.map((g, i) => (
                <div key={g.machineGroup} className="flex items-center gap-2 rounded border border-border p-2">
                  <span className="w-20 shrink-0 text-sm font-semibold text-text">설비그룹 {g.machineGroup}</span>
                  <Select aria-label={`설비그룹 ${g.machineGroup} 시작 테이블`} value={g.startTableId} className="w-36"
                    options={TABLE_OPTIONS}
                    onChange={(v) => setGroups((prev) => prev.map((x, k) => (k === i ? { ...x, startTableId: v } : x)))} />
                  <label className="flex min-w-0 flex-1 cursor-pointer items-center gap-2 rounded border border-dashed border-border px-2 py-1.5 text-sm text-text-muted hover:bg-surface">
                    <FileUp className="h-4 w-4 shrink-0" />
                    <span className="truncate">{g.file ? g.file.name : 'NC 파일 선택'}</span>
                    <input type="file" className="hidden"
                      onChange={(e) => {
                        const file = e.target.files?.[0] ?? null;
                        setGroups((prev) => prev.map((x, k) => (k === i ? { ...x, file } : x)));
                        e.target.value = '';
                      }} />
                  </label>
                </div>
              ))}
            </div>
          )}
          <div className="flex flex-wrap items-center gap-2">
            <Button size="sm" onClick={() => void generate()} disabled={busy || !lineCode}>
              <Play className="mr-1 h-4 w-4" />생성
            </Button>
            <span className="text-xs text-text-muted">
              {lineCode ? '설비그룹마다 그 설비의 NC 파일을 넣습니다. 파일이 없는 그룹은 건너뜁니다.' : '라인을 고르면 설비그룹마다 파일 칸이 나옵니다.'}
            </span>
          </div>
        </CardContent>
      </Card>

      <div className="flex flex-wrap items-center justify-between gap-3">
        <ScreenTabs
          tabs={TABS.map((t) => ({
            key: t.key,
            label: t.label,
            tooltip: t.hint,
            count: { list: rows.length, duplicates: duplicates.length, compare: compare.length }[t.key],
          }))}
          active={tab}
          onChange={(key) => { setTab(key); void search(key); }}
        />
        <div className="flex flex-wrap items-center gap-2">
          <Button size="sm" variant="secondary" onClick={() => void search()} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {tab === 'list' && (
            <>
              <Button size="sm" variant="secondary" onClick={() => void replacePart()} disabled={busy || rows.length === 0}>
                <Replace className="mr-1 h-4 w-4" />품번 교체
              </Button>
              <Input aria-label="리비전" placeholder="리비전" value={revision} className="w-24"
                onChange={(e) => setRevision(e.target.value)} />
              <label className="flex items-center gap-1 text-sm text-text">
                <input type="checkbox" checked={mixed} onChange={(e) => setMixed(e.target.checked)} />
                Line Mixed
              </label>
              <Button size="sm" disabled={busy || rows.length === 0}
                onClick={() => {
                  if (!revision.trim()) { toast.error('리비전을 넣으세요.'); return; }
                  if (!smtModelName || !layoutModelName.trim() || !lineCode) { toast.error('라인·SMT 모델·레이아웃 모델명을 고르세요.'); return; }
                  setApplyOpen(true);
                }}>
                <CheckCircle2 className="mr-1 h-4 w-4" />적용
              </Button>
            </>
          )}
        </div>
      </div>

      <Card className="min-h-[420px] flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'list' && (
            <DataGrid
              data={rows}
              columns={listColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="SMT피더배치"
              emptyMessage="NC 파일로 [생성]하면 피더 배치가 나옵니다."
              getRowId={(row) => (row as SmtNcRow).rowKey}
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
              exportFileName="SMT피더배치중복"
              emptyMessage="중복이 없습니다."
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
              emptyMessage="SMT 모델을 고르고 조회하세요."
              getRowId={(row) => String((row as SmtNcCompareRow).itemCode)}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={applyOpen}
        onClose={() => setApplyOpen(false)}
        onConfirm={apply}
        title="SMT BOM 적용"
        message={`${layoutModelName} / ${lineCode} 라인 / ${pcbItem || '-'}면 SMT BOM 을 피더 배치 ${rows.length}줄로 ${mixed ? '자리별로 바꿉니다 (Line Mixed)' : '모두 바꿉니다'}. 리비전 ${revision}.`}
      />
      <ConfirmModal
        isOpen={deleteRow !== null}
        onClose={() => setDeleteRow(null)}
        onConfirm={removeRow}
        title="피더 배치 줄 삭제"
        message={deleteRow ? `${deleteRow.tableId ?? ''}${deleteRow.address ?? ''} ${deleteRow.partName ?? ''} 줄을 지울까요?` : ''}
        variant="danger"
      />
    </div>
  );
}
