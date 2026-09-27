/**
 * @file src/app/(authenticated)/report/report-columns.tsx
 * @description 리포트 A그룹 그리드 컬럼.
 *
 * 표시 규칙은 다른 대분류와 같다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 * 시각 문자열은 서버가 만들어 보낸 것을 그대로 쓴다 (new Date() 로 다시 파싱하지 않는다 —
 * UTC 로 해석돼 9시간 틀어진다).
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import type {
  CarrierBarcodeRow,
  FgIssueDetailRow,
  FgIssueSummaryRow,
  ItemMasterRow,
  LineBarcodeRow,
  MachineOperationRow,
  MachineRow,
  MagazineStockRow,
  MasterPlanRow,
  PickupAmountRow,
  PickupDetailRow,
  RunCardReportRow,
  RunCardSummaryRow,
  WorkstageStockRow,
} from './report-types';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;

const ts = (value: unknown) => (value ? String(value) : '');
const yn = (value: unknown) => (value ? String(value) : '');
/** 금액은 소수점을 버리고 천단위만 보여준다 — 리포트에서 소수는 읽기를 방해한다. */
const money = (value: unknown) =>
  value == null ? '' : Math.round(Number(value)).toLocaleString();

/**
 * 단가는 **반올림하지 않는다.** SMT 부품 단가에는 1 미만이 흔해서
 * (30일치 픽업 19,595건 중 854건이 1 미만 · 3,430건이 소수 — 실측)
 * 금액과 같은 규칙으로 찍으면 그 단가가 전부 `0` 으로 보인다.
 * 소수는 최대 4자리까지 두고 뒤의 0 은 붙이지 않는다.
 */
const unitPrice = (value: unknown) =>
  value == null
    ? ''
    : Number(value).toLocaleString(undefined, { maximumFractionDigits: 4 });

// ───────────────────────────────── 338 품목마스터리포트

/** 유효기간 상태는 계산값이다. 만료된 품목이 눈에 들어와야 한다. */
const STATUS_LABEL: Record<string, string> = {
  RUNNING: '적용중',
  FUTURE: '적용전',
  EXPIRED: '만료',
};

export const itemMasterColumns: ColumnDef<ItemMasterRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 200 },
  { accessorKey: 'itemSpec', header: '규격', size: 180 },
  {
    accessorKey: 'status',
    header: '유효기간',
    size: 100,
    meta: center,
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      const label = STATUS_LABEL[v] ?? v;
      if (v === 'EXPIRED') return <span className="font-semibold text-red-500">{label}</span>;
      if (v === 'FUTURE') return <span className="text-amber-500">{label}</span>;
      return label;
    },
  },
  { accessorKey: 'dateSet', header: '적용시작', size: 110 },
  { accessorKey: 'dateEnd', header: '적용종료', size: 110 },
  { accessorKey: 'itemUom', header: '단위', size: 80, meta: center },
  {
    id: 'itemTypeName',
    header: '품목유형',
    size: 130,
    accessorFn: (r) => codeWithName(r.itemType, r.itemTypeName),
  },
  {
    id: 'itemClassName',
    header: '품목분류',
    size: 130,
    accessorFn: (r) => codeWithName(r.itemClass, r.itemClassName),
  },
  {
    id: 'lineTypeName',
    header: '구매유형',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineType, r.lineTypeName),
  },
  { accessorKey: 'itemDivision', header: '품목구분', size: 100 },
  { accessorKey: 'setItemYn', header: 'SET', size: 70, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'abcGrade', header: 'ABC', size: 70, meta: center },
  { accessorKey: 'barcode', header: '바코드', size: 150 },
  { accessorKey: 'partNo', header: 'PART NO', size: 130 },
  { accessorKey: 'drawingNo', header: '도면번호', size: 130 },
  { accessorKey: 'specialProperty', header: '특성', size: 120 },
  { accessorKey: 'width', header: '가로', size: 80, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'height', header: '높이', size: 80, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'weight', header: '중량', size: 80, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'innerDiameter', header: '내경', size: 80, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'outerDiameter', header: '외경', size: 80, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 340 라인설비바코드

export const lineBarcodeColumns: ColumnDef<LineBarcodeRow>[] = [
  { accessorKey: 'barcodeText', header: '바코드', size: 170 },
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'machine', header: '설비', size: 120 },
  { accessorKey: 'machineName', header: '설비명', size: 180 },
  { accessorKey: 'machineType', header: '설비유형', size: 110 },
  { accessorKey: 'machineModelName', header: '설비모델', size: 160 },
  { accessorKey: 'useStatus', header: '사용상태', size: 100, meta: center },
];

