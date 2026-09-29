/**
 * @file src/app/(authenticated)/quality/qc-columns.tsx
 * @description 품질관리 화면들이 공유하는 그리드 컬럼 (4M · 공정품질검사 · 온도상태).
 *
 * 표시 규칙은 지그·S-PARTS 와 같은 것을 쓴다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, dateOnly, dateTime, num } from '@/components/shared/grid-format';

const right = { align: 'right' } as const;

/** PB d_qc_4m_lst / d_qc_4m_hist */
export interface Qc4mRow {
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  ecoDate: string | null;
  applyDate: string | null;
  firstProductDate: string | null;
  lastProductDate: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  ecoStatus: string | null;
  ecoStatusName: string | null;
  ecoType: string | null;
  ecoTypeName: string | null;
  ecoDivision: string | null;
  ecoDivisionName: string | null;
  pcbItem: string | null;
  pcbItemName: string | null;
  hwRevision: string | null;
  swRevision: string | null;
  ecoPoint: string | null;
  ecoComments: string | null;
  ecoReason: string | null;
  attach1Yn: string | null;
  attach2Yn: string | null;
  attach1Name: string | null;
  attach2Name: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const qc4mColumns: ColumnDef<Qc4mRow>[] = [
  { accessorKey: 'ecoDate', header: '변경일자', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'modelName', header: '모델명', size: 200 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { id: 'ecoDivisionName', header: '4M 구분', size: 120, accessorFn: (r) => codeWithName(r.ecoDivision, r.ecoDivisionName) },
  { id: 'ecoTypeName', header: '변경유형', size: 110, accessorFn: (r) => codeWithName(r.ecoType, r.ecoTypeName) },
  { id: 'ecoStatusName', header: '진행상태', size: 100, accessorFn: (r) => codeWithName(r.ecoStatus, r.ecoStatusName) },
  { id: 'workstageName', header: '공정', size: 130, accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName) },
  { id: 'pcbItemName', header: 'T/B', size: 90, accessorFn: (r) => codeWithName(r.pcbItem, r.pcbItemName) },
  { accessorKey: 'ecoPoint', header: '변경점', size: 200 },
  { accessorKey: 'ecoReason', header: '변경사유', size: 200 },
  { accessorKey: 'ecoComments', header: '변경내용', size: 220 },
  { accessorKey: 'applyDate', header: '적용일자', size: 110, cell: (c) => dateOnly(c.getValue()) },
  { accessorKey: 'firstProductDate', header: '초생산일', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'lastProductDate', header: '최종생산일', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'hwRevision', header: 'H/W Rev', size: 100 },
  { accessorKey: 'swRevision', header: 'S/W Rev', size: 100 },
  {
    id: 'attach', header: '첨부', size: 90,
    // 첨부파일 자체는 이관 범위 밖이다. 있는지만 보여준다.
    accessorFn: (r) => [r.attach1Yn === 'Y' ? '1' : '', r.attach2Yn === 'Y' ? '2' : '']
      .filter(Boolean).join(',') || '-',
  },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** PB d_qc_wqc_inspect_bad_hst_es / d_qc_visual_inspect_bad_lst_es */
export interface WqcRow {
  inspectDate: string;
  inspectSequence: number;
  serialNo: string | null;
  modelName: string | null;
  modelSuffix: string | null;
  itemCode: string | null;
  lineCode: string | null;
  lineName: string | null;
  workstageCode: string | null;
  workstageName: string | null;
  machineCode: string | null;
  wqcDivision: string | null;
  wqcDivisionName: string | null;
  inspectQty: number | null;
  inspectBadQty: number | null;
  defectQty: number | null;
  badReasonCode: string | null;
  badReasonName: string | null;
  repairResult: string | null;
  repairResultName: string | null;
  repairYn: string | null;
  repairDate: string | null;
  locationInfor: string | null;
  inspectBy: string | null;
  comments: string | null;
  wqcInspectNo: string | null;
  wqcInspectResult: string | null;
  completeYn: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const wqcColumns: ColumnDef<WqcRow>[] = [
  { accessorKey: 'inspectDate', header: '검사일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'inspectSequence', header: '검사항번', size: 100, meta: right },
  { accessorKey: 'serialNo', header: 'PID', size: 180 },
  { accessorKey: 'modelName', header: '모델명', size: 180 },
  { accessorKey: 'modelSuffix', header: '서픽스', size: 90 },
  { accessorKey: 'itemCode', header: '품목코드', size: 140 },
  { id: 'lineName', header: '라인', size: 120, accessorFn: (r) => codeWithName(r.lineCode, r.lineName) },
  { id: 'workstageName', header: '공정', size: 130, accessorFn: (r) => codeWithName(r.workstageCode, r.workstageName) },
  { accessorKey: 'machineCode', header: '설비코드', size: 110 },
  { id: 'badReasonName', header: '불량원인', size: 130, accessorFn: (r) => codeWithName(r.badReasonCode, r.badReasonName) },
  { accessorKey: 'inspectQty', header: '검사수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'inspectBadQty', header: '불량수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'defectQty', header: '결함수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { id: 'repairResultName', header: '수리결과', size: 110, accessorFn: (r) => codeWithName(r.repairResult, r.repairResultName) },
  { accessorKey: 'repairYn', header: '수리여부', size: 90 },
  { accessorKey: 'repairDate', header: '수리일시', size: 150, cell: (c) => dateTime(c.getValue()) },
  { id: 'wqcDivisionName', header: '검사구분', size: 110, accessorFn: (r) => codeWithName(r.wqcDivision, r.wqcDivisionName) },
  { accessorKey: 'locationInfor', header: '불량위치', size: 140 },
  { accessorKey: 'inspectBy', header: '검사자', size: 100 },
  { accessorKey: 'comments', header: '비고', size: 180 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** PB d_com_tempreture_raw_lst */
export interface TemperatureRawRow {
  nodeId: string;
  machineName: string | null;
  gatherDate: string | null;
  roomTemperature: number | null;
  humidity: number | null;
  dewPoint: number | null;
  minTempValue: number | null;
  maxTempValue: number | null;
  minHumidityValue: number | null;
  maxHumidityValue: number | null;
  ngYn: string | null;
  gwId: string | null;
  lqi: number | null;
  batt: number | null;
  nodeType: string | null;
  childCnt: number | null;
}

const dec = (value: unknown) => (value == null ? '' : Number(value).toFixed(1));

export const temperatureRawColumns: ColumnDef<TemperatureRawRow>[] = [
  { accessorKey: 'gatherDate', header: '수집일시', size: 160, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'machineName', header: '설비명', size: 160 },
  { accessorKey: 'nodeId', header: '노드ID', size: 150 },
  { accessorKey: 'roomTemperature', header: '온도(℃)', size: 100, meta: right, cell: (c) => dec(c.getValue()) },
  { accessorKey: 'humidity', header: '습도(%)', size: 100, meta: right, cell: (c) => dec(c.getValue()) },
  { accessorKey: 'dewPoint', header: '이슬점(℃)', size: 100, meta: right, cell: (c) => dec(c.getValue()) },
  { accessorKey: 'ngYn', header: '기준초과', size: 90 },
  {
    id: 'tempRange', header: '온도 기준범위', size: 130, meta: right,
    accessorFn: (r) => `${dec(r.minTempValue)} ~ ${dec(r.maxTempValue)}`,
  },
  {
    id: 'humidityRange', header: '습도 기준범위', size: 130, meta: right,
    accessorFn: (r) => `${dec(r.minHumidityValue)} ~ ${dec(r.maxHumidityValue)}`,
  },
  { accessorKey: 'batt', header: '배터리', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'lqi', header: 'LQI', size: 80, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'gwId', header: 'G/W', size: 110 },
];

/** PB d_mcn_temerature_check_lst */
export interface TemperatureCheckRow {
  machineCode: string;
  machineName: string | null;
  checkSequence: number;
  checkStartDate: string | null;
  checkEndDate: string | null;
  ngReasonCode: string | null;
  ngReasonName: string | null;
  actionCode: string | null;
  actionName: string | null;
  confirmYn: string | null;
  confirmName: string | null;
  confirmDate: string | null;
  comments: string | null;
  enterBy: string | null;
  enterDate: string | null;
  lastModifyBy: string | null;
  lastModifyDate: string | null;
}

export const temperatureCheckColumns: ColumnDef<TemperatureCheckRow>[] = [
  { accessorKey: 'confirmDate', header: '확인일시', size: 160, cell: (c) => dateTime(c.getValue()) },
  { id: 'machineName', header: '설비', size: 170, accessorFn: (r) => codeWithName(r.machineCode, r.machineName) },
  { accessorKey: 'checkSequence', header: '점검항번', size: 100, meta: right },
  { accessorKey: 'checkStartDate', header: '이상 시작', size: 160, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'checkEndDate', header: '이상 종료', size: 160, cell: (c) => dateTime(c.getValue()) },
  { id: 'ngReasonName', header: '이상원인', size: 130, accessorFn: (r) => codeWithName(r.ngReasonCode, r.ngReasonName) },
  { id: 'actionName', header: '조치', size: 120, accessorFn: (r) => codeWithName(r.actionCode, r.actionName) },
  { id: 'confirmName', header: '확인', size: 100, accessorFn: (r) => codeWithName(r.confirmYn, r.confirmName) },
  { accessorKey: 'comments', header: '비고', size: 220 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 150, cell: (c) => dateTime(c.getValue()) },
];

/** 온도 노드 목록 (조회조건 드롭다운 + 현재값) */
export interface TemperatureNodeRow {
  nodeId: string;
  machineCode: string | null;
  machineName: string | null;
  minTempValue: number | null;
  maxTempValue: number | null;
  minHumidityValue: number | null;
  maxHumidityValue: number | null;
  lastGatherDate: string | null;
  roomTemperature: number | null;
  humidity: number | null;
  dewPoint: number | null;
  batt: number | null;
  lqi: number | null;
}

export const temperatureNodeColumns: ColumnDef<TemperatureNodeRow>[] = [
  { id: 'machineName', header: '설비', size: 180, accessorFn: (r) => codeWithName(r.machineCode, r.machineName) },
  { accessorKey: 'nodeId', header: '노드ID', size: 150 },
  { accessorKey: 'lastGatherDate', header: '최근 수집', size: 160, cell: (c) => dateTime(c.getValue()) },
  { accessorKey: 'roomTemperature', header: '온도(℃)', size: 100, meta: right, cell: (c) => dec(c.getValue()) },
  { accessorKey: 'humidity', header: '습도(%)', size: 100, meta: right, cell: (c) => dec(c.getValue()) },
  { accessorKey: 'dewPoint', header: '이슬점(℃)', size: 100, meta: right, cell: (c) => dec(c.getValue()) },
  {
    id: 'tempRange', header: '온도 기준범위', size: 130, meta: right,
    accessorFn: (r) => `${dec(r.minTempValue)} ~ ${dec(r.maxTempValue)}`,
  },
  {
    id: 'humidityRange', header: '습도 기준범위', size: 130, meta: right,
    accessorFn: (r) => `${dec(r.minHumidityValue)} ~ ${dec(r.maxHumidityValue)}`,
  },
  { accessorKey: 'batt', header: '배터리', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'lqi', header: 'LQI', size: 80, meta: right, cell: (c) => num(c.getValue()) },
];
