CREATE OR REPLACE PROCEDURE "P_CREATE_LINE_TARGET_INS" 
  /* ================================================================
   * 프로시저명  : P_CREATE_LINE_TARGET_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   업무 기준 데이터를 생성하고 대상 테이블에 등록한다.
   *   시퀀스, 현재일자, 입력 파라미터 등 원본 생성 규칙을 그대로 사용한다.
   *   정상 처리 또는 오류 결과는 원본 OUT 파라미터/예외 처리 흐름을 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_ORGANIZATION_ID - 원본 선언부 기준 입력/출력 파라미터
   *   P_WORK_DATE - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE_TARGET - 원본 로직 참조 테이블
   *   ISYS_BATCHJOBERRLOG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CREATE_LINE_TARGET_INS(...)
   * ================================================================ */
(
   P_ORGANIZATION_ID IN NUMBER,
   P_WORK_DATE       IN DATE
)
IS

   LVS_ERRORMSG      VARCHAR2(500); -- [AI] 내부 처리용 변수

BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

-- ？？？？？ TARGET ？？？？ ？？？？ ？？？？ ？？？？？？？？？？？？？？ ？？ ？  (？？？ ？？ ？？？？？？？？？？？？？？ ？？)

  DELETE FROM IP_PRODUCT_LINE_TARGET
   WHERE PLAN_DATE > TRUNC(P_WORK_DATE)
     AND ORGANIZATION_ID = P_ORGANIZATION_ID;



-- ？？？？？？？？？？ ？？？？？ ？？？ ？？？？  (？？？ ？？ ？？？ ？？？？？？？ ？？？？)

  INSERT INTO IP_PRODUCT_LINE_TARGET (
                                      PLAN_DATE,
                                      LINE_CODE,
                                      SHIFT_CODE,
                                      WORKING_START_DATE,
                                      WORKING_END_DATE,
                                      WORKING_HOUR,
                                      WORKER_QTY,
                                      PLAN_QTY,
                                      STD_ST,
                                      STD_TT,
                                      COMMENTS,
                                      ORGANIZATION_ID,
                                      ENTER_DATE,
                                      ENTER_BY,
                                      LAST_MODIFY_DATE,
                                      LAST_MODIFY_BY
                                     )
  SELECT PLAN_DATE + 7,
         LINE_CODE,
         SHIFT_CODE,
         NVL(WORKING_START_DATE, SYSDATE) +7,
         NVL(WORKING_END_DATE,   SYSDATE) +7,
         (NVL(WORKING_END_DATE,  SYSDATE) - NVL(WORKING_START_DATE, SYSDATE)) * 24,
         WORKER_QTY,
         PLAN_QTY,
         STD_ST,
         STD_TT,
         COMMENTS,
         ORGANIZATION_ID,
         SYSDATE,
         'BATCH',
         SYSDATE,
         'BATCH'
    FROM IP_PRODUCT_LINE_TARGET
   WHERE PLAN_DATE       >= TRUNC((P_WORK_DATE) -6)
     AND PLAN_DATE       <= TRUNC( P_WORK_DATE )
     AND ORGANIZATION_ID =  P_ORGANIZATION_ID ;

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
            SELECT 4,
                   1,
                   'LINE_TARGET',
                   'P_CREATE_LINE_TARGET_INS',
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