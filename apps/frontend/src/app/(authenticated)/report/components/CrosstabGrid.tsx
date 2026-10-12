"use client";

/**
 * @file src/app/(authenticated)/report/components/CrosstabGrid.tsx
 * @description 크로스탭(피벗) 표. 열 집합이 데이터에 따라 달라지는 표를 그린다.
 *
 * 초보자 가이드:
 * 1. **왜 DataGrid 를 쓰지 않는가.** DataGrid 는 컬럼 정의가 미리 정해진 표다.
 *    크로스탭은 조회한 기간에 따라 열 개수가 바뀐다 (9월 조회면 30열, 하루면 1열).
 * 2. **피벗을 SQL 로 돌리지 않는다.** PB 도 DataWindow 표현 계층에서 돌렸다
 *    (`processing=4`). 서버는 `(열키, 행키, 값)` 목록만 주고 여기서 돌린다 —
 *    동적 PIVOT SQL 을 만들면 열 목록을 두 번 조회해야 하고 바인드도 못 쓴다.
 * 3. **합계는 화면에서 더한다.** 행 합계·열 합계·총합을 모두 보여준다. 리포트에서
 *    합계 없는 크로스탭은 읽을 수 없다.
 * 4. **CSV 로 내보낼 수 있다.** 피벗된 모양 그대로 내보낸다 (DataGrid 의 내보내기는
 *    원자료 모양으로 나가서 크로스탭에는 쓸 수 없다).
 */
import { useMemo } from 'react';
import { Download } from 'lucide-react';
import { Button } from '@/components/ui';

export interface CrosstabSpec<T> {
  /** 행을 묶는 키. 같은 키면 한 줄로 합친다. */
  rowKey: (row: T) => string;
  /** 왼쪽 고정 컬럼들 (행을 설명하는 값). */
  rowLabels: { header: string; value: (row: T) => string; width?: number }[];
  /** 열을 만드는 키 (보통 일자). 오름차순으로 정렬한다. */
  colKey: (row: T) => string;
  /** 열 머리글 표시. 생략하면 키를 그대로 쓴다. */
  colHeader?: (key: string) => string;
  /** 셀 값. 같은 (행키, 열키) 가 여러 건이면 더한다. */
  value: (row: T) => number;
}

const fmt = (n: number) => (n === 0 ? '' : n.toLocaleString());

