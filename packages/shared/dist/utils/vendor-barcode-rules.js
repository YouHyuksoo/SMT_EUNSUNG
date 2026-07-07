"use strict";
/**
 * @file packages/shared/src/utils/vendor-barcode-rules.ts
 * @description 거래처 바코드 매핑 매칭유형 enum (프론트/백엔드 단일 출처)
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.VENDOR_BARCODE_DEFAULT_MATCH_TYPE = exports.VENDOR_BARCODE_MATCH_TYPES = void 0;
/** 바코드 매칭 유형 값 집합 (정확일치 / 접두사 / 정규식) */
exports.VENDOR_BARCODE_MATCH_TYPES = ['EXACT', 'PREFIX', 'REGEX'];
/** 기본 매칭 유형 */
exports.VENDOR_BARCODE_DEFAULT_MATCH_TYPE = 'EXACT';