// ───────────────────────────────── 341 캐리어바코드

export const carrierBarcodeColumns: ColumnDef<CarrierBarcodeRow>[] = [
  { accessorKey: 'serialNo', header: '바코드', size: 220 },
  { accessorKey: 'labelText', header: '라벨문자', size: 220 },
  { accessorKey: 'enterBy', header: '발행자', size: 100 },
  { accessorKey: 'enterDate', header: '발행일시', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 100 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 343 설비리포트

export const machineColumns: ColumnDef<MachineRow>[] = [
  { accessorKey: 'machineCode', header: '설비코드', size: 130 },
  { accessorKey: 'machineName', header: '설비명', size: 180 },
  {
    id: 'machineTypeName',
    header: '설비유형',
    size: 130,
    accessorFn: (r) => codeWithName(r.machineType, r.machineTypeName),
  },
  { accessorKey: 'machineModelName', header: '설비모델', size: 170 },
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'capacity', header: '능력', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'reservedCapacity', header: '예비능력', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'useStatus', header: '사용상태', size: 100, meta: center },
  {
    id: 'customerName',
    header: '고객',
    size: 150,
    accessorFn: (r) => codeWithName(r.customerCode, r.customerName),
  },
  { accessorKey: 'acquisitionType', header: '취득구분', size: 100 },
  { accessorKey: 'acquisitionDate', header: '취득일', size: 110 },
  { accessorKey: 'nationCode', header: '국가', size: 80, meta: center },
  { accessorKey: 'manualLocationComment', header: '위치메모', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const machineOperationColumns: ColumnDef<MachineOperationRow>[] = [
  { accessorKey: 'machineCode', header: '설비코드', size: 130 },
  { accessorKey: 'machineName', header: '설비명', size: 180 },
  { accessorKey: 'machineType', header: '설비유형', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  {
    accessorKey: 'planDate',
    header: '가동일',
    size: 110,
    // 기록이 없는 설비는 비어 있다 (외부조인으로 남겨 뒀다) — 그 사실이 정보다.
    cell: (c) => (c.getValue()
      ? String(c.getValue())
      : <span className="text-text-muted">기록 없음</span>),
  },
  { accessorKey: 'startTime', header: '시작', size: 90, meta: center },
  { accessorKey: 'endTime', header: '종료', size: 90, meta: center },
  {
    accessorKey: 'totalOperationTime',
    header: '총 가동시간',
    size: 120,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'machineStatusCode', header: '상태', size: 90, meta: center },
];

// ───────────────────────────────── 344 SMT PICKUP 리포트

export const pickupDetailColumns: ColumnDef<PickupDetailRow>[] = [
  { accessorKey: 'actualDate', header: '실적일', size: 110 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'programName', header: '프로그램', size: 150 },
  { accessorKey: 'tableNo', header: '테이블', size: 90 },
  { accessorKey: 'address', header: '주소', size: 90 },
  { accessorKey: 'subAddress', header: '보조주소', size: 100 },
  { accessorKey: 'feederZaxis', header: 'Z축', size: 80 },
  { accessorKey: 'feederLraxis', header: 'LR축', size: 80 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'abcGrade', header: 'ABC', size: 70, meta: center },
  { accessorKey: 'purUnitPrice', header: '구매단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  { accessorKey: 'takeupQty', header: '집어올림', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'missQty',
    header: '미스',
    size: 90,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n > 0 ? <span className="text-amber-500">{num(c.getValue())}</span> : num(c.getValue());
    },
  },
  { accessorKey: 'recogQty', header: '인식오류', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'missAmount',
    header: '미스 금액',
    size: 130,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n > 0
        ? <span className="font-semibold text-red-500">{money(c.getValue())}</span>
        : money(c.getValue());
    },
  },
  { accessorKey: 'createBy', header: '생성자', size: 100 },
];

export const pickupAmountColumns: ColumnDef<PickupAmountRow>[] = [
  { accessorKey: 'actualDate', header: '실적일', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'takeupQty', header: '집어올림', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'missQty', header: '미스', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'recogQty', header: '인식오류', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'ppm',
    header: 'PPM',
    size: 100,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n >= 10000
        ? <span className="font-semibold text-red-500">{num(c.getValue())}</span>
        : num(c.getValue());
    },
  },
  {
    accessorKey: 'missAmount',
    header: '미스 금액',
    size: 140,
    meta: right,
    cell: (c) => <span className="font-semibold">{money(c.getValue())}</span>,
  },
];

// ───────────────────────────────── 346 생산계획리포트

/** 시간대 10칸은 고정이다 (생산 대분류의 MI/SMD 계획과 같은 구조). */
export const masterPlanColumns: ColumnDef<MasterPlanRow>[] = [
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'mfs', header: 'MFS', size: 110 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  {
    id: 'customerName',
    header: '고객',
    size: 150,
    accessorFn: (r) => codeWithName(r.customerCode, r.customerName),
  },
  ...Array.from({ length: 10 }, (_, i) => {
    const key = `slot${String(i + 1).padStart(2, '0')}` as keyof MasterPlanRow;
    return {
      accessorKey: key,
      header: `${i + 1}시간대`,
      size: 95,
      meta: right,
      cell: (c: { getValue: () => unknown }) => {
        const n = Number(c.getValue() ?? 0);
        return n === 0 ? <span className="text-text-muted/50">0</span> : num(c.getValue());
      },
    } as ColumnDef<MasterPlanRow>;
  }),
  {
    accessorKey: 'planQty',
    header: '계획합계',
    size: 110,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
];

// ───────────────────────────────── 347 런카드리포트

export const runCardReportColumns: ColumnDef<RunCardReportRow>[] = [
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'runDate', header: '지시일', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'markingNo', header: '마킹번호', size: 110 },
  { accessorKey: 'lotSize', header: '롯트수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    id: 'runStatusName',
    header: '진행상태',
    size: 120,
    accessorFn: (r) => codeWithName(r.runStatus, r.runStatusName),
  },
  {
    id: 'productRunTypeName',
    header: '생산유형',
    size: 120,
    accessorFn: (r) => codeWithName(r.productRunType, r.productRunTypeName),
  },
  { accessorKey: 'kittingDate', header: '키팅시각', size: 160, cell: (c) => ts(c.getValue()) },
];

/**
 * 런카드 합계 컬럼.
 * @param withQty 수량 3종을 켰는지. 끄면 그 열을 아예 내지 않는다 —
 *                빈 열을 보여 주면 '0장' 으로 오해한다.
 */
export function runCardSummaryColumns(withQty: boolean): ColumnDef<RunCardSummaryRow>[] {
  const cols: ColumnDef<RunCardSummaryRow>[] = [
    { accessorKey: 'runDate', header: '지시일', size: 110 },
    {
      id: 'lineName',
      header: '라인',
      size: 130,
      accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
    },
    { accessorKey: 'modelName', header: '모델', size: 150 },
    { accessorKey: 'itemCode', header: '품목코드', size: 150 },
    { accessorKey: 'itemName', header: '품목명', size: 180 },
    { accessorKey: 'markingNo', header: '마킹번호', size: 110 },
    {
      id: 'productRunTypeName',
      header: '생산유형',
      size: 120,
      accessorFn: (r) => codeWithName(r.productRunType, r.productRunTypeName),
    },
    { accessorKey: 'runCardCount', header: '런카드 수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
    { accessorKey: 'lotSize', header: '롯트수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  ];
  if (withQty) {
    cols.push(
      { accessorKey: 'labelQty', header: '라벨수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'inputQty', header: '투입수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'outputQty', header: '산출수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
    );
  }
  return cols;
}

// ───────────────────────────────── 348 제품 판매실적

export const fgIssueDetailColumns: ColumnDef<FgIssueDetailRow>[] = [
  { accessorKey: 'issueDate', header: '출하시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'barcode', header: '제품 바코드', size: 170 },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  {
    accessorKey: 'qty',
    header: '수량 (부호)',
    size: 110,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n < 0
        ? <span className="font-semibold text-red-500">{num(c.getValue())}</span>
        : num(c.getValue());
    },
  },
  { accessorKey: 'issuePrice', header: '단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
  {
    accessorKey: 'txnDeficit',
    header: '구분',
    size: 100,
    meta: center,
    // 3 출고 · 4 출고취소 (현재 데이터에 쓰이는 두 값 — 실측)
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      if (v === '3') return '출고';
      if (v === '4') return <span className="text-red-500">출고취소</span>;
      return v;
    },
  },
  {
    id: 'customerName',
    header: '고객',
    size: 160,
    accessorFn: (r) => codeWithName(r.customerCode, r.customerName),
  },
  { accessorKey: 'locationCode', header: '위치', size: 110 },
  { accessorKey: 'packType', header: '포장', size: 90 },
  { accessorKey: 'palletNo', header: '파렛트', size: 110 },
  { accessorKey: 'palletDate', header: '파렛트시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'shipNo', header: '출하번호', size: 120 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'mfs', header: 'MFS', size: 110 },
  { accessorKey: 'actualDate', header: '실적일', size: 110 },
  { accessorKey: 'shiftCode', header: '교대', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];

export const fgIssueSummaryColumns: ColumnDef<FgIssueSummaryRow>[] = [
  { accessorKey: 'modelName', header: '모델', size: 160 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
  {
    id: 'customerName',
    header: '고객',
    size: 180,
    accessorFn: (r) => codeWithName(r.customerCode, r.customerName),
  },
  { accessorKey: 'locationCode', header: '위치', size: 110 },
  { accessorKey: 'issueCount', header: '출하 건수', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'qty',
    header: '수량 (취소 차감)',
    size: 140,
    meta: right,
    cell: (c) => <span className="font-semibold">{num(c.getValue())}</span>,
  },
  { accessorKey: 'issuePrice', header: '단가', size: 110, meta: right, cell: (c) => unitPrice(c.getValue()) },
];

// ───────────────────────────────── 350 공정재공 · 352 공정매거진

export const workstageStockColumns: ColumnDef<WorkstageStockRow>[] = [
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  {
    id: 'workstageName',
    header: '공정',
    size: 180,
    accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName),
  },
  { accessorKey: 'modelName', header: '모델', size: 160 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
  {
    accessorKey: 'inventoryQty',
    header: '재공수량',
    size: 120,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n < 0
        ? <span className="font-semibold text-red-500">{num(c.getValue())}</span>
        : num(c.getValue());
    },
  },
];

/**
 * 공정매거진 컬럼. 갈래에 따라 채워지는 칸이 다르다 —
 * 재공은 재공수량, 불량·폐기는 입출고 구분과 두 수량이다.
 */
export function magazineStockColumns(
  kind: 'workstage' | 'defect' | 'destroy',
): ColumnDef<MagazineStockRow>[] {
  const cols: ColumnDef<MagazineStockRow>[] = [
    { accessorKey: 'workstageName', header: '공정', size: 200 },
    { accessorKey: 'modelName', header: '모델', size: 160 },
    { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
    { accessorKey: 'itemCode', header: '품목코드', size: 150 },
    { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  ];
  if (kind === 'workstage') {
    cols.push({
      accessorKey: 'inventoryQty',
      header: '재공수량',
      size: 120,
      meta: right,
      cell: (c) => num(c.getValue()),
    });
  } else {
    cols.push(
      {
        accessorKey: 'receiptDeficit',
        header: '입출고',
        size: 90,
        meta: center,
        cell: (c) => {
          const v = String(c.getValue() ?? '');
          if (v === 'IN') return '입고';
          if (v === 'OUT') return <span className="text-red-500">출고</span>;
          return v;
        },
      },
      {
        accessorKey: 'workstageInvQty',
        header: '매거진 수량',
        size: 130,
        meta: right,
        cell: (c) => num(c.getValue()),
      },
      {
        accessorKey: 'modelInvQty',
        header: '해당공정 재공',
        size: 140,
        meta: right,
        cell: (c) => num(c.getValue()),
      },
    );
  }
  return cols;
}
