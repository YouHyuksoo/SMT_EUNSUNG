/**
 * @file src/app/(authenticated)/warehouse/solder-columns.tsx
 * @description 솔더 페이스트 그리드 컬럼 (244·245).
 *
 * 솔더는 굳으면 못 쓴다. 그래서 이 화면의 열은 대부분 **시간**이고,
 * 오래 둔 통이 눈에 들어와야 한다:
 * - 유효기한이 지났으면 빨강, 7일 이내면 주황
 * - 투입대기 수량이 0보다 크면 주황 (점도까지 끝났는데 라인에 안 올라간 통)
 *
 * 시간 열은 서버가 `F_GET_TIME_STR` 로 만든 문자열을 그대로 쓴다 (PB 와 같은 함수).
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import type {
  SolderInputHistoryRow,
  SolderRow,
  SolderStageCountRow,
} from './warehouse-types';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;

const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** 솔더 종류. 실측 분포 'F' 35,629건 · 'P' 131건. 코드표는 따로 없다. */
const SOLDER_TYPE_LABEL: Record<string, string> = { F: '무연(F)', P: '유연(P)' };
const solderTypeCell = (value: unknown) => {
  const v = String(value ?? '');
  return SOLDER_TYPE_LABEL[v] ?? v;
};

// ───────────────────────────────── 244 단계별 대기 수량

export const solderStageCountColumns: ColumnDef<SolderStageCountRow>[] = [
  {
    id: 'machineName',
    header: '설비(공장)',
    size: 170,
    accessorFn: (r) => codeWithName(r.machineCode, r.machineName),
  },
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  {
    accessorKey: 'solderType',
    header: '종류',
    size: 100,
    meta: center,
    cell: (c) => solderTypeCell(c.getValue()),
  },
  {
    accessorKey: 'refrigeratorCnt',
    header: '냉장고',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'unfreezingCnt',
    header: '해동중',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'mixCnt',
    header: '교반중',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'viscosityWaitCnt',
    header: '점도대기',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'inputWaitCnt',
    header: '투입대기',
    size: 110,
    meta: right,
    // 점도까지 끝났는데 라인에 안 올라간 통. 오래 두면 굳는다.
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n > 0
        ? <span className="font-semibold text-amber-500">{num(n)}</span>
        : num(n);
    },
  },
];

// ───────────────────────────────── 244 솔더 통 목록

export const solderColumns: ColumnDef<SolderRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'solderLotNo', header: '솔더 롯트', size: 160 },
  { accessorKey: 'itemBarcode', header: '솔더 바코드', size: 180 },
  {
    accessorKey: 'solderType',
    header: '종류',
    size: 100,
    meta: center,
    cell: (c) => solderTypeCell(c.getValue()),
  },
  {
    accessorKey: 'validCount',
    header: '유효기한 잔여',
    size: 130,
    meta: right,
    // 음수면 이미 지났다. 7일 이내면 곧 지난다.
    cell: (c) => {
      const v = c.getValue();
      if (v == null) return '';
      const d = Number(v);
      if (d < 0) return <span className="font-semibold text-red-500">{num(d)}일</span>;
      if (d <= 7) return <span className="text-amber-500">{num(d)}일</span>;
      return `${num(d)}일`;
    },
  },
  { accessorKey: 'receiptDate', header: '입고(냉장고)', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'issueDate', header: '출고(꺼냄)', size: 160, cell: (c) => ts(c.getValue()) },
  // 꺼낸 뒤 지난 시간이 솔더 수명을 깎는다 — 이 화면의 핵심 열이다.
  { accessorKey: 'afterIssueTime', header: '출고 후 경과', size: 130 },
  { accessorKey: 'unfreezingStartDate', header: '해동 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'unfreezingEndDate', header: '해동 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'unfreezingWaitTime', header: '해동 소요', size: 120 },
  { accessorKey: 'mixStartDate', header: '교반 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'mixEndDate', header: '교반 종료', size: 160, cell: (c) => ts(c.getValue()) },
  // PB 는 이 열에서 24시간을 버렸다 (실측 최대 163시간이 19:12 로 보였다).
  { accessorKey: 'mixWaitTime', header: '교반 소요', size: 120 },
  { accessorKey: 'rpm', header: 'RPM', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mixTime', header: '교반설정', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'temp', header: '온도', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'viscosityStartDate', header: '점도 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'viscosityEndDate', header: '점도 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'viscosity', header: '점도', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'viscosityOperator', header: '점도측정자', size: 110 },
  { accessorKey: 'afterViscosityTime', header: '점도 후 경과', size: 130 },
  { accessorKey: 'openDate', header: '개봉', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'afterOpenTime', header: '개봉 후 경과', size: 130 },
  { accessorKey: 'firstLineInputDate', header: '최초 라인투입', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'afterFirstInputTime', header: '최초투입 후 경과', size: 150 },
  { accessorKey: 'inputDate', header: '라인투입', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'solderInputLine', header: '투입 라인 목록', size: 200 },
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'modelName', header: '모델', size: 140 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'returnDate', header: '반납', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'destroyDate', header: '폐기', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'validDate', header: '유효기한', size: 120 },
  { accessorKey: 'freezerInTemp', header: '냉장 온도', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'unfreezingStartTemp', header: '해동시작 온도', size: 130, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'unfreezingEndTemp', header: '해동종료 온도', size: 130, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'viscosityFileName', header: '점도 파일', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 245 솔더 라인투입이력

export const solderInputHistoryColumns: ColumnDef<SolderInputHistoryRow>[] = [
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'inputDate', header: '투입시각', size: 170, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'solderLotNo', header: '솔더 롯트', size: 160 },
  { accessorKey: 'itemBarcode', header: '솔더 바코드', size: 180 },
  {
    accessorKey: 'solderType',
    header: '종류',
    size: 100,
    meta: center,
    cell: (c) => solderTypeCell(c.getValue()),
  },
  {
    id: 'lineName',
    header: '라인',
    size: 140,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  {
    id: 'machineName',
    header: '설비',
    size: 160,
    accessorFn: (r) => codeWithName(r.machineCode, r.machineName),
  },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'enterBy', header: '등록자', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];
