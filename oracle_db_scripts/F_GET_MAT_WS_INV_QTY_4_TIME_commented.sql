CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_MAT_WS_INV_QTY_4_TIME
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
   *   P_MATERIAL_MFS  (IN, VARCHAR2) - 제조/공급 구분
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 제품 관련 값 조회 또는 참조
   *   IM_ITEM_RECEIPT_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 5회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_MAT_WS_INV_QTY_4_TIME(...) FROM DUAL;
   * ================================================================ */
 "F_GET_MAT_WS_INV_QTY_4_TIME" (
   p_item_code   IN VARCHAR2,
   p_material_mfs IN VARCHAR2,
   p_org         IN NUMBER)
   RETURN NUMBER
IS
   lvf_inventory_qty   NUMBER;
   LVL_FEEDING_QTY     NUMBER;
BEGIN


   --   ？？？？？？？？？？？？？
   --------------------------------------------------------------

   --   SELECT SUM(inventory_qty)
   --   INTO   lvf_inventory_qty
   --   FROM   im_item_workstage_inventory
   --   WHERE  item_code = p_item_code AND
   --          organization_id = p_org;
   --------------------------------------------------------------
   --
   --------------------------------------------------------------


   SELECT NVL(SUM (NVL(feeding_qty,0) - NVL(product_actual_qty,0)),0)
     INTO LVL_FEEDING_QTY
     FROM iB_product_plandata
    WHERE item_code = p_item_code
      AND lot_no = p_material_mfs
          AND active_yn = 'Y';


-- SELECT SUM (a.inventory_qty)
--     INTO lvf_inventory_qty
--     FROM im_item_workstage_inventory a
--    WHERE     a.item_code = p_item_code
--          AND a.organization_id = p_org ;


   SELECT SUM(DECODE( NVL(NEW_SCAN_QTY, 0 ) , 0 , SCAN_QTY , NEW_SCAN_QTY  ) )
     INTO lvf_inventory_qty
     FROM im_item_receipt_barcode
    WHERE     item_code = p_item_code
          AND ISSUE_COMPARE_YN  = 'Y'
          AND LOT_NO = p_material_mfs
          AND FEEDING_YN = 'N'
          AND organization_id = p_org ;

--      select sum(nvl(B.scan_qty,0))
--      into LVL_FEEDING_QTY
--      from im_item_workstage_inventory A left outer join im_item_receipt_barcode B on A.item_code = B.item_code and A.material_mfs = B.lot_no and B.feeding_yn = 'N' and A.organization_id = B.organization_id
--      WHERE a.item_code = p_item_code and
--            a.organization_id = p_org;

   RETURN NVL (lvf_inventory_qty, 0) + NVL(LVL_FEEDING_QTY,0) ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
