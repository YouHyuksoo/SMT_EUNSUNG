CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAT_WS_INV_TIME_QTY
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
   *   P_LOT_NO  (IN, VARCHAR2) - LOT 번호
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   *   P_DATE  (IN, DATE) - 일자 관련 값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_INVENTORY_4_TIME - 품목 / 재고 / 시간 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAT_WS_INV_TIME_QTY(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAT_WS_INV_TIME_QTY" (
   p_item_code   IN VARCHAR2,
   p_lot_no      IN VARCHAR2,
   p_org         IN NUMBER,
   p_date        IN DATE)
   RETURN NUMBER
IS
   lvf_inventory_qty      NUMBER;
   lvf_ws_inventory_qty   NUMBER;
   lvf_return_qty         NUMBER;
BEGIN
   SELECT NVL (inventory_qty, 0), NVL (ws_inv_qty, 0)
     INTO lvf_inventory_qty, lvf_ws_inventory_qty
     FROM IM_ITEM_INVENTORY_4_TIME
    WHERE     item_code = p_item_code
          AND material_mfs = p_lot_no
          AND inventory_time = p_date;


   --
   --  /*？？？*/
   --  SELECT NVL(SUM(inventory_qty),0)
   --    INTO lvf_inventory_qty
   --    FROM im_item_workstage_inventory
   --   WHERE item_code       = p_item_code
   --        AND material_mfs = p_lot_no
   --        AND organization_id = p_org;
   --
   --  /*？？？？？？？？？
   --  SELECT nvl(sum(x.issue_qty),0)
   --    INTO lvf_issue_qty
   --    FROM im_item_workstage_issue x
   --   WHERE organization_id = p_org
   --     AND item_code like p_item_code
   --     AND material_mfs = p_lot_no
   --     AND enter_date > p_date   ;
   --
   --  /*？？？？？？？？？
   --  SELECT nvl(sum(x.receipt_qty),0)
   --    INTO lvf_receipt_qty
   --    FROM im_item_workstage_receipt x
   --   WHERE organization_id = p_org
   --     AND item_code like p_item_code
   --     AND material_mfs = p_lot_no
   --     AND enter_date > p_date ;
   --

   lvf_return_qty := lvf_ws_inventory_qty;


   RETURN lvf_return_qty;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
