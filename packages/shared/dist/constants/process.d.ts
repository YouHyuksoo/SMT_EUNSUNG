/**
 * @file packages/shared/src/constants/process.ts
 * @description 공정 관련 상수 정의
 *
 * 초보자 가이드:
 * 1. **PROCESS_CODES**: 공정 코드와 이름 매핑
 * 2. **PROCESS_ORDER**: 공정 순서 정의
 * 3. **PROCESS_CONFIG**: 공정별 설정값
 */
import type { SupportedLanguage } from './index';
/** 공정 정보 타입 */
export interface ProcessInfo {
    code: string;
    name: {
        ko: string;
        en: string;
        vi: string;
    };
    shortCode: string;
    order: number;
    color: string;
}
/** 공정 정보 */
export declare const PROCESSES: Record<string, ProcessInfo>;
/** 공정 코드 목록 (순서대로) */
export declare const PROCESS_ORDER: readonly ["CUTTING", "CRIMPING", "ASSEMBLY", "INSPECTION", "PACKING"];
/** 공정 Short 코드 매핑 */
export declare const PROCESS_SHORT_CODES: Record<string, string>;
/** 공정별 기본 설정 */
export declare const PROCESS_CONFIG: Record<string, {
    hasApplicator: boolean;
    hasBlade: boolean;
    requiresMaterialInput: boolean;
    supportsRework: boolean;
    defaultCycleTime: number;
}>;
/** 불량코드 그룹 (공정별) */
export declare const DEFECT_CODE_GROUPS: Record<string, {
    code: string;
    name: {
        ko: string;
        en: string;
        vi: string;
    };
}[]>;
/**
 * 공정 코드로 공정 이름 반환
 * @param code 공정 코드
 * @param lang 언어
 * @returns 공정 이름
 */
export declare function getProcessName(code: string, lang?: SupportedLanguage): string;
/**
 * 공정 코드로 Short 코드 반환
 * @param code 공정 코드
 * @returns Short 코드
 */
export declare function getProcessShortCode(code: string): string;
/**
 * Short 코드로 공정 코드 반환
 * @param shortCode Short 코드
 * @returns 공정 코드
 */
export declare function getProcessCodeByShort(shortCode: string): string | undefined;
//# sourceMappingURL=process.d.ts.map