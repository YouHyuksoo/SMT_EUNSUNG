"use client";

/**
 * @file src/app/(authenticated)/process-transaction/magazine-label/page.tsx
 * @description 229 매거진라벨 발행 — PB w_pln_product_magazine_label_master2 이식 (쓰기 + 라벨 출력)
 *
 * 초보자 가이드:
 * 1. **작업자 ID 를 찍고 런카드 번호를 찍는다.** 매거진 라벨번호를 찍어도 그 라벨이
 *    속한 런카드를 되짚어 준다. 작업자 ID 는 원장 작성자(`ENTER_BY`)로 들어간다 —
 *    실측 작성자는 AA·KK·LL 같은 라인 작업자 ID 이고, 로그인 계정과 다르다.
 * 2. **장입수량(상자당 수량)은 작업자가 넣는다.** 모델기준정보 값이 있으면 채워 주지만
 *    대부분 모델은 비어 있다(2026-10-14 실측 327개 중 301개). 장입수량 400, 1,000개를
 *    라벨 3장으로 발행하면 400 / 400 / 200 이 나온다.
 * 3. **지시수량을 넘겨 발행할 수 없다.** 이미 발행된 수량까지 합쳐서 본다.
 * 4. **발행하면 바로 라벨을 찍는다** (PB 와 같다). 출력 방식(브라우저 인쇄 / Print Agent)은
 *    PC 마다 기억한다. 출력이 실패해도 발행은 되돌리지 않는다 — 아래 목록에서 골라 [재출력].
 * 5. **공정은 W180 이 기본이다.** PB 도 화면을 열 때 W180 을 골라 두었다(실측 원장 100% W180).
 *    바꾸면 이 브라우저가 기억한다.
 * 6. **한 번에 한 모델만 발행한다.** 실측으로 한 세트에 여러 모델이 섞인 적이 없다.
 * 7. **폐기는 되돌릴 수 없다.** 라벨이 이력표로 옮겨지고 목록에서 사라진다.
 *    이미 공정에 투입된 라벨은 폐기되지 않는다.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import { flushSync } from 'react-dom';
import toast from 'react-hot-toast';
import { AlertTriangle, Printer, ScanLine, Trash2, User } from 'lucide-react';
import { SMT_LINE_DIVISIONS } from '@smt/shared';
import DataGrid from '@/components/data-grid/DataGrid';
import ProcessSelect from '@/components/shared/ProcessSelect';
import ProdLineSelect from '@/components/shared/ProdLineSelect';
import LabelPrintMethodSelect, { useLabelPrintMethod } from '@/components/shared/LabelPrintMethodSelect';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import { printAgentPng, PrintAgentUnavailableError } from '@/services/print-agent';
import { printPngLabelsInBrowser, renderLabelNodeToPngBase64 } from '@/services/label-print';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  magazineIssuedColumns,
  magazinePlanColumns,
} from '../magazine-columns';
import type { MagazineIssuedRow, MagazinePlanRow } from '../magazine-columns';
import MagazineLabelSheet, {
  MAGAZINE_LABEL_MM,
  makeCode39Png,
  type MagazinePrintItem,
  type MagazinePrintRow,
} from './MagazineLabelSheet';

interface RunCard {
  runNo: string;
  lineCode: string | null;
  lineName: string | null;
  masterModelName: string | null;
  itemCode: string | null;
  lotSize: number | null;
  pcbItem: string | null;
  runCardWorkstageCode: string | null;
  runDate: string | null;
}

/** 고른 공정을 기억하는 자리 — PB 의 `WORKENV.INI [WORKSTAGE] WORKSTAGE_IO` 를 브라우저로 옮긴 것이다. */
const WORKSTAGE_KEY = 'mes-magazine-label-workstage';
/** PB 가 화면을 열 때 고르던 공정 (`ddlb_result_workstage_code.selectitem('W180')`). */
const DEFAULT_WORKSTAGE = 'W180';

const errorMessage = (error: unknown, fallback: string) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message
  ?? (error instanceof Error && error.message ? error.message : fallback);

