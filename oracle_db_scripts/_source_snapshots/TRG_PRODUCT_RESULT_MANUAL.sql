TRIGGER "INFINITY21_JSMES"."TRG_PRODUCT_RESULT_MANUAL" 
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