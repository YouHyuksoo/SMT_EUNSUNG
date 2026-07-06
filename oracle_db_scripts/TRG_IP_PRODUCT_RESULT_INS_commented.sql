CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"."TRG_IP_PRODUCT_RESULT_INS" 
 BEFORE
  INSERT
 ON ip_product_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_count             NUMBER;
   lvi_seq               NUMBER;
   lvi_return            NUMBER;
   lvs_line_code         VARCHAR2 (20);
   lvs_workstage_code    VARCHAR2 (20);
   lvs_machine_code      VARCHAR2 (20);
   lvs_deficit           VARCHAR2 (1);
   lvs_config_value      VARCHAR2 (1);
   lvs_prie_type_value   VARCHAR2 (1);
   lvl_cntlq             NUMBER;
   lvi_exsits            NUMBER;
BEGIN
    /* ================================================================
     * 트리거명  : TRG_IP_PRODUCT_RESULT_INS
     * 작성일  : 2026-07-02
     * 수정이력: 2026-07-02 - AI(Codex) - 한글 주석 자동 추가
     * ================================================================
     * [AI 분석] 기능 설명:
     *   IP_PRODUCT_RESULT 테이블의 INSERT 이벤트 발생 시 원본 로직에 정의된 자동 처리를 수행한다.
     * ================================================================
     * [AI 분석] 발화 조건:
     *   시점/단위: BEFORE EACH ROW / 이벤트: INSERT / 조건: 없음
     * ================================================================
     * [AI 분석] 대상 객체:
     *   IP_PRODUCT_RESULT - 트리거가 걸린 테이블/뷰
     * ================================================================
     * [AI 분석] OLD/NEW 사용:
     *   :NEW - LOT_DIVIDE_YN, PRODUCT_ACTUAL_QTY, PLAN_DATE, PLAN_DATE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE, MOLD_CODE 변경 후 값 참조
     * ================================================================
     * [AI 분석] 예외 처리:
     *   원본 EXCEPTION 블록 기준으로 오류를 처리한다.
     * ================================================================
     * [AI 분석] 복잡도:
     *   조건 분기: IF 15회 / 반복문: 0회 / DML: SELECT 6회, INSERT 5회, UPDATE 4회
     * ================================================================
     * 검증 방법: USER_OBJECTS, USER_ERRORS, USER_SOURCE, USER_TRIGGERS 조회만 사용한다.
     * 주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
     * ================================================================ */

   IF :NEW.lot_divide_yn = 'Y'
   THEN
      NULL;
   ELSE
      --  raise_application_error( -20003 , :NEW.product_actual_qty ) ;
      UPDATE ip_product_master_plan a
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

      
-------------------------------------------------------
-- MACHINE CAPACITY
-------------------------------------------------------
      UPDATE ip_product_daily_mcn_capacity
         SET reserved_capacity =
                     NVL (reserved_capacity, 0)
                   - (  NVL (:NEW.product_actual_qty, 0)
                      * NVL (
                           f_get_product_st (
                              :NEW.item_code,
                              :NEW.line_code,
                              :NEW.workstage_code,
                              :NEW.machine_code,
                              :NEW.organization_id
                           ),
                           0
                        )
                     )
       WHERE machine_code = :NEW.machine_code
         AND plan_date = :NEW.plan_date
         AND organization_id = :NEW.organization_id;

      
-------------------------------------------------------
-- MOLD ACTUAL VALUE
-------------------------------------------------------
------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'P')
           INTO lvs_config_value
           FROM isys_config
          WHERE config_name = 'MOLD_ACTUAL_TYPE'
            AND use_yn = 'Y'
            AND organization_id = :NEW.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'P'; --PRODUCT RESULT
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF lvs_config_value = 'S' --WHEN SALE
      THEN
         NULL;
      ELSE
         UPDATE imcn_mold_inventory
            SET actual_value =
                       NVL (actual_value, 0)
                     + NVL (:NEW.product_actual_qty, 0)
          WHERE mold_code = :NEW.mold_code
            AND mold_version = :NEW.mold_version
            AND mold_set_serial = :NEW.mold_set_serial
            AND organization_id = :NEW.organization_id;
      END IF;

      
