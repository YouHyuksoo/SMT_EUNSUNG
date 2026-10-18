CREATE OR REPLACE FUNCTION F_GET_ASSY_SEMI_ITEM (
   p_run_no IN VARCHAR2
) RETURN VARCHAR2
  /* ================================================================
   * 함수명 : F_GET_ASSY_SEMI_ITEM
   * 작성일 : 2026-10-18
   * 수정이력:
   *   2026-10-18 - AI(Claude) - SMT 런의 반제품(생산 품목)을 BOM 기준으로 돌려준다 (P_ASSY_RESULT_ADD 에서 떼어냄)
   * ================================================================
   * 기능 설명:
   *   런카드(RUN_NO)의 제품(ITEM_CODE)·면(PCB_ITEM T/B)으로 그 런이 만드는 반제품을 찾는다.
   *   - 모델 분류(IP_PRODUCT_MODEL_MASTER.BOM_EXPLODE_TYPE)가 RAW(원자재만)면 제품 자신.
   *   - 그 외는 제품 BOM(ID_ENG_BOM)의 반제품 행(자식이 있는 행, 부모 '*' 제외) 중
   *     PCB_ITEM 이 런카드 면 또는 '*'(양면)인 품목. 같은 면이 우선. 오늘 유효 BOM.
   *   - SMT 런카드(면 T/B)가 아니거나 찾지 못하면 NULL.
   *   쓰는 곳: P_ASSY_RESULT_ADD(AOI·수기·보정 실적), P_WIP_MOVE_BY_MAGAZINE(매거진 공정간 이동).
   *   설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md
   * ================================================================ */
IS
   v_side    VARCHAR2(1);
   v_model   VARCHAR2(100);
   v_product VARCHAR2(30);
   v_type    VARCHAR2(20);
   v_item    VARCHAR2(30);
BEGIN
   BEGIN
      SELECT r.PCB_ITEM, r.MODEL_NAME, r.ITEM_CODE INTO v_side, v_model, v_product
        FROM IP_PRODUCT_RUN_CARD r
       WHERE r.RUN_NO = p_run_no AND r.ORGANIZATION_ID = 1 AND r.PCB_ITEM IN ('T', 'B') AND ROWNUM = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
   END;
   BEGIN
      SELECT NVL(m.BOM_EXPLODE_TYPE, 'NONE') INTO v_type
        FROM IP_PRODUCT_MODEL_MASTER m WHERE m.MODEL_NAME = v_model AND m.ORGANIZATION_ID = 1;
   EXCEPTION WHEN NO_DATA_FOUND THEN v_type := 'NONE';
   END;
   IF v_type = 'RAW' THEN RETURN v_product; END IF;
   SELECT MAX(b.CHILD_ITEM_CODE) KEEP (DENSE_RANK FIRST ORDER BY CASE b.PCB_ITEM WHEN v_side THEN 0 ELSE 1 END)
     INTO v_item
     FROM ID_ENG_BOM b
    WHERE b.ITEM_CODE = v_product AND b.ORGANIZATION_ID = 1 AND b.PARENT_ITEM_CODE <> '*'
      AND b.PCB_ITEM IN (v_side, '*') AND b.CHILD_ITEM_CODE <> b.PARENT_ITEM_CODE
      AND NVL(b.DATESET, DATE '1900-01-01') <= SYSDATE AND NVL(b.DATEEND, DATE '9999-12-31') >= TRUNC(SYSDATE)
      AND EXISTS (SELECT 1 FROM ID_ENG_BOM k WHERE k.ITEM_CODE = v_product AND k.PARENT_ITEM_CODE = b.CHILD_ITEM_CODE
                                             AND k.ORGANIZATION_ID = 1 AND k.CHILD_ITEM_CODE <> k.PARENT_ITEM_CODE);
   RETURN v_item;
END F_GET_ASSY_SEMI_ITEM;
/
