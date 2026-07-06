PROCEDURE "P_INSERT_AOI_RAW" (
   p_data   IN ARRAY5_PARAMS_T,
   p_info   IN ARRAY5_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (200) := '';
   lvs_line_code      VARCHAR2 (20) := '';
   lvs_machine_code   VARCHAR2 (20) := '';
   lvs_sql            VARCHAR2 (30000);
   LVS_ERRORMSG       VARCHAR2 (32000);
   
   lvs_column_count   VARCHAR2 (20) := '';
   
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

   INSERT INTO IQ_MACHINE_INSPECT_DATA_AOI (                                     
                                                  pid, 
                                                  array_no, 
                                                  crd,
                                                  part_name, 
                                                  result, 
                                                  review_result,
                                                  defect_code,
                                                  
                                                  enter_date,
                                                  enter_by,
                                                  last_modify_date,
                                                  last_modify_by,
                                                  organization_id,
                                                  file_name,
                                                  line_code,
                                                  machine_code,
                                                  
                                                  cstid,
                                                  equipmentid,
                                                  inspect_date,   
                                                   run_no,                                          
                                                  c7,
                                                  review_date,
                                                  job_file
                                                 )
                                 VALUES (
                                         REPLACE (TRIM (p_data(1)), '"'),
                                         NULL,
                                         NULL,
                                         NULL,
                                         REPLACE (TRIM (p_data(5)), '"'),
                                         REPLACE (TRIM (p_data(6)), '"'),
                                         NULL,

                                         sysdate,
                                         'FILE WATCHER',
                                         sysdate,
                                         'FILE WATCHER',
                                         1,
                                         lvs_file_name,
                                         lvs_line_code,
                                         lvs_machine_code,
                                         
                                         '*', 
                                         lvs_machine_code,
                                         to_char( to_date( REPLACE (TRIM (p_data(2)), '"'), 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS' ),  -- 20201014155941  
                                        '*',
                                         NULL,
                                         to_char( to_date( REPLACE (TRIM (p_data(3)), '"'), 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS' ),  -- 20201014155941  
                                         
                                         REPLACE (TRIM (p_data(4)), '"')
                                         );
   
   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN

      LVS_ERRORMSG :=
         '[P_INSERT_AOI_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);
   ROLLBACK ;
         INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
       VALUES ( SYSDATE  , LVS_ERRORMSG  , 'FILE = '||lvs_file_name||', LINE = '||lvs_line_code||', COLUMN COUNT = ' || lvs_column_count ) ;

      COMMIT;
      
END P_INSERT_AOI_RAW;