-----------------------------------------------
--
-----------------------------------------------
/*      BEGIN
         SELECT NVL (config_value, 'B')
           INTO lvs_prie_type_value
           FROM isys_config
          WHERE config_name = 'PRODUCT_RECEIPT_PRICE_TYPE'
            AND use_yn = 'Y'
            AND organization_id = :NEW.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_prie_type_value := 'B';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

*/
-------------------------------------------------------
-- Workstage Inventory
-------------------------------------------------------
      IF :NEW.product_actual_qty < 0
      THEN
         lvs_deficit := 2;
      ELSE
         lvs_deficit := 1;
      END IF;

      /*    BEGIN
              SELECT COUNT (*)
                INTO lvi_exsits
                FROM im_item_workstage_receipt
               WHERE PLAN_DATE = :NEW.PLAN_DATE
                 AND PLAN_DATE_SEQUENCE = :NEW.PLAN_DATE_SEQUENCE
                 AND organization_id = :NEW.organization_id;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 lvi_exsits := 0;
           END;

           IF lvi_exsits > 0
           THEN
              UPDATE im_item_workstage_receipt
                 SET receipt_qty = :NEW.product_actual_qty
               WHERE PLAN_DATE = :NEW.PLAN_DATE
                 AND PLAN_DATE_SEQUENCE = :NEW.PLAN_DATE_SEQUENCE
                 AND organization_id = :NEW.organization_id;
           ELSE
           */
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
                   last_modify_by,
                   plan_date,
                   plan_date_sequence
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
                   :NEW.product_price,
                   
/*                   pkg_design.bom_material_cost (
                      :NEW.item_code,
                      :NEW.product_date,
                      lvs_prie_type_value,
                      :NEW.organization_id
                   ), --:NEW.receipt_price,
*/
                   :NEW.product_actual_qty,
                   :NEW.product_actual_qty, --RECEIPT_WEIGHT,
                   :NEW.product_amt,
                   
/*                     pkg_design.bom_material_cost (
                      :NEW.item_code,
                      :NEW.product_date,
                      lvs_prie_type_value,
                      :NEW.organization_id
                   )
                   * :NEW.product_actual_qty, --:NEW.receipt_amt,
*/
                   'N', --:NEW.receipt_type, --RECEIPT_TYPE,AUTO / NORMAL
                   'M001', --:NEW.receipt_account,
                   1, --ITEM_UNIT_WEIGHT,
                   NULL, --ISSUE_DATE,
                   NULL, --ISSUE_SEQUENCE,
                   '', --:NEW.work_order_no,
                   'N', --RECEIPT_STATUS,
                   :NEW.product_date, --transfer_date,
                   :NEW.product_sequence, --20100510 YOUHS MODIFY seq_workstage_receipt_seq.NEXTVAL, --TRANSFER_SEQUENCE,
                   'C', --TRANSFER TYPE C=CONNECT
                   '', --:NEW.invoice_no,
                   SYSDATE,
                   :NEW.enter_by,
                   SYSDATE,
                   :NEW.last_modify_by,
                   :NEW.plan_date,
                   :NEW.plan_date_sequence
                  );

      --  END IF;


------------------------------------------------------------
-- Child Item Auto Issue
------------------------------------------------------------

------------------------------------
-- SYSTEM CONFIG VALUE GET
-- CURRENT VALUE = Y
------------------------------------
      BEGIN
         SELECT NVL (config_value, 'N')
           INTO lvs_config_value
           FROM isys_config
          WHERE config_name = 'PRODUCT_WORKSTAGE_ISSUE_YN'
            AND use_yn = 'Y'
            AND organization_id = :NEW.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'N';
         WHEN OTHERS
         THEN
            raise_application_error (-20008, SQLERRM);
      END;

      IF lvs_config_value = 'N'
      THEN
         :NEW.workstage_issue_yn := 'N';
         NULL;
      ELSE
         :NEW.workstage_issue_yn := 'Y';
         SELECT a.line_code, a.workstage_code, a.machine_code
           INTO lvs_line_code, lvs_workstage_code, lvs_machine_code
           FROM ip_product_master_plan a
          WHERE a.plan_date = :NEW.plan_date
            AND a.plan_date_sequence = :NEW.plan_date_sequence
            AND a.organization_id = :NEW.organization_id;
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
                  :NEW.organization_id                           /*IN NUMBER*/
               );

         IF lvi_return < 0
         THEN
            raise_application_error (-20003, SQLERRM);
         END IF;
      END IF;

      
