/**
 * @file src/app/(authenticated)/query/query-columns.tsx
 * @description 조회 화면 그리드 컬럼.
 *
 * 표시 규칙은 다른 대분류와 같다 — 코드컬럼은 뜻을 보여주고 코드는 괄호로 함께 둔다.
 * 시각 문자열은 서버가 이미 'YYYY-MM-DD HH24:MI:SS' 로 만들어 보낸다 (KST 보존).
 * 여기서 new Date() 로 다시 파싱하지 않는다 — UTC 로 해석돼 9시간 틀어진다.
 */
import type { ColumnDef } from '@tanstack/react-table';
import { codeWithName, num } from '@/components/shared/grid-format';
import type {
  BarcodeMatchRow,
  FeederSlotRow,
  IssueHistoryRow,
  MarkingDetailRow,
  MarkingSummaryRow,
  MaterialBarcodeRow,
  NsnpHistoryRow,
  NsnpLineRow,
  PcbInputRow,
  PidInfoRow,
  PlanDataRow,
  ScanDetailRow,
  ScanGroupRow,
  SensorActualRow,
  SensorBucketRow,
  SlotHistoryRow,
  WorkflowRow,
} from './query-types';

const right = { align: 'right' } as const;
const center = { align: 'center' } as const;

/** 서버가 만든 시각 문자열을 그대로 쓴다. */
const ts = (value: unknown) => (value ? String(value) : '');
/** IQ_MACHINE_INSPECT_* 의 검사시각은 'YYYY/MM/DD HH24:MI:SS' 문자열이다 */
const rawTs = (value: unknown) => (value ? String(value).replace(/\//g, '-') : '');
/** Y/N 플래그를 눈에 들어오게. 빈 값과 'N' 을 구분해 보여준다. */
const yn = (value: unknown) => {
  if (!value) return '';
  return String(value) === 'Y' ? 'Y' : 'N';
};

// ───────────────────────────────── 323 PID 정보조회

export const pidInfoColumns: ColumnDef<PidInfoRow>[] = [
  { accessorKey: 'serialNo', header: 'PID', size: 150 },
  {
    accessorKey: 'xOutCount',
    header: 'X-OUT',
    size: 80,
    meta: center,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n > 0 ? <span className="font-semibold text-red-500">{n}</span> : '';
    },
  },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'runDate', header: '지시일', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'customerModelName', header: '고객모델', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'lotNo', header: '롯트번호', size: 130 },
  { accessorKey: 'lotQty', header: '롯트수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'magazineNo', header: '매거진', size: 110 },
  { accessorKey: 'boxNo', header: '박스', size: 110 },
  { accessorKey: 'palleteNo', header: '파렛트', size: 110 },
  { accessorKey: 'carrierBarcode', header: '캐리어', size: 130 },
  { accessorKey: 'carrierSize', header: '캐리어 수', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  {
    id: 'barcodeStatusName',
    header: '바코드 상태',
    size: 120,
    accessorFn: (r) => codeWithName(r.barcodeStatus, r.barcodeStatusName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'qcScanYn', header: 'QC스캔', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'qcScanDate', header: 'QC 스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'longtermYn', header: '장기재고', size: 90, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'receiptDate', header: '입고시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'shippingDate', header: '출하시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'labelText', header: '라벨문자', size: 180 },
  { accessorKey: 'mappingLabel', header: '매핑라벨', size: 150 },
  { accessorKey: 'mappingModelName', header: '매핑모델', size: 150 },
  { accessorKey: 'partNo', header: 'PART NO', size: 130 },
  { accessorKey: 'ecNo', header: 'EC NO', size: 110 },
  { accessorKey: 'workOrderNo', header: '작업지시번호', size: 130 },
  { accessorKey: 'arrayType', header: '배열', size: 90 },
  { accessorKey: 'bcrCode', header: 'BCR', size: 100 },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'comments', header: '메모', size: 250 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 324 마킹이력조회

export const markingDetailColumns: ColumnDef<MarkingDetailRow>[] = [
  { accessorKey: 'markingDate', header: '마킹시각', size: 160, cell: (c) => rawTs(c.getValue()) },
  { accessorKey: 'pid', header: 'PID', size: 150 },
  { accessorKey: 'resultCode', header: '판정', size: 80, meta: center },
  { accessorKey: 'lotId', header: '설비 롯트', size: 140 },
  { accessorKey: 'cstId', header: 'CST', size: 110 },
  { accessorKey: 'seq', header: '순번', size: 80, meta: right },
  { accessorKey: 'equipmentId', header: '설비', size: 110 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'machineCode', header: '설비코드', size: 110 },
  { accessorKey: 'fileName', header: '파일명', size: 220 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const markingSummaryColumns: ColumnDef<MarkingSummaryRow>[] = [
  { accessorKey: 'lotId', header: '설비 롯트', size: 140 },
  { accessorKey: 'pidQty', header: 'PID 수', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'markingDate', header: '첫 마킹시각', size: 160, cell: (c) => rawTs(c.getValue()) },
  { accessorKey: 'minPid', header: '첫 PID', size: 150 },
  { accessorKey: 'maxPid', header: '끝 PID', size: 150 },
  { accessorKey: 'resultCode', header: '판정', size: 80, meta: center },
  { accessorKey: 'equipmentId', header: '설비', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'machineCode', header: '설비코드', size: 110 },
  { accessorKey: 'seq', header: '끝 순번', size: 90, meta: right },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 325 PCB 투입 리스트조회

export const pcbInputColumns: ColumnDef<PcbInputRow>[] = [
  { accessorKey: 'scanDate', header: '스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'pcbBarcode', header: 'PCB 바코드', size: 180 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lotQty', header: '수량', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  {
    id: 'supplierName',
    header: '공급처',
    size: 150,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'supplierBarcode', header: '공급처 바코드', size: 170 },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 100 },
  { accessorKey: 'pcbCoatingType', header: '코팅유형', size: 110 },
  { accessorKey: 'pcbCoatingMaxDay', header: '코팅 한도(일)', size: 120, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'pcbCoatingDate', header: '코팅일', size: 110 },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'scanBy', header: '스캔자', size: 100 },
  { accessorKey: 'receiptStatus', header: '입고상태', size: 100 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 327 SMT 오장착 스캔 현황

/** NG 사유·메모는 화면에서 고칠 수 있다 — 편집 가능함을 제목에 표시한다. */
export const scanDetailColumns: ColumnDef<ScanDetailRow>[] = [
  { accessorKey: 'checkDate', header: '스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'checkStatusName',
    header: '상태',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkStatus, r.checkStatusName),
    cell: (c) => {
      const r = c.row.original;
      const bad = r.checkStatus === 'E';
      return (
        <span className={bad ? 'font-semibold text-red-500' : ''}>
          {codeWithName(r.checkStatus, r.checkStatusName)}
        </span>
      );
    },
  },
  {
    id: 'checkTypeName',
    header: '구분',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkType, r.checkTypeName),
  },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'lotName', header: '설비 롯트', size: 140 },
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'partName', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'chipName', header: '칩명', size: 130 },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 170 },
  { accessorKey: 'scanSupplierPartName', header: '공급처 바코드', size: 170 },
  { accessorKey: 'oldBarcode', header: '이전 바코드', size: 150 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'checkMsg', header: '메시지', size: 220 },
  { accessorKey: 'ngReason', header: 'NG 사유 (수정)', size: 180 },
  { accessorKey: 'comments', header: '메모 (수정)', size: 220 },
  { accessorKey: 'ngType', header: 'NG 유형', size: 100 },
  { accessorKey: 'checkBy', header: '작업자', size: 100 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'vendorLotNo', header: '제조사 롯트', size: 140 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'feederShaft', header: '피더축', size: 90 },
  { accessorKey: 'validDate', header: '유효일', size: 110 },
  { accessorKey: 'unlockBy', header: '해제자', size: 100 },
  { accessorKey: 'unlockDate', header: '해제시각', size: 160, cell: (c) => ts(c.getValue()) },
];

export const scanGroupColumns: ColumnDef<ScanGroupRow>[] = [
  { accessorKey: 'fullCheckSequence', header: '풀체크 회차', size: 110, meta: right },
  { accessorKey: 'fullCheckStartTime', header: '회차 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'fullCheckEndTime', header: '회차 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'checkDate', header: '스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'checkStatusName',
    header: '상태',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkStatus, r.checkStatusName),
  },
  {
    id: 'checkTypeName',
    header: '구분',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkType, r.checkTypeName),
  },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'lotName', header: '설비 롯트', size: 140 },
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'partName', header: '품목코드', size: 150 },
  { accessorKey: 'chipName', header: '칩명', size: 130 },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 170 },
  { accessorKey: 'ccsCheckTime', header: 'CCS 종료', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'ngReason', header: 'NG 사유', size: 180 },
  { accessorKey: 'checkMsg', header: '메시지', size: 220 },
  { accessorKey: 'checkBy', header: '작업자', size: 100 },
];

