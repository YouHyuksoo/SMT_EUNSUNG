CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MASTER_PID_SHS
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
   *   P_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MODEL_MASTER - 제품 / 모델 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_SMTDATE_CODE - 관련 업무 함수 호출
   *   F_GET_MODEL_TYPE - 관련 업무 함수 호출
   *   F_GET_YEAR_CODE - 관련 업무 함수 호출
   *   F_GET_MONTH_CODE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회, ELSIF 5회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MASTER_PID_SHS(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MASTER_PID_SHS" (p_item_code IN VARCHAR2)
/* Formatted on 2015-06-29 19:19:57 (QP5 v5.126) */
    RETURN VARCHAR2
IS
    lvs_return          VARCHAR2 (30);
    lvs_customer_code   VARCHAR2 (10);
    lvs_days            VARCHAR2 (10);
    lvs_seq             VARCHAR2 (10);
    lvs_model_type      VARCHAR2 (10);
    lvs_site_code       VARCHAR2 (10);
    LVS_REVISION        VARCHAR2 (10);
    LVS_ITEM_CODE       VARCHAR2 (30);
    lvs_model_name      VARCHAR2 (30);

BEGIN

    BEGIN
        SELECT   customer_code , model_type ,site_code  , substr(revision,1,1) , item_code, model_name
          INTO   lvs_customer_code , lvs_model_type  , lvs_site_code , lvs_revision , lvs_item_code, lvs_model_name
          FROM   ip_product_model_master
         WHERE   (item_code = p_item_code OR model_name = p_item_code) AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            raise_application_error (-20005, p_item_code || ' ' || lvs_customer_code || ' ' || SQLERRM);
    END;

    --------------------------------------------------------------
    --  FACTORY , LINE , YY , DAYS , SERIAL(3)    -- 11 digit
    --------------------------------------------------------------
    SELECT   TO_CHAR (SYSDATE, 'DDD') INTO lvs_days FROM DUAL;

    --------------------------------------------------------------
    -- KEFICO
    --------------------------------------------------------------
    IF lvs_customer_code = '50401'
    THEN
        lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce4.NEXTVAL, '0000'));

      -- 20161223 SHS, Sequence ？？？？？？？ ？？？？？？？ 
        lvs_return := '4' || SUBSTR (lvs_seq, 1, 1) || TO_CHAR (SYSDATE, 'YY') || lvs_days || SUBSTR (lvs_seq, 2, 3);
      --  lvs_return := '4' || SUBSTR (lvs_seq, 1, 1) || '26' || lvs_days || SUBSTR (lvs_seq, 2, 3);

    --------------------------------------------------------------
    --BOSCH
    --------------------------------------------------------------
    ELSIF lvs_customer_code = 'BOSCH'
    THEN
        lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce7.NEXTVAL, '0000000'));

        lvs_return := '91' ||lvs_seq;

    --------------------------------------------------------------
    --  LG INNOTEK 10 DIGIT
    --------------------------------------------------------------
    ELSIF lvs_customer_code = '00844'
    THEN

        -- 20161223 SHS, model_name？？ item_code ？？ ？？？？ ？？？？？？ ？？？？
        lvs_return :=
               'Y'
            || f_get_smtdate_code (lvs_model_name, SYSDATE)
            || f_get_model_type (p_item_code, 1)
            || TRIM (TO_CHAR (seq_pid_sequnce5.NEXTVAL, '00000'));

    --------------------------------------------------------------
    -- DY
    --------------------------------------------------------------
    ELSIF lvs_customer_code = 'DY'
    THEN
        lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce4_dy.NEXTVAL, '0000'));

        --？？？？ ？？？ ？？？？  1

        lvs_return := nvl(lvs_model_type,'1') || SUBSTR (lvs_seq, 1, 1) || TO_CHAR (SYSDATE, 'YY') || lvs_days || SUBSTR (lvs_seq, 2, 3);

    --------------------------------------------------------------
    -- HLDS
    --------------------------------------------------------------
   ELSIF lvs_customer_code = 'HLDS'
   THEN
      lvs_seq := TRIM (TO_CHAR (seq_pid_sequnce5.NEXTVAL, '00000'));

      lvs_return := lvs_site_code||lvs_seq||TO_CHAR(SYSDATE,'YYMMDD')||LVS_REVISION||LVS_ITEM_CODE ;

    --------------------------------------------------------------
    --  ？？？？？？？u 10 DIGIT
    --------------------------------------------------------------
    ELSIF lvs_customer_code = '00200'
    THEN

        lvs_return := lvs_site_code
                      || 'A'  -- line code : 1~9, A-Z
                      || f_get_year_code (lvs_model_name, SUBSTR(TO_CHAR (sysdate, 'yyyymmdd'), 1, 6))
                      || f_get_month_code(lvs_model_name, SUBSTR(TO_CHAR (sysdate, 'yyyymmdd'), 1, 6))
                      || to_char(sysdate,'DD')
                      || lvs_revision
                      || TRIM (TO_CHAR (SEQ_PID_SEQUNCE8_SEOUL.NEXTVAL, '000'));

   ELSE
        lvs_return := '*';
    END IF;

    RETURN lvs_return;

EXCEPTION
    WHEN OTHERS
    THEN
        raise_application_error (-20005, p_item_code || ' ' || lvs_customer_code || ' ' || SQLERRM);
END;