------------------------------------------------------------
--
------------------------------------------------------------
      SELECT COUNT (*)
        INTO lvl_cntlq
        FROM iq_product_lqc
       WHERE lqc_inspect_no = :NEW.lqc_inspect_no
         AND lqc_inspect_result IN ('P', 'R', 'U')
         AND organization_id = :NEW.organization_id
         AND ROWNUM = 1;

      IF :NEW.lqc_inspect_result = 'W'
      THEN
         NULL;
      ELSIF      :NEW.lqc_inspect_result = 'P'
             AND lvl_cntlq < 1
      THEN
         NULL;
              -- MODIFY DSATE 20100328 YOUHS
              --占쏙옙 ?占?? ?竊잞폕占?竊잂？뀐폕              -- INSET INTO NEW INSPECT RESULT PASS
      /*        INSERT INTO iq_product_lqc
                          (inspect_date,
                           inspect_sequence,
                           organization_id,
                           lqc_inspect_no,
                           mfs,
                           item_code,
                           line_code,
                           workstage_code,
                           lqc_inspect_result,
                           product_actual_qty,
                           inspect_bad_qty,
                           inspect_by,
                           enter_date,
                           enter_by,
                           last_modify_date,
                           last_modify_by
                          )
                   VALUES (TRUNC (SYSDATE),
                           seq_lqc_inspect_no.NEXTVAL,
                           :NEW.organization_id,
                           :NEW.lqc_inspect_no,
                           :NEW.mfs,
                           :NEW.item_code,
                           :NEW.line_code,
                           :NEW.workstage_code,
                           'P',
                           :NEW.product_actual_qty,
                           0,
                           :NEW.last_modify_by,
                           :NEW.last_modify_date,
                           :NEW.last_modify_by,
                           :NEW.last_modify_date,
                           :NEW.last_modify_by
                          );
            */
      ELSIF      :NEW.lqc_inspect_result = 'R'
             AND lvl_cntlq < 1
      THEN
         -- INSET INTO NEW INSPECT RESULT RETURN
         INSERT INTO iq_product_lqc
                     (inspect_date,
                      inspect_sequence,
                      organization_id,
                      lqc_inspect_no,
                      mfs,
                      item_code,
                      line_code,
                      workstage_code,
                      lqc_inspect_result,
                      product_actual_qty,
                      inspect_bad_qty,
                      inspect_by,
                      enter_date,
                      enter_by,
                      last_modify_date,
                      last_modify_by
                     )
              VALUES (TRUNC (SYSDATE),
                      seq_lqc_inspect_no.NEXTVAL,
                      :NEW.organization_id,
                      :NEW.lqc_inspect_no,
                      :NEW.mfs,
                      :NEW.item_code,
                      :NEW.line_code,
                      :NEW.workstage_code,
                      'R',
                      :NEW.product_actual_qty,
                      :NEW.product_actual_qty,
                      :NEW.last_modify_by,
                      :NEW.last_modify_date,
                      :NEW.last_modify_by,
                      :NEW.last_modify_date,
                      :NEW.last_modify_by
                     );
      -- END IF;
      ELSIF      :NEW.lqc_inspect_result = 'U'
             AND lvl_cntlq < 1
      THEN
         -- INSET INTO NEW INSPECT RESULT REUSE
         INSERT INTO iq_product_lqc
                     (inspect_date,
                      inspect_sequence,
                      organization_id,
                      lqc_inspect_no,
                      mfs,
                      item_code,
                      line_code,
                      workstage_code,
                      lqc_inspect_result,
                      product_actual_qty,
                      inspect_bad_qty,
                      inspect_by,
                      enter_date,
                      enter_by,
                      last_modify_date,
                      last_modify_by
                     )
              VALUES (TRUNC (SYSDATE),
                      seq_lqc_inspect_no.NEXTVAL,
                      :NEW.organization_id,
                      :NEW.lqc_inspect_no,
                      :NEW.mfs,
                      :NEW.item_code,
                      :NEW.line_code,
                      :NEW.workstage_code,
                      'U',
                      :NEW.product_actual_qty,
                      :NEW.product_actual_qty,
                      :NEW.last_modify_by,
                      :NEW.last_modify_date,
                      :NEW.last_modify_by,
                      :NEW.last_modify_date,
                      :NEW.last_modify_by
                     );
      END IF;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error (-20006, SQLERRM);
   WHEN OTHERS
   THEN
      raise_application_error (
         -20007,
            'IP_PRODUCT_RESULT=> Plan Date ='
         || :NEW.plan_date
         || 'Plan Sequence='
         || :NEW.plan_date_sequence
         || ' '
         || SQLERRM||'~r~n'
      );
END;
