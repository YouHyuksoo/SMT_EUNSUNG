PACKAGE BODY "PKG_SUMMARY_JOBS" is

  PROCEDURE PS_PICKUP_RATE_SUMMARY_BY_DAY ( P_DATE IN DATE ) IS
    /*매일 오전 7시30분에 전날 픽업 실적 집계 함  P_DATE SMS TRUNC(SYSDATE - 1) 로 넘김 */

    LVS_ERRORMSG VARCHAR2(500);

  BEGIN

    DELETE FROM IQ_MACHINE_INSPECT_PICKUP_QRY
     WHERE ACTUAL_DATE = P_DATE ;


    INSERT INTO IQ_MACHINE_INSPECT_PICKUP_QRY (
        line_code,
        machine_code,
        program_name,
        address,
        sub_address,
        item_code,
        abc_grade,
        item_name,
        pur_unit_price,
        actual_date,
        table_no,
        feeder_zaxis,
        feeder_lraxis,
        takeup_qty,
        miss_qty,
        recog_qty,
        created_date,
        create_by
    )

    SELECT X.LINE_CODE,
           MACHINE_CODE,
           PROGRAM_NAME,
           ADDRESS,
           SUB_ADDRESS,
           X.ITEM_CODE,
           Y.ABC_GRADE,
           Y.ITEM_NAME,

           --NVL(f_get_mat_max_unit_price_cfm(substr(x.item_code, 1, decode(instr(x.item_code,'-'),0,length(x.item_code), instr(x.item_code,'-') - 1 )),'F',sysdate,1),0) AS PUR_UNIT_PRICE,
           NVL(f_get_mat_max_unit_price_cfm(x.item_code,'G',sysdate,1),0) AS PUR_UNIT_PRICE,
           ACTUAL_DATE,
           TABLE_NO,
           FEEDER_ZAXIS,
           FEEDER_LRAXIS,
           TAKEUP_QTY,
           MISS_QTY,
           RECOG_QTY,
           SYSDATE,
           'BATCH'
      FROM (
              SELECT X.LINE_CODE,
                     MACHINE_CODE,
                     PROGRAM_NAME,
                     ADDRESS,
                     SUB_ADDRESS,
                     X.ITEM_CODE,
                     ACTUAL_DATE,
                     --ACTUAL_TIME,
                     --DATA_TYPE,
                     MAX(TABLE_NO)      TABLE_NO,
                     MAX(FEEDER_ZAXIS)  FEEDER_ZAXIS,
                     MAX(FEEDER_LRAXIS) FEEDER_LRAXIS,

                     SUM(DECODE( DATA_TYPE, 'T', DECODE( SIGN(SIM_COUNT), -1,  NVL(HEAD_SUM,0), NVL(SIM_COUNT,0) ) , 0 )) AS TAKEUP_QTY,
                     SUM(DECODE( DATA_TYPE, 'M', DECODE( SIGN(SIM_COUNT), -1,  NVL(HEAD_SUM,0), NVL(SIM_COUNT,0) ) , 0 )) AS MISS_QTY  ,
                     SUM(DECODE( DATA_TYPE, 'R', DECODE( SIGN(SIM_COUNT), -1,  NVL(HEAD_SUM,0), NVL(SIM_COUNT,0) ) , 0 )) AS RECOG_QTY

                FROM (

                       SELECT T.LINE_CODE  ,
                              T.MACHINE_CODE,
                              T.PROGRAM_NAME,
                              T.ADDRESS    ,
                              T.SUB_ADDRESS,
                              T.ITEM_CODE  ,
                              T.DATA_TYPE  ,
                              T.ACTUAL_DATE,
                              T.ACTUAL_TIME,
                              --ID_ITEM.ABC_GRADE  AS ABC_GRADE ,
                              T.TABLE_NO,
                              T.FEEDER_ZAXIS,
                              T.FEEDER_LRAXIS,
                              T.MODEL_NAME,
                              T.MODEL_SUFFIX,
                              T.PARENT_ITEM_CODE,
                              T.PCB_ITEM,

                              --NVL(f_get_mat_max_unit_price_cfm(T.ITEM_CODE,'F',sysdate,1),0)  INVENTORY_PRICE,


                              T.HEAD_SUM   ,
                              DECODE(NVL(T.MACHINE_TYPE,'CM'), 'NPM' , T.HEAD_SUM,
                              T.HEAD_SUM -
                              LAG( T.HEAD_SUM) OVER ( PARTITION BY T.LINE_CODE  ,
                                                     T.MACHINE_CODE,
                                                     T.PROGRAM_NAME,
                                                     T.ADDRESS    ,
                                                     T.SUB_ADDRESS,
                                                     T.ITEM_CODE  ,
                                                     T.DATA_TYPE
                                             ORDER BY T.LINE_CODE  ,
                                                       T.MACHINE_CODE,
                                                       T.PROGRAM_NAME,
                                                       T.ADDRESS    ,
                                                       T.SUB_ADDRESS,
                                                       T.ITEM_CODE  ,
                                                       T.DATA_TYPE  ,
                                                       T.ACTUAL_DATE,
                                                       T.ACTUAL_TIME
                                            )
                              ) SIM_COUNT




                          FROM IQ_MACHINE_INSPECT_PICKUP_RATE t
                         WHERE  ( T.ACTUAL_DATE = TRUNC(P_DATE) OR ( T.ACTUAL_DATE = TRUNC(P_DATE-1) and T.ACTUAL_TIME = 'J' ) )

                      ) x

                  WHERE ACTUAL_DATE = TRUNC(P_DATE)

                  GROUP BY X.LINE_CODE,
                           MACHINE_CODE,
                           PROGRAM_NAME,
                           ADDRESS,
                           SUB_ADDRESS,
                           X.ITEM_CODE,
                           ACTUAL_DATE
        ) X, ID_ITEM Y
       WHERE X.ITEM_CODE = Y.ITEM_CODE (+) ;

       COMMIT ;

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
                   'PKG_SUMMARY_JOBS',
                   'PS_PICKUP_RATE_SUMMARY_BY_DAY',
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
end PKG_SUMMARY_JOBS;