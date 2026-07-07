/**
 * @file packages/shared/src/utils/date.ts
 * @description 날짜 관련 유틸리티 함수
 *
 * 초보자 가이드:
 * 1. **formatDate()**: 날짜를 원하는 형식의 문자열로 변환
 * 2. **getDatePrefix()**: LOT 번호 등에 사용할 날짜 접두사 생성
 * 3. **parseDate()**: 문자열을 Date 객체로 변환
 */
/**
 * 날짜를 지정된 형식의 문자열로 변환
 * @param date 날짜 (Date 객체 또는 문자열)
 * @param format 형식 (기본값: 'YYYY-MM-DD')
 * @returns 형식화된 날짜 문자열
 *
 * @example
 * formatDate(new Date(), 'YYYY-MM-DD')         // '2024-01-15'
 * formatDate(new Date(), 'YYYY-MM-DD HH:mm')   // '2024-01-15 09:30'
 * formatDate(new Date(), 'YYYY년 MM월 DD일')   // '2024년 01월 15일'
 */
export declare function formatDate(date: Date | string | null | undefined, format?: string): string;
/**
 * 날짜 접두사 생성 (YYYYMMDD 형식)
 * @param date 날짜 (기본값: 현재 날짜)
 * @returns YYYYMMDD 형식의 문자열
 *
 * @example
 * getDatePrefix()                    // '20240115'
 * getDatePrefix(new Date(2024, 0, 1)) // '20240101'
 */
export declare function getDatePrefix(date?: Date): string;
/**
 * 날짜+시간 접두사 생성 (YYYYMMDDHHmmss 형식)
 * @param date 날짜 (기본값: 현재 날짜)
 * @returns YYYYMMDDHHmmss 형식의 문자열
 *
 * @example
 * getDateTimePrefix() // '20240115093045'
 */
export declare function getDateTimePrefix(date?: Date): string;
/**
 * 날짜 문자열을 Date 객체로 변환
 * @param dateStr 날짜 문자열
 * @returns Date 객체 또는 null
 */
export declare function parseDate(dateStr: string | null | undefined): Date | null;
/**
 * 오늘 날짜인지 확인
 * @param date 확인할 날짜
 * @returns 오늘이면 true
 */
export declare function isToday(date: Date | string): boolean;
/**
 * 두 날짜 사이의 일수 계산
 * @param startDate 시작 날짜
 * @param endDate 종료 날짜
 * @returns 일수 차이
 */
export declare function daysBetween(startDate: Date | string, endDate: Date | string): number;
/**
 * 날짜에 일수 더하기
 * @param date 기준 날짜
 * @param days 더할 일수 (음수면 빼기)
 * @returns 새로운 Date 객체
 */
export declare function addDays(date: Date | string, days: number): Date;
/**
 * 해당 월의 첫째 날 반환
 * @param date 기준 날짜
 * @returns 해당 월의 1일
 */
export declare function getFirstDayOfMonth(date?: Date): Date;
/**
 * 해당 월의 마지막 날 반환
 * @param date 기준 날짜
 * @returns 해당 월의 마지막 날
 */
export declare function getLastDayOfMonth(date?: Date): Date;
/**
 * 해당 주의 시작일 반환 (월요일 기준)
 * @param date 기준 날짜
 * @returns 해당 주의 월요일
 */
export declare function getStartOfWeek(date?: Date): Date;
/**
 * 근무 시간(교대) 코드 반환
 * @param date 시간 (기본값: 현재)
 * @returns 교대 코드 (DAY, SWING, NIGHT)
 *
 * @example
 * // 오전 9시 -> 'DAY'
 * // 오후 4시 -> 'SWING'
 * // 밤 12시 -> 'NIGHT'
 */
export declare function getShiftCode(date?: Date): 'DAY' | 'SWING' | 'NIGHT';
/**
 * 작업일 기준 날짜 반환 (야간근무 시 전날로 처리)
 * @param date 기준 시간
 * @returns 작업일 Date
 */
export declare function getWorkDate(date?: Date): Date;
/**
 * 시간 차이를 사람이 읽기 쉬운 형태로 반환
 * @param date 비교 날짜
 * @param lang 언어 코드
 * @returns '방금 전', '5분 전', '2시간 전' 등
 */
export declare function getRelativeTime(date: Date | string, lang?: 'ko' | 'en' | 'vi'): string;
//# sourceMappingURL=date.d.ts.map
