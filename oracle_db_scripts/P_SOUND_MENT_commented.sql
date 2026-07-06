CREATE OR REPLACE PROCEDURE "P_SOUND_MENT" 
  /* ================================================================
   * 프로시저명  : P_SOUND_MENT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 장치 또는 출력 관련 메시지를 생성/전송한다.
   *   입력 파라미터를 원본 통신/출력 포맷에 맞춰 처리한다.
   *   통신 또는 출력 오류는 원본 예외 처리 방식으로 호출부에 전달한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   없음
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IMCN_MACHINE - 원본 로직 참조 테이블
   *   ISYS_BATCHJOBERRLOG - 원본 로직 참조 테이블
   *   ISYS_SOUND_MENT - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_INTERLOCK_SET_NSNP
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_SOUND_MENT(...)
   * ================================================================ */
IS

    CURSOR C_MENT IS
    SELECT ORGANIZATION_ID, SOUND_ID, SOUND_TEXT
      FROM ISYS_SOUND_MENT
     WHERE ORGANIZATION_ID = 1
       AND SOUND_STATUS    = 'O'
       AND (
            WARNING_DATE IS NULL OR
            (SYSDATE - NVL(WARNING_DATE,SYSDATE)) * (24*60) >= TIME_TERM
           );

     LVS_SOUND_IP   VARCHAR2(20); -- [AI] 내부 처리용 변수
     LVS_ERRORMSG   VARCHAR2(3000);  -- buffwe size ？？？？ 500 > 3000 -- [AI] 내부 처리용 변수
     LVS_SOUNDMSG   VARCHAR2(3000);  -- buffwe size ？？？？ 500 > 3000 -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

     LVS_SOUNDMSG := '';

-- ISYS_SOUND_MENT TABLE ？？ ？？？？？？NG？？ ？？ ？？？？ PC？？ Message ？？？？

     SELECT IP_ADDRESS
       INTO LVS_SOUND_IP
       FROM IMCN_MACHINE
      WHERE MACHINE_CODE = 'SOUND';

    FOR C_VAR IN C_MENT LOOP

 --       BEGIN

           LVS_SOUNDMSG := LVS_SOUNDMSG||C_VAR.SOUND_TEXT||'.....';

           UPDATE ISYS_SOUND_MENT
              SET WARNING_DATE    = SYSDATE
            WHERE SOUND_ID        = C_VAR.SOUND_ID
              AND ORGANIZATION_ID = C_VAR.ORGANIZATION_ID;

           -- COMMIT;

           -- sys.dbms_lock.sleep(5);   -- 3 sec delay


 --       EXCEPTION

 --          WHEN OTHERS THEN

--                 NULL;

--        END;


    END LOOP;

   P_INTERLOCK_SET_NSNP( LVS_SOUND_IP, 'SOUND, '||LVS_SOUNDMSG );

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
            SELECT 1,
                   1,
                   'SOUND OUT',
                   'P_SOUND_MENT',
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