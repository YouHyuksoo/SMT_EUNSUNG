PROCEDURE TEST_P_INSERT_DATA3_RAW (
   p_data   IN ARRAY5_PARAMS_T,
   p_data2   IN ARRAY5_PARAMS_T,
   p_data3   IN ARRAY5_PARAMS_T,
   p_info   IN ARRAY5_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (200) := '';
   lvs_line_code      VARCHAR2 (20) := '';
   lvs_machine_code   VARCHAR2 (20) := '';
   lvs_file_path      VARCHAR2 (3000) := '';
   lvs_sql            VARCHAR2 (30000);
   LVS_ERRORMSG       VARCHAR2 (32000);
   lvs_info5          VARCHAR2 (3000) := '';
   li_key_count       int := 0;

   lvs_info5_str1     VARCHAR2 (100) := '';
   lvs_info5_str2     VARCHAR2 (3000) := '';

   lvs_str1        VARCHAR2 (100) := '';
   lvs_str2        VARCHAR2 (100) := '';
   lvs_str3        VARCHAR2 (100) := '';
   lvs_str4        VARCHAR2 (100) := '';
   lvs_str5        VARCHAR2 (100) := '';
   lvs_str6        VARCHAR2 (100) := '';
BEGIN
   --********************************************************************
   -- info 기준정보
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

   IF p_info.LAST >= 4
   THEN
      lvs_file_path := REPLACE (TRIM (p_info (4)), '"');
   END IF;

   --********************************************************************
   -- data 데이타정보
   --********************************************************************
   IF lvs_machine_code = 'MOI' --MOI
   THEN
        lvs_sql := 'INSERT INTO TEST_DATA_RAW ( C1';

       IF p_info.LAST >= 5
       THEN
          lvs_info5 := REPLACE (TRIM (p_info (5)), '"');    -- #7=R160239-2020_05_20-10:19:33,OK,2020/05/20_10:19:33,R160239,

          select regexp_substr(lvs_info5,'[^=]+',1,1),      -- #7
                 regexp_substr(lvs_info5,'[^=]+',1,2)       -- R160239-2020_05_20-10:19:33,OK,2020/05/20_10:19:33,R160239,
            into lvs_info5_str1,
                 lvs_info5_str2
            from dual;

          IF lvs_info5_str2 is not null
          THEN
                                                               -- R160239-2020_05_20-10:19:33,OK,2020/05/20_10:19:33,R160239,
            select regexp_substr(lvs_info5_str2,'[^,]+',1,2),  -- Inspection result    OK
                  regexp_substr(lvs_info5_str2,'[^,]+',1,3),  -- Inspection date       2020/05/20_10:19:33
                  regexp_substr(lvs_info5_str2,'[^,]+',1,4)  -- Serial No.             R160239
             into lvs_str1,
                  lvs_str2,
                  lvs_str3
             from dual;

             li_key_count := 3;
          end if;
       END IF;
   ELSIF lvs_machine_code = 'ICT' --ICT
   THEN
        lvs_sql := 'INSERT INTO TEST_DATA_RAW ( C1';

   ELSIF lvs_machine_code = 'SPI' --SPI
   THEN
        lvs_str1 := SUBSTR(lvs_file_name, LENGTH(lvs_file_name), 1);

        IF p_data.LAST > 26
          THEN
            lvs_sql := 'INSERT INTO TEST_DATA_RAW ( C1';

        ELSE
          return;

        END IF;

        li_key_count := 3;

   ELSIF lvs_machine_code = 'M1' --TEST
   THEN
        lvs_str1 := SUBSTR(lvs_file_name, LENGTH(lvs_file_name), 1);

        IF p_data.LAST > 26
          THEN
            lvs_sql := 'INSERT INTO TEST_DATA_RAW ( C1';

        ELSE
          return;

        END IF;

        li_key_count := 3;
   ELSE
        return;
   END IF;

   FOR i IN p_data.FIRST + 1 .. p_data.LAST + li_key_count
   LOOP
      lvs_sql := lvs_sql || ', C' || i;
   END LOOP;

   lvs_sql := lvs_sql
        || ',
            ENTER_DATE       ,
            ENTER_BY         ,
            LAST_MODIFY_DATE ,
            LAST_MODIFY_BY   ,
            ORGANIZATION_ID  ,
            FILE_NAME        ,
            LINE_CODE        ,
            MACHINE_CODE     ,
            RUN_NO           ,
            FILE_PATH
            )
              VALUES
            (';

   lvs_sql := lvs_sql || '''' || REPLACE (TRIM (p_data (1)), '"') || '''';

   FOR i IN p_data.FIRST + 1 .. p_data.LAST
   LOOP
      lvs_sql := lvs_sql || ', ''' || REPLACE (TRIM (p_data (i)), '"') || '''';
   END LOOP;


   IF lvs_machine_code = 'MOI' AND li_key_count > 0
     THEN
       --add master keys
       lvs_sql := lvs_sql
          || ','
          || ''''
          || lvs_str1
          || ''''
          || ','
          || ''''
          || lvs_str2
          || ''''
          || ','
          || ''''
          || lvs_str3
          || '''';

   ELSIF lvs_machine_code = 'SPI' AND li_key_count > 0
     THEN
       --add comments
       lvs_sql := lvs_sql
          || ','
          || ''''
          || lvs_str1
          || ''''
          || ','
          || ''''
          || REPLACE (TRIM (p_data2 (2)), '"')
          || ''''
          || ','
          || ''''
          || REPLACE (TRIM (p_data3 (7)), '"')
          || '''' ;

   ELSIF lvs_machine_code = 'M1' AND li_key_count > 0
     THEN
       --add comments
       lvs_sql := lvs_sql
          || ','
          || ''''
          || lvs_str1
          || ''''
          || ','
          || ''''
          || REPLACE (TRIM (p_data2 (2)), '"')
          || ''''
          || ','
          || ''''
          || REPLACE (TRIM (p_data3 (7)), '"')
          || '''' ;
   END IF;

   lvs_sql := lvs_sql
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
      || ','
      || ''''
      || lvs_file_path
      || ''''
      || ')';

   EXECUTE IMMEDIATE lvs_sql;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      LVS_ERRORMSG :=
         '[TEST_P_INSERT_DATA3_RAW]'|| SUBSTR (SQLERRM, 1, 200)|| lvs_sql;

    --   INSERT INTO ICOM_MACHINE_INSERT_LOG( LOG_DATE , ERROR_MESSAGE , ERROR_DESC )
     --  VALUES ( SYSDATE  , LVS_ERRORMSG  , lvs_file_name||' LINE='||lvs_line_code  ) ;
      ps_job_errorlog(990,1,'TEST_P_INSERT_DATA3_RAW','RAW',LVS_ERRORMSG,'FFF');
      COMMIT;
      NULL;
END TEST_P_INSERT_DATA3_RAW;
