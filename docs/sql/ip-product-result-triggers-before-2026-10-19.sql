-- IP_PRODUCT_RESULT 기존 트리거 원본 (2026-10-19 삭제 전, 4개 모두 INVALID 였다). 원복하려면 이 파일을 그대로 실행한다.

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
/

CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"."TRG_IP_PRODUCT_RESULT_UPD" 
 BEFORE
   UPDATE OF lqc_inspect_result, oqc_inspect_result, product_actual_qty
 ON ip_product_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt              NUMBER;
   phase                VARCHAR2 (10);
   lvs_config_value     VARCHAR2 (1);
   lvs_deficit          VARCHAR2 (1);
   lvi_return           NUMBER;
   lvs_line_code        VARCHAR2 (20);
   lvs_workstage_code   VARCHAR2 (20);
   lvs_machine_code     VARCHAR2 (20);
   lvi_exsits           NUMBER;
   lvs_result_status    VARCHAR (1);
BEGIN
    /* ================================================================
     * 트리거명  : TRG_IP_PRODUCT_RESULT_UPD
     * 작성일  : 2026-07-02
     * 수정이력: 2026-07-02 - AI(Codex) - 한글 주석 자동 추가
     * ================================================================
     * [AI 분석] 기능 설명:
     *   IP_PRODUCT_RESULT 테이블의 UPDATE 이벤트 발생 시 원본 로직에 정의된 자동 처리를 수행한다.
     * ================================================================
     * [AI 분석] 발화 조건:
     *   시점/단위: BEFORE EACH ROW / 이벤트: UPDATE / 조건: 없음
     * ================================================================
     * [AI 분석] 대상 객체:
     *   IP_PRODUCT_RESULT - 트리거가 걸린 테이블/뷰
     * ================================================================
     * [AI 분석] OLD/NEW 사용:
     *   :NEW - LQC_INSPECT_RESULT, LQC_INSPECT_NO, LAST_MODIFY_BY, OQC_INSPECT_RESULT, OQC_INSPECT_NO, PRODUCT_ACTUAL_QTY, ORGANIZATION_ID, WORKSTAGE_ISSUE_YN 변경 후 값 참조
     *   :OLD - LQC_INSPECT_RESULT, ORGANIZATION_ID, MFS, ITEM_CODE, LINE_CODE, WORKSTAGE_CODE, PRODUCT_ACTUAL_QTY, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE 변경 전 값 참조
     * ================================================================
     * [AI 분석] 예외 처리:
     *   원본 EXCEPTION 블록 기준으로 오류를 처리한다.
     * ================================================================
     * [AI 분석] 복잡도:
     *   조건 분기: IF 20회 / 반복문: 0회 / DML: SELECT 4회, INSERT 7회, UPDATE 5회
     * ================================================================
     * 검증 방법: USER_OBJECTS, USER_ERRORS, USER_SOURCE, USER_TRIGGERS 조회만 사용한다.
     * 주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
     * ================================================================ */

   phase := 10;

   IF :NEW.lqc_inspect_result = 'W'
   THEN
      phase := 20;
      NULL;
   ELSIF      :NEW.lqc_inspect_result = 'P'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      phase := 30;

      -- INSET INTO NEW INSPECT RESULT PASS
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
                   :OLD.organization_id,
                   :NEW.lqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.line_code,
                   :OLD.workstage_code,
                   'P',
                   :OLD.product_actual_qty,
                   0,
                   :NEW.last_modify_by,
                   :OLD.enter_date,
                   :OLD.enter_by,
                   :OLD.last_modify_date,
                   :OLD.last_modify_by
                  );
   ELSIF      :NEW.lqc_inspect_result = 'R'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      phase := 40;

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
                   :OLD.organization_id,
                   :NEW.lqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.line_code,
                   :OLD.workstage_code,
                   'R',
                   :OLD.product_actual_qty,
                   0,
                   :NEW.last_modify_by,
                   :OLD.enter_date,
                   :OLD.enter_by,
                   :OLD.last_modify_date,
                   :OLD.last_modify_by
                  );
   ELSIF      :NEW.lqc_inspect_result = 'U'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      phase := 50;

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
                   :OLD.organization_id,
                   :NEW.lqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.line_code,
                   :OLD.workstage_code,
                   'U',
                   :OLD.product_actual_qty,
                   0,
                   :NEW.last_modify_by,
                   :OLD.enter_date,
                   :OLD.enter_by,
                   :OLD.last_modify_date,
                   :OLD.last_modify_by
                  );
   END IF;

   phase := 60;

   IF :NEW.oqc_inspect_result = 'W'
   THEN
      phase := 70;
      NULL;
   ELSIF      :NEW.oqc_inspect_result = 'P'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      phase := 80;

      -- INSET INTO NEW INSPECT RESULT PASS
      INSERT INTO iq_product_oqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   oqc_inspect_no,
                   mfs,
                   item_code,
                   receipt_qty,
                   oqc_inspect_result,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_oqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   NVL (:NEW.oqc_inspect_no, :NEW.lqc_inspect_no),
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'P',
                   0,
                   :NEW.last_modify_by,
                   :OLD.enter_date,
                   :OLD.enter_by,
                   :OLD.last_modify_date,
                   :OLD.last_modify_by
                  );
   ELSIF      :NEW.oqc_inspect_result = 'R'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      phase := 90;

      -- INSET INTO NEW INSPECT RESULT RETURN
      INSERT INTO iq_product_oqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   oqc_inspect_no,
                   mfs,
                   item_code,
                   receipt_qty,
                   oqc_inspect_result,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_oqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   NVL (:NEW.oqc_inspect_no, :NEW.lqc_inspect_no),
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'R',
                   0,
                   :NEW.last_modify_by,
                   :OLD.enter_date,
                   :OLD.enter_by,
                   :OLD.last_modify_date,
                   :OLD.last_modify_by
                  );
   ELSIF      :NEW.oqc_inspect_result = 'U'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
      phase := 100;

      -- INSET INTO NEW INSPECT RESULT REUSE
      INSERT INTO iq_product_oqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   oqc_inspect_no,
                   mfs,
                   item_code,
                   receipt_qty,
                   oqc_inspect_result,
                   inspect_bad_qty,
                   inspect_by,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_oqc_inspect_no.NEXTVAL,
                   :OLD.organization_id,
                   NVL (:NEW.oqc_inspect_no, :NEW.lqc_inspect_no),
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'U',
                   0,
                   :NEW.last_modify_by,
                   :OLD.enter_date,
                   :OLD.enter_by,
                   :OLD.last_modify_date,
                   :OLD.last_modify_by
                  );
   END IF;

   phase := 110;

