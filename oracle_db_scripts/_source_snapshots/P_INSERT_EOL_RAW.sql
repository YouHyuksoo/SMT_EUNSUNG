PROCEDURE "P_INSERT_EOL_RAW" (
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
   
 
        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_EOL (      
                                                      
                                                 inspect_start_date, 
                                                 inspect_end_date, 
                                                 test_channel, 
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
                                                 
                                                 current_test_data1, 
                                                 current_test_result1, 
                                                 current_test_data2, 
                                                 current_test_result2, 
                                                 current_test_data3, 
                                                 current_test_result3, 
                                                 current_test_data4, 
                                                 current_test_result4, 
                                                 connectivity_test_data1, 
                                                 connectivity_test_result1, 
                                                 connectivity_test_data2, 
                                                 connectivity_test_result2, 
                                                 connectivity_test_data3, 
                                                 connectivity_test_result3, 
                                                 connectivity_test_data4, 
                                                 connectivity_test_result4
                                                 
                                             )
                                     VALUES (
                                     
                                             REPLACE (TRIM (p_data(1)), '"'),
                                             REPLACE (TRIM (p_data(2)), '"'),
                                             REPLACE (TRIM (p_data(3)), '"'),
                                             REPLACE (TRIM (p_data(4)), '"'),
                                             REPLACE (TRIM (p_data(5)), '"'),
                                             
                                             sysdate,
                                             lvs_column_count, --'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             
                                             '*',
                                             lvs_line_code,
                                             lvs_machine_code,
                                             lvs_file_name,
                                             
                                             REPLACE (TRIM (p_data(6)), '"'),
                                             REPLACE (TRIM (p_data(7)), '"'),
                                             REPLACE (TRIM (p_data(8)), '"'),
                                             REPLACE (TRIM (p_data(9)), '"'),
                                             REPLACE (TRIM (p_data(10)), '"'),
                                             REPLACE (TRIM (p_data(11)), '"'),
                                             REPLACE (TRIM (p_data(12)), '"'),
                                             REPLACE (TRIM (p_data(13)), '"'),
                                             REPLACE (TRIM (p_data(14)), '"'),
                                             
                                             REPLACE (TRIM (p_data(15)), '"'),
                                             REPLACE (TRIM (p_data(16)), '"'),
                                             REPLACE (TRIM (p_data(17)), '"'),
                                             REPLACE (TRIM (p_data(18)), '"'),
                                             REPLACE (TRIM (p_data(19)), '"'),
                                             REPLACE (TRIM (p_data(20)), '"'),
                                             REPLACE (TRIM (p_data(21)), '"')              
            
                                           );
                                           
   
   
   
   COMMIT;
   
EXCEPTION
   WHEN OTHERS
   THEN

      LVS_ERRORMSG :=
         '[P_INSERT_EOL_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
   ROLLBACK ;
         INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
       VALUES ( SYSDATE  , LVS_ERRORMSG  , 'FILE = '||lvs_file_name||', LINE = '||lvs_line_code || ', COLUMN COUNT = ' || lvs_column_count ) ;

      COMMIT;
      
      
END P_INSERT_EOL_RAW;
