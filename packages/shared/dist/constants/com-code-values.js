"use strict";
/**
 * @file packages/shared/src/constants/com-code-values.ts
 * @description 공통코드 그룹별 허용 값 상수 (Backend DTO validation, Frontend 타입 용도)
 *
 * 초보자 가이드:
 * 1. **as const**: 리터럴 타입 추론을 위해 필수
 * 2. **_VALUES 배열**: DTO의 @IsIn() 데코레이터에서 사용
 * 3. **Value 타입**: 해당 그룹의 union 타입 (예: 'WAITING' | 'RUNNING' | 'DONE')
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.CONSUMABLE_LOG_TYPE_VALUES = exports.CONSUMABLE_STATUS_VALUES = exports.CONSUMABLE_CATEGORY_VALUES = exports.LINE_ENDING_VALUES = exports.FLOW_CONTROL_VALUES = exports.PARITY_VALUES = exports.STOP_BITS_VALUES = exports.DATA_BITS_VALUES = exports.BAUD_RATE_VALUES = exports.COMM_TYPE_VALUES = exports.EQUIP_TYPE_VALUES = exports.PROD_RESULT_STATUS_VALUES = exports.MAT_LOT_STATUS_VALUES = exports.PLANT_TYPE_VALUES = exports.USE_YN_VALUES = exports.GENERAL_STATUS_VALUES = exports.MOLD_STATUS_VALUES = exports.INVENTORY_MOVE_TYPE_VALUES = exports.WAREHOUSE_TYPE_VALUES = exports.BOM_TYPE_VALUES = exports.PRODUCT_TYPE_VALUES = exports.PRODUCT_STOCK_QUALITY_STATUS_VALUES = exports.PRODUCT_STOCK_ITEM_TYPE_VALUES = exports.ITEM_TYPE_VALUES = exports.PROCESS_CATEGORY_VALUES = exports.PROCESS_TYPE_VALUES = exports.CONNECTION_STATUS_VALUES = exports.INTERFACE_STATUS_VALUES = exports.APPROVAL_STATUS_VALUES = exports.QUALITY_JUDGMENT_VALUES = exports.CONTROL_METHOD_VALUES = exports.SAMPLE_FREQ_VALUES = exports.SAMPLE_SIZE_VALUES = exports.BOM_SIDE_VALUES = exports.SCRAP_REASON_VALUES = exports.INSPECT_METHOD_VALUES = exports.INSPECT_TYPE_VALUES = exports.INSPECT_RESULT_VALUES = exports.DEFECT_DISPOSITION_VALUES = exports.DEFECT_STATUS_VALUES = exports.PM_STATUS_VALUES = exports.EQUIP_STATUS_VALUES = exports.ISSUE_STATUS_VALUES = exports.RECEIVE_STATUS_VALUES = exports.SHIPMENT_STATUS_VALUES = exports.PALLET_STATUS_VALUES = exports.BOX_STATUS_VALUES = exports.SEMI_PRODUCT_STATUS_VALUES = exports.JOB_ORDER_TYPE_VALUES = exports.JOB_ORDER_STATUS_VALUES = void 0;
exports.LINE_ACTIVE_YN_LABELS = exports.LINE_ACTIVE_YN_VALUES = exports.LINE_CAPACITY_UOM_VALUES = exports.LINE_STATUS_LABELS = exports.LINE_STATUS_VALUES = exports.LINE_PRODUCT_DIVISION_LABELS = exports.LINE_PRODUCT_DIVISION_VALUES = exports.LINE_DIVISION_LABELS = exports.LINE_DIVISION_VALUES = exports.REF_TYPE_VALUES = exports.TRANSACTION_TYPE_VALUES = exports.WAREHOUSE_TYPE_DTO_VALUES = exports.REWORK_INSPECT_RESULT_VALUES = exports.REWORK_PROCESS_STATUS_VALUES = exports.REWORK_STATUS_VALUES = exports.REPAIR_RESULT_VALUES = exports.DEFECT_LOG_STATUS_VALUES = exports.IF_LOG_STATUS_VALUES = exports.INTERFACE_DIRECTION_VALUES = exports.SUBCON_INSPECT_RESULT_VALUES = exports.SUBCON_ORDER_STATUS_VALUES = exports.VENDOR_TYPE_VALUES = exports.PARTNER_TYPE_VALUES = exports.USAGE_REPORT_STATUS_VALUES = exports.CUSTOMS_LOT_STATUS_VALUES = exports.CUSTOMS_ENTRY_STATUS_VALUES = exports.ISSUE_REASON_VALUES = exports.INCOMING_TYPE_VALUES = exports.CONSUMABLE_LOG_TYPE_GROUP_VALUES = void 0;
// ===== 작업지시 상태 =====
exports.JOB_ORDER_STATUS_VALUES = ['WAITING', 'RUNNING', 'HOLD', 'DONE', 'CANCELED'];
// ===== 작업지시 유형 =====
exports.JOB_ORDER_TYPE_VALUES = ['NORMAL', 'REWORK', 'SAMPLE', 'TRIAL'];
// ===== 반제품 상태 =====
exports.SEMI_PRODUCT_STATUS_VALUES = ['WAITING', 'IN_PROGRESS', 'COMPLETED', 'MOVED'];
// ===== BOX 상태 =====
exports.BOX_STATUS_VALUES = ['OPEN', 'CLOSED', 'SHIPPED'];
// ===== 팔레트 상태 =====
exports.PALLET_STATUS_VALUES = ['OPEN', 'CLOSED', 'LOADED', 'SHIPPED'];
// ===== 출하 상태 =====
exports.SHIPMENT_STATUS_VALUES = ['PREPARING', 'LOADED', 'SHIPPED', 'DELIVERED', 'CANCELED'];
// ===== 입하 상태 =====
exports.RECEIVE_STATUS_VALUES = ['PENDING', 'PASSED', 'FAILED'];
// ===== 출고 상태 =====
exports.ISSUE_STATUS_VALUES = ['PENDING', 'IN_PROGRESS', 'COMPLETED'];
// ===== 설비 상태 =====
exports.EQUIP_STATUS_VALUES = ['NORMAL', 'MAINT', 'STOP'];
// ===== PM 상태 =====
exports.PM_STATUS_VALUES = ['SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'OVERDUE'];
// ===== 불량 상태 =====
exports.DEFECT_STATUS_VALUES = ['PENDING', 'REPAIRING', 'COMPLETED', 'SCRAPPED'];
// ===== 불량 처리 유형 =====
exports.DEFECT_DISPOSITION_VALUES = ['REPAIR', 'REWORK', 'SCRAP', 'CONCESSION'];
// ===== 검사 결과 =====
exports.INSPECT_RESULT_VALUES = ['PASS', 'FAIL'];
// ===== 검사 유형 =====
exports.INSPECT_TYPE_VALUES = ['CONTINUITY', 'INSULATION', 'HI_POT', 'VISUAL'];
// ===== 검사 방법 =====
exports.INSPECT_METHOD_VALUES = ['VISUAL', 'MEASUREMENT', 'FUNCTIONAL', 'ELECTRICAL', 'DESTRUCTIVE'];
// ===== 폐기 사유 =====
exports.SCRAP_REASON_VALUES = ['DAMAGE', 'EXPIRY', 'QUALITY', 'SURPLUS', 'OBSOLETE', 'ETC'];
// ===== BOM 사이드 =====
exports.BOM_SIDE_VALUES = ['N', 'L', 'R'];
// ===== 시료 크기 =====
exports.SAMPLE_SIZE_VALUES = ['N1', 'N3', 'N5', 'N10', 'N30', 'ALL'];
// ===== 시료 빈도 =====
exports.SAMPLE_FREQ_VALUES = ['EVERY_LOT', 'HOURLY', 'PER_SHIFT', 'DAILY', 'WEEKLY', 'MONTHLY', 'CONTINUOUS'];
// ===== 관리 방법 =====
exports.CONTROL_METHOD_VALUES = ['SPC', 'CHECK_SHEET', 'VISUAL', 'GAUGE', 'POKA_YOKE', 'FIRST_ARTICLE', 'AUTO_INSPECT'];
// ===== 품질 판정 =====
exports.QUALITY_JUDGMENT_VALUES = ['PASS', 'FAIL', 'PENDING', 'CONDITIONAL'];
// ===== 승인 상태 =====
exports.APPROVAL_STATUS_VALUES = ['PENDING', 'APPROVED', 'REJECTED'];
// ===== 인터페이스 상태 =====
exports.INTERFACE_STATUS_VALUES = ['PENDING', 'SENT', 'FAILED', 'CONFIRMED'];
// ===== 검사기 연결 상태 =====
exports.CONNECTION_STATUS_VALUES = ['CONNECTED', 'DISCONNECTED', 'ERROR'];
// ===== 공정 유형 =====
exports.PROCESS_TYPE_VALUES = ['CUTTING', 'STRIPPING', 'CRIMPING', 'WELDING', 'SHIELD', 'HEAT', 'ASSEMBLY', 'INSPECTION', 'PACKING'];
// ===== 공정 대분류 =====
exports.PROCESS_CATEGORY_VALUES = ['WIRE', 'TERMINAL', 'ASSEMBLY', 'INSPECTION', 'HEAT'];
// ===== 품목 유형 =====
exports.ITEM_TYPE_VALUES = ['RAW_MATERIAL', 'SEMI_PRODUCT', 'FINISHED', 'CONSUMABLE'];
// ===== 제품재고/생산계획 품목 유형 =====
exports.PRODUCT_STOCK_ITEM_TYPE_VALUES = ['SEMI_PRODUCT', 'FINISHED'];
// ===== 제품재고 품질 상태 =====
exports.PRODUCT_STOCK_QUALITY_STATUS_VALUES = ['GOOD', 'DEFECT'];
// ===== 제품 유형 =====
exports.PRODUCT_TYPE_VALUES = [
    'SMT',
    'MODEL',
    'SUB_ASSY',
    'WIRE',
    'TERMINAL',
    'CONNECTOR',
    'HOLDER',
    'SEAL',
    'SHIELD',
    'TAPE',
    'TUBE',
    'HOUSING',
    'LABEL',
    'CLIP',
    'ELECTRIC',
    'GROMMET',
];
// ===== BOM 유형 =====
exports.BOM_TYPE_VALUES = ['PRODUCTION', 'STANDARD', 'ENGINEERING'];
// ===== 창고 유형 =====
exports.WAREHOUSE_TYPE_VALUES = ['RAW_MATERIAL', 'WIP', 'FINISHED', 'MRB', 'HOLD'];
// ===== 재고 이동 유형 =====
exports.INVENTORY_MOVE_TYPE_VALUES = ['RECEIPT', 'ISSUE', 'TRANSFER', 'ADJUSTMENT', 'SCRAP'];
// ===== 금형 상태 =====
exports.MOLD_STATUS_VALUES = ['ACTIVE', 'INACTIVE', 'REPAIR', 'SCRAPPED'];
// ===== 일반 상태 =====
exports.GENERAL_STATUS_VALUES = ['ACTIVE', 'INACTIVE'];
// ===== 사용 여부 =====
exports.USE_YN_VALUES = ['Y', 'N'];
// ===== 공장/조직 유형 =====
exports.PLANT_TYPE_VALUES = ['PLANT', 'SHOP', 'LINE', 'CELL'];
// ===== 자재 LOT 상태 =====
exports.MAT_LOT_STATUS_VALUES = ['NORMAL', 'HOLD', 'DEPLETED'];
// ===== 출고 유형 (ComCode ISSUE_TYPE 그룹으로 이관됨) =====
// @deprecated ComCode 'ISSUE_TYPE' 그룹 사용. 백엔드 DTO 검증에서 @IsIn 제거됨.
// export const ISSUE_TYPE_VALUES = ['PROD', 'SUBCON', 'SAMPLE', 'ADJ'] as const;
// export type IssueTypeValue = typeof ISSUE_TYPE_VALUES[number];
// ===== 생산실적 상태 =====
exports.PROD_RESULT_STATUS_VALUES = ['RUNNING', 'DONE', 'CANCELED'];
// ===== 설비 유형 =====
exports.EQUIP_TYPE_VALUES = [
    'COMMON', 'AUTO_CRIMP', 'SINGLE_CUT', 'MULTI_CUT', 'TWIST', 'SOLDER',
    'HOUSING', 'TESTER', 'LABEL_PRINTER', 'INSPECTION', 'PACKING', 'OTHER',
];
// ===== 통신 유형 =====
exports.COMM_TYPE_VALUES = ['MQTT', 'SERIAL', 'TCP', 'OPC_UA', 'MODBUS'];
// ===== 통신설정 - 시리얼 옵션 =====
exports.BAUD_RATE_VALUES = [9600, 19200, 38400, 57600, 115200];
exports.DATA_BITS_VALUES = [7, 8];
exports.STOP_BITS_VALUES = ['1', '1.5', '2'];
exports.PARITY_VALUES = ['NONE', 'EVEN', 'ODD'];
exports.FLOW_CONTROL_VALUES = ['NONE', 'XONXOFF', 'RTSCTS'];
exports.LINE_ENDING_VALUES = ['NONE', 'CR', 'LF', 'CRLF'];
// ===== 소모품 카테고리 =====
exports.CONSUMABLE_CATEGORY_VALUES = ['MOLD', 'JIG', 'TOOL'];
// ===== 소모품 상태 =====
exports.CONSUMABLE_STATUS_VALUES = ['NORMAL', 'WARNING', 'REPLACE'];
// ===== 소모품 이력 유형 =====
exports.CONSUMABLE_LOG_TYPE_VALUES = ['IN', 'IN_RETURN', 'OUT', 'OUT_RETURN'];
// ===== 소모품 이력 유형 그룹 =====
exports.CONSUMABLE_LOG_TYPE_GROUP_VALUES = ['RECEIVING', 'ISSUING'];
// ===== 소모품 입고 구분 =====
exports.INCOMING_TYPE_VALUES = ['NEW', 'REPLACEMENT'];
// ===== 소모품 출고 사유 =====
exports.ISSUE_REASON_VALUES = ['PRODUCTION', 'REPAIR', 'OTHER'];
// ===== 통관 입항 상태 =====
exports.CUSTOMS_ENTRY_STATUS_VALUES = ['PENDING', 'CLEARED', 'RELEASED'];
// ===== 통관 LOT 상태 =====
exports.CUSTOMS_LOT_STATUS_VALUES = ['BONDED', 'PARTIAL', 'RELEASED'];
// ===== 사용보고서 상태 =====
exports.USAGE_REPORT_STATUS_VALUES = ['DRAFT', 'REPORTED', 'CONFIRMED'];
// ===== 거래처 유형 =====
// MFG: 제조사 (IQC005 자재 입하 시 필수, 발주처와 별개)
exports.PARTNER_TYPE_VALUES = ['SUPPLIER', 'CUSTOMER', 'MFG'];
// ===== 협력사 유형 =====
exports.VENDOR_TYPE_VALUES = ['SUBCON', 'SUPPLIER'];
// ===== 외주 발주 상태 =====
exports.SUBCON_ORDER_STATUS_VALUES = ['ORDERED', 'DELIVERED', 'PARTIAL_RECV', 'RECEIVED', 'CLOSED', 'CANCELED'];
// ===== 외주 검수 결과 =====
exports.SUBCON_INSPECT_RESULT_VALUES = ['PASS', 'FAIL', 'PARTIAL'];
// ===== 인터페이스 방향 =====
exports.INTERFACE_DIRECTION_VALUES = ['IN', 'OUT'];
// ===== 인터페이스 로그 상태 =====
exports.IF_LOG_STATUS_VALUES = ['PENDING', 'SUCCESS', 'FAIL', 'RETRY'];
// ===== 불량 로그 상태 (DTO) =====
exports.DEFECT_LOG_STATUS_VALUES = ['WAIT', 'REPAIR', 'REWORK', 'SCRAP', 'DONE'];
// ===== 수리 결과 =====
exports.REPAIR_RESULT_VALUES = ['PASS', 'FAIL', 'SCRAP'];
// ===== 재작업 상태 =====
exports.REWORK_STATUS_VALUES = [
    'REGISTERED', 'QC_PENDING', 'QC_APPROVED', 'QC_REJECTED',
    'PROD_PENDING', 'APPROVED', 'PROD_REJECTED',
    'IN_PROGRESS', 'REWORK_DONE', 'INSPECT_PENDING',
    'PASS', 'FAIL', 'SCRAP',
];
// ===== 재작업 공정 상태 =====
exports.REWORK_PROCESS_STATUS_VALUES = ['WAITING', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED'];
// ===== 재작업 검사 결과 =====
exports.REWORK_INSPECT_RESULT_VALUES = ['PASS', 'FAIL', 'SCRAP'];
// ===== 창고 유형 (DTO) =====
exports.WAREHOUSE_TYPE_DTO_VALUES = ['RAW', 'WIP', 'FG', 'FLOOR', 'DEFECT', 'SCRAP', 'SUBCON'];
// ===== 재고 트랜잭션 유형 =====
exports.TRANSACTION_TYPE_VALUES = [
    'MAT_IN', 'MAT_IN_CANCEL', 'MAT_OUT', 'MAT_OUT_CANCEL',
    'WIP_IN', 'WIP_IN_CANCEL', 'WIP_OUT', 'WIP_OUT_CANCEL',
    'FG_IN', 'FG_IN_CANCEL', 'FG_OUT', 'FG_OUT_CANCEL',
    'DEFECT_IN', 'DEFECT_IN_CANCEL',
    'SUBCON_OUT', 'SUBCON_OUT_CANCEL', 'SUBCON_IN', 'SUBCON_IN_CANCEL',
    'PROD_CONSUME', 'PROD_CONSUME_CANCEL',
    'TRANSFER', 'TRANSFER_CANCEL',
    'WIP_MOVE', 'WIP_MOVE_CANCEL',
    'ADJ_PLUS', 'ADJ_MINUS', 'SCRAP',
];
// ===== 참조 유형 =====
exports.REF_TYPE_VALUES = ['JOB_ORDER', 'SUBCON_ORDER', 'SHIPMENT', 'CUSTOMS', 'ADJUST', 'PROD_RESULT'];
// ===== 생산라인 (IP_PRODUCT_LINE) =====
// 값/한글명은 은성 DB의 ISYS_BASECODE 및 컬럼 주석 정의를 그대로 옮긴 것이다.
/** 라인구분 (IP_PRODUCT_LINE.LINE_DIVISION) */
exports.LINE_DIVISION_VALUES = [
    'C', 'D', 'E', 'ETC', 'I', 'KIPAN', 'L', 'M', 'REBALL', 'REPAIR', 'S', 'SMT', 'T', 'W',
];
exports.LINE_DIVISION_LABELS = {
    C: 'CELL',
    D: 'SMT',
    E: '외주',
    ETC: 'ETC',
    I: '사내',
    KIPAN: '기판',
    L: '조립라인',
    M: '무상사급',
    REBALL: '리볼',
    REPAIR: '수리',
    S: '유상사급',
    SMT: 'SMT',
    T: '검사라인',
    W: '가공공정',
};
/** 라인제품구분 (IP_PRODUCT_LINE.LINE_PRODUCT_DIVISION) */
exports.LINE_PRODUCT_DIVISION_VALUES = ['FIXED', 'ONESELF', 'SALE', 'SUBLET'];
exports.LINE_PRODUCT_DIVISION_LABELS = {
    FIXED: '고정',
    ONESELF: '자작',
    SALE: '유상',
    SUBLET: '무상',
};
/** 라인상태 (IP_PRODUCT_LINE.LINE_STATUS) */
exports.LINE_STATUS_VALUES = ['C', 'D', 'E', 'M', 'N', 'Q', 'R', 'S', 'T', 'Z'];
exports.LINE_STATUS_LABELS = {
    C: '모델변경',
    D: '고장',
    E: '오삽발생',
    M: '자재교환',
    N: '정상',
    Q: '기타',
    R: '수리중',
    S: '정지',
    T: '일시정지',
    Z: '샘플생산',
};
/** 용량단위 (IP_PRODUCT_LINE.CAPACITY_UOM) */
exports.LINE_CAPACITY_UOM_VALUES = ['KG', 'ST'];
/** 활성유무 (IP_PRODUCT_LINE.ACTIVE_YN) — 사용여부가 아니라 라인 가동 활성 상태다. */
exports.LINE_ACTIVE_YN_VALUES = ['Y', 'N'];
exports.LINE_ACTIVE_YN_LABELS = {
    Y: '활성',
    N: '대기',
};
