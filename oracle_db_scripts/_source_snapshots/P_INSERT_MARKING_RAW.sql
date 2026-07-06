PROCEDURE "P_INSERT_MARKING_RAW" (
                                                          p_data   IN ARRAY5_PARAMS_T,
                                                          p_info   IN ARRAY5_PARAMS_T
                                                        )
IS

   lvs_file_name      VARCHAR2 (100) := '';
   lvs_line_code      VARCHAR2 (20)  := '';
   lvs_machine_code   VARCHAR2 (20)  := '';
   
   LVS_ERRORMSG       VARCHAR2 (300);
   
   lvl_column_count   number        := 0;
   
   lvs_dateset        VARCHAR2 (20) := '';
   lvs_date_string    VARCHAR2 (20) := '';
   
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

   lvl_column_count :=  p_data.LAST;

   ----------------------------------------------------------------------------
   -- 데이타 처리
   ----------------------------------------------------------------------------

   IF ( lvs_line_code = '03' 
        or lvs_line_code = '04' 
        or lvs_line_code = '05' 
        or lvs_line_code = '06' 
        or lvs_line_code = '09' 
        or lvs_line_code = '10' 
        or lvs_line_code = '11') and lvl_column_count = 4   THEN    -- STS
       -- STS
       
             lvs_date_string := REPLACE (TRIM (p_data (2)), '"')||REPLACE (TRIM (p_data (3)), '"');             -- "210401""  +  101223"
             lvs_dateset     := to_char( to_date( lvs_date_string, 'YYMMDDHH24MISS' ), 'YYYY/MM/DD HH24:MI:SS' );
             
             INSERT INTO IQ_MACHINE_INSPECT_DATA_MK (
                                                     lotid, 
                                                     cstid, 
                                                     seq, 
                                                     pid, 
                                                     
                                                     equipmentid, 
                                                     dateset, 
                                                     result_code,
                                                      
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
                     REPLACE (TRIM (p_data (4)), '"'),
                     REPLACE (TRIM (p_data (1)), '"'),
                     REPLACE (TRIM (p_data (3)), '"'),    -- 시간을 임시로 남김 마킹일자가 시간만 가지고 있어서  : 101223"
                     REPLACE (TRIM (p_data (1)), '"'),
                     
                     lvs_machine_code,
                     lvs_dateset, 
                     NULL,
                     
                     sysdate,
                     'SYSTEM',
                     sysdate,
                     'SYSTEM',
                     1,
                     
                     lvs_file_name,
                     REPLACE (TRIM (p_data (4)), '"'),
                     lvs_line_code,
                     lvs_machine_code
                    );
 
   ELSIF (lvs_line_code = '01' 
          or lvs_line_code = '02' 
          or  lvs_line_code = '07' 
          or lvs_line_code = '08' 
          or lvs_line_code = '12'
          or lvs_line_code = '18' 
          ) and lvl_column_count = 3 THEN   -- KIT
     
     
             lvs_date_string := REPLACE (TRIM (p_data (2)), '"');
             lvs_dateset     := to_char( to_date( lvs_date_string, 'YYYY-MM-DD HH24:MI:SS' ), 'YYYY/MM/DD HH24:MI:SS' );   -- 2021-04-21 09:47:04
                                                                                                                              -------------------
             INSERT INTO IQ_MACHINE_INSPECT_DATA_MK (
                                                     lotid, 
                                                     cstid, 
                                                     seq, 
                                                     pid, 
                                                     
                                                     equipmentid, 
                                                     dateset, 
                                                     result_code,
                                                      
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
                     REPLACE (TRIM (p_data (3)), '"'),
                     REPLACE (TRIM (p_data (1)), '"'),
                     REPLACE ( SUBSTR( lvs_date_string, 12, 8 ), ':'),    -- 2021-04-21 09:47:04
                     REPLACE (TRIM (p_data (1)), '"'),                                  --------
                     
                     lvs_machine_code,
                     lvs_dateset, 
                     NULL,
                     
                     sysdate,
                     'SYSTEM',
                     sysdate,
                     'SYSTEM',
                     1,
                     
                     lvs_file_name,
                     REPLACE (TRIM (p_data (3)), '"'),
                     lvs_line_code,
                     lvs_machine_code
                    );
                     
   END IF;
   
   
 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;
   
EXCEPTION
   WHEN OTHERS THEN
     
        LVS_ERRORMSG := '[P_INSERT_MARKING_RAW]' || ' ' || SUBSTR (SQLERRM, 1, 200);
        
        ROLLBACK ;
        INSERT INTO ICOM_MACHINE_INSERT_LOG( 
                                             LOG_DATE , 
                                             ERROR_MESSAGE , 
                                             ERROR_DESC,
                                             
                                             TEMP1,
                                             TEMP2,
                                             TEMP3,
                                             TEMP4
                                             
                                           )
                                    VALUES (
                                             SYSDATE, 
                                             LVS_ERRORMSG  , 
                                            'FILE = '||lvs_file_name,
                                             
                                             lvs_line_code,
                                             lvs_machine_code,
                                             lvs_date_string,
                                             lvl_column_count
                                              
                                           ) ;

      COMMIT;
      
END ;