----------------------------------------------------
--
----------------------------------------------------

   IF nvl(:OLD.product_actual_qty,0) <> :NEW.product_actual_qty -- if# 90
   THEN
      UPDATE ip_product_master_plan
         SET product_actual_qty =  product_actual_qty + ( :NEW.product_actual_qty - nvl(:OLD.product_actual_qty,0) )
       WHERE plan_date = :OLD.plan_date
         AND plan_date_sequence = :OLD.plan_date_sequence
         AND organization_id = :OLD.organization_id;

      phase := 120;
-------------------------------------------------------
-- MACHINE CAPACITY
-------------------------------------------------------
      UPDATE ip_product_daily_mcn_capacity
         SET reserved_capacity =
                     NVL (reserved_capacity, 0)
                   - (  (  NVL (:NEW.product_actual_qty, 0)
                         - NVL (:OLD.product_actual_qty, 0)
                        )
                      * NVL (
                           f_get_product_st (
                              :OLD.item_code,
                              :OLD.line_code,
                              :OLD.workstage_code,
                              :OLD.machine_code,
                              :OLD.organization_id
                           ),
                           0
                        )
                     )
       WHERE machine_code = :OLD.machine_code
         AND plan_date = :OLD.plan_date
         AND organization_id = :OLD.organization_id;

      phase := 130;


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

      phase := 140;

      IF lvs_config_value = 'S' --WHEN SALE
      THEN
         NULL;
      ELSE
         UPDATE imcn_mold_inventory
            SET actual_value =   NVL (actual_value, 0)
                               + (  NVL (:NEW.product_actual_qty, 0)
                                  - NVL (:OLD.product_actual_qty, 0)
                                 )
          WHERE mold_code = :OLD.mold_code
            AND mold_version = :OLD.mold_version
            AND mold_set_serial = :OLD.mold_set_serial
            AND organization_id = :OLD.organization_id;
      END IF;

      phase := 150;


