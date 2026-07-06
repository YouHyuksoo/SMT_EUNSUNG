PROCEDURE "P_SOUND_MENT" 
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

     LVS_SOUND_IP   VARCHAR2(20);
     LVS_ERRORMSG   VARCHAR2(3000);  -- buffwe size ？？？？ 500 > 3000
     LVS_SOUNDMSG   VARCHAR2(3000);  -- buffwe size ？？？？ 500 > 3000

BEGIN

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

           WHEN OTHERS THEN
                NULL;

        END;

END;