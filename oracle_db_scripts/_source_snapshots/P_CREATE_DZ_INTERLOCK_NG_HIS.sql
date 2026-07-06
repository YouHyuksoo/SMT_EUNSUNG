PROCEDURE "P_CREATE_DZ_INTERLOCK_NG_HIS" 
(
    P_TYPE IN VARCHAR2
)
IS

    LVS_SYSDATE       DATE;
    LVS_ERRORMSG      VARCHAR2(500);  
   
BEGIN
  
    LVS_SYSDATE := SYSDATE;
    
    IF P_TYPE = 'Y' THEN  -- YESTERDAY
      
       --------------------------------------------
       -- 공정통과 일자별(3일)
       --------------------------------------------
           
       delete from idz_interlock_ng_his_day
       where receipt_date >= trunc(LVS_SYSDATE -1)
         and receipt_date <  trunc(LVS_SYSDATE);
       
       insert into idz_interlock_ng_his_day
       select receipt_date , 
              total_qty , 
              ng_qty , 
              ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
         from (
                select trunc(receipt_date ) as receipt_date ,
                       count(*) total_qty ,
                       sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                  from iq_interlock_check_result 
                 where receipt_date >= trunc(LVS_SYSDATE -1)
                   and receipt_date <  trunc(LVS_SYSDATE)
                 group by trunc(receipt_date )
              );
              
    ELSE                  -- TODAY
 
       delete from idz_interlock_ng_his_day
       where receipt_date >= TRUNC(LVS_SYSDATE);
       
       insert into idz_interlock_ng_his_day
       select receipt_date , 
              total_qty , 
              ng_qty , 
              ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
         from (
                select trunc(receipt_date ) as receipt_date ,
                       count(*) total_qty ,
                       sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                  from iq_interlock_check_result 
                 where receipt_date >= TRUNC(LVS_SYSDATE)
                 group by trunc(receipt_date )
              );
                   
        
       --------------------------------------------
       -- 공정통과 라인별(3일)
       --------------------------------------------
       
       delete from idz_interlock_ng_his_line;
       
       insert into idz_interlock_ng_his_line
       select line_name , 
              total_qty , 
              ng_qty , 
              ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
        from ( 
               select f_get_line_name( line_code, 1 ) as line_name ,
                      count(*) total_qty ,
                      sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                 from iq_interlock_check_result 
                where receipt_date >= (LVS_SYSDATE - 3)
                group by  line_code
             );

       COMMIT;
          
       --------------------------------------------
       -- 공정통과 일자별(3일)
       --------------------------------------------                    
       
       delete from idz_interlock_ng_his_top10;
       
       insert into idz_interlock_ng_his_top10 
       SELECT model_name, 
              ng_qty,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
         FROM ( 
                select model_name, ng_qty
                  from ( 
                         select model_name , sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty 
                           from iq_interlock_check_result 
                          where receipt_date >= (LVS_SYSDATE - 3)
                          group by model_name 
                       )
                 ORDER BY NG_QTY  DESC 
               ) 
        WHERE ROWNUM < 11;
        
        COMMIT;        
        
       --------------------------------------------
       -- 공정통과 공정별(3일)
       --------------------------------------------        
        delete from IDZ_INTERLOCK_NG_HIS_WORKSTAGE;
        
        insert into idz_interlock_ng_his_WORKSTAGE
        select workstage_name, 
               total_qty , 
               ng_qty , 
               ( ng_qty / total_qty * 1000000 )  as ppm,
              1,
              sysdate,
              'BATCH',
              sysdate,
              'BATCH'
          from ( 
                 select f_get_workstage_name( workstage_code) as workstage_name,
                        count(*) total_qty ,
                        sum( decode ( check_result , 'NG' ,1 ,0 )) as ng_qty
                   from iq_interlock_check_result 
                  where receipt_date >= (LVS_SYSDATE - 3)
                  group by  workstage_code
               );
        
                 
    END IF;
  
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
                   'DATAZEN',
                   'P_CREATE_DZ_INTERLOCK_NG_HIS',
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