export const barcodeMatchColumns: ColumnDef<BarcodeMatchRow>[] = [
  { accessorKey: 'matchedOn', header: '일치 위치', size: 100, meta: center },
  { accessorKey: 'checkDate', header: '스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'checkStatusName',
    header: '상태',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkStatus, r.checkStatusName),
  },
  {
    id: 'checkTypeName',
    header: '구분',
    size: 100,
    accessorFn: (r) => codeWithName(r.checkType, r.checkTypeName),
  },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'lotName', header: '설비 롯트', size: 140 },
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'partName', header: '품목코드', size: 150 },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 170 },
  { accessorKey: 'scanSupplierPartName', header: '공급처 바코드', size: 170 },
  { accessorKey: 'oldBarcode', header: '이전 바코드', size: 150 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  { accessorKey: 'ngReason', header: 'NG 사유', size: 180 },
  { accessorKey: 'comments', header: '메모', size: 200 },
];

export const issueHistoryColumns: ColumnDef<IssueHistoryRow>[] = [
  { accessorKey: 'issueDate', header: '출고시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'issueDeficitName',
    header: '구분',
    size: 130,
    accessorFn: (r) => codeWithName(r.issueDeficit, r.issueDeficitName),
  },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'issueQty', header: '출고수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'locationCode', header: '위치', size: 110 },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];

// ───────────────────────────────── 328 PDA 검사오류내역조회

/** 검사 플래그 3개는 화면에서 고칠 수 있다 — 제목에 표시한다. */
export const planDataColumns: ColumnDef<PlanDataRow>[] = [
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'checkYn',
    header: '검사 (수정)',
    size: 110,
    meta: center,
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      return v === 'N' ? <span className="font-semibold text-amber-500">N</span> : v;
    },
  },
  { accessorKey: 'checkStatus', header: '검사상태 (수정)', size: 130 },
  {
    accessorKey: 'ccsYn',
    header: 'CCS (수정)',
    size: 110,
    meta: center,
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      return v === 'N' ? <span className="font-semibold text-amber-500">N</span> : v;
    },
  },
  { accessorKey: 'feedingQty', header: '피더 잔량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'activeYn', header: '사용', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'replaceYn', header: '대체', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'revision', header: '리비전', size: 90 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const workflowColumns: ColumnDef<WorkflowRow>[] = [
  {
    accessorKey: 'lineCode',
    header: '라인',
    size: 80,
    meta: center,
  },
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'checkYn', header: '검사', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'ccsYn', header: 'CCS', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'modelComments', header: '배치 메모', size: 300 },
];

