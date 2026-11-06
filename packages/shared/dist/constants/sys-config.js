"use strict";
/**
 * @file packages/shared/src/constants/sys-config.ts
 * @description 환경설정(ISYS_CONFIG) 중 관리자만 바꿀 수 있는 키
 *
 * 초보자 가이드:
 * 1. 백엔드는 이 목록의 값 변경·삭제·등록을 관리자(ADMIN, 사용자 레벨 9 이상)가 아니면 거절한다.
 * 2. 프론트 환경설정 화면은 관리자가 아니면 이 키의 입력을 잠그고 이유를 보여 준다.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.ADMIN_ONLY_CONFIG_KEYS = void 0;
exports.isAdminOnlyConfigKey = isAdminOnlyConfigKey;
exports.ADMIN_ONLY_CONFIG_KEYS = [
    /** 제품 선입선출 — 켜면 307 제품출하가 먼저 들어온 박스부터 나가도록 막는다 */
    'PRODUCT_FIFO_YN',
];
/** 관리자만 바꿀 수 있는 환경설정 키인지 (대소문자·앞뒤 공백 무시) */
function isAdminOnlyConfigKey(configKey) {
    const key = configKey.trim().toUpperCase();
    return exports.ADMIN_ONLY_CONFIG_KEYS.includes(key);
}
