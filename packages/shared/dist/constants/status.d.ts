/**
 * @file packages/shared/src/constants/status.ts
 * @description 상태 코드 상수 및 라벨 정의
 *
 * 초보자 가이드:
 * 1. **STATUS_LABELS**: UI에 표시할 상태 라벨 (다국어 지원)
 * 2. **STATUS_COLORS**: 상태별 색상 (Tailwind CSS 클래스)
 * 3. **getStatusLabel()**: 상태 코드를 라벨로 변환
 */
import type { SupportedLanguage } from './index';
/** 상태 라벨 타입 */
export interface StatusLabel {
    ko: string;
    en: string;
    vi: string;
}
/** 작업 상태 라벨 */
export declare const WORK_STATUS_LABELS: Record<string, StatusLabel>;
/** 작업 상태 색상 */
export declare const WORK_STATUS_COLORS: Record<string, string>;
/** 품질 판정 라벨 */
export declare const QUALITY_JUDGMENT_LABELS: Record<string, StatusLabel>;
/** 품질 판정 색상 */
export declare const QUALITY_JUDGMENT_COLORS: Record<string, string>;
/** 설비 상태 라벨 */
export declare const EQUIPMENT_STATUS_LABELS: Record<string, StatusLabel>;
/** 설비 상태 색상 */
export declare const EQUIPMENT_STATUS_COLORS: Record<string, string>;
/** 출하 상태 라벨 */
export declare const SHIPMENT_STATUS_LABELS: Record<string, StatusLabel>;
/** 출하 상태 색상 */
export declare const SHIPMENT_STATUS_COLORS: Record<string, string>;
/** 불량 처리 라벨 */
export declare const DEFECT_DISPOSITION_LABELS: Record<string, StatusLabel>;
/** 불량 처리 색상 */
export declare const DEFECT_DISPOSITION_COLORS: Record<string, string>;
/** 인터페이스 상태 라벨 */
export declare const INTERFACE_STATUS_LABELS: Record<string, StatusLabel>;
/** 인터페이스 상태 색상 */
export declare const INTERFACE_STATUS_COLORS: Record<string, string>;
/**
 * 상태 코드를 라벨로 변환
 * @param statusLabels 상태 라벨 객체
 * @param code 상태 코드
 * @param lang 언어 코드
 * @returns 해당 언어의 라벨
 */
export declare function getStatusLabel(statusLabels: Record<string, StatusLabel>, code: string, lang?: SupportedLanguage): string;
/**
 * 상태 코드에 해당하는 색상 클래스 반환
 * @param statusColors 상태 색상 객체
 * @param code 상태 코드
 * @returns Tailwind CSS 클래스
 */
export declare function getStatusColor(statusColors: Record<string, string>, code: string): string;
//# sourceMappingURL=status.d.ts.map