// ───────────────────────────────── 329 SMT 피더별 모니터링

export const feederSlotColumns: ColumnDef<FeederSlotRow>[] = [
  { accessorKey: 'machine', header: '설비', size: 100 },
  { accessorKey: 'tableId', header: '테이블', size: 90 },
  { accessorKey: 'locationCode', header: '피더위치', size: 100 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  {
    accessorKey: 'feedingQty',
    header: '잔량',
    size: 100,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      // 잔량이 없거나 0 이면 곧 떨어진다 — 이 화면을 여는 이유다.
      const cls = n <= 0 ? 'font-semibold text-red-500' : '';
      return <span className={cls}>{num(c.getValue())}</span>;
    },
  },
  { accessorKey: 'currentLotNo', header: '현재 제조번호', size: 150 },
  { accessorKey: 'lastFeedingDate', header: '최종 투입시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'checkYn', header: '검사', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'ccsYn', header: 'CCS', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'checkStatus', header: '검사상태', size: 100 },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'revision', header: '리비전', size: 90 },
  { accessorKey: 'replaceYn', header: '대체', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
];

export const slotHistoryColumns: ColumnDef<SlotHistoryRow>[] = [
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
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'scanQty', header: '스캔수량', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'scanPartName', header: '스캔 바코드', size: 170 },
  { accessorKey: 'scanSupplierPartName', header: '공급처 바코드', size: 170 },
  { accessorKey: 'checkBy', header: '작업자', size: 100 },
  { accessorKey: 'ngReason', header: 'NG 사유', size: 160 },
  { accessorKey: 'checkMsg', header: '메시지', size: 200 },
];

// ───────────────────────────────── 330 SMT 제품실적센서이력조회

/** 실적수량·보정수량은 화면에서 고칠 수 있다 — 제목에 표시한다. */
export const sensorActualColumns: ColumnDef<SensorActualRow>[] = [
  { accessorKey: 'receiptDate', header: '수집시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'receiptSequence', header: '순번', size: 80, meta: right },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'workstageCode', header: '공정', size: 90 },
  { accessorKey: 'pcbItem', header: 'PCB면', size: 80, meta: center },
  { accessorKey: 'runNo', header: 'Run No', size: 130 },
  {
    accessorKey: 'productActualQty',
    header: '실적수량 (수정)',
    size: 130,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  {
    accessorKey: 'adjustQty',
    header: '보정수량 (수정)',
    size: 130,
    meta: right,
    cell: (c) => {
      const n = Number(c.getValue() ?? 0);
      return n !== 0
        ? <span className="font-semibold text-amber-500">{num(c.getValue())}</span>
        : num(c.getValue());
    },
  },
  { accessorKey: 'productActualSum', header: '누적실적', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'productActualLostQty', header: '손실수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'originCount', header: '센서 원값', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'actualType', header: '실적유형', size: 100 },
  { accessorKey: 'isLastYn', header: '최종', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'workTime', header: '작업시간', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'workerName', header: '작업자', size: 110 },
  { accessorKey: 'workerCount', header: '작업인원', size: 100, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'lastReceiptDate', header: '이전 수집시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'lastModifyBy', header: '수정자', size: 90 },
  { accessorKey: 'lastModifyDate', header: '수정일시', size: 160, cell: (c) => ts(c.getValue()) },
];

export const sensorBucketColumns: ColumnDef<SensorBucketRow>[] = [
  { accessorKey: 'receiptDate', header: '구간', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'productActualQty', header: '실적수량', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 333 자재 바코드 상태 조회

export const materialBarcodeColumns: ColumnDef<MaterialBarcodeRow>[] = [
  { accessorKey: 'itemBarcode', header: '자재 바코드', size: 170 },
  {
    id: 'barcodeStatusName',
    header: '상태',
    size: 110,
    accessorFn: (r) => codeWithName(r.barcodeStatus, r.barcodeStatusName),
  },
  { accessorKey: 'itemCode', header: '품목코드', size: 150 },
  { accessorKey: 'itemName', header: '품목명', size: 180 },
  { accessorKey: 'itemSpec', header: '규격', size: 160 },
  { accessorKey: 'lotNo', header: '제조번호', size: 140 },
  { accessorKey: 'vendorLotNo', header: '제조사 롯트', size: 140 },
  { accessorKey: 'scanQty', header: '수량', size: 90, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'scanDate', header: '스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    id: 'supplierName',
    header: '공급처',
    size: 150,
    accessorFn: (r) => codeWithName(r.supplierCode, r.supplierName),
  },
  { accessorKey: 'supplierBarcode', header: '공급처 바코드', size: 170 },
  { accessorKey: 'receiptCompareYn', header: '입고대조', size: 100, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'receiptCompareDate', header: '입고대조시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'issueCompareYn', header: '출고대조', size: 100, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'issueCompareDate', header: '출고대조시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    accessorKey: 'holdingYn',
    header: '홀딩',
    size: 80,
    meta: center,
    cell: (c) => (String(c.getValue() ?? '') === 'Y'
      ? <span className="font-semibold text-red-500">Y</span> : yn(c.getValue())),
  },
  { accessorKey: 'feedingYn', header: '투입', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'feedingModel', header: '투입모델', size: 150 },
  { accessorKey: 'returnYn', header: '반품', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'issueReturnYn', header: '출고반품', size: 100, meta: center, cell: (c) => yn(c.getValue()) },
  { accessorKey: 'lotDivideYn', header: '분할', size: 80, meta: center, cell: (c) => yn(c.getValue()) },
  {
    accessorKey: 'reelDestroyYn',
    header: '릴폐기',
    size: 90,
    meta: center,
    cell: (c) => (String(c.getValue() ?? '') === 'Y'
      ? <span className="font-semibold text-red-500">Y</span> : yn(c.getValue())),
  },
  { accessorKey: 'reelDestroyDate', header: '릴폐기시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'mslLevel', header: 'MSL', size: 70, meta: center },
  { accessorKey: 'mslMaxTime', header: 'MSL 한도(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslPassedTime', header: 'MSL 경과(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslRemainTime', header: 'MSL 잔여(h)', size: 110, meta: right, cell: (c) => num(c.getValue()) },
  { accessorKey: 'mslOpenDate', header: 'MSL 개봉시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'manufactureWeek', header: '제조주차', size: 100 },
  { accessorKey: 'validDate', header: '유효일', size: 110 },
  { accessorKey: 'locationCode', header: '위치', size: 110 },
  { accessorKey: 'labelType', header: '라벨유형', size: 100 },
  { accessorKey: 'receiptSlipNo', header: '입고전표', size: 130 },
  { accessorKey: 'originItemBarcode', header: '원 바코드', size: 170 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
  { accessorKey: 'enterDate', header: '등록일시', size: 160, cell: (c) => ts(c.getValue()) },
];

// ───────────────────────────────── 335 NSNP 처리이력조회

export const nsnpLineColumns: ColumnDef<NsnpLineRow>[] = [
  { accessorKey: 'lineCode', header: '라인', size: 80, meta: center },
  { accessorKey: 'lineName', header: '라인명', size: 130 },
  {
    id: 'lineStatusName',
    header: '라인상태',
    size: 110,
    accessorFn: (r) => codeWithName(r.lineStatus, r.lineStatusName),
  },
  {
    accessorKey: 'nsnpStatus',
    header: 'NSNP 상태',
    size: 110,
    meta: center,
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      return v && v !== 'N'
        ? <span className="font-semibold text-red-500">{v}</span> : v;
    },
  },
  {
    accessorKey: 'useStatus',
    header: '설비 사용',
    size: 100,
    meta: center,
    cell: (c) => {
      const v = String(c.getValue() ?? '');
      if (!v) return '';
      return v === 'U'
        ? <span className="text-emerald-600">사용 (U)</span>
        : <span className="text-text-muted">미사용 (S)</span>;
    },
  },
  { accessorKey: 'nsnpStartDate', header: 'NSNP 시작', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
  { accessorKey: 'ccsDate', header: 'CCS 시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'fullCheckDate', header: '풀체크 시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'reflowCheckDate', header: '리플로 시각', size: 160, cell: (c) => ts(c.getValue()) },
  { accessorKey: 'pcbScanDate', header: 'PCB 스캔시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    accessorKey: 'historyRows',
    header: '이력 건수',
    size: 110,
    meta: right,
    cell: (c) => num(c.getValue()),
  },
  { accessorKey: 'ipAddress', header: 'IP', size: 130 },
];

export const nsnpHistoryColumns: ColumnDef<NsnpHistoryRow>[] = [
  { accessorKey: 'enterDate', header: '발생시각', size: 160, cell: (c) => ts(c.getValue()) },
  {
    accessorKey: 'sourceKind',
    header: '원장',
    size: 110,
    meta: center,
    cell: (c) => (String(c.getValue()) === 'NSNP'
      ? 'NSNP 감지'
      : <span className="text-text-muted">라인 ON/OFF</span>),
  },
  {
    id: 'lineName',
    header: '라인',
    size: 120,
    accessorFn: (r) => codeWithName(r.lineCode, r.lineName),
  },
  { accessorKey: 'actionCode', header: '동작', size: 100 },
  { accessorKey: 'nsnpReason', header: '사유', size: 140 },
  { accessorKey: 'nsnpErrorMessage', header: '메시지', size: 400 },
  { accessorKey: 'machineCode', header: '설비', size: 110 },
  { accessorKey: 'modelName', header: '모델', size: 150 },
  { accessorKey: 'modelSuffix', header: '모델 SFX', size: 100 },
  { accessorKey: 'enterBy', header: '등록자', size: 90 },
];
