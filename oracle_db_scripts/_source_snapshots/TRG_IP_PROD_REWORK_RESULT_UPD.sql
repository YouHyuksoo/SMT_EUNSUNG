TRIGGER "INFINITY21_JSMES"."TRG_IP_PROD_REWORK_RESULT_UPD" 
 BEFORE
   UPDATE OF lqc_inspect_result, oqc_inspect_result
 ON ip_product_rework_result
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt   NUMBER;
BEGIN
   IF :NEW.lqc_inspect_result = 'W'
   THEN
      NULL;
   ELSIF      :NEW.lqc_inspect_result = 'P'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
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
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.lqc_inspect_result = 'R'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
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
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.lqc_inspect_result = 'U'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
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
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   END IF;

   IF :NEW.oqc_inspect_result = 'W'
   THEN
      NULL;
   ELSIF      :NEW.oqc_inspect_result = 'P'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
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
                   :NEW.oqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'P',
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.oqc_inspect_result = 'R'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
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
                   :NEW.oqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'R',
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   ELSIF      :NEW.oqc_inspect_result = 'U'
          AND :NEW.lqc_inspect_result <> :OLD.lqc_inspect_result
   THEN
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
                   :NEW.oqc_inspect_no,
                   :OLD.mfs,
                   :OLD.item_code,
                   0,
                   'U',
                   0,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by,
                   :NEW.last_modify_date,
                   :NEW.last_modify_by
                  );
   END IF;
END;