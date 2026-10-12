"use client";

/**
 * @file src/app/(authenticated)/production/smd-plan-board/page.tsx
 * @description 반제품생산계획 현황판 — 날짜 하나의 반제품(SMD) 생산계획을 라인별 블록으로 보여주고
 *              날짜 공지와 라인별 특이사항을 적는다. 생산 1팀이 쓰던 일일 생산계획 표를 옮긴 화면이다.
 *
 * 초보자 가이드:
 * 1. **데이터는 두 API 를 함께 부른다.**
 *    - GET /production/smd-plan?dateFrom=d&dateTo=d : 계획 행 + 시간대 10칸 계획/실적 (반제품생산계획과 같은 API)
 *    - GET /production/smd-plan-board?date=d        : 시간대 정의, 라인 목록, 계획 외 실적, 특이사항·공지
 * 2. **계획 한 건은 주간(A~E)·야간(F~J) 두 줄이다.** 칸 숫자는 센서 실적이다.
 * 3. **메모 저장은 날짜+라인 단위로 통째로 바꾼다.** PUT /production/smd-plan-board/notes,
 *    lineCode '*' 는 날짜 전체 공지다.
 */
import { useCallback, useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Pencil, RefreshCw } from 'lucide-react';
import DateFilter from '@/components/shared/DateFilter';
import { Button, Card, CardContent } from '@/components/ui';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import type { PlanRow } from '../planning-types';
import LineBlock from './components/LineBlock';
import NoteEditor from './components/NoteEditor';
import {
  extraToItem,
  planToItem,
  type BoardItem,
  type BoardLine,
  type BoardMeta,
} from './board-types';

/** 날짜 전체 공지의 라인코드 (백엔드 BOARD_NOTICE_LINE 과 같다) */
const NOTICE_LINE = '*';

const errorMessage = (error: unknown, fallback: string) =>
  (error as { response?: { data?: { message?: string | string[] } } })?.response?.data?.message?.toString()
  ?? fallback;

const titleDate = (date: string) => {
  const [y, m, d] = date.split('-');
  return y && m && d ? `${y}년 ${m}월 ${d}일` : date;
};

