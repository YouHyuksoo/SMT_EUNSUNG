PROCEDURE P_INSERT_SPI_PARMI_RAW(
                                               p_data     IN ARRAY5_PARAMS_T,
                                               p_data2    IN ARRAY5_PARAMS_T,
                                               p_info     IN ARRAY5_PARAMS_T
                                            )
IS
   lvs_file_name      VARCHAR2 (100) := '';
   lvs_line_code      VARCHAR2 (20)  := '';
   lvs_machine_code   VARCHAR2 (20)  := '';
   
   lvs_mode           VARCHAR2 (20)  := '';
   lvs_column_count1  VARCHAR2 (20) := '';
   lvs_column_count2  VARCHAR2 (20) := '';

   LVS_ERRORMSG       VARCHAR2 (500);
   
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
   
   lvs_column_count1 :=  to_char( p_data.LAST ); 
   lvs_column_count2 :=  to_char( p_data2.LAST ); 
   
   ----------------------------------------------------------------------------
   -- 데이타 처리
   ----------------------------------------------------------------------------
 
                   
       INSERT INTO IQ_MACHINE_INSPECT_DATA_SPI (  
                                                pid, 
                                                array_no, 
                                                crd,
                                                part_name, 
                                                result, 
                                                review_result,
                                                defect_code,
                                                defect_name,
                                                bad_mark,
                                                
                                                cstid, 
                                                seq_no, 
                                                equipmentid,                                               
                                                inspect_date, 
                                                result_group, 
   
                                                enter_date, 
                                                enter_by, 
                                                last_modify_date, 
                                                last_modify_by, 
                                                organization_id, 
                                                file_name, 
                                                run_no, 
                                                line_code, 
                                                machine_code
                                               )
                               VALUES (
                                       REPLACE (TRIM (p_data(2)), '"'),
                                       REPLACE (TRIM (p_data(1)), '"'),
                                       NULL,
                                       NULL,
                                       REPLACE (TRIM (p_data(6)), '"'),
                                       NULL,
                                       REPLACE (TRIM (p_data(4)), '"'),
                                       REPLACE (TRIM (p_data(3)), '"'),
                                       REPLACE (TRIM (p_data(5)), '"'),
                                                                            
                                       '*',
                                       '00',
                                       lvs_machine_code,
                                      -- to_char( sysdate, 'YYYY/MM/DD HH24:MI:SS' ),  
                                       to_char( to_date(REPLACE (TRIM (p_data2(6)), '"')||' '||REPLACE (TRIM (p_data2(7)), '"'),'YYYYMMDD HH24:MI:SS'), 'YYYY/MM/DD HH24:MI:SS' ),
                                       NULL,
                                       
                                       sysdate,
                                       'FILE WACHTOR',
                                       sysdate,
                                       'FILE WACHTOR',
                                       1,
                                       lvs_file_name||'.'||lvs_mode,
                                       '*',
                                       lvs_line_code,
                                       lvs_machine_code
                                      );  
                                               
                                              
 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_SPI_PARMI_RAW]' || ' ' || SUBSTR (SQLERRM, 1, 300);

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
                                             SYSDATE,
                                             LVS_ERRORMSG  ,
                                             'FILE = '||lvs_file_name,
                                             
                                             'LINE = '||lvs_line_code,
                                             'p_data C5, p_data2 C11',
                                             lvs_column_count1 ,
                                             lvs_column_count2 ,
                                             p_data2(6)||', '||p_data2(7)
                                           ) ;

      COMMIT;

END ;