export default function MagazineLabelPage() {
  const [scan, setScan] = useState('');
  const [runCard, setRunCard] = useState<RunCard | null>(null);
  const [models, setModels] = useState<MagazinePlanRow[]>([]);
  const [selected, setSelected] = useState<MagazinePlanRow | null>(null);
  const [issued, setIssued] = useState<MagazineIssuedRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState(false);
  const [status, setStatus] = useState<{ text: string; tone: 'ok' | 'error' | 'info' }>({
    text: '작업자 ID 를 찍고 런카드를 찍으세요.', tone: 'info',
  });
  const { truncated, rowLimit, mark } = useTruncation();

  // 작업자
  const [workerId, setWorkerId] = useState('');
  const [workerName, setWorkerName] = useState<string | null>(null);

  // 발행 입력
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState(DEFAULT_WORKSTAGE);
  const [okQty, setOkQty] = useState('');
  const [packingQty, setPackingQty] = useState('');
  const [printQty, setPrintQty] = useState('1');
  const [issueOpen, setIssueOpen] = useState(false);

  // 출력
  const [printMethod, setPrintMethod] = useLabelPrintMethod();
  const [printItems, setPrintItems] = useState<MagazinePrintItem[]>([]);
  const printRef = useRef<HTMLDivElement>(null);
  const [picked, setPicked] = useState<MagazineIssuedRow | null>(null);

  // 폐기 입력
  const [destroyNo, setDestroyNo] = useState('');
  const [destroyOpen, setDestroyOpen] = useState(false);

  useEffect(() => {
    try {
      const saved = window.localStorage.getItem(WORKSTAGE_KEY);
      if (saved) setWorkstageCode(saved);
    } catch { /* 저장소를 못 쓰는 브라우저면 기본 W180 */ }
  }, []);

  const changeWorkstage = useCallback((code: string) => {
    setWorkstageCode(code);
    try {
      if (code) window.localStorage.setItem(WORKSTAGE_KEY, code);
    } catch { /* 무시 */ }
  }, []);

  /** 작업자 ID 를 찍으면 이름을 찾아 보여 준다 (이름이 없는 라인 작업자 ID 도 그대로 쓴다). */
  const lookupWorker = useCallback(async () => {
    const id = workerId.trim().toUpperCase();
    setWorkerId(id);
    if (!id) { setWorkerName(null); return; }
    try {
      const r = await api.get('/process-transaction/magazine-label/worker', { params: { workerId: id } });
      setWorkerName((r.data?.data?.userName as string | null) ?? null);
    } catch {
      setWorkerName(null);
    }
  }, [workerId]);

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

  /** 모델 한 줄을 고르면 발행 입력을 그 줄로 채운다. */
  const pick = useCallback((row: MagazinePlanRow) => {
    setSelected(row);
    setOkQty(String(row.okQty));
    // 모델기준정보가 비어 있으면 서버가 1 을 준다 — 1 은 실제 상자 수량이 아니므로 비워 두고 넣게 한다.
    setPackingQty(Number(row.packingPcsQty) > 1 ? String(row.packingPcsQty) : '');
    setPrintQty(String(row.printQty || 1));
  }, []);

  const lookup = useCallback(async (value = scan.trim()) => {
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
        const reason = data?.reason ?? '런카드를 찾을 수 없습니다.';
        toast.error(reason);
        setStatus({ text: reason, tone: 'error' });
        setRunCard(null);
        setModels([]);
        setSelected(null);
        setIssued([]);
        return;
      }
      setRunCard(data.runCard);
      setScan(data.runCard.runNo);
      setLineCode(data.runCard.lineCode ?? '');
      setModels(data.models ?? []);
      const first = (data.models ?? [])[0] ?? null;
      if (first) pick(first);
      else setSelected(null);
      setPicked(null);
      await loadIssued(data.runCard.runNo);
    } catch (error: unknown) {
      const message = errorMessage(error, '조회에 실패했습니다.');
      toast.error(message);
      setStatus({ text: message, tone: 'error' });
    } finally {
      setLoading(false);
    }
  }, [scan, loadIssued, pick]);

  /**
   * 라벨을 찍는다 — 출력 값을 받아 라벨을 그리고 PNG 로 바꿔 고른 방식으로 보낸다.
   * 실패하면 사람이 읽을 메시지로 예외를 던진다.
   */
  const printLabels = useCallback(async (labelNos: string[]) => {
    const r = await api.post('/process-transaction/magazine-label/print-data', {
      magazineLabelNos: labelNos,
    });
    const rows = (r.data?.data ?? []) as MagazinePrintRow[];
    if (rows.length === 0) throw new Error('출력할 라벨을 찾지 못했습니다.');
    const items = await Promise.all(rows.map(async (row) => ({
      row,
      barcodeSrc: await makeCode39Png(row.magazineLabelNo),
    })));
    flushSync(() => setPrintItems(items));
    try {
      const nodes = Array.from(printRef.current?.children ?? [])
        .filter((node): node is HTMLElement => node instanceof HTMLElement);
      if (nodes.length !== items.length) throw new Error('라벨 출력 화면을 준비하지 못했습니다.');
      const { width, height } = MAGAZINE_LABEL_MM;
      const pngs: string[] = [];
      for (const node of nodes) pngs.push(await renderLabelNodeToPngBase64(node, width, height));
      if (printMethod === 'BROWSER') {
        await printPngLabelsInBrowser('매거진 라벨', pngs, width, height);
        return;
      }
      for (let i = 0; i < pngs.length; i += 1) {
        await printAgentPng({
          jobId: `MAG-${items[i].row.magazineLabelNo}`,
          widthMm: width,
          heightMm: height,
          copies: 1,
          contentBase64: pngs[i],
        });
      }
    } catch (error: unknown) {
      if (error instanceof PrintAgentUnavailableError) {
        throw new Error('라벨 프린트 에이전트에 연결할 수 없습니다. 출력 방식을 \'브라우저 인쇄\'로 바꾸면 에이전트 없이 찍을 수 있습니다.');
      }
      throw error;
    } finally {
      setPrintItems([]);
    }
  }, [printMethod]);

  const qty = Number(okQty);
  const sheets = Number(printQty);
  const packing = Number(packingQty);

  /** 서버와 같은 규칙으로 미리 보여 준다 — 보여준 장수와 들어가는 장수가 같아야 한다. */
  const preview = (() => {
    if (!selected || !Number.isFinite(qty) || qty <= 0 || !Number.isFinite(packing) || packing <= 0) return [];
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

  const blocker = !workerId.trim()
    ? '작업자 ID 를 찍으세요.'
    : !runCard
      ? '런카드를 먼저 찍으세요.'
      : !lineCode
        ? '라인을 고르세요.'
        : !workstageCode
          ? '공정을 고르세요.'
          : !selected
            ? '발행할 모델을 고르세요.'
            : !(Number.isFinite(packing) && Number.isInteger(packing) && packing > 0)
              ? '장입수량(상자당 수량)을 넣으세요.'
              : !(Number.isFinite(qty) && qty > 0)
                ? '발행 수량을 1 이상으로 넣으세요.'
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
    let labelNos: string[] = [];
    try {
      const r = await api.post('/process-transaction/magazine-label', {
        runNo: runCard.runNo,
        modelName: selected.modelName,
        okQty: qty,
        printQty: sheets,
        packingPcsQty: packing,
        workstageCode,
        lineCode,
        workerId: workerId.trim().toUpperCase(),
      });
      const result = r.data?.data as {
        issued?: { magazineLabelNo: string; qty: number }[];
        labelCount?: number;
        totalQty?: number;
      };
      labelNos = (result?.issued ?? []).map((l) => l.magazineLabelNo);
      setStatus({
        text: `발행 ${result?.labelCount ?? 0}장 (${(result?.totalQty ?? 0).toLocaleString()}개): ${labelNos.join(', ')}`,
        tone: 'ok',
      });
    } catch (error: unknown) {
      const message = errorMessage(error, '발행에 실패했습니다.');
      toast.error(message);
      setStatus({ text: message, tone: 'error' });
      setBusy(false);
      return;
    }
    try {
      await printLabels(labelNos);
      toast.success(`라벨 ${labelNos.length}장을 발행하고 출력했습니다.`);
    } catch (error: unknown) {
      // 발행은 이미 됐다 — 되돌리지 않고 재출력하게 한다.
      const message = `발행은 됐지만 출력하지 못했습니다: ${errorMessage(error, '출력 실패')} — 목록에서 골라 [재출력] 하세요.`;
      toast.error(message, { duration: 8000 });
      setStatus({ text: message, tone: 'error' });
    } finally {
      await lookup(runCard.runNo);
      setBusy(false);
    }
  }, [runCard, selected, qty, sheets, packing, workstageCode, lineCode, workerId, lookup, printLabels]);

  const reprint = useCallback(async () => {
    if (!picked) return;
    setBusy(true);
    try {
      await printLabels([picked.magazineLabelNo]);
      setStatus({ text: `재출력: ${picked.magazineLabelNo}`, tone: 'ok' });
    } catch (error: unknown) {
      const message = errorMessage(error, '재출력에 실패했습니다.');
      toast.error(message);
      setStatus({ text: message, tone: 'error' });
    } finally {
      setBusy(false);
    }
  }, [picked, printLabels]);

  const destroy = useCallback(async () => {
    setDestroyOpen(false);
    setBusy(true);
    const no = destroyNo.trim();
    try {
      await api.post('/process-transaction/magazine-label/destroy', {
        magazineLabelNo: no,
      });
      toast.success(`폐기했습니다: ${no}`);
      setStatus({ text: `폐기: ${no}`, tone: 'ok' });
      setDestroyNo('');
      setPicked(null);
      if (runCard) await lookup(runCard.runNo);
    } catch (error: unknown) {
      const message = errorMessage(error, '폐기에 실패했습니다.');
      toast.error(message);
      setStatus({ text: message, tone: 'error' });
    } finally {
      setBusy(false);
    }
  }, [destroyNo, runCard, lookup]);

  const statusTone = status.tone === 'error'
    ? 'bg-red-600 text-white'
    : status.tone === 'ok'
      ? 'bg-emerald-600 text-white'
      : 'bg-surface text-text border border-border';

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header className="flex flex-wrap items-end justify-between gap-3">
        <div>
          <h1 className="text-xl font-bold text-text">매거진라벨 발행</h1>
          <p className="mt-1 text-sm text-text-muted">
            작업자·런카드를 찍고 상자 단위로 라벨을 발행·출력합니다.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Printer className="h-4 w-4 text-text-muted" />
          <LabelPrintMethodSelect className="w-44" value={printMethod} onChange={setPrintMethod} />
        </div>
      </header>

      {/* 상태 메시지 — PB st_status 처럼 마지막 결과를 크게 보여 준다 */}
      <div role="status" className={`rounded-lg px-4 py-3 text-lg font-bold break-all ${statusTone}`}>
        {status.text}
      </div>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <span className="flex items-center gap-1 text-sm font-semibold text-text">
            <User className="h-4 w-4" />작업자
          </span>
          <Input aria-label="작업자 ID" placeholder="작업자 ID" value={workerId} className="w-36"
            autoFocus
            onChange={(e) => setWorkerId(e.target.value.toUpperCase())}
            onBlur={() => void lookupWorker()}
            onKeyDown={(e) => { if (e.key === 'Enter') void lookupWorker(); }} />
          <span className="w-24 truncate text-sm text-text-muted">{workerName ?? ''}</span>

          <span className="ml-2 flex items-center gap-1 text-sm font-semibold text-text">
            <ScanLine className="h-4 w-4" />런카드 / 매거진라벨
          </span>
          <Input aria-label="런카드번호" placeholder="런카드번호 또는 매거진라벨번호"
            value={scan} className="w-64"
            onChange={(e) => setScan(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') void lookup(); }} />
          <Button size="sm" onClick={() => void lookup()} disabled={loading}>조회</Button>
          {runCard && (
            <span className="text-sm text-text-muted">
              {runCard.masterModelName} · 지시 {Number(runCard.lotSize ?? 0).toLocaleString()}
              {runCard.pcbItem ? ` · PCB ${runCard.pcbItem}` : ''}
              {runCard.runDate ? ` · ${runCard.runDate}` : ''}
            </span>
          )}
        </CardContent>
      </Card>

      {/* 발행 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <ProdLineSelect aria-label="라인" value={lineCode} className="w-48"
            includeDivisions={SMT_LINE_DIVISIONS} placeholder="라인" onChange={setLineCode} />
          <ProcessSelect aria-label="공정" value={workstageCode} className="w-44"
            onChange={changeWorkstage} />
          <span className="text-sm font-semibold text-text">
            {selected ? selected.modelName : '모델을 고르세요'}
          </span>
          <label className="flex items-center gap-1 text-sm text-text-muted">
            장입
            <Input aria-label="장입수량" placeholder="상자당 수량" value={packingQty}
              className="w-28" inputMode="numeric"
              onChange={(e) => setPackingQty(e.target.value.replace(/\D/g, ''))} />
          </label>
          <label className="flex items-center gap-1 text-sm text-text-muted">
            수량
            <Input aria-label="발행 수량" placeholder="발행 수량" value={okQty}
              className="w-28" inputMode="numeric"
              onChange={(e) => setOkQty(e.target.value.replace(/\D/g, ''))} />
          </label>
          <label className="flex items-center gap-1 text-sm text-text-muted">
            장수
            <Input aria-label="라벨 장수" placeholder="라벨 장수" value={printQty}
              className="w-20" inputMode="numeric"
              onChange={(e) => setPrintQty(e.target.value.replace(/\D/g, ''))} />
          </label>
          {preview.length > 0 && (
            <span className="text-sm text-text-muted">
              라벨 {preview.length}장 ={' '}
              <span className="font-semibold text-text">{preview.join(' + ')}</span>
            </span>
          )}
          <Button size="sm" disabled={busy || Boolean(blocker)}
            onClick={() => setIssueOpen(true)}>
            <Printer className="mr-1 h-4 w-4" />발행·출력
          </Button>
          {blocker && (
            <span className="flex items-center gap-1 text-sm text-amber-500">
              <AlertTriangle className="h-4 w-4" />{blocker}
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <div className="grid min-h-0 flex-1 gap-3 lg:grid-cols-[minmax(0,1fr)_minmax(0,1.4fr)]">
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
            <div className="flex flex-wrap items-center gap-2">
              <span className="text-sm font-semibold text-text">
                발행된 라벨 {issued.length.toLocaleString()}장
              </span>
              <Button size="sm" variant="secondary" disabled={busy || !picked}
                onClick={() => void reprint()}>
                <Printer className="mr-1 h-4 w-4" />재출력{picked ? ` ${picked.magazineLabelNo}` : ''}
              </Button>
              <span className="ml-auto flex items-center gap-2">
                <Trash2 className="h-4 w-4 text-text-muted" />
                <Input aria-label="폐기할 매거진라벨" placeholder="폐기할 매거진라벨번호"
                  value={destroyNo} className="w-52"
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
                onRowClick={(row) => {
                  const r = row as MagazineIssuedRow;
                  setPicked(r);
                  setDestroyNo(r.magazineLabelNo);
                }}
                rowClassName={(row) => ((row as MagazineIssuedRow).magazineLabelNo === picked?.magazineLabelNo
                  ? 'bg-primary/10'
                  : '')}
              />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* 출력용 라벨 — 화면 밖에 그려 PNG 로 바꾼 뒤 지운다 */}
      <div ref={printRef} aria-hidden="true"
        style={{ position: 'fixed', left: -10000, top: 0, pointerEvents: 'none' }}>
        {printItems.map((item) => (
          <MagazineLabelSheet key={item.row.magazineLabelNo} item={item} />
        ))}
      </div>

      <ConfirmModal
        isOpen={issueOpen}
        onClose={() => setIssueOpen(false)}
        onConfirm={issue}
        title="매거진라벨 발행"
        message={`${selected?.modelName ?? ''} 를 라벨 ${preview.length}장`
          + ` (${preview.join(' + ')}) 으로 발행하고 출력합니다.`
          + ` 작업자 ${workerId.trim().toUpperCase()} · 라인 ${lineCode} · 공정 ${workstageCode}.`}
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
