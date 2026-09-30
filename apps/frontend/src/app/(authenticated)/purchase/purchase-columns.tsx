/**
 * @file src/app/(authenticated)/purchase/purchase-columns.tsx
 * @description 자재 구매·발주 행 타입 + 그리드 컬럼 — 480·481·483·484.
 *
 * 코드값은 전부 공통코드 실측이다. 화면에는 코드가 아니라 **뜻**이 보인다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { comCodeCell } from '@/components/shared/codeCells';
import { num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;
const ts = (value: unknown) => (value ? String(value) : '');

/** 공통코드 `CONFIRM YN`. */
export const CONFIRM_NAME: Record<string, string> = {
  N: '아니오', W: '대기', Y: '확정',
};
/** 공통코드 `ARRIVAL TYPE`. */
export const ARRIVAL_TYPE_NAME: Record<string, string> = {
  D: '출발', A: '도착', R: '입고',
};
/** 공통코드 `ARRIVAL STATUS`. */
export const ARRIVAL_STATUS_NAME: Record<string, string> = {
  N: '정상', C: '취소',
};

/**
 * 라벨만 보여 주는 코드 컬럼은 정적 맵을 두지 않는다. 화면에 적어 두면 기준정보가
 * 늘었을 때 조용히 어긋난다 (`ORDER TYPE`·`LINE TYPE` 은 실제로 11개다).
 * 공용 `comCodeCell` 이 ISYS_BASECODE 에서 그때그때 읽는다.
 * 아래 CONFIRM/ARRIVAL 맵은 색까지 바꿔야 해서 남긴다 — 코드 수가 DB 와 같다.
 */

// ───────────────────────────────── 480·481 주문

export interface PurchaseOrderRow {
  orderNo: string;
  orderGroupNo: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  orderType: string | null;
  orderQty: number | null;
  arrivalQty: number | null;
  remainQty: number | null;
  unitPrice: number | null;
  orderAmt: number | null;
  currency: string | null;
  delivery: string | null;
  deliveryMethod: string | null;
  deliveryPlace: string | null;
  originNationCode: string | null;
  incidentalExpenseCode: string | null;
  mfs: string | null;
  materialMfs: string | null;
  shipmentComment: string | null;
  attnName: string | null;
  ccName: string | null;
  enterBy: string | null;
  purchaseOrderDate: string | null;
  deliveryDate: string | null;
  enterDate: string | null;
  /** 480 주문예정에만 있다. */
  confirmYn?: string | null;
  confirmBy?: string | null;
  confirmDate?: string | null;
}

export interface PurchaseOrderGroupRow {
  orderGroupNo: string;
  supplierCode: string | null;
  supplierName: string | null;
  orderDateFrom: string | null;
  orderDateTo: string | null;
  orderCount: number | null;
  orderQty: number | null;
  arrivalQty: number | null;
  orderAmt: number | null;
}

