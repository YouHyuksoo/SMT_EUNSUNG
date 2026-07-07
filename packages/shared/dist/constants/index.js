"use strict";
/**
 * @file packages/shared/src/constants/index.ts
 * @description 공통 상수 정의
 *
 * 초보자 가이드:
 * 1. **사용법**: import { MENU_ITEMS, PROCESS_CODES } from '@smt/shared/constants'
 * 2. **as const**: 타입 추론을 위해 readonly로 정의됨
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(exports, p)) __createBinding(exports, m, p);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CURRENCY_CODES = exports.UNIT_CODES = exports.SHIFT_CODES = exports.SUPPORTED_LANGUAGES = exports.PERMISSION_CODES = exports.QR_PREFIX = exports.WAREHOUSE_CODES = exports.PROCESS_CODES = exports.DATE_FORMAT = exports.PAGINATION = exports.API_BASE_PATH = void 0;
/** API 엔드포인트 기본 경로 */
exports.API_BASE_PATH = '/api/v1';
/** 페이지네이션 기본값 */
exports.PAGINATION = {
    DEFAULT_PAGE: 1,
    DEFAULT_LIMIT: 20,
    MAX_LIMIT: 100,
};
/** 날짜 포맷 */
exports.DATE_FORMAT = {
    DATE: 'YYYY-MM-DD',
    DATETIME: 'YYYY-MM-DD HH:mm:ss',
    TIME: 'HH:mm:ss',
    DISPLAY_DATE: 'YYYY년 MM월 DD일',
    DISPLAY_DATETIME: 'YYYY년 MM월 DD일 HH:mm',
    COMPACT_DATE: 'YYYYMMDD',
    COMPACT_DATETIME: 'YYYYMMDDHHmmss',
};
/** 공정 코드 */
exports.PROCESS_CODES = {
    CUTTING: 'CUT',
    CRIMPING: 'CRM',
    ASSEMBLY: 'ASM',
    INSPECTION: 'INS',
    PACKING: 'PKG',
};
/** 창고 코드 */
exports.WAREHOUSE_CODES = {
    RAW_MATERIAL: 'WH-RM',
    SEMI_PRODUCT: 'WH-SP',
    FINISHED_GOODS: 'WH-FG',
    MRB: 'WH-MRB', // 불량 격리 창고
    HOLD: 'WH-HOLD', // 보류 창고
    LINE: 'WH-LINE', // 라인 재고
};
/** QR 코드 접두사 */
exports.QR_PREFIX = {
    BOX: 'BOX',
    PALLET: 'PLT',
    LOT: 'LOT',
    SERIAL: 'SER',
};
/** 권한 코드 */
exports.PERMISSION_CODES = {
    ADMIN: 'ADMIN',
    MANAGER: 'MANAGER',
    OPERATOR: 'OPERATOR',
    VIEWER: 'VIEWER',
};
/** 다국어 지원 언어 */
exports.SUPPORTED_LANGUAGES = ['ko', 'en', 'vi'];
/** 교대(Shift) 코드 */
exports.SHIFT_CODES = {
    DAY: { code: 'DAY', name: { ko: '주간', en: 'Day', vi: 'Ca ngày' }, startHour: 6, endHour: 14 },
    SWING: { code: 'SWING', name: { ko: '중간', en: 'Swing', vi: 'Ca chiều' }, startHour: 14, endHour: 22 },
    NIGHT: { code: 'NIGHT', name: { ko: '야간', en: 'Night', vi: 'Ca đêm' }, startHour: 22, endHour: 6 },
};
/** 단위 코드 */
exports.UNIT_CODES = {
    EA: { code: 'EA', name: { ko: '개', en: 'EA', vi: 'Cái' } },
    M: { code: 'M', name: { ko: '미터', en: 'Meter', vi: 'Mét' } },
    KG: { code: 'KG', name: { ko: '킬로그램', en: 'Kilogram', vi: 'Kg' } },
    ROLL: { code: 'ROLL', name: { ko: '롤', en: 'Roll', vi: 'Cuộn' } },
    SET: { code: 'SET', name: { ko: '세트', en: 'Set', vi: 'Bộ' } },
    BOX: { code: 'BOX', name: { ko: '박스', en: 'Box', vi: 'Hộp' } },
};
/** 통화 코드 */
exports.CURRENCY_CODES = {
    KRW: { code: 'KRW', symbol: '₩', name: '원' },
    USD: { code: 'USD', symbol: '$', name: 'Dollar' },
    VND: { code: 'VND', symbol: '₫', name: 'Đồng' },
};
// 메뉴 상수
__exportStar(require("./menu"), exports);
// 상태 코드 상수
__exportStar(require("./status"), exports);
// 공정 상수
__exportStar(require("./process"), exports);
// 공통코드 값 상수
__exportStar(require("./com-code-values"), exports);
