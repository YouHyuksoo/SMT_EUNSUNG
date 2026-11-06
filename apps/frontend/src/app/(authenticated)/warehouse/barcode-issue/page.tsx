"use client";

/**
 * @file src/app/(authenticated)/warehouse/barcode-issue/page.tsx
 * @description 자재바코드출고관리 — PB w_mat_other_issue_barcode_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **자재를 라인으로 내보내고(출고), 쓰다 남은 릴을 되돌리는(반품) 화면이다.**
 *    왼쪽 패널 맨 위에서 작업(출고 / 반품)을 고른다.
 * 2. **출고 조건 (왼쪽)** — 출고 형태 · 라인 · 공정 · 모델 · Inv Type 과 PB Option 묶음 전부.
 *    - PCB Assy 출고(기본, P): 제품 모델 설계BOM 에 있는 자재만 나간다.
 *    - SMT 출고(K): SMT 모델 · 라인 · 면 피더 BOM 에 있는 자재만 나가고 피더 위치가 남는다.
 *    - 🔒 표시 옵션(FIFO · Model Not Check · No Origin Barcode)은 비밀번호를 맞춰야 바꾼다.
 *      서버가 판정·출고 때마다 다시 맞춘다.
 *    - 기본값은 시스템 설정값(PB 와 같다). MSL · 원라벨 대조 · Issue By Feeder 는 설정값이라 잠겨 있다.
 * 3. **출고 스캔** — 원라벨(거래처 바코드)을 먼저, 자재 바코드를 다음에 찍는다. 검사 결과가
 *    목록으로 나오고 '출고' 를 눌러야 기록된다. No Origin Barcode 면 원라벨 없이 나간다.
 * 4. **고른 조건은 사용자별로 기억한다** (이 PC 브라우저). 다시 열면 작업 · 출고 형태 · 라인 · 공정 ·
 *    모델 · 면 · Inv Type · 옵션 · 반품 조건이 그대로 채워진다. 🔒 잠금 옵션과 비밀번호는 기억하지 않는다.
 * 5. **반품** — 반품 형태 · Bad · Line Manual Check · Auto Print · Auto Set Qty · Invoice 를
 *    왼쪽에서 정하고 오른쪽에서 찍는다 (IssueReturnWork).
 */
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import {
  AlertTriangle, CheckCircle2, Lock, MinusCircle, ScanLine, Search, Settings2, Undo2, XCircle,
} from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import BarcodeScanInput from '@/components/shared/BarcodeScanInput';
import ComCodeSelect from '@/components/shared/ComCodeSelect';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import LabelPrintMethodSelect, { useLabelPrintMethod } from '@/components/shared/LabelPrintMethodSelect';
import LineSelect from '@/components/shared/LineSelect';
import ModelSearchField from '@/components/shared/ModelSearchField';
import PartSearchField from '@/components/shared/PartSearchField';
import ProcessSelect from '@/components/shared/ProcessSelect';
import ScreenTabs from '@/components/shared/ScreenTabs';
import { Button, Card, CardContent, ConfirmModal, Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { useAuthStore } from '@/stores/authStore';
import { getTodayLocal } from '@/utils/date';
import { TruncationNotice, useTruncation } from '../../report/components/TruncationNotice';
import {
  barcodeIssueColumns,
  fifoCandidateColumns,
  issueBomColumns,
  issueWaitingColumns,
} from '../barcode-issue-columns';
import type {
  BarcodeIssueRow,
  BarcodeIssueScanResult,
  FifoCandidateRow,
  IssueBomRow,
  IssueMode,
  IssueWaitingRow,
  ScanCheck,
} from '../barcode-issue-columns';
import IssueCancelModal from './IssueCancelModal';
import IssueReturnWork from './IssueReturnWork';

const today = () => getTodayLocal();

type WorkKind = 'issue' | 'return';
type TabKey = 'bom' | 'issues' | 'waiting';
type LockedOption = 'fifo' | 'modelNotCheck' | 'noOriginBarcode';

const TAB_LABELS: Record<TabKey, string> = { bom: '출고 BOM', issues: '출고 이력', waiting: '출고 대기' };
const MODE_LABELS: Record<IssueMode, { label: string; hint: string }> = {
  P: { label: 'PCB Assy 출고', hint: '제품 모델 설계BOM 으로 대조' },
  K: { label: 'SMT 출고', hint: 'SMT 모델·라인·면 피더 BOM 으로 대조' },
};
const LOCK_LABELS: Record<LockedOption, string> = {
  fifo: 'Material FIFO', modelNotCheck: 'Model Not Check', noOriginBarcode: 'No Origin Barcode',
};

/** GET /warehouse/barcode-issue/options — 시스템 설정값 (없으면 PB 기본값) */
interface IssueOptionDefaults {
  materialFifo: boolean;
  issueCompare: boolean;
  mslTimeCheck: boolean;
  lifeCycleCheck: boolean;
  issueByFeeder: boolean;
  longTermInventory: boolean;
}

/** 검사 결과 한 줄의 아이콘·색. */
const CHECK_STYLE: Record<ScanCheck['result'], { icon: typeof CheckCircle2; cls: string }> = {
  pass: { icon: CheckCircle2, cls: 'text-emerald-500' },
  reject: { icon: XCircle, cls: 'text-red-500 font-semibold' },
  warn: { icon: AlertTriangle, cls: 'text-amber-500' },
  skip: { icon: MinusCircle, cls: 'text-text-muted' },
};

/** 이 화면은 성공·실패를 직접 토스트로 알린다 — 공용 오류 창·성공 토스트를 겹쳐 띄우지 않는다. */
const QUIET = { suppressErrorModal: true, skipSuccessToast: true } as const;

const errorMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

/** 사용자별로 기억하는 조건 (localStorage). 🔒 잠금 옵션·비밀번호는 넣지 않는다. */
const CONDITIONS_STORAGE_PREFIX = 'barcode-issue-conditions';
interface SavedConditions {
  work: WorkKind;
  issueMode: IssueMode;
  lineCode: string;
  workstageCode: string;
  modelName: string;
  topBottom: string;
  inventoryType: string;
  locationFilter: string;
  checkPcbCoating: boolean;
  checkLongTerm: boolean;
  checkLifeCycle: boolean;
  noCheckDup: boolean;
  returnBad: boolean;
  lineManual: boolean;
  returnLineCode: string;
  autoPrint: boolean;
  autoQty: boolean;
  invoiceNo: string;
}

function readSavedConditions(key: string): Partial<SavedConditions> | null {
  try {
    const raw = localStorage.getItem(key);
    return raw ? (JSON.parse(raw) as Partial<SavedConditions>) : null;
  } catch {
    return null;
  }
}

/** 왼쪽 패널 체크박스 한 줄 */
function OptionCheck({ label, checked, onChange, disabled, locked, onUnlock, hint }: {
  label: string; checked: boolean; onChange?: (v: boolean) => void; disabled?: boolean;
  locked?: boolean; onUnlock?: () => void; hint?: string;
}) {
  return (
    <div className="flex items-center gap-2 text-sm text-text" title={hint}>
      <label className={`flex flex-1 items-center gap-2 ${disabled || locked ? 'text-text-muted' : ''}`}>
        <input type="checkbox" checked={checked} disabled={disabled || locked}
          onChange={(e) => onChange?.(e.target.checked)} />
        {label}
      </label>
      {locked && (
        <button type="button" onClick={onUnlock} aria-label={`${label} 잠금 해제`}
          className="rounded p-0.5 text-text-muted hover:bg-surface hover:text-text">
          <Lock className="h-3.5 w-3.5" />
        </button>
      )}
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="flex flex-col gap-2">
      <span className="text-xs font-medium text-text-muted">{title}</span>
      {children}
    </section>
  );
}

export default function BarcodeIssuePage() {
  const [work, setWork] = useState<WorkKind>('issue');
  const [tab, setTab] = useState<TabKey>('bom');

  // ── 출고 조건 (좌측 패널) ──
  const [issueMode, setIssueMode] = useState<IssueMode>('P');
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [modelName, setModelName] = useState('');
  const [runCardNo, setRunCardNo] = useState('');
  const [topBottom, setTopBottom] = useState('');
  const [inventoryType, setInventoryType] = useState('P');
  const [locationFilter, setLocationFilter] = useState('');

  // PB Option 묶음
  const [defaults, setDefaults] = useState<IssueOptionDefaults | null>(null);
  const [checkFifo, setCheckFifo] = useState(true);
  const [checkPcbCoating, setCheckPcbCoating] = useState(true);
  const [checkLongTerm, setCheckLongTerm] = useState(false);
  const [checkLifeCycle, setCheckLifeCycle] = useState(false);
  const [noOriginBarcode, setNoOriginBarcode] = useState(false);
  const [modelNotCheck, setModelNotCheck] = useState(false);
  const [noCheckDup, setNoCheckDup] = useState(true);
  const [unlockPassword, setUnlockPassword] = useState('');
  const [unlockTarget, setUnlockTarget] = useState<LockedOption | null>(null);
  const [passwordInput, setPasswordInput] = useState('');

  // ── 반품 조건 (좌측 패널) ──
  const [returnBad, setReturnBad] = useState(false);
  const [lineManual, setLineManual] = useState(false);
  const [returnLineCode, setReturnLineCode] = useState('');
  const [autoPrint, setAutoPrint] = useState(true);
  const [autoQty, setAutoQty] = useState(false);
  const [invoiceNo, setInvoiceNo] = useState('');
  const [printMethod, setPrintMethod] = useLabelPrintMethod();

  // ── 조회 ──
  const [dateFrom, setDateFrom] = useState(today());
  const [dateTo, setDateTo] = useState(today());
  const [itemCode, setItemCode] = useState('');
  const [lotNo, setLotNo] = useState('');
  const [issues, setIssues] = useState<BarcodeIssueRow[]>([]);
  const [waiting, setWaiting] = useState<IssueWaitingRow[]>([]);
  const [bom, setBom] = useState<IssueBomRow[]>([]);
  /** 이 화면에서 출고한 바코드 (자재별) — PB dw_1.our_barcode / dw_5.check_yn 표시 */
  const [issuedByItem, setIssuedByItem] = useState<Record<string, string[]>>({});
  const [loading, setLoading] = useState(false);
  const [bomLoading, setBomLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  // ── 스캔·출고 ──
  const [supplierBarcode, setSupplierBarcode] = useState('');
  const [barcode, setBarcode] = useState('');
  const [scan, setScan] = useState<BarcodeIssueScanResult | null>(null);
  const [fifoRows, setFifoRows] = useState<FifoCandidateRow[]>([]);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [cancelOpen, setCancelOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  // ── 고른 조건 기억 (사용자별) ──
  const userId = useAuthStore((state) => state.user?.id)?.trim();
  const storageKey = userId ? `${CONDITIONS_STORAGE_PREFIX}:${encodeURIComponent(userId)}` : null;
  const savedRef = useRef<Partial<SavedConditions> | null>(null);
  const [restored, setRestored] = useState(false);
  // 설정 기본값을 받기 전에 저장하면 기본값 대신 초기값이 기억된다 — 받은 뒤부터 저장한다.
  const [optionsReady, setOptionsReady] = useState(false);

  useEffect(() => {
    const saved = storageKey ? readSavedConditions(storageKey) : null;
    savedRef.current = saved;
    if (saved) {
      if (saved.work) setWork(saved.work);
      if (saved.issueMode) setIssueMode(saved.issueMode);
      if (saved.lineCode !== undefined) setLineCode(saved.lineCode);
      if (saved.workstageCode !== undefined) setWorkstageCode(saved.workstageCode);
      if (saved.modelName !== undefined) setModelName(saved.modelName);
      if (saved.topBottom !== undefined) setTopBottom(saved.topBottom);
      if (saved.inventoryType) setInventoryType(saved.inventoryType);
      if (saved.locationFilter !== undefined) setLocationFilter(saved.locationFilter);
      if (saved.checkPcbCoating !== undefined) setCheckPcbCoating(saved.checkPcbCoating);
      if (saved.checkLongTerm !== undefined) setCheckLongTerm(saved.checkLongTerm);
      if (saved.checkLifeCycle !== undefined) setCheckLifeCycle(saved.checkLifeCycle);
      if (saved.noCheckDup !== undefined) setNoCheckDup(saved.noCheckDup);
      if (saved.returnBad !== undefined) setReturnBad(saved.returnBad);
      if (saved.lineManual !== undefined) setLineManual(saved.lineManual);
      if (saved.returnLineCode !== undefined) setReturnLineCode(saved.returnLineCode);
      if (saved.autoPrint !== undefined) setAutoPrint(saved.autoPrint);
      if (saved.autoQty !== undefined) setAutoQty(saved.autoQty);
      if (saved.invoiceNo !== undefined) setInvoiceNo(saved.invoiceNo);
    }
    setRestored(true);
  }, [storageKey]);

  useEffect(() => {
    if (!restored || !optionsReady || !storageKey) return;
    const next: SavedConditions = {
      work, issueMode, lineCode, workstageCode, modelName, topBottom, inventoryType, locationFilter,
      checkPcbCoating, checkLongTerm, checkLifeCycle, noCheckDup,
      returnBad, lineManual, returnLineCode, autoPrint, autoQty, invoiceNo,
    };
    try {
      localStorage.setItem(storageKey, JSON.stringify(next));
    } catch {
      // 저장소를 못 쓰면 이번 화면에서만 유지한다.
    }
  }, [restored, optionsReady, storageKey, work, issueMode, lineCode, workstageCode, modelName, topBottom, inventoryType,
    locationFilter, checkPcbCoating, checkLongTerm, checkLifeCycle, noCheckDup,
    returnBad, lineManual, returnLineCode, autoPrint, autoQty, invoiceNo]);

  // 설정값으로 옵션 기본값을 맞춘다 (PB f_config_setup → 체크박스 constructor).
  // 사용자가 고른 값이 기억돼 있으면 그 값을 둔다 (FIFO 는 잠금 옵션이라 늘 설정값).
  useEffect(() => {
    if (!restored) return;
    api.get('/warehouse/barcode-issue/options')
      .then((r) => {
        const d = r.data?.data as IssueOptionDefaults | undefined;
        if (!d) return;
        const saved = savedRef.current;
        setDefaults(d);
        setCheckFifo(d.materialFifo);
        setCheckLongTerm(saved?.checkLongTerm ?? d.longTermInventory);
        setCheckLifeCycle(saved?.checkLifeCycle ?? d.lifeCycleCheck);
      })
      .catch(() => toast.error('출고 옵션 기본값을 읽지 못했습니다.'))
      .finally(() => setOptionsReady(true));
  }, [restored]);

  /** 라인을 고르면 PB 처럼 생산유형 · SMT 공정 · (SMT 출고면) 생산계획 모델·면을 채운다. */
  const changeLine = useCallback(async (next: string) => {
    setLineCode(next);
    if (!next) return;
    try {
      const r = await api.get('/warehouse/barcode-issue/line-defaults', { params: { lineCode: next } });
      const d = r.data?.data as { productionType: string | null; workstageCode: string | null;
        planModelName: string | null; planPcbItem: string | null } | undefined;
      if (!d) return;
      setInventoryType(d.productionType || 'P');
      if (d.workstageCode) setWorkstageCode((prev) => prev || d.workstageCode || '');
      if (issueMode === 'K' && d.planModelName) {
        setModelName(d.planModelName);
        setTopBottom(d.planPcbItem ?? '');
      }
    } catch {
      toast.error('라인 기본값을 읽지 못했습니다.');
    }
  }, [issueMode]);

  /** 출고 형태를 바꾸면 모델 목록이 달라지므로 모델·판정·BOM 표시를 비운다. */
  const changeMode = useCallback((next: IssueMode) => {
    setIssueMode(next);
    setModelName('');
    setTopBottom('');
    setScan(null);
    setFifoRows([]);
    setBom([]);
    setIssuedByItem({});
  }, []);

  /** 런카드 번호(9자리)로 모델을 찾는다 (PB 모델 칸에 런카드를 찍던 기능). */
  const findRunCardModel = useCallback(async () => {
    const no = runCardNo.trim();
    if (!no) return;
    try {
      const r = await api.get('/warehouse/barcode-issue/run-card-model', { params: { runNo: no } });
      const name = (r.data?.data?.modelName as string | null) ?? null;
      if (!name) { toast.error(`런카드 ${no} 의 모델을 찾지 못했습니다.`); return; }
      setModelName(name);
      setRunCardNo('');
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '런카드를 찾지 못했습니다.');
    }
  }, [runCardNo]);

  /** 잠금 옵션 — 비밀번호가 맞으면 그 옵션을 뒤집는다 (PB '?' 버튼). */
  const confirmUnlock = useCallback(async () => {
    if (!unlockTarget) return;
    try {
      await api.post('/warehouse/barcode-issue/unlock', { password: passwordInput }, QUIET);
      setUnlockPassword(passwordInput);
      if (unlockTarget === 'fifo') setCheckFifo((v) => !v);
      if (unlockTarget === 'modelNotCheck') setModelNotCheck((v) => !v);
      if (unlockTarget === 'noOriginBarcode') setNoOriginBarcode((v) => !v);
      toast.success(`${LOCK_LABELS[unlockTarget]} 을(를) 바꿨습니다.`);
      setUnlockTarget(null);
      setPasswordInput('');
      setScan(null);
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '비밀번호가 맞지 않습니다.');
    }
  }, [unlockTarget, passwordInput]);

  /** 출고 조건이 바뀌면 대조 BOM 을 다시 읽는다. */
  const loadBom = useCallback(async () => {
    if (!modelName.trim() || (issueMode === 'K' && !lineCode)) { setBom([]); return; }
    setBomLoading(true);
    try {
      const r = await api.get('/warehouse/barcode-issue/bom', {
        params: {
          issueMode,
          modelName: modelName.trim(),
          lineCode: lineCode || undefined,
          topBottom: issueMode === 'K' ? topBottom || undefined : undefined,
        },
      });
      setBom(r.data?.data ?? []);
    } catch (error: unknown) {
      setBom([]);
      toast.error(errorMessage(error) ?? '출고 BOM 을 읽지 못했습니다.');
    } finally {
      setBomLoading(false);
    }
  }, [issueMode, modelName, lineCode, topBottom]);

  useEffect(() => { void loadBom(); }, [loadBom]);
  // 모델이 바뀌면 출고 표시도 새로 센다.
  useEffect(() => { setIssuedByItem({}); setScan(null); }, [issueMode, modelName]);

  const search = useCallback(async () => {
    if (tab === 'bom') { void loadBom(); return; }
    setLoading(true);
    try {
      if (tab === 'issues') {
        const r = await api.get('/warehouse/barcode-issue', {
          params: { dateFrom, dateTo, itemCode: itemCode || undefined, lotNo: lotNo || undefined, lineCode: lineCode || undefined },
        });
        setIssues(r.data?.data ?? []);
        mark(r);
      } else {
        const r = await api.get('/warehouse/barcode-issue/waiting', {
          params: { itemCode: itemCode || undefined, lotNo: lotNo || undefined },
        });
        setWaiting(r.data?.data ?? []);
        mark(r);
      }
      setSearched(true);
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [tab, dateFrom, dateTo, itemCode, lotNo, lineCode, mark, loadBom]);

  useEffect(() => { if (tab !== 'bom') void search(); }, [tab]); // eslint-disable-line react-hooks/exhaustive-deps

  const conditionBody = useCallback(() => ({
    lineCode,
    workstageCode: workstageCode.trim(),
    issueMode,
    modelName: modelName.trim(),
    topBottom: issueMode === 'K' ? topBottom || undefined : undefined,
    supplierBarcode: supplierBarcode.trim() || undefined,
    noOriginBarcode,
    modelNotCheck: issueMode === 'P' ? modelNotCheck : false,
    unlockPassword: unlockPassword || undefined,
    inventoryType,
    checkFifo, checkPcbCoating,
    checkLongTermInventory: checkLongTerm,
    checkLifeCycle,
  }), [lineCode, workstageCode, issueMode, modelName, topBottom, supplierBarcode, noOriginBarcode,
    modelNotCheck, unlockPassword, inventoryType, checkFifo, checkPcbCoating, checkLongTerm, checkLifeCycle]);

  /** 찍은 바코드를 판정한다 (읽기 전용). 출고는 하지 않는다. */
  const runScan = useCallback(async (scanned?: string) => {
    const value = (scanned ?? barcode).trim();
    if (!value) return;
    setBarcode(value);
    setBusy(true);
    setFifoRows([]);
    try {
      const r = await api.post('/warehouse/barcode-issue/scan', { ...conditionBody(), barcode: value }, QUIET);
      const result = r.data?.data as BarcodeIssueScanResult | undefined;
      setScan(result ?? null);
      if (result && Number(result.fifoCount ?? 0) > 0 && result.itemCode && result.lotNo) {
        const f = await api.get('/warehouse/barcode-issue/fifo', {
          params: { itemCode: result.itemCode, lotNo: result.lotNo, inventoryType: result.inventoryType ?? inventoryType },
        });
        setFifoRows(f.data?.data ?? []);
      }
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '바코드를 판정하지 못했습니다.');
      setScan(null);
    } finally {
      setBusy(false);
    }
  }, [barcode, conditionBody, inventoryType]);

  /** SMT 출고에서 No Check Dup 를 끄면 같은 바코드·남은 BOM 자리를 화면에서 막는다 (PB dw_1.find). */
  const dupBlocker = useMemo(() => {
    if (issueMode !== 'K' || noCheckDup || !scan?.itemCode) return null;
    const scannedList = issuedByItem[scan.itemCode] ?? [];
    if (scannedList.includes(scan.barcode)) return '이미 스캔 한 자재입니다.';
    const slots = bom.filter((r) => r.div === 'BOM' && r.itemCode === scan.itemCode).length;
    if (slots > 0 && scannedList.length >= slots) return `${scan.itemCode} 의 BOM 자리가 모두 찼습니다.`;
    return null;
  }, [issueMode, noCheckDup, scan, issuedByItem, bom]);

  /** 출고대조 + 출고 기록 (쓰기). */
  const submit = useCallback(async () => {
    setConfirmOpen(false);
    setBusy(true);
    try {
      const r = await api.post('/warehouse/barcode-issue', { ...conditionBody(), barcode: barcode.trim() }, QUIET);
      const result = r.data?.data as { barcode?: string; itemCode?: string; issueQty?: number; warnings?: ScanCheck[] } | undefined;
      toast.success(`출고했습니다: ${result?.itemCode} ${Number(result?.issueQty ?? 0).toLocaleString()}개`);
      (result?.warnings ?? []).forEach((w) => toast(`${w.label}: ${w.detail ?? ''}`, { icon: '⚠️' }));
      if (result?.itemCode) {
        const code = result.itemCode;
        const bc = result.barcode ?? barcode.trim();
        setIssuedByItem((prev) => ({ ...prev, [code]: [...(prev[code] ?? []), bc] }));
      }
      // 원라벨 칸도 비운다 (PB cbx_supplier_clear 'C').
      setSupplierBarcode('');
      setBarcode('');
      setScan(null);
      setFifoRows([]);
      if (tab !== 'bom') void search();
    } catch (error: unknown) {
      toast.error(errorMessage(error) ?? '출고에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  }, [barcode, conditionBody, tab, search]);

  const blocker = !lineCode ? '라인을 고르세요.'
    : !workstageCode.trim() ? '공정을 고르세요.'
      : !modelName.trim() ? '모델을 고르세요.'
        : !barcode.trim() ? (noOriginBarcode || supplierBarcode ? '자재 바코드를 찍으세요.' : '원라벨을 먼저 찍으세요.')
          : !scan ? '바코드를 먼저 판정하세요 (Enter).'
            : !scan.issuable ? scan.reason
              : dupBlocker;

  const bomRows = useMemo(() => bom
    .map((r) => ({ ...r, issuedCount: (issuedByItem[r.itemCode] ?? []).length }))
    .filter((r) => issueMode !== 'K' || !locationFilter.trim()
      || String(r.feederLocationCode ?? '').toUpperCase().includes(locationFilter.trim().toUpperCase())),
  [bom, issuedByItem, locationFilter, issueMode]);
  const bomColumns = useMemo(() => issueBomColumns(issueMode), [issueMode]);
  const issuedItems = Object.keys(issuedByItem).length;
  const iqcState = scan?.checks.find((c) => c.key === 'iqc');

  const counts: Record<TabKey, number> = { bom: bom.length, issues: issues.length, waiting: waiting.length };


  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">자재바코드출고관리</h1>
        <p className="mt-1 text-sm text-text-muted">
          {work === 'issue' ? '릴 바코드를 찍어 라인으로 내보냅니다' : '라인에서 남은 릴을 창고로 되돌립니다'} · 왼쪽에서 조건을 정하세요
        </p>
      </header>

      {/* 작업 · 출고 형태 (반품이면 반품 형태) — PB Category / Process 라디오 */}
      <Card padding="none">
        <CardContent className="flex flex-wrap items-stretch gap-3 p-3">
          <div className="flex overflow-hidden rounded-md border border-border" role="group" aria-label="작업">
            {(['issue', 'return'] as const).map((w) => (
              <button key={w} type="button" onClick={() => setWork(w)}
                className={`flex w-28 items-center justify-center gap-1 px-3 py-2 text-sm ${work === w
                  ? 'bg-primary text-primary-foreground' : 'bg-background text-text hover:bg-surface'}`}>
                {w === 'issue' ? <><ScanLine className="h-4 w-4" />출고</> : <><Undo2 className="h-4 w-4" />반품</>}
              </button>
            ))}
          </div>
          {work === 'issue' && <span className="flex items-center text-xs font-medium text-text-muted">출고 형태</span>}
          {work === 'issue' && (
            <div className="flex flex-wrap gap-2" role="radiogroup" aria-label="출고 형태">
              {(Object.keys(MODE_LABELS) as IssueMode[]).map((m) => (
                <button key={m} type="button" role="radio" aria-checked={issueMode === m} onClick={() => changeMode(m)}
                  className={`w-64 rounded-md border px-3 py-2 text-left text-sm ${issueMode === m
                    ? 'border-primary bg-primary/10 text-text' : 'border-border bg-background text-text-muted hover:bg-surface'}`}>
                  <span className="font-semibold">{MODE_LABELS[m].label}</span>
                  <span className="ml-1 text-xs">({m})</span>
                  <span className="mt-0.5 block text-xs text-text-muted">{MODE_LABELS[m].hint}</span>
                </button>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      <div className="flex min-h-0 flex-1 gap-4">
        {/* ── 좌측 패널 ── */}
        <Card className="w-[36rem] shrink-0 overflow-y-auto" padding="none">
          <CardContent className="flex flex-col gap-4 p-4">
            {work === 'issue' ? (
              <>
                <div className="flex items-center gap-1 text-sm font-semibold text-text"><Settings2 className="h-4 w-4" />출고 조건</div>
                <div className="grid grid-cols-2 gap-4">
                <div className="flex min-w-0 flex-col gap-4">
                <Section title="출고 위치">
                  <LineSelect value={lineCode} onChange={(v) => void changeLine(v)} labelPrefix="라인" fullWidth />
                  <ProcessSelect labelPrefix="공정" value={workstageCode} onChange={setWorkstageCode} fullWidth />
                  <ComCodeSelect groupCode="INVENTORY TYPE" labelPrefix="Inv Type" includeAll={false} placeholder="Inv Type"
                    value={inventoryType} onChange={setInventoryType} fullWidth />
                </Section>

                <Section title={issueMode === 'P' ? '제품 모델' : 'SMT 모델'}>
                  <ModelSearchField value={modelName} onChange={(v) => setModelName(v)} className="w-full" />
                  <Input aria-label="런카드 번호" placeholder="런카드 번호 → Enter (모델 찾기)" value={runCardNo} className="w-full"
                    onChange={(e) => setRunCardNo(e.target.value.toUpperCase())}
                    onKeyDown={(e) => { if (e.key === 'Enter') void findRunCardModel(); }} />
                  {issueMode === 'K' && (
                    <ComCodeSelect groupCode="TOP BOTTOM" labelPrefix="면" value={topBottom} onChange={setTopBottom} fullWidth />
                  )}
                  <p className="text-xs text-text-muted">
                    {!modelName ? '모델을 고르면 대조 BOM 을 읽습니다.'
                      : issueMode === 'K' && !lineCode ? 'SMT 출고는 라인을 골라야 피더 BOM 을 읽습니다.'
                        : bomLoading ? 'BOM 을 읽는 중…'
                          : `대조 BOM ${bom.length.toLocaleString()}건 · 출고 ${issuedItems.toLocaleString()}종`}
                  </p>
                </Section>

                {issueMode === 'K' && (
                <Section title="Process">
                  <Input aria-label="Location Code 필터" placeholder="Location Code (피더 필터)" value={locationFilter} className="w-full" onChange={(e) => setLocationFilter(e.target.value)} />
                </Section>
                )}
                </div>
                <div className="flex min-w-0 flex-col gap-4">
                <Section title="Option">
                  <OptionCheck label="IQC Check (품목 검사규칙 자동)" checked={iqcState ? iqcState.result !== 'skip' : false} disabled
                    hint="품목 검사규칙이 무검사(P)가 아니면 IQC 합격 이력을 본다 — 찍으면 자동으로 정해진다" />
                  <OptionCheck label="PCB Coating Check" checked={checkPcbCoating} onChange={setCheckPcbCoating} />
                  <OptionCheck label="No Origin Barcode" checked={noOriginBarcode} locked onUnlock={() => setUnlockTarget('noOriginBarcode')}
                    hint="원라벨 없이 출고 — 원라벨 칸 값(비우면 자재 바코드) 뒤에 -NB 를 붙여 남긴다" />
                  <OptionCheck label="Model Not Check" checked={modelNotCheck} locked onUnlock={() => setUnlockTarget('modelNotCheck')}
                    hint="PCB Assy 출고의 BOM 대조를 끈다" />
                  <OptionCheck label="Material FIFO" checked={checkFifo} locked onUnlock={() => setUnlockTarget('fifo')} />
                  <OptionCheck label="Life Cycle Check" checked={checkLifeCycle} onChange={setCheckLifeCycle} />
                  <OptionCheck label="MSL Time Check" checked={defaults?.mslTimeCheck ?? true} disabled hint="시스템 설정값 (PB 에서도 잠긴 칸)" />
                  <OptionCheck label="Issue Compare YN (원라벨 대조)" checked={defaults?.issueCompare ?? true} disabled hint="시스템 설정값 MATERIAL_ISSUE_COMPARE_YN (없으면 Y)" />
                  <OptionCheck label="Issue By Feeder" checked={defaults?.issueByFeeder ?? false} disabled hint="시스템 설정값 ISSUE_BY_FEEDER" />
                  <OptionCheck label="MFS Auto Generate" checked disabled hint="PB 에 표시만 있고 동작하는 코드가 없는 옵션" />
                  <OptionCheck label="Long Term Inventory" checked={checkLongTerm} onChange={setCheckLongTerm} />
                  <OptionCheck label="No Check Dup (SMT)" checked={noCheckDup} onChange={setNoCheckDup} disabled={issueMode !== 'K'}
                    hint="끄면 SMT 출고에서 같은 바코드와 BOM 자리 수를 막는다" />
                  <OptionCheck label="Supplier Clear (C)" checked disabled hint="출고 뒤 원라벨 칸을 비운다 (PB 고정)" />
                  <OptionCheck label="With Location Information" checked={false} disabled hint="PB Monitoring 모드의 비교 목록 전환 — 이 화면에 그 모드가 없다" />
                </Section>

                </div>
                </div>
              </>
            ) : (
              <>
                <div className="flex items-center gap-1 text-sm font-semibold text-text"><Settings2 className="h-4 w-4" />반품 조건</div>
                <div className="grid grid-cols-2 gap-4">
                <div className="flex min-w-0 flex-col gap-4">
                <Section title="Process">
                  <OptionCheck label="Bad (불량 반품 → M02 · 라인 28)" checked={returnBad}
                    onChange={(v) => { setReturnBad(v); setAutoPrint(!v); }} />
                  <OptionCheck label="Line Manual Check" checked={lineManual} onChange={setLineManual}
                    hint="켜면 마지막 출고 라인 대신 아래 라인을 쓴다" />
                  <LineSelect value={returnLineCode} onChange={setReturnLineCode} labelPrefix="라인" fullWidth />
                  <OptionCheck label="Auto Print (새 라벨)" checked={autoPrint && !returnBad} disabled={returnBad} onChange={setAutoPrint} />
                  <LabelPrintMethodSelect value={printMethod} onChange={setPrintMethod} fullWidth />
                  <OptionCheck label="Issue Return Auto Set Qty" checked={autoQty} onChange={setAutoQty}
                    hint="찍으면 반품 수량에 현재 릴 수량을 채운다" />
                </Section>
                </div>
                <div className="flex min-w-0 flex-col gap-4">
                <Section title="Mass Issue Return">
                  <Input aria-label="Invoice" placeholder="Invoice (불량 반품 전표, 비우면 채번)" value={invoiceNo} className="w-full"
                    onChange={(e) => setInvoiceNo(e.target.value)} />
                  <p className="text-xs text-text-muted">반품·로스 행의 모델: {modelName || '없음'} (출고 조건의 모델)</p>
                </Section>
                </div>
                </div>
              </>
            )}
          </CardContent>
        </Card>

        {/* ── 오른쪽 작업부 ── */}
        {work === 'return' ? (
          <IssueReturnWork conditions={{
            bad: returnBad, lineManual, lineCode: returnLineCode, autoPrint: autoPrint && !returnBad,
            autoQty, invoiceNo, modelName, printMethod,
          }} />
        ) : (
          <div className="flex min-w-0 flex-1 flex-col gap-4">
            <Card padding="none">
              <CardContent className="flex flex-col gap-3 p-3">
                <div className="flex flex-wrap items-center gap-3">
                  <span className="flex items-center gap-1 text-sm font-semibold text-text"><ScanLine className="h-4 w-4" />출고 스캔</span>
                  <span className="rounded bg-primary/10 px-2 py-0.5 text-xs font-medium text-primary">{MODE_LABELS[issueMode].label}</span>
                  <BarcodeScanInput aria-label="원라벨" placeholder={noOriginBarcode ? '원라벨 없음 (No Origin Barcode)' : '원라벨(거래처 바코드) 스캔'}
                    value={supplierBarcode} onChange={setSupplierBarcode} onScan={(v) => setSupplierBarcode(v)}
                    primaryFocus={false} maintainFocus={false} className="w-60" />
                  <BarcodeScanInput aria-label="자재 바코드" placeholder="자재 바코드 스캔"
                    value={barcode} onChange={setBarcode} onScan={(v) => void runScan(v)} className="w-64" />
                  <Button size="sm" variant="secondary" disabled={busy || !barcode.trim()} onClick={() => void runScan()}>판정</Button>
                  <Button size="sm" disabled={busy || Boolean(blocker)} onClick={() => setConfirmOpen(true)}>출고</Button>
                  <Button size="sm" variant="secondary" onClick={() => setCancelOpen(true)}>
                    <Undo2 className="mr-1 h-4 w-4" />출고 취소
                  </Button>
                  {blocker && (barcode || lineCode) && (
                    <span className="flex items-center gap-1 text-sm text-text-muted">
                      <AlertTriangle className="h-4 w-4 shrink-0 text-amber-500" />{blocker}
                    </span>
                  )}
                </div>

                {scan && (
                  <div className="rounded border border-border bg-surface-muted p-3 text-sm">
                    <div className="mb-2 flex flex-wrap gap-x-6 gap-y-1">
                      <span>품목 <b>{scan.itemCode ?? '-'}</b>{scan.item?.itemName ? ` (${scan.item.itemName})` : ''}</span>
                      <span>롯트 <b>{scan.lotNo ?? '-'}</b></span>
                      <span>수량 <b>{Number(scan.barcodeRow?.issueQty ?? 0).toLocaleString()}</b></span>
                      <span>전표 {scan.barcodeRow?.receiptSlipNo ?? '없음'}</span>
                      {scan.item?.mslLevel && <span>MSL {scan.item.mslLevel}</span>}
                      {scan.feederLocationCode && <span>피더 <b>{scan.feederLocationCode}</b></span>}
                      {scan.supplierBarcode && <span>원라벨 {scan.supplierBarcode}</span>}
                    </div>
                    <div className="grid gap-1 md:grid-cols-2 xl:grid-cols-3">
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

                {fifoRows.length > 0 && (
                  <div>
                    <p className="mb-1 text-sm font-semibold text-red-500">먼저 써야 할 릴 {fifoRows.length}건 — 이 릴을 찾아 쓰세요.</p>
                    <div className="max-h-56 overflow-auto">
                      <DataGrid data={fifoRows} columns={fifoCandidateColumns} pageSize={20} enableExport
                        exportFileName="FIFO_먼저써야할릴" emptyMessage="없습니다." />
                    </div>
                  </div>
                )}
              </CardContent>
            </Card>

            <ScreenTabs
              tabs={(Object.keys(TAB_LABELS) as TabKey[]).map((k) => ({ key: k, label: TAB_LABELS[k], count: counts[k] }))}
              active={tab}
              onChange={setTab}
            />

            {tab !== 'bom' && (
              <Card padding="none">
                <CardContent className="flex flex-wrap items-center gap-3 p-3">
                  {tab === 'issues' && (
                    <DateRangeFilter label="출고일" from={dateFrom} to={dateTo} onFromChange={setDateFrom} onToChange={setDateTo} />
                  )}
                  <PartSearchField aria-label="품목코드" placeholder="품목코드" value={itemCode} className="w-44"
                    onChange={(e) => setItemCode(e.target.value)} onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
                  <Input aria-label="롯트번호" placeholder="롯트번호" value={lotNo} className="w-40" onChange={(e) => setLotNo(e.target.value)} />
                  <Button size="sm" onClick={search} disabled={loading}><Search className="mr-1 h-4 w-4" />조회</Button>
                  {tab === 'waiting' && <span className="text-sm text-text-muted">입고대조는 됐고 아직 라인으로 안 나간 릴입니다.</span>}
                </CardContent>
              </Card>
            )}

            {tab !== 'bom' && <TruncationNotice truncated={truncated} rowLimit={rowLimit} />}

            <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
              <CardContent className="h-full p-3">
                {tab === 'bom' ? (
                  <DataGrid data={bomRows} columns={bomColumns} isLoading={bomLoading} pageSize={100}
                    enableColumnFilter enableExport exportFileName={`출고BOM_${modelName}`}
                    emptyMessage={!modelName ? '왼쪽에서 모델을 고르세요.'
                      : issueMode === 'K' && !lineCode ? '라인을 고르세요.' : '이 조건의 BOM 이 없습니다.'} />
                ) : tab === 'issues' ? (
                  <DataGrid data={issues} columns={barcodeIssueColumns} isLoading={loading} pageSize={100}
                    enableColumnFilter enableExport exportFileName="자재바코드출고" enableColumnPinning
                    defaultPinnedColumns={{ left: ['issueDate'] }}
                    emptyMessage={searched ? '기간 안에 출고가 없습니다.' : '조회하세요.'} />
                ) : (
                  <DataGrid data={waiting} columns={issueWaitingColumns} isLoading={loading} pageSize={100}
                    enableColumnFilter enableExport exportFileName="출고대기_바코드" enableColumnPinning
                    defaultPinnedColumns={{ left: ['itemBarcode'] }}
                    emptyMessage={searched ? '출고 대기 바코드가 없습니다.' : '조회하세요.'}
                    onRowClick={(row) => setBarcode((row as IssueWaitingRow).itemBarcode)} />
                )}
              </CardContent>
            </Card>
          </div>
        )}
      </div>

      <IssueCancelModal isOpen={cancelOpen} onClose={() => setCancelOpen(false)}
        onCanceled={() => { if (tab !== 'bom') void search(); }} />

      <Modal isOpen={unlockTarget !== null} onClose={() => { setUnlockTarget(null); setPasswordInput(''); }}
        title={unlockTarget ? `${LOCK_LABELS[unlockTarget]} 잠금 해제` : ''} size="sm"
        footer={(
          <div className="flex justify-end gap-2">
            <Button variant="secondary" size="sm" onClick={() => { setUnlockTarget(null); setPasswordInput(''); }}>취소</Button>
            <Button size="sm" disabled={!passwordInput} onClick={() => void confirmUnlock()}>확인</Button>
          </div>
        )}>
        <div className="flex flex-col gap-2 text-sm">
          <p className="text-text-muted">비밀번호가 맞으면 이 옵션을 바꿉니다. 출고할 때마다 서버가 다시 확인합니다.</p>
          <Input type="password" aria-label="비밀번호" placeholder="비밀번호" value={passwordInput} autoFocus
            onChange={(e) => setPasswordInput(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter' && passwordInput) void confirmUnlock(); }} />
        </div>
      </Modal>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={submit}
        title="자재 출고"
        message={`${scan?.itemCode} 롯트 ${scan?.lotNo} · ${Number(scan?.barcodeRow?.issueQty ?? 0).toLocaleString()}개를`
          + ` ${MODE_LABELS[issueMode].label}(${issueMode}) · 모델 ${modelName} · 라인 ${lineCode} 공정 ${workstageCode} 로`
          + ' 출고합니다. 되돌리려면 반품하거나 출고취소 화면을 쓰세요.'}
        confirmText="출고"
      />
    </div>
  );
}
