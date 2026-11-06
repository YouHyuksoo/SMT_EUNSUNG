"use client";

/**
 * @file src/app/(authenticated)/production/smd-plan-board/components/LineBlock.tsx
 * @description 라인 한 개의 블록 — 큰 라인 글자 + 계획 표(주간/야간 두 줄) + 특이사항 줄 + 합계 줄.
 *
 * 초보자 가이드:
 * 1. 계획 한 건 = 두 줄. 모델~생산계획 칸은 두 줄을 묶고, 근무·시간대·합계만 줄마다 다르다.
 * 2. 시간대 칸 숫자는 센서 실적이다. 계획 칸(planTimeN)에 값이 있을 때만 그 아래 '계획 n' 을 작게 붙인다.
 * 3. LOT·OP·AOI·수삽/외관·UPH(2H) 는 연결할 데이터가 없어 빈 칸으로 둔다.
 */
import { Pencil } from 'lucide-react';
import NoteEditor from './NoteEditor';
import {
  hhmm,
  lineLetter,
  SHIFTS,
  shiftTotals,
  type BoardItem,
  type BoardLine,
  type BoardNoteGroup,
  type BoardSlot,
  type ShiftCells,
} from '../board-types';

interface LineBlockProps {
  line: BoardLine;
  slots: BoardSlot[];
  items: BoardItem[];
  note: BoardNoteGroup | undefined;
  editing: boolean;
  saving: boolean;
  onEdit: () => void;
  onCancel: () => void;
  onSave: (lines: string[]) => void;
}

/** 표 전체 칸 수: 정보 9 + 근무 1 + 시간대 5 + 합계 1 */
const COLUMN_COUNT = 16;
const NO_SOURCE = '연결할 데이터가 없어 비워 둡니다';

const fmt = (value: number | null | undefined) => (value == null ? '' : value.toLocaleString());

const th = 'whitespace-nowrap border-b border-border px-2 py-1.5 text-center text-[11px] font-semibold text-text-muted';
const td = 'whitespace-nowrap px-2 py-1 text-right tabular-nums';

function SlotCell({ cells, index }: { cells: ShiftCells; index: number }) {
  const actual = cells.actual[index];
  const plan = cells.plan[index];
  return (
    <td className={td}>
      <span className={actual ? 'text-text' : 'text-text-muted'}>{actual == null ? '' : fmt(actual)}</span>
      {plan ? <span className="block text-[10px] leading-tight text-text-muted">계획 {fmt(plan)}</span> : null}
    </td>
  );
}

