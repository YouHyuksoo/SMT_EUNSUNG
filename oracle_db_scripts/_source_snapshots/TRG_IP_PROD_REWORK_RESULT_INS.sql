TRIGGER "INFINITY21_JSMES"."TRG_IP_PROD_REWORK_RESULT_INS" 
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