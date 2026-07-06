CREATE OR REPLACE PROCEDURE "P_SOUND_MENT_MSG_INS" 
  /* ================================================================
   * 프로시저명  : P_SOUND_MENT_MSG_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   프로시저 원본 로직의 업무 처리 흐름을 수행한다.
   *   참조 테이블과 입력 파라미터를 기반으로 조회, 등록, 갱신 또는 메시지 반환을 처리한다.
   *   원본 코드의 트랜잭션 및 예외 처리 흐름은 변경하지 않았다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   IM_ITEM_BAKING_MASTER - 원본 로직 참조 테이블
   *   IM_ITEM_MSL_CHECK_VIEW - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   *   IQ_INTERLOCK_REFLOW_DATA - 원본 로직 참조 테이블
   *   ISYS_BATCHJOBERRLOG - 원본 로직 참조 테이블
   *   ISYS_SOUND_MENT - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   FROM
   *   F_GET_LINE_NAME
   *   F_GET_REFLOW_STATUS
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_SOUND_MENT_MSG_INS(...)
   * ================================================================ */
IS

   LVS_ERRORMSG VARCHAR2(500); -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

-- REFLOW에 대해 NG 발생시 ISYS_SOUND_MENT table에 Data를 Insert 한다

    INSERT INTO  isys_sound_ment (
                                  sound_id,
                                  sound_text,
                                  sound_status,
                                  sound_level,
                                  time_term,
                                  enter_date,
                                  enter_by,
                                  last_modify_date,
                                  last_modify_by,
                                  organization_id,
                                  line_code,
                                  machine_code,
                                  action_history,
                                  sound_group,
                                  WARNING_DATE
                                 )
    SELECT   to_char(sysdate,'YYYYMMDD')||'-'||trim(to_char(seq_sound_ment_id.nextval,'00000')),  -- SOUND ID
             LINE_NAME||f_msg(' REFLOW 이상 발생!!  ','C',1) ,                                                  -- SOUND MENT
             'O',  -- Open, Close                                                                 -- STATUS
             1,     -- 1                                                                          -- level
             10, -- cycle time 10 minuts                                                          -- time term
             sysdate,
             'REFLOW',
             sysdate,
             'REFLOW',
             1,                                                                                   -- org id
             line_code,                                                                           -- line code
             '*',                                                                                 -- machine code
             NULL,                                                                                -- action history
             'REFLOW',                                                                            -- sound group
             NULL                                                                                 -- wrning_date (방송시간)
    FROM
    (
         SELECT LINE_CODE                                                                    LINE_CODE,
                f_get_line_name(LINE_CODE, 1)                                                LINE_NAME--,
            --    DECODE(F_GET_REFLOW_STATUS('R',  LINE_CODE, ORGANIZATION_ID), 1, 'OK', 'NG') RESULT_DATA,
            --    DECODE(F_GET_REFLOW_STATUS('T',  LINE_CODE, ORGANIZATION_ID), 1, 'OK', 'NG') TEMPERATURE_DATA
           FROM IQ_INTERLOCK_REFLOW_DATA
          WHERE ORGANIZATION_ID  = 1
            AND LINE_CODE IN ( SELECT LINE_CODE
                                 FROM IP_PRODUCT_LINE
                                WHERE MES_DISPLAY_YN = 'Y'
                                  AND LINE_STATUS = 'N'
                                  AND ORGANIZATION_ID  = 1
                             )
            AND (LINE_CODE, ENTER_DATE) IN (
                                            SELECT LINE_CODE,
                                                   MAX(ENTER_DATE)
                                              FROM IQ_INTERLOCK_REFLOW_DATA
                                             WHERE ORGANIZATION_ID  = 1
                                               AND ENTER_DATE >= TO_DATE(SYSDATE,'YYYY-MM-DD')
                                             GROUP BY LINE_CODE
                                           )
            AND (
                  DECODE(F_GET_REFLOW_STATUS('R',  LINE_CODE, ORGANIZATION_ID), 1, 'OK', 'NG') = 'NG' OR
                  DECODE(F_GET_REFLOW_STATUS('T',  LINE_CODE, ORGANIZATION_ID), 1, 'OK', 'NG') = 'NG'
                )
            AND line_code not in (
                                   SELECT line_code
                                     from isys_sound_ment
                                    where organization_id = 1
                                      and sound_group     = 'REFLOW'
                                      and sound_status    = 'O'
                                 )
          GROUP BY LINE_CODE
    );

