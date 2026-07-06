CREATE OR REPLACE PROCEDURE TEST_P_INSERT_ICT_OFF_RAW (
  /* ================================================================
   * 프로시저명  : TEST_P_INSERT_ICT_OFF_RAW
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   외부 또는 설비에서 전달된 원시/연계 데이터를 대상 테이블에 등록한다.
   *   입력 파라미터와 원본 로직의 데이터 적재 흐름은 그대로 유지했다.
   *   오류 발생 시 원본 예외 처리 방식에 따라 메시지 반환 또는 로그 처리를 수행한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_DATA - 원본 선언부 기준 입력/출력 파라미터
   *   P_INFO - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ICOM_MACHINE_INSERT_LOG - 원본 로직 참조 테이블
   *   IQ_MACHINE_INSPECT_DATA_ICT - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_INFO
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC TEST_P_INSERT_ICT_OFF_RAW(...)
   * ================================================================ */
   p_data   IN ARRAY4_PARAMS_T,
   p_info   IN ARRAY4_PARAMS_T)
IS
   lvs_file_name      VARCHAR2 (200) := ''; -- [AI] 내부 처리용 변수
   lvs_line_code      VARCHAR2 (20)  := ''; -- [AI] 내부 처리용 변수
   lvs_machine_code   VARCHAR2 (20)  := ''; -- [AI] 내부 처리용 변수

   lvs_sql            VARCHAR2 (30000); -- [AI] 내부 처리용 변수
   LVS_ERRORMSG       VARCHAR2 (32000); -- [AI] 내부 처리용 변수

   lvs_str1        VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_str2        VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_str3        VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_str4        VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_str5        VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_str6        VARCHAR2 (100); -- [AI] 내부 처리용 변수

   lvs_barcode1             VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_barcode2             VARCHAR2 (100); -- [AI] 내부 처리용 변수

   lvs_result              VARCHAR2 (100); -- [AI] 내부 처리용 변수
   lvs_inspect_date        VARCHAR2 (100); -- [AI] 내부 처리용 변수


BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.

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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
