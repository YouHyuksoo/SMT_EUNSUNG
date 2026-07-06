CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MODEL_NAME
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE  (IN, varchar2) - 라인 코드
   * ================================================================
   * [AI 분석] 반환값:
   *   varchar2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - 제품 / 라인 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MODEL_NAME(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MODEL_NAME" 
  ( p_line_code IN varchar2)
  RETURN  varchar2 IS

    lvs_model_name   VARCHAR2(15);
    lvs_from_date    VARCHAR2(14);
    lvs_to_date      VARCHAR2(14);


    lvd_fdate        DATE;
    lvd_tdate        DATE;


BEGIN

     IF TO_CHAR (SYSDATE, 'HH24MI') < '0820'
     THEN

           --생산실적용 Date
           lvd_fdate     := TO_DATE (TO_CHAR (SYSDATE - 1, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI');
           lvd_tdate     := TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI');

           lvs_from_date := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE - 1, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');
           lvs_to_date   := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');

     ELSE

           --생산실적용 Date
           lvd_fdate     := TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI');
           lvd_tdate     := TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI');

           lvs_from_date := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');
           lvs_to_date   := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');

     END IF;

    /* IF p_line_code = '41' OR  p_line_code = '42' OR p_line_code = '43' OR  p_line_code = '44' OR  p_line_code = '45' OR  p_line_code = '46'
     THEN --기판라인
        BEGIN
          SELECT DISTINCT MODEL
            INTO lvs_model_name
            FROM TB_VIS_TSTRSLT
           WHERE ITEM_CODE     IN ( SELECT ITEM_CODE
                                    FROM IP_PRODUCT_MASTER_PLAN
                                   WHERE PLAN_DATE   >= TRUNC(lvd_fdate)
                                     AND PLAN_DATE   <= TRUNC(lvd_tdate)
                                     AND LINE_CODE   = p_line_code )
             AND CREATED_DATE  = ( SELECT MAX(CREATED_DATE)
                                    FROM TB_VIS_TSTRSLT
                                   WHERE ITEM_CODE     IN ( SELECT ITEM_CODE
                                                            FROM IP_PRODUCT_MASTER_PLAN
                                                           WHERE PLAN_DATE   >= TRUNC(lvd_fdate)
                                                             AND PLAN_DATE   <= TRUNC(lvd_tdate)
                                                             AND LINE_CODE   = p_line_code )
                                    AND CREATED_DATE  >= lvs_from_date
                                    AND CREATED_DATE  <= lvs_to_date
                                    AND RESULT         = 'P'
                                    AND OPERATIONNAME = 'PCB2100' )
            AND RESULT         = 'P'
            AND OPERATIONNAME = 'PCB2100'
            and rownum = 1 ;
        EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                     lvs_model_name := '';
        END;
     ELSE*/
         BEGIN

           SELECT MODEL_NAME
             INTO lvs_model_name
             FROM IP_PRODUCT_LINE
            WHERE line_code = p_line_code;

         EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                     lvs_model_name := '';
         END;
    /* END IF;*/


     RETURN lvs_model_name ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;
