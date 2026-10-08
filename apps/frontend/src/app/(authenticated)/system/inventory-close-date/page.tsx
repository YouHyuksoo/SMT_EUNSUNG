"use client";

/**
 * @file src/app/(authenticated)/system/inventory-close-date/page.tsx
 * @description 재고마감일자 설정 — 월별 마감 시작일~종료일을 미리 등록한다
 *
 * 초보자 가이드:
 * 1. 자재·제품·공정 마감은 여기 등록한 기간의 입출고만 그 달로 센다. 종료일은 그날 끝까지 포함한다.
 * 2. 등록이 없는 달은 달력 월(1일~말일)이 적용된다. 줄을 고쳐 [저장] 하면 그 달이 등록된다.
 * 3. 기간은 이웃한 달과 이어져야 한다 (다음 달 시작일 = 이번 달 종료일 + 1일). 안 이어지면 서버가 거절한다.
 * 4. 자재·제품·공정 중 하나라도 마감한 달은 바꾸거나 지울 수 없다.
 * 5. 연간 생성은 그 해 12개월을 한 번에 다시 만든다. 시작일 1 은 달력 월, 26 은 전달 26일~이번 달 25일.
 */
import { useCallback, useEffect, useState } from 'react';
import toast from 'react-hot-toast';
import { CalendarRange, ChevronLeft, ChevronRight, Save, Trash2 } from 'lucide-react';
import { Badge, Button, Card, CardContent, ConfirmModal, Input } from '@/components/ui';
import { apiMessage, closeDateApi, type ClosePeriodRow } from './inventory-close-date';

type Draft = { startDate: string; endDate: string };

const closedBadge = (closed: boolean) => (
  <Badge variant={closed ? 'success' : 'neutral'}>{closed ? '마감' : '미마감'}</Badge>
);

