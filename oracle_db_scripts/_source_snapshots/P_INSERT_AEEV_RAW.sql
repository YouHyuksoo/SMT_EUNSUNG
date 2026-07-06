PROCEDURE "P_INSERT_AEEV_RAW" (
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (200) := '';
   lvs_line_code      VARCHAR2 (20) := '';
   lvs_machine_code   VARCHAR2 (20) := '';
   lvs_mode           VARCHAR2 (20) := '';
   lvs_result         VARCHAR2 (20) := '';
   lvs_column_count   VARCHAR2 (20) := '';
   
   lvs_sql            VARCHAR2 (30000);
   LVS_ERRORMSG       VARCHAR2 (32000);
   
BEGIN
  
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
   
   
 --  if ( p_data.LAST < 15 ) then  -- file watcher 에서 file name filter를 못하여 임시적용
 --       return;
 --  end if;
 
        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_AEEV (      
                                                      
                                                 inspect_date, 
                                                 pid, 
                                                 result, 
                                                 
                                                 enter_date, 
                                                 enter_by, 
                                                 last_modify_date, 
                                                 last_modify_by, 
                                                 organization_id, 
                                                 
                                                 run_no, 
                                                 line_code, 
                                                 machine_code, 
                                                 file_name, 
                                                 
                                                 current_check1, 
                                                 current_check2, 
                                                 current_check3, 
                                                 current_check4, 
                                                 current_check5, 
                                                 current_check6, 
                                                 
                                                 connectivity_check1, 
                                                 connectivity_check2, 
                                                 connectivity_check3, 
                                                 connectivity_check4, 
                                                 connectivity_check5, 
                                                 connectivity_check6
                                                 
                                             )
                                     VALUES (
                                     
                                             TO_CHAR( TO_DATE( REPLACE (TRIM (p_data(1)), '"'), 'YYYY-MM-DD HH24:MI:SS'), 'YYYY/MM/DD HH24:MI:SS'),    -- 2021-02-17 08:59:55
                                             NVL(REPLACE (TRIM (p_data(2)), '"'),'*'),
                                             REPLACE (TRIM (p_data(3)), '"'),
                                             
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             
                                             F_GET_RUN_NO_BY_PID( REPLACE (TRIM (p_data(2)), '"') ),
                                             lvs_line_code,
                                             lvs_machine_code,
                                             lvs_file_name,
                                             
                                             REPLACE (TRIM (p_data(4)), '"'),
                                             REPLACE (TRIM (p_data(5)), '"'),
                                             REPLACE (TRIM (p_data(6)), '"'),
                                             REPLACE (TRIM (p_data(7)), '"'),
                                             REPLACE (TRIM (p_data(8)), '"'),
                                             REPLACE (TRIM (p_data(9)), '"'),
                                             
                                             REPLACE (TRIM (p_data(10)), '"'),
                                             REPLACE (TRIM (p_data(11)), '"'),
                                             REPLACE (TRIM (p_data(12)), '"'),
                                             REPLACE (TRIM (p_data(13)), '"'),
                                             REPLACE (TRIM (p_data(14)), '"'),
                                             REPLACE (TRIM (p_data(15)), '"')            
            
                                           );
                                           
   
   COMMIT;
   
EXCEPTION
  
   WHEN OTHERS THEN

      LVS_ERRORMSG := '[P_INSERT_AEEV_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
      
     ROLLBACK ;
     
     INSERT INTO ICOM_MACHINE_INSERT_LOG( 
                                          LOG_DATE , 
                                          ERROR_MESSAGE , 
                                          ERROR_DESC,
                                          
                                          TEMP1, 
                                          TEMP2,
                                          TEMP3,
                                          TEMP4,
                                          TEMP5
                                        )
                                 VALUES ( 
                                          SYSDATE  , 
                                          LVS_ERRORMSG  , 
                                          'FILE = '||lvs_file_name,
                                          
                                          'LINE = '||lvs_line_code,
                                          NULL,
                                          'C15',
                                          lvs_column_count ,
                                          p_data(1)
                                        ) ;

      COMMIT;
      
      
END P_INSERT_AEEV_RAW;
