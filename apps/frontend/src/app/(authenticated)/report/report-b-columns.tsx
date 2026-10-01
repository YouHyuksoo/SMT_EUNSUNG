/**
 * @file src/app/(authenticated)/report/report-b-columns.tsx
 * @description 리포트 B그룹 그리드 컬럼 (자재 원장 · S-PARTS · 지그 · 4M).
 *
 * 표시 규칙:
 * - 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 * - **단가는 반올림하지 않는다** — 자재 단가에는 1 미만이 흔해서 금액과 같은
 *   규칙으로 찍으면 0 으로 보인다 (리포트 A 에서 실측한 결함이다).
 * - 시각 문자열은 서버가 만들어 보낸 것을 그대로 쓴다 (new Date() 로 다시 파싱하면
 *   UTC 로 해석돼 9시간 틀어진다).
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import type {
  FourMHistoryRow,
  JigCardRow,
  JigIssueReportRow,
  JigReportRow,
  MaterialBarcodeSlipRow,
  MaterialDisusedRow,
  MaterialInventoryDailyRow,
  MaterialInventoryRow,
  MaterialInventorySummaryRow,
  MaterialIssueRow,
  MaterialIssueSumAccountRow,
  MaterialIssueSumItemRow,
  MaterialLongTermRow,
  MaterialNotIssuedRow,
  MaterialRackMoveRow,
  MaterialReceiptRow,
  MaterialReceiptSumItemRow,
  MaterialReceiptSumSupplierRow,
  MaterialReceiptSumWarehouseRow,
  MaterialReceiptSupplierRow,
  MoldCardRow,
  MoldIssueRow,
  MoldReceiptRow,
  MoldReportRow,
  SmtCheckHistoryRow,
} from './report-b-types';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;

const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');
/** 금액은 소수를 버린다. 리포트에서 소수는 읽기를 방해한다. */
const money = (value: unknown) =>
  value == null ? '' : Math.round(Number(value)).toLocaleString();
/** 단가는 소수를 유지한다 (최대 4자리). 자재 단가는 1 미만이 흔하다. */
const unitPrice = (value: unknown) =>
  value == null ? '' : Number(value).toLocaleString(undefined, { maximumFractionDigits: 4 });

const yesNo = (value: unknown) => {
  const v = String(value ?? '');
  if (v === 'Y') return '예';
  if (v === 'N') return '아니오';
  return v;
};

// ───────────────────────────────── 362 자재전표바코드

