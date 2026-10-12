"use client";

/**
 * @file src/app/(authenticated)/jig/clean-check/page.tsx
 * @description 195 스퀴지검사관리(세척) — PB w_mcn_jig_squeeze_clean_check_master 이식 (쓰기)
 *
 * 초보자 가이드:
 * 1. **스퀴지를 쓰기 전에 깨끗한지 보는 화면이다.** 바코드를 찍고 세척·외관·공기압을
 *    판정해 합격/불합격을 남긴다.
 * 2. **스퀴즈검사관리(`/jig/squeeze-check`)와 다른 화면이다.** 그쪽은 **장력**을,
 *    여기는 **세척 상태**를 본다.
 * 3. **판정이 지그 상태를 바꾼다.** 합격이면 사용가능, 불합격이면 사용정지가 된다.
 *    검사기록과 지그상태가 한 번에 같이 움직인다 — 어긋나면 불합격 스퀴지가
 *    라인에 올라간다.
 * 4. **세척·외관 중 하나라도 NG 면 합격으로 넘길 수 없다.** PB 도 같은 검사를 했다.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import toast from 'react-hot-toast';
import { AlertTriangle, ScanLine, Search, SprayCan } from 'lucide-react';
import DataGrid from '@/components/data-grid/DataGrid';
import DateRangeFilter from '@/components/shared/DateRangeFilter';
import { Button, Card, CardContent, Input } from '@/components/ui';
import api from '@/services/api';
import {
  TruncationNotice,
  useTruncation,
} from '../../report/components/TruncationNotice';
import { jigCleanCheckColumns } from '../jig-extra-columns';
import type { JigCleanCheckRow } from '../jig-extra-columns';

interface JigInfo {
  jigCode: string;
  jigName: string | null;
  lineCode: string | null;
  lineName: string | null;
  breakValue: number | null;
  hitValue: number | null;
  useStatus: string | null;
  tensionCheckYn: string | null;
  lastCleanDate: string | null;
}

const today = () => new Date().toISOString().slice(0, 10);
const daysAgo = (n: number) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  return d.toISOString().slice(0, 10);
};

/** OK/NG 를 고르는 작은 토글 — 세척과 외관이 같은 모양이다. */
function OkNgToggle({ label, value, onChange }: {
  label: string;
  value: boolean | null;
  onChange: (v: boolean) => void;
}) {
  return (
    <span className="flex items-center gap-1">
      <span className="text-sm text-text-muted">{label}</span>
      <Button size="sm" variant={value === true ? 'primary' : 'secondary'}
        onClick={() => onChange(true)}>OK</Button>
      <Button size="sm" variant={value === false ? 'danger' : 'secondary'}
        onClick={() => onChange(false)}>NG</Button>
    </span>
  );
}

