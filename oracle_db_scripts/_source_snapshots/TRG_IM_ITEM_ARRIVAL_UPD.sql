TRIGGER "INFINITY21_JSMES"."TRG_IM_ITEM_ARRIVAL_UPD" 
 BEFORE
   UPDATE OF inspect_result
 ON im_item_arrival
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
 WHEN (
NEW.inspect_result = 'U'
         OR NEW.inspect_result = 'P'
         OR NEW.inspect_result = 'R'
         OR NEW.inspect_result = 'W'
      ) DECLARE
   lvl_cnt   NUMBER;
BEGIN
   IF :NEW.inspect_result = 'W'
   THEN
      DELETE FROM iq_item_iqc
            WHERE iqc_inspect_no = :OLD.iqc_inspect_no
              AND organization_id = :OLD.organization_id;

      DELETE FROM iq_item_iqc_bad
            WHERE iqc_inspect_no = :OLD.iqc_inspect_no
              AND organization_id = :OLD.organization_id;
   ELSIF    :NEW.inspect_result = 'P'
         OR :NEW.inspect_result = 'U'
   THEN
      INSERT INTO iq_item_iqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   iqc_inspect_no,
                   supplier_code,
                   destroy_qty,
                   mfs,
                   item_code,
                   arrival_qty,
                   inspect_lot_qty,
                   inspect_bad_lot_qty,
                   inspect_qty,
                   inspect_bad_qty,
                   inspect_result,
                   product_date,
                   departure_date,
                   arrival_date,
                   arrival_seq_no,
                   inspect_by,
                   iqc_improve_no,
                   destroy_reason_code,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   inspect_method
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_iqc_inspect.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.iqc_inspect_no,
                   :OLD.supplier_code,
                   0, -- DESTROY_QTY,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.arrival_qty,
                   1,
                   0,
                   f_get_inspect_sample_qty (
                      :OLD.arrival_qty,
                      :OLD.organization_id
                   ), --ROUND(:OLD.ARRIVAL_QTY * 0.1,0) ,
                   0,
                   :NEW.inspect_result,
                   :OLD.product_date,
                   :OLD.departure_date,
                   :OLD.arrival_date,
                   :OLD.arrival_seq_no,
                   :NEW.last_modify_by,
                   '',
                   '',
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   (SELECT inspect_method
                      FROM im_item_master
                     WHERE item_code = :OLD.item_code
                       AND supplier_code = :OLD.supplier_code
                       AND organization_id = :OLD.organization_id)
                  );
   ELSE
      -- INSET INTO NEW INSPECT RESULT RETURN
      INSERT INTO iq_item_iqc
                  (inspect_date,
                   inspect_sequence,
                   organization_id,
                   iqc_inspect_no,
                   supplier_code,
                   destroy_qty,
                   mfs,
                   item_code,
                   arrival_qty,
                   inspect_lot_qty,
                   inspect_bad_lot_qty,
                   inspect_qty,
                   inspect_bad_qty,
                   inspect_result,
                   product_date,
                   departure_date,
                   arrival_date,
                   arrival_seq_no,
                   inspect_by,
                   iqc_improve_no,
                   destroy_reason_code,
                   enter_date,
                   enter_by,
                   last_modify_date,
                   last_modify_by,
                   inspect_method
                  )
           VALUES (TRUNC (SYSDATE),
                   seq_qc_iqc_inspect.NEXTVAL,
                   :OLD.organization_id,
                   :NEW.iqc_inspect_no,
                   :OLD.supplier_code,
                   0, -- DESTROY_QTY,
                   :OLD.mfs,
                   :OLD.item_code,
                   :OLD.arrival_qty,
                   1,
                   1,
                   f_get_inspect_sample_qty (
                      :OLD.arrival_qty,
                      :OLD.organization_id
                   ), --INSPECT_QTY,
                   0,
                   :NEW.inspect_result,
                   :OLD.product_date,
                   :OLD.departure_date,
                   :OLD.arrival_date,
                   :OLD.arrival_seq_no,
                   :NEW.last_modify_by,
                   '',
                   '',
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   (SELECT inspect_method
                      FROM im_item_master
                     WHERE item_code = :OLD.item_code
                       AND supplier_code = :OLD.supplier_code
                       AND organization_id = :OLD.organization_id)
                  );
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;