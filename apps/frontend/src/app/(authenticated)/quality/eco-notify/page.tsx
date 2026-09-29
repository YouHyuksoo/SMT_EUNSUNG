"use client";

/**
 * @file src/app/(authenticated)/quality/eco-notify/page.tsx
 * @description 품질알림관리 — PB w_qc_eco_notify_master 이식
 *
 * 초보자 가이드:
 * 1. **이 화면은 품목마스터(ID_ITEM)의 ECO 확인여부를 바꾼다.** 별도 알림 테이블이 아니다.
 *    PB 도 ECO_CHECK_YN / ECO_CHECK_COMMENTS 두 컬럼을 고쳤다.
 * 2. **여러 품목을 한 번에 처리한다** — PB 도 그리드에서 체크한 행을 묶어 저장했다.
 * 3. **첨부파일(ID_ITEM_IMAGE)은 이관 범위 밖이다.** PB 에서는 여기서 도면·사진을
 *    올리고 내려받을 수 있었다.
 * 4. 오늘 유효한 품목만 본다 (DATESET ~ DATEEND).
 */
import { useCallback, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { BellRing, Check, Search, Undo2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import UseYnSelect from '@/components/shared/UseYnSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { ecoNotifyColumns, type EcoNotifyRow } from '../notify-columns';

export default function EcoNotifyPage() {
  const [rows, setRows] = useState<EcoNotifyRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  const [itemCode, setItemCode] = useState('');
  const [itemName, setItemName] = useState('');
  const [modelName, setModelName] = useState('');
  const [ecoCheckYn, setEcoCheckYn] = useState('');

  const [picked, setPicked] = useState<Set<string>>(new Set());
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);
  const [confirm, setConfirm] = useState<'Y' | 'N' | null>(null);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get('/quality/notify/eco', {
        params: {
          itemCode: itemCode || undefined,
          itemName: itemName || undefined,
          modelName: modelName || undefined,
          ecoCheckYn: ecoCheckYn || undefined,
        },
      });
      setRows(response.data?.data ?? []);
      setTotal(Number(response.data?.meta?.total ?? 0));
      setSearched(true);
      setPicked(new Set());
    } catch {
      toast.error('품질알림 대상 조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [itemCode, itemName, modelName, ecoCheckYn]);

  const apply = useCallback(async (value: 'Y' | 'N') => {
    setConfirm(null);
    if (picked.size === 0) return;
    setBusy(true);
    try {
      const response = await api.put('/quality/notify/eco', {
        itemCodes: [...picked],
        ecoCheckYn: value,
        ecoCheckComments: comments || undefined,
      });
      const changed = Number(response.data?.data?.changed ?? 0);
      toast.success(`${changed}건을 ${value === 'Y' ? '확인' : '확인해제'} 처리했습니다.`);
      void search();
    } catch {
      toast.error('처리에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [picked, comments, search]);

  const toggle = useCallback((row: EcoNotifyRow) => {
    setPicked((prev) => {
      const next = new Set(prev);
      if (next.has(row.itemCode)) next.delete(row.itemCode);
      else next.add(row.itemCode);
      return next;
    });
  }, []);

  const columns = useMemo(() => ecoNotifyColumns, []);

  return (
    <main className="flex h-full min-w-0 flex-col gap-4 p-6">
      <header className="flex items-center justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-xl font-bold text-text">
            <BellRing className="h-6 w-6 text-primary" />품질알림관리
          </h1>
          <p className="mt-1 text-sm text-text-muted">
            품목별 ECO 확인여부와 설명을 관리합니다 ·{' '}
            {searched ? `${rows.length}/${total}건 · ${picked.size}건 선택` : '조회 버튼을 누르세요'}
          </p>
        </div>
        <Button size="sm" onClick={search} disabled={loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Input aria-label="품목코드" placeholder="품목코드" value={itemCode}
            className="w-44" onChange={(e) => setItemCode(e.target.value)} />
          <Input aria-label="품목명" placeholder="품목명" value={itemName}
            className="w-44" onChange={(e) => setItemName(e.target.value)} />
          <Input aria-label="모델명" placeholder="모델명" value={modelName}
            className="w-44" onChange={(e) => setModelName(e.target.value)} />
          <UseYnSelect includeAll labelPrefix="ECO 확인"
            value={ecoCheckYn} onChange={setEcoCheckYn} className="w-44" />
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-end gap-3 p-3">
          <span className="self-center text-sm text-text-muted">
            {picked.size > 0 ? `${picked.size}건 선택` : '행을 클릭해 선택하세요'}
          </span>
          <label className="text-xs text-text-muted">
            ECO 설명
            <Input value={comments} className="w-72"
              onChange={(e) => setComments(e.target.value)} />
          </label>
          <Button size="sm" disabled={picked.size === 0 || busy}
            onClick={() => setConfirm('Y')}>
            <Check className="mr-1 h-4 w-4" />확인처리
          </Button>
          <Button size="sm" variant="secondary" disabled={picked.size === 0 || busy}
            onClick={() => setConfirm('N')}>
            <Undo2 className="mr-1 h-4 w-4" />확인해제
          </Button>
          {picked.size > 0 && (
            <Button size="sm" variant="secondary" onClick={() => setPicked(new Set())}>
              선택 해제
            </Button>
          )}
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
            exportFileName="품질알림"
            emptyMessage="조회 버튼을 눌러 품목을 확인하세요."
            onRowClick={(row) => toggle(row as EcoNotifyRow)}
            rowClassName={(row) =>
              picked.has((row as EcoNotifyRow).itemCode) ? 'bg-primary/10' : ''}
            getRowId={(row) => (row as EcoNotifyRow).itemCode}
          />
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirm !== null}
        onClose={() => setConfirm(null)}
        onConfirm={() => confirm && apply(confirm)}
        title={confirm === 'Y' ? 'ECO 확인처리' : 'ECO 확인해제'}
        message={`선택한 ${picked.size}건의 ECO 확인여부를 '${confirm}' 로 바꿉니다.`
          + (comments ? ` 설명: ${comments}` : '')}
      />
    </main>
  );
}
