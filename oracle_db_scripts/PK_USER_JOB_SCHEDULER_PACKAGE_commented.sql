CREATE OR REPLACE PACKAGE
  /* ================================================================
   * 패키지명  : PK_USER_JOB_SCHEDULER
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   사용자 작업 또는 스케줄러 실행을 관리하는 공통 로직을 제공한다.
   *   작업 등록, 실행, 상태 관리 흐름에서 호출되는 것으로 추정된다.
   * ================================================================
   * [AI 분석] 공개/구현 객체:
   *   PROCEDURE PS_DBMS_JOB_SUBMIT - 패키지 내 업무 처리 단위
   *   PROCEDURE PS_DBMS_JOB_RUN - 패키지 내 업무 처리 단위
   *   PROCEDURE PS_DBMS_JOB_REMOVE - 패키지 내 업무 처리 단위
   *   PROCEDURE PS_DBMS_JOB_BROKEN - 패키지 내 업무 처리 단위
   *   PROCEDURE PS_DBMS_JOB_CHANGE - 패키지 내 업무 처리 단위
   *   PROCEDURE PS_RECOMPILER - 패키지 내 업무 처리 단위
   *   FUNCTION F_GET_NEXTDATE - 패키지 내 업무 처리 단위
   *   PROCEDURE PS_RELEASE_16_JOB - 패키지 내 업무 처리 단위
   *   FUNCTION F_JOB_SHCEDULER - 패키지 내 업무 처리 단위
   *   FUNCTION FN_GET_REPLACE - 패키지 내 업무 처리 단위
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (패키지 선언부 또는 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   EXEC PK_USER_JOB_SCHEDULER.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "PK_USER_JOB_SCHEDULER" 
  IS
-----------------------------------------------------------------
-- Purpose: Batch job scheduler
--
-- MODIFICATION HISTORY
-- 수정변경 사항이 있을시 UI에 적용되는 부분이 있으니 먼저 확인 하세요!!
-- Person      Date       Comments
-- ---------   ---------  ------------------------------------------
-- Kim.j.h     2007.09    initial   rev 0.1
-- ---------   ---------  -----------------------------------------
   /*PROCEDURE ps_dbms_job_log (  p_organization_id IN NUMBER,
                                p_job_id          IN NUMBER,
                                p_job_name        IN VARCHAR2,
                                p_job_parameters  IN VARCHAR2,
                                p_job_msg         IN VARCHAR2,
                                p_job_start_date  IN DATE,
                                p_job_status      IN VARCHAR2,
                                p_job_error_desc  IN VARCHAR2,
                                p_job_row_traker  IN VARCHAR2   ) ;*/

   PROCEDURE ps_dbms_job_submit ( parm_what       IN VARCHAR2,
                                  parm_next_date  IN varchar2,
                                  parm_interval   IN VARCHAR2,
                                  parm_return     OUT NUMBER
                                ) ;

   PROCEDURE ps_dbms_job_run    ( parm_job_id IN NUMBER ,
                                  parm_return OUT NUMBER ) ;

   PROCEDURE ps_dbms_job_remove ( parm_job_id   IN NUMBER  ,
                                  parm_return OUT NUMBER ) ;

   PROCEDURE ps_dbms_job_broken ( parm_job_id    IN NUMBER,
                                  parm_broken IN VARCHAR2 DEFAULT 'TRUE',
                                  parm_return OUT NUMBER   ) ;

   PROCEDURE ps_dbms_job_change ( parm_job_id    IN NUMBER ,
                                  parm_what      IN VARCHAR2,
                                  parm_next_date IN varchar2,
                                  parm_interval  IN VARCHAR2,
                                  parm_return    OUT NUMBER  ) ;



   /* 수작업용 recompiler */
   PROCEDURE ps_recompiler (   o_owner    IN   VARCHAR2
                             , o_name     IN   VARCHAR2
                             , o_type     IN   VARCHAR2
                             , o_status   IN   VARCHAR2
                             , display    IN   BOOLEAN  );

   FUNCTION F_GET_NEXTDATE  ( PARM_JOBID    IN NUMBER,
                              PARM_INTERVAL IN NUMBER ) RETURN  DATE ;
   /* 16 에 대한 Release Job */
   PROCEDURE PS_RELEASE_16_JOB ;


   FUNCTION F_JOB_SHCEDULER
  ( param_command   IN VARCHAR2 := 'RUN',
    param_job_id    IN NUMBER   := 0 ,
    param_what      IN VARCHAR2 := '',
    param_next_date IN date     := sysdate,
    param_interval  IN VARCHAR2 := 'SYSDATE + 1/24',
    param_broken    IN VARCHAR2 := 'TRUE'
  )
  RETURN  NUMBER ;

  function fn_get_replace ( p_str in   VARCHAR2 )   return VARCHAR2 ;

END; -- Package spec;
