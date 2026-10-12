/**
 * @file src/app/(authenticated)/quality/repair-query-columns.tsx
 * @description 281 공정수리이력조회 요약 행 타입 + 컬럼.
 *
 * 일별과 위치별은 **묶는 기준만 다르다** — 그래서 컬럼도 첫 칸 머리글만 바꿔
 * 같은 정의를 쓴다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;

export interface RepairSummaryRow {
  /** 일별이면 날짜(YYYY-MM-DD), 위치별이면 위치코드. */
  groupKey: string;
  modelName: string | null;
  badReasonCode: string | null;
  badReasonName: string | null;
  qcCount: number | null;
  badQty: number | null;
}

export const repairSummaryColumns = (
  groupHeader: string,
): ColumnDef<RepairSummaryRow>[] => [
  { accessorKey: 'groupKey', header: groupHeader, size: 140 },
  { accessorKey: 'modelName', header: '모델', size: 170 },
  { accessorKey: 'badReasonCode', header: '불량사유 코드', size: 130 },
  { accessorKey: 'badReasonName', header: '불량사유', size: 200 },
  {
    accessorKey: 'qcCount',
    header: '건수',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'badQty',
    header: '불량수량',
    size: 120,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
];