-------------------------------------------------------
-- Workstage Inventory
-------------------------------------------------------


      IF (  :NEW.product_actual_qty
          - :OLD.product_actual_qty
         ) < 0
      THEN
         lvs_deficit := 2;
      ELSE
         lvs_deficit := 1;
      END IF;

      phase := 160;

      BEGIN
         SELECT COUNT (*)
           INTO lvi_exsits
           FROM im_item_workstage_receipt
          WHERE plan_date = :OLD.plan_date
            AND plan_date_sequence = :OLD.plan_date_sequence
            AND transfer_date = :OLD.product_date
            AND transfer_sequence = :OLD.product_sequence
            AND organization_id = :OLD.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_exsits := 0;
      END;

      phase := 170;

      IF lvi_exsits > 0
      THEN
         UPDATE im_item_workstage_receipt
            SET receipt_qty =   receipt_qty
                              + (  :NEW.product_actual_qty
                                 - :OLD.product_actual_qty
                                ),
                receipt_weight =   receipt_weight
                                 + (  :NEW.product_actual_qty
                                    - :OLD.product_actual_qty
                                   )
          WHERE plan_date = :OLD.plan_date
            AND plan_date_sequence = :OLD.plan_date_sequence
            AND transfer_date = :OLD.product_date
            AND transfer_sequence = :OLD.product_sequence
            AND organization_id = :OLD.organization_id;

         phase := 180;
      ELSE
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
              VALUES (:OLD.product_date,
                      seq_workstage_receipt_seq.NEXTVAL,
                      :OLD.organization_id,
                      :OLD.workstage_code, --Parent Item Workstage
                      :OLD.workstage_code,
                      :OLD.machine_code,
                      :OLD.mfs,
                      :OLD.mfs,
                      :OLD.item_code,
                      'T', --:NEW.item_type,
                      :OLD.product_line_type,
                      :OLD.line_code,
                      :OLD.line_code,
                      lvs_deficit, --receipt_deficit
                      :OLD.product_price,
                        :NEW.product_actual_qty
                      - :OLD.product_actual_qty,
                        :NEW.product_actual_qty
                      - :OLD.product_actual_qty, --RECEIPT_WEIGHT,
                        :OLD.product_price
                      * (  :NEW.product_actual_qty
                         - :OLD.product_actual_qty
                        ),
                      'N', --:NEW.receipt_type, --RECEIPT_TYPE,AUTO / NORMAL
                      'M001', --:NEW.receipt_account,
                      1, --ITEM_UNIT_WEIGHT,
                      NULL, --ISSUE_DATE,
                      NULL, --ISSUE_SEQUENCE,
                      '', --:NEW.work_order_no,
                      'N', --RECEIPT_STATUS,
                      :OLD.product_date, --transfer_date,
                      :OLD.product_sequence, --20100510 YOUHS MODIFY seq_workstage_receipt_seq.NEXTVAL, --TRANSFER_SEQUENCE,
                      'C', --TRANSFER TYPE C=CONNECT
                      '', --:NEW.invoice_no,
                      SYSDATE,
                      :OLD.enter_by,
                      SYSDATE,
                      :OLD.last_modify_by,
                      :OLD.plan_date,
                      :OLD.plan_date_sequence
                     );
      END IF;

      phase := 190;


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
            AND organization_id = :OLD.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvs_config_value := 'N';
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      phase := 200;

      IF lvs_config_value = 'N'
      THEN
         :NEW.workstage_issue_yn := 'N';
         NULL;
      ELSE
         :NEW.workstage_issue_yn := 'Y';
         SELECT a.line_code,
                a.workstage_code,
                a.machine_code
           INTO lvs_line_code,
                lvs_workstage_code,
                lvs_machine_code
           FROM ip_product_master_plan a
          WHERE a.plan_date = :OLD.plan_date
            AND a.plan_date_sequence = :OLD.plan_date_sequence
            AND a.organization_id = :OLD.organization_id;