export const materialBarcodeSlipColumns: ColumnDef<MaterialBarcodeSlipRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 200 },
  { accessorKey: 'scanDate', header: '스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'lotNo', header: '자재 롯트', size: 150 },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    id: 'supplierName',
    header: '협력사',
    size: 160,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'supplierBarcode', header: '협력사 바코드', size: 180 },
  { accessorKey: 'supplierItemCode', header: '협력사 품목', size: 140 },
  { accessorKey: 'supplierLotNo', header: '협력사 롯트', size: 140 },
  { accessorKey: 'receiptSlipNo', header: '입고전표', size: 130 },
  { accessorKey: 'receiptType', header: '입고유형', size: 100, meta: center },
  {
    accessorKey: 'receiptCompareYn',
    header: '입고대조',
    size: 90,
    meta: center,
    cell: (c) => yesNo(c.getValue()),
  },
  { accessorKey: 'receiptCompareDate', header: '입고대조시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'receiptCompareBy', header: '입고대조자', size: 100 },
  { accessorKey: 'issueType', header: '출고유형', size: 100, meta: center },
  {
    accessorKey: 'issueCompareYn',
    header: '출고대조',
    size: 90,
    meta: center,
    cell: (c) => yesNo(c.getValue()),
  },
  { accessorKey: 'issueCompareDate', header: '출고대조시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'barcodeStatus', header: '바코드상태', size: 110, meta: center },
  { accessorKey: 'labelType', header: '라벨유형', size: 90, meta: center },
  {
    accessorKey: 'lotDivideYn',
    header: '롯트분할',
    size: 90,
    meta: center,
    cell: (c) => yesNo(c.getValue()),
  },
  { accessorKey: 'originItemBarcode', header: '원본 바코드', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 363 자재입고

export const materialReceiptColumns: ColumnDef<MaterialReceiptRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'receiptDate', header: '입고시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'receiptSequence', header: '순번', size: 80, meta: right },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'itemClass', header: '품목분류', size: 110 },
  {
    id: 'supplierName',
    header: '협력사',
    size: 160,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'locationCode', header: '창고', size: 100 },
  { accessorKey: 'locationAddress', header: '랙 주소', size: 110 },
  { accessorKey: 'receiptDeficit', header: '입출고', size: 80, meta: center },
  { accessorKey: 'receiptType', header: '입고유형', size: 100, meta: center },
  { accessorKey: 'orderType', header: '발주유형', size: 100, meta: center },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'receiptQty', header: '입고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'unitPrice', header: '입고단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  {
    accessorKey: 'checkUnitPrice',
    header: '기준단가',
    size: 110,
    meta: right,
    // 입고단가와 기준단가가 다르면 단가확인이 안 된 입고다. 그게 이 열의 목적이다.
    cell: (c) => {
      const row = c.row.original as MaterialReceiptRow;
      const base = c.getValue();
      const differs = base != null && row.unitPrice != null
        && Number(base) !== Number(row.unitPrice);
      return differs
        ? <span className="font-semibold text-amber-500">{unitPrice(base)}</span>
        : unitPrice(base);
    },
  },
  { accessorKey: 'receiptAmt', header: '입고금액', size: 130, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'materialCostAmt', header: '재료비', size: 120, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'currency', header: '통화', size: 80, meta: center },
  { accessorKey: 'exchangeRate', header: '환율', size: 90, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'foreignReceiptAmt', header: '외화금액', size: 120, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 130 },
  { accessorKey: 'subcontractInvoiceNo', header: '외주전표', size: 130 },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 140 },
  { accessorKey: 'mfs', header: 'MFS', size: 120 },
  { accessorKey: 'receiptLotNo', header: '입고 롯트', size: 130 },
  { accessorKey: 'barcode', header: '바코드', size: 160 },
  { accessorKey: 'receiptStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'confirmYn', header: '확정', size: 70, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'receiptCompareYn', header: '바코드대조', size: 100, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'receiptSlipNo', header: '바코드전표', size: 130 },
  { accessorKey: 'vendorLotNo', header: '벤더 롯트', size: 130 },
  { accessorKey: 'vendorCode', header: '벤더', size: 100 },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const materialReceiptSupplierColumns: ColumnDef<MaterialReceiptSupplierRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'receiptDate', header: '입고시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'receiptSequence', header: '순번', size: 80, meta: right },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 100 },
  { accessorKey: 'receiptDeficit', header: '입출고', size: 80, meta: center },
  { accessorKey: 'receiptType', header: '입고유형', size: 100, meta: center },
  { accessorKey: 'orderType', header: '발주유형', size: 100, meta: center },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'receiptQty', header: '입고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'unitPrice', header: '단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'receiptAmt', header: '금액', size: 130, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'currency', header: '통화', size: 80, meta: center },
  { accessorKey: 'foreignReceiptAmt', header: '외화금액', size: 120, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 130 },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 140 },
  { accessorKey: 'receiptStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'confirmYn', header: '확정', size: 70, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];

// ───────────────────────────────── 364 자재입고합계

/**
 * 품목별 입고합계 컬럼.
 * @param withContact 협력사 연락처 3칸을 넣을지 (PB '협력사용' DataWindow)
 */
export function materialReceiptSumItemColumns(
  withContact: boolean,
): ColumnDef<MaterialReceiptSumItemRow>[] {
  const cols: ColumnDef<MaterialReceiptSumItemRow>[] = [
    {
      id: 'supplierName',
      header: '협력사',
      size: 170,
      accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
    },
  ];
  if (withContact) {
    cols.push(
      { accessorKey: 'supplierAddress', header: '주소', size: 220 },
      { accessorKey: 'supplierTelNo', header: '전화', size: 130 },
      { accessorKey: 'supplierFaxNo', header: '팩스', size: 130 },
    );
  }
  cols.push(
    { accessorKey: 'itemCode', header: '품목코드', size: 150 },
    { accessorKey: 'itemName', header: '품목명', size: 180 },
    { accessorKey: 'itemSpec', header: '규격', size: 160 },
    { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
    {
      accessorKey: 'virtualReceiptYn',
      header: '가상입고',
      size: 90,
      meta: center,
      cell: (c) => yesNo(c.getValue()),
    },
    { accessorKey: 'receiptType', header: '입고유형', size: 100, meta: center },
    { accessorKey: 'invoiceNo', header: '전표번호', size: 130 },
    {
      accessorKey: 'receiptQty',
      header: '입고수량',
      size: 120,
      meta: right,
      cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
    },
    // PB 와 같이 단순 평균이다. 수량 가중 평균이 아니라는 것을 머리글에 적는다.
    { accessorKey: 'receiptPrice', header: '단가(평균)', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
    { accessorKey: 'receiptAmt', header: '입고금액', size: 140, meta: right, cell: (c) => money(c.getValue()) },
    { accessorKey: 'foreignReceiptAmt', header: '외화금액', size: 130, meta: right, cell: (c) => money(c.getValue()) },
  );
  return cols;
}

export const materialReceiptSumSupplierColumns: ColumnDef<MaterialReceiptSumSupplierRow>[] = [
  {
    id: 'supplierName',
    header: '협력사',
    size: 190,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'receiptType', header: '입고유형', size: 110, meta: center },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 140 },
  {
    accessorKey: 'receiptQty',
    header: '입고수량',
    size: 130,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'receiptAmt', header: '입고금액', size: 150, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'foreignReceiptAmt', header: '외화금액', size: 140, meta: right, cell: (c) => money(c.getValue()) },
];

export const materialReceiptSumWarehouseColumns: ColumnDef<MaterialReceiptSumWarehouseRow>[] = [
  {
    id: 'locationName',
    header: '창고',
    size: 200,
    accessorFn: (r) => codeWithName(r.locationCode, r.locationName),
  },
  { accessorKey: 'receiptType', header: '입고유형', size: 110, meta: center },
  {
    accessorKey: 'receiptQty',
    header: '입고수량',
    size: 130,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'receiptAmt', header: '입고금액', size: 150, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'foreignReceiptAmt', header: '외화금액', size: 140, meta: right, cell: (c) => money(c.getValue()) },
];

// ───────────────────────────────── 365 자재출고

export const materialIssueColumns: ColumnDef<MaterialIssueRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'issueDate', header: '출고시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'issueSequence', header: '순번', size: 80, meta: right },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'abcGrade', header: 'ABC', size: 70, meta: center },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'locationCode', header: '창고', size: 100 },
  { accessorKey: 'locationAddress', header: '랙 주소', size: 110 },
  { accessorKey: 'issueDeficit', header: '입출고', size: 80, meta: center },
  { accessorKey: 'issueType', header: '출고유형', size: 100, meta: center },
  { accessorKey: 'issueAccount', header: '출고계정', size: 110 },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'issueQty', header: '출고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'unitPrice', header: '단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'issueAmt', header: '출고금액', size: 130, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'modelName', header: '모델', size: 140 },
  { accessorKey: 'mfs', header: 'MFS', size: 120 },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 140 },
  { accessorKey: 'feederLocationCode', header: '피더위치', size: 110 },
  { accessorKey: 'feederShaft', header: '피더축', size: 90 },
  { accessorKey: 'barcode', header: '바코드', size: 160 },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 130 },
  { accessorKey: 'issueStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const materialNotIssuedColumns: ColumnDef<MaterialNotIssuedRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'issueDate', header: '지시일', size: 110 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'mfs', header: 'MFS', size: 120 },
  { accessorKey: 'planYyyymm', header: '계획월', size: 100, meta: center },
  { accessorKey: 'issuePlanQty', header: '지시수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'issueQty', header: '출고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'remainQty',
    header: '미출고',
    size: 110,
    meta: right,
    cell: (c) => <span className="font-semibold text-amber-500">{num(c.getValue())}</span>,
  },
  { accessorKey: 'issueStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'issueAccount', header: '출고계정', size: 110 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];

export const smtCheckHistoryColumns: ColumnDef<SmtCheckHistoryRow>[] = [
  { accessorKey: 'checkDate', header: '체크시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 220 },
  { accessorKey: 'partName', header: '자재명', size: 170 },
  { accessorKey: 'lotName', header: '롯트명', size: 150 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'locationCode', header: '위치', size: 110 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'oldBarcode', header: '이전 바코드', size: 200 },
  { accessorKey: 'checkType', header: '체크유형', size: 100, meta: center },
  { accessorKey: 'checkSequence', header: '순번', size: 80, meta: right },
  { accessorKey: 'checkStatus', header: '상태', size: 90, meta: center },
  { accessorKey: 'recycleDate', header: '재활용시각', size: 170, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 366 자재출고합계

export const materialIssueSumItemColumns: ColumnDef<MaterialIssueSumItemRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  {
    accessorKey: 'issueQty',
    header: '출고수량',
    size: 130,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'issueAmt', header: '출고금액', size: 150, meta: right, cell: (c) => money(c.getValue()) },
];

export const materialIssueSumAccountColumns: ColumnDef<MaterialIssueSumAccountRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'issueAccount', header: '출고계정', size: 140 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  {
    accessorKey: 'issueQty',
    header: '출고수량',
    size: 130,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'issueAmt', header: '출고금액', size: 150, meta: right, cell: (c) => money(c.getValue()) },
];

// ───────────────────────────────── 367 자재랙이동

export const materialRackMoveColumns: ColumnDef<MaterialRackMoveRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'moveDate', header: '이동시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 150 },
  { accessorKey: 'fromRack', header: '이전 랙', size: 120 },
  { accessorKey: 'toRack', header: '이후 랙', size: 120 },
];

// ───────────────────────────────── 368 자재장기재고

export const materialLongTermColumns: ColumnDef<MaterialLongTermRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 150 },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'locationAddressRack', header: '랙 주소', size: 130 },
  { accessorKey: 'lastReceiptDate', header: '마지막 입고', size: 120 },
  {
    accessorKey: 'idleDays',
    header: '경과일수',
    size: 110,
    meta: right,
    // 오래 잠긴 것이 눈에 들어와야 한다. 1년 넘으면 빨강, 6개월 넘으면 주황.
    cell: (c) => {
      const d = Number(c.getValue() ?? 0);
      if (d >= 365) return <span className="font-semibold text-red-500">{num(d)}</span>;
      if (d >= 180) return <span className="text-amber-500">{num(d)}</span>;
      return num(d);
    },
  },
];