export default function LineBlock({
  line, slots, items, note, editing, saving, onEdit, onCancel, onSave,
}: LineBlockProps) {
  const letter = lineLetter(line);
  const daySlots = slots.slice(0, 5);
  const nightSlots = slots.slice(5, 10);
  const shiftRange = (shiftSlots: BoardSlot[]) =>
    shiftSlots.length > 0
      ? `${hhmm(shiftSlots[0].startTime)}~${hhmm(shiftSlots[shiftSlots.length - 1].endTime)}`
      : '';
  const totals = { day: shiftTotals(items, 'day'), night: shiftTotals(items, 'night') };
  const noteLines = note?.lines ?? [];

  return (
    <section className="flex min-w-0 overflow-hidden rounded-lg border border-border bg-card">
      <aside className="flex w-20 shrink-0 flex-col items-center justify-between gap-2 border-r border-border bg-surface px-1 py-3">
        <div className="text-center">
          <div className={`font-bold leading-none text-text ${letter.length <= 2 ? 'text-5xl' : 'text-base break-all'}`}>
            {letter}
          </div>
          <div className="mt-1 text-[11px] text-text-muted">{line.lineName ?? line.lineCode}</div>
        </div>
        <button
          type="button"
          onClick={onEdit}
          disabled={editing}
          className="flex flex-col items-center gap-0.5 rounded border border-border px-1.5 py-1 text-[11px] text-text-muted hover:border-primary hover:text-primary disabled:opacity-40"
        >
          <Pencil className="h-3 w-3" />특이사항
        </button>
      </aside>

      <div className="min-w-0 flex-1 overflow-x-auto">
        <table className="w-full border-collapse text-xs">
          <thead className="bg-surface">
            <tr>
              <th className={`${th} text-left`}>MODEL</th>
              <th className={`${th} text-left`}>품번</th>
              <th className={th} title={NO_SOURCE}>LOT</th>
              <th className={th} title={NO_SOURCE}>OP</th>
              <th className={th} title={NO_SOURCE}>AOI</th>
              <th className={th} title={NO_SOURCE}>수삽/외관</th>
              <th className={th} title={NO_SOURCE}>UPH(2H)</th>
              <th className={th} title="계획수량 (롯트카드 LOT 수량과 같다)">LOT 수량</th>
              <th className={th} title="시간대 계획 10칸의 합">생산계획</th>
              <th className={th}>근무</th>
              {daySlots.map((slot, i) => {
                const night = nightSlots[i];
                return (
                  <th
                    key={slot.code}
                    className={th}
                    title={`주간 ${slot.code} ${hhmm(slot.startTime)}~${hhmm(slot.endTime)}`
                      + (night ? ` / 야간 ${night.code} ${hhmm(night.startTime)}~${hhmm(night.endTime)}` : '')}
                  >
                    {slot.code} TIME
                    {night && <span className="block text-[10px] font-normal">야간 {night.code}</span>}
                  </th>
                );
              })}
              <th className={th}>합계</th>
            </tr>
          </thead>
          <tbody>
            {items.length === 0 && (
              <tr>
                <td colSpan={COLUMN_COUNT} className="px-2 py-3 text-center text-text-muted">
                  이 날짜의 계획·실적이 없습니다.
                </td>
              </tr>
            )}
            {items.map((item) =>
              SHIFTS.map((shift, shiftIndex) => {
                const cells = item[shift.key];
                const first = shiftIndex === 0;
                return (
                  <tr
                    key={`${item.key}|${shift.key}`}
                    className={`${first ? 'border-t border-border' : 'bg-surface/60'}`}
                  >
                    {first && (
                      <>
                        <td rowSpan={2} className="max-w-[280px] px-2 py-1 align-middle text-text">
                          <div className="flex items-center gap-1">
                            <span className="truncate font-medium" title={item.modelName}>{item.modelName}</span>
                            {item.pcbItem && (
                              <span
                                className="shrink-0 rounded border border-border px-1 text-[10px] text-text-muted"
                                title={item.pcbItemName ?? item.pcbItem}
                              >
                                {item.pcbItem}
                              </span>
                            )}
                            {item.kind === 'extra' && (
                              <span
                                className="shrink-0 rounded border border-info/50 px-1 text-[10px] text-info"
                                title="같은 날 계획과 라인·모델·PCB 면이 맞지 않는 생산실적"
                              >
                                계획 외
                              </span>
                            )}
                          </div>
                          {item.modelSuffix && item.modelSuffix !== '*' && (
                            <div className="text-[10px] text-text-muted">{item.modelSuffix}</div>
                          )}
                        </td>
                        <td rowSpan={2} className="whitespace-nowrap px-2 py-1 align-middle text-text-secondary">
                          {item.itemCode ?? ''}
                        </td>
                        <td rowSpan={2} />
                        <td rowSpan={2} />
                        <td rowSpan={2} />
                        <td rowSpan={2} />
                        <td rowSpan={2} />
                        <td rowSpan={2} className={`${td} align-middle text-text`}>{fmt(item.lotQty)}</td>
                        <td rowSpan={2} className={`${td} align-middle text-text`}>{fmt(item.planSum)}</td>
                      </>
                    )}
                    <td
                      className="whitespace-nowrap px-2 py-1 text-center text-text-secondary"
                      title={shiftRange(shift.key === 'day' ? daySlots : nightSlots)}
                    >
                      {shift.label}
                    </td>
                    {cells.actual.map((_, i) => (
                      <SlotCell key={i} cells={cells} index={i} />
                    ))}
                    <td className={`${td} font-semibold text-text`}>{fmt(cells.actualSum)}</td>
                  </tr>
                );
              }),
            )}

            {editing ? (
              <tr className="border-t border-border">
                <td colSpan={COLUMN_COUNT} className="px-2 py-2">
                  <NoteEditor
                    initialLines={noteLines}
                    placeholder={'ㄴ 마무리 후 K LINE 이관 생산\n※ 야간 종업 시간 07:30'}
                    saving={saving}
                    onSave={onSave}
                    onCancel={onCancel}
                  />
                </td>
              </tr>
            ) : (
              noteLines.map((text, i) => (
                <tr key={`note-${i}`} className={i === 0 ? 'border-t border-border' : ''}>
                  <td colSpan={COLUMN_COUNT} className="border-l-2 border-warning px-2 py-0.5 text-[13px] text-text">
                    {text}
                  </td>
                </tr>
              ))
            )}

            {items.length > 0 && SHIFTS.map((shift, shiftIndex) => {
              const total = totals[shift.key];
              return (
                <tr key={`total-${shift.key}`} className={`bg-surface font-semibold ${shiftIndex === 0 ? 'border-t-2 border-border' : ''}`}>
                  {shiftIndex === 0 && (
                    <td colSpan={9} rowSpan={2} className="px-2 py-1 text-right align-middle text-text-muted">
                      합계
                    </td>
                  )}
                  <td className="px-2 py-1 text-center text-text-secondary">{shift.label}</td>
                  {total.slots.map((value, i) => (
                    <td key={i} className={`${td} text-text`}>{fmt(value)}</td>
                  ))}
                  <td className={`${td} text-text`}>{fmt(total.sum)}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </section>
  );
}
