PROCEDURE P_INSERT_PERFORM_O1XX_RAW (
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
   
   lvs_inspect_date   VARCHAR2 (50) := '';
   
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
        -- 데이타가공
        --------------------------------------------------------------   
        
    --   lvs_inspect_date := replace(replace(replace(REPLACE (TRIM (p_data(1)), '"'), '년', '/'), '월', '/'), '일', '')||' '||replace(replace(replace(REPLACE (TRIM (p_data(2)), '"'), '시', ':'), '분', ':'), '초', '');
    --   lvs_result       := decode(REPLACE (TRIM (p_data(4)), '"'), '불량', 'NG', '양품', 'OK', TRIM (p_data(4)));
    
      select replace(replace(replace(REPLACE (TRIM (p_data(1)), '"'), '년', '/'), '월', '/'), '일', '')||' '||replace(replace(replace(REPLACE (TRIM (p_data(2)), '"'), '시', ':'), '분', ':'), '초', ''),
             decode(REPLACE (TRIM (p_data(4)), '"'), '불량', 'NG', '양품', 'OK', TRIM (p_data(4)))
        into lvs_inspect_date, lvs_result
        from dual;
    
        --------------------------------------------------------------
        -- 이력저장
        --------------------------------------------------------------
        
       INSERT INTO IQ_MACHINE_INSPECT_DATA_O1XX (      
                                                      
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
                                                 C19,
                                                 C20,
                                                 C21,
                                                 C22,
                                                 C23,
                                                 C24,
                                                 C25,
                                                 C26,
                                                 C27,
                                                 C28,
                                                 C29,
                                                 C30,
                                                 C31,
                                                 C32,
                                                 C33,
                                                 C34,
                                                 C35,
                                                 C36,
                                                 C37
                                             )
                                     VALUES (
                                     
                                             lvs_inspect_date,           
                                             REPLACE (TRIM (p_data(3)), '"'),
                                             lvs_result,
                                             
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
                                             REPLACE (TRIM (p_data(19)), '"'),
                                             REPLACE (TRIM (p_data(20)), '"'),
                                             REPLACE (TRIM (p_data(21)), '"'),
                                             REPLACE (TRIM (p_data(22)), '"'),
                                             REPLACE (TRIM (p_data(23)), '"'),
                                             REPLACE (TRIM (p_data(24)), '"'),
                                             REPLACE (TRIM (p_data(25)), '"'),
                                             REPLACE (TRIM (p_data(26)), '"'),
                                             REPLACE (TRIM (p_data(27)), '"'),
                                             REPLACE (TRIM (p_data(28)), '"'),
                                             REPLACE (TRIM (p_data(29)), '"'),
                                             REPLACE (TRIM (p_data(30)), '"'),
                                             REPLACE (TRIM (p_data(31)), '"'),
                                             REPLACE (TRIM (p_data(32)), '"'),
                                             REPLACE (TRIM (p_data(33)), '"'),
                                             REPLACE (TRIM (p_data(34)), '"'),
                                             REPLACE (TRIM (p_data(35)), '"'),
                                             REPLACE (TRIM (p_data(36)), '"'),
                                             REPLACE (TRIM (p_data(37)), '"')
                                           );
                                           
   
   COMMIT;
   
EXCEPTION
  
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_PERFORM_O1XX_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
  
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
