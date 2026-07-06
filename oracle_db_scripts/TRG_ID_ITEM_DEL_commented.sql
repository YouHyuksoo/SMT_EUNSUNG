CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ID_ITEM_DEL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_ITEM 테이블의 DELETE 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: DELETE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_ITEM - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.DATESET - 변경/삭제 전 값 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.ITEM_CLASS - 변경/삭제 전 품목 관련 값
   *   :OLD.ITEM_SPEC - 변경/삭제 전 품목 관련 값
   *   :OLD.ITEM_UOM - 변경/삭제 전 품목 관련 값
   *   :OLD.ITEM_TYPE - 변경/삭제 전 품목 관련 값
   *   :OLD.VIRTUAL_RECEIPT_YN - 변경/삭제 전 입고 관련 값
   *   :OLD.ITEM_NAME - 변경/삭제 전 품목 / 명칭 관련 값
   *   :OLD.LINE_TYPE - 변경/삭제 전 라인 관련 값
   *   :OLD.ROUTE_NO - 변경/삭제 전 값 값
   *   :OLD.BARCODE - 변경/삭제 전 바코드 관련 값
   *   :OLD.ABC_GRADE - 변경/삭제 전 값 값
   *   :OLD.RAW_MATERIAL - 변경/삭제 전 자재 관련 값
   *   :OLD.SAFETY_INVENTORY - 변경/삭제 전 재고 관련 값
   *   :OLD.WORK_BAD_RATE - 변경/삭제 전 율 관련 값
   *   :OLD.TRANSFER_UOM - 변경/삭제 전 값 값
   *   :OLD.MANUFACTURE_LEADTIME - 변경/삭제 전 값 값
   *   :OLD.ORDER_CYCLE - 변경/삭제 전 값 값
   *   :OLD.ORDER_RULE - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 트리거 대상 테이블
   *   IM_ITEM_MASTER - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_UNIT_PRICE - 품목 / 단가 관련 트리거 내부 SQL에서 참조/변경
   *   ID_ITEM_HISTORY - 품목 / 이력 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: INSERT 1회, DELETE 11회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ID_ITEM_DEL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ID_ITEM_DEL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ID_ITEM_DEL" 
 AFTER
  DELETE
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
   INSERT INTO id_item_history
               (item_code,
                dateset,
                organization_id,
                item_class,
                item_spec,
                item_uom,
                item_type,
                virtual_receipt_yn,
                item_name,
                line_type,
                route_no,
                barcode,
                abc_grade,
                raw_material,
                safety_inventory,
                work_bad_rate,
                transfer_uom,
                manufacture_leadtime,
                order_cycle,
                order_rule,
                svc_code,
                capacity,
                LENGTH,
                dateend,
                set_item_yn,
                special_property,
                layer,
                part_no,
                height,
                weight,
                drawing_no,
                gradient,
                density,
                item_division,
                issue_packing_qty,
                inner_diameter,
                outer_diameter,
                width,
                hs_code,
                hs_name,
                hs_spec,
                hs_code_scrap,
                hs_name_scrap,
                hs_spec_scrap,
                enter_by,
                enter_date,
                last_modify_by,
                last_modify_date,
                transfer_yn,
                line_code,
                tariff_rate,
                supplier_code,
                customer_code,
                model_name,
                model_suffix
               )
        VALUES (:OLD.item_code,
                :OLD.dateset,
                :OLD.organization_id,
                :OLD.item_class,
                :OLD.item_spec,
                :OLD.item_uom,
                :OLD.item_type,
                :OLD.virtual_receipt_yn,
                :OLD.item_name,
                :OLD.line_type,
                :OLD.route_no,
                :OLD.barcode,
                :OLD.abc_grade,
                :OLD.raw_material,
                :OLD.safety_inventory,
                :OLD.work_bad_rate,
                :OLD.transfer_uom,
                :OLD.manufacture_leadtime,
                :OLD.order_cycle,
                :OLD.order_rule,
                :OLD.svc_code,
                :OLD.capacity,
                :OLD.LENGTH,
                :OLD.dateend,
                :OLD.set_item_yn,
                :OLD.special_property,
                :OLD.layer,
                :OLD.part_no,
                :OLD.height,
                :OLD.weight,
                :OLD.drawing_no,
                :OLD.gradient,
                :OLD.density,
                :OLD.item_division,
                :OLD.issue_packing_qty,
                :OLD.inner_diameter,
                :OLD.outer_diameter,
                :OLD.width,
                :OLD.hs_code,
                :OLD.hs_name,
                :OLD.hs_spec,
                :OLD.hs_code_scrap,
                :OLD.hs_name_scrap,
                :OLD.hs_spec_scrap,
                :OLD.enter_by,
                :OLD.enter_date,
                :OLD.last_modify_by,
                :OLD.last_modify_date,
                :OLD.transfer_yn,
                :OLD.line_code,
                :OLD.tariff_rate,
                :OLD.supplier_code,
                :OLD.customer_code,
                :OLD.model_name,
                :OLD.model_suffix
               );

   
--------------------------------------------------
-- ITEM MASTER DELETE
--------------------------------------------------
   DELETE FROM im_item_master
         WHERE supplier_code = '*'
           AND item_code = :OLD.item_code
           AND organization_id = :OLD.organization_id;

   
--------------------------------------------------
-- BUY PRICE DELETE
--------------------------------------------------

   DELETE FROM im_item_unit_price
         WHERE supplier_code = '*'
           AND item_code = :OLD.item_code
           AND organization_id = :OLD.organization_id;

   
----------------------------------------------------
---- SALE PRICE DELETE
----------------------------------------------------
--
--   DELETE FROM is_product_sale_price
--         WHERE customer_code = '*'
--           AND item_code = :OLD.item_code
--           AND organization_id = :OLD.organization_id;
--
--   
----------------------------------------------------
---- SALE PRICE DELETE
----------------------------------------------------
--
--   DELETE FROM is_product_work_cost
--         WHERE customer_code = '*'
--           AND item_code = :OLD.item_code
--           AND organization_id = :OLD.organization_id;
--
--   
----------------------------------------------------
---- svc SALE PRICE DELETE
----------------------------------------------------
--
--   DELETE FROM is_svc_sale_price
--         WHERE customer_code = '*'
--           AND item_code = :OLD.item_code
--           AND organization_id = :OLD.organization_id;
END;