// ───────────────────────────────── 369 재고

export const materialInventoryColumns: ColumnDef<MaterialInventoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 150 },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 100 },
  {
    accessorKey: 'inventoryQty',
    header: '재고수량',
    size: 120,
    meta: right,
    // 안전재고보다 적으면 눈에 들어와야 한다. 음수는 입출고가 어긋난 자리다.
    cell: (c) => {
      const row = c.row.original as MaterialInventoryRow;
      const qty = Number(c.getValue() ?? 0);
      if (qty < 0) return <span className="font-semibold text-red-500">{num(qty)}</span>;
      const safety = Number(row.safetyInventory ?? 0);
      if (safety > 0 && qty < safety) {
        return <span className="text-amber-500">{num(qty)}</span>;
      }
      return num(qty);
    },
  },
  { accessorKey: 'safetyInventory', header: '안전재고', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryPrice', header: '재고단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'inventoryAmt', header: '재고금액', size: 140, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'inventoryHold', header: '보류', size: 80, meta: center },
  { accessorKey: 'inventoryStatus', header: '재고상태', size: 100, meta: center },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const materialInventorySummaryColumns: ColumnDef<MaterialInventorySummaryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'itemClass', header: '품목분류', size: 110 },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'inventoryStatus', header: '재고상태', size: 100, meta: center },
  {
    accessorKey: 'inventoryQty',
    header: '재고수량',
    size: 130,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'inventoryPrice', header: '재고단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'inventoryAmt', header: '재고금액', size: 150, meta: right, cell: (c) => money(c.getValue()) },
];

