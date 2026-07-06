CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_IP_PROD_REWORK_RESULT_INS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_REWORK_RESULT 테이블의 INSERT 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: BEFORE
   *   이벤트: INSERT
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_REWORK_RESULT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :NEW.LOT_DIVIDE_YN - 신규/변경 후 LOT 관련 값
   *   :NEW.PRODUCT_ACTUAL_QTY - 신규/변경 후 제품 / 수량 관련 값
   *   :NEW.PLAN_DATE - 신규/변경 후 계획 / 일자 관련 값
   *   :NEW.PLAN_DATE_SEQUENCE - 신규/변경 후 계획 / 일자 관련 값
   *   :NEW.ORGANIZATION_ID - 신규/변경 후 값 값
   *   :NEW.MACHINE_CODE - 신규/변경 후 설비 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_REWORK_RESULT - 제품 / 실적 관련 트리거 대상 테이블
   *   IP_PRODUCT_REWORK_PLAN - 제품 / 계획 관련 트리거 내부 SQL에서 참조/변경
   *   IMCN_MACHINE - 설비 관련 트리거 내부 SQL에서 참조/변경
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 트리거 내부 오류를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 8회 / 반복문: 0회
   *   DML: SELECT 2회, INSERT 2회, UPDATE 2회
   * ================================================================
   * 검증 방법:
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_IP_PROD_REWORK_RESULT_INS';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_IP_PROD_REWORK_RESULT_INS';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_IP_PROD_REWORK_RESULT_INS" 
 BEFORE
  INSERT
 ON ip_product_rework_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count            NUMBER;
   lvi_seq              NUMBER;
   lvi_return           NUMBER;
   lvs_line_code        VARCHAR2 (20);
   lvs_workstage_code   VARCHAR2 (20);
   lvs_machine_code     VARCHAR2 (20);
   lvs_deficit          VARCHAR2 (1);
   lvs_config_value     VARCHAR2 (1);
BEGIN
   IF :NEW.lot_divide_yn = 'Y'
   THEN
      NULL;
   ELSE
      --  raise_application_error( -20003 , :NEW.product_actual_qty ) ;

      UPDATE ip_product_rework_plan a
         SET a.product_actual_qty =   NVL (a.product_actual_qty, 0)
                                    + NVL (:NEW.product_actual_qty, 0),
             a.plan_status = DECODE (
                                a.order_qty,
                                  NVL (a.product_actual_qty, 0)
                                + NVL (:NEW.product_actual_qty, 0), 'C',
                                'P'
                             )
       WHERE a.plan_date = :NEW.plan_date
         AND a.plan_date_sequence = :NEW.plan_date_sequence
         AND a.organization_id = :NEW.organization_id;

      
--------------------------------------------------------
--
--------------------------------------------------------

      UPDATE imcn_machine
         SET reserved_capacity =
                  NVL (reserved_capacity, 0)
                - NVL (:NEW.product_actual_qty, 0)
       WHERE machine_code = :NEW.machine_code
         AND organization_id = :NEW.organization_id;
   
-------------------------------------------------------
-- Workstage Inventory
-------------------------------------------------------

   /*     IF :NEW.product_actual_qty < 0
        THEN
           lvs_deficit := 2;
        ELSE
           lvs_deficit := 1;
        END IF;

        INSERT INTO im_item_workstage_receipt
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
                     from_line_code,
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
             VALUES (:NEW.product_date,
                     seq_workstage_receipt_seq.NEXTVAL,
                     :NEW.organization_id,
                     :NEW.workstage_code, --Parent Item Workstage
                     :NEW.workstage_code,
                     :NEW.machine_code,
                     :NEW.mfs,
                     :NEW.mfs,
                     :NEW.item_code,
                     'T', --:NEW.item_type,
                     :NEW.product_line_type,
                     :NEW.line_code,
                     :NEW.line_code,
                     lvs_deficit, --receipt_deficit
                     0, --:NEW.receipt_price,
                     :NEW.product_actual_qty,
                     :NEW.product_actual_qty, --RECEIPT_WEIGHT,
                     0, --:NEW.receipt_amt,
                     'N', --:NEW.receipt_type, --RECEIPT_TYPE,AUTO / NORMAL
                     'M001', --:NEW.receipt_account,
                     1, --ITEM_UNIT_WEIGHT,
                     NULL, --ISSUE_DATE,
                     NULL, --ISSUE_SEQUENCE,
                     '', --:NEW.work_order_no,
                     'N', --RECEIPT_STATUS,
                     :NEW.product_date, --transfer_date,
                     seq_workstage_receipt_seq.NEXTVAL, --TRANSFER_SEQUENCE,
                     'C',
                     '', --:NEW.invoice_no,
                     SYSDATE,
                     :NEW.enter_by,
                     SYSDATE,
                     :NEW.last_modify_by
                    );


  ------------------------------------------------------------
  -- Child Item Auto Issue
  ------------------------------------------------------------
  ------------------------------------
  -- SYSTEM CONFIG VALUE GET
  -- CURRENT VALUE = Y
  ------------------------------------
        BEGIN
           SELECT NVL(config_value, 'N')
           INTO   lvs_config_value
           FROM   isys_config
           WHERE      config_name = 'PRODUCT_WORKSTAGE_ISSUE_YN'
                  AND use_yn = 'Y'
                  AND organization_id = :NEW.organization_id;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              lvs_config_value := 'N';
           WHEN OTHERS
           THEN
              raise_application_error(-20003, SQLERRM);
        END;

        IF lvs_config_value = 'N'
        THEN
           NULL;
        ELSE
           SELECT a.line_code,
                  a.workstage_code,
                  a.machine_code
           INTO   lvs_line_code,
                  lvs_workstage_code,
                  lvs_machine_code
           FROM   ip_product_rework_plan a
           WHERE      a.plan_date = :NEW.plan_date
                  AND a.plan_date_sequence = :NEW.plan_date_sequence
                  AND a.organization_id = :NEW.organization_id;
           lvi_return :=
                 pkg_planning.plan_prod_child_item_issue(
                    :NEW.product_date ,
                    :NEW.product_sequence ,
                    :NEW.mfs,
                    :NEW.item_code,
                    lvs_line_code,
                    lvs_workstage_code,
                    lvs_machine_code,
                    :NEW.product_actual_qty,
                    'N',
                    :NEW.organization_id
                 );

           IF lvi_return < 0
           THEN
              raise_application_error(-20003, SQLERRM);
           END IF;
        END IF;*/

------------------------------------------------------------

   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error (-20003, SQLERRM);
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
            'Plan Date ='
         || :NEW.plan_date
         || 'Plan Sequence='
         || :NEW.plan_date_sequence
         || ' '
         || SQLERRM
      );
END;
