CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_ID_ITEM_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   ID_ITEM 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   ID_ITEM - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.ITEM_DIVISION - 신규/변경 후 품목 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :NEW.DATESET - 신규/변경 후 값 값
   *   :NEW.DATEEND - 신규/변경 후 값 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.ENTER_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_DATE - 신규/변경 후 일자 관련 값
   *   :NEW.BUY_PRICE - 신규/변경 후 단가 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 트리거 대상 테이블
   *   IM_ITEM_MASTER - 품목 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_UNIT_PRICE - 품목 / 단가 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_LOCAL_CURRENCY - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 16회, ELSIF 2회 / 반복문: 0회
   *   DML: SELECT 3회, INSERT 12회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_ID_ITEM_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_ID_ITEM_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_ID_ITEM_INS"
 AFTER
  INSERT
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
BEGIN
   
-----------------------------------------------------
--
--  Check System Condition
--
-----------------------------------------------------
   IF      :NEW.item_division = 'F'
       AND :NEW.line_code IS NULL
   THEN
      raise_application_error (-20003,    'Line Code Invalid'
                                       || SQLERRM);
   END IF;

   IF :NEW.line_type = 'N'
   THEN
      NULL;
   ELSE
      
------------------------------------------------------
-- New Material Insert
------------------------------------------------------
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_master
       WHERE item_code = :NEW.item_code
         AND organization_id = :NEW.organization_id;

      IF lvi_count > 0
      THEN
         NULL;
      ELSE
         IF :NEW.line_type = 'T'
         THEN
            NULL;
         ELSE
            INSERT INTO im_item_master
                        (supplier_code,
                         item_code,
                         dateset,
                         organization_id,
                         order_type,
                         order_rate,
                         order_leadtime,
                         order_bad_rate,
                         mim_order_qty,
                         packing_qty,
                         longterm_delivery_yn,
                         warehouse_charge,
                         order_charge,
                         dateend,
                         main_vendor_yn,
                         payment_type,
                         inspect_method,
                         inspect_rule,
                         incidental_expense_code,
                         enter_by,
                         enter_date,
                         last_modify_by,
                         last_modify_date
                        )
                 VALUES (NVL (:NEW.supplier_code, '*'), --SUPPLIER_CODE,
                         :NEW.item_code,
                         :NEW.dateset,
                         :NEW.organization_id,
                         'A', --ORDER_TYPE,
                         100, --ORDER_RATE,
                         0, --ORDER_LEADTIME,
                         0, --ORDER_BAD_RATE,
                         0, --MIM_ORDER_QTY,
                         0, --PACKING_QTY,
                         'N', --LONGTERM_DELIVERY_YN,
                         '*', --WAREHOUSE_CHARGE,
                         '*', --ORDER_CHARGE,
                         :NEW.dateend,
                         'Y', --MAIN_VENDOR_YN,
                         '*', --PAYMENT_TYPE,
                         'S', --INSPECT_METHOD,
                         'I', --INSPECT_RULE,
                         '*', --INCIDENTAL_EXPENSE_CODE,
                         :NEW.enter_by,
                         :NEW.enter_date,
                         :NEW.last_modify_by,
                         :NEW.last_modify_date
                        );
         END IF;
      END IF;

      IF :NEW.line_type = 'T'
      THEN
         NULL;
      ELSE
         
------------------------------------------------------
-- New Material Buy Price Insert
------------------------------------------------------
  --       SELECT COUNT (*)
 --         INTO lvi_count
  --        FROM im_item_unit_price
  --        WHERE item_code = :NEW.item_code
  --         AND line_type = :NEW.line_type
   --         AND organization_id = :NEW.organization_id;


      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_unit_price
       WHERE item_code = :NEW.item_code
         AND supplier_code = NVL (:NEW.supplier_code, '*')
         AND organization_id = :NEW.organization_id;
         
      IF ( lvi_count = 0 ) THEN
         
         
         INSERT INTO im_item_unit_price
                     (dateset,
                      item_code,
                      supplier_code,
                      line_type,
                      organization_id,
                      delivery,
                      currency,
                      unit_price,
                      tax_rate,
                      price_type,
                      approval_no,
                      standard_unit_price,
                      dateend,
                      price_change_reason,
                      confirm_by,
                      price_change_confirm_yn,
                      confirm_date,
                      enter_date,
                      enter_by,
                      last_modify_date,
                      last_modify_by
                     )
              VALUES (:NEW.dateset,
                      :NEW.item_code,
                      NVL (:NEW.supplier_code, '*'), --SUPPLIER_CODE,
                      :NEW.line_type,
                      :NEW.organization_id,
                      '2', --DELIVERY, ( 1 EXPORT ,2 DOMESTIC )
                      f_get_local_currency (:NEW.organization_id), --CURRENCY,
                      NVL (:NEW.buy_price, 0), --UNIT_PRICE,
                      0, --TAX_RATE,
                      'T', --PRICE_TYPE,
                      '', --APPROVAL_NO,
                      NVL (:NEW.buy_price, 0), --STANDARD_UNIT_PRICE,
                      :NEW.dateend,
                      'N', --PRICE_CHANGE_REASON,
                      '', --CONFIRM_BY,
                      'N', --PRICE_CHANGE_CONFIRM_YN,
                      NULL, --CONFIRM_DATE,
                      :NEW.enter_date,
                      :NEW.enter_by,
                      :NEW.last_modify_date,
                      :NEW.last_modify_by
                     );
                     
      END IF;
                     
                     
      END IF;

