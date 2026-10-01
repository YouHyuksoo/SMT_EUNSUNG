/**
 * @file src/app/(authenticated)/tracking/tracking-columns.tsx
 * @description 추적 화면 그리드 컬럼.
 *
 * 표시 규칙은 다른 대분류와 같다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 * 시각 문자열은 서버가 이미 'YYYY-MM-DD HH24:MI:SS' 로 만들어 보낸다 (KST 보존).
 * 그래서 여기서 new Date() 로 다시 파싱하지 않는다 — 그러면 UTC 로 해석돼 9시간 틀어진다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import type {
  DynamicMaterialRow,
  FeedingWindowRow,
  InterlockTabRow,
  JigCheckTabRow,
  LotDetailRow,
  LotSpiRow,
  MaterialUsageRow,
  MslTabRow,
  PcbInputTabRow,
  PickupRateRow,
  PidMaterialRow,
  ReelChangeTabRow,
  RunCardRow,
  SampleTabRow,
  SolderTabRow,
  StageColumnDef,
  StageCountRow,
  StageTimelineRow,
} from './tracking-types';
import { formatDisplayDate } from '@/utils/date';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;

/** 서버가 만든 시각 문자열을 그대로 쓴다. 초 단위까지 보여줘야 추적이 된다. */
const ts = (value: unknown) => (value ? formatDisplayDate(value) : '');

