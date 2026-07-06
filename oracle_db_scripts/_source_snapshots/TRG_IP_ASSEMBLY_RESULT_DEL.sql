TRIGGER "INFINITY21_JSMES"."TRG_IP_ASSEMBLY_RESULT_DEL" 
 AFTER
  DELETE
 ON ip_assembly_result
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
   BEGIN
      SELECT COUNT (*)
        INTO lvi_count
        FROM ip_assembly_master_plan
       WHERE plan_date = :OLD.plan_date
         AND plan_date_sequence = :OLD.plan_date_sequence
         AND organization_id = :OLD.organization_id;

      IF lvi_count = 0
      THEN
         raise_application_error (-20003,    'Plan Not Found'
                                          || SQLERRM);
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20003,    'Plan Not Found'
                                          || SQLERRM);
   END;

   UPDATE ip_assembly_master_plan
      SET product_actual_qty =
                           NVL (product_actual_qty, 0)
                         - :OLD.product_actual_qty,
          plan_status = 'P'
    WHERE plan_date = :OLD.plan_date
      AND plan_date_sequence = :OLD.plan_date_sequence
      AND organization_id = :OLD.organization_id;


----------------------------------------------------------
-- Plan Status Flag Change
----------------------------------------------------------
   UPDATE ip_assembly_master_plan
      SET plan_status = 'W'
    WHERE plan_date = :OLD.plan_date
      AND plan_date_sequence = :OLD.plan_date_sequence
      AND product_actual_qty = 0
      AND organization_id = :OLD.organization_id;


----------------------------------------------------------
-- Machine Capacity
----------------------------------------------------------

   UPDATE ip_product_daily_mcn_capacity
      SET reserved_capacity =   NVL (reserved_capacity, 0)
                              + (  NVL (:OLD.product_actual_qty, 0)
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


------------------------------------
-- MOLD ACTUAL CHANGE
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
         AND organization_id = :OLD.organization_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvs_config_value := 'P'; --PRODUCT RESULT
      WHEN OTHERS
      THEN
         raise_application_error (-20003, SQLERRM);
   END;

   IF lvs_config_value = 'S' --SALE
   THEN
      NULL;
   ELSE
      UPDATE imcn_mold_inventory
         SET actual_value =
                       NVL (actual_value, 0)
                     - NVL (:OLD.product_actual_qty, 0)
       WHERE mold_code = :OLD.mold_code
         AND mold_version = :OLD.mold_version
         AND mold_set_serial = :OLD.mold_set_serial
         AND organization_id = :OLD.organization_id;
   END IF;

   BEGIN
      SELECT a.line_code,
             a.workstage_code,
             a.machine_code
        INTO lvs_line_code,
             lvs_workstage_code,
             lvs_machine_code
        FROM ip_assembly_master_plan a
       WHERE a.plan_date = :OLD.plan_date
         AND a.plan_date_sequence = :OLD.plan_date_sequence
         AND a.organization_id = :OLD.organization_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20003,
               'Product Master Plan Not Found '
            || SQLERRM
         );
   END;


-------------------------------------------------------
-- Workstage Inventory
-------------------------------------------------------

   UPDATE im_item_workstage_receipt
      SET receipt_status = 'C'
    WHERE item_code = :OLD.item_code
      AND line_type = :OLD.product_line_type
      AND mfs = :OLD.mfs
      AND line_code = :OLD.line_code
      AND workstage_code = :OLD.trans_workstage_code
      AND from_workstage_code = :OLD.workstage_code    
      AND transfer_date = :OLD.product_date
      AND transfer_sequence = :OLD.product_sequence
      AND plan_date = :OLD.plan_date
      AND plan_date_sequence = :OLD.plan_date_sequence
      AND organization_id = :OLD.organization_id;

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
                :OLD.trans_workstage_code,
                :OLD.workstage_code,
                :OLD.machine_code,
                :OLD.mfs,
                :OLD.mfs,
                :OLD.item_code,
                'T', --:NEW.item_type,
                :OLD.product_line_type,
                :OLD.line_code,
                2, --receipt_deficit
                0, --:NEW.receipt_price,
                :OLD.product_actual_qty * -1,
                :OLD.product_actual_qty * -1, --RECEIPT_WEIGHT,
                0, --:NEW.receipt_amt,
                'N', --:NEW.receipt_type, --RECEIPT_TYPE,AUTO / NORMAL
                'M001', --:NEW.receipt_account,
                1, --ITEM_UNIT_WEIGHT,
                NULL, --ISSUE_DATE,
                NULL, --ISSUE_SEQUENCE,
                '', --:NEW.work_order_no,
                'C', --RECEIPT_STATUS,
                :OLD.product_date, --transfer_date,
                seq_workstage_receipt_seq.NEXTVAL, --TRANSFER_SEQUENCE,
                'C',
                '', --:NEW.invoice_no,
                SYSDATE,
                :OLD.enter_by,
                SYSDATE,
                :OLD.last_modify_by,
                :OLD.plan_date,
                :OLD.plan_date_sequence
               );


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
       WHERE config_name = 'ASSEMBLY_WORKSTAGE_ISSUE_YN'
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

   IF lvs_config_value = 'N'
   THEN
      NULL;
   ELSE
      BEGIN
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
                  'C' /*IN VARCHAR2*/,
                  :OLD.organization_id                           /*IN NUMBER*/
               );

         IF lvi_return < 0
         THEN
            raise_application_error (-20003,    'Child Item Issue '
                                             || SQLERRM);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20003,    'Child Item Issue '
                                             || SQLERRM);
      END;
   END IF;
------------------------------------------------------------

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error (-20003, SQLERRM);
   WHEN OTHERS
   THEN
      raise_application_error (
         -20003,
            'Plan Date ='
         || :OLD.plan_date
         || 'Plan Sequence='
         || :OLD.plan_date_sequence
         || ' '
         || SQLERRM
      );
END;