-----------------------------------------------
--
-----------------------------------------------
         IF   :NEW.product_actual_qty - :OLD.product_actual_qty > 0
         THEN
            lvs_result_status := 'N';
         ELSE
            lvs_result_status := 'C';
         END IF;
-----------------------------------------------
         lvi_return :=
               pkg_planning.plan_prod_child_item_issue (
                  :OLD.product_date /*IN DATE*/,
                  :OLD.product_sequence /*IN NUMBER*/,
                  :OLD.mfs /*IN VARCHAR2*/,
                  :OLD.item_code /*IN VARCHAR2*/,
                  lvs_line_code /*IN VARCHAR2*/,
                  lvs_workstage_code /*IN VARCHAR2*/,
                  lvs_machine_code /*IN VARCHAR2*/,
                    :NEW.product_actual_qty
                  - :OLD.product_actual_qty /*IN NUMBER*/,
                  lvs_result_status /*IN VARCHAR2*/,
                  :OLD.organization_id
               );
         phase := 210;

         IF lvi_return < 0
         THEN
            raise_application_error (-20003, SQLERRM);
         END IF;
      END IF;
   END IF; -- if# 90 old actual <> new actual
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003,    'PHASE='
                                       || phase
                                       || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"."TRG_IP_PRODUCT_RESULT_DEL" 
 AFTER
  DELETE
 ON ip_product_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
    lvi_count            NUMBER;
    lvi_seq              NUMBER;
    lvi_return           NUMBER;
    lvs_line_code        VARCHAR2 (20);
    lvs_workstage_code   VARCHAR2 (20);
    lvs_machine_code     VARCHAR2 (20);
    lvs_config_value     VARCHAR2 (1);
