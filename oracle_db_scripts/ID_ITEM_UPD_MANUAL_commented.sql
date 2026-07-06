CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : ID_ITEM_UPD_MANUAL
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
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.LINE_TYPE - 변경/삭제 전 라인 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   ID_ITEM - 품목 관련 트리거 대상 테이블
   *   IM_ITEM_INVENTORY - 품목 / 재고 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_RECEIPT - 품목 / 입고 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_ISSUE - 품목 / 출고 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 8회, ELSIF 2회 / 반복문: 0회
   *   DML: SELECT 3회, INSERT 1회, UPDATE 9회, DELETE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'ID_ITEM_UPD_MANUAL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'ID_ITEM_UPD_MANUAL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."ID_ITEM_UPD_MANUAL" 
 BEFORE
   UPDATE OF route_no
 ON id_item
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count   NUMBER;
   phase       VARCHAR2 (10);
BEGIN
   
 --  IF 1 = 2
--   THEN
   phase := '10';

   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM im_item_inventory
       WHERE item_code = :OLD.item_code
         AND line_type = :OLD.line_type
         AND organization_id = :OLD.organization_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvi_count := 0;
   END;

   phase := '20';

   IF lvi_count > 0
   THEN
      DELETE FROM im_item_inventory
            WHERE item_code = :OLD.item_code
              AND line_type <> :OLD.line_type
              AND organization_id = :OLD.organization_id;

      phase := '30';

      UPDATE im_item_receipt
         SET line_type = :OLD.line_type
       WHERE item_code = :OLD.item_code
         AND line_type <> :OLD.line_type
         AND organization_id = :OLD.organization_id;

      phase := '40';

      UPDATE im_item_issue
         SET line_type = :OLD.line_type
       WHERE item_code = :OLD.item_code
         AND line_type <> :OLD.line_type
         AND organization_id = :OLD.organization_id;
   ELSE
      lvi_count := 0;
      phase := '50';

      BEGIN
         SELECT COUNT (*)
           INTO lvi_count
           FROM im_item_inventory
          WHERE item_code = :OLD.item_code
            AND line_type <> :OLD.line_type
            AND organization_id = :OLD.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_count := 0;
      END;

      phase := '60';

      IF lvi_count = 0
      THEN
         NULL;
      ELSIF lvi_count = 1
      THEN
         UPDATE im_item_inventory
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '70';

         UPDATE im_item_receipt
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '80';

         UPDATE im_item_issue
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;
      ELSIF lvi_count > 1
      THEN
         phase := '90';

         DELETE FROM im_item_inventory a
               WHERE a.item_code = :OLD.item_code
                 AND a.ROWID <> (SELECT MAX (ROWID)
                                   FROM im_item_inventory b
                                  WHERE b.item_code = :OLD.item_code
                                    AND a.item_code = b.item_code
                                    AND a.organization_id = b.organization_id);

         phase := '100';

         UPDATE im_item_inventory
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '110';

         UPDATE im_item_receipt
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;

         phase := '120';

         UPDATE im_item_issue
            SET line_type = :OLD.line_type
          WHERE item_code = :OLD.item_code
            AND organization_id = :OLD.organization_id;
      END IF;
   END IF;
  /*     IF :NEW.set_item_yn = 'Y'
       THEN
          INSERT INTO is_product_sale_price
                      (customer_code,
                       item_code,
                       product_line_type,
                       dateset,
                       organization_id,
                       confirm_date,
                       price_type,
                       price_change_reason,
                       product_sale_price,
                       confirm_by,
                       sale_currency,
                       dateend,
                       price_change_confirm_yn,
                       enter_by,
                       enter_date,
                       last_modify_date,
                       last_modify_by
                      )
               VALUES (NVL(:OLD.customer_code, '*'), --CUSTOMER_CODE,
                       :OLD.item_code,
                       :OLD.line_type,
                       :OLD.dateset,
                       :OLD.organization_id,
                       NULL, --CONFIRM_DATE,
                       'T', --PRICE_TYPE,
                       'N', --PRICE_CHANGE_REASON,
                       0, --PRODUCT_SALE_PRICE,
                       '', --CONFIRM_BY,
                       'CNY', --SALE_CURRENCY,
                       :OLD.dateend,
                       'N', --PRICE_CHANGE_CONFIRM_YN,
                       :OLD.enter_by,
                       :OLD.enter_date,
                       :OLD.last_modify_date,
                       :OLD.last_modify_by
                      );
       END IF;*/
--  END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003,    'phase='
                                       || phase
                                       || ' '
                                       || SQLERRM);
END;