export default function InventoryCloseDatePage() {
  const [year, setYear] = useState(new Date().getFullYear());
  const [rows, setRows] = useState<ClosePeriodRow[]>([]);
  const [drafts, setDrafts] = useState<Record<string, Draft>>({});
  const [loading, setLoading] = useState(false);
  const [busy, setBusy] = useState<string | null>(null);
  const [startDay, setStartDay] = useState('1');
  const [confirmGenerate, setConfirmGenerate] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const list = await closeDateApi.list(year);
      setRows(list);
      setDrafts(Object.fromEntries(list.map((r) => [r.yyyymm, { startDate: r.startDate, endDate: r.endDate }])));
    } catch (error: unknown) {
      setRows([]);
      toast.error(apiMessage(error) ?? '조회에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  }, [year]);

  useEffect(() => { void load(); }, [load]);

  const setDraft = (yyyymm: string, patch: Partial<Draft>) =>
    setDrafts((prev) => ({ ...prev, [yyyymm]: { ...prev[yyyymm], ...patch } }));

  const save = async (row: ClosePeriodRow) => {
    const d = drafts[row.yyyymm];
    if (!d?.startDate || !d?.endDate) {
      toast.error('시작일과 종료일을 입력하세요.');
      return;
    }
    setBusy(row.yyyymm);
    try {
      await closeDateApi.save({ yyyymm: row.yyyymm, startDate: d.startDate, endDate: d.endDate });
      toast.success(`${row.yyyymm} 기간을 저장했습니다.`);
      await load();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '저장에 실패했습니다.');
    } finally {
      setBusy(null);
    }
  };

  const remove = async (row: ClosePeriodRow) => {
    setBusy(row.yyyymm);
    try {
      await closeDateApi.remove(row.yyyymm);
      toast.success(`${row.yyyymm} 등록을 지웠습니다. 달력 월이 적용됩니다.`);
      await load();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '삭제에 실패했습니다.');
    } finally {
      setBusy(null);
    }
  };

  const generate = async () => {
    setBusy('generate');
    try {
      const r = await closeDateApi.generate(year, Number(startDay));
      toast.success(`${r.year}년 ${r.months}개월 기간을 만들었습니다.`);
      setConfirmGenerate(false);
      await load();
    } catch (error: unknown) {
      toast.error(apiMessage(error) ?? '생성에 실패했습니다.');
    } finally {
      setBusy(null);
    }
  };

  const startDayNum = Number(startDay);
  const startDayValid = Number.isInteger(startDayNum) && startDayNum >= 1 && startDayNum <= 28;

  return (
    <div className="flex h-full flex-col gap-3 p-6">
      <header>
        <h1 className="text-xl font-bold text-text">재고마감일자설정</h1>
        <p className="mt-1 text-sm text-text-muted">월별 마감 시작일~종료일 · 자재·제품·공정 마감 공통</p>
      </header>

      <Card padding="none">
        <CardContent className="p-3 text-sm text-text-muted">
          자재·제품·공정 마감은 여기 등록한 기간의 입출고만 그 달로 센다. 기간이 끝난 뒤의 입출고는 다음 달 몫이라
          마감 중에도 생산을 멈출 필요가 없다. 등록이 없는 달은 달력 월(1일~말일)로 본다. 기간은 이웃한 달과
          이어져야 한다 (다음 달 시작일 = 이번 달 종료일 + 1일).
        </CardContent>
      </Card>

      <Card padding="none">
        <CardContent className="flex flex-wrap items-center gap-3 p-3">
          <Button size="sm" variant="secondary" aria-label="이전 해" onClick={() => setYear((y) => y - 1)}>
            <ChevronLeft className="h-4 w-4" />
          </Button>
          <Input aria-label="연도" type="number" value={year} className="w-28"
            onChange={(e) => { const v = Number(e.target.value); if (Number.isInteger(v) && v >= 2000) setYear(v); }} />
          <Button size="sm" variant="secondary" aria-label="다음 해" onClick={() => setYear((y) => y + 1)}>
            <ChevronRight className="h-4 w-4" />
          </Button>
          <span className="ml-4 text-sm font-semibold text-text">시작일</span>
          <Input aria-label="연간 생성 시작일" type="number" min={1} max={28} value={startDay} className="w-20"
            onChange={(e) => setStartDay(e.target.value)} />
          <Button size="sm" disabled={busy !== null || !startDayValid} onClick={() => setConfirmGenerate(true)}>
            <CalendarRange className="mr-1 h-4 w-4" />연간 생성
          </Button>
          {!startDayValid && <span className="text-sm text-amber-500">시작일은 1~28 이어야 합니다.</span>}
        </CardContent>
      </Card>

      <Card className="min-h-0 flex-1 overflow-auto" padding="none">
        <CardContent className="p-3">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border text-left text-text-muted">
                <th className="px-2 py-2">마감월</th>
                <th className="px-2 py-2">시작일</th>
                <th className="px-2 py-2">종료일 (그날 끝까지)</th>
                <th className="px-2 py-2">등록</th>
                <th className="px-2 py-2">자재</th>
                <th className="px-2 py-2">제품</th>
                <th className="px-2 py-2">공정</th>
                <th className="px-2 py-2">마지막 마감</th>
                <th className="px-2 py-2" />
              </tr>
            </thead>
            <tbody>
              {rows.map((r) => {
                const locked = r.materialClosed || r.fgClosed || r.wipClosed;
                const d = drafts[r.yyyymm] ?? { startDate: r.startDate, endDate: r.endDate };
                const rowBusy = busy === r.yyyymm || busy === 'generate';
                return (
                  <tr key={r.yyyymm} className="border-b border-border/50">
                    <td className="px-2 py-2 font-semibold text-text">{r.yyyymm}</td>
                    <td className="px-2 py-2">
                      <Input aria-label={`${r.yyyymm} 시작일`} type="date" value={d.startDate} className="w-44"
                        disabled={locked || loading} onChange={(e) => setDraft(r.yyyymm, { startDate: e.target.value })} />
                    </td>
                    <td className="px-2 py-2">
                      <Input aria-label={`${r.yyyymm} 종료일`} type="date" value={d.endDate} className="w-44"
                        disabled={locked || loading} onChange={(e) => setDraft(r.yyyymm, { endDate: e.target.value })} />
                    </td>
                    <td className="px-2 py-2">
                      <Badge variant={r.registered ? 'info' : 'neutral'}>{r.registered ? '등록됨' : '달력 월 적용'}</Badge>
                    </td>
                    <td className="px-2 py-2">{closedBadge(r.materialClosed)}</td>
                    <td className="px-2 py-2">{closedBadge(r.fgClosed)}</td>
                    <td className="px-2 py-2">{closedBadge(r.wipClosed)}</td>
                    <td className="px-2 py-2 text-text-muted">{r.lastCloseDate ?? '-'}</td>
                    <td className="px-2 py-2">
                      {locked ? (
                        <span className="text-amber-500">마감한 달은 바꿀 수 없다</span>
                      ) : (
                        <div className="flex gap-2">
                          <Button size="sm" disabled={rowBusy || loading} onClick={() => save(r)}>
                            <Save className="mr-1 h-4 w-4" />저장
                          </Button>
                          <Button size="sm" variant="secondary" disabled={rowBusy || loading || !r.registered}
                            onClick={() => remove(r)}>
                            <Trash2 className="mr-1 h-4 w-4" />등록 삭제
                          </Button>
                        </div>
                      )}
                    </td>
                  </tr>
                );
              })}
              {!rows.length && (
                <tr>
                  <td colSpan={9} className="px-2 py-8 text-center text-text-muted">
                    {loading ? '불러오는 중입니다.' : '조회된 기간이 없습니다.'}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </CardContent>
      </Card>

      <ConfirmModal
        isOpen={confirmGenerate}
        onClose={() => setConfirmGenerate(false)}
        onConfirm={generate}
        isLoading={busy === 'generate'}
        title="연간 생성"
        message={`${year}년 12개월의 등록을 지우고 다시 만든다 (1 = 달력 월, 26 = 전달 26일 ~ 이번 달 25일).\n\n시작일 ${startDay} 로 만듭니다. 마감한 달이 있는 해는 만들 수 없습니다.`}
        confirmText="생성"
      />
    </div>
  );
}
