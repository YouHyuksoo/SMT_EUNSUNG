"use client";

/**
 * @file src/app/(authenticated)/jig/master/page.tsx
 * @description 지그마스터 — PB w_mcn_jig_master 이식
 *
 * 초보자 가이드:
 * 1. **조회조건**: PB 규약대로 `값 + '%'` LIKE 다. 빈 값이면 전체 조회.
 * 2. **등록·수정**: PB 는 별도 탭(dw_2)이지만 웹은 우측 폼 패널 하나로 만든다.
 * 3. **적용모델**: 행을 고르면 하단에서 그 지그의 적용모델을 조회한다.
 *    복사는 PKG_MES_MAC.SP_COPY_APPLY_MODEL 을 호출한다 — 대상의 기존 적용모델을
 *    전부 지우고 원본 것으로 덮으므로 확인 모달을 반드시 거친다.
 * 4. **지그 이미지(BLOB)**: 이관 범위에서 제외했다. PB 는 JIG_IMAGE 에 저장한다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Copy, Edit2, Grip, Plus, Search } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import LineSelect from '@/components/shared/LineSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { jigApplyModelColumns, jigMasterColumns } from './columns';
import JigMasterFormPanel, { emptyJigForm, toJigForm, type JigForm } from './components/JigMasterFormPanel';
import type { JigApplyModelRow, JigMasterRow } from './types';

export default function JigMasterPage() {
  const [rows, setRows] = useState<JigMasterRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [jigCode, setJigCode] = useState('');
  const [jigLotNo, setJigLotNo] = useState('');
  const [jigType, setJigType] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [jigStatus, setJigStatus] = useState('');

  const [selected, setSelected] = useState<JigMasterRow | null>(null);
  const [applyModels, setApplyModels] = useState<JigApplyModelRow[]>([]);
  const [applyLoading, setApplyLoading] = useState(false);

  const [panel, setPanel] = useState<{ mode: 'create' | 'edit'; form: JigForm } | null>(null);
  const [copyFrom, setCopyFrom] = useState('');
  const [copyOpen, setCopyOpen] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/jig/master', {
        params: {
          jigCode: jigCode || undefined,
          jigLotNo: jigLotNo || undefined,
          jigType: jigType || undefined,
          lineCode: lineCode || undefined,
          jigStatus: jigStatus || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setSelected(null);
      setApplyModels([]);
    } catch {
      toast.error('지그마스터 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [jigCode, jigLotNo, jigType, lineCode, jigStatus]);

  /** 선택 행이 바뀌면 그 지그의 적용모델을 다시 읽는다 */
  useEffect(() => {
    if (!selected) return;
    let cancelled = false;
    setApplyLoading(true);
    api.get('/jig/master/apply-models', {
      params: { jigCode: selected.jigCode, jigLotNo: selected.jigLotNo },
    })
      .then((response) => { if (!cancelled) setApplyModels(response.data?.data ?? []); })
      .catch(() => { if (!cancelled) toast.error('적용모델 조회에 실패했습니다.'); })
      .finally(() => { if (!cancelled) setApplyLoading(false); });
    return () => { cancelled = true; };
  }, [selected]);

  const runCopy = useCallback(async () => {
    if (!selected) return;
    setCopyOpen(false);
    try {
      const response = await api.post('/jig/master/apply-models/copy', {
        fromJigLotNo: copyFrom.trim(),
        toJigCode: selected.jigCode,
        toJigLotNo: selected.jigLotNo,
        jigType: selected.jigType ?? '',
      });
      toast.success(`적용모델 ${response.data?.data?.copied ?? 0}건을 복사했습니다.`);
      setCopyFrom('');
      setSelected({ ...selected });
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : '';
      toast.error(message.includes('400') ? '복사할 원본 지그를 확인하세요.' : '적용모델 복사에 실패했습니다.');
    }
  }, [copyFrom, selected]);

  const columns = useMemo(() => jigMasterColumns, []);
  const applyColumns = useMemo(() => jigApplyModelColumns, []);

  return (
    <div className="flex h-full">
      <main className="flex min-w-0 flex-1 flex-col gap-4 p-6">
        <header className="flex items-center justify-between gap-4">
          <div>
            <h1 className="flex items-center gap-2 text-xl font-bold text-text">
              <Grip className="h-6 w-6 text-primary" />지그마스터
            </h1>
            <p className="mt-1 text-sm text-text-muted">
              지그 기준정보와 지그별 적용모델을 관리합니다 · {searched ? `${rows.length}/${total}건` : '조회조건을 선택하세요'}
            </p>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={search} disabled={loading}>
              <Search className="mr-1 h-4 w-4" />조회
            </Button>
            <Button size="sm" variant="secondary" disabled={!selected}
              onClick={() => selected && setPanel({ mode: 'edit', form: toJigForm(selected) })}>
              <Edit2 className="mr-1 h-4 w-4" />수정
            </Button>
            <Button size="sm" onClick={() => setPanel({ mode: 'create', form: emptyJigForm })}>
              <Plus className="mr-1 h-4 w-4" />등록
            </Button>
          </div>
        </header>

        <Card padding="none">
          <CardContent className="flex flex-wrap items-center gap-3 p-3">
            <Input placeholder="지그코드" value={jigCode} className="w-40"
              onChange={(e) => setJigCode(e.target.value)} />
            <Input placeholder="지그LOT" value={jigLotNo} className="w-40"
              onChange={(e) => setJigLotNo(e.target.value)} />
            <ComCodeSelect groupCode="JIG TYPE" value={jigType} onChange={setJigType} className="w-44" />
            <ComCodeSelect groupCode="JIG STATUS" value={jigStatus} onChange={setJigStatus} className="w-44" />
            <LineSelect labelPrefix="라인" value={lineCode} onChange={setLineCode} className="w-44" />
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
              exportFileName="지그마스터"
              emptyMessage="조회 버튼을 눌러 지그를 확인하세요."
              onRowClick={(row) => setSelected(row as JigMasterRow)}
              getRowId={(row) => {
                const jig = row as JigMasterRow;
                return `${jig.jigCode}|${jig.jigLotNo}`;
              }}
            />
          </CardContent>
        </Card>

        <Card padding="none" className="h-64 shrink-0 overflow-hidden">
          <CardContent className="flex h-full flex-col p-3">
            <div className="mb-2 flex items-center justify-between gap-3">
              <b className="text-sm text-text">
                적용모델{selected ? ` — ${selected.jigCode} / ${selected.jigLotNo}` : ''}
              </b>
              <div className="flex items-center gap-2">
                <Input
                  placeholder="복사 원본 지그LOT"
                  value={copyFrom}
                  disabled={!selected}
                  className="w-52"
                  onChange={(e) => setCopyFrom(e.target.value)}
                />
                <Button
                  size="sm"
                  variant="secondary"
                  disabled={!selected || !copyFrom.trim()}
                  onClick={() => setCopyOpen(true)}
                >
                  <Copy className="mr-1 h-4 w-4" />적용모델 복사
                </Button>
              </div>
            </div>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={applyModels}
                columns={applyColumns}
                isLoading={applyLoading}
                pageSize={20}
                emptyMessage={selected ? '적용모델이 없습니다.' : '지그를 선택하세요.'}
                getRowId={(row) => (row as JigApplyModelRow).itemCode}
              />
            </div>
          </CardContent>
        </Card>
      </main>

      {panel && (
        <JigMasterFormPanel
          key={`${panel.mode}-${panel.form.jigCode}-${panel.form.jigLotNo}`}
          mode={panel.mode}
          initialForm={panel.form}
          onClose={() => setPanel(null)}
          onSaved={() => { setPanel(null); void search(); }}
        />
      )}

      <ConfirmModal
        isOpen={copyOpen}
        onClose={() => setCopyOpen(false)}
        onConfirm={runCopy}
        title="적용모델 복사"
        message={selected
          ? `${copyFrom} 의 적용모델을 ${selected.jigLotNo} 로 복사합니다. 대상의 기존 적용모델은 모두 삭제됩니다.`
          : ''}
        variant="danger"
      />
    </div>
  );
}
