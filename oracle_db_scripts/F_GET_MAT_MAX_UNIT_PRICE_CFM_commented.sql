CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAT_MAX_UNIT_PRICE_CFM
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
   *   P_LINE_TYPE  (IN, VARCHAR2) - 라인 관련 값
   *   P_DATE  (IN, DATE) - 일자 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_UNIT_PRICE - 품목 / 단가 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_LOCAL_CURRENCY - 관련 업무 함수 호출
   *   F_GET_EXCHANGE_RATE - 관련 업무 함수 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAT_MAX_UNIT_PRICE_CFM(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAT_MAX_UNIT_PRICE_CFM" (
   p_item_code       IN   VARCHAR2,
   P_line_type       IN   VARCHAR2,
   p_date            IN   DATE,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_price   NUMBER;
   lvs_currency varchar2(3);
   phase varchar2(10) ;
BEGIN
 
  -- RETURN 1 ;
  -----------------------------------------------------
  -- 단가 빼달라는 요청 20171207 곽차장
  -----------------------------------------------------
 
   phase := '10' ;  
   SELECT max(unit_price) , max(currency)
     INTO lvf_price , lvs_currency
     FROM im_item_unit_price
    WHERE item_code = p_item_code
     -- AND line_type = p_line_type
      AND dateset <= p_date
      AND dateend >= p_date
     -- AND PRICE_CHANGE_CONFIRM_YN = 'Y'
      AND organization_id = p_org;

     phase := '20' ;   
    if f_get_local_currency(p_org) <> lvs_currency then
       phase := '30' ; 
       lvf_price := lvf_price * f_get_exchange_rate(p_date , lvs_currency);
       phase := '40' ; 
    end if ;

   RETURN NVL(lvf_price,0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, phase||' '||SQLERRM);
END;