/** 주문·예정이 함께 쓰는 앞부분 컬럼. */
const orderBaseColumns: ColumnDef<PurchaseOrderRow>[] = [
  { accessorKey: 'orderNo', header: '주문번호', size: 120 },
  { accessorKey: 'orderGroupNo', header: '발주그룹', size: 120 },
  { accessorKey: 'supplierName', header: '협력사', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'orderQty',
    header: '주문수량',
    size: 110,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  {
    accessorKey: 'arrivalQty',
    header: '도착수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'remainQty',
    header: '잔량',
    size: 100,
    meta: right,
    cell: (c) => {
      const v = Number(c.getValue() ?? 0);
      return v > 0
        ? <span className="font-medium text-amber-500">{num(v)}</span>
        : <span className="text-text-muted">{num(v)}</span>;
    },
  },
  {
    accessorKey: 'unitPrice',
    header: '단가',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'orderAmt',
    header: '금액',
    size: 130,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'currency', header: '통화', size: 80, meta: center },
  {
    accessorKey: 'orderType',
    header: '주문구분',
    size: 110,
    cell: comCodeCell<PurchaseOrderRow>('ORDER TYPE'),
  },
  {
    accessorKey: 'lineType',
    header: '거래구분',
    size: 110,
    cell: comCodeCell<PurchaseOrderRow>('LINE TYPE'),
  },
  {
    accessorKey: 'purchaseOrderDate',
    header: '주문일',
    size: 110,
    cell: (c) => ts(c.getValue()),
  },
  {
    accessorKey: 'deliveryDate',
    header: '납기일',
    size: 110,
    cell: (c) => ts(c.getValue()),
  },
];

export const purchaseOrderColumns: ColumnDef<PurchaseOrderRow>[] = [
  ...orderBaseColumns,
  {
    accessorKey: 'deliveryMethod',
    header: '운송',
    size: 90,
    cell: comCodeCell<PurchaseOrderRow>('DELIVERY METHOD'),
  },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
];

export const forecastOrderColumns: ColumnDef<PurchaseOrderRow>[] = [
  {
    accessorKey: 'confirmYn',
    header: '승인',
    size: 90,
    meta: center,
    cell: (c) => {
      const code = String(c.getValue() ?? 'N');
      const tone = code === 'Y'
        ? 'text-emerald-500'
        : code === 'W' ? 'text-amber-500' : 'text-text-muted';
      return <span className={`font-medium ${tone}`}>{CONFIRM_NAME[code] ?? code}</span>;
    },
  },
  ...orderBaseColumns,
  { accessorKey: 'confirmBy', header: '승인자', size: 100 },
  {
    accessorKey: 'confirmDate',
    header: '승인일시',
    size: 160,
    cell: (c) => ts(c.getValue()),
  },
];

export const purchaseOrderGroupColumns: ColumnDef<PurchaseOrderGroupRow>[] = [
  { accessorKey: 'orderGroupNo', header: '발주그룹', size: 140 },
  { accessorKey: 'supplierName', header: '협력사', size: 170 },
  {
    accessorKey: 'orderCount',
    header: '건수',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'orderQty',
    header: '주문수량',
    size: 120,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'arrivalQty',
    header: '도착수량',
    size: 120,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'orderAmt',
    header: '금액',
    size: 140,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'orderDateFrom', header: '시작', size: 110, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'orderDateTo', header: '끝', size: 110, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 483·484 출발·도착

export interface ArrivalRow {
  arrivalDate: string | null;
  arrivalSeqNo: number;
  arrivalType: string | null;
  arrivalStatus: string | null;
  arrivalQty: number | null;
  orderNo: string | null;
  orderGroupNo: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  lineType: string | null;
  unitPrice: number | null;
  currency: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  orderQty: number | null;
  enterBy: string | null;
  departureDate: string | null;
  enterDate: string | null;
}

export interface OrderForArrivalRow {
  orderNo: string;
  orderGroupNo: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  orderQty: number | null;
  unitPrice: number | null;
  currency: string | null;
  pendingQty: number | null;
  remainQty: number | null;
  purchaseOrderDate: string | null;
  deliveryDate: string | null;
}

export const arrivalColumns: ColumnDef<ArrivalRow>[] = [
  {
    accessorKey: 'arrivalSeqNo',
    header: '순번',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'arrivalType',
    header: '단계',
    size: 90,
    meta: center,
    cell: (c) => {
      const code = String(c.getValue() ?? '');
      const tone = code === 'A'
        ? 'text-emerald-500'
        : code === 'R' ? 'text-blue-500' : 'text-amber-500';
      return (
        <span className={`font-medium ${tone}`}>
          {ARRIVAL_TYPE_NAME[code] ?? code}
        </span>
      );
    },
  },
  {
    accessorKey: 'arrivalStatus',
    header: '상태',
    size: 80,
    meta: center,
    cell: (c) => (String(c.getValue() ?? 'N') === 'C'
      ? <span className="font-medium text-red-500">취소</span>
      : <span className="text-text-muted">정상</span>),
  },
  { accessorKey: 'orderNo', header: '주문번호', size: 120 },
  { accessorKey: 'supplierName', header: '협력사', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  {
    accessorKey: 'arrivalQty',
    header: '수량',
    size: 110,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  {
    accessorKey: 'orderQty',
    header: '주문수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'departureDate',
    header: '출발일',
    size: 110,
    cell: (c) => ts(c.getValue()),
  },
  {
    accessorKey: 'arrivalDate',
    header: '도착일',
    size: 110,
    cell: (c) => ts(c.getValue()),
  },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
];

export const orderForArrivalColumns: ColumnDef<OrderForArrivalRow>[] = [
  { accessorKey: 'orderNo', header: '주문번호', size: 120 },
  { accessorKey: 'supplierName', header: '협력사', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  {
    accessorKey: 'orderQty',
    header: '주문수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'pendingQty',
    header: '잡힌수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'remainQty',
    header: '잔량',
    size: 110,
    meta: right,
    cell: (c) => <span className="font-semibold text-amber-500">{num(c.getValue())}</span>,
  },
  {
    accessorKey: 'deliveryDate',
    header: '납기일',
    size: 110,
    cell: (c) => ts(c.getValue()),
  },
];

// ───────────────────────────────── 477 소요량

export interface MasterPlanRow {
  requirementPlanDate: string | null;
  requirementPlanSeq: number | null;
  planDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  orderQty: number | null;
  totalInventoryQty: number | null;
  inventoryQty: number | null;
  safetyInventoryQty: number | null;
  applyYn: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export interface RequirementRow {
  requirementPlanDate: string | null;
  planDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  requirementQty: number | null;
  setItemCode: string | null;
  parentItemCode: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export interface RequirementMatrixRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  totalQty: number;
  qtyByDate: Record<string, number>;
}

export const masterPlanColumns: ColumnDef<MasterPlanRow>[] = [
  { accessorKey: 'planDate', header: '계획일', size: 110, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 200 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  {
    accessorKey: 'orderQty',
    header: '주문수량',
    size: 110,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  {
    accessorKey: 'totalInventoryQty',
    header: '총재고',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'inventoryQty',
    header: '가용재고',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'safetyInventoryQty',
    header: '안전재고',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'applyYn', header: '적용', size: 70, meta: center },
  { accessorKey: 'enterBy', header: '작성자', size: 100 },
];

export const requirementColumns: ColumnDef<RequirementRow>[] = [
  { accessorKey: 'planDate', header: '계획일', size: 110, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 200 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  {
    accessorKey: 'lineType',
    header: '거래유형',
    size: 110,
    cell: comCodeCell<RequirementRow>('LINE TYPE'),
  },
  { accessorKey: 'supplierName', header: '공급처', size: 170 },
  {
    accessorKey: 'requirementQty',
    header: '소요량',
    size: 120,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 150 },
];

// ───────────────────────────────── 478 발주계획

export interface OrderPlanRow {
  itemCode: string | null;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  orderNo: string | null;
  purchaseOrderDate: string | null;
  deliveryDate: string | null;
  orderQty: number | null;
  inventoryQty: number | null;
  totalInventoryQty: number | null;
  purchaseOrderQty: number | null;
  arrivalQty: number | null;
  unitPrice: number | null;
  orderAmt: number | null;
  currency: string | null;
  delivery: string | null;
  purchaseOrderStatus: string | null;
  mfs: string | null;
  enterBy: string | null;
  enterDate: string | null;
}

export interface RequirementOrderRow {
  requirementPlanDate: string | null;
  planDate: string | null;
  itemCode: string | null;
  itemName: string | null;
  itemUom: string | null;
  lineType: string | null;
  supplierCode: string | null;
  supplierName: string | null;
  mfs: string | null;
  requirementQty: number | null;
}

export const orderPlanColumns: ColumnDef<OrderPlanRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  {
    accessorKey: 'lineType',
    header: '거래유형',
    size: 110,
    cell: comCodeCell<OrderPlanRow>('LINE TYPE'),
  },
  { accessorKey: 'supplierName', header: '협력사', size: 160 },
  { accessorKey: 'deliveryDate', header: '납기', size: 110, cell: (c) => ts(c.getValue()) },
  {
    accessorKey: 'orderQty',
    header: '소요량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'inventoryQty',
    header: '차감재고',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'purchaseOrderQty',
    header: '발주량',
    size: 120,
    meta: right,
    cell: (c) => {
      const value = Number(c.getValue() ?? 0);
      return (
        <span className={value > 0 ? 'font-semibold text-primary' : 'text-text-muted'}>
          {num(value)}
        </span>
      );
    },
  },
  {
    accessorKey: 'unitPrice',
    header: '단가',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'orderAmt',
    header: '금액',
    size: 130,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'currency', header: '통화', size: 80, meta: center },
  { accessorKey: 'orderNo', header: '계획번호', size: 150 },
];

export const requirementOrderColumns: ColumnDef<RequirementOrderRow>[] = [
  { accessorKey: 'planDate', header: '계획일', size: 110, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemUom', header: '단위', size: 70, meta: center },
  {
    accessorKey: 'lineType',
    header: '거래유형',
    size: 110,
    cell: comCodeCell<RequirementOrderRow>('LINE TYPE'),
  },
  { accessorKey: 'supplierName', header: '공급처', size: 160 },
  {
    accessorKey: 'requirementQty',
    header: '소요량',
    size: 120,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
];
