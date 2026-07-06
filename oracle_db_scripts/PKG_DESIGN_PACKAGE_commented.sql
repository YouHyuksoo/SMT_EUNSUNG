CREATE OR REPLACE PACKAGE
  /* ================================================================
   * 패키지명  : PKG_DESIGN
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   설계/BOM/모델 기준 정보와 관련된 공통 업무 로직을 제공하는 패키지이다.
   *   제품 기준정보와 설계 변경 데이터 조회/검증에 사용되는 것으로 추정된다.
   * ================================================================
   * [AI 분석] 공개/구현 객체:
   *   FUNCTION BOM_QUERY - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_QUERY_ALL - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_MODEL_QTY - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_TRANSLATION - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_NEWINS_CHECK - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_LOOP_CHECK - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_LOOP_CHECK_ECO - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_ECO_CONFIRM - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_EXPLOSION - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_EXPLOSION_ALL - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_ASSY_EXPLOSION - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_ONESELF_ASSY_EXPLOSION - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_FREE_ASSY_EXPLOSION - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_COPY - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_COUNT - 패키지 내 업무 처리 단위
   *   FUNCTION BOM_MATERIAL_COST - 패키지 내 업무 처리 단위
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
   *   EXEC PKG_DESIGN.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "PKG_DESIGN" 
IS

--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below


   FUNCTION bom_query(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_query_all(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_model_qty(
      p_org          IN   VARCHAR2,
      p_session_id   IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_translation(
      p_work_no         IN   NUMBER,
      p_set_item_code   IN   VARCHAR2,
      p_org             IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_newins_check(
      p_work_no            IN   NUMBER,
      p_set_item_code      IN   VARCHAR2,
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_loop_check(
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_loop_check_eco(
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_eco_confirm(
      p_eco_work_no   IN   NUMBER,
      p_org           IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_explosion_all(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_assy_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_child_item_code    IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   -- wire assy explosion
   FUNCTION bom_oneself_assy_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   -- FREE ASSY ITEM EXPLOSION
   FUNCTION bom_free_assy_explosion(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   -- BOM COPY
   FUNCTION bom_copy(
      p_bom_work_no             IN   NUMBER,
      p_source_item_code        IN   VARCHAR2,
      p_dest_parent_item_code   IN   VARCHAR2,
      p_dest_item_code          IN   VARCHAR,
      p_dateset                      DATE,
      p_org                     IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_count(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION bom_material_cost(
      p_parent_item_code   IN   VARCHAR2,
      p_dateset            IN   DATE,
      p_price_type         IN   VARCHAR2,
      p_org                IN   NUMBER
   )
      RETURN NUMBER;
END; -- Package spec


-- End of DDL Script for Package HSRM.PKG_DESIGN;
