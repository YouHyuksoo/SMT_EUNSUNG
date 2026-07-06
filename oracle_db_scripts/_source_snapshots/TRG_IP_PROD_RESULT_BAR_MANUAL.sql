TRIGGER "INFINITY21_JSMES"."TRG_IP_PROD_RESULT_BAR_MANUAL" 
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