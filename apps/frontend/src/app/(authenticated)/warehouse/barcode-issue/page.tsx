"use client";

/**
 * @file src/app/(authenticated)/warehouse/barcode-issue/page.tsx
 * @description 자재바코드출고관리 — PB w_mat_other_issue_barcode_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **자재를 라인으로 내보내는 화면이다.** 릴 바코드를 찍으면 그 릴이 "라인으로
 *    나갔다"로 표시되고 출고 원장에 한 건이 들어간다. 자재창고에서 가장 많이 쓰는
 *    화면이다.
 * 2. **찍으면 먼저 검사 결과를 보여준다.** 통과·거절·경고·끔이 목록으로 나오고,
 *    **첫 거절 사유**가 버튼 위에 크게 뜬다. 출고는 '출고' 를 눌러야 된다 —
 *    PB 는 찍는 순간 출고까지 해버려서 잘못 찍으면 되돌릴 수 없었다.
 * 3. **FIFO(선입선출)에 걸리면 먼저 써야 할 릴 목록이 아래에 나온다.** 그 릴을
 *    찾아 쓰면 된다. PB 에는 비밀번호로 FIFO 를 뚫는 장치가 있었지만 옮기지 않았다.
 * 4. **검사 몇 가지는 끌 수 있다.** 기본값은 PB 와 같다 (FIFO·MSL·PCB 코팅 ON).
 *    끄면 검사 목록에 '끔' 으로 남아 무엇을 건너뛰었는지 보인다.
 * 5. **라인·공정은 반드시 골라야 한다.** 비우면 어디로 나갔는지 모르는 출고가 생긴다.
 * 6. **키팅 BOM 탭**에서 모델에 들어가는 자재와 대체품을 볼 수 있다.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, CheckCircle2, MinusCircle, ScanLine, Search, XCircle } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import { useRunAfterRender } from '@/hooks/useRunAfterRender';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import {
  barcodeIssueColumns,
  fifoCandidateColumns,
  issueWaitingColumns,
  kittingBomColumns,
} from '../barcode-issue-columns';
import type {
  BarcodeIssueRow,
  BarcodeIssueScanResult,
  FifoCandidateRow,
  IssueWaitingRow,
  KittingBomRow,
  ScanCheck,
} from '../barcode-issue-columns';
import PartSearchField from '@/components/shared/PartSearchField';
import ProcessSelect from '@/components/shared/ProcessSelect';

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

type TabKey = 'issues' | 'waiting' | 'bom';

const TAB_LABELS: Record<TabKey, string> = {
  issues: '출고 이력',
  waiting: '출고 대기',
  bom: '키팅 BOM',
};

/** 검사 결과 한 줄의 아이콘·색. */
const CHECK_STYLE: Record<ScanCheck['result'], { icon: typeof CheckCircle2; cls: string }> = {
  pass: { icon: CheckCircle2, cls: 'text-emerald-500' },
  reject: { icon: XCircle, cls: 'text-red-500 font-semibold' },
  warn: { icon: AlertTriangle, cls: 'text-amber-500' },
  skip: { icon: MinusCircle, cls: 'text-text-muted' },
};

export default function BarcodeIssuePage() {
  const [tab, setTab] = useState<TabKey>('issues');

  // 조회
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [bomModelName, setBomModelName] = useState('');

  const [issues, setIssues] = useState<BarcodeIssueRow[]>([]);
  const [waiting, setWaiting] = useState<IssueWaitingRow[]>([]);
  const [bom, setBom] = useState<KittingBomRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // 스캔·출고 (쓰기)
  const [barcode, setBarcode] = useState('');
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [feederLocationCode, setFeederLocationCode] = useState('');
  const [kitting, setKitting] = useState(true);
  const [checkFifo, setCheckFifo] = useState(true);
  const [checkMslTime, setCheckMslTime] = useState(true);
  const [checkPcbCoating, setCheckPcbCoating] = useState(true);
  const [checkLongTerm, setCheckLongTerm] = useState(false);
  const [checkLifeCycle, setCheckLifeCycle] = useState(false);
  const [scan, setScan] = useState<BarcodeIssueScanResult | null>(null);
  const [fifoRows, setFifoRows] = useState<FifoCandidateRow[]>([]);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      if (tab === 'issues') {
        const r = await api.get('/warehouse/barcode-issue', {
          params: {
            dateFrom, dateTo,
            itemCode: itemCode || undefined,
            lotNo: lotNo || undefined,
            lineCode: lineCode || undefined,
          },
        });
        setIssues(r.data?.data ?? []);
        mark(r);
      } else if (tab === 'waiting') {
        const r = await api.get('/warehouse/barcode-issue/waiting', {
          params: { itemCode: itemCode || undefined, lotNo: lotNo || undefined },
        });
        setWaiting(r.data?.data ?? []);
        mark(r);
      } else {
        if (!bomModelName.trim()) { setBom([]); setSearched(true); return; }
        const r = await api.get('/warehouse/barcode-issue/kitting-bom', {
          params: { modelName: bomModelName.trim(), lineCode: lineCode || undefined },
        });
        setBom(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, dateFrom, dateTo, itemCode, lotNo, lineCode, bomModelName, mark]);

  useEffect(() => { void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  /** 찍은 바코드를 판정한다 (읽기 전용). 출고는 하지 않는다. */
  const runScan = useCallback(async () => {
    const value = barcode.trim();
    if (!value) return;
    setBusy(true);
    setFifoRows([]);
    try {
      const r = await api.post('/warehouse/barcode-issue/scan', {
        barcode: value,
        lineCode,
        workstageCode: workstageCode.trim(),
        checkFifo, checkMslTime, checkPcbCoating,
        checkLongTermInventory: checkLongTerm,
        checkLifeCycle,
      });
      const result = r.data?.data as BarcodeIssueScanResult | undefined;
      setScan(result ?? null);
      // FIFO 에 걸렸으면 먼저 써야 할 릴을 바로 보여준다.
      if (result && Number(result.fifoCount ?? 0) > 0 && result.itemCode && result.lotNo) {
        const f = await api.get('/warehouse/barcode-issue/fifo', {
          params: {
            itemCode: result.itemCode,
            lotNo: result.lotNo,
            inventoryType: result.barcodeRow?.inventoryType ?? undefined,
          },
        });
        setFifoRows(f.data?.data ?? []);
      }
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '바코드를 판정하지 못했습니다.');
      setScan(null);
    } finally {
      setBusy(false);
    }
  }, [barcode, lineCode, workstageCode, checkFifo, checkMslTime, checkPcbCoating,
    checkLongTerm, checkLifeCycle]);

  /** 출고대조 + 출고 기록 (쓰기). */
  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-issue', {
        barcode: barcode.trim(),
        lineCode,
        workstageCode: workstageCode.trim(),
        modelName: modelName.trim() || undefined,
        feederLocationCode: feederLocationCode.trim() || undefined,
        kitting,
        checkFifo, checkMslTime, checkPcbCoating,
        checkLongTermInventory: checkLongTerm,
        checkLifeCycle,
      });
      const result = r.data?.data as
        { itemCode?: string; issueQty?: number; warnings?: ScanCheck[] } | undefined;
      toast.success(
        `출고했습니다: ${result?.itemCode}`
        + ` ${Number(result?.issueQty ?? 0).toLocaleString()}개`,
      );
      (result?.warnings ?? []).forEach((w) => {
        toast(`${w.label}: ${w.detail ?? ''}`, { icon: '⚠️' });
      });
      setBarcode('');
      setScan(null);
      setFifoRows([]);
      void search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '출고에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, lineCode, workstageCode, modelName, feederLocationCode, kitting,
    checkFifo, checkMslTime, checkPcbCoating, checkLongTerm, checkLifeCycle, search]);

  const blocker = !lineCode
    ? '라인을 고르세요.'
    : !workstageCode.trim()
      ? '공정을 넣으세요.'
      : !barcode.trim()
        ? '바코드를 찍으세요.'
        : !scan
          ? '바코드를 먼저 판정하세요 (Enter).'
          : !scan.issuable
            ? scan.reason
            : null;

  const counts: Record<TabKey, number> = {
    issues: issues.length, waiting: waiting.length, bom: bom.length,
  };

  // 모델을 고르면 새 모델명으로 바로 조회한다 (Enter 조회를 대신함)
  const searchAfterModelSelect = useRunAfterRender(search);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재바코드출고관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          릴 바코드를 찍어 라인으로 내보냅니다 ·{' '}
          {searched ? `${TAB_LABELS[tab]} ${counts[tab].toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      {/* 스캔·출고 (쓰기) */}
      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-end gap-3">
            <span className="flex items-center gap-1 pb-2 text-sm font-semibold text-text">
              <ScanLine className="h-4 w-4" />출고 스캔
            </span>
            <div className="w-40">
              <LineSelect value={lineCode} onChange={setLineCode} labelPrefix="라인" />
            </div>
            <ProcessSelect labelPrefix="공정" value={workstageCode} onChange={setWorkstageCode} className="w-44" />
            <ModelSearchField value={modelName} onChange={setModelName} className="w-44" />
            <Input aria-label="피더 위치" placeholder="피더 위치" value={feederLocationCode}
              className="w-32"
              onChange={(e) => setFeederLocationCode(e.target.value)} />
            <Input aria-label="자재 바코드" placeholder="자재 바코드 → Enter"
              value={barcode} className="w-64"
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void runScan(); }} />
            <Button size="sm" variant="secondary" disabled={busy || !barcode.trim()}
              onClick={runScan}>
              판정
            </Button>
            <Button size="sm" disabled={busy || Boolean(blocker)}
              onClick={() => setConfirmOpen(true)}>
              출고
            </Button>
          </div>

          <div className="flex flex-wrap items-center gap-4 text-sm text-text">
            <label className="flex items-center gap-2">
              <input type="checkbox" checked={kitting}
                onChange={(e) => setKitting(e.target.checked)} />
              키팅 출고
            </label>
            <span className="text-text-muted">검사:</span>
            <label className="flex items-center gap-2">
              <input type="checkbox" checked={checkFifo}
                onChange={(e) => setCheckFifo(e.target.checked)} />
              FIFO
            </label>
            <label className="flex items-center gap-2">
              <input type="checkbox" checked={checkMslTime}
                onChange={(e) => setCheckMslTime(e.target.checked)} />
              MSL 시간
            </label>
            <label className="flex items-center gap-2">
              <input type="checkbox" checked={checkPcbCoating}
                onChange={(e) => setCheckPcbCoating(e.target.checked)} />
              PCB 코팅
            </label>
            <label className="flex items-center gap-2">
              <input type="checkbox" checked={checkLongTerm}
                onChange={(e) => setCheckLongTerm(e.target.checked)} />
              장기재고
            </label>
            <label className="flex items-center gap-2">
              <input type="checkbox" checked={checkLifeCycle}
                onChange={(e) => setCheckLifeCycle(e.target.checked)} />
              수명주기
            </label>
          </div>

          {/* 판정 결과 — 순서 그대로 보여준다 (서버가 준 순서가 PB 순서다). */}
          {scan && (
            <div className="rounded border border-border bg-surface-muted p-3 text-sm">
              <div className="mb-2 flex flex-wrap gap-x-6 gap-y-1">
                <span>품목 <b>{scan.itemCode ?? '-'}</b>
                  {scan.item?.itemName ? ` (${scan.item.itemName})` : ''}</span>
                <span>롯트 <b>{scan.lotNo ?? '-'}</b></span>
                <span>수량 <b>
                  {Number(scan.barcodeRow?.issueQty ?? 0).toLocaleString()}</b></span>
                <span>전표 {scan.barcodeRow?.receiptSlipNo ?? '없음'}</span>
                {scan.item?.mslLevel && <span>MSL {scan.item.mslLevel}</span>}
              </div>
              <div className="grid gap-1 md:grid-cols-2 lg:grid-cols-3">
                {scan.checks.map((c) => {
                  const S = CHECK_STYLE[c.result];
                  const Icon = S.icon;
                  return (
                    <div key={c.key} className={`flex items-start gap-1 ${S.cls}`}>
                      <Icon className="mt-0.5 h-4 w-4 shrink-0" />
                      <span>{c.label}{c.detail ? ` — ${c.detail}` : ''}</span>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {blocker && (barcode || lineCode) && (
            <p className="flex items-start gap-1 text-sm text-amber-500">
              <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />{blocker}
            </p>
          )}

          {/* FIFO 에 걸렸으면 먼저 써야 할 릴을 바로 보여준다. */}
          {fifoRows.length > 0 && (
            <div>
              <p className="mb-1 text-sm font-semibold text-red-500">
                먼저 써야 할 릴 {fifoRows.length}건 — 이 릴을 찾아 쓰세요.
              </p>
              <div className="max-h-56 overflow-auto">
                <DataGrid
                  data={fifoRows}
                  columns={fifoCandidateColumns}
                  pageSize={20}
                  enableExport
                  exportFileName="FIFO_먼저써야할릴"
                  emptyMessage="없습니다."
                />
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      <ScreenTabs
        tabs={(Object.keys(TAB_LABELS) as TabKey[]).map((k) => ({
          key: k, label: TAB_LABELS[k], count: counts[k],
        }))}
        active={tab}
        onChange={setTab}
      />

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          {tab === 'issues' && (
            <DateRangeFilter label="출고일" from={dateFrom} to={dateTo}
              onFromChange={setDateFrom} onToChange={setDateTo} />
          )}
          {tab === 'bom' ? (
            <ModelSearchField aria-label="BOM 모델명" placeholder="모델명" value={bomModelName}
              className="w-56"
              onChange={(v) => { setBomModelName(v); if (v) searchAfterModelSelect(); }} />
          ) : (
            <>
              <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode}
                className="w-44"
                onChange={(e) => setItemCode(e.target.value)}
                onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
              <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo}
                className="w-40"
                onChange={(e) => setLotNo(e.target.value)} />
            </>
          )}
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
          {tab === 'waiting' && (
            <span className="text-sm text-text-muted">
              입고대조는 됐고 아직 라인으로 안 나간 릴입니다.
            </span>
          )}
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          {tab === 'issues' ? (
            <DataGrid
              data={issues}
              columns={barcodeIssueColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="자재바코드출고"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['issueDate'] }}
              emptyMessage={searched ? '기간 안에 출고가 없습니다.' : '조회하세요.'}
            />
          ) : tab === 'waiting' ? (
            <DataGrid
              data={waiting}
              columns={issueWaitingColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="출고대기_바코드"
              enableColumnPinning
              defaultPinnedColumns={{ left: ['itemBarcode'] }}
              emptyMessage={searched ? '출고 대기 바코드가 없습니다.' : '조회하세요.'}
              onRowClick={(row) => setBarcode((row as IssueWaitingRow).itemBarcode)}
            />
          ) : (
            <DataGrid
              data={bom}
              columns={kittingBomColumns}
              isLoading={loading}
              pageSize={100}
              enableColumnFilter
              enableExport
              exportFileName="키팅BOM"
              emptyMessage={bomModelName ? '이 모델의 BOM 이 없습니다.' : '모델명을 넣으세요.'}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="자재 출고"
        message={`${scan?.itemCode} 롯트 ${scan?.lotNo} ·`
          + ` ${Number(scan?.barcodeRow?.issueQty ?? 0).toLocaleString()}개를`
          + ` 라인 ${lineCode} 공정 ${workstageCode} 로 출고합니다. 되돌릴 수 없습니다`
          + ' (되돌리려면 출고바코드반품 화면을 쓰세요).'}
        confirmText="출고"
      />
    </div>
  );
}
