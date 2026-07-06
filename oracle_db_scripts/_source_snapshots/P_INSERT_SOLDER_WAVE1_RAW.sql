PROCEDURE P_INSERT_SOLDER_WAVE1_RAW (
                                                       p_data   IN ARRAY5_PARAMS_T,
                                                       p_info   IN ARRAY5_PARAMS_T
                                                     )
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
  
   IF p_info.LAST >= 1 THEN
      lvs_file_name := REPLACE (TRIM (p_info (1)), '"');
   END IF;

   IF p_info.LAST >= 2 THEN
      lvs_line_code := REPLACE (TRIM (p_info (2)), '"');
   END IF;

   IF p_info.LAST >= 3 THEN
      lvs_machine_code := REPLACE (TRIM (p_info (3)), '"');
   END IF;
   
   lvs_column_count :=  to_char( p_data.LAST ); 
   
 
        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_WAVE1 (      
                                                      
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
                                                 
                                                 C1,
                                                 C2,
                                                 C3,
                                                 C4,
                                                 C5,
                                                 C6,
                                                 C7,
                                                 C8,
                                                 C9,
                                                 C10,
                                                 C11,
                                                 C12,
                                                 C13,
                                                 C14,
                                                 C15,
                                                 C16,
                                                 C17,
                                                 C18,
                                                 C19
                                             )
                                     VALUES (
                                     
                                             TO_CHAR(sysdate, 'YYYY/MM/DD HH24:MI:SS'),     -- TO_CHAR( TO_DATE( REPLACE (TRIM (p_data(1)), '"'), 'YYYY-MM-DD HH24:MI:SS'), 'YYYY/MM/DD HH24:MI:SS'),    -- 2021-02-17 08:59:55
                                             '*', --REPLACE (TRIM (p_data(2)), '"'),
                                             '',  --REPLACE (TRIM (p_data(3)), '"'),
                                             
                                             sysdate,
                                             'FILE WATCHER',
                                             sysdate,
                                             'FILE WATCHER',
                                             1,
                                             
                                             '*', --F_GET_RUN_NO_BY_PID( REPLACE (TRIM (p_data(2)), '"') ),
                                             lvs_line_code,
                                             lvs_machine_code,
                                             lvs_file_name,
                                             
                                             REPLACE (TRIM (p_data(1)), '"'),
                                             REPLACE (TRIM (p_data(2)), '"'),
                                             REPLACE (TRIM (p_data(3)), '"'),
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
                                             REPLACE (TRIM (p_data(15)), '"'),
                                             REPLACE (TRIM (p_data(16)), '"'),
                                             REPLACE (TRIM (p_data(17)), '"'),
                                             REPLACE (TRIM (p_data(18)), '"'),
                                             REPLACE (TRIM (p_data(19)), '"')
                                           );
                                           
   
   COMMIT;
   
EXCEPTION
  
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_SOLDER_WAVE1_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
  
        ROLLBACK ;
       
       INSERT INTO ICOM_MACHINE_INSERT_LOG( 
                                            LOG_DATE , 
                                            ERROR_MESSAGE , 
                                            ERROR_DESC 
                                          )
                                   VALUES ( 
                                            SYSDATE  , 
                                            LVS_ERRORMSG  ,
                                            'FILE = '||lvs_file_name||', LINE = '||lvs_line_code || ', COLUMN COUNT = ' || lvs_column_count 
                                          ) ;

      COMMIT;
      
      
END;
