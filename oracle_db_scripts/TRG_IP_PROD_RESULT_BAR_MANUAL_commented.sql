CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PROD_RESULT_BAR_MANUAL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RESULT_BARCODE 테이블의 UPDATE 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RESULT_BARCODE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LAST_MODIFY_BY - 신규/변경 후 값 값
   *   :OLD.PLAN_DATE - 변경/삭제 전 계획 / 일자 관련 값
   *   :OLD.PLAN_DATE_SEQUENCE - 변경/삭제 전 계획 / 일자 관련 값
   *   :OLD.LQC_INSPECT_RESULT - 변경/삭제 전 검사 / 실적 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.PRODUCT_DATE - 변경/삭제 전 제품 / 일자 관련 값
   *   :OLD.PRODUCT_SEQUENCE - 변경/삭제 전 제품 관련 값
   *   :OLD.PRODUCT_LINE_TYPE - 변경/삭제 전 제품 / 라인 관련 값
   *   :OLD.WORK_DIVISION - 변경/삭제 전 값 값
   *   :OLD.LQC_INSPECT_NO - 변경/삭제 전 검사 관련 값
   *   :OLD.OQC_INSPECT_NO - 변경/삭제 전 검사 관련 값
   *   :OLD.OQC_INSPECT_RESULT - 변경/삭제 전 검사 / 실적 관련 값
   *   :OLD.RECEIPT_DATE - 변경/삭제 전 입고 / 일자 관련 값
   *   :OLD.RECEIPT_SEQUENCE - 변경/삭제 전 입고 관련 값
   *   :OLD.PRODUCT_ACTUAL_STATUS - 변경/삭제 전 제품 / 상태 관련 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.RECEIPT_YN - 변경/삭제 전 입고 관련 값
   *   :OLD.MFS - 변경/삭제 전 값 값
   *   :OLD.PRODUCT_ACTUAL_QTY - 변경/삭제 전 제품 / 수량 관련 값
   *   :OLD.LINE_CODE - 변경/삭제 전 라인 관련 값
   *   :OLD.WORKSTAGE_CODE - 변경/삭제 전 공정 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RESULT_BARCODE - 제품 / 실적 / 바코드 관련 트리거 대상 테이블
   *   IP_PRODUCT_RESULT - 제품 / 실적 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 1회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PROD_RESULT_BAR_MANUAL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PROD_RESULT_BAR_MANUAL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PROD_RESULT_BAR_MANUAL" 
 BEFORE
   UPDATE OF last_modify_by
 ON ip_product_result_barcode
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_exists   NUMBER;
BEGIN
IF  :NEW.LAST_MODIFY_BY = 'ADMIN2' THEN
      BEGIN
         SELECT COUNT (*)
           INTO lvi_exists
           FROM ip_product_result
          WHERE plan_date = :OLD.plan_date
            AND plan_date_sequence = :OLD.plan_date_sequence
            AND nvl(lqc_inspect_result,'*') = nvl(:OLD.lqc_inspect_result,'*')
            AND organization_id = :OLD.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_exists := 0;
      END;

      IF lvi_exists = 0
      THEN
         INSERT INTO ip_product_result
                     (product_date,
                      product_sequence,
                      organization_id,
                      product_line_type,
                      lqc_inspect_result,
                      plan_date,
                      work_division,
                      lqc_inspect_no,
                      oqc_inspect_no,
                      oqc_inspect_result,
                      receipt_date,
                      receipt_sequence,
                      plan_date_sequence,
                      product_actual_status,
                      item_code,
                      receipt_yn,
                      mfs,
                      product_actual_qty,
                      line_code,
                      workstage_code,
                      machine_code,
                      enter_date,
                      enter_by,
                      last_modify_date,
                      last_modify_by,
                      lot_divide_yn,
                      sub_mfs,
                      invoice_no,
                      customer_order_no,
                      product_start_time,
                      product_end_time,
                      request_lqc_inspect,
                      customer_order_no_origin,
                      request_oqc_inspect,
                      trans_workstage_code,
                      product_price,
                      product_amt,
                      barcode,
                      mold_code,
                      mold_version,
                      mold_set_serial,
                      model_sn,
                      barcode_sn,
                      product_actual_time,
                      shift_code,
                      workstage_issue_yn
                     )
              VALUES (:OLD.product_date,
                      :OLD.product_sequence,
                      :OLD.organization_id,
                      :OLD.product_line_type,
                      :OLD.lqc_inspect_result,
                      :OLD.plan_date,
                      :OLD.work_division,
                      :OLD.lqc_inspect_no,
                      :OLD.oqc_inspect_no,
                      :OLD.oqc_inspect_result,
                      :OLD.receipt_date,
                      :OLD.receipt_sequence,
                      :OLD.plan_date_sequence,
                      :OLD.product_actual_status,
                      :OLD.item_code,
                      :OLD.receipt_yn,
                      :OLD.mfs,
                      :OLD.product_actual_qty,
                      :OLD.line_code,
                      :OLD.workstage_code,
                      :OLD.machine_code,
                      :OLD.enter_date,
                      :OLD.enter_by,
                      :OLD.last_modify_date,
                      :OLD.last_modify_by,
                      :OLD.lot_divide_yn,
                      :OLD.sub_mfs,
                      :OLD.invoice_no,
                      :OLD.customer_order_no,
                      :OLD.product_start_time,
                      :OLD.product_end_time,
                      :OLD.request_lqc_inspect,
                      :OLD.customer_order_no_origin,
                      :OLD.request_oqc_inspect,
                      :OLD.trans_workstage_code,
                      :OLD.product_price,
                      :OLD.product_amt,
                      :OLD.barcode,
                      :OLD.mold_code,
                      :OLD.mold_version,
                      :OLD.mold_set_serial,
                      :OLD.model_sn,
                      :OLD.barcode_sn,
                      :OLD.product_actual_time,
                      :OLD.shift_code,
                      :OLD.workstage_issue_yn
                     );
      ELSE
         UPDATE ip_product_result
            SET product_actual_qty =
                                  nvl(product_actual_qty,0)
                                + :OLD.product_actual_qty
          WHERE plan_date = :OLD.plan_date
            AND plan_date_sequence = :OLD.plan_date_sequence
            AND nvl(lqc_inspect_result,'*') = nvl(:OLD.lqc_inspect_result,'*')
            AND organization_id = :OLD.organization_id;
      END IF;
END IF ;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;
