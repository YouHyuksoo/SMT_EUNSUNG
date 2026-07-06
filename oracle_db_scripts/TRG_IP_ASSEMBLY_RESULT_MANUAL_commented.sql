CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_ASSEMBLY_RESULT_MANUAL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_ASSEMBLY_RESULT 테이블의 UPDATE 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_ASSEMBLY_RESULT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.PLAN_DATE - 신규/변경 후 계획 / 일자 관련 값
   *   :NEW.PLAN_DATE_SEQUENCE - 신규/변경 후 계획 / 일자 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.PRODUCT_DATE - 신규/변경 후 제품 / 일자 관련 값
   *   :NEW.PRODUCT_SEQUENCE - 신규/변경 후 제품 관련 값
   *   :NEW.MFS - 신규/변경 후 값 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.PRODUCT_ACTUAL_QTY - 신규/변경 후 제품 / 수량 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_ASSEMBLY_RESULT - 실적 관련 트리거 대상 테이블
   *   IP_ASSEMBLY_MASTER_PLAN - 계획 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 호출 객체:
   *   PLAN_PROD_CHILD_ITEM_ISSUE - 트리거 내부 업무 처리 호출
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부/Oracle 표준 예외 처리를 따른다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_ASSEMBLY_RESULT_MANUAL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_ASSEMBLY_RESULT_MANUAL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_ASSEMBLY_RESULT_MANUAL" 
 BEFORE
   UPDATE OF product_sequence
 ON ip_assembly_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count             NUMBER;
   lvi_seq               NUMBER;
   lvi_return            NUMBER;
   lvs_line_code         VARCHAR2 (20);
   lvs_workstage_code    VARCHAR2 (20);
   lvs_machine_code      VARCHAR2 (30);
   lvs_deficit           VARCHAR2 (1);
   lvs_config_value      VARCHAR2 (1);
   dest_workstage_code   VARCHAR2 (10);
   from_workstage_code   VARCHAR2 (10);
   lvs_prie_type_value   VARCHAR2 (1);
   lvl_cntlq             NUMBER;
BEGIN
   IF 1 = 2
   THEN
      SELECT a.line_code, a.workstage_code, a.machine_code
        INTO lvs_line_code, lvs_workstage_code, lvs_machine_code
        FROM ip_assembly_master_plan a
       WHERE a.plan_date = :NEW.plan_date
         AND a.plan_date_sequence = :NEW.plan_date_sequence
         AND a.organization_id = :NEW.organization_id;
      
------------------------------------------------------------
-- Child ITem Issue
------------------------------------------------------------
      lvi_return :=
            pkg_planning.plan_prod_child_item_issue (
               :NEW.product_date /*IN DATE*/,
               :NEW.product_sequence /*IN NUMBER*/,
               :NEW.mfs /*IN VARCHAR2*/,
               :NEW.item_code /*IN VARCHAR2*/,
               lvs_line_code /*IN VARCHAR2*/,
               lvs_workstage_code /*IN VARCHAR2*/,
               lvs_machine_code /*IN VARCHAR2*/,
               :NEW.product_actual_qty /*IN NUMBER*/,
               'N' /*IN VARCHAR2*/,
               :NEW.organization_id                              /*IN NUMBER*/
            );

      IF lvi_return < 0
      THEN
         raise_application_error (-20003, SQLERRM);
      END IF;
   
/*      INSERT INTO im_item_workstage_receipt
                  (receipt_date,
                   receipt_sequence,
                   organization_id,
                   workstage_code,
                   from_workstage_code,
                   machine_code,
                   material_mfs,
                   mfs,
                   item_code,
                   item_type,
                   line_type,
                   line_code,
                   receipt_deficit,
                   receipt_price,
                   receipt_qty,
                   receipt_weight,
                   receipt_amt,
                   receipt_type,
                   receipt_account,
                   item_unit_weight,
                   issue_date,
                   issue_sequence,
                   work_order_no,
                   receipt_status,
                   transfer_date,
                   transfer_sequence,
                   transfer_type,
                   invoice_no,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (:OLD.product_date,
                   seq_workstage_receipt_seq.NEXTVAL,
                   :OLD.organization_id,
                   DECODE(
                      :OLD.trans_workstage_code, NULL, :OLD.workstage_code,
                      '*', :OLD.workstage_code, :OLD.workstage_code
                   ),
                   :OLD.workstage_code,
                   :OLD.machine_code,
                   :OLD.mfs,
                   :OLD.mfs,
                   :OLD.item_code,
                   'T', --:OLD.item_type,
                   :OLD.product_line_type,
                   :OLD.line_code,
                   1, --receipt_deficit
                   0, --:OLD.receipt_price,
                   :OLD.product_actual_qty,
                   :OLD.product_actual_qty, --RECEIPT_WEIGHT,
                   0, --:OLD.receipt_amt,
                   'N', --:OLD.receipt_type, --RECEIPT_TYPE,AUTO / NORMAL
                   'M001', --:OLD.receipt_account,
                   1, --ITEM_UNIT_WEIGHT,
                   NULL, --ISSUE_DATE,
                   NULL, --ISSUE_SEQUENCE,
                   '', --:OLD.work_order_no,
                   'N', --RECEIPT_STATUS,
                   :OLD.product_date, --transfer_date,
                   seq_workstage_receipt_seq.NEXTVAL, --TRANSFER_SEQUENCE,
                   'C', -- WORKSTAGE CONNECT
                   '', --:OLD.invoice_no,
                   SYSDATE,
                   :OLD.enter_by,
                   SYSDATE,
                   :OLD.last_modify_by
                  );

*/
   END IF;
END;