--      IF :NEW.svc_code = 'Y'
--      THEN
--         INSERT INTO is_svc_sale_price
--                     (dateset,
--                      item_code,
--                      customer_code,
--                      line_type,
--                      organization_id,
--                      delivery,
--                      sale_currency,
--                      sale_price,
--                      price_type,
--                      approval_no,
--                      standard_sale_price,
--                      dateend,
--                      price_change_reason,
--                      confirm_by,
--                      price_change_confirm_yn,
--                      confirm_date,
--                      enter_date,
--                      enter_by,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (:NEW.dateset,
--                      :NEW.item_code,
--                      NVL (:NEW.supplier_code, '*'), --SUPPLIER_CODE,
--                      :NEW.line_type,
--                      :NEW.organization_id,
--                      '2', --DELIVERY, ( 1 EXPORT ,2 DOMESTIC )
--                      f_get_local_currency (:NEW.organization_id), --CURRENCY,
--                      0, --UNIT_PRICE,
--                      'T', --PRICE_TYPE,
--                      '', --APPROVAL_NO,
--                      0, --STANDARD_UNIT_PRICE,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_REASON,
--                      '', --CONFIRM_BY,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      NULL, --CONFIRM_DATE,
--                      :NEW.enter_date,
--                      :NEW.enter_by,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--      END IF;

      
-- ------------------------------------------------------
---- New Product Sale Price Insert
--------------------------------------------------------
--      IF :NEW.item_division = 'F'
--      THEN
--         INSERT INTO is_product_sale_price
--                     (customer_code,
--                      item_code,
--                      product_line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_sale_price,
--                      confirm_by,
--                      sale_currency,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by,
--                      standard_sale_price
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      NVL (:NEW.sale_price, 0),
--                      
----* (1 - (f_get_volume_dc_rate(:new.customer_code , :new.organization_id)/100) ), --PRODUCT_SALE_PRICE,
--                      '', --CONFIRM_BY,
--                      f_get_local_currency (:NEW.organization_id),
--                      --SALE_CURRENCY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by,
--                      NVL (:NEW.sale_price, 0)
--                     );
--      
-----------------------------------------------------------------
--      ELSIF :NEW.item_division = 'C'
--      THEN
--         INSERT INTO is_product_work_cost
--                     (customer_code,
--                      item_code,
--                      product_line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_work_cost,
--                      confirm_by,
--                      work_currency,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      0, --PRODUCT_SALE_PRICE,
--                      '', --CONFIRM_BY,
--                      f_get_local_currency (:NEW.organization_id),
--                      --SALE_CURRENCY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--      ELSIF :NEW.item_division = 'G' -- GOODS
--      THEN
--         INSERT INTO is_product_sale_price
--                     (customer_code,
--                      item_code,
--                      product_line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_sale_price,
--                      confirm_by,
--                      sale_currency,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by,
--                      standard_sale_price
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      NVL (:NEW.sale_price, 0),
--                      
----* (1 - (f_get_volume_dc_rate(:new.customer_code , :new.organization_id)/100) ), --PRODUCT_SALE_PRICE,
--                      '', --CONFIRM_BY,
--                      f_get_local_currency (:NEW.organization_id),
--                      --SALE_CURRENCY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by,
--                      NVL (:NEW.sale_price, 0)
--                     );
--
--         INSERT INTO is_material_sale_price
--                     (customer_code,
--                      item_code,
--                      line_type,
--                      dateset,
--                      organization_id,
--                      confirm_date,
--                      price_type,
--                      price_change_reason,
--                      product_sale_price,
--                      sale_currency,
--                      confirm_by,
--                      dateend,
--                      price_change_confirm_yn,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (NVL (:NEW.customer_code, '*'), --CUSTOMER_CODE,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      NULL, --CONFIRM_DATE,
--                      'T', --PRICE_TYPE,
--                      'N', --PRICE_CHANGE_REASON,
--                      NVL (:NEW.sale_price, 0), --PRODUCT_SALE_PRICE,
--                      f_get_local_currency (:NEW.organization_id),
--                      '', --CONFIRM_BY,
--                      :NEW.dateend,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--
--         
-----------------------------------------------------------------------------
--         INSERT INTO is_product_buy_price
--                     (supplier_code,
--                      item_code,
--                      line_type,
--                      dateset,
--                      organization_id,
--                      delivery,
--                      currency,
--                      unit_price,
--                      price_type,
--                      tax_rate,
--                      approval_no,
--                      standard_unit_price,
--                      dateend,
--                      confirm_date,
--                      price_change_reason,
--                      price_change_confirm_yn,
--                      confirm_by,
--                      enter_by,
--                      enter_date,
--                      last_modify_date,
--                      last_modify_by
--                     )
--              VALUES (:NEW.supplier_code,
--                      :NEW.item_code,
--                      :NEW.line_type,
--                      :NEW.dateset,
--                      :NEW.organization_id,
--                      '1', --DELIVERY,
--                      f_get_local_currency (:NEW.organization_id), --CURRENCY,
--                      NVL (:NEW.buy_price, 0), --PRICE,
--                      'T', --
--                      0, --TAX_RATE,
--                      '', --APPROVAL_NO,
--                      NVL (:NEW.buy_price, 0), --STANDARD_UNIT_PRICE,
--                      :NEW.dateend,
--                      NULL, --CONFIRM_DATE,
--                      'N', --PRICE_CHANGE_REASON,
--                      'N', --PRICE_CHANGE_CONFIRM_YN,
--                      NULL, --CONFIRM_BY,
--                      :NEW.enter_by,
--                      :NEW.enter_date,
--                      :NEW.last_modify_date,
--                      :NEW.last_modify_by
--                     );
--      
-----------------------------------------------------------------------------
--      END IF;
   END IF;
END;
