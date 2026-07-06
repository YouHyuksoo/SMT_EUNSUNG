CREATE OR REPLACE PROCEDURE "P_JOB_ERRORLOG" (
  /* ================================================================
   * 프로시저명  : P_JOB_ERRORLOG
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   배치 작업 오류 정보를 ISYS_BATCHJOBERRLOG에 기록한다.
   *   작업 번호, 조직, 프로세스명, 오브젝트명, 비고를 받아 Error 상태 로그로 저장한다.
   *   자율 트랜잭션으로 처리되어 호출 트랜잭션과 별도로 COMMIT 또는 ROLLBACK된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_WORK_NO          (IN, NUMBER) - 배치 작업 번호
   *   P_ORGANIZATION_ID  (IN, NUMBER) - 조직 ID
   *   P_PROCESS_NAME     (IN, VARCHAR2) - 배치 프로세스명
   *   P_PROCESS_OBJECT   (IN, VARCHAR2) - 오류 발생 오브젝트명
   *   P_REMARK           (IN, VARCHAR2) - 오류 비고 또는 상세 메시지
   *   P_WORK_MAN         (IN, VARCHAR2) - 작업자 입력값, 현재 로직에서는 미사용
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ISYS_BATCHJOBERRLOG - 배치 작업 오류 로그 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - 오류 발생 시 자율 트랜잭션을 ROLLBACK한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: INSERT 1회
   *   주의: AUTONOMOUS_TRANSACTION, COMMIT 및 ROLLBACK 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_JOB_ERRORLOG(1, 1, 'PROC', 'OBJECT', 'ERROR MESSAGE', 'USER')
   * ================================================================ */
 p_work_no NUMBER
                                            ,p_organization_id  NUMBER
                                            ,p_process_name     VARCHAR2
                                            ,p_process_object   VARCHAR2
                                            ,p_remark           VARCHAR2
                                            ,p_work_man         VARCHAR2)
    /******************************************************************************/
    /* Object Name  : worklog_start                                               */
    /* Description  : Work？？？？Log？？？？                                          */
    /* Parameter                                                                  */
    /******************************************************************************/
    IS
        v_work_man    VARCHAR2(25); -- [AI] 오류 로그 등록자 값
        PRAGMA AUTONOMOUS_TRANSACTION;

    BEGIN

        -- [AI] 오류 로그 등록자를 고정 시스템 값으로 설정한다.
        v_work_man  := 'Logger';

        -- [AI] 배치 작업 오류 정보를 별도 로그 테이블에 기록한다.
        INSERT INTO ISYS_BATCHJOBERRLOG
            (batch_job_seq
            ,organization_id
            ,batch_job_process_name
            ,batch_job_object_name
            ,batch_job_status_code
            ,batch_job_remark
            ,ENTER_by
            ,log_date
            )
        VALUES
            (p_work_no
            ,p_organization_id
            ,p_process_name
            ,p_process_object
            ,'Error'
            ,p_remark
            ,v_work_man
            ,sysdate
            );

        -- [AI] 자율 트랜잭션의 로그 기록을 확정한다.
        COMMIT;
    EXCEPTION
        -- [AI] 오류 발생 시 자율 트랜잭션 변경 내용을 되돌린다.
        WHEN OTHERS THEN
            ROLLBACK;

    END p_job_errorlog;
