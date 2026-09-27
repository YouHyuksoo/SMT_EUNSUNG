/**
 * @file src/app/(authenticated)/production/planning-columns.tsx
 * @description 생산(M_PLANNING) 화면 그리드 컬럼.
 *
 * 표시 규칙은 지그·S-PARTS·품질·SMT 와 같다 — 코드컬럼은 뜻을 보여주고
 * 코드는 괄호로 함께 둔다. 표시 헬퍼는 중복 정의하지 않고 지그 것을 가져온다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '@/components/shared/grid-format';
import type {
  DailyReportRow,
  KittingPidRow,
  KittingRunCardRow,
  PlanRow,
  ResultPeriodRow,
  ResultRunRow,
  ResultSerialRow,
  SmdActualRow,
  SmdActualSummaryRow,
} from './planning-types';
import { SLOT_INDEXES } from './planning-types';

const right = { align: 'right' } as const;

/** 퍼센트 한 자리. 정수로 끊으면 55.4 와 54.6 이 같아 보인다. */
const pct = (value: unknown) => (value == null ? '' : `${Number(value).toFixed(1)}%`);

/** 분 단위 시간. 604 → 10시간 4분 처럼 읽기 쉽게 붙여 준다. */
const minutes = (value: unknown) => {
  if (value == null) return '';
  const total = Math.round(Number(value));
  if (!Number.isFinite(total)) return '';
  if (total < 60) return `${total}분`;
  return `${Math.floor(total / 60)}시간 ${total % 60}분`;
};

/**
 * 계획 공통 컬럼. 시간대 10칸은 폭을 많이 먹으므로 기본 목록에서 빼고,
 * 화면이 '시간대 보기' 를 켤 때 planTimeColumns 를 뒤에 붙인다.
 */
