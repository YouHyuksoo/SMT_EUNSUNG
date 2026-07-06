CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PLAN_MOLD_REQUEST_QTY
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
   *   P_PLAN_DATE  (IN, DATE) - 계획 / 일자 관련 값
   *   P_PLAN_SEQUENCE  (IN, NUMBER) - 계획 관련 값
   *   P_BREAK_QTY  (IN, number) - 수량
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_MI_PLAN - 제품 / 계획 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PLAN_MOLD_REQUEST_QTY(...) FROM DUAL;
   * ================================================================ */
 "F_GET_PLAN_MOLD_REQUEST_QTY" (p_plan_date IN DATE, p_plan_sequence IN NUMBER, p_break_qty in number  , p_org IN NUMBER
)
   RETURN NUMBER
IS
   lvf_plan_qty                  NUMBER;
   lvi_qty number ;
BEGIN

   SELECT plan_qty
   INTO   lvf_plan_qty
   FROM   ip_product_mi_plan
   WHERE  plan_date = p_plan_date AND plan_sequence = p_plan_sequence
          AND organization_id = p_org;



           lvi_qty := trunc(lvf_plan_qty / p_break_qty) ;

           if mod( lvf_plan_qty , p_break_qty ) > 0 then
              lvi_qty := lvi_qty + 1  ;
           end if ;

   RETURN lvi_qty;



EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;