export const materialInventoryDailyColumns: ColumnDef<MaterialInventoryDailyRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 100 },
  { accessorKey: 'inventoryStatus', header: '재고상태', size: 100, meta: center },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'receiptQty', header: '당일 입고', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'issueQty', header: '당일 출고', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'workstageInventoryQty',
    // PB 와 집계 기준이 다르다 (품목+조직 합산). 머리글에 그 사실을 적는다.
    header: '공정재공 (품목합)',
    size: 140,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
];

export const materialDisusedColumns: ColumnDef<MaterialDisusedRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  { accessorKey: 'materialMfs', header: '자재 롯트', size: 150 },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 100 },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'issueQty',
    header: '기간 출고량',
    size: 120,
    meta: right,
    // 0 이면 그 기간에 한 번도 안 나갔다 — 불용 판정의 핵심이다.
    cell: (c) => {
      const q = Number(c.getValue() ?? 0);
      return q === 0
        ? <span className="font-semibold text-red-500">0</span>
        : num(q);
    },
  },
  { accessorKey: 'lastIssueDate', header: '마지막 출고', size: 120 },
  { accessorKey: 'inventoryPrice', header: '재고단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'inventoryAmt', header: '재고금액', size: 140, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'safetyInventory', header: '안전재고', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryHold', header: '보류', size: 80, meta: center },
  { accessorKey: 'inventoryStatus', header: '재고상태', size: 100, meta: center },
  { accessorKey: 'comments', header: '비고', size: 180 },
];

