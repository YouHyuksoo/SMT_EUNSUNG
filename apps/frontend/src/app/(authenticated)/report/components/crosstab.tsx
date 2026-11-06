/**
 * @file src/app/(authenticated)/report/components/crosstab.tsx
 * @description 크로스탭(피벗)을 DataGrid 의 행·컬럼으로 바꾼다. 열이 조회 기간에 따라 달라지는 표용.
 *
 * 초보자 가이드:
 * 1. **표는 다른 화면과 같은 DataGrid 로 그린다.** 이 훅은 `(행키, 열키, 값)` 목록을
 *    한 줄짜리 객체와 컬럼 정의로 바꿔 줄 뿐이다. 정렬·필터·고정·내보내기는 DataGrid 가 한다.
 * 2. **피벗을 SQL 로 돌리지 않는다.** 서버는 `(열키, 행키, 값)` 목록만 주고 여기서 돌린다 —
 *    동적 PIVOT SQL 을 만들면 열 목록을 두 번 조회해야 하고 바인드도 못 쓴다.
 * 3. **합계는 행 합계 컬럼(오른쪽 고정) + 표 아래 합계 행이다.** 합계 행은 컬럼 필터가 걸리면
 *    걸러진 행만 더한다.
 * 4. **열 집합이 바뀌면 `gridKey` 도 바뀐다.** DataGrid 에 key 로 넘겨 새 기간의 열 순서로 다시 그린다.
 */
import { useMemo } from 'react';
import type { ColumnDef, HeaderContext } from '@tanstack/react-table';

export interface CrosstabSpec<T> {
  /** 행을 묶는 키. 같은 키면 한 줄로 합친다. */
  rowKey: (row: T) => string;
  /** 왼쪽 컬럼들 (행을 설명하는 값). id 는 컬럼 id — 품목이면 itemCode/itemName 을 쓴다. */
  rowLabels: { id: string; header: string; value: (row: T) => string; width?: number }[];
  /** 열을 만드는 키 (보통 일자). 오름차순으로 정렬한다. */
  colKey: (row: T) => string;
  /** 열 머리글 표시. 생략하면 키를 그대로 쓴다. */
  colHeader?: (key: string) => string;
  /** 셀 값. 같은 (행키, 열키) 가 여러 건이면 더한다. */
  value: (row: T) => number;
}

export type CrosstabRow = Record<string, string | number>;

const ROW_TOTAL = 'rowTotal';

const blankZero = (value: unknown) => {
  const n = Number(value ?? 0);
  return n === 0 ? '' : n.toLocaleString();
};

/** 걸러진 전체 행의 합 (페이지가 아니라 필터 결과 전체) */
const sumFooter = (id: string) => ({ table }: HeaderContext<CrosstabRow, unknown>) =>
  table.getFilteredRowModel().rows
    .reduce((sum, row) => sum + Number(row.getValue(id) ?? 0), 0)
    .toLocaleString();

export function useCrosstab<T>(rows: T[], spec: CrosstabSpec<T>) {
  return useMemo(() => {
    const colKeys = new Set<string>();
    // 행 순서는 처음 나온 순서를 지킨다 (서버 ORDER BY 를 존중한다).
    const lines = new Map<string, CrosstabRow>();
    const colId = (key: string) => `c_${key.replace(/[^0-9A-Za-z_]/g, '_')}`;

    for (const row of rows) {
      const ck = spec.colKey(row);
      colKeys.add(ck);
      const rk = spec.rowKey(row);
      let line = lines.get(rk);
      if (!line) {
        line = { [ROW_TOTAL]: 0 };
        for (const label of spec.rowLabels) line[label.id] = label.value(row);
        lines.set(rk, line);
      }
      const v = Number(spec.value(row) ?? 0);
      const id = colId(ck);
      line[id] = Number(line[id] ?? 0) + v;
      line[ROW_TOTAL] = Number(line[ROW_TOTAL]) + v;
    }

    const cols = [...colKeys].sort();
    const data = [...lines.values()];
    // 그 줄에 없는 열은 0 으로 채워 정렬·필터·내보내기가 빈 값을 만나지 않게 한다.
    for (const line of data) for (const key of cols) line[colId(key)] ??= 0;

    const columns: ColumnDef<CrosstabRow, unknown>[] = [
      ...spec.rowLabels.map((label, i): ColumnDef<CrosstabRow, unknown> => ({
        id: label.id,
        accessorKey: label.id,
        header: label.header,
        size: label.width ?? 100,
        footer: i === 0 ? '합계' : undefined,
      })),
      ...cols.map((key): ColumnDef<CrosstabRow, unknown> => ({
        id: colId(key),
        accessorKey: colId(key),
        header: spec.colHeader ? spec.colHeader(key) : key,
        size: 80,
        meta: { align: 'right', filterType: 'number' },
        cell: ({ getValue }) => blankZero(getValue()),
        footer: sumFooter(colId(key)),
      })),
      {
        id: ROW_TOTAL,
        accessorKey: ROW_TOTAL,
        header: '합계',
        size: 100,
        meta: { align: 'right', filterType: 'number' },
        cell: ({ getValue }) => <span className="font-semibold">{Number(getValue() ?? 0).toLocaleString()}</span>,
        footer: sumFooter(ROW_TOTAL),
      },
    ];

    return {
      data,
      columns,
      /** 첫 설명 컬럼은 왼쪽, 행 합계는 오른쪽에 고정한다 */
      pinned: { left: spec.rowLabels.slice(0, 1).map((l) => l.id), right: [ROW_TOTAL] },
      gridKey: cols.join('|'),
    };
  }, [rows, spec]);
}
