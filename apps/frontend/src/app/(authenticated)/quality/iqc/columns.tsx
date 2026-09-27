/**
 * @file src/app/(authenticated)/quality/iqc/columns.tsx
 * @description IQC 관리 그리드 컬럼.
 *
 * 표시 규칙은 지그·S-PARTS 와 같은 것을 쓴다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '@/components/shared/grid-format';
import type { IqcHistoryRow, IqcTargetRow } from './types';

const right = { align: 'right' } as const;

/** ESD 점검주기가 임계값에 닿으면 합격 판정이 막힌다 — 그리드에서 바로 보이게 한다 */
export const ESD_CHECK_LIMIT = 10;

export const iqcTargetColumns: ColumnDef<IqcTargetRow>[] = [
  { accessorKey: 'receiptSlipNo', header: '입고전표', size: 140 },
  { accessorKey: 'itemBarcode', header: '자재바코드', size: 160 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 150 },
  { id: 'itemClassName', header: '품목분류', size: 120, accessorFn: (r) => codeWithName(r.itemClass, r.itemClassName) },
  { id: 'supplierName', header: '공급처', size: 150, accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName) },
  { accessorKey: 'scanDate', header: '스캔일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'lotNo', header: 'LOT번호', size: 140 },
  { id: 'inspectResultName', header: '판정', size: 100, accessorFn: (r) => codeWithName(r.inspectResult, r.inspectResultName) },
  {
    accessorKey: 'esdCheckCycleValue', header: 'ESD 점검주기', size: 110, meta: right,
    cell: (c) => {
      const value = Number(c.getValue() ?? 0);
      return value >= ESD_CHECK_LIMIT ? `${value} (점검필요)` : num(c.getValue());
    },
  },
  { id: 'receiptCompareName', header: '입고대조', size: 110, accessorFn: (r) => codeWithName(r.receiptCompareYn, r.receiptCompareName) },
  { accessorKey: 'receiptCompareDate', header: '대조일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { id: 'barcodeStatusName', header: '바코드상태', size: 110, accessorFn: (r) => codeWithName(r.barcodeStatus, r.barcodeStatusName) },
  { accessorKey: 'supplierBarcode', header: '공급처바코드', size: 160 },
  { accessorKey: 'supplierItemCode', header: '공급처품번', size: 140 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 80 },
  { accessorKey: 'locationAddress', header: '자재위치', size: 120 },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 100 },
  { accessorKey: 'manufactureDate', header: '제조일자', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'pcbCoatingDate', header: 'PCB 코팅일', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'lotDivideYn', header: '분할', size: 70 },
  { accessorKey: 'originItemBarcode', header: '원본바코드', size: 160 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const iqcHistoryColumns: ColumnDef<IqcHistoryRow>[] = [
  { accessorKey: 'inspectDate', header: '검사일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'inspectSequence', header: '검사항번', size: 100, meta: right },
  { accessorKey: 'iqcInspectNo', header: '입고전표', size: 140 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'mfs', header: 'MFS(원LOT)', size: 140 },
  { id: 'inspectResultName', header: '판정', size: 100, accessorFn: (r) => codeWithName(r.inspectResult, r.inspectResultName) },
  { id: 'badReasonName', header: '불량원인', size: 130, accessorFn: (r) => codeWithName(r.badReasonCode, r.badReasonName) },
  { id: 'supplierName', header: '공급처', size: 150, accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName) },
  { accessorKey: 'arrivalQty', header: '입하수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'arrivalDate', header: '입하일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'inspectLotQty', header: '검사LOT수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inspectBadLotQty', header: '불량LOT수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inspectQty', header: '검사수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inspectBadQty', header: '불량수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'destroyQty', header: '폐기수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inspectBy', header: '검사자', size: 100 },
  { accessorKey: 'iqcImproveNo', header: '개선번호', size: 120 },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
