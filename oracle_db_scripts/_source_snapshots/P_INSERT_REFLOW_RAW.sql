PROCEDURE "P_INSERT_REFLOW_RAW" (
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (100) := '';
   lvs_job_name       VARCHAR2 (100) := '';
   
   lvs_line_code      VARCHAR2 (20) := '';
   lvs_machine_code   VARCHAR2 (20) := '';
   lvs_column_count   VARCHAR2 (20) := '';
   
   LVS_ERRORMSG       VARCHAR2 (300);
BEGIN
   IF p_info.LAST >= 1  THEN
      lvs_file_name := REPLACE (TRIM (p_info (1)), '"');
   END IF;

   IF p_info.LAST >= 2 THEN
      lvs_line_code := REPLACE (TRIM (p_info (2)), '"');
   END IF;

   IF p_info.LAST >= 3 THEN
      lvs_machine_code := REPLACE (TRIM (p_info (3)), '"');
   END IF;

   IF p_info.LAST >= 5  THEN
      lvs_job_name := REPLACE (TRIM (p_info (5)), '"');
   END IF;
   
   lvs_column_count :=  to_char( p_data.LAST ); 

   INSERT INTO IQ_MACHINE_INSPECT_DATA_REFLOW (
                                                measure_date, 
                                                
                                                top1, 
                                                bottom1, 
                                                
                                                top2, 
                                                bottom2, 
                                                
                                                top3, 
                                                bottom3, 
                                                
                                                top4, 
                                                bottom4, 
                                                
                                                top5, 
                                                bottom5, 
                                                
                                                top6, 
                                                bottom6, 
                                                
                                                top7, 
                                                bottom7, 
                                                
                                                top8, 
                                                bottom8, 
                                                
                                                top9, 
                                                bottom9, 
                                                
                                                top10, 
                                                bottom10, 
                                                
                                                top11, 
                                                bottom11, 
                                                
                                                top12, 
                                                bottom12, 
                                                
                                                top13, 
                                                bottom13, 
                                                
                                                belt_speed, 
                                                oxygen_concentration,  
                                                                                             
                                                enter_date, 
                                                enter_by, 
                                                last_modify_date, 
                                                last_modify_by, 
                                                organization_id, 
                                                file_name, 
                                                line_code, 
                                                machine_code,
                                                job_file
                                                )
                                         VALUES (
                                                 --TO_CHAR( TO_DATE(REPLACE (TRIM (p_data (2)), '"'), 'MM/DD/YYYY HH:MI:SS PM'), 'YYYYY/MM/DD HH24:MI:SS'),  -- 9/9/2020 1:09:43 PM  이 포맷처리시 오류로 sysdate 기준으로 등록
                                                 -- REPLACE (TRIM (p_data (2)), '"'),
                                                 -- TO_CHAR( sysdate, 'YYYY/MM/DD HH24:MI:SS'),
                                                 
                                                 --to_char( TO_DATE( replace( replace( REPLACE ( TRIM ( p_data (2)), '"'),'AM', '오전'), 'PM', '오후'), 'DD/MM/YYYY HH:MI:SS AM'), 'YYYY/MM/DD HH24:MI:SS'),  -- 9/9/2020 1:09:43 PM
                                                 to_char( TO_DATE( REPLACE ( TRIM ( p_data (2)), '"'), 'YYYY-MM-DD AM HH:MI:SS'), 'YYYY/MM/DD HH24:MI:SS'), -- 2020-10-12 오전 12:02:25
                                                 REPLACE (TRIM (p_data (4)), '"'),  -- 1  : Top: PV 0,  bottom: PV 1
                                                 REPLACE (TRIM (p_data (7)), '"'),        
                                                 
                                                 REPLACE (TRIM (p_data (10)), '"'), -- 2   
                                                 REPLACE (TRIM (p_data (13)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (16)), '"'),  --3
                                                 REPLACE (TRIM (p_data (19)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (22)), '"'),  --4
                                                 REPLACE (TRIM (p_data (25)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (28)), '"'), --5
                                                 REPLACE (TRIM (p_data (31)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (34)), '"'), --6
                                                 REPLACE (TRIM (p_data (37)), '"'),
                                                 
                                                 
                                                 REPLACE (TRIM (p_data (46)), '"'), --7
                                                 REPLACE (TRIM (p_data (49)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (52)), '"'), --8
                                                 REPLACE (TRIM (p_data (55)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (58)), '"'), --9
                                                 REPLACE (TRIM (p_data (61)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (64)), '"'), --10
                                                 REPLACE (TRIM (p_data (67)), '"'),
                                                 
                                                 REPLACE (TRIM (p_data (40)), '"'), --11
                                                 NULL, 
                                                 
                                                 REPLACE (TRIM (p_data (106)), '"'),  --12
                                                 NULL,
                                                 
                                                 NULL, --13
                                                 NULL,
                                                 
                                                 REPLACE (TRIM (p_data (43)), '"'),  -- belt spped
                                                 REPLACE (TRIM (p_data (175)), '"'), -- oxygen_concentration
                                                 
                                                                 
                                                 SYSDATE,
                                                 'SYSTEM',
                                                 SYSDATE,
                                                 'SYSTEM',
                                                 1,
                                                 lvs_file_name,
                                                 lvs_line_code,
                                                 lvs_machine_code,
                                                 NVL(lvs_job_name,'*')                                                 
                                                 );

 
 -----------------------------------------------------------------------
 --
 -----------------------------------------------------------------------
   COMMIT;
EXCEPTION
   WHEN OTHERS  THEN
        LVS_ERRORMSG := '[P_INSERT_REFLOW_RAW]' || SUBSTR (SQLERRM, 1, 200);
      
      INSERT
        INTO ICOM_MACHINE_INSERT_LOG (LOG_DATE, ERROR_MESSAGE, ERROR_DESC)
      VALUES (
                SYSDATE,
                LVS_ERRORMSG,
                'LINE =>' || lvs_line_code || ', FILE =>' || lvs_file_name || ', COLUMN COUNT =>' || lvs_column_count||', DATA =>'||REPLACE (TRIM (p_data (2)), '"')
             );

      COMMIT;
      
END ;
