PROCEDURE P_INSERT_SP_RAW3 (
   p_data   IN ARRAY5_PARAMS_T,
   p_info   IN ARRAY5_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (100) := '';
   lvs_line_code      VARCHAR2 (20)  := '';
   lvs_machine_code   VARCHAR2 (20)  := '';

   LVS_ERRORMSG       VARCHAR2 (300);
   
   lvs_column_count   VARCHAR2 (20)  := '';
   
BEGIN

   ----------------------------------------------------------------------------
   -- 호출 watcher 정보
   ----------------------------------------------------------------------------

   IF p_info.LAST >= 1
   THEN
      lvs_file_name := REPLACE (TRIM (p_info (1)), '"');
   END IF;

   IF p_info.LAST >= 2
   THEN
      lvs_line_code := REPLACE (TRIM (p_info (2)), '"');
   END IF;

   IF p_info.LAST >= 3
   THEN
      lvs_machine_code := REPLACE (TRIM (p_info (3)), '"');
   END IF;    
   
   lvs_column_count :=  to_char( p_data.LAST ); 
   
   ----------------------------------------------------------------------------
   -- 데이타 처리 SKIP
   ----------------------------------------------------------------------------
       
 

   IF ( (REPLACE (TRIM (p_data(1)), '"') = '') or ( REPLACE (TRIM (p_data(3)), '"') = '') or  (REPLACE (TRIM (p_data(1)), '"') is null) or ( REPLACE (TRIM (p_data(3)), '"') is null) )  THEN
          
        return;           -- job_file : c:\printer\data\NE EV_PILOT_SNSG BOX.pcb -- 1508/3000 : 생산수량 
        
   END IF;
   

   
   ----------------------------------------------------------------------------
   -- 데이타 처리 : HIT
   ----------------------------------------------------------------------------
       
                   
       INSERT INTO IQ_MACHINE_INSPECT_DATA_SP ( 
                                                PID,
                                                INSPECT_DATE,
                                                RESULT,
                                                
                                                ENTER_DATE       ,
                                                ENTER_BY         ,
                                                LAST_MODIFY_DATE ,
                                                LAST_MODIFY_BY   ,
                                                ORGANIZATION_ID  ,
                                                
                                                FILE_NAME        ,
                                                LINE_CODE        ,
                                                MACHINE_CODE     ,
                                                RUN_NO           ,
                                                
                                                sso_dist_table   ,
                                                sso_table_speed  ,
                                                
                                                pressure1        ,
                                                speed1           ,
                                                pressure2        ,
                                                speed2           ,
                                                
                                                frequency        ,
                                                temprature       ,
                                                front_sqg        ,
                                                rear_sqg         ,
                                                matal_mask       ,
                                                
                                                paste_id         ,
                                                Stencil_Id       ,
                                                Squeegee_Id      ,
                                                Product_Count    ,
                                                squeegee_count   ,
                                                Mask_Count       ,
                                                paste_count      ,
                                                WORK_SEPARATION_SPEED,
                                                WORK_SEPARATION_DISTANCE,
                                                
                                                JOB_FILE,
                                                POSITION
                                               )
                               VALUES (
                                       'NULL', 
                                       to_char( to_date( TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(2)), '"'), '[^;]+', 1, 1 )), 'YYYY-MM-DD HH24:MI:SS' ), 'YYYY/MM/DD HH24:MI:SS'), -- 일자
                                       NULL,
                                       
                                       sysdate,
                                       'SP3',
                                       sysdate,
                                       'FILE WACHTOR',
                                       1,
                                       
                                       lvs_file_name,
                                       lvs_line_code,
                                       lvs_machine_code,
                                       '*',
                                                                                                                   
                                       NULL, --REPLACE (TRIM (p_data(30)), '"'),
                                       NULL, --REPLACE (TRIM (p_data(29)), '"'),
                                       
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(10)), '"'), '[^;]+', 1, 1 )),                                         -- Pressure1
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(11)), '"'), '[^;]+', 1, 1 )),                                        -- speed1
                                       NULL,
                                       NULL,
                                       
                                       NULL, --REPLACE (TRIM (p_data(40)), '"'),
                                       NULL,
                                       NULL, --REPLACE (TRIM (p_data(9)), '"'),
                                       NULL,
                                       NULL, --REPLACE (TRIM (p_data(10)), '"'),
                                       
                                       NULL,
                                       NULL,
                                       NULL,
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(4)), '"'), '[^;]+', 1, 1 )),    -- product count
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(24)), '"'), '[^;]+', 1, 1 )),   -- 마스크 사용횟수
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(25)), '"'), '[^;]+', 1, 1 )),   -- 스퀴즈 사용횟수
                                       NULL,
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(16)), '"'), '[^;]+', 1, 1 )),   -- WORK SEPARATION SPEEDE
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(17)), '"'), '[^;]+', 1, 1 )),   -- WORK SEPARATION DISTANCE
                                       
                                       TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(3)), '"'), '[^;]+', 1, 1 )),    -- job file
                                       DECODE(TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(9)), '"'), '[^;]+', 1, 1 )) , '1', 'FRONT SQUEEGEE', '2', 'REAR SQUEEGEE', '3', 'DOUBLE PRINTING',  TRIM(REGEXP_SUBSTR( REPLACE (TRIM (p_data(9)), '"'), '[^;]+', 1, 1 )) )  
                                      );
                                      
 
                                              
 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_SP_RAW3]' || ' ' || SUBSTR (SQLERRM, 1, 300);

        ROLLBACK ;
        INSERT INTO ICOM_MACHINE_INSERT_LOG(
                                             LOG_DATE ,
                                             ERROR_MESSAGE ,
                                             ERROR_DESC,
                                             
                                             TEMP1,
                                             TEMP2,
                                             TEMP3
                                           )
                                    VALUES (
                                             SYSDATE,
                                             LVS_ERRORMSG  ,
                                             'FILE = ' || lvs_file_name,
                                             
                                             lvs_line_code,
                                             lvs_machine_code,
                                             lvs_column_count
                                             
                                           ) ;

      COMMIT;
      
END;
