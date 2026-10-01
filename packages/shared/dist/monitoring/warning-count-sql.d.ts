/**
 * @file packages/shared/src/monitoring/warning-count-sql.ts
 * @description 솔더 페이스트·MSL NG 건수 SQL. 모니터링 display(31, 29)와 백엔드 대시보드가 같은 기준을 쓴다.
 *
 * 초보자 가이드:
 * 1. PB 원본 d_display_solder_waring_ng_count2 / d_display_msl_waring_ng_count 조건 그대로다.
 * 2. 경고 기준을 바꾸려면 이 파일만 고친다. 두 화면이 함께 바뀐다.
 */
/**
 * Solder Paste NG 건수 조회 (d_display_solder_waring_ng_count2).
 * gap3 > '11:30' (5자리) OR aftr_unfreezing_time > '23:30' OR 유효기간 만료 시 NG.
 * NG > 0이면 경고 사운드 대신 화면 상단에 경고 배너를 표시한다.
 */
export declare function sqlSolderNgCount(): string;
/**
 * MSL NG 건수 조회 (d_display_msl_waring_ng_count).
 * PB 원본에서 msl_passed_hour/msl_max_hour > 0.99 AND ng_count >= 1인 건수를 센다.
 * NG > 0이면 경고 사운드 대신 화면 상단에 경고 배너를 표시한다.
 * @returns SQL 문자열
 */
export declare function sqlMslNgCount(): string;
//# sourceMappingURL=warning-count-sql.d.ts.map