export function CrosstabGrid<T>({
  rows,
  spec,
  isLoading,
  emptyMessage,
  exportFileName,
}: {
  rows: T[];
  spec: CrosstabSpec<T>;
  isLoading?: boolean;
  emptyMessage?: string;
  exportFileName?: string;
}) {
  const pivot = useMemo(() => {
    const colKeys = new Set<string>();
    // 행 순서는 처음 나온 순서를 지킨다 (서버 ORDER BY 를 존중한다).
    const order: string[] = [];
    const bodies = new Map<string, { labels: string[]; cells: Map<string, number> }>();

    for (const row of rows) {
      const rk = spec.rowKey(row);
      const ck = spec.colKey(row);
      colKeys.add(ck);
      let body = bodies.get(rk);
      if (!body) {
        body = { labels: spec.rowLabels.map((l) => l.value(row)), cells: new Map() };
        bodies.set(rk, body);
        order.push(rk);
      }
      body.cells.set(ck, (body.cells.get(ck) ?? 0) + Number(spec.value(row) ?? 0));
    }

    const cols = [...colKeys].sort();
    const lines = order.map((rk) => {
      const body = bodies.get(rk)!;
      const values = cols.map((c) => body.cells.get(c) ?? 0);
      return {
        key: rk,
        labels: body.labels,
        values,
        total: values.reduce((a, b) => a + b, 0),
      };
    });
    const colTotals = cols.map((_, i) => lines.reduce((sum, l) => sum + l.values[i], 0));
    return {
      cols,
      lines,
      colTotals,
      grandTotal: colTotals.reduce((a, b) => a + b, 0),
    };
  }, [rows, spec]);

  const download = () => {
    const head = [...spec.rowLabels.map((l) => l.header),
      ...pivot.cols.map((c) => (spec.colHeader ? spec.colHeader(c) : c)), '합계'];
    const body = pivot.lines.map((l) => [...l.labels, ...l.values.map(String), String(l.total)]);
    const foot = [
      '합계', ...spec.rowLabels.slice(1).map(() => ''),
      ...pivot.colTotals.map(String), String(pivot.grandTotal),
    ];
    const csv = [head, ...body, foot]
      .map((r) => r.map((c) => `"${String(c).replace(/"/g, '""')}"`).join(','))
      .join('\r\n');
    // 엑셀이 UTF-8 을 알아보게 BOM 을 붙인다 (없으면 한글이 깨진다).
    const blob = new Blob([`﻿${csv}`], { type: 'text/csv;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${exportFileName ?? '크로스탭'}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  if (isLoading) {
    return <div className="p-6 text-sm text-text-muted">불러오는 중…</div>;
  }
  if (pivot.lines.length === 0) {
    return (
      <div className="p-6 text-sm text-text-muted">
        {emptyMessage ?? '조건에 맞는 자료가 없습니다.'}
      </div>
    );
  }

  return (
    <div className="flex h-full flex-col gap-2">
      <div className="flex items-center justify-between gap-2">
        <span className="text-sm text-text-muted">
          {pivot.lines.length}행 × {pivot.cols.length}열 · 총합{' '}
          <span className="font-semibold text-text">{pivot.grandTotal.toLocaleString()}</span>
        </span>
        <Button size="sm" variant="secondary" onClick={download}>
          <Download className="mr-1 h-4 w-4" />CSV
        </Button>
      </div>

      <div className="min-h-0 flex-1 overflow-auto rounded-lg border border-border">
        <table className="w-full border-collapse text-sm">
          <thead className="sticky top-0 z-10 bg-surface">
            <tr>
              {spec.rowLabels.map((l) => (
                <th key={l.header}
                  className="border-b border-r border-border px-2 py-1.5 text-left font-semibold text-text"
                  style={l.width ? { minWidth: l.width } : undefined}>
                  {l.header}
                </th>
              ))}
              {pivot.cols.map((c) => (
                <th key={c}
                  className="whitespace-nowrap border-b border-r border-border px-2 py-1.5 text-right font-semibold text-text">
                  {spec.colHeader ? spec.colHeader(c) : c}
                </th>
              ))}
              <th className="border-b border-border bg-surface px-2 py-1.5 text-right font-semibold text-text">
                합계
              </th>
            </tr>
          </thead>
          <tbody>
            {pivot.lines.map((l) => (
              <tr key={l.key} className="hover:bg-primary/5">
                {l.labels.map((v, i) => (
                  <td key={i}
                    className="whitespace-nowrap border-b border-r border-border px-2 py-1 text-text">
                    {v}
                  </td>
                ))}
                {l.values.map((v, i) => (
                  <td key={i}
                    className="border-b border-r border-border px-2 py-1 text-right text-text">
                    {fmt(v)}
                  </td>
                ))}
                <td className="border-b border-border px-2 py-1 text-right font-semibold text-text">
                  {l.total.toLocaleString()}
                </td>
              </tr>
            ))}
          </tbody>
          <tfoot className="sticky bottom-0 bg-surface">
            <tr>
              <td className="border-t border-r border-border px-2 py-1.5 font-semibold text-text">
                합계
              </td>
              {spec.rowLabels.slice(1).map((l) => (
                <td key={l.header} className="border-t border-r border-border" />
              ))}
              {pivot.colTotals.map((v, i) => (
                <td key={i}
                  className="border-t border-r border-border px-2 py-1.5 text-right font-semibold text-text">
                  {fmt(v)}
                </td>
              ))}
              <td className="border-t border-border px-2 py-1.5 text-right font-bold text-text">
                {pivot.grandTotal.toLocaleString()}
              </td>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  );
}