/** IQ_MACHINE_INSPECT_* 의 검사시각은 'YYYY/MM/DD HH24:MI:SS' 문자열이다 */
const rawTs = (value: unknown) => (value ? String(value).replace(/\//g, '-') : '');

// ───────────────────────────────── 313 자재 제조번호 기준 추적

export const feedingWindowColumns: ColumnDef<FeedingWindowRow>[] = [
  { accessorKey: 'checkDateStart', header: '투입시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'checkDateEnd', header: '교체시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 130,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'lotName', header: '설비 롯트명', size: 140 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'partName', header: '품목코드', size: 150 },
  {
    id: 'checkTypeName',
    header: '투입구분',
    size: 110,
    accessorFn: (r) => codeWithName(r.checkType, r.checkTypeName),
  },
  { accessorKey: 'vendorCode', header: '제조사', size: 110 },
  { accessorKey: 'vendorLotNo', header: '제조사 롯트', size: 140 },
  { accessorKey: 'traceCode', header: '추적코드', size: 120 },
  { accessorKey: 'supplierBarcodeOrigin', header: '공급처 바코드', size: 170 },
  { accessorKey: 'ourBarcodeOrigin', header: '자사 바코드', size: 150 },
  { accessorKey: 'ccsEndDate', header: 'CCS 종료', size: 160, cell: (c) => ts(c.getValue()) },
];

export const lotSpiColumns: ColumnDef<LotSpiRow>[] = [
  { accessorKey: 'inspectDate', header: '검사시각', size: 160, cell: (c) => rawTs(c.getValue()) },
  { accessorKey: 'pid', header: 'PID', size: 150 },
  { accessorKey: 'result', header: '판정', size: 80, meta: center },
  { accessorKey: 'defectCode', header: '불량코드', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'equipmentId', header: '설비', size: 110 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'customerModelName', header: '고객모델', size: 150 },
  { accessorKey: 'lotQty', header: '롯트수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'magazineNo', header: '매거진', size: 110 },
  { accessorKey: 'boxNo', header: '박스', size: 110 },
  { accessorKey: 'palleteNo', header: '파렛트', size: 110 },
  { accessorKey: 'maskLotNo', header: '마스크 롯트', size: 150 },
  { accessorKey: 'squeezeLotNo', header: '스퀴지 롯트', size: 130 },
  { accessorKey: 'solderLotNo', header: '솔더 롯트', size: 130 },
  { accessorKey: 'shiftCode', header: '교대', size: 80, meta: center },
  { accessorKey: 'qcScanDate', header: 'QC 스캔', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'cstId', header: 'CST', size: 110 },
  { accessorKey: 'seqNo', header: '순번', size: 80, meta: right },
];

// ───────────────────────────────── 314 자재추적조회(동적)

export const stageTimelineColumns: ColumnDef<StageTimelineRow>[] = [
  { accessorKey: 'workstageName', header: '공정', size: 90, meta: center },
  { accessorKey: 'inspectDate', header: '검사·투입시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'result', header: '판정', size: 80, meta: center },
  { accessorKey: 'defectCode', header: '불량코드', size: 110 },
  { accessorKey: 'equipmentId', header: '설비', size: 110 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'modelName', header: '모델', size: 140 },
  { accessorKey: 'smtModelName', header: 'SMT 모델', size: 170 },
  { accessorKey: 'minDatetime', header: '라인 OFF 직전', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'maxDatetime', header: '기준시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'barcodeStatusName',
    header: '바코드 상태',
    size: 120,
    accessorFn: (r) => codeWithName(r.barcodeStatus, r.barcodeStatusName),
  },
  { accessorKey: 'lotQty', header: '롯트수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'magazineNo', header: '매거진', size: 110 },
  { accessorKey: 'carrierBarcode', header: '캐리어', size: 130 },
  { accessorKey: 'fileName', header: '파일명', size: 200 },
];

export const dynamicMaterialColumns: ColumnDef<DynamicMaterialRow>[] = [
  { accessorKey: 'branch', header: '구분', size: 90, meta: center },
  { accessorKey: 'checkDate', header: '투입시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'partName', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'vendorLotNo', header: '제조사 롯트', size: 140 },
  {
    id: 'checkTypeName',
    header: '투입구분',
    size: 110,
    accessorFn: (r) => codeWithName(r.checkType, r.checkTypeName),
  },
  {
    id: 'checkStatusName',
    header: '상태',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkStatus, r.checkStatusName),
  },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 170 },
  { accessorKey: 'supplierBarcodeOrigin', header: '공급처 바코드', size: 170 },
  { accessorKey: 'traceCode', header: '추적코드', size: 120 },
  { accessorKey: 'validDate', header: '유효일', size: 110 },
  { accessorKey: 'smtModelName', header: 'SMT 모델', size: 170 },
  { accessorKey: 'ngReason', header: 'NG 사유', size: 150 },
  { accessorKey: 'checkMsg', header: '메시지', size: 180 },
];

// ───────────────────────────────── 315 자재사용이력조회

export const materialUsageColumns: ColumnDef<MaterialUsageRow>[] = [
  { accessorKey: 'procDate', header: '발생시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'sourceKind', header: '원장', size: 90, meta: center },
  {
    id: 'procName',
    header: '구분',
    size: 130,
    accessorFn: (r) => codeWithName(r.procCode, r.procName),
  },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 190 },
  { accessorKey: 'itemClass', header: '품목분류', size: 110 },
  { accessorKey: 'qty', header: '수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'locationCode', header: '위치', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'smtModelName', header: 'SMT 모델', size: 170 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'mounterAddress', header: '마운터 주소', size: 120 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'mslMaxTime', header: 'MSL 한도(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslPassedTime', header: 'MSL 경과(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'bakingStartDate', header: '베이킹 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'bakingEndDate', header: '베이킹 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'feedingDate', header: '피딩시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'reelDestroyDate', header: '릴 폐기', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 100 },
  { accessorKey: 'pcbCoatingType', header: '코팅유형', size: 110 },
  { accessorKey: 'pcbCoatingDate', header: '코팅일', size: 110 },
  { accessorKey: 'lifeCycle', header: '수명(일)', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'supplierBarcodeOrigin', header: '공급처 바코드', size: 170 },
  { accessorKey: 'oldBarcode', header: '이전 바코드', size: 150 },
];

// ───────────────────────────────── 318·319 롯트카드

export const runCardColumns: ColumnDef<RunCardRow>[] = [
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'runDate', header: '지시일', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'markingNo', header: '마킹번호', size: 110 },
  { accessorKey: 'lotSize', header: '롯트수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 317·318 공정 매트릭스

/**
 * 공정 매트릭스 컬럼. 서버가 준 정의로 만든다 — DB 함수 목록이 서버에만 있어야
 * 한쪽만 늘어나는 일이 없다.
 *
 * 값은 **건수**다. 제목에 '건' 을 붙이고, 0 은 회색으로 낮춰 보이게 한다 —
 * 0 이 잔뜩 있는 표에서 '있는 공정' 만 눈에 들어와야 추적이 빠르다.
 */
export function stageCountColumns(stages: StageColumnDef[]): ColumnDef<StageCountRow>[] {
  return [
    { accessorKey: 'serialNo', header: 'PID', size: 150 },
    { accessorKey: 'runNo', header: 'Run No', size: 130 },
    { accessorKey: 'modelName', header: '모델', size: 140 },
    { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
    { accessorKey: 'runDate', header: '지시일', size: 110 },
    ...stages.map<ColumnDef<StageCountRow>>((s) => ({
      accessorKey: s.key,
      header: `${s.label} 건`,
      size: 100,
      meta: right,
      cell: (c) => {
        const n = Number(c.getValue() ?? 0);
        return (
          <span className={n === 0 ? 'text-text-muted/50' : 'font-semibold text-text'}>
            {n.toLocaleString()}
          </span>
        );
      },
    })),
  ];
}

// ───────────────────────────────── 319 롯트 상세

export const lotDetailColumns: ColumnDef<LotDetailRow>[] = [
  { accessorKey: 'serialNo', header: 'PID', size: 150 },
  { accessorKey: 'markingDate', header: '마킹시각', size: 160, cell: (c) => rawTs(c.getValue()) },
  { accessorKey: 'spiInspectDate', header: 'SPI 검사', size: 160, cell: (c) => rawTs(c.getValue()) },
  { accessorKey: 'spiResult', header: 'SPI', size: 70, meta: center },
  { accessorKey: 'aoiInspectDate', header: 'AOI 검사', size: 160, cell: (c) => rawTs(c.getValue()) },
  { accessorKey: 'aoiResult', header: 'AOI', size: 70, meta: center },
  { accessorKey: 'aoiDefectCode', header: 'AOI 불량', size: 110 },
  { accessorKey: 'repairYn', header: '수리', size: 70, meta: center },
  { accessorKey: 'spiToAoiTime', header: 'SPI→AOI', size: 110, meta: right },
  { accessorKey: 'markingToAoiTime', header: '마킹→AOI', size: 110, meta: right },
  { accessorKey: 'markingToShippingTime', header: '마킹→출하', size: 120, meta: right },
  { accessorKey: 'boxScanDate', header: '박스 스캔', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'shippingDate', header: '출하시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 140 },
  { accessorKey: 'lotQty', header: '롯트수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'magazineNo', header: '매거진', size: 110 },
  { accessorKey: 'boxNo', header: '박스', size: 110 },
  { accessorKey: 'palleteNo', header: '파렛트', size: 110 },
  { accessorKey: 'maskJigLotNo', header: '마스크 롯트', size: 150 },
  { accessorKey: 'maskHitValue', header: '마스크 타수', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'squeezeJigLotNo', header: '스퀴지 롯트', size: 150 },
  { accessorKey: 'squeezeHitValue', header: '스퀴지 타수', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'solderLotNo', header: '솔더 롯트', size: 170 },
  { accessorKey: 'sampleInputDate', header: '샘플 투입', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'ccsStartDate', header: 'CCS 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'ccsEndDate', header: 'CCS 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'markingEquipmentId', header: '마킹설비', size: 110 },
  { accessorKey: 'spiEquipmentId', header: 'SPI 설비', size: 110 },
  { accessorKey: 'aoiEquipmentId', header: 'AOI 설비', size: 110 },
];

// ───────────────────────────────── 317·319 PID 자재

export const pidMaterialColumns: ColumnDef<PidMaterialRow>[] = [
  { accessorKey: 'feedingDate', header: '투입시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  {
    id: 'checkTypeName',
    header: '투입구분',
    size: 110,
    accessorFn: (r) => codeWithName(r.checkType, r.checkTypeName),
  },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 170 },
  { accessorKey: 'scanSupplierPartName', header: '공급처 바코드', size: 170 },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'mslMaxTime', header: 'MSL 한도(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslPassedTime', header: 'MSL 경과(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'reelDestroyDate', header: '릴 폐기', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 321 대시보드 탭

export const pickupRateColumns: ColumnDef<PickupRateRow>[] = [
  { accessorKey: 'lineName', header: '라인', size: 120 },
  { accessorKey: 'totalCount', header: '총 픽업', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'missCount', header: '미스', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'rejectCount', header: '리젝', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  {
    accessorKey: 'goodRate',
    header: '양품률(%)',
    size: 110,
    meta: right,
    cell: (c) => {
      const v = c.getValue();
      const warn = c.row.original.lineWarningSign === 'W';
      return <span className={warn ? 'font-semibold text-red-500' : ''}>{num(v)}</span>;
    },
  },
  { accessorKey: 'ppm', header: 'PPM', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'ngPosition', header: 'NG 위치 (투입 500개↑ · 불량 1%↑)', size: 420 },
];

export const solderTabColumns: ColumnDef<SolderTabRow>[] = [
  { accessorKey: 'itemBarcode', header: '솔더 바코드', size: 150 },
  { accessorKey: 'solderLotNo', header: '솔더 롯트', size: 140 },
  { accessorKey: 'solderType', header: '유형', size: 90 },
  { accessorKey: 'modelName', header: '모델', size: 140 },
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'issueDate', header: '출고', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'unfreezingStartDate', header: '해동 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'unfreezingEndDate', header: '해동 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'unfreezingWaitTime', header: '해동 소요', size: 110, meta: right },
  { accessorKey: 'mixStartDate', header: '교반 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'mixWaitTime', header: '교반 소요', size: 110, meta: right },
  { accessorKey: 'viscosityEndDate', header: '점도 측정', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'viscosity', header: '점도', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'viscosityOperator', header: '측정자', size: 100 },
  { accessorKey: 'afterViscosityTime', header: '점도후 경과', size: 120, meta: right },
  { accessorKey: 'afterIssueTime', header: '출고후 경과', size: 120, meta: right },
  { accessorKey: 'firstLineInputDate', header: '최초 라인투입', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'afterFirstLineInputTime', header: '최초투입후 경과', size: 140, meta: right },
  { accessorKey: 'destroyDate', header: '폐기', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'validDate', header: '유효일', size: 110 },
  { accessorKey: 'validCount', header: '유효 잔여(일)', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'rpm', header: 'RPM', size: 80, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'temp', header: '온도', size: 80, meta: right, cell: (c) => num(c.getValue()) },
];

/** 마스크·스퀴지 점검 공용. 마스크만 장력 5점이 있어 옵션으로 붙인다. */
export function jigCheckColumns(variant: 'mask' | 'squeeze'): ColumnDef<JigCheckTabRow>[] {
  const cols: ColumnDef<JigCheckTabRow>[] = [
    { accessorKey: 'checkDate', header: '점검시각', size: 160, cell: (c) => ts(c.getValue()) },
    { accessorKey: 'jigLotNo', header: '지그 롯트', size: 170 },
    { accessorKey: 'jigCode', header: '지그코드', size: 120 },
    { accessorKey: 'checkSequence', header: '회차', size: 80, meta: right },
    { accessorKey: 'checkStatus', header: '판정', size: 80, meta: center },
    { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
    { accessorKey: 'cleanYn', header: '세정', size: 70, meta: center },
    { accessorKey: 'hitValue', header: '누적 타수', size: 110, meta: right, cell: (c) => num(c.getValue()) },
    { accessorKey: 'breakValue', header: '한계 타수', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  ];
  if (variant === 'mask') {
    cols.push(
      { accessorKey: 'maxTension', header: '최대 장력', size: 110, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'tension1', header: '장력1', size: 85, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'tension2', header: '장력2', size: 85, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'tension3', header: '장력3', size: 85, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'tension4', header: '장력4', size: 85, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'tension5', header: '장력5', size: 85, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'usedQty', header: '사용량', size: 90, meta: right, cell: (c) => num(c.getValue()) },
      { accessorKey: 'usedBy', header: '사용자', size: 100 },
      { accessorKey: 'returnBy', header: '반납자', size: 100 },
    );
  } else {
    cols.push({ accessorKey: 'pinHoleYn', header: '핀홀', size: 70, meta: center });
  }
  cols.push(
    { accessorKey: 'confirmYn', header: '확인', size: 70, meta: center },
    { accessorKey: 'confirmDate', header: '확인시각', size: 160, cell: (c) => ts(c.getValue()) },
    { accessorKey: 'comments', header: '메모', size: 200 },
    { accessorKey: 'enterBy', header: '등록자', size: 90 },
  );
  return cols;
}

export const mslTabColumns: ColumnDef<MslTabRow>[] = [
  {
    accessorKey: 'passedRate',
    header: '경과율(%)',
    size: 110,
    meta: right,
    cell: (c) => {
      const v = Number(c.getValue() ?? 0);
      const cls = v >= 100 ? 'font-semibold text-red-500'
        : v >= 80 ? 'font-semibold text-amber-500' : '';
      return <span className={cls}>{num(c.getValue())}</span>;
    },
  },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'partNo', header: 'PART NO', size: 130 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'mslMaxTime', header: '한도(h)', size: 95, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslPassedHour', header: '경과(h)', size: 95, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslRemainHour', header: '잔여(h)', size: 95, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslPrePassedTime', header: '이전 경과(h)', size: 115, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'checkCount', header: '투입 건', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'bakingCount', header: '베이킹 건', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'checkMinTime', header: '최초 투입', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'checkMaxTime', header: '최종 투입', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'bakingStartDate', header: '베이킹 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'bakingEndDate', header: '베이킹 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'ccsYn', header: 'CCS', size: 70, meta: center },
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 170 },
];

export const pcbInputTabColumns: ColumnDef<PcbInputTabRow>[] = [
  { accessorKey: 'scanDate', header: '스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'pcbBarcode', header: 'PCB 바코드', size: 180 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lotQty', header: '수량', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'supplierCode', header: '공급처', size: 110 },
  { accessorKey: 'supplierBarcode', header: '공급처 바코드', size: 170 },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 100 },
  { accessorKey: 'pcbCoatingType', header: '코팅유형', size: 110 },
  { accessorKey: 'pcbCoatingMaxDay', header: '코팅 한도(일)', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'pcbCoatingDate', header: '코팅일', size: 110 },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'scanBy', header: '스캔자', size: 100 },
  { accessorKey: 'receiptStatus', header: '입고상태', size: 100 },
];

export const sampleTabColumns: ColumnDef<SampleTabRow>[] = [
  { accessorKey: 'inputDate', header: '투입시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'sampleType', header: '유형', size: 90 },
  { accessorKey: 'sampleCode', header: '샘플코드', size: 130 },
  { accessorKey: 'sampleLotNo', header: '샘플 롯트', size: 140 },
  { accessorKey: 'sampleSpec', header: '규격', size: 180 },
  { accessorKey: 'sampleApplyDate', header: '적용일', size: 110 },
  { accessorKey: 'currentApplyDate', header: '현재 적용일', size: 120 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 140 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];

export const reelChangeTabColumns: ColumnDef<ReelChangeTabRow>[] = [
  { accessorKey: 'checkDate', header: '투입시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'checkTypeName',
    header: '구분',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkType, r.checkTypeName),
  },
  {
    id: 'checkStatusName',
    header: '상태',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkStatus, r.checkStatusName),
  },
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'feederShaft', header: '피더축', size: 90 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'partName', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'chipName', header: '칩명', size: 130 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 170 },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'ngReason', header: 'NG 사유', size: 150 },
  { accessorKey: 'ngType', header: 'NG 유형', size: 100 },
  { accessorKey: 'checkMsg', header: '메시지', size: 200 },
  { accessorKey: 'checkBy', header: '작업자', size: 100 },
  { accessorKey: 'ccsOkCount', header: '라인 CCS OK', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'unlockBy', header: '해제자', size: 100 },
  { accessorKey: 'unlockDate', header: '해제시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'lotDivideYn', header: '분할', size: 70, meta: center },
  { accessorKey: 'validDate', header: '유효일', size: 110 },
];

export const interlockTabColumns: ColumnDef<InterlockTabRow>[] = [
  { accessorKey: 'enterDate', header: '발생시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'actionCode', header: '동작', size: 100 },
  { accessorKey: 'nsnpReason', header: '사유', size: 130 },
  { accessorKey: 'nsnpErrorMessage', header: '메시지', size: 400 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'modelName', header: '모델', size: 140 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];
