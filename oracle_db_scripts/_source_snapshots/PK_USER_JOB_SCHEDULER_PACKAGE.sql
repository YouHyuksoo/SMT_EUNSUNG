PACKAGE "PK_USER_JOB_SCHEDULER" 
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

END; -- Package spec