CREATE OR REPLACE PROCEDURE "P_INTERLOCK_CHECK_NG_LOG" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_CHECK_NG_LOG
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2016-04-27
   * 수정이력:
   *   2016-04-27 - zethani(지성솔루션컨설팅) - 인터락 NG 로그 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   인터락 검사 NG 결과를 IQ_INTERLOCK_REQUEST_LOG에 기록한다.
   *   라인, 설비, PID, 요청일자, 공정, 인터락 유형, 반환값과 설명을 저장한다.
   *   자율 트랜잭션으로 로그를 즉시 COMMIT하여 호출 트랜잭션과 분리한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE       (IN, VARCHAR2) - 라인 코드
   *   P_MACHINE_CODE    (IN, VARCHAR2) - 설비 코드
   *   P_SERIAL_NO       (IN, VARCHAR2) - PID 또는 시리얼 번호
   *   P_RESULT_DATE     (IN, DATE) - 요청 또는 결과 발생 일시
   *   P_COMMENT         (IN, VARCHAR2) - 로그 설명
   *   P_WORKSTAGE_CODE  (IN, VARCHAR2) - 공정 코드
   *   P_RETURN_VALUE    (IN, VARCHAR2) - 인터락 반환값
   *   P_INTERLOCK_TYPE  (IN, VARCHAR2) - 인터락 유형
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_INTERLOCK_REQUEST_LOG - 인터락 요청/NG 로그 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - ORA-20003으로 프로시저명과 오류 메시지를 재발생시킨다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: INSERT 1회
   *   주의: AUTONOMOUS_TRANSACTION, COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_CHECK_NG_LOG('L1', 'MC01', 'PID01', SYSDATE, 'NG', 'W010', 'N', 'TYPE')
   * ================================================================ */
 p_line_code        VARCHAR2
                                                      ,p_machine_code     VARCHAR2
                                                      ,p_serial_no        VARCHAR2
                                                      ,p_result_date      DATE

                                                      ,p_comment          VARCHAR2
                                                      ,p_workstage_code   VARCHAR2
                                                      ,p_return_value     VARCHAR2
                                                      ,p_interlock_type   VARCHAR2  )
    /******************************************************************************/
    /* Object Name  : Interlock Ng Logging                                        */
    /* Description  : p_interlock_check ？？？？？？？ NG ？？？？？？？？？                       */
    /* Parameter    : 2016.04.27 zethani                                          */
    /******************************************************************************/
    IS

        PRAGMA AUTONOMOUS_TRANSACTION;

    BEGIN

        -- [AI] 인터락 NG 또는 요청 결과 로그를 기록한다.
        INSERT INTO iq_interlock_request_log
            (line_code,
             machine_code,
             serial_no,
             request_date,
             comments,
             --log_sequence,
             workstage_code,
             interlock_type,
             return_value,
             organization_id
            )
        VALUES
            (p_line_code
            ,p_machine_code
            ,p_serial_no
            ,p_result_date
            ,p_comment

            ,p_workstage_code
            ,p_interlock_type
            ,p_return_value
            ,1
            );

        -- [AI] 자율 트랜잭션 로그를 즉시 확정한다.
        COMMIT;
    EXCEPTION
        -- [AI] 로그 등록 오류를 프로시저명 포함 애플리케이션 오류로 변환한다.
        WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20003, 'PROC=P_INTERLOCK_CHECK_NG_LOG()'||' '||SQLERRM);  -- 2016/10/25 SHS, insert ？？error ？？ser error ？？？

    END;
