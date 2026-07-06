CREATE OR REPLACE PACKAGE
  /* ================================================================
   * 패키지명  : PKG_MATERIAL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   자재 기준, 재고, 투입/출고 관련 공통 처리를 묶어 제공하는 패키지이다.
   *   자재 업무 화면과 배치 처리에서 반복되는 조회/계산 로직을 재사용한다.
   * ================================================================
   * [AI 분석] 공개/구현 객체:
   *   FUNCTION MAT_MFS_RESULT_NET_COST - 패키지 내 업무 처리 단위
   *   FUNCTION MAT_MFS_SHIPPING_NET_COST - 패키지 내 업무 처리 단위
   *   FUNCTION MAT_MFS_TOTAL_COST - 패키지 내 업무 처리 단위
   *   FUNCTION MAT_MFS_TOTAL_4_PROFIT_COST - 패키지 내 업무 처리 단위
   *   FUNCTION MAT_AUTO_PURCHASE_ORDER - 패키지 내 업무 처리 단위
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
   *   EXEC PKG_MATERIAL.<PROCEDURE_NAME>(...);
   *   SELECT {clean(name)}.<FUNCTION_NAME>(...) FROM DUAL;
   * ================================================================ */
 "PKG_MATERIAL" 
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



   FUNCTION mat_mfs_result_net_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_mfs_shipping_net_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_mfs_total_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_mfs_total_4_profit_cost(
      p_org      IN   NUMBER,
      p_yyyymm   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION mat_auto_purchase_order(
      p_item_code   IN   VARCHAR2,
      p_order_qty   IN   NUMBER,
      p_line_type   IN   VARCHAR2,
      p_org         IN   NUMBER
   )
      RETURN NUMBER;
END; -- Package spec;
