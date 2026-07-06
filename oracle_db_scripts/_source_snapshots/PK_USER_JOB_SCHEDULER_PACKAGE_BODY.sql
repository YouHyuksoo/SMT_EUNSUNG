PACKAGE BODY "PK_USER_JOB_SCHEDULER" IS

/*  PROCEDURE ps_dbms_job_log ( p_organization_id IN NUMBER,
                              p_job_id          IN NUMBER,
                              p_job_name        IN VARCHAR2,
                              p_job_parameters  IN VARCHAR2,
                              p_job_msg         IN VARCHAR2,
                              p_job_start_date  IN DATE,
                              p_job_status      IN VARCHAR2,
                              p_job_error_desc  IN VARCHAR2,
                              p_job_row_traker  IN VARCHAR2     ) IS
    PRAGMA AUTONOMOUS_TRANSACTION ;
  -- -----------------------------
     lvs_module VARCHAR2(1000);
     lvs_action VARCHAR2(1000);
  -- ----------------------------
  BEGIN
    DBMS_APPLICATION_INFO.read_module(module_name => lvs_module,action_name => lvs_action);

    INSERT INTO TB_SYS_JOB_LOG
           ( organization_id, program_id    , job_name    , job_prameters , job_message      ,
            job_log_date   , job_start_date, job_end_date, job_end_status, job_log_desc     ,
            job_row_tracker, ip_address    , terminal    , os_user       , network_protocol ,
            host           , current_sql   , client_info , is_error      , client_identifier,
            CURRENT_USER   , db_name       , exe_module  , exe_action
          )
    VALUES (
            p_organization_id                      ,p_job_id                             ,p_job_name                           ,p_job_parameters                 ,p_job_msg
           ,SYSDATE                                ,p_job_start_date                     ,SYSDATE                              ,p_job_status                     ,p_job_error_desc
           ,p_job_row_traker                       ,SYS_CONTEXT ('USERENV','IP_ADDRESS') ,SYS_CONTEXT ('USERENV','TERMINAL')   ,SYS_CONTEXT ('USERENV','OS_USER'),SYS_CONTEXT ('USERENV','NETWORK_PROTOCOL')
           ,SYS_CONTEXT ('USERENV','HOST')         ,SYS_CONTEXT ('USERENV','CURRENT_SQL'),SYS_CONTEXT ('USREENV','CLIENT_INFO'),SYS_CONTEXT ('USERENV','ISDBA')  ,SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')
           ,SYS_CONTEXT ('USERENV','CURRENT_USER') ,SYS_CONTEXT ('USERENV','DB_NAME')    ,lvs_module                           ,lvs_action
          );
    COMMIT ;

  END ps_dbms_job_log;   */



  PROCEDURE ps_dbms_job_submit( parm_what       IN VARCHAR2,
                                parm_next_date  IN varchar2,
                                parm_interval   IN VARCHAR2,
                                parm_return     OUT NUMBER    --> job id 반환
                              ) IS
    /*============================================================================
      공통 Tracking 을 위한
    ============================================================================*/
    MyJobID               NUMBER                               ; --Job ID User Define
    MyJobName             VARCHAR2(150) := 'F_DBMS_JOB_SUBMIT' ; --Object Name
    MyjobParameters       VARCHAR2(4000) :=  '1.What : '||parm_what
                                          ||'2.Next Date :'||parm_next_date
                                          ||'3.Interval  :'||parm_interval ;         --Prarameters
    MyjobMessage          VARCHAR2(1000);                  --Message
    MyjobStartDate        DATE          := SYSDATE   ;     --Job Start Time
    MyjobStatus           VARCHAR2(25)  := 'SUCCESS' ;     --Eror or Success Flag
    MyjobPosition         VARCHAR2(1000);                  --Error Tracking
    MyjobCursor           VARCHAR2(1000):= 'None'    ;     --Error Tracking
    /*============================================================================*/
    next_job_id NUMBER ;
    parm_job_id NUMBER ;
    ln_check    NUMBER ;
  BEGIN
      parm_job_id := 1 ;

      SELECT COUNT(*)
        INTO ln_check
        FROM user_jobs a
       WHERE a.job = parm_job_id ;

      IF ln_check > 0 THEN
          SELECT NVL(MAX(JOB),0) + 10
            INTO next_job_id
            FROM USER_JOBS ;
      ELSE
           next_job_id := parm_job_id ;
      END IF ;

      DBMS_JOB.ISUBMIT(next_job_id, replace(REPLACE(parm_what,chr(13),''),chr(34),''),
                                            to_date(parm_next_date,'yyyy-mm-dd hh24:mi:ss'),
                                            replace(REPLACE(parm_interval,chr(13),''),chr(34),'') ) ;
      MyJobID       := next_job_id;
      MyjobPosition := 'Step END';
      MyjobMessage  := SQLERRM;
      --pk_user_job_scheduler.ps_dbms_job_log( 999, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
      parm_return := next_job_id;


      /*insert into tb_sys_job_master jm (
         jm.job,
         jm.job_name,
         jm.what
      )
      values (
        next_job_id,
        substr(parm_what,  instr(parm_what,'\*') + 2,  instr(parm_what,'*\') - 3),
        replace(REPLACE(parm_what,chr(13),''),chr(34),'')
      )    ;*/

      COMMIT;
  EXCEPTION
     WHEN OTHERS THEN
        MyJobID        := next_job_id;
         MyjobPosition  := MyjobPosition||' Step Exceipton Others';
        MyjobStatus    := 'ERROR';
        MyjobMessage   := SQLERRM;
        parm_return    := SQLCODE;
       -- pk_user_job_scheduler.ps_dbms_job_log( 999, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
  END ps_dbms_job_submit;


  PROCEDURE ps_dbms_job_run ( parm_job_id IN NUMBER, parm_return OUT NUMBER ) IS
    /*============================================================================
      공통 Tracking 을 위한
    ============================================================================*/
    MyJobID               NUMBER        := parm_job_id ;            --Job ID User Define
    MyJobName             VARCHAR2(150) := 'F_DBMS_JOB_RUN' ; --Object Name
    MyjobParameters       VARCHAR2(256) :=   '1.job : '||TO_CHAR(parm_job_id) ;         --Prarameters
    MyjobMessage          VARCHAR2(1000);                  --Message
    MyjobStartDate        DATE          := SYSDATE   ;     --Job Start Time
    MyjobStatus           VARCHAR2(25)  := 'SUCCESS' ;     --Eror or Success Flag
    MyjobPosition         VARCHAR2(1000);                  --Error Tracking
    MyjobCursor           VARCHAR2(1000):= 'None'    ;     --Error Tracking
    /*============================================================================*/

  BEGIN
      dbms_job.run(parm_job_id) ;

      MyjobPosition := 'Step END';
      MyjobMessage  := SQLERRM;
      parm_return   := SQLCODE;
      --pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
  EXCEPTION
     WHEN OTHERS THEN
         MyjobPosition := MyjobPosition||' Step Exceipton Others';
        MyjobStatus   := 'ERROR';
        MyjobMessage  := SQLERRM;
        parm_return   := SQLCODE;
       -- pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
  END ps_dbms_job_run;

  PROCEDURE ps_dbms_job_remove ( parm_job_id IN NUMBER , parm_return OUT NUMBER  ) IS
    /*============================================================================
      공통 Tracking 을 위한
    ============================================================================*/
    MyJobID               NUMBER        := parm_job_id ;            --Job ID User Define
    MyJobName             VARCHAR2(150) := 'F_DBMS_JOB_REMOVE' ; --Object Name
    MyjobParameters       VARCHAR2(256) :=   '1.job : '||TO_CHAR(parm_job_id) ;         --Prarameters
    MyjobMessage          VARCHAR2(1000);                  --Message
    MyjobStartDate        DATE          := SYSDATE   ;     --Job Start Time
    MyjobStatus           VARCHAR2(25)  := 'SUCCESS' ;     --Eror or Success Flag
    MyjobPosition         VARCHAR2(1000);                  --Error Tracking
    MyjobCursor           VARCHAR2(1000):= 'None'    ;     --Error Tracking
    /*============================================================================*/
  BEGIN
      DBMS_JOB.remove(parm_job_id);
      MyjobPosition := 'Step END';
      MyjobMessage  := SQLERRM;
      parm_return   := SQLCODE ;
    --  pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
      COMMIT;
  EXCEPTION
     WHEN OTHERS THEN
         MyjobPosition := MyjobPosition||' Step Exceipton Others';
         MyjobStatus   := 'ERROR';
         MyjobMessage  := SQLERRM;
         parm_return   := SQLCODE;
      --   pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
  END ps_dbms_job_remove;


  PROCEDURE ps_dbms_job_broken ( parm_job_id IN NUMBER,
                                 parm_broken IN VARCHAR2 DEFAULT 'TRUE',
                                 parm_return OUT NUMBER ) IS
    /*============================================================================
      공통 Tracking 을 위한
    ============================================================================*/
    MyJobID               NUMBER        := parm_job_id ;            --Job ID User Define
    MyJobName             VARCHAR2(150) := 'F_DBMS_JOB_BROKEN' ; --Object Name
    MyjobParameters       VARCHAR2(256) := '1.parm_job_id : '||TO_CHAR(parm_job_id)||' 2.action :'||parm_broken ;         --Prarameters
    MyjobMessage          VARCHAR2(1000);                  --Message
    MyjobStartDate        DATE          := SYSDATE   ;     --Job Start Time
    MyjobStatus           VARCHAR2(25)  := 'SUCCESS' ;     --Eror or Success Flag
    MyjobPosition         VARCHAR2(1000);                  --Error Tracking
    MyjobCursor           VARCHAR2(1000):= 'None'    ;     --Error Tracking
    /*============================================================================*/

    lvb_broken BOOLEAN;

  BEGIN

      IF parm_broken = 'TRUE' THEN
         lvb_broken := TRUE ;
      ELSE
         lvb_broken := FALSE ;
      END IF ;

      dbms_job.broken(job => parm_job_id, broken => lvb_broken ) ;
      dbms_output.put_line('F_DBMS_JOB_BROKEN :: Broken Sucess :: '||to_char(parm_job_id)||' - '||parm_broken);
      MyjobPosition := 'Step END';
      MyjobMessage  := SQLERRM;
      parm_return   := SQLCODE ;
      --pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
      COMMIT;
  EXCEPTION
     WHEN OTHERS THEN
         MyjobPosition := MyjobPosition||' Step Exceipton Others';
         MyjobStatus   := 'ERROR';
         MyjobMessage  := SQLERRM;
         parm_return   := SQLCODE;
         dbms_output.put_line('F_DBMS_JOB_BROKEN :: Occur Errors :: '||SQLERRM||' '||to_char(parm_job_id)||' - '||parm_broken);
         --pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
  END ps_dbms_job_broken;

  PROCEDURE ps_dbms_job_change ( PARM_JOB_ID    IN NUMBER ,
                                 PARM_WHAT      IN VARCHAR2,
                                 PARM_NEXT_DATE IN varchar2,
                                 PARM_INTERVAL  IN VARCHAR2,
                                 parm_return    OUT NUMBER  ) IS
   /*============================================================================
      공통 Tracking 을 위한
    ============================================================================*/
    MyJobID               NUMBER        := PARM_JOB_ID ;            --Job ID User Define
    MyJobName             VARCHAR2(150) := 'F_DBMS_JOB_CHANGE' ; --Object Name
    MyjobParameters       VARCHAR2(4000) :=   ' 1.job : '      ||TO_CHAR(PARM_JOB_ID)
                                           ||' 2.what :'      ||PARM_WHAT
                                           ||' 3.next date : '||PARM_NEXT_DATE
                                           ||' 4.interval : ' ||PARM_INTERVAL ;         --Prarameters
    MyjobMessage          VARCHAR2(1000);                  --Message
    MyjobStartDate        DATE          := SYSDATE   ;     --Job Start Time
    MyjobStatus           VARCHAR2(25)  := 'SUCCESS' ;     --Eror or Success Flag
    MyjobPosition         VARCHAR2(1000);                  --Error Tracking
    MyjobCursor           VARCHAR2(1000):= 'None'    ;     --Error Tracking
    /*----------------------------------------------------------------------------*/
    MyJobWhat             varchar2(4000);
    MyJobInterval         VARCHAR2(4000);
    /*============================================================================*/

  BEGIN
      MyjobPosition := 'Change Start';

      MyJobWhat     :=  replace(REPLACE(parm_what,chr(13),''),chr(34),'') ;
      MyJobInterval := replace(replace(PARM_INTERVAL,chr(13),''),chr(34),'');

      DBMS_JOB.change(PARM_JOB_ID, MyJobWhat ,to_date(PARM_NEXT_DATE,'yyyy-mm-dd hh24:mi:ss'),MyJobInterval);
      MyjobPosition := 'Step End';
      MyjobMessage  := SQLERRM;
      parm_return   := SQLCODE;
      --pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
      COMMIT;
  EXCEPTION
     WHEN OTHERS THEN
         MyjobPosition := MyjobPosition||' Step Exceipton Others';
         MyjobStatus   := 'ERROR';
         MyjobMessage  := SQLERRM;
         parm_return   := SQLCODE;
         --pk_user_job_scheduler.ps_dbms_job_log( 0, MyJobID, MyJobName,MyjobParameters, MyjobMessage,MyjobStartDate,MyjobStatus,MyjobPosition, MyjobCursor);
  END ps_dbms_job_change;



-------------------------------------
-- OBJECT RECOMPILER
-------------------------------------
PROCEDURE ps_recompiler (
   o_owner    IN   VARCHAR2
 , o_name     IN   VARCHAR2
 , o_type     IN   VARCHAR2
 , o_status   IN   VARCHAR2
 , display    IN   BOOLEAN
)

IS
   -- Exceptions
   successwithcompilationerror EXCEPTION;
   PRAGMA EXCEPTION_INIT ( successwithcompilationerror, -24344 );
   -- Return Codes
   invalid_type CONSTANT INTEGER := 1;
   invalid_parent CONSTANT INTEGER := 2;
   compile_errors CONSTANT INTEGER := 4;
   cnt NUMBER;
   dyncur INTEGER;
   type_status INTEGER := 0;
   parent_status INTEGER := 0;
   recompile_status INTEGER := 0;
   object_status VARCHAR2 ( 30 );

   CURSOR invalid_parent_cursor (
      oowner    VARCHAR2
    , oname     VARCHAR2
    , otype     VARCHAR2
    , ostatus   VARCHAR2
    , OID       NUMBER
   )
   IS
      SELECT /*+ RULE */
             o.object_id
        FROM public_dependency d, all_objects o
       WHERE d.object_id = OID
         AND o.object_id = d.referenced_object_id
         AND o.status != 'VALID'
      MINUS
      SELECT /*+ RULE */
             object_id
        FROM all_objects
       WHERE owner LIKE UPPER ( oowner )
         AND object_name LIKE UPPER ( oname )
         AND object_type LIKE UPPER ( otype )
         AND status LIKE UPPER ( ostatus );

   CURSOR recompile_cursor ( OID NUMBER )
   IS
      SELECT /*+ RULE */
                'ALTER '
             || DECODE ( object_type
                       , 'PACKAGE BODY', 'PACKAGE'
                       , 'TYPE BODY', 'TYPE'
                       , object_type
                       )
             || ' '
             || owner
             || '.'
             || object_name
             || ' COMPILE '
             || DECODE ( object_type
                       , 'PACKAGE BODY', ' BODY'
                       , 'TYPE BODY', 'BODY'
                       , 'TYPE', 'SPECIFICATION'
                       , ''
                       )
             || ' REUSE SETTINGS' stmt
           , object_type, owner, object_name
        FROM all_objects
       WHERE object_id = OID;

   recompile_record recompile_cursor%ROWTYPE;

   CURSOR obj_cursor (
      oowner    VARCHAR2
    , oname     VARCHAR2
    , otype     VARCHAR2
    , ostatus   VARCHAR2
   )
   IS
      SELECT     /*+ RULE */
                 MAX ( LEVEL ) dlevel, object_id
            FROM SYS.public_dependency
      START WITH object_id IN (
                    SELECT object_id
                      FROM all_objects
                     WHERE owner LIKE UPPER ( oowner )
                       AND object_name LIKE UPPER ( oname )
                       AND object_type LIKE UPPER ( otype )
                       AND status LIKE UPPER ( ostatus ))
      CONNECT BY object_id = PRIOR referenced_object_id
        GROUP BY object_id
       HAVING MIN ( LEVEL ) = 1

      UNION ALL

      SELECT   1 dlevel, object_id
          FROM all_objects o
         WHERE owner LIKE UPPER ( oowner )
           AND object_name LIKE UPPER ( oname )
           AND object_type LIKE UPPER ( otype )
           AND status LIKE UPPER ( ostatus )
           AND NOT EXISTS ( SELECT 1
                             FROM SYS.public_dependency d
                            WHERE d.object_id = o.object_id )
      ORDER BY 1 DESC;

   TYPE integer_tt IS TABLE OF PLS_INTEGER
      INDEX BY BINARY_INTEGER;

   l_dlevel integer_tt;
   l_object_id integer_tt;

   CURSOR status_cursor ( OID NUMBER )
   IS
      SELECT /*+ RULE */
             status
        FROM all_objects
       WHERE object_id = OID;
BEGIN
   -- Recompile requested objects based on their dependency levels.
   IF display
   THEN
      DBMS_OUTPUT.put_line ( CHR ( 0 ));
      DBMS_OUTPUT.put_line
                          ( '                            RECOMPILING OBJECTS' );
      DBMS_OUTPUT.put_line ( CHR ( 0 ));
      DBMS_OUTPUT.put_line
                         (    '                            Object Owner is  '
                           || o_owner
                         );
      DBMS_OUTPUT.put_line
                          (    '                            Object Name is   '
                            || o_name
                          );
      DBMS_OUTPUT.put_line
                          (    '                            Object Type is   '
                            || o_type
                          );
      DBMS_OUTPUT.put_line
                          (    '                            Object Status is '
                            || o_status
                          );
      DBMS_OUTPUT.put_line ( CHR ( 0 ));
   END IF;

   dyncur := DBMS_SQL.open_cursor;

   OPEN obj_cursor ( o_owner, o_name, o_type, o_status );

   FETCH obj_cursor
   BULK COLLECT INTO l_dlevel, l_object_id;

   FOR indx IN 1 .. l_dlevel.COUNT
   LOOP
      OPEN recompile_cursor ( l_object_id ( indx ));

      FETCH recompile_cursor
       INTO recompile_record;

      CLOSE recompile_cursor;

      -- We can recompile only Functions, Packages, Package Bodies,
      -- Procedures, Triggers, Views, Types and Type Bodies.
      IF recompile_record.object_type IN
            ( 'FUNCTION'
            , 'PACKAGE'
            , 'PACKAGE BODY'
            , 'PROCEDURE'
            , 'TRIGGER'
            , 'VIEW'
            , 'TYPE'
            , 'TYPE BODY'
            )
      THEN
         -- There is no sense to recompile an object that depends on
         -- invalid objects outside of the current recompile request.
         OPEN invalid_parent_cursor ( o_owner
                                    , o_name
                                    , o_type
                                    , o_status
                                    , l_object_id ( indx )
                                    );

         FETCH invalid_parent_cursor
          INTO cnt;

         IF invalid_parent_cursor%NOTFOUND
         THEN
            -- Recompile object.
            BEGIN
               DBMS_SQL.parse ( dyncur
                              , recompile_record.stmt
                              , DBMS_SQL.native
                              );
            EXCEPTION
               WHEN successwithcompilationerror
               THEN
                  NULL;
            END;

            OPEN status_cursor ( l_object_id (indx));

            FETCH status_cursor
             INTO object_status;

            CLOSE status_cursor;

            IF display
            THEN
               DBMS_OUTPUT.put_line (    recompile_record.object_type
                                      || ' '
                                      || recompile_record.owner
                                      || '.'
                                      || recompile_record.object_name
                                      || ' is recompiled. Object status is '
                                      || object_status
                                      || '.'
                                    );
            END IF;

            IF object_status <> 'VALID'
            THEN
               recompile_status := compile_errors;
            END IF;
         ELSE
            IF display
            THEN
               DBMS_OUTPUT.put_line (    recompile_record.object_type
                                      || ' '
                                      || recompile_record.owner
                                      || '.'
                                      || recompile_record.object_name
                                      || ' references invalid object(s)'
                                      || ' outside of this request.'
                                    );
            END IF;

            parent_status := invalid_parent;
         END IF;

         CLOSE invalid_parent_cursor;
      ELSE
         IF display
         THEN
            DBMS_OUTPUT.put_line (    recompile_record.owner
                                   || '.'
                                   || recompile_record.object_name
                                   || ' is a '
                                   || recompile_record.object_type
                                   || ' and can not be recompiled.'
                                 );
         END IF;

         type_status := invalid_type;
      END IF;
   END LOOP;

   DBMS_SQL.close_cursor ( dyncur );
   --RETURN type_status + parent_status + recompile_status;
EXCEPTION
   WHEN OTHERS
   THEN
      IF obj_cursor%ISOPEN
      THEN
         CLOSE obj_cursor;
      END IF;

      IF recompile_cursor%ISOPEN
      THEN
         CLOSE recompile_cursor;
      END IF;

      IF invalid_parent_cursor%ISOPEN
      THEN
         CLOSE invalid_parent_cursor;
      END IF;

      IF status_cursor%ISOPEN
      THEN
         CLOSE status_cursor;
      END IF;

      IF DBMS_SQL.is_open ( dyncur )
      THEN
         DBMS_SQL.close_cursor ( dyncur );
      END IF;

      RAISE;
END;

FUNCTION F_GET_NEXTDATE
  ( PARM_JOBID    IN NUMBER,
    PARM_INTERVAL IN NUMBER )
  RETURN  DATE IS
  /*정시에 Interval을 가지고 실행되는 Job에 사용.*/
  /*Interval 보다 긴시간 작업이 실행될 경우는 interval * 2 가 Setting*/
  /*Job Scheduler에서 사용됩니다*/
  LD_NEXT    DATE            ;
BEGIN
   SELECT NEXT_DATE
     INTO LD_NEXT
     FROM USER_JOBS
    WHERE JOB=PARM_JOBID ;

<<MyLoop>>
    LD_NEXT := LD_NEXT + PARM_INTERVAL ;

    IF LD_NEXT <= SYSDATE THEN
       GOTO MyLoop ;
    END IF;

    RETURN LD_NEXT ;
EXCEPTION
   WHEN OTHERS THEN
    RETURN SYSDATE + parm_interval ;
END;

PROCEDURE PS_RELEASE_16_JOB IS
 CURSOR CJ16 IS
  SELECT JOB
     FROM user_jobs
   WHERE failures > 15
     AND broken = 'Y'  ;

 p_return NUMBER ;
 p_cnt    NUMBER := 0 ;
BEGIN
     FOR C16ROW IN CJ16 LOOP
          BEGIN
            pk_user_job_scheduler.ps_dbms_job_broken( parm_job_id    => C16ROW.JOB ,
                               parm_broken => 'FALSE',
                               parm_return => p_return );

           --pk_user_job_scheduler.ps_dbms_job_log( 0, 666, 'Releaser','None'||C16row.JOB, SQLERRM||SQLCODE,SYSDATE,p_return,'IN LOOP', 'C16ROW');
         EXCEPTION
           WHEN OTHERS THEN
           --pk_user_job_scheduler.ps_dbms_job_log( 0, 666, 'Releaser','None'||C16row.JOB, SQLERRM||SQLCODE,SYSDATE,p_return,'LOOP EXCEPTION', 'C16ROW');
           null;
         END ;
         p_cnt := nvl(p_cnt,0) + 1 ;
     END LOOP;
     --pk_user_job_scheduler.ps_dbms_job_log( 0, 666, 'Releaser','Process : '||p_cnt, SQLERRM||SQLCODE,SYSDATE,'TRUE','END JOB', 'C16ROW');
EXCEPTION
  WHEN OTHERS THEN
    null ;
     -- pk_user_job_scheduler.ps_dbms_job_log( 0, 666, 'Releaser','None', SQLERRM||SQLCODE,SYSDATE,'TRUE','EXCEPTION2', 'C16ROW');
END ;


FUNCTION F_JOB_SHCEDULER
  ( param_command   IN VARCHAR2 := 'RUN',
    param_job_id    IN NUMBER   := 0 ,
    param_what      IN VARCHAR2 := '',
    param_next_date IN date     := sysdate,
    param_interval  IN VARCHAR2 := 'SYSDATE + 1/24',
    param_broken    IN VARCHAR2 := 'TRUE'
  )
  RETURN  NUMBER IS

-- 임시
   parm_return   number ;
BEGIN
    CASE
      WHEN param_command = 'RUN'     THEN
           pk_user_job_scheduler.ps_dbms_job_run(param_job_id,parm_return);
      WHEN param_command = 'SUBMIT'  THEN
           pk_user_job_scheduler.ps_dbms_job_submit(param_what,param_next_date,param_interval,parm_return);
      WHEN param_command = 'REMOVE'  THEN
           pk_user_job_scheduler.ps_dbms_job_remove(param_job_id ,parm_return);
      WHEN param_command = 'CHANGE'  THEN
           pk_user_job_scheduler.ps_dbms_job_change(param_job_id,param_what,param_next_date,param_interval,parm_return);
      WHEN param_command = 'BREAK'   THEN
           pk_user_job_scheduler.ps_dbms_job_broken(param_job_id,param_broken,parm_return);
      WHEN param_command = 'RESTART' THEN
           pk_user_job_scheduler.ps_dbms_job_broken(param_job_id,param_broken,parm_return);

    END CASE ;

    RETURN parm_return ;
EXCEPTION
   WHEN OTHERS THEN
       RETURN SQLCODE ;
END;

 /***************************************************************
  *  웹에서 지원안되는 문자 대체하기.                            *
  ***************************************************************/
  function fn_get_replace ( p_str           in   VARCHAR2 )   return varchar2 is

      v_return_value    Varchar2(4000)   :=  null;      -- Return Value
   begin
      begin
          SELECT
               REPLACE(
                  replace(
                    replace(
                      replace(
                          replace(
                              replace(
                                replace(
                                  replace(nvl(p_str,''),chr(39),'\'||chr(39))
                                ,chr(34),'\'||chr(34))
                              ,chr(10),'\n')
                            ,chr(13),'\r\n')
                        ,chr(35),'\'||chr(35))
                    ,chr(59),'\'||chr(59))
                  ,chr(58),'\'||chr(58))
                ,chr(47),'\'||chr(47))
          into    v_return_value
          From    dual
          ;
      exception
          when others then
              v_return_value   :=   p_str;
      end;

      return  v_return_value ;

  end;


END;