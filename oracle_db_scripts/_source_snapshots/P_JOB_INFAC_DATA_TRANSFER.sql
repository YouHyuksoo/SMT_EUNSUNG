PROCEDURE P_JOB_INFAC_DATA_TRANSFER
IS

   lvl_count1     number default 0 ;
   lvl_count2     number default 0 ;
   lvs_message    varchar2(200);
   
BEGIN
  
      -------------------------------------------------------------------
      -- DATA 생성
      -------------------------------------------------------------------

      P_JOB_INFAC_DATA_CREATE;

      -------------------------------------------------------------------
      -- INFAC DATA 전송
      -------------------------------------------------------------------
      
      INSERT INTO ESEAI_M107 ( 
                               DT_IF, 
                               CD_SL, 
                               CD_ITEM, 
                               YN_PROCESS, 
                               DC_ERRORMSG, 
                               QT_IM, 
                               DTS_CREATE
                            )
      SELECT DT_IF, 
             CD_SL, 
             CD_ITEM, 
             YN_PROCESS, 
             DC_ERRORMSG, 
             CASE WHEN QT_IM < 0 THEN 0 ELSE QT_IM END AS QT_IM , 
             DTS_CREATE
        FROM ESEAI_M107_TEMP
       WHERE TRANSFER_YN = 'N'
         AND DT_IF       =  to_char(sysdate, 'YYYYMMDD')
         AND DTS_CREATE  >= to_char(sysdate - (5/(24*60)), 'HH24:MI:SS')
         AND DTS_CREATE  <= to_char(sysdate + (5/(24*60)), 'HH24:MI:SS');
       
       lvl_count1 := SQL%ROWCOUNT;
       
       ------------------------------------------------------------------- 
       -- 전송후 처리완료 flag setting
       -------------------------------------------------------------------
       
       UPDATE ESEAI_M107_TEMP
          SET TRANSFER_DATE = sysdate,
              TRANSFER_YN   = 'Y'
        WHERE TRANSFER_YN   = 'N'
          AND DT_IF       =  to_char(sysdate, 'YYYYMMDD')
          AND DTS_CREATE  >= to_char(sysdate - (5/(24*60)), 'HH24:MI:SS')
          AND DTS_CREATE  <= to_char(sysdate + (5/(24*60)), 'HH24:MI:SS');
        
       lvl_count2 := SQL%ROWCOUNT;
        
       -------------------------------------------------------------------
       -- insert log 생성
       -------------------------------------------------------------------
      
      lvs_message := 'INSERT => '||to_char(lvl_count1)||', UPDATE => '||to_char(lvl_count2);
       
      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_TRANSFER',
                                        'P_JOB_INFAC_DATA_TRANSFER',
                                        'SEND OK',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );
                 
      COMMIT;
 

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION
       
 WHEN OTHERS THEN
      
      lvs_message := substr(SQLERRM, 1, 200);
      
      insert into isys_batchjoberrlog ( 
                                        batch_job_seq ,
                                        organization_id,
                                        batch_job_process_name,
                                        batch_job_object_name,
                                        batch_job_status_code,
                                        batch_job_remark,
                                        enter_by,
                                        log_date  
                                      )
                               values (
                                        null,
                                        1,
                                        'INFAC_DATA_TRANSFER',
                                        'P_JOB_INFAC_DATA_TRANSFER',
                                        'SEND NG',
                                        lvs_message,
                                        'JOB',
                                        sysdate
                                      );
                 
      commit;
      
END;