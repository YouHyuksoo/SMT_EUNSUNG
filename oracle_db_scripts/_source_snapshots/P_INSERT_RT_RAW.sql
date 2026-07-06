PROCEDURE "P_INSERT_RT_RAW" (
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (100) := '';
   lvs_line_code      VARCHAR2 (20) := '';
   lvs_machine_code   VARCHAR2 (20) := '';
   LVS_ERRORMSG       VARCHAR2 (300);
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

   ----------------------------------------------------------------------------
   -- 데이타 처리
   ----------------------------------------------------------------------------
   
   -- p_data (1)  ROUTER,
   -- p_data (2)  TMA WALK IN CUSH SW,
   -- p_data (3)  19709A0011-01 
   -- p_data (4)  2019/07/10 06:39:54
   -- p_data (5)  40020
   -- p_data (6)  10326

   INSERT INTO IQ_MACHINE_INSPECT_DATA_RT (
                                           cstid, 
                                           seq_no, 
                                           pid, 
                                           
                                           equipmentid, 
                                           inspect_date, 
                                           result, 
                                           defect_code, 
                                           
                                           enter_date, 
                                           enter_by, 
                                           last_modify_date, 
                                           last_modify_by, 
                                           organization_id, 
                                           
                                           file_name, 
                                           array_no, 
                                           run_no, 
                                           line_code, 
                                           machine_code, 
                                           
                                           rpm_value, 
                                           bit_value
                                          )
   VALUES (
           nvl(regexp_substr(REPLACE (TRIM (p_data (3)), '"'), '[^-]+',1,1), 'NULL'),
           nvl(substr(regexp_substr(REPLACE (TRIM (p_data (3)), '"'),'[^-]+',1,2),1,2),'00'),
           NVL(REPLACE (TRIM (p_data (3)), '"'), 'NULL'),
           
           REPLACE (TRIM (p_data (1)), '"'),
           REPLACE (TRIM (p_data (4)), '"'), 
           'OK',
           '',
           
           sysdate,
           'SYSTEM',
           sysdate,
           'SYSTEM',
           1,
           
           lvs_file_name,
           '',
           'NULL',
           lvs_line_code,
           lvs_machine_code,
           
           REPLACE (TRIM (p_data (5)), '"'), 
           REPLACE (TRIM (p_data (6)), '"')
          );

 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;
   
EXCEPTION
   WHEN OTHERS THEN
     
        LVS_ERRORMSG := '[P_INSERT_RT_RAW]' || ' ' || SUBSTR (SQLERRM, 1, 200);
        
        ROLLBACK ;
        INSERT INTO ICOM_MACHINE_INSERT_LOG( 
                                             LOG_DATE , 
                                             ERROR_MESSAGE , 
                                             ERROR_DESC
                                           )
                                    VALUES (
                                             SYSDATE, 
                                             LVS_ERRORMSG  , 
                                             lvs_file_name||' LINE='||lvs_line_code 
                                           ) ;

      COMMIT;
      NULL;
      
END ;