BEGIN
    /* ================================================================
     * 트리거명  : TRG_IP_PRODUCT_RESULT_DEL
     * 작성일  : 2026-07-02
     * 수정이력: 2026-07-02 - AI(Codex) - 한글 주석 자동 추가
     * ================================================================
     * [AI 분석] 기능 설명:
     *   IP_PRODUCT_RESULT 테이블의 DELETE 이벤트 발생 시 원본 로직에 정의된 자동 처리를 수행한다.
     * ================================================================
     * [AI 분석] 발화 조건:
     *   시점/단위: AFTER EACH ROW / 이벤트: DELETE / 조건: 없음
     * ================================================================
     * [AI 분석] 대상 객체:
     *   IP_PRODUCT_RESULT - 트리거가 걸린 테이블/뷰
     * ================================================================
     * [AI 분석] OLD/NEW 사용:
     *   :OLD - PRODUCT_ACTUAL_QTY, PLAN_DATE, PLAN_DATE_SEQUENCE, ORGANIZATION_ID, ITEM_CODE, LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE, MOLD_CODE, MOLD_VERSION 변경 전 값 참조
     * ================================================================
     * [AI 분석] 예외 처리:
     *   원본 EXCEPTION 블록 기준으로 오류를 처리한다.
     * ================================================================
     * [AI 분석] 복잡도:
     *   조건 분기: IF 10회 / 반복문: 0회 / DML: SELECT 4회, INSERT 1회, UPDATE 5회, DELETE 1회
     * ================================================================
     * 검증 방법: USER_OBJECTS, USER_ERRORS, USER_SOURCE, USER_TRIGGERS 조회만 사용한다.
     * 주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
     * ================================================================ */

    IF :old.product_actual_qty = 0
    THEN
        NULL;
    ELSE
        BEGIN
            SELECT   COUNT ( * )
              INTO   lvi_count
              FROM   ip_product_master_plan
             WHERE       plan_date = :old.plan_date
                     AND plan_date_sequence = :old.plan_date_sequence
                     AND organization_id = :old.organization_id;

            IF lvi_count = 0
            THEN
                NULL;
            -- raise_application_error (-20003,    'Plan Not Found'|| SQLERRM);
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        --  raise_application_error (-20003,    'Plan Not Found'                                          || SQLERRM);
        END;

        UPDATE   ip_product_master_plan
           SET   product_actual_qty =
                     NVL (product_actual_qty, 0) - :old.product_actual_qty,
                 plan_status = 'P'
         WHERE       plan_date = :old.plan_date
                 AND plan_date_sequence = :old.plan_date_sequence
                 AND organization_id = :old.organization_id;


        ----------------------------------------------------------
        -- Plan Status Flag Change
        ----------------------------------------------------------
        UPDATE   ip_product_master_plan
           SET   plan_status = 'W'
         WHERE       plan_date = :old.plan_date
                 AND plan_date_sequence = :old.plan_date_sequence
                 AND product_actual_qty = 0
                 AND organization_id = :old.organization_id;


        ----------------------------------------------------------
        -- Machine Capacity
        ----------------------------------------------------------

        UPDATE   ip_product_daily_mcn_capacity
           SET   reserved_capacity =
                     NVL (reserved_capacity, 0)
                     + (NVL (:old.product_actual_qty, 0)
                        * NVL (f_get_product_st (:old.item_code,
                                                 :old.line_code,
                                                 :old.workstage_code,
                                                 :old.machine_code,
                                                 :old.organization_id), 0))
         WHERE       machine_code = :old.machine_code
                 AND plan_date = :old.plan_date
                 AND organization_id = :old.organization_id;


        ------------------------------------
        -- MOLD ACTUAL CHANGE
        ------------------------------------
        -- SYSTEM CONFIG VALUE GET
        -- CURRENT VALUE = Y
        ------------------------------------
        BEGIN
            SELECT   NVL (config_value, 'P')
              INTO   lvs_config_value
              FROM   isys_config
             WHERE       config_name = 'MOLD_ACTUAL_TYPE'
                     AND use_yn = 'Y'
                     AND organization_id = :old.organization_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvs_config_value := 'P';                      --PRODUCT RESULT
            WHEN OTHERS
            THEN
                raise_application_error (-20003, SQLERRM);
        END;

        IF lvs_config_value = 'S'                                       --SALE
        THEN
            NULL;
        ELSE
            UPDATE   imcn_mold_inventory
               SET   actual_value =
                         NVL (actual_value, 0)
                         - NVL (:old.product_actual_qty, 0)
             WHERE       mold_code = :old.mold_code
                     AND mold_version = :old.mold_version
                     AND mold_set_serial = :old.mold_set_serial
                     AND organization_id = :old.organization_id;
        END IF;

        BEGIN
            SELECT   a.line_code, a.workstage_code, a.machine_code
              INTO   lvs_line_code, lvs_workstage_code, lvs_machine_code
              FROM   ip_product_master_plan a
             WHERE       a.plan_date = :old.plan_date
                     AND a.plan_date_sequence = :old.plan_date_sequence
                     AND a.organization_id = :old.organization_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20003,
                    'Product Master Plan Not Found ' || SQLERRM);
        END;


        -------------------------------------------------------
        -- Workstage Inventory
        -------------------------------------------------------

        UPDATE   im_item_workstage_receipt
           SET   receipt_status = 'C'
         WHERE       item_code = :old.item_code
                 AND line_type = :old.product_line_type
                 AND mfs = :old.mfs
                 AND line_code = :old.line_code
                 AND workstage_code = :old.workstage_code
                 AND transfer_date = :old.product_date
                 AND transfer_sequence = :old.product_sequence
                 AND plan_date = :old.plan_date
                 AND plan_date_sequence = :old.plan_date_sequence
                 AND organization_id = :old.organization_id;

        INSERT INTO im_item_workstage_receipt (receipt_date,
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
                                               last_modify_by,
                                               plan_date,
                                               plan_date_sequence)
          VALUES   (:old.product_date,
                    seq_workstage_receipt_seq.NEXTVAL,
                    :old.organization_id,
                    :old.workstage_code,
                    'WH',
                    :old.machine_code,
                    :old.mfs,
                    :old.mfs,
                    :old.item_code,
                    'T',                                     --:NEW.item_type,
                    :old.product_line_type,
                    :old.line_code,
                    2,                                       --receipt_deficit
                    0,                                   --:NEW.receipt_price,
                    :old.product_actual_qty * -1,
                    :old.product_actual_qty * -1,            --RECEIPT_WEIGHT,
                    0,                                     --:NEW.receipt_amt,
                    'N',     --:NEW.receipt_type, --RECEIPT_TYPE,AUTO / NORMAL
                    'M001',                            --:NEW.receipt_account,
                    1,                                     --ITEM_UNIT_WEIGHT,
                    NULL,                                        --ISSUE_DATE,
                    NULL,                                    --ISSUE_SEQUENCE,
                    '',                                  --:NEW.work_order_no,
                    'C',                                     --RECEIPT_STATUS,
                    :old.product_date,                        --transfer_date,
                    seq_workstage_receipt_seq.NEXTVAL,    --TRANSFER_SEQUENCE,
                    'C',
                    '',                                     --:NEW.invoice_no,
                    SYSDATE,
                    :old.enter_by,
                    SYSDATE,
                    :old.last_modify_by,
                    :old.plan_date,
                    :old.plan_date_sequence);


        ------------------------------------------------------------
        -- Child Item Auto Issue
        ------------------------------------------------------------
        ------------------------------------
        -- SYSTEM CONFIG VALUE GET
        -- CURRENT VALUE = Y
        ------------------------------------
        BEGIN
            SELECT   NVL (config_value, 'N')
              INTO   lvs_config_value
              FROM   isys_config
             WHERE       config_name = 'PRODUCT_WORKSTAGE_ISSUE_YN'
                     AND use_yn = 'Y'
                     AND organization_id = :old.organization_id;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                lvs_config_value := 'N';
            WHEN OTHERS
            THEN
                raise_application_error (-20003, SQLERRM);
        END;

        IF lvs_config_value = 'N'
        THEN
            NULL;
        ELSE
            BEGIN
                lvi_return :=
                    pkg_planning.plan_prod_child_item_issue (
                        :old.product_date                          /*IN DATE*/
                                         ,
                        :old.product_sequence                    /*IN NUMBER*/
                                             ,
                        :old.mfs                               /*IN VARCHAR2*/
                                ,
                        :old.item_code                         /*IN VARCHAR2*/
                                      ,
                        lvs_line_code                          /*IN VARCHAR2*/
                                     ,
                        lvs_workstage_code                     /*IN VARCHAR2*/
                                          ,
                        lvs_machine_code                       /*IN VARCHAR2*/
                                        ,
                        :old.product_actual_qty                  /*IN NUMBER*/
                                               ,
                        'C'                                    /*IN VARCHAR2*/
                           ,
                        :old.organization_id                     /*IN NUMBER*/
                                            );

                IF lvi_return < 0
                THEN
                    raise_application_error (-20003,
                                             'Child Item Issue ' || SQLERRM);
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    raise_application_error (-20003,
                                             'Child Item Issue ' || SQLERRM);
            END;
        END IF;
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
            || :old.plan_date
            || 'Plan Sequence='
            || :old.plan_date_sequence
            || ' '
            || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER "INFINITY21_JSMES"
  /* ================================================================
   * 트리거명  : TRG_PRODUCT_RESULT_MANUAL
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   IP_PRODUCT_RESULT 테이블의 UPDATE 발생 시 생산/검사 실적 관련 값을 자동 보정하거나 이력을 갱신한다.
   *   제품 실적, 검사 결과, 공정 흐름의 데이터 정합성을 유지하기 위한 트리거로 추정된다.
   * ================================================================
   * [AI 분석] 발화 조건:
   *   시점: AFTER
   *   이벤트: UPDATE
   *   단위: FOR EACH ROW
   *   조건: 없음
   * ================================================================
   * [AI 분석] 대상 객체:
   *   IP_PRODUCT_RESULT - 트리거가 걸린 테이블/뷰
   * ================================================================
   * [AI 분석] OLD/NEW 사용:
   *   :OLD.PLAN_DATE - 변경/삭제 전 계획 / 일자 관련 값
   *   :OLD.PLAN_DATE_SEQUENCE - 변경/삭제 전 계획 / 일자 관련 값
   *   :OLD.ORGANIZATION_ID - 변경/삭제 전 값 값
   *   :OLD.PRODUCT_DATE - 변경/삭제 전 제품 / 일자 관련 값
   *   :OLD.PRODUCT_SEQUENCE - 변경/삭제 전 제품 관련 값
   *   :OLD.MFS - 변경/삭제 전 값 값
   *   :OLD.ITEM_CODE - 변경/삭제 전 품목 관련 값
   *   :OLD.PRODUCT_ACTUAL_QTY - 변경/삭제 전 제품 / 수량 관련 값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_RESULT - 제품 / 실적 관련 트리거 대상 테이블
   *   IP_PRODUCT_MASTER_PLAN - 제품 / 계획 관련 트리거 내부 SQL에서 참조/변경
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
   *   SELECT status FROM user_objects WHERE object_type = 'TRIGGER' AND object_name = 'TRG_PRODUCT_RESULT_MANUAL';
   *   SELECT * FROM user_errors WHERE type = 'TRIGGER' AND name = 'TRG_PRODUCT_RESULT_MANUAL';
   *   주의: 검증 목적으로 대상 테이블에 DML을 실행하지 않는다.
   * ================================================================ */
