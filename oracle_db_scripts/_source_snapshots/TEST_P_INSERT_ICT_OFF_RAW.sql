PROCEDURE TEST_P_INSERT_ICT_OFF_RAW (
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (200) := '';
   lvs_line_code      VARCHAR2 (20)  := '';
   lvs_machine_code   VARCHAR2 (20)  := '';

   lvs_sql            VARCHAR2 (30000);
   LVS_ERRORMSG       VARCHAR2 (32000);

   lvs_str1        VARCHAR2 (100);
   lvs_str2        VARCHAR2 (100);
   lvs_str3        VARCHAR2 (100);
   lvs_str4        VARCHAR2 (100);
   lvs_str5        VARCHAR2 (100);
   lvs_str6        VARCHAR2 (100);

   lvs_barcode1             VARCHAR2 (100);
   lvs_barcode2             VARCHAR2 (100);

   lvs_result              VARCHAR2 (100);
   lvs_inspect_date        VARCHAR2 (100);


BEGIN

   --********************************************************************
   -- 라인,설비등 기준정보 파싱
   --********************************************************************

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

   --********************************************************************
   -- 화일내 데이타 파싱 ( *.rpc )
   --********************************************************************

   -- CK-14WAY N-IMS-LH_0928_101905_18928C0015-01, 18928C0016-01.rpc

   select regexp_substr(lvs_file_name,'[^_]+',1,1),  -- CK-14WAY N-IMS-LH
          regexp_substr(lvs_file_name,'[^_]+',1,2),  -- 0928
          regexp_substr(lvs_file_name,'[^_]+',1,3),  -- 101905
          regexp_substr(lvs_file_name,'[^_]+',1,4)   -- 18928C0015-01, 18928C0016-01.rpc
     into lvs_str1,
          lvs_str2,
          lvs_str3,
          lvs_str4
     from dual;

   -- 18928C0015-01, .rpc

   lvs_barcode1     := NVL(trim(regexp_substr(lvs_str4,'[^,]+',1,1)), 'NULL');   -- 18928C0015-01

   lvs_str5         := NVL(regexp_substr(lvs_str4,'[^,]+',1,2), 'NULL');         -- 18928C0016-01.rpc
   lvs_barcode2     := NVL(trim(regexp_substr(lvs_str5,'[^.]+',1,1)), 'NULL');   -- 18928C0016-01

   lvs_result       := 'NULL';
   lvs_inspect_date := to_char(sysdate,'YYYY')||lvs_str2||lvs_str3;              -- YYYY0928101905

   IF ( lvs_BARCODE1 = '' ) THEN
        lvs_BARCODE1 := 'NULL';
   END IF;

   IF ( lvs_BARCODE2 = '' ) THEN
        lvs_BARCODE2 := 'NULL';
   END IF;

   --********************************************************************
   -- 이력저장
   --********************************************************************

   lvs_sql := 'INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT ( ';
   lvs_sql := lvs_sql || '
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
              RUN_NO
             )
             VALUES
             (';

   lvs_sql := lvs_sql
              || ''''
              || lvs_barcode1
              || ''''
              || ','
              || ''''
              || to_char(to_date(lvs_inspect_date, 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS')
              || ''''
              || ','
              || ''''
              || lvs_result
              || ''''
              || ','
              || 'SYSDATE'
              || ','
              || ''''
              || 'SYSTEM'
              || ''''
              || ','
              || 'SYSDATE'
              || ','
              || ''''
              || 'SYSTEM'
              || ''''
              || ','
              || '1'
              || ','
              || ''''
              || lvs_file_name
              || ''''
              || ','
              || ''''
              || lvs_line_code
              || ''''
              || ','
              || ''''
              || lvs_machine_code
              || ''''
              || ','
              || ''''
              || '*'
              || ''''
              || ')';

   --EXECUTE IMMEDIATE lvs_sql;

   IF ( lvs_BARCODE2 <> '' and lvs_BARCODE2 <> 'NULL' and length(lvs_BARCODE2)>12) THEN

         lvs_sql := 'INSERT INTO IQ_MACHINE_INSPECT_DATA_ICT ( ';
         lvs_sql := lvs_sql || '
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
                    RUN_NO
                   )
                   VALUES
                   (';

         lvs_sql := lvs_sql
                    || ''''
                    || lvs_barcode2
                    || ''''
                    || ','
                    || ''''
                    || to_char(to_date(lvs_inspect_date, 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS')
                    || ''''
                    || ','
                    || ''''
                    || lvs_result
                    || ''''
                    || ','
                    || 'SYSDATE'
                    || ','
                    || ''''
                    || 'SYSTEM'
                    || ''''
                    || ','
                    || 'SYSDATE'
                    || ','
                    || ''''
                    || 'SYSTEM'
                    || ''''
                    || ','
                    || '1'
                    || ','
                    || ''''
                    || lvs_file_name
                    || ''''
                    || ','
                    || ''''
                    || lvs_line_code
                    || ''''
                    || ','
                    || ''''
                    || lvs_machine_code
                    || ''''
                    || ','
                    || ''''
                    || '*'
                    || ''''
                    || ')';

         --EXECUTE IMMEDIATE lvs_sql;

   END IF;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN

        LVS_ERRORMSG := '[TEST_P_INSERT_ICT_OFF_RAW]' || lvs_sql || SUBSTR (SQLERRM, 1, 200);

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
END TEST_P_INSERT_ICT_OFF_RAW;
