PROCEDURE P_INSERT_SP_RAW (
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
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
   -- 데이타 처리 : SJ
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
                                                DOUBLE_PRINTING_OPTION,
                                                PRINTING_DIRECTION
                                               )
                               VALUES (
                                       REPLACE (TRIM (p_data(1)), '"'),
                                       to_char( to_date( REPLACE (TRIM (p_data(2)), '"'), 'YYYYMMDDHH24MISS' ), 'YYYY/MM/DD HH24:MI:SS'),
                                       NULL,
                                       
                                       sysdate,
                                       'SP',
                                       sysdate,
                                       'FILE WACHTOR',
                                       1,
                                       lvs_file_name,
                                       lvs_line_code,
                                       lvs_machine_code,
                                       '*',
                                                                                                                   
                                       NULL, --REPLACE (TRIM (p_data(30)), '"'),
                                       NULL, --REPLACE (TRIM (p_data(29)), '"'),
                                       
                                       REPLACE (TRIM (p_data(36)), '"'),
                                       REPLACE (TRIM (p_data(37)), '"'),
                                       NULL,
                                       NULL,
                                       
                                       NULL, --REPLACE (TRIM (p_data(40)), '"'),
                                       NULL,
                                       NULL, --REPLACE (TRIM (p_data(9)), '"'),
                                       NULL,
                                       NULL, --REPLACE (TRIM (p_data(10)), '"'),
                                       
                                       REPLACE (TRIM (p_data(5)), '"'),
                                       REPLACE (TRIM (p_data(6)), '"'),
                                       REPLACE (TRIM (p_data(7)), '"'),
                                       REPLACE (TRIM (p_data(8)), '"'),
                                       REPLACE (TRIM (p_data(9)), '"'),
                                       REPLACE (TRIM (p_data(10)), '"'),
                                       REPLACE (TRIM (p_data(11)), '"'),
                                       REPLACE (TRIM (p_data(26)), '"'),
                                       REPLACE (TRIM (p_data(27)), '"'),
                                       
                                       REPLACE (TRIM (p_data(3)), '"'),
                                       REPLACE (TRIM (p_data(31)), '"'),
                                       REPLACE (TRIM (p_data(32)), '"')
                                      );
                                      
 
                                              
 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[P_INSERT_SP_RAW]' || ' ' || SUBSTR (SQLERRM, 1, 300);

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
      
END P_INSERT_SP_RAW;