export default function SmdPlanBoardPage() {
  const [date, setDate] = useState(getTodayLocal);
  const [plans, setPlans] = useState<PlanRow[]>([]);
  const [meta, setMeta] = useState<BoardMeta | null>(null);
  const [loading, setLoading] = useState(false);
  /** 편집 중인 메모 대상 라인코드 ('*' = 공지) */
  const [editing, setEditing] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const load = useCallback(async (target: string) => {
    setLoading(true);
    try {
      const [planRes, boardRes] = await Promise.all([
        api.get('/production/smd-plan', { params: { dateFrom: target, dateTo: target } }),
        api.get('/production/smd-plan-board', { params: { date: target } }),
      ]);
      setPlans(planRes.data?.data ?? []);
      setMeta(boardRes.data?.data ?? null);
    } catch (error: unknown) {
      setPlans([]);
      setMeta(null);
      toast.error(errorMessage(error, '현황판 조회에 실패했습니다.'));
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    setEditing(null);
    void load(date);
  }, [date, load]);

  const { lines, itemsByLine } = useMemo(() => {
    const byLine = new Map<string, BoardItem[]>();
    const push = (lineCode: string, item: BoardItem) => {
      const list = byLine.get(lineCode) ?? [];
      list.push(item);
      byLine.set(lineCode, list);
    };
    for (const plan of plans) push(plan.lineCode, planToItem(plan));
    for (const extra of meta?.extraActuals ?? []) push(extra.lineCode, extraToItem(extra));

    // 라인 목록은 서버 순서. 서버 목록에 없는 라인의 계획('%' 라인 등)은 뒤에 붙인다.
    const ordered: BoardLine[] = [...(meta?.lines ?? [])];
    const known = new Set(ordered.map((line) => line.lineCode));
    for (const plan of plans) {
      if (!known.has(plan.lineCode)) {
        ordered.push({ lineCode: plan.lineCode, lineName: plan.lineName });
        known.add(plan.lineCode);
      }
    }
    return { lines: ordered, itemsByLine: byLine };
  }, [plans, meta]);

  const saveNotes = useCallback(async (lineCode: string, noteLines: string[]) => {
    setSaving(true);
    try {
      await api.put('/production/smd-plan-board/notes', { date, lineCode, lines: noteLines });
      toast.success(noteLines.length > 0 ? '저장했습니다.' : '메모를 지웠습니다.');
      setEditing(null);
      const boardRes = await api.get('/production/smd-plan-board', { params: { date } });
      setMeta(boardRes.data?.data ?? null);
    } catch (error: unknown) {
      toast.error(errorMessage(error, '메모 저장에 실패했습니다.'));
    } finally {
      setSaving(false);
    }
  }, [date]);

  const notice = meta?.notice;
  const extraCount = meta?.extraActuals.length ?? 0;

  return (
    <div className="flex h-full flex-col gap-4 overflow-auto p-6">
      <header className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-text">반제품생산계획 현황판</h1>
          <p className="mt-1 text-sm text-text-muted">
            생산 1팀 라인별 반제품 계획과 시간대 실적 · 계획 {plans.length}건
            {extraCount > 0 ? ` · 계획 외 실적 ${extraCount}건` : ''}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <DateFilter value={date} onChange={(v) => v && setDate(v)} />
          <Button size="sm" variant="secondary" onClick={() => void load(date)} disabled={loading}>
            <RefreshCw className={`mr-1 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />새로고침
          </Button>
        </div>
      </header>

      <Card padding="none">
        <CardContent className="flex flex-col gap-3 p-4 lg:flex-row lg:items-start">
          <div className="shrink-0 lg:w-80">
            <div className="text-lg font-bold text-text">{titleDate(date)} 생산 1팀 생산계획</div>
            <div className="mt-1 flex items-center gap-2 text-xs text-text-muted">
              {notice?.enterBy ? <span>공지 저장 {notice.enterBy} · {notice.enterDate}</span> : <span>공지 없음</span>}
              {editing !== NOTICE_LINE && (
                <button
                  type="button"
                  onClick={() => setEditing(NOTICE_LINE)}
                  className="flex items-center gap-1 rounded border border-border px-1.5 py-0.5 hover:border-primary hover:text-primary"
                >
                  <Pencil className="h-3 w-3" />공지 편집
                </button>
              )}
            </div>
          </div>
          <div className="min-w-0 flex-1">
            {editing === NOTICE_LINE ? (
              <NoteEditor
                initialLines={notice?.lines ?? []}
                placeholder={'NE PE EV 시리얼넘버 AB라인 00001번부터\n주간조 매주 수요일까지 Reflow Profile 측정\n매주 화요일 대청소 실시'}
                saving={saving}
                onSave={(noteLines) => void saveNotes(NOTICE_LINE, noteLines)}
                onCancel={() => setEditing(null)}
              />
            ) : (notice?.lines.length ?? 0) > 0 ? (
              <ul className="flex flex-col gap-1 border-l-2 border-primary pl-3 text-sm text-text">
                {notice?.lines.map((text, i) => <li key={i}>{text}</li>)}
              </ul>
            ) : (
              <p className="text-sm text-text-muted">이 날짜의 공지가 없습니다.</p>
            )}
          </div>
        </CardContent>
      </Card>

      {meta && meta.slots.length < 10 && (
        <p className="text-sm text-error">
          시간대 정의(ICOM_WORKTIME_RANGES, SMTWORKTIME)가 {meta.slots.length}칸뿐입니다. 시간대 칸이 일부 비어 보일 수 있습니다.
        </p>
      )}

      {/* 블록 하나가 1,100px 남짓 필요해 아주 넓은 화면에서만 두 줄로 놓는다 */}
      <div className="grid grid-cols-1 gap-4 min-[2400px]:grid-cols-2">
        {lines.map((line) => (
          <LineBlock
            key={line.lineCode}
            line={line}
            slots={meta?.slots ?? []}
            items={itemsByLine.get(line.lineCode) ?? []}
            note={meta?.lineNotes[line.lineCode]}
            editing={editing === line.lineCode}
            saving={saving}
            onEdit={() => setEditing(line.lineCode)}
            onCancel={() => setEditing(null)}
            onSave={(noteLines) => void saveNotes(line.lineCode, noteLines)}
          />
        ))}
        {!loading && lines.length === 0 && (
          <p className="text-sm text-text-muted">표시할 라인이 없습니다.</p>
        )}
      </div>
    </div>
  );
}
