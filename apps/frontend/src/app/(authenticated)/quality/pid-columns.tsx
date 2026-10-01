/**
 * @file src/app/(authenticated)/quality/pid-columns.tsx
 * @description PID 홀딩 · PCB 이슈스캔 · IQC 이력등록 그리드 컬럼.
 *
 * 표시 규칙은 지그·S-PARTS 와 같은 것을 쓴다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;

/** PB d_pln_product_2d_barcode_4_holding */
export interface PidHoldingRow {
  serialNo: string;
  runNo: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  itemName: string | null;
  lineCode: string | null;
  lineName: string | null;
  magazineNo: string | null;
  boxNo: string | null;
  barcodeStatus: string | null;
  barcodeStatusName: string | null;
  actualDate: string | null;
  shiftCode: string | null;
  receiptDate: string | null;
  shippingDate: string | null;
  shippingDeficit: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const pidHoldingColumns: ColumnDef<PidHoldingRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'serialNo', header: 'PID', size: 190 },
  { id: 'barcodeStatusName', header: '바코드상태', size: 110, accessorFn: (r) => codeWithName(r.barcodeStatus, r.barcodeStatusName) },
  { accessorKey: 'runNo', header: 'RUN번호', size: 150 },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { id: 'lineName', header: '라인', size: 120, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { accessorKey: 'magazineNo', header: '매거진번호', size: 140 },
  { accessorKey: 'boxNo', header: 'BOX번호', size: 140 },
  { accessorKey: 'actualDate', header: '생산일자', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'shiftCode', header: '교대', size: 80 },
  { accessorKey: 'receiptDate', header: '입고일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'shippingDate', header: '출하일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'shippingDeficit', header: '출하구분', size: 90 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** PB d_qc_pid_issue_scan_hist / _lst */
export interface PidIssueScanRow {
  serialNo: string;
  scanDate: string | null;
  pidIssueType: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  itemName: string | null;
  lineCode: string | null;
  lineName?: string | null;
  location: string | null;
  cleanCharger: string | null;
  inspectCharger: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy?: string | null;
  lastModifyDate?: string | null;
}

export const pidIssueScanColumns: ColumnDef<PidIssueScanRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'scanDate', header: '스캔일시', size: 160, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'serialNo', header: 'PID', size: 190 },
  { accessorKey: 'pidIssueType', header: '이슈유형', size: 120 },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { id: 'lineName', header: '라인', size: 120, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { accessorKey: 'location', header: '위치', size: 130 },
  { accessorKey: 'cleanCharger', header: '세척담당', size: 110 },
  { accessorKey: 'inspectCharger', header: '검사담당', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** PB d_iq_iqc_insepct_history / _summary_history */
export interface IqcInspectHistoryRow {
  inspectDate: string;
  /** 수정·삭제가 쓰는 불투명 키 (YYYYMMDDHH24MISS). 검사일시를 ISO 로 왕복시키면 시간대가 밀린다. */
  inspectDateKey: string;
  inspectSequence: number;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemClass: string | null;
  itemClassName: string | null;
  lotNo: string | null;
  defectCode: string | null;
  inspectType: string | null;
  inspectResult: string | null;
  inspectResultName: string | null;
  badReasonCode: string | null;
  badReasonName: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  shiftCode: string | null;
  inspectQty: number | null;
  defectQty: number | null;
  inspector: string | null;
  inspectorName: string | null;
  comments: string | null;
  attribute01: string | null;
  attribute02: string | null;
  attribute03: string | null;
  attribute04: string | null;
  attribute05: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const iqcInspectHistoryColumns: ColumnDef<IqcInspectHistoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'inspectDate', header: '검사일시', size: 160, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'inspectSequence', header: '검사항번', size: 100, meta: right },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { id: 'itemClassName', header: '품목분류', size: 130, accessorFn: (r) => codeWithName(r.itemClass, r.itemClassName) },
  { accessorKey: 'lotNo', header: 'LOT번호', size: 140 },
  { accessorKey: 'inspectType', header: '검사유형', size: 110 },
  { id: 'inspectResultName', header: '판정', size: 100, accessorFn: (r) => codeWithName(r.inspectResult, r.inspectResultName) },
  { id: 'badReasonName', header: '불량원인', size: 130, accessorFn: (r) => codeWithName(r.badReasonCode, r.badReasonName) },
  { accessorKey: 'defectCode', header: '결함코드', size: 120 },
  { accessorKey: 'inspectQty', header: '검사수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'defectQty', header: '결함수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { id: 'supplierName', header: '공급처', size: 150, accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName) },
  { accessorKey: 'shiftCode', header: '교대', size: 80 },
  { accessorKey: 'inspector', header: '검사자', size: 100 },
  { accessorKey: 'inspectorName', header: '검사자명', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
