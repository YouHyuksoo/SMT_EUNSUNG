CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_MAT_FREE_ISSUE_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IM_ITEM_FREE_ISSUE 테이블의 INSERT 이벤트 발생 시 원본 트리거 로직에 정의된 후속 처리를 자동 수행한다.
   *   업무 데이터의 기본값 설정, 검증, 이력 기록 또는 연계 테이블 갱신에 사용된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IM_ITEM_FREE_ISSUE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.SUPPLIER_CODE - 신규/변경 후 공급사 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.MATERIAL_MFS - 신규/변경 후 자재 관련 값
   *   :NEW.LINE_TYPE - 신규/변경 후 라인 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.ISSUE_PRICE - 신규/변경 후 출고 / 단가 관련 값
   *   :NEW.ISSUE_QTY - 신규/변경 후 출고 / 수량 관련 값
   *   :NEW.ISSUE_AMT - 신규/변경 후 출고 관련 값
   *   :NEW.ENTER_BY - 신규/변경 후 값 값
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_FREE_ISSUE - 품목 / 출고 관련 트리거 대상 테이블
   *   IM_ITEM_FREE_INVENTORY - 품목 / 재고 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_MAT_FREE_ISSUE_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_MAT_FREE_ISSUE_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_MAT_FREE_ISSUE_INS" 
 AFTER
  INSERT
 ON im_item_free_issue
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER := 0;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM im_item_free_inventory
       WHERE supplier_code = :NEW.supplier_code
         AND item_code = :NEW.item_code
         AND material_mfs = :NEW.material_mfs
         AND line_type = :NEW.line_type
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      INSERT INTO im_item_free_inventory
                  (supplier_code,
                   item_code,
                   material_mfs,
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
                   :NEW.material_mfs,
                   :NEW.organization_id,
                   :NEW.line_type,
                   :NEW.issue_price,
                   :NEW.issue_qty * -1,
                   :NEW.issue_amt * -1,
                   NULL,
                   TRUNC (SYSDATE),
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by
                  );
   ELSE
      UPDATE im_item_free_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             - :NEW.issue_qty,
             inventory_amt =   NVL (inventory_amt, 0)
                             - :NEW.issue_amt
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND material_mfs = :NEW.material_mfs
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;

      UPDATE im_item_free_inventory
         SET inventory_price =
                   DECODE (inventory_qty, 0, 0, inventory_amt / inventory_qty)
       WHERE item_code = :NEW.item_code
         AND line_type = :NEW.line_type
         AND material_mfs = :NEW.material_mfs
         AND supplier_code = :NEW.supplier_code
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
