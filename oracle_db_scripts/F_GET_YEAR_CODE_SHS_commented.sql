CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_YEAR_CODE_SHS
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
   *   P_MODEL_NAME  (IN, VARCHAR2) - 모델 / 명칭 관련 값
   *   P_YYYY  (IN, VARCHAR2) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_YEAR_BASE - 제품 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_YEAR_CODE_SHS(...) FROM DUAL;
   * ================================================================ */
 F_GET_YEAR_CODE_SHS (
   p_model_name   IN VARCHAR2,
   p_yyyy         IN VARCHAR2)
   RETURN VARCHAR2
IS
   lvs_return   VARCHAR2 (2);
   lvs_yyyy     VARCHAR2 (10);
   lvs_mm       VARCHAR2 (10);
BEGIN
   -------------------------------------------------------------------------
   --
   -------------------------------------------------------------------------
   BEGIN
     
      SELECT yyyy_code
        INTO lvs_yyyy
        FROM ip_product_year_base
       WHERE model_name = p_model_name AND yyyy = SUBSTR (p_yyyy, 1, 4);
       
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
      
         --lvs_yyyy := TO_CHAR (SYSDATE, 'Y');
         --lvs_yyyy := '*' ;
         
         -- select trim(substr(to_char(sysdate,'YYYY'),4,1))
         --  into lvs_yyyy
         --  from dual;
           
         RAISE_APPLICATION_ERROR(-20003, '생산월력 미등록 ( f_get_year_code ) => '||p_model_name||', '||SUBSTR (p_yyyy, 1, 4) ||' => '|| SQLERRM ) ;
     
   END;

   lvs_return := lvs_yyyy;

   RETURN lvs_return;

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
            'f_get_year_code MODEL NAME='
         || p_model_name
         || ' YYYY='
         || p_yyyy
         || '  '
         || SQLERRM);
END;