."TRG_PRODUCT_RESULT_MANUAL" 
 AFTER
   UPDATE OF product_sequence
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
BEGIN
   IF 1 = 2
   THEN
      SELECT a.line_code, a.workstage_code, a.machine_code
        INTO lvs_line_code, lvs_workstage_code, lvs_machine_code
        FROM ip_product_master_plan a
       WHERE a.plan_date = :OLD.plan_date
         AND a.plan_date_sequence = :OLD.plan_date_sequence
         AND a.organization_id = :OLD.organization_id;
      lvi_return :=
            pkg_planning.plan_prod_child_item_issue (
               :OLD.product_date /*IN DATE*/,
               :OLD.product_sequence /*IN NUMBER*/,
               :OLD.mfs /*IN VARCHAR2*/,
               :OLD.item_code /*IN VARCHAR2*/,
               lvs_line_code /*IN VARCHAR2*/,
               lvs_workstage_code /*IN VARCHAR2*/,
               lvs_machine_code /*IN VARCHAR2*/,
               :OLD.product_actual_qty /*IN NUMBER*/,
               'N' /*IN VARCHAR2*/,
               :OLD.organization_id                              /*IN NUMBER*/
            );
   
/*  IF 1 = 2
  THEN
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
          VALUES (:OLD.product_date,
                  seq_workstage_receipt_seq.NEXTVAL,
                  :OLD.organization_id,
                  :OLD.workstage_code,
                  :OLD.workstage_code,
                  :OLD.machine_code,
                  :OLD.mfs,
                  :OLD.mfs,
                  :OLD.item_code,
                  'T', --:OLD.item_type,
                  :OLD.product_line_type,
                  :OLD.line_code,
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
                  'C',
                  '', --:OLD.invoice_no,
                  SYSDATE,
                  :OLD.enter_by,
                  SYSDATE,
                  :OLD.last_modify_by
                 );
  END IF; */

   END IF;
END;
/
