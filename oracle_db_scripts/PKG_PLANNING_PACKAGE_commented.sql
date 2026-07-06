CREATE OR REPLACE PACKAGE
  /* ================================================================
   * 패키지명  : PKG_PLANNING
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   생산/자재 계획 관련 조회와 계산 로직을 묶어 제공하는 패키지이다.
   *   여러 화면 또는 배치 로직에서 공통 계획 데이터를 재사용하도록 구성된 것으로 추정된다.
   * ================================================================
   * [AI 분석] 공개/구현 객체:
   *   FUNCTION PLAN_CHILD_ITEM_ISSUE - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_WS_CHILD_ITEM_ISSUE - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_WS_CHILD_ITEM_ISSUE_GEN - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_PROD_CHILD_ITEM_ISSUE - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_PROD_CHILD_ITEM_BAD_ISSUE - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_ASSY_PLAN_GEN - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_ASSY_PLAN_GEN_ONESELF - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_ASSY_EXPLOSION - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_ASSY_EXPLOSION_ONESELF - 패키지 내 업무 처리 단위
   *   FUNCTION PLAN_PROD_EXPLOSION - 패키지 내 업무 처리 단위
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (패키지 선언부 또는 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   EXEC PKG_PLANNING.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "PKG_PLANNING" 
AS
   FUNCTION plan_child_item_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION plan_ws_child_item_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_sub_mfs              IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_product_result_weight   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;


   FUNCTION plan_ws_child_item_issue_gen(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_sub_mfs              IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_product_result_weight   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;



   FUNCTION plan_prod_child_item_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;

  FUNCTION plan_prod_child_item_bad_issue(
      p_product_date         IN   DATE,
      p_product_sequence     IN   NUMBER,
      p_mfs                  IN   VARCHAR2,
      p_item_code            IN   VARCHAR2,
      p_line_code            IN   VARCHAR2,
      p_workstage_code       IN   VARCHAR2,
      p_machine_code         IN   VARCHAR2,
      p_product_result_qty   IN   NUMBER,
      p_result_status        IN   VARCHAR2,
      p_org                  IN   NUMBER
   )
      RETURN NUMBER;

   -- ASSEMBLY PLAN GENERATE
   FUNCTION plan_assy_plan_gen(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

   -- wire ASSEMBLY PLAN GENERATE
   FUNCTION plan_assy_plan_gen_oneself(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_line_code       IN   VARCHAR2,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

   -- WORKSTAGE ASSY ITEM EXPLOSION
   FUNCTION plan_assy_explosion(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;


   -- WORKSTAGE WIRE ASSY ITEM EXPLOSION
   FUNCTION plan_assy_explosion_oneself(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

-- WORKSTAGE ASSY ITEM EXPLOSION
   FUNCTION plan_prod_explosion(
      p_plan_date       IN   DATE,
      p_plan_sequence   IN   NUMBER,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;
END pkg_planning;
