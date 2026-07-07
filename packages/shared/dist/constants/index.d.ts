/**
 * @file packages/shared/src/constants/index.ts
 * @description 공통 상수 정의
 *
 * 초보자 가이드:
 * 1. **사용법**: import { MENU_ITEMS, PROCESS_CODES } from '@smt/shared/constants'
 * 2. **as const**: 타입 추론을 위해 readonly로 정의됨
 */
/** API 엔드포인트 기본 경로 */
export declare const API_BASE_PATH = "/api/v1";
/** 페이지네이션 기본값 */
export declare const PAGINATION: {
    readonly DEFAULT_PAGE: 1;
    readonly DEFAULT_LIMIT: 20;
    readonly MAX_LIMIT: 100;
};
/** 날짜 포맷 */
export declare const DATE_FORMAT: {
    readonly DATE: "YYYY-MM-DD";
    readonly DATETIME: "YYYY-MM-DD HH:mm:ss";
    readonly TIME: "HH:mm:ss";
    readonly DISPLAY_DATE: "YYYY년 MM월 DD일";
    readonly DISPLAY_DATETIME: "YYYY년 MM월 DD일 HH:mm";
    readonly COMPACT_DATE: "YYYYMMDD";
    readonly COMPACT_DATETIME: "YYYYMMDDHHmmss";
};
/** 공정 코드 */
export declare const PROCESS_CODES: {
    readonly CUTTING: "CUT";
    readonly CRIMPING: "CRM";
    readonly ASSEMBLY: "ASM";
    readonly INSPECTION: "INS";
    readonly PACKING: "PKG";
};
/** 창고 코드 */
export declare const WAREHOUSE_CODES: {
    readonly RAW_MATERIAL: "WH-RM";
    readonly SEMI_PRODUCT: "WH-SP";
    readonly FINISHED_GOODS: "WH-FG";
    readonly MRB: "WH-MRB";
    readonly HOLD: "WH-HOLD";
    readonly LINE: "WH-LINE";
};
/** QR 코드 접두사 */
export declare const QR_PREFIX: {
    readonly BOX: "BOX";
    readonly PALLET: "PLT";
    readonly LOT: "LOT";
    readonly SERIAL: "SER";
};
/** 권한 코드 */
export declare const PERMISSION_CODES: {
    readonly ADMIN: "ADMIN";
    readonly MANAGER: "MANAGER";
    readonly OPERATOR: "OPERATOR";
    readonly VIEWER: "VIEWER";
};
/** 다국어 지원 언어 */
export declare const SUPPORTED_LANGUAGES: readonly ["ko", "en", "vi"];
export type SupportedLanguage = typeof SUPPORTED_LANGUAGES[number];
/** 교대(Shift) 코드 */
export declare const SHIFT_CODES: {
    readonly DAY: {
        readonly code: "DAY";
        readonly name: {
            readonly ko: "주간";
            readonly en: "Day";
            readonly vi: "Ca ngày";
        };
        readonly startHour: 6;
        readonly endHour: 14;
    };
    readonly SWING: {
        readonly code: "SWING";
        readonly name: {
            readonly ko: "중간";
            readonly en: "Swing";
            readonly vi: "Ca chiều";
        };
        readonly startHour: 14;
        readonly endHour: 22;
    };
    readonly NIGHT: {
        readonly code: "NIGHT";
        readonly name: {
            readonly ko: "야간";
            readonly en: "Night";
            readonly vi: "Ca đêm";
        };
        readonly startHour: 22;
        readonly endHour: 6;
    };
};
/** 단위 코드 */
export declare const UNIT_CODES: {
    readonly EA: {
        readonly code: "EA";
        readonly name: {
            readonly ko: "개";
            readonly en: "EA";
            readonly vi: "Cái";
        };
    };
    readonly M: {
        readonly code: "M";
        readonly name: {
            readonly ko: "미터";
            readonly en: "Meter";
            readonly vi: "Mét";
        };
    };
    readonly KG: {
        readonly code: "KG";
        readonly name: {
            readonly ko: "킬로그램";
            readonly en: "Kilogram";
            readonly vi: "Kg";
        };
    };
    readonly ROLL: {
        readonly code: "ROLL";
        readonly name: {
            readonly ko: "롤";
            readonly en: "Roll";
            readonly vi: "Cuộn";
        };
    };
    readonly SET: {
        readonly code: "SET";
        readonly name: {
            readonly ko: "세트";
            readonly en: "Set";
            readonly vi: "Bộ";
        };
    };
    readonly BOX: {
        readonly code: "BOX";
        readonly name: {
            readonly ko: "박스";
            readonly en: "Box";
            readonly vi: "Hộp";
        };
    };
};
/** 통화 코드 */
export declare const CURRENCY_CODES: {
    readonly KRW: {
        readonly code: "KRW";
        readonly symbol: "₩";
        readonly name: "원";
    };
    readonly USD: {
        readonly code: "USD";
        readonly symbol: "$";
        readonly name: "Dollar";
    };
    readonly VND: {
        readonly code: "VND";
        readonly symbol: "₫";
        readonly name: "Đồng";
    };
};
export * from './menu';
export * from './status';
export * from './process';
export * from './com-code-values';
//# sourceMappingURL=index.d.ts.map