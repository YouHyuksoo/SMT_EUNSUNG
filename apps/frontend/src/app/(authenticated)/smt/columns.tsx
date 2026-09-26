/**
 * @file src/app/(authenticated)/smt/columns.tsx
 * @description SMT 9화면 그리드 컬럼.
 *
 * 표시 규칙은 지그·S-PARTS·품질과 같은 것을 쓴다 — 코드컬럼은 뜻을 보여주고
 * 코드는 괄호로 함께 둔다. 표시 헬퍼는 중복 정의하지 않고 지그 것을 가져온다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '../jig/shared-format';
import type {
  SmtBomReplaceRow,
  SmtBomReportRow,
  SmtBomRow,
  SmtBomExplodeRow,
  SmtLineRow,
  SmtLocationRow,
  SmtNcCompareRow,
  SmtNcDuplicateRow,
  SmtNcRow,
  SmtPickupRow,
  SmtPlanLineRow,
  SmtPlanRow,
} from './types';

const right = { align: 'right' } as const;

/** 소수 한 자리 퍼센트. 흡착에러율은 정수로 끊으면 0 과 0.4 가 같아 보인다. */
const pct = (value: unknown) =>
  value == null ? '' : `${Number(value).toFixed(1)}%`;

export const smtLineColumns: ColumnDef<SmtLineRow>[] = [
  { accessorKey: 'lineCode', header: '라인코드', size: 110 },
  { accessorKey: 'lineName', header: '라인명', size: 160 },
  { accessorKey: 'machine', header: '설비코드', size: 110 },
  { accessorKey: 'machineName', header: '설비명', size: 160 },
  { accessorKey: 'machineGroup', header: '설비그룹', size: 100 },
  {
    id: 'lineStatusName',
    header: '라인상태',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineStatus, r.lineStatusName),
  },
  { accessorKey: 'lineDivision', header: '라인구분', size: 100 },
  { accessorKey: 'showTableYn', header: '테이블표시', size: 100 },
  {
    accessorKey: 'locationCount',
    header: '위치수',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const smtLocationColumns: ColumnDef<SmtLocationRow>[] = [
  { accessorKey: 'lineCode', header: '라인코드', size: 110 },
  { accessorKey: 'lineName', header: '라인명', size: 150 },
  { accessorKey: 'machine', header: '설비코드', size: 110 },
  { accessorKey: 'machineName', header: '설비명', size: 150 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'locationCode', header: '위치코드', size: 130 },
  { accessorKey: 'tableNo', header: '테이블번호', size: 110 },
  {
    accessorKey: 'planUseCount',
    header: '계획사용',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'comments', header: '비고', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** 라인관리 화면의 하위 위치 그리드 — 라인·설비가 이미 정해져 있어 그 두 컬럼을 뺀다. */
export const smtLineLocationColumns: ColumnDef<SmtLocationRow>[] = [
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'locationCode', header: '위치코드', size: 140 },
  { accessorKey: 'tableNo', header: '테이블번호', size: 110 },
  { accessorKey: 'comments', header: '비고', size: 220 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const smtBomReplaceColumns: ColumnDef<SmtBomReplaceRow>[] = [
  { accessorKey: 'modelName', header: '모델명', size: 160 },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 150 },
  { accessorKey: 'childItemCode', header: '원 품목', size: 150 },
  { accessorKey: 'childItemName', header: '원 품목명', size: 180 },
  { accessorKey: 'replaceItemCode', header: '대체품목', size: 150 },
  { accessorKey: 'replaceItemName', header: '대체품목명', size: 180 },
  { accessorKey: 'lineCode', header: '라인', size: 90 },
  { accessorKey: 'machine', header: '설비', size: 90 },
  { accessorKey: 'locationCode', header: '위치코드', size: 120 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  {
    id: 'pcbItemName',
    header: 'PCB면',
    size: 110,
    accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName),
  },
  {
    accessorKey: 'itemUnitQty',
    header: '소요량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'dateSet', header: '적용시작', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'dateEnd', header: '적용종료', size: 110, cell: (c) => dateOnly(c.getValue()) },
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
  { accessorKey: 'revision', header: '리비전', size: 90 },
  { accessorKey: 'feederShaft', header: '피더축', size: 80 },
  { accessorKey: 'comments', header: '비고', size: 180 },
];

export const smtBomColumns: ColumnDef<SmtBomRow>[] = [
  { accessorKey: 'lineCode', header: '라인', size: 80 },
  { accessorKey: 'machine', header: '설비', size: 90 },
  { accessorKey: 'tableId', header: '테이블', size: 80 },
  { accessorKey: 'locationCode', header: '위치코드', size: 120 },
  {
    id: 'pcbItemName',
    header: 'PCB면',
    size: 110,
    accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName),
  },
  { accessorKey: 'childItemCode', header: '품목코드', size: 150 },
  { accessorKey: 'childItemName', header: '품목명', size: 190 },
  { accessorKey: 'childItemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'itemUnitQty',
    header: '소요량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    id: 'childItemUomName',
    header: '단위',
    size: 100,
    accessorFn: (r) => codeWithName(r.childItemUom, r.childItemUomName),
  },
  { accessorKey: 'feederType', header: '피더유형', size: 120 },
  { accessorKey: 'feederShaft', header: '피더축', size: 80 },
  { accessorKey: 'revision', header: '리비전', size: 90 },
  {
    accessorKey: 'sortSequence',
    header: '순번',
    size: 80,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'dateSet', header: '적용시작', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'dateEnd', header: '적용종료', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'smtModelName', header: 'SMT모델', size: 140 },
  { accessorKey: 'locationInfo', header: '위치정보', size: 200 },
  { accessorKey: 'comments', header: '비고', size: 180 },
];

export const smtPlanColumns: ColumnDef<SmtPlanRow>[] = [
  {
    id: 'activeYnName',
    header: '활성',
    size: 100,
    accessorFn: (r) => codeWithName(r.activeYn, r.activeYnName),
  },
  { accessorKey: 'replaceYn', header: '대체', size: 70 },
  { accessorKey: 'lineCode', header: '라인', size: 80 },
  { accessorKey: 'machine', header: '설비', size: 90 },
  { accessorKey: 'tableId', header: '테이블', size: 80 },
  { accessorKey: 'locationCode', header: '위치코드', size: 120 },
  {
    id: 'pcbItemName',
    header: 'PCB면',
    size: 110,
    accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName),
  },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  {
    accessorKey: 'itemUnitQty',
    header: '소요량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'feedingQty',
    header: '투입량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    id: 'checkStatusName',
    header: '체크상태',
    size: 120,
    accessorFn: (r) => codeWithName(r.checkStatus, r.checkStatusName),
  },
  { accessorKey: 'checkMsg', header: '체크메시지', size: 180 },
  { accessorKey: 'fullCheckYn', header: '풀체크', size: 90 },
  {
    id: 'ccsYnName',
    header: 'CCS',
    size: 100,
    accessorFn: (r) => codeWithName(r.ccsYn, r.ccsYnName),
  },
  { accessorKey: 'lotNo', header: 'LOT번호', size: 140 },
  { accessorKey: 'revision', header: '리비전', size: 90 },
  { accessorKey: 'feederShaft', header: '피더축', size: 80 },
  {
    accessorKey: 'feedingDate',
    header: '투입일시',
    size: 150,
    cell: (c) => dateTime(c.getValue()),
  },
  { accessorKey: 'planDate', header: '계획일', size: 110 },
];

export const smtPlanLineColumns: ColumnDef<SmtPlanLineRow>[] = [
  { accessorKey: 'lineCode', header: '라인코드', size: 110 },
  { accessorKey: 'lineName', header: '라인명', size: 170 },
  { accessorKey: 'activeModelName', header: '활성 모델', size: 190 },
  {
    accessorKey: 'activeModelCount',
    header: '활성 모델수',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'planRows',
    header: '계획 행수',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'lineStatus', header: '라인상태', size: 100 },
  { accessorKey: 'nsnpStatus', header: 'NSNP', size: 90 },
];

export const smtBomReportColumns: ColumnDef<SmtBomReportRow>[] = [
  { accessorKey: 'replaceYn', header: '대체', size: 70 },
  { accessorKey: 'lineCode', header: '라인', size: 80 },
  { accessorKey: 'lineName', header: '라인명', size: 140 },
  { accessorKey: 'machine', header: '설비', size: 90 },
  { accessorKey: 'tableId', header: '테이블', size: 80 },
  { accessorKey: 'locationCode', header: '위치코드', size: 120 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'itemUnitQty',
    header: '캐리어 반영 소요량',
    size: 150,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'feederType', header: '피더크기', size: 110 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 80 },
  { accessorKey: 'locationAddress', header: '보관위치', size: 130 },
  {
    accessorKey: 'unitPrice',
    header: '확정단가',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 90 },
  { accessorKey: 'revision', header: '리비전', size: 90 },
  { accessorKey: 'locationBarcode', header: '위치 바코드', size: 140 },
  { accessorKey: 'lineCodeBarcode', header: '라인 바코드', size: 150 },
  { accessorKey: 'parentItemBarcode', header: '모델 바코드', size: 170 },
  { accessorKey: 'pcbItemBarcode', header: 'PCB 바코드', size: 150 },
];

export const smtBomExplodeColumns: ColumnDef<SmtBomExplodeRow>[] = [
  { accessorKey: 'bomLevelIndent', header: '레벨', size: 90 },
  { accessorKey: 'parentItemCode', header: '상위품목', size: 150 },
  { accessorKey: 'childItemCode', header: '하위품목', size: 150 },
  { accessorKey: 'childItemName', header: '하위품목명', size: 190 },
  { accessorKey: 'childItemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'itemUnitQty',
    header: '소요량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'modelUnitQty',
    header: '모델소요량',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'feederLocations', header: '피더 위치', size: 220 },
  { accessorKey: 'itemClass', header: '품목분류', size: 110 },
  { accessorKey: 'lineType', header: '라인유형', size: 100 },
];

export const smtNcColumns: ColumnDef<SmtNcRow>[] = [
  { accessorKey: 'lineCode', header: '라인', size: 90 },
  { accessorKey: 'machineCode', header: '설비', size: 100 },
  { accessorKey: 'machineGroup', header: '설비그룹', size: 100 },
  { accessorKey: 'modelName', header: '모델명', size: 170 },
  { accessorKey: 'lotName', header: 'LOT명', size: 140 },
  { accessorKey: 'tableId', header: '테이블', size: 80 },
  { accessorKey: 'address', header: '주소', size: 80 },
  { accessorKey: 'position', header: '위치', size: 110 },
  { accessorKey: 'partName', header: '부품코드', size: 150 },
  { accessorKey: 'partItemName', header: '부품명', size: 180 },
  { accessorKey: 'chipName', header: 'CHIP명', size: 130 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 90 },
  {
    accessorKey: 'itemUnitQty',
    header: '소요량',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'feederType', header: '피더유형', size: 120 },
  { accessorKey: 'locationInfo', header: '위치정보', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

export const smtNcDuplicateColumns: ColumnDef<SmtNcDuplicateRow>[] = [
  {
    accessorKey: 'dupCount',
    header: '중복수',
    size: 90,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'lineCode', header: '라인', size: 90 },
  { accessorKey: 'machineCode', header: '설비', size: 100 },
  { accessorKey: 'modelName', header: '모델명', size: 170 },
  { accessorKey: 'lotName', header: 'LOT명', size: 140 },
  { accessorKey: 'tableId', header: '테이블', size: 80 },
  { accessorKey: 'address', header: '주소', size: 80 },
  { accessorKey: 'position', header: '위치', size: 110 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 90 },
  { accessorKey: 'partName', header: '부품코드', size: 150 },
  { accessorKey: 'locationInfo', header: '위치정보', size: 200 },
];

export const smtNcCompareColumns: ColumnDef<SmtNcCompareRow>[] = [
  {
    id: 'state',
    header: '판정',
    size: 120,
    accessorFn: (r) => {
      if (r.onlyInBom) return 'BOM 에만';
      if (r.onlyInFeeder) return '피더에만';
      return r.diff ? '수량 불일치' : '일치';
    },
  },
  { accessorKey: 'itemCode', header: '품목코드', size: 170 },
  {
    accessorKey: 'bomQty',
    header: 'BOM 소요량',
    size: 120,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'feederQty',
    header: '피더 소요량',
    size: 120,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'qtyDiff',
    header: '차이',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'bomRows',
    header: 'BOM 행수',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'feederRows',
    header: '피더 행수',
    size: 100,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
];

export const smtPickupColumns: ColumnDef<SmtPickupRow>[] = [
  { accessorKey: 'productDate', header: '생산일', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'lineCode', header: '라인', size: 90 },
  { accessorKey: 'lineName', header: '라인명', size: 150 },
  { accessorKey: 'modelName', header: '모델명', size: 170 },
  { accessorKey: 'feederId', header: '피더 ID', size: 150 },
  { accessorKey: 'feederType', header: '피더유형', size: 130 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  {
    accessorKey: 'transferCount',
    header: '이송횟수',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'adsorptionErrorCount',
    header: '흡착에러',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  // PB 컬럼명이 PICKUP_RATE 지만 식은 흡착에러/이송횟수 다. 라벨을 사실대로 적는다.
  {
    accessorKey: 'pickupRate',
    header: '흡착에러율',
    size: 120,
    meta: right,
    cell: (c) => pct(c.getValue()),
  },
  { accessorKey: 'pickupStatus', header: '상태', size: 90 },
  { accessorKey: 'actionPlan', header: '조치계획', size: 200 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];
