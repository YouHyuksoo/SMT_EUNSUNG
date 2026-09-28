"use client";

/**
 * @file src/app/(authenticated)/process-transaction/magazine-label/page.tsx
 * @description 229 매거진라벨 발행 — PB w_pln_product_magazine_label_master2 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **런카드 번호를 찍는 것으로 시작한다.** 매거진 라벨번호를 찍어도 그 라벨이
 *    속한 런카드를 되짚어 준다 — 현장은 둘 다 찍기 때문이다.
 * 2. **상자 단위로 라벨을 만든다.** 장입수량이 400이고 1,000개를 발행하면
 *    400 / 400 / 200 세 장이 나온다. 마지막 상자는 남은 만큼만 담는다.
 * 3. **지시수량을 넘겨 발행할 수 없다.** 이미 발행된 수량까지 합쳐서 본다.
 * 4. **라벨 인쇄는 포함하지 않았다.** 원장(라벨 행)만 만들고 발행된 라벨번호를
 *    돌려준다 — 라벨 프린터 연동은 장비 결정이 필요해 뒤로 미뤘다.
 * 5. **폐기는 되돌릴 수 없다.** 라벨이 이력표로 옮겨지고 목록에서 사라진다.
 *    이미 공정에 투입된 라벨은 폐기되지 않는다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, Printer, ScanLine, Trash2 } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  magazineIssuedColumns,
  magazinePlanColumns,
} from '../magazine-columns';
import type { MagazineIssuedRow, MagazinePlanRow } from '../magazine-columns';

interface RunCard {
  runNo: string;
  lineCode: string | null;
  lineName: string | null;
  masterModelName: string | null;
  itemCode: string | null;
  lotSize: number | null;
  pcbItem: string | null;
  workstageCode: string | null;
  runDate: string | null;
}

export default function MagazineLabelPage() {
  const [scan, setScan] = useState('');
  const [runCard, setRunCard] = useState<RunCard | null>(null);
  const [models, setModels] = useState<MagazinePlanRow[]>([]);
  const [selected, setSelected] = useState<MagazinePlanRow | null>(null);
  const [issued, setIssued] = useState<MagazineIssuedRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 발행 입력
  const [okQty, setOkQty] = useState('');
  const [printQty, setPrintQty] = useState('1');
  const [issueOpen, setIssueOpen] = useState(false);

  // 폐기 입력
  const [destroyNo, setDestroyNo] = useState('');
  const [destroyOpen, setDestroyOpen] = useState(false);

  const loadIssued = useCallback(async (runNo: string) => {
    try {
      const r = await api.get('/process-transaction/magazine-label/issued', {
        params: { runNo },
      });
      setIssued(r.data?.data ?? []);
      mark(r);
    } catch {
      setIssued([]);
    }
  }, [mark]);

  const lookup = useCallback(async () => {
    const value = scan.trim();
    if (!value) return;
    setLoading(true);
    try {
      const r = await api.post('/process-transaction/magazine-label/lookup', {
        scan: value,
      });
      const data = r.data?.data as {
        runCard: RunCard | null;
        models: MagazinePlanRow[];
        reason: string | null;
      };
      if (!data?.runCard) {
        toast.error(data?.reason ?? '런카드를 찾을 수 없습니다.');
        setRunCard(null);
        setModels([]);
        setSelected(null);
        setIssued([]);
        return;
      }
      setRunCard(data.runCard);
      setModels(data.models ?? []);
      const first = (data.models ?? [])[0] ?? null;
      setSelected(first);
      setOkQty(first ? String(first.okQty) : '');
      setPrintQty(first ? String(first.printQty || 1) : '1');
      await loadIssued(data.runCard.runNo);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [scan, loadIssued]);

  /** 모델 한 줄을 고르면 발행 입력을 그 줄로 채운다. */
  const pick = useCallback((row: MagazinePlanRow) => {
    setSelected(row);
    setOkQty(String(row.okQty));
    setPrintQty(String(row.printQty || 1));
  }, []);

  const qty = Number(okQty);
  const sheets = Number(printQty);
  const packing = Number(selected?.packingPcsQty ?? 0);

  /** 서버와 같은 규칙으로 미리 보여 준다 — 보여준 장수와 들어가는 장수가 같아야 한다. */
  const preview = (() => {
    if (!selected || !Number.isFinite(qty) || qty <= 0 || packing <= 0) return [];
    const out: number[] = [];
    let remain = qty;
    let left = Number.isFinite(sheets) ? sheets : 0;
    while (left > 0 && remain > 0) {
      const piece = remain < packing ? remain : packing;
      out.push(piece);
      remain -= piece;
      left -= 1;
    }
    return out;
  })();

  const blocker = !runCard
    ? '런카드를 먼저 찍으세요.'
    : !selected
      ? '발행할 모델을 고르세요.'
      : !(Number.isFinite(qty) && qty > 0)
        ? '발행 수량을 1 이상으로 넣으세요.'
        : packing <= 0
          ? '장입수량이 0 입니다. 모델기준정보를 확인하세요.'
          : !(Number.isFinite(sheets) && sheets > 0)
            ? '라벨 장수를 1 이상으로 넣으세요.'
            : Number(selected.magazineQty ?? 0) + qty > Number(runCard.lotSize ?? 0)
              ? `지시수량을 넘습니다 (이미 ${selected.magazineQty} + ${qty}`
                + ` > 지시 ${runCard.lotSize}).`
              : null;

  const issue = useCallback(async () => {
    setIssueOpen(false);
    if (!runCard || !selected) return;
    setBusy(true);
    try {
      const r = await api.post('/process-transaction/magazine-label', {
        runNo: runCard.runNo,
        modelName: selected.modelName,
        okQty: qty,
        printQty: sheets,
        packingPcsQty: packing,
      });
      const result = r.data?.data as {
        issued?: { magazineLabelNo: string; qty: number }[];
        labelCount?: number;
        totalQty?: number;
      };
      toast.success(
        `라벨 ${result?.labelCount ?? 0}장 발행 (${result?.totalQty ?? 0}개):`
        + ` ${(result?.issued ?? []).map((l) => l.magazineLabelNo).join(', ')}`,
      );
      await lookup();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '발행에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [runCard, selected, qty, sheets, packing, lookup]);

  const destroy = useCallback(async () => {
    setDestroyOpen(false);
    setBusy(true);
    try {
      await api.post('/process-transaction/magazine-label/destroy', {
        magazineLabelNo: destroyNo.trim(),
      });
      toast.success(`폐기했습니다: ${destroyNo.trim()}`);
      setDestroyNo('');
      if (runCard) await loadIssued(runCard.runNo);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '폐기에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [destroyNo, runCard, loadIssued]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">매거진라벨 발행</h1>
        <p className="mt-1 text-sm text-text-muted">
          런카드를 찍고 상자 단위로 라벨을 발행합니다 ·{' '}
          {runCard
            ? `${runCard.runNo} · 지시 ${Number(runCard.lotSize ?? 0).toLocaleString()}`
            : '런카드를 찍으세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />런카드 / 매거진라벨
          </span>
          <Input aria-label="런카드번호" placeholder="런카드번호 또는 매거진라벨번호"
            value={scan} className="w-72" autoFocus
            onChange={(e) => setScan(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void lookup(); }} />
          <Button size="sm" onClick={lookup} disabled={loading}>조회</Button>
          {runCard && (
            <span className="text-sm text-text-muted">
              {runCard.lineName ?? runCard.lineCode} · {runCard.masterModelName}
              {runCard.pcbItem ? ` · PCB ${runCard.pcbItem}` : ''}
              {runCard.runDate ? ` · ${runCard.runDate}` : ''}
            </span>
          )}
        </CardContent>
      </Card>

      {/* 발행 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <Printer className="h-4 w-4" />라벨 발행
          </span>
          <span className="text-sm text-text-muted">
            {selected ? `${selected.modelName} · 장입 ${packing}` : '모델을 고르세요'}
          </span>
          <Input aria-label="발행 수량" placeholder="발행 수량" value={okQty}
            className="w-32" inputMode="numeric"
            onChange={(e) => setOkQty(e.target.value)} />
          <Input aria-label="라벨 장수" placeholder="라벨 장수" value={printQty}
            className="w-28" inputMode="numeric"
            onChange={(e) => setPrintQty(e.target.value)} />
          {preview.length > 0 && (
            <span className="text-sm text-text-muted">
              라벨 {preview.length}장 ={' '}
              <span className="font-semibold text-text">{preview.join(' + ')}</span>
            </span>
          )}
          <Button size="sm" disabled={busy || Boolean(blocker)}
            onClick={() => setIssueOpen(true)}>
            발행
          </Button>
          {blocker && runCard && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <p className="text-sm text-text-muted">
        라벨 인쇄는 포함하지 않았습니다 — 발행된 라벨번호를 알려 드리므로 인쇄는
        프린터를 정한 뒤에 붙입니다. 수리·불량·폐기 라벨 발행은 6년간 쓰인 적이 없어
        옮기지 않았습니다.
      </p>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-4 lg:grid-rows-[1fr_1.2fr]">
        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="h-full p-3">
            <DataGrid
              data={models}
              columns={magazinePlanColumns}
              isLoading={loading}
              pageSize={20}
              emptyMessage={runCard
                ? '이 런카드에 붙은 모델이 없습니다.'
                : '런카드를 찍으세요.'}
              onRowClick={(row) => pick(row as MagazinePlanRow)}
              rowClassName={(row) => ((row as MagazinePlanRow).modelName === selected?.modelName
                ? 'bg-primary/10'
                : '')}
            />
          </CardContent>
        </Card>

        <Card className="min-h-0 overflow-hidden" padding="none">
          <CardContent className="flex h-full flex-col gap-2 p-3">
            <div className="flex flex-wrap items-center gap-3">
              <span className="text-sm font-semibold text-text">
                발행된 라벨 {issued.length.toLocaleString()}장
              </span>
              <span className="ml-auto flex items-center gap-2">
                <Trash2 className="h-4 w-4 text-text-muted" />
                <Input aria-label="폐기할 매거진라벨" placeholder="폐기할 매거진라벨번호"
                  value={destroyNo} className="w-56"
                  onChange={(e) => setDestroyNo(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter' && destroyNo.trim()) setDestroyOpen(true);
                  }} />
                <Button size="sm" variant="danger"
                  disabled={busy || !destroyNo.trim()}
                  onClick={() => setDestroyOpen(true)}>
                  폐기
                </Button>
              </span>
            </div>
            <div className="min-h-0 flex-1">
              <DataGrid
                data={issued}
                columns={magazineIssuedColumns}
                pageSize={100}
                enableColumnFilter
                enableExport
                exportFileName="매거진라벨발행"
                enableColumnPinning
                defaultPinnedColumns={{ left: ['magazineLabelNo'] }}
                emptyMessage={runCard
                  ? '아직 발행된 라벨이 없습니다.'
                  : '런카드를 찍으세요.'}
                onRowClick={(row) => setDestroyNo(
                  (row as MagazineIssuedRow).magazineLabelNo,
                )}
              />
            </div>
          </CardContent>
        </Card>
      </div>

      <ConfirmModal
        isOpen={issueOpen}
        onClose={() => setIssueOpen(false)}
        onConfirm={issue}
        title="매거진라벨 발행"
        message={`${selected?.modelName ?? ''} 를 라벨 ${preview.length}장`
          + ` (${preview.join(' + ')}) 으로 발행합니다.`
          + ' 발행된 라벨은 공정 투입 기록의 시작점이 됩니다.'}
        confirmText="발행"
      />

      <ConfirmModal
        isOpen={destroyOpen}
        onClose={() => setDestroyOpen(false)}
        onConfirm={destroy}
        title="매거진라벨 폐기"
        message={`${destroyNo.trim()} 를 폐기합니다.`
          + ' 라벨이 이력표로 옮겨지고 목록에서 사라집니다. 되돌릴 수 없습니다.'}
        confirmText="폐기"
      />
    </div>
  );
}