// ───────────────────────────────── 354·355 S-PARTS 입·출고

export const moldReceiptColumns: ColumnDef<MoldReceiptRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'receiptDate', header: '입고시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'receiptSequence', header: '순번', size: 80, meta: right },
  { accessorKey: 'moldCode', header: 'S-PARTS 코드', size: 140 },
  { accessorKey: 'moldName', header: 'S-PARTS 명', size: 180 },
  { accessorKey: 'moldSpec', header: '규격', size: 160 },
  { accessorKey: 'moldGroup', header: '그룹', size: 110 },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'invoiceNo', header: '전표번호', size: 130 },
  { accessorKey: 'orderNo', header: '발주번호', size: 130 },
  { accessorKey: 'receiptDeficit', header: '입출고', size: 80, meta: center },
  { accessorKey: 'receiptQty', header: '입고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'unitPrice', header: '단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'receiptAmt', header: '금액', size: 130, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'currency', header: '통화', size: 80, meta: center },
  { accessorKey: 'locationCode', header: '창고', size: 100 },
  { accessorKey: 'lineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'moldVersion', header: '버전', size: 90, meta: center },
  { accessorKey: 'moldSetSerial', header: '세트일련', size: 110 },
  { accessorKey: 'receiptStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const moldIssueColumns: ColumnDef<MoldIssueRow>[] = [
  { accessorKey: 'issueDate', header: '출고시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'issueSequence', header: '순번', size: 80, meta: right },
  { accessorKey: 'moldCode', header: 'S-PARTS 코드', size: 140 },
  { accessorKey: 'moldName', header: 'S-PARTS 명', size: 180 },
  { accessorKey: 'moldSpec', header: '규격', size: 160 },
  { accessorKey: 'moldGroup', header: '그룹', size: 110 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'issueDeficit', header: '입출고', size: 80, meta: center },
  { accessorKey: 'moldIssueAccount', header: '출고계정', size: 120 },
  { accessorKey: 'issueQty', header: '출고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'issuePrice', header: '단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'issueAmt', header: '금액', size: 130, meta: right, cell: (c) => money(c.getValue()) },
  { accessorKey: 'currency', header: '통화', size: 80, meta: center },
  { accessorKey: 'moldVersion', header: '버전', size: 90, meta: center },
  { accessorKey: 'moldSetSerial', header: '세트일련', size: 110 },
  { accessorKey: 'issueStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 357 지그

export const jigReportColumns: ColumnDef<JigReportRow>[] = [
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그 롯트', size: 140 },
  { accessorKey: 'barcodeText', header: '바코드', size: 160 },
  { accessorKey: 'jigName', header: '지그명', size: 180 },
  { accessorKey: 'jigSpec', header: '규격', size: 160 },
  { accessorKey: 'jigType', header: '지그유형', size: 110 },
  { accessorKey: 'jigStatus', header: '지그상태', size: 100, meta: center },
  { accessorKey: 'jigModelName', header: '지그모델', size: 150 },
  { accessorKey: 'useStatus', header: '사용상태', size: 100, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'nationCode', header: '국가', size: 80, meta: center },
  { accessorKey: 'acquisitionType', header: '취득구분', size: 100 },
  { accessorKey: 'acquisitionDate', header: '취득일', size: 110 },
  { accessorKey: 'breakValue', header: '한계값', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'hitValue',
    header: '타발수',
    size: 110,
    meta: right,
    // 한계값을 넘었으면 교체 대상이다.
    cell: (c) => {
      const row = c.row.original as JigReportRow;
      const hit = Number(c.getValue() ?? 0);
      const limit = Number(row.breakValue ?? 0);
      return limit > 0 && hit >= limit
        ? <span className="font-semibold text-red-500">{num(hit)}</span>
        : num(hit);
    },
  },
];

export const jigCardColumns: ColumnDef<JigCardRow>[] = [
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그 롯트', size: 140 },
  { accessorKey: 'jigName', header: '지그명', size: 180 },
  { accessorKey: 'jigType', header: '지그유형', size: 110 },
  { accessorKey: 'jigStatus', header: '지그상태', size: 100, meta: center },
  { accessorKey: 'jigModelName', header: '지그모델', size: 150 },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'acquisitionType', header: '취득구분', size: 100 },
  { accessorKey: 'acquisitionDate', header: '취득일', size: 110 },
  {
    accessorKey: 'repairSequence',
    header: '수리순번',
    size: 100,
    meta: right,
    // 수리 기록이 없는 지그도 남는다 (외부조인) — 그 사실이 정보다.
    cell: (c) => (c.getValue() == null
      ? <span className="text-text-muted">수리 없음</span>
      : num(c.getValue())),
  },
  { accessorKey: 'repairStatus', header: '수리상태', size: 100, meta: center },
  { accessorKey: 'repairReasonCode', header: '수리사유', size: 120 },
  { accessorKey: 'repairDate', header: '수리시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'repairTime', header: '수리시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'repairBy', header: '수리자', size: 100 },
  { accessorKey: 'repairComments', header: '수리내용', size: 220 },
];

export const jigIssueReportColumns: ColumnDef<JigIssueReportRow>[] = [
  { accessorKey: 'issueDate', header: '출고시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'issueSequence', header: '순번', size: 80, meta: right },
  { accessorKey: 'jigCode', header: '지그코드', size: 130 },
  { accessorKey: 'jigLotNo', header: '지그 롯트', size: 140 },
  { accessorKey: 'jigType', header: '지그유형', size: 110 },
  { accessorKey: 'jigStatus', header: '지그상태', size: 100, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'issueDeficit', header: '입출고', size: 80, meta: center },
  { accessorKey: 'issueAccount', header: '출고계정', size: 120 },
  { accessorKey: 'issueQty', header: '출고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'issueStatus', header: '상태', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 358 S-PARTS 관리

export const moldReportColumns: ColumnDef<MoldReportRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'moldCode', header: 'S-PARTS 코드', size: 140 },
  { accessorKey: 'moldName', header: 'S-PARTS 명', size: 180 },
  { accessorKey: 'moldSpec', header: '규격', size: 160 },
  { accessorKey: 'moldGroup', header: '그룹', size: 110 },
  { accessorKey: 'moldType', header: '유형', size: 100 },
  { accessorKey: 'barcodeText', header: '바코드', size: 150 },
  { accessorKey: 'drawingNo', header: '도면번호', size: 130 },
  { accessorKey: 'rawMaterial', header: '재질', size: 120 },
  { accessorKey: 'punchNo', header: '펀치번호', size: 110 },
  { accessorKey: 'moldLineType', header: '구매유형', size: 100, meta: center },
  { accessorKey: 'itemUnitQty', header: '단위수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'gasYn', header: '가스', size: 70, meta: center, cell: (c) => yesNo(c.getValue()) },
  { accessorKey: 'itemGasQty', header: '가스수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    id: 'supplierName',
    header: '협력사',
    size: 170,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'safetyInventory', header: '안전재고', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'orderLeadtime', header: '발주 L/T', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'moldVersion',
    header: '버전',
    size: 90,
    meta: center,
    // 재고 행이 없는 S-PARTS 도 남긴다 (외부조인) — 관리 리포트의 목적이다.
    cell: (c) => (c.getValue() == null
      ? <span className="text-text-muted">재고 없음</span>
      : String(c.getValue())),
  },
  { accessorKey: 'moldSetSerial', header: '세트일련', size: 110 },
  { accessorKey: 'moldSetQty', header: '세트수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'moldRowQty', header: '열수', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'moldUsefullRowQty', header: '사용가능 열', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'moldUseStatus', header: '사용상태', size: 100, meta: center },
  { accessorKey: 'locationCode', header: '위치', size: 100 },
  { accessorKey: 'moldWarehouseCode', header: '창고', size: 100 },
  { accessorKey: 'applyModelName', header: '적용모델', size: 150 },
  { accessorKey: 'breakValue', header: '한계값', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'actualValue',
    header: '실적값',
    size: 110,
    meta: right,
    cell: (c) => {
      const row = c.row.original as MoldReportRow;
      const actual = Number(c.getValue() ?? 0);
      const limit = Number(row.breakValue ?? 0);
      return limit > 0 && actual >= limit
        ? <span className="font-semibold text-red-500">{num(actual)}</span>
        : num(actual);
    },
  },
  { accessorKey: 'rentStatus', header: '대여상태', size: 100, meta: center },
  { accessorKey: 'lastReceiptDate', header: '마지막 입고', size: 120 },
  { accessorKey: 'lastIssueDate', header: '마지막 출고', size: 120 },
  { accessorKey: 'comments', header: '비고', size: 180 },
];

export const moldCardColumns: ColumnDef<MoldCardRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'moldCode', header: 'S-PARTS 코드', size: 140 },
  { accessorKey: 'moldName', header: 'S-PARTS 명', size: 180 },
  { accessorKey: 'moldSpec', header: '규격', size: 160 },
  { accessorKey: 'moldGroup', header: '그룹', size: 110 },
  { accessorKey: 'moldType', header: '유형', size: 100 },
  { accessorKey: 'moldVersion', header: '버전', size: 90, meta: center },
  { accessorKey: 'moldSetSerial', header: '세트일련', size: 110 },
  { accessorKey: 'moldRowQty', header: '열수', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'moldUsefullRowQty', header: '사용가능 열', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'moldUseStatus', header: '사용상태', size: 100, meta: center },
  { accessorKey: 'moldWarehouseCode', header: '창고', size: 100 },
  { accessorKey: 'breakValue', header: '한계값', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'actualValue', header: '실적값', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'rentSupplierCode', header: '대여 협력사', size: 130 },
  { accessorKey: 'lastReceiptDate', header: '마지막 입고', size: 120 },
  { accessorKey: 'lastAdjustDate', header: '마지막 조정', size: 120 },
  {
    accessorKey: 'repairSequence',
    header: '수리순번',
    size: 100,
    meta: right,
    cell: (c) => (c.getValue() == null
      ? <span className="text-text-muted">수리 없음</span>
      : num(c.getValue())),
  },
  { accessorKey: 'repairStatus', header: '수리상태', size: 100, meta: center },
  { accessorKey: 'repairReasonCode', header: '수리사유', size: 120 },
  { accessorKey: 'repairDate', header: '수리시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'repairTime', header: '수리시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'repairBy', header: '수리자', size: 100 },
  { accessorKey: 'repairComments', header: '수리내용', size: 220 },
  { accessorKey: 'comments', header: '비고', size: 180 },
];

// ───────────────────────────────── 360 4M 변경이력

export const fourMHistoryColumns: ColumnDef<FourMHistoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'modelName', header: '모델', size: 170 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 110 },
  { accessorKey: 'version', header: '버전', size: 100, meta: center },
  { accessorKey: 'hwVersion', header: 'H/W 버전', size: 130 },
  {
    accessorKey: 'swVersionOut',
    header: 'S/W 출력버전',
    size: 140,
    // 원천 표가 0행이라 항상 비어 있다. 빈 칸을 '값 없음' 으로 읽게 표시한다.
    cell: (c) => (c.getValue()
      ? String(c.getValue())
      : <span className="text-text-muted">기록 없음</span>),
  },
  {
    accessorKey: 'swVersionIn',
    header: 'S/W 입력버전',
    size: 140,
    cell: (c) => (c.getValue()
      ? String(c.getValue())
      : <span className="text-text-muted">기록 없음</span>),
  },
];