function planCommonColumns(variant: 'mi' | 'smd'): ColumnDef<PlanRow>[] {
  const base: ColumnDef<PlanRow>[] = [
    { accessorKey: 'planDate', header: '계획일', size: 110, cell: (c) => dateOnly(c.getValue()) },
    { accessorKey: 'planSequence', header: '순번', size: 70, meta: right },
    { accessorKey: 'planPriority', header: '우선순위', size: 90, meta: right },
    {
      id: 'lineName',
      header: '라인',
      size: 130,
      accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
    },
    { accessorKey: 'modelName', header: '모델명', size: 190 },
    { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  ];

  if (variant === 'mi') {
    base.push({ accessorKey: 'workstageCode', header: '공정', size: 90 });
  } else {
    base.push(
      { accessorKey: 'shiftCode', header: '교대', size: 80 },
      { accessorKey: 'productionType', header: '생산유형', size: 100 },
      { accessorKey: 'mfsGroupNo', header: 'MFS그룹', size: 110 },
    );
  }

  return [
    ...base,
    {
      id: 'pcbItemName',
      header: 'PCB면',
      size: 100,
      accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName),
    },
    { accessorKey: 'itemCode', header: '품목코드', size: 140 },
    { accessorKey: 'itemName', header: '품목명', size: 180 },
    { accessorKey: 'workOrderNo', header: '작업지시번호', size: 140 },
    {
      accessorKey: 'planQty',
      header: '계획수량',
      size: 110,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    {
      accessorKey: 'planTimeSum',
      header: '시간대 합',
      size: 110,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    {
      accessorKey: 'actualQty',
      header: '실적수량',
      size: 110,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    {
      accessorKey: 'planCapaQty',
      header: '설비능력',
      size: 100,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    {
      accessorKey: 'mcTime',
      header: '기종교체(분)',
      size: 110,
      meta: right,
      cell: (c) => num(c.getValue()),
    },
    { accessorKey: 'carrierSize', header: '캐리어', size: 90, meta: right },
    {
      id: 'planStatusName',
      header: '계획상태',
      size: 120,
      accessorFn: (r) => codeWithName(r.planStatus, r.planStatusName),
    },
    { accessorKey: 'confirmYn', header: '확정', size: 70 },
    // '*' 면 롯트카드가 아직 안 붙은 계획이다. 그대로 보여주면 오해하므로 바꿔 적는다.
    {
      id: 'mfs',
      header: '롯트카드',
      size: 130,
      accessorFn: (r) => (!r.mfs || r.mfs === '*' ? '미발행' : r.mfs),
    },
    { accessorKey: 'customerCode', header: '고객', size: 110 },
    { accessorKey: 'comments', header: '비고', size: 200 },
    { accessorKey: 'enterBy', header: '등록자', size: 90 },
    {
      accessorKey: 'enterDate',
      header: '등록일시',
      size: 150,
      cell: (c) => dateTime(c.getValue()),
    },
  ];
}

export const miPlanColumns = planCommonColumns('mi');
export const smdPlanColumns = planCommonColumns('smd');

/**
 * 시간대 10칸 — 계획 / 실적을 나란히 둔다.
 * PB DataWindow 가 10칸 고정이라 칸 번호를 그대로 머리글로 쓴다.
 */
export const planTimeSlotColumns: ColumnDef<PlanRow>[] = SLOT_INDEXES.flatMap((slot) => [
  {
    id: `planTime${slot}`,
    header: `${slot}칸 계획`,
    size: 90,
    meta: right,
    accessorFn: (r) => r[`planTime${slot}`],
    cell: (c) => num(c.getValue()),
  },
  {
    id: `actualTime${slot}`,
    header: `${slot}칸 실적`,
    size: 90,
    meta: right,
    accessorFn: (r) => r[`actualTime${slot}`],
    cell: (c) => num(c.getValue()),
  },
]);

export const smdActualColumns: ColumnDef<SmdActualRow>[] = [
  {
    accessorKey: 'receiptDate',
    header: '집계일시',
    size: 160,
    cell: (c) => dateTime(c.getValue()),
  },
  { accessorKey: 'receiptSequence', header: '순번', size: 80, meta: right },
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델명', size: 190 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  {
    id: 'pcbItemName',
    header: 'PCB면',
    size: 100,
    accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName),
  },
  {
    accessorKey: 'productActualQty',
    header: '실적수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'adjustQty',
    header: '보정수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'productActualLostQty',
    header: '로스수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  // 센서 원시값. 화면에서 고칠 수 없다 — 고치면 센서 이력과 갈린다.
  {
    accessorKey: 'originCount',
    header: '센서 원시값',
    size: 120,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'productActualSum',
    header: '누적실적',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'carrierSize', header: '캐리어', size: 90, meta: right },
  { accessorKey: 'actualType', header: '실적유형', size: 100 },
  { accessorKey: 'timeDivision', header: '시간구분', size: 100 },
  { accessorKey: 'isLastYn', header: '최종', size: 70 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  {
    accessorKey: 'lastModifyDate',
    header: '수정일시',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
];

export const smdActualSummaryColumns: ColumnDef<SmdActualSummaryRow>[] = [
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델명', size: 200 },
  { accessorKey: 'rowCount', header: '집계건수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'productActualQty',
    header: '실적수량 합',
    size: 130,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'adjustQty',
    header: '보정수량 합',
    size: 130,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'productActualLostQty',
    header: '로스수량 합',
    size: 130,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'firstDate', header: '최초', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'lastDate', header: '최종', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const kittingRunCardColumns: ColumnDef<KittingRunCardRow>[] = [
  { accessorKey: 'runNo', header: '작업지시번호', size: 140 },
  { accessorKey: 'runDate', header: '작업일', size: 110, cell: (c) => dateOnly(c.getValue()) },
  {
    accessorKey: 'pidCount',
    header: '매핑 PID',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'lotSize', header: 'LOT수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'modelName', header: '모델명', size: 190 },
  { accessorKey: 'masterModelName', header: '마스터모델', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'lotNo', header: 'LOT번호', size: 130 },
  { accessorKey: 'markingNo', header: '마킹번호', size: 120 },
  {
    id: 'runStatusName',
    header: '작업상태',
    size: 120,
    accessorFn: (r) => codeWithName(r.runStatus, r.runStatusName),
  },
  {
    id: 'productRunTypeName',
    header: '작업유형',
    size: 130,
    accessorFn: (r) => codeWithName(r.productRunType, r.productRunTypeName),
  },
  { accessorKey: 'arrayType', header: '배열', size: 80 },
  { accessorKey: 'carrierSize', header: '캐리어', size: 90, meta: right },
  {
    accessorKey: 'kittingDate',
    header: '키팅일시',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
  { accessorKey: 'mfsGroupNo', header: 'MFS그룹', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 180 },
];

export const kittingPidColumns: ColumnDef<KittingPidRow>[] = [
  { accessorKey: 'serialNo', header: 'PID', size: 200 },
  // PID 7~11번째 다섯 글자. 모델매칭이 맞는지 눈으로 확인하는 자리다.
  { accessorKey: 'modelCode', header: '모델코드', size: 100 },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 80 },
  { accessorKey: 'workstageCode', header: '공정', size: 80 },
  {
    id: 'barcodeStatusName',
    header: '바코드상태',
    size: 120,
    accessorFn: (r) => codeWithName(r.barcodeStatus, r.barcodeStatusName),
  },
  { accessorKey: 'qcScanYn', header: 'QC검사', size: 90 },
  {
    accessorKey: 'qcScanDate',
    header: 'QC검사일시',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
  { accessorKey: 'magazineNo', header: '매거진번호', size: 130 },
  { accessorKey: 'lotNo', header: 'LOT번호', size: 130 },
  { accessorKey: 'lotQty', header: 'LOT수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  {
    accessorKey: 'enterDate',
    header: '등록일시',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
];

export const resultPeriodColumns: ColumnDef<ResultPeriodRow>[] = [
  { accessorKey: 'modelName', header: '모델명', size: 190 },
  { accessorKey: 'runNo', header: '작업지시번호', size: 140 },
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'lotQty', header: 'LOT수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'resultQty',
    header: '실적수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'rowCount', header: '통과건수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'firstDate', header: '최초통과', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'lastDate', header: '최종통과', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const resultRunColumns: ColumnDef<ResultRunRow>[] = [
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 110 },
  {
    accessorKey: 'resultQty',
    header: '실적수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'rowCount', header: '통과건수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'firstDate', header: '최초통과', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'lastDate', header: '최종통과', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const resultSerialColumns: ColumnDef<ResultSerialRow>[] = [
  { accessorKey: 'ioDate', header: '통과일시', size: 170, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'serialNo', header: 'PID', size: 220 },
  { accessorKey: 'ioQty', header: '수량', size: 90, meta: right, cell: (c) => num(c.getValue()) },
];

export const dailyReportColumns: ColumnDef<DailyReportRow>[] = [
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'runNo', header: '작업지시번호', size: 140 },
  { accessorKey: 'modelName', header: '모델명', size: 190 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80 },
  {
    id: 'solderTypeName',
    header: '솔더',
    size: 110,
    accessorFn: (r) => codeWithName(r.solderType, r.solderTypeName),
  },
  { accessorKey: 'lotSize', header: 'LOT수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'carrierSize', header: '캐리어', size: 90, meta: right },
  {
    accessorKey: 'resultQty',
    header: '실적수량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'badQty', header: '불량수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'badPpm', header: '불량 PPM', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'productStart',
    header: '생산시작',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
  {
    accessorKey: 'productEnd',
    header: '생산종료',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
  { accessorKey: 'productTime', header: '생산시간', size: 120, meta: right, cell: (c) => minutes(c.getValue()) },
  { accessorKey: 'restTime', header: '휴게시간', size: 120, meta: right, cell: (c) => minutes(c.getValue()) },
  { accessorKey: 'lossTime', header: '로스시간', size: 120, meta: right, cell: (c) => minutes(c.getValue()) },
  { accessorKey: 'availableTime', header: '가용시간', size: 120, meta: right, cell: (c) => minutes(c.getValue()) },
  { accessorKey: 'actualTime', header: '실가동시간', size: 120, meta: right, cell: (c) => minutes(c.getValue()) },
  {
    accessorKey: 'timeWorkingRate',
    header: '시간가동률',
    size: 110,
    meta: right,
    cell: (c) => pct(c.getValue()),
  },
  {
    accessorKey: 'performanceWorkingRate',
    header: '성능가동률',
    size: 110,
    meta: right,
    cell: (c) => pct(c.getValue()),
  },
  {
    accessorKey: 'goodProductRate',
    header: '양품률',
    size: 100,
    meta: right,
    cell: (c) => pct(c.getValue()),
  },
  {
    accessorKey: 'overallEfficiency',
    header: '종합효율',
    size: 110,
    meta: right,
    cell: (c) => pct(c.getValue()),
  },
];
