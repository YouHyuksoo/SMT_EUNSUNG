PROCEDURE "P_CREATE_LINE_TARGET_INS" 
(
   P_ORGANIZATION_ID IN NUMBER,
   P_WORK_DATE       IN DATE
)
IS

   LVS_ERRORMSG      VARCHAR2(500);

BEGIN

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

           WHEN OTHERS THEN
                NULL;

        END;

END;