/**
 * @file src/app/(authenticated)/confirm/confirm-columns.tsx
 * @description 승인 화면 그리드 컬럼.
 *
 * 표시 규칙은 다른 대분류와 같다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '@/components/shared/grid-format';
import type { BomWorkNumberRow, BomWorkspaceRow, PriceConfirmRow } from './confirm-types';

const right = { align: 'right' } as const;

/** 이전단가 → 새 단가의 변화율. 승인 화면에서 가장 먼저 보는 숫자다. */
const changeRate = (row: PriceConfirmRow) => {
  const last = Number(row.lastPrice ?? 0);
  const now = Number(row.unitPrice ?? 0);
  if (!Number.isFinite(last) || last === 0) return '';
  return `${(((now - last) / last) * 100).toFixed(1)}%`;
};

/**
 * 단가승인 컬럼.
 * @param variant 'mold' 는 라인유형이 키가 아니고 품목이 S-PARTS 코드다.
 * @param partnerLabel 공급처 / 고객
 */
export function priceConfirmColumns(
  variant: 'buy' | 'sale' | 'mold',
  partnerLabel: string,
): ColumnDef<PriceConfirmRow>[] {
  const cols: ColumnDef<PriceConfirmRow>[] = [
    { accessorKey: 'confirmYn', header: '승인', size: 70 },
    {
      accessorKey: 'itemCode',
      header: variant === 'mold' ? 'S-PARTS 코드' : '품목코드',
      size: 150,
    },
    {
      accessorKey: 'itemName',
      header: variant === 'mold' ? 'S-PARTS명' : '품목명',
      size: 190,
    },
    {
      id: 'partnerName',
      header: partnerLabel,
      size: 160,
      accessorFn: (r) => codeWithName(r.partnerCode, r.partnerName),
    },
    { accessorKey: 'dateSet', header: '적용시작', size: 110, cell: (c) => dateOnly(c.getValue()) },
    { accessorKey: 'dateEnd', header: '적용종료', size: 110, cell: (c) => dateOnly(c.getValue()) },
  ];

  // 라인유형은 구매·판매에서 키의 일부다. S-PARTS 는 키가 아니라 컬럼을 내지 않는다.
  if (variant !== 'mold') {
    cols.push({
      id: 'lineTypeName',
      header: '라인유형 (키)',
      size: 130,
      accessorFn: (r) => codeWithName(r.lineType, r.lineTypeName),
    });
  }

  cols.push(
    {
      accessorKey: 'lastPrice',
      header: '이전단가',
      size: 120,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    {
      accessorKey: 'unitPrice',
      header: '신규단가',
      size: 120,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    { id: 'changeRate', header: '변화율', size: 100, meta: right, accessorFn: changeRate },
    {
      accessorKey: 'standardPrice',
      header: '표준단가',
      size: 120,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    {
      id: 'currencyName',
      header: '통화',
      size: 100,
      accessorFn: (r) => codeWithName(r.currency, r.currencyName),
    },
    { accessorKey: 'taxRate', header: '세율', size: 80, meta: right, cell: (c) => num(c.getValue()) },
    {
      id: 'priceTypeName',
      header: '단가유형',
      size: 120,
      accessorFn: (r) => codeWithName(r.priceType, r.priceTypeName),
    },
    {
      id: 'priceChangeReasonName',
      header: '변경사유',
      size: 150,
      accessorFn: (r) => codeWithName(r.priceChangeReason, r.priceChangeReasonName),
    },
  );

  if (variant !== 'sale') {
    cols.push(
      { accessorKey: 'approvalNo', header: '승인번호', size: 120 },
      {
        id: 'deliveryName',
        header: '납품조건',
        size: 120,
        accessorFn: (r) => codeWithName(r.delivery, r.deliveryName),
      },
    );
  }

  cols.push(
    { accessorKey: 'confirmBy', header: '승인자', size: 100 },
    {
      accessorKey: 'confirmDate',
      header: '승인일시',
      size: 150,
      cell: (c) => dateTime(c.getValue()),
    },
    { accessorKey: 'enterBy', header: '등록자', size: 90 },
    {
      accessorKey: 'enterDate',
      header: '등록일시',
      size: 150,
      cell: (c) => dateTime(c.getValue()),
    },
  );
  return cols;
}

export const bomWorkNumberColumns: ColumnDef<BomWorkNumberRow>[] = [
  { accessorKey: 'bomWorkNo', header: '작업번호', size: 110, meta: right },
  { accessorKey: 'itemCode', header: 'SET 품목', size: 150 },
  { accessorKey: 'itemName', header: 'SET 품목명', size: 200 },
  { accessorKey: 'rowCount', header: '행수', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'newRowCount',
    header: '새 BOM 행수',
    size: 120,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  {
    accessorKey: 'enterDate',
    header: '등록일시',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
];

export const bomWorkspaceColumns: ColumnDef<BomWorkspaceRow>[] = [
  { accessorKey: 'newBomYn', header: '신규', size: 70 },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 150 },
  { accessorKey: 'parentItemName', header: '상위품목명', size: 180 },
  { accessorKey: 'childItemCode', header: '하위품목', size: 150 },
  { accessorKey: 'childItemName', header: '하위품목명', size: 180 },
  { accessorKey: 'childItemSpec', header: '규격', size: 160 },
  { accessorKey: 'replaceItemCode', header: '대체품목', size: 140 },
  {
    accessorKey: 'itemUnitQty',
    header: '소요량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'childItemUom', header: '단위', size: 80 },
  {
    accessorKey: 'sortSequence',
    header: '순번',
    size: 80,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  {
    id: 'itemTypeName',
    header: '품목유형',
    size: 120,
    accessorFn: (r) => codeWithName(r.itemType, r.itemTypeName),
  },
  {
    id: 'lineTypeName',
    header: '라인유형',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineType, r.lineTypeName),
  },
  { accessorKey: 'dateSet', header: '적용시작', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'dateEnd', header: '적용종료', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80 },
  { accessorKey: 'revision', header: '리비전', size: 90 },
  { accessorKey: 'confirmComment', header: '승인메모', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];
