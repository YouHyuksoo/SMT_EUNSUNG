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
export function sqlSolderNgCount(): string {
  return `
SELECT COUNT(*) AS NG_COUNT
  FROM IM_ITEM_SOLDER_MASTER
 WHERE ISSUE_DATE IS NOT NULL
   AND DESTROY_DATE IS NULL
   AND ORGANIZATION_ID = 1
   AND (
     (
       LENGTH(
         F_GET_TIME_TERM_HMI(
           NVL(NVL(NVL(VISCOSITY_START_DATE, FIRST_LINE_INPUT_DATE), INPUT_DATE), SYSDATE),
           SYSDATE
         )
       ) = 5
       AND F_GET_TIME_TERM_HMI(
             NVL(NVL(NVL(VISCOSITY_START_DATE, FIRST_LINE_INPUT_DATE), INPUT_DATE), SYSDATE),
             SYSDATE
           ) > '11:30'
     )
     OR F_GET_TIME_STR(
          DECODE(
            SIGN((NVL(DESTROY_DATE, SYSDATE) - NVL(UNFREEZING_START_DATE, SYSDATE)) * 24),
            -1, 0,
            (NVL(DESTROY_DATE, SYSDATE) - NVL(UNFREEZING_START_DATE, SYSDATE)) * 24
          )
        ) > '23:30'
     OR (TRUNC(VALID_DATE) - TRUNC(SYSDATE)) <= 0
   )
`;
}

/**
 * MSL NG 건수 조회 (d_display_msl_waring_ng_count).
 * PB 원본에서 msl_passed_hour/msl_max_hour > 0.99 AND ng_count >= 1인 건수를 센다.
 * NG > 0이면 경고 사운드 대신 화면 상단에 경고 배너를 표시한다.
 * @returns SQL 문자열
 */
export function sqlMslNgCount(): string {
  return `
SELECT nvl(sum(1), 0) AS ng_count
  FROM (
    SELECT line_name,
           location_code,
           item_code,
           lot_no,
           trunc(passed_time, 2)                          AS msl_passed_hour,
           msl_level,
           msl_max_time                                   AS msl_max_hour,
           trunc(msl_max_time - passed_time, 2)           AS msl_remain_hour,
           (
             SELECT nvl(sum(1), 0)
               FROM isys_sound_ment
              WHERE organization_id = 1
                AND sound_group    = 'MSL'
                AND sound_status   = 'O'
                AND line_code      = A.line_code
                AND machine_code   = A.lot_no
                AND rownum = 1
           ) AS ng_count
      FROM (
             SELECT line_code,
                    f_get_line_name(line_code, 1)          AS line_name,
                    location_code,
                    item_code,
                    lot_no,
                    msl_pre_passed_time,
                    passed_time,
                    msl_level,
                    msl_max_time,
                    (SELECT min(check_date)
                       FROM ib_smt_checkhist
                      WHERE lot_no = a.lot_no)             AS check_min_time,
                    (SELECT max(check_date)
                       FROM ib_smt_checkhist
                      WHERE lot_no = a.lot_no)             AS check_max_time,
                    round(
                      (SELECT (max(check_date) - min(check_date)) * 24
                         FROM ib_smt_checkhist
                        WHERE lot_no = a.lot_no)
                    )                                      AS check_pass_time,
                    (SELECT sum(1)
                       FROM ib_smt_checkhist
                      WHERE lot_no = a.lot_no
                        AND check_status = 'P')            AS check_count,
                    (
                      SELECT nvl(sum(1), 0)
                        FROM IM_ITEM_BAKING_MASTER
                       WHERE lot_no = a.lot_no
                         AND rownum = 1
                    )                                      AS baking_count
               FROM IM_ITEM_MSL_CHECK_VIEW a
              WHERE MSL_LEVEL >= '2A'
           ) a
     WHERE decode(msl_pre_passed_time, 0,
             decode(baking_count, 0, check_pass_time + passed_time, passed_time),
             passed_time
           ) >= (msl_max_time * 0.7)
     ORDER BY line_name, location_code
  )
 WHERE msl_passed_hour / msl_max_hour > 0.99
   AND ng_count >= 1
`;
}
