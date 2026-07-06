CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ID_ITEM_UPD
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_ITEM 테이블의 UPDATE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_ITEM - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.SUPPLIER_CODE - 변경/삭제 전 공급사 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 트리거 대상 테이블
   *   ID_ENG_BOM - BOM 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_MASTER - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_UNIT_PRICE - 품목 / 단가 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 6회, ELSIF 1회 / 반복문: 0회
   *   DML: UPDATE 10회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ID_ITEM_UPD';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ID_ITEM_UPD';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ID_ITEM_UPD" 
 BEFORE
   UPDATE OF supplier_code, line_type, customer_code
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   IF :NEW.line_type = 'M'
   THEN
      UPDATE id_eng_bom
         SET line_type = 'M'
       WHERE child_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;

      UPDATE id_eng_bom
         SET item_type = 'M'
       WHERE parent_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;
   ELSIF :NEW.line_type = 'T'
   THEN
      UPDATE id_eng_bom
         SET line_type = 'T'
       WHERE child_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;

      UPDATE id_eng_bom
         SET item_type = 'T'
       WHERE parent_item_code = :OLD.item_code
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;
   END IF;

   
-------------------------------------------------------
--
-------------------------------------------------------

   IF      :OLD.supplier_code = '*'
       AND :NEW.supplier_code <> '*'
   THEN
      UPDATE im_item_master
         SET supplier_code = :NEW.supplier_code
       WHERE item_code = :OLD.item_code
         AND supplier_code = '*'
         AND organization_id = :OLD.organization_id;

      UPDATE im_item_unit_price
         SET supplier_code = :NEW.supplier_code
       WHERE item_code = :OLD.item_code
         AND supplier_code = '*'
         AND dateset <= TRUNC (SYSDATE)
         AND dateend >= TRUNC (SYSDATE)
         AND organization_id = :OLD.organization_id;

--      UPDATE is_product_buy_price
--         SET supplier_code = :NEW.supplier_code
--       WHERE item_code = :OLD.item_code
--         AND supplier_code = '*'
--         AND organization_id = :OLD.organization_id;
   END IF;

   
-------------------------------------------------------
--
-------------------------------------------------------

--   IF      :OLD.customer_code = '*'
--       AND :NEW.customer_code <> '*'
--   THEN
--      UPDATE is_product_sale_price
--         SET customer_code = :NEW.customer_code
--       WHERE item_code = :OLD.item_code
--         AND customer_code = '*'
--         AND organization_id = :OLD.organization_id;
--
--      UPDATE is_material_sale_price
--         SET customer_code = :NEW.customer_code
--       WHERE item_code = :OLD.item_code
--         AND customer_code = '*'
--         AND organization_id = :OLD.organization_id;
--   END IF;
END;