export default function JigCleanCheckPage() {
  const [dateFrom, setDateFrom] = useState(daysAgo(7));
  const [dateTo, setDateTo] = useState(today());
  const [jigLotNoCond, setJigLotNoCond] = useState('');
  const [rows, setRows] = useState<JigCleanCheckRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const { truncated, rowLimit, mark } = useTruncation();

  const [barcode, setBarcode] = useState('');
  const [jig, setJig] = useState<JigInfo | null>(null);
  const [cleanOk, setCleanOk] = useState<boolean | null>(null);
  const [visualOk, setVisualOk] = useState<boolean | null>(null);
  const [airPressValue, setAirPressValue] = useState('');
  const [comments, setComments] = useState('');
  const [busy, setBusy] = useState(false);
  const barcodeRef = useRef<HTMLInputElement>(null);

  const search = useCallback(async () => {
    setLoading(true);
    try {
      const r = await api.get('/jig/clean-check', {
        params: { dateFrom, dateTo, jigLotNo: jigLotNoCond || undefined },
      });
      setRows(r.data?.data ?? []);
      mark(r);
      setSearched(true);
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [dateFrom, dateTo, jigLotNoCond, mark]);

  useEffect(() => { void search(); }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const lookup = useCallback(async () => {
    const value = barcode.trim();
    if (!value) return;
    try {
      const r = await api.post('/jig/clean-check/lookup', { jigLotNo: value });
      const data = r.data?.data as { jig: JigInfo | null; reason: string | null };
      if (!data?.jig) {
        toast.error(data?.reason ?? '스퀴지를 찾을 수 없습니다.');
        setJig(null);
        return;
      }
      setJig(data.jig);
      setCleanOk(null);
      setVisualOk(null);
      setAirPressValue('');
      setComments('');
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '조회에 실패했습니다.');
      setJig(null);
    }
  }, [barcode]);

  /** 세척·외관 둘 다 OK 여야 합격이다 (PB 와 같은 규칙). */
  const canPass = cleanOk === true && visualOk === true;
  const blocker = !jig
    ? '스퀴지 바코드를 먼저 찍으세요.'
    : cleanOk === null
      ? '세척 판정을 고르세요.'
      : visualOk === null
        ? '외관 판정을 고르세요.'
        : null;

  const save = useCallback(async (pass: boolean) => {
    if (!jig || blocker) return;
    setBusy(true);
    try {
      const r = await api.post('/jig/clean-check', {
        jigLotNo: barcode.trim(),
        pass,
        cleanOk: cleanOk === true,
        visualOk: visualOk === true,
        airPressValue: airPressValue ? Number(airPressValue) : undefined,
        comments: comments.trim() || undefined,
      });
      const useStatus = r.data?.data?.useStatus;
      toast.success(
        `${pass ? '합격' : '불합격'}으로 남겼습니다 —`
        + ` 지그 상태 ${useStatus === 'U' ? '사용가능' : '사용정지'}`,
      );
      setBarcode('');
      setJig(null);
      setCleanOk(null);
      setVisualOk(null);
      setAirPressValue('');
      setComments('');
      await search();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '등록에 실패했습니다.');
    } finally {
      setBusy(false);
      barcodeRef.current?.focus();
    }
  }, [jig, blocker, barcode, cleanOk, visualOk, airPressValue, comments, search]);

  return (
    <div className="flex h-full flex-col gap-4 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">스퀴지검사관리(세척)</h1>
        <p className="mt-1 text-sm text-text-muted">
          스퀴지의 세척·외관·공기압을 판정합니다 ·{' '}
          {searched ? `${rows.length.toLocaleString()}건` : '조회하세요'}
        </p>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-3">
          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <ScanLine className="h-4 w-4" />스퀴지 바코드
            </span>
            <Input ref={barcodeRef} aria-label="스퀴지 바코드" placeholder="스퀴지 바코드"
              value={barcode} className="w-64" autoFocus
              onChange={(e) => setBarcode(e.target.value)}
              onKeyDown={(e) => { if (e.key === 'Enter') void lookup(); }} />
            <Button size="sm" onClick={lookup}>조회</Button>
            {jig && (
              <span className="text-sm text-text-muted">
                {jig.jigCode} {jig.jigName ?? ''} · {jig.lineName ?? jig.lineCode}
                {jig.lastCleanDate ? ` · 마지막 세척 ${jig.lastCleanDate}` : ' · 세척 이력 없음'}
              </span>
            )}
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <span className="flex items-center gap-1 text-sm font-semibold text-text">
              <SprayCan className="h-4 w-4" />판정
            </span>
            <OkNgToggle label="세척" value={cleanOk} onChange={setCleanOk} />
            <OkNgToggle label="외관" value={visualOk} onChange={setVisualOk} />
            <Input aria-label="공기압" placeholder="공기압" value={airPressValue}
              className="w-28" inputMode="decimal" disabled={!jig}
              onChange={(e) => setAirPressValue(e.target.value)} />
            <Input aria-label="비고" placeholder="비고" value={comments}
              className="w-56" disabled={!jig}
              onChange={(e) => setComments(e.target.value)} />
            <Button size="sm" disabled={busy || Boolean(blocker) || !canPass}
              onClick={() => save(true)}>
              합격
            </Button>
            <Button size="sm" variant="danger" disabled={busy || Boolean(blocker)}
              onClick={() => save(false)}>
              불합격
            </Button>
            {blocker && jig && (
              <span className="flex items-center gap-1 text-sm text-amber-500">
                <AlertTriangle className="h-4 w-4" />{blocker}
              </span>
            )}
            {!blocker && !canPass && jig && (
              <span className="text-sm text-amber-500">
                세척·외관 중 NG 가 있어 합격으로 넘길 수 없습니다.
              </span>
            )}
          </div>
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <DateRangeFilter label="검사일" from={dateFrom} to={dateTo}
            onFromChange={setDateFrom} onToChange={setDateTo} />
          <Input aria-label="지그 롯트 조건" placeholder="지그 롯트" value={jigLotNoCond}
            className="w-44"
            onChange={(e) => setJigLotNoCond(e.target.value)} />
          <Button size="sm" onClick={search} disabled={loading}>
            <Search className="mr-1 h-4 w-4" />조회
          </Button>
        </CardContent>
      </Card>

      <TruncationNotice truncated={truncated} rowLimit={rowLimit} />

      <Card className="min-h-0 flex-1 overflow-hidden" padding="none">
        <CardContent className="h-full p-3">
          <DataGrid
            data={rows}
            columns={jigCleanCheckColumns}
            isLoading={loading}
            pageSize={100}
            enableColumnFilter
            enableExport
            exportFileName="스퀴지세척검사"
            enableColumnPinning
            defaultPinnedColumns={{ left: ['jigLotNo'] }}
            emptyMessage={searched ? '이 기간에 검사 기록이 없습니다.' : '조회하세요.'}
            rowClassName={(row) => (String((row as JigCleanCheckRow).jigCheckStatus ?? '') !== 'P'
              ? 'bg-red-500/5'
              : '')}
          />
        </CardContent>
      </Card>
    </div>
  );
}