-- 온도/습도에 대해 NG 발생시 ISYS_SOUND_MENT table에 Data를 Insert 한다

    INSERT INTO  isys_sound_ment (
                                  sound_id,
                                  sound_text,
                                  sound_status,
                                  sound_level,
                                  time_term,
                                  enter_date,
                                  enter_by,
                                  last_modify_date,
                                  last_modify_by,
                                  organization_id,
                                  line_code,
                                  machine_code,
                                  action_history,
                                  sound_group,
                                  WARNING_DATE
                                 )
    SELECT   to_char(sysdate,'YYYYMMDD')||'-'||trim(to_char(seq_sound_ment_id.nextval,'00000')),  -- SOUND ID
             REPLACE(MACHINE_NAME,'-','')||f_msg(' 온습도 이상 발생!!  ','C',1) ,                                -- SOUND MENT
             'O',  -- Open, Close                                                                 -- STATUS
             1,     -- 1                                                                          -- level
             10, -- cycle time 10 minuts                                                          -- time term
             sysdate,
             'HUMIDITY',
             sysdate,
             'HUMIDITY',
             1,                                                                                   -- org id
             '*',                                                                                 -- line code
             MACHINE_CODE,                                                                        -- machine code
             NULL,                                                                                -- action history
             'HUMIDITY',                                                                          -- sound group
             NULL                                                                                 -- warning_date
   FROM (
          SELECT IMCN_MACHINE.MACHINE_NAME as MACHINE_NAME ,
                 IMCN_MACHINE.MACHINE_CODE as MACHINE_CODE,
                 CASE WHEN MIN_TEMP_VALUE <= ROOM_TEMPERATURE AND MAX_TEMP_VALUE >= ROOM_TEMPERATURE THEN 'OK' ELSE 'NG' END TEMP_STATUS ,
                 CASE WHEN MIN_HUMIDITY_VALUE <= HUMIDITY AND MAX_HUMIDITY_VALUE >= HUMIDITY         THEN 'OK' ELSE 'NG' END HUMIDITY_STATUS
            FROM "ICOM_TEMPERATURE_DATA"  , IMCN_MACHINE
           WHERE "ICOM_TEMPERATURE_DATA"."NODETYPE" in (  1   )
              AND UPPER("ICOM_TEMPERATURE_DATA"."NODEID") = IMCN_MACHINE.MACHINE_CODE(+)
              AND IMCN_MACHINE.MES_DISPLAY_YN = 'Y'
              AND machine_code not in (
                                       SELECT machine_code
                                         from isys_sound_ment
                                        where organization_id = 1
                                          and sound_group     = 'HUMIDITY'
                                          and sound_status    = 'O'
                                       )

        )
  WHERE TEMP_STATUS = 'NG' or HUMIDITY_STATUS = 'NG';


  -- MSL 자재 관리 MAX_TIME 기준 90% 이상일경우 알람

    INSERT INTO  isys_sound_ment (
                                  sound_id,
                                  sound_text,
                                  sound_status,
                                  sound_level,
                                  time_term,
                                  enter_date,
                                  enter_by,
                                  last_modify_date,
                                  last_modify_by,
                                  organization_id,
                                  line_code,
                                  machine_code,
                                  action_history,
                                  sound_group,
                                  WARNING_DATE
                                 )
    SELECT   to_char(sysdate,'YYYYMMDD')||'-'||trim(to_char(seq_sound_ment_id.nextval,'00000')),  -- SOUND ID
             f_msg('함습자재 이상발생, 확인 바랍니다!! ','C',1) ,                                                  -- SOUND MENT
             'O',  -- Open, Close                                                                 -- STATUS
             1,     -- 1                                                                          -- level
             10, -- cycle time 10 minuts                                                          -- time term
             sysdate,
             'MSL',
             sysdate,
             'MSL',
             1,                                                                                   -- org id
             LINE_code,                                                                           -- line code
             LOT_NO,                                                                              -- machine code
             NULL,                                                                                -- action history
             'MSL',                                                                               -- sound group
             NULL                                                                                 -- warning_date
          FROM (
                SELECT LINE_code,
                       LOCATION_CODE,
                       ITEM_CODE,
                       LOT_NO,
                       ROUND(DECODE(MSL_PRE_PASSED_TIME,0, decode(baking_count,0,check_pass_time + passed_time, passed_time ), PASSED_TIME)) MSL_PASSED_HOUR,
                       MSL_LEVEL,
                       MSL_MAX_TIME  MSL_MAX_HOUR,
                       MSL_MAX_TIME - ROUND(DECODE(MSL_PRE_PASSED_TIME,0, decode(baking_count,0,check_pass_time + passed_time, passed_time ), PASSED_TIME))  MSL_REMAIN_HOUR,
                      (

                                 SELECT NVL(SUM(1),0)
                                  FROM ISYS_SOUND_MENT
                                 WHERE ORGANIZATION_ID = 1
                                   AND SOUND_GROUP     = 'MSL'
                                   AND SOUND_STATUS    = 'O'
                                   AND LINE_CODE       = A.LINE_CODE
                                   AND MACHINE_CODE    = A.LOT_NO
                                   AND ROWNUM = 1
                       ) NG_COUNT1,
                      ( SELECT  NVL(SUM(1),0)
                                  FROM ISYS_SOUND_MENT
                                 WHERE ORGANIZATION_ID = 1
                                   AND SOUND_GROUP     = 'MSL'
                                   AND SOUND_STATUS    = 'C'
                                   AND LINE_CODE       = A.LINE_CODE
                                   AND MACHINE_CODE    = A.LOT_NO
                                   AND LAST_MODIFY_DATE > sysdate - (6/24)  -- msl 자재중 라벨이력이 없는것을 위해 일단 6시간이내에서 CHECK
                                   AND ROWNUM = 1

                      ) NG_COUNT2
                  FROM (
                         SELECT LINE_CODE,
                                F_GET_LINE_NAME(LINE_CODE,1) LINE_NAME,
                                LOCATION_CODE,
                                ITEM_CODE,
                                LOT_NO,

                                MSL_PRE_PASSED_TIME,
                                PASSED_TIME,
                                MSL_LEVEL,
                                MSL_MAX_TIME,
                               (SELECT MIN(CHECK_DATE)
                                  FROM IB_SMT_CHECKHIST
                                  WHERE LOT_NO = A.LOT_NO) CHECK_MIN_TIME,
                               (SELECT MAX(CHECK_DATE)
                                  FROM IB_SMT_CHECKHIST
                                  WHERE LOT_NO = A.LOT_NO) CHECK_MAX_TIME,
                                ROUND((SELECT (MAX(CHECK_DATE) - MIN(CHECK_DATE)) * 24
                                         FROM IB_SMT_CHECKHIST
                                        WHERE LOT_NO = A.LOT_NO)) CHECK_PASS_TIME,
                                (SELECT SUM(1)
                                   FROM IB_SMT_CHECKHIST
                                  WHERE LOT_NO = A.LOT_NO
                                    AND CHECK_STATUS = 'P' )  CHECK_COUNT ,
                                (
                                  SELECT NVL(SUM(1),0)
                                    FROM IM_ITEM_BAKING_MASTER
                                   WHERE LOT_NO = A.LOT_NO
                                     AND ROWNUM = 1
                                ) BAKING_COUNT
                           FROM IM_ITEM_MSL_CHECK_VIEW A
                          WHERE MSL_LEVEL >= '3'
                           -- AND (LINE_CODE LIKE :ARG_LINE_CODE OR LINE_CODE IN (:ARG_MULTI_LINE_CODE))
                       ) A
                 WHERE DECODE(MSL_PRE_PASSED_TIME,0, decode(baking_count,0,check_pass_time + passed_time, passed_time ),PASSED_TIME) >=  (MSL_MAX_TIME * 0.7)
                 ORDER BY LINE_NAME, LOCATION_CODE
               )
         WHERE MSL_PASSED_HOUR / MSL_MAX_HOUR > 0.9
          AND NG_COUNT1 = 0
          and NG_COUNT2 = 0;

  --------------------------------------------------------------------------------------------------------------------------------------------

    COMMIT;

EXCEPTION

   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN

        LVS_ERRORMSG := SUBSTR(SQLERRM, 1, 200);
        ROLLBACK;

        BEGIN

            INSERT INTO ISYS_BATCHJOBERRLOG(
                                            batch_job_seq,
                                            organization_id,
                                            batch_job_process_name,
                                            batch_job_object_name,
                                            batch_job_status_code,
                                            batch_job_remark,
                                            enter_by,
                                            log_date
                                            )
            SELECT 2,
                   1,
                   'SOUND MSG INSERT',
                   'P_SOUND_MENT_MSG_INS',
                   'ERROR',
                   LVS_ERRORMSG,
                   'BATCH',
                   sysdate
              FROM DUAL;

             COMMIT;

        EXCEPTION

   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
           WHEN OTHERS THEN
                NULL;

        END;

END;