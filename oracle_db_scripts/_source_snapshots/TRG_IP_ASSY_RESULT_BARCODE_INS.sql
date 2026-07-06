TRIGGER "INFINITY21_JSMES"."TRG_IP_ASSY_RESULT_BARCODE_INS" 
 BEFORE
  INSERT
 ON ip_assembly_result_barcode
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvi_exists   NUMBER;
BEGIN
   IF :NEW.enter_by = 'ADMIN2'
   THEN
      NULL;
   ELSE
      BEGIN
         SELECT COUNT (*)
           INTO lvi_exists
           FROM ip_assembly_result
          WHERE plan_date = :NEW.plan_date
            AND plan_date_sequence = :NEW.plan_date_sequence
            AND lqc_inspect_result = :NEW.lqc_inspect_result
            AND organization_id = :NEW.organization_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_exists := 0;
      END;

      IF lvi_exists = 0
      THEN
         INSERT INTO ip_assembly_result
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
         UPDATE ip_assembly_result
            SET product_actual_qty =
                                  product_actual_qty
                                + :NEW.product_actual_qty
          WHERE plan_date = :NEW.plan_date
            AND plan_date_sequence = :NEW.plan_date_sequence
            AND organization_id = :NEW.organization_id;
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;