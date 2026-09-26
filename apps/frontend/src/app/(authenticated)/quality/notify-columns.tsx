/**
 * @file src/app/(authenticated)/quality/notify-columns.tsx
 * @description 품질이상발생 · 품질알림 · 재고통제 · OQC 그리드 컬럼.
 *
 * 표시 규칙은 지그·S-PARTS 와 같은 것을 쓴다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '../jig/shared-format';

const right = { align: 'right' } as const;

/** PB d_qc_notify_lst */
export interface QcNotifyRow {
  actionDate: string;
  notifySequence: number;
  modelName: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  machineCode: string | null;
  itemCode: string | null;
  itemName: string | null;
  runNo: string | null;
  startTime: string | null;
  endTime: string | null;
  inspectQty: number | null;
  inspectBadQty: number | null;
  grade: string | null;
  gradeName: string | null;
  badReasonCode: string | null;
  badReasonName: string | null;
  detectLocation: string | null;
  detectLocationName: string | null;
  notifyStatus: string | null;
  notifyStatusName: string | null;
  completeYn: string | null;
  completeName: string | null;
  completeDate: string | null;
  materialMaker: string | null;
  locationInfo: string | null;
  badDescription: string | null;
  inspectCharger: string | null;
  inspectManager: string | null;
  departmentCode: string | null;
  lineStatusNotify: string | null;
  comments: string | null;
  qcComments: string | null;
  ngImageYn: string | null;
  inspectImageYn: string | null;
  documentImageYn: string | null;
  ngImageFileName: string | null;
  inspectImageFileName: string | null;
  documentImageFileName: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const qcNotifyColumns: ColumnDef<QcNotifyRow>[] = [
  { accessorKey: 'actionDate', header: '발생일자', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'notifySequence', header: '발생항번', size: 100, meta: right },
  { id: 'notifyStatusName', header: '조치상태', size: 110, accessorFn: (r) => codeWithName(r.notifyStatus, r.notifyStatusName) },
  { id: 'completeName', header: '완료', size: 110, accessorFn: (r) => codeWithName(r.completeYn, r.completeName) },
  { accessorKey: 'completeDate', header: '완료일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { id: 'lineName', header: '라인', size: 120, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { id: 'workstageName', header: '공정', size: 130, accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName) },
  { accessorKey: 'machineCode', header: '설비코드', size: 110 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 170 },
  { accessorKey: 'runNo', header: 'RUN번호', size: 140 },
  { id: 'gradeName', header: '등급', size: 90, accessorFn: (r) => codeWithName(r.grade, r.gradeName) },
  { id: 'badReasonName', header: '불량원인', size: 130, accessorFn: (r) => codeWithName(r.badReasonCode, r.badReasonName) },
  { id: 'detectLocationName', header: '발견장소', size: 120, accessorFn: (r) => codeWithName(r.detectLocation, r.detectLocationName) },
  { accessorKey: 'inspectQty', header: '검사수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inspectBadQty', header: '불량수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'startTime', header: '시작시각', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'endTime', header: '종료시각', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'materialMaker', header: '자재메이커', size: 130 },
  { accessorKey: 'locationInfo', header: '위치정보', size: 130 },
  { accessorKey: 'badDescription', header: '불량내용', size: 220 },
  { accessorKey: 'inspectCharger', header: '검사담당', size: 110 },
  { accessorKey: 'inspectManager', header: '검사책임', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'qcComments', header: 'QC 의견', size: 180 },
  {
    id: 'attach', header: '첨부', size: 110,
    // 첨부파일 자체는 이관 범위 밖이다. 어떤 종류가 있는지만 보여준다.
    accessorFn: (r) => [
      r.ngImageYn === 'Y' ? 'NG' : '',
      r.inspectImageYn === 'Y' ? '검사' : '',
      r.documentImageYn === 'Y' ? '문서' : '',
    ].filter(Boolean).join(',') || '-',
  },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** PB d_qc_eco_notify_lst (품목마스터 기준) */
export interface EcoNotifyRow {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  issuePackingQty: number | null;
  ecoCheckYn: string | null;
  ecoCheckComments: string | null;
  mslLevel: string | null;
  locationAddress: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const ecoNotifyColumns: ColumnDef<EcoNotifyRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 200 },
  { accessorKey: 'itemSpec', header: '규격', size: 170 },
  { accessorKey: 'itemUom', header: '단위', size: 80 },
  { accessorKey: 'ecoCheckYn', header: 'ECO 확인', size: 100 },
  { accessorKey: 'ecoCheckComments', header: 'ECO 설명', size: 250 },
  { accessorKey: 'modelName', header: '모델명', size: 170 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'issuePackingQty', header: '출고포장수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 80 },
  { accessorKey: 'locationAddress', header: '자재위치', size: 120 },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** 재고통제 대상 (IM_ITEM_INVENTORY + 통제여부) */
export interface InventoryHoldTargetRow {
  materialMfs: string;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  locationCode: string | null;
  lineType: string | null;
  inventoryQty: number | null;
  holdStatus: string | null;
  holdStatusName: string | null;
  holdingDate: string | null;
  holdComments: string | null;
  heldYn: string | null;
}

export const inventoryHoldTargetColumns: ColumnDef<InventoryHoldTargetRow>[] = [
  { accessorKey: 'heldYn', header: '통제', size: 80 },
  { accessorKey: 'materialMfs', header: '자재LOT', size: 180 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'inventoryQty', header: '재고수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'itemUom', header: '단위', size: 80 },
  { accessorKey: 'locationCode', header: '로케이션', size: 110 },
  { accessorKey: 'lineType', header: '거래유형', size: 100 },
  { id: 'holdStatusName', header: '통제상태', size: 110, accessorFn: (r) => codeWithName(r.holdStatus, r.holdStatusName) },
  { accessorKey: 'holdingDate', header: '통제일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'holdComments', header: '통제사유', size: 200 },
];

/** PB d_mat_inventory_4_lot_blocking */
export interface InventoryHoldRow {
  materialMfs: string;
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  inventoryStatus: string | null;
  inventoryStatusName: string | null;
  holdingDate: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const inventoryHoldColumns: ColumnDef<InventoryHoldRow>[] = [
  { accessorKey: 'materialMfs', header: '자재LOT', size: 180 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { id: 'inventoryStatusName', header: '통제상태', size: 110, accessorFn: (r) => codeWithName(r.inventoryStatus, r.inventoryStatusName) },
  { accessorKey: 'holdingDate', header: '통제일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'comments', header: '통제사유', size: 220 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** PB d_iq_oqc_insepct_history */
export interface OqcHistoryRow {
  inspectDate: string;
  inspectSequence: number;
  productId: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  itemName: string | null;
  defectCode: string | null;
  inspectType: string | null;
  inspectResult: string | null;
  inspectResultName: string | null;
  badReasonCode: string | null;
  badReasonName: string | null;
  badReasonDivision: string | null;
  badReasonResult: string | null;
  inspectQty: number | null;
  defectQty: number | null;
  inspector: string | null;
  inspectorName: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const oqcHistoryColumns: ColumnDef<OqcHistoryRow>[] = [
  { accessorKey: 'inspectDate', header: '검사일시', size: 160, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'inspectSequence', header: '검사항번', size: 100, meta: right },
  { accessorKey: 'productId', header: 'PID', size: 190 },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { id: 'inspectResultName', header: '판정', size: 100, accessorFn: (r) => codeWithName(r.inspectResult, r.inspectResultName) },
  { id: 'badReasonName', header: '불량원인', size: 130, accessorFn: (r) => codeWithName(r.badReasonCode, r.badReasonName) },
  { accessorKey: 'badReasonDivision', header: '원인구분', size: 110 },
  { accessorKey: 'badReasonResult', header: '원인결과', size: 110 },
  { accessorKey: 'defectCode', header: '결함코드', size: 120 },
  { accessorKey: 'inspectType', header: '검사유형', size: 110 },
  { accessorKey: 'inspectQty', header: '검사수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'defectQty', header: '결함수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inspector', header: '검사자', size: 100 },
  { accessorKey: 'inspectorName', header: '검사자명', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** PB d_prd_cell_biz_pack_4_oqc_master — 매거진 포장 단위 검사대상 */
export interface OqcLotRow {
  packBarcode: string;
  packType: string | null;
  packTypeName: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  partNo: string | null;
  runNo: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  packDate: string | null;
  packingPcsQty: number | null;
  packQty: number | null;
  completeFlag: string | null;
  printFlag: string | null;
  boxingFlag: string | null;
  palletFlag: string | null;
  shipFlag: string | null;
  receiptFlag: string | null;
  boxNo: string | null;
  palletNo: string | null;
  shipNo: string | null;
  receiptNo: string | null;
  boxingDate: string | null;
  palletDate: string | null;
  shipDate: string | null;
  receiptDate: string | null;
  customerCode: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export const oqcLotColumns: ColumnDef<OqcLotRow>[] = [
  { accessorKey: 'packDate', header: '포장일시', size: 160, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'packBarcode', header: '포장바코드', size: 190 },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'partNo', header: '품번', size: 140 },
  { accessorKey: 'runNo', header: 'RUN번호', size: 140 },
  { id: 'lineName', header: '라인', size: 120, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { id: 'workstageName', header: '공정', size: 130, accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName) },
  { accessorKey: 'packQty', header: '포장수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'packingPcsQty', header: '개별수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'completeFlag', header: '완료', size: 80 },
  { accessorKey: 'boxingFlag', header: '박스', size: 80 },
  { accessorKey: 'palletFlag', header: '팔레트', size: 80 },
  { accessorKey: 'shipFlag', header: '출하', size: 80 },
  { accessorKey: 'receiptFlag', header: '입고', size: 80 },
  { accessorKey: 'boxNo', header: 'BOX번호', size: 140 },
  { accessorKey: 'palletNo', header: '팔레트번호', size: 140 },
  { accessorKey: 'shipNo', header: '출하번호', size: 140 },
  { accessorKey: 'shipDate', header: '출하일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'customerCode', header: '고객코드', size: 110 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];
