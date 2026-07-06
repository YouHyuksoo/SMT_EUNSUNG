CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PROD_RESULT_BARCODE_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RESULT_BARCODE 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RESULT_BARCODE - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.PLAN_DATE - 신규/변경 후 계획 / 일자 관련 값
   *   :NEW.PLAN_DATE_SEQUENCE - 신규/변경 후 계획 / 일자 관련 값
   *   :NEW.LQC_INSPECT_RESULT - 신규/변경 후 검사 / 실적 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.PRODUCT_DATE - 신규/변경 후 제품 / 일자 관련 값
   *   :NEW.PRODUCT_SEQUENCE - 신규/변경 후 제품 관련 값
   *   :NEW.PRODUCT_LINE_TYPE - 신규/변경 후 제품 / 라인 관련 값
   *   :NEW.WORK_DIVISION - 신규/변경 후 값 값
   *   :NEW.LQC_INSPECT_NO - 신규/변경 후 검사 관련 값
   *   :NEW.OQC_INSPECT_NO - 신규/변경 후 검사 관련 값
   *   :NEW.OQC_INSPECT_RESULT - 신규/변경 후 검사 / 실적 관련 값
   *   :NEW.RECEIPT_DATE - 신규/변경 후 입고 / 일자 관련 값
   *   :NEW.RECEIPT_SEQUENCE - 신규/변경 후 입고 관련 값
   *   :NEW.PRODUCT_ACTUAL_STATUS - 신규/변경 후 제품 / 상태 관련 값
   *   :NEW.ITEM_CODE - 신규/변경 후 품목 관련 값
   *   :NEW.RECEIPT_YN - 신규/변경 후 입고 관련 값
   *   :NEW.MFS - 신규/변경 후 값 값
   *   :NEW.PRODUCT_ACTUAL_QTY - 신규/변경 후 제품 / 수량 관련 값
   *   :NEW.LINE_CODE - 신규/변경 후 라인 관련 값
   *   :NEW.WORKSTAGE_CODE - 신규/변경 후 공정 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RESULT_BARCODE - 제품 / 실적 / 바코드 관련 트리거 대상 테이블
   *   IP_PRODUCT_RESULT - 제품 / 실적 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: SELECT 1회, INSERT 2회, UPDATE 1회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PROD_RESULT_BARCODE_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PROD_RESULT_BARCODE_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PROD_RESULT_BARCODE_INS" 
 BEFORE
  INSERT
 ON ip_product_result_barcode
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_exists   NUMBER;
BEGIN

      BEGIN
         SELECT COUNT (*)
           INTO lvi_exists
           FROM ip_product_result
          WHERE plan_date = :NEW.plan_date
            AND plan_date_sequence = :NEW.plan_date_sequence
            AND nvl(lqc_inspect_result,'*') = nvl(:NEW.lqc_inspect_result,'*')
            AND organization_id = :NEW.organization_id;
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
              VALUES (:NEW.product_date,
                      :NEW.product_sequence,
                      :NEW.organization_id,
                      :NEW.product_line_type,
                      :NEW.lqc_inspect_result,
                      :NEW.plan_date,
                      :NEW.work_division,
                      :NEW.lqc_inspect_no,
                      :NEW.oqc_inspect_no,
                      :NEW.oqc_inspect_result,
                      :NEW.receipt_date,
                      :NEW.receipt_sequence,
                      :NEW.plan_date_sequence,
                      :NEW.product_actual_status,
                      :NEW.item_code,
                      :NEW.receipt_yn,
                      :NEW.mfs,
                      :NEW.product_actual_qty,
                      :NEW.line_code,
                      :NEW.workstage_code,
                      :NEW.machine_code,
                      :NEW.enter_date,
                      :NEW.enter_by,
                      :NEW.last_modify_date,
                      :NEW.last_modify_by,
                      :NEW.lot_divide_yn,
                      :NEW.sub_mfs,
                      :NEW.invoice_no,
                      :NEW.customer_order_no,
                      :NEW.product_start_time,
                      :NEW.product_end_time,
                      :NEW.request_lqc_inspect,
                      :NEW.customer_order_no_origin,
                      :NEW.request_oqc_inspect,
                      :NEW.trans_workstage_code,
                      :NEW.product_price,
                      :NEW.product_amt,
                      :NEW.barcode,
                      :NEW.mold_code,
                      :NEW.mold_version,
                      :NEW.mold_set_serial,
                      :NEW.model_sn,
                      :NEW.barcode_sn,
                      :NEW.product_actual_time,
                      :NEW.shift_code,
                      :NEW.workstage_issue_yn
                     );
      ELSE
         UPDATE ip_product_result
            SET product_actual_qty =
                                  nvl(product_actual_qty,0)
                                + :NEW.product_actual_qty
          WHERE plan_date = :NEW.plan_date
            AND plan_date_sequence = :NEW.plan_date_sequence
            AND nvl(lqc_inspect_result,'*') = nvl(:NEW.lqc_inspect_result,'*')
            AND organization_id = :NEW.organization_id;
      END IF;

EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20004,'IP_PRODUCT_RESULT_BARCODE=>'|| SQLERRM);
END;
