CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IM_ITEM_SALE_RECEIPT_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_SALE_RECEIPT 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_SALE_RECEIPT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.RECEIPT_PRICE - 신규/변경 후 입고 / 단가 관련 값
   *   :NEW.RECEIPT_QTY - 신규/변경 후 입고 / 수량 관련 값
   *   :NEW.RECEIPT_AMT - 신규/변경 후 입고 관련 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :NEW.RECEIPT_DATE - 신규/변경 후 입고 / 일자 관련 값
   *   :NEW.RECEIPT_SEQUENCE - 신규/변경 후 입고 관련 값
   *   :NEW.MATERIAL_MFS - 신규/변경 후 자재 관련 값
   *   :NEW.LOCATION_CODE - 신규/변경 후 값 값
   *   :NEW.RECEIPT_DEFICIT - 신규/변경 후 입고 관련 값
   *   :NEW.RECEIPT_STATUS - 신규/변경 후 입고 / 상태 관련 값
   *   :NEW.INVOICE_NO - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_SALE_RECEIPT - 품목 / 입고 관련 트리거 대상 테이블
   *   IM_ITEM_SALE_INVENTORY - 품목 / 재고 관련 트리거 내부 SQL에서 참조/변경
   *   IM_ITEM_ISSUE - 품목 / 출고 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_GET_MAT_ISSUE_PRICE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 3회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IM_ITEM_SALE_RECEIPT_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IM_ITEM_SALE_RECEIPT_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IM_ITEM_SALE_RECEIPT_INS" 
 BEFORE
  INSERT
 ON im_item_sale_receipt
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_sale_inventory
       WHERE supplier_code = :NEW.supplier_code
         AND item_code = :NEW.item_code
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      INSERT INTO im_item_sale_inventory
                  (supplier_code,
                   item_code,
                   organization_id,
                   line_type,
                   inventory_price,
                   inventory_qty,
                   inventory_amt,
                   last_receipt_date,
                   last_issue_date,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (:NEW.supplier_code,
                   :NEW.item_code,
                   :NEW.organization_id,
                   :NEW.line_type,
                   :NEW.receipt_price,
                   :NEW.receipt_qty,
                   :NEW.receipt_amt,
                   TRUNC (SYSDATE),
                   NULL,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSE
      UPDATE im_item_sale_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             + :NEW.receipt_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             + :NEW.receipt_amt
       WHERE item_code = :NEW.item_code
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_sale_inventory
         SET inventory_price = DECODE (
                                  inventory_qty,
                                  0, 0,
                                  NVL (inventory_amt, 0) / inventory_qty
                               )
       WHERE item_code = :NEW.item_code
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;
   END IF;

   INSERT INTO im_item_issue
               (issue_date,
                issue_sequence,
                organization_id,
                mfs,
                material_mfs,
                item_code,
                location_code,
                item_type,
                line_code,
                workstage_code,
                issue_deficit,
                issue_qty,
                issue_status,
                issue_price,
                issue_amt,
                issue_account,
                line_type,
                comments,
                sale_amt,
                sale_price,
                invoice_no,
                issue_type,
                supplier_code,
                work_order_no,
                interface_yn,
                enter_date,
                enter_by,
                last_modify_date,
                last_modify_by
               )
        VALUES (:NEW.receipt_date,
                :NEW.receipt_sequence,
                :NEW.organization_id,
                '*', --MFS,
                :NEW.material_mfs,
                :NEW.item_code,
                :NEW.LOCATION_CODE, --LOCATION_CODE,
                'S', --ITEM_TYPE,
                'SALE', --:NEW.LINE_CODE,
                '*', --WORKSTAGE_CODE,
                DECODE (:NEW.receipt_deficit, '1', '3', '4'), --ISSUE_DEFICIT,
                :NEW.receipt_qty, --ISSUE_QTY,
                :NEW.receipt_status, --ISSUE_STATUS,
                f_get_mat_issue_price (
                   :NEW.material_mfs,
                   :NEW.item_code,
                   :NEW.line_type,
                   :NEW.organization_id
                ),
                  f_get_mat_issue_price (
                   :NEW.material_mfs,
                   :NEW.item_code,
                   :NEW.line_type,
                   :NEW.organization_id
                )
                * :NEW.receipt_qty,
                'M004', --ISSUE_ACCOUNT,
                :NEW.line_type,
                '*', --COMMENTS,
                :NEW.receipt_price, --SALE_PRICE,
                :NEW.receipt_amt, --SALE_AMT,
                :NEW.invoice_no,
                'N', --ISSUE_TYPE,
                :NEW.supplier_code,
                '*', --WORK_ORDER_NO,
                'N',
                SYSDATE, --ENTER_DATE,
                :NEW.enter_by,
                SYSDATE,
                :NEW.last_modify_by
               );
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
