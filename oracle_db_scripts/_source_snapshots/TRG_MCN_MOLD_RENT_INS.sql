TRIGGER "INFINITY21_JSMES"."TRG_MCN_MOLD_RENT_INS" 
 AFTER
  INSERT
 ON imcn_mold_rent
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
   lvl_cnt                     NUMBER       := 0;
   lvs_currency                VARCHAR2 (3);
   lvs_local_currency          VARCHAR2 (3);
   lvf_exchange_rate           NUMBER       := 0;
   lvf_unit_price              NUMBER       := 0;
   lvs_delivery                VARCHAR (10);
   lvi_count                   NUMBER       := 0;
   lvf_last_dd_avg_price       NUMBER       := 0;
   lvf_last_dd_inventory_qty   NUMBER       := 0;
   lvf_last_dd_inventory_amt   NUMBER       := 0;
   lvf_mm_rent_qty             NUMBER       := 0;
   lvf_mm_issue_amt            NUMBER       := 0;
   lvf_mm_receipt_qty          NUMBER       := 0;
   lvf_mm_receipt_amt          NUMBER       := 0;
   phase                       NUMBER;
BEGIN
   BEGIN
      SELECT COUNT (*)
        INTO lvl_cnt
        FROM imcn_mold_inventory
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id
         AND NVL (rent_status, 'N') = 'N'OR rent_status = 'W'
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;

   IF lvl_cnt < 1
   THEN
      raise_application_error (
         -20003,
            'Mold Code Not Found in Mold Mastert AA '
         || SQLERRM
      );
   ELSE
      UPDATE imcn_mold_inventory
         SET inventory_qty =   NVL (inventory_qty, 0)
                             - :NEW.rent_qty,
             inventory_amt =
                            inventory_amt
                          - (:NEW.rent_qty * inventory_price),
             mold_in_out = DECODE (:NEW.rent_status, 'N', 'O', 'I'),
             last_issue_date =
                      DECODE (:NEW.rent_status, 'N', SYSDATE, last_issue_date),
             last_receipt_date =
                    DECODE (:NEW.rent_status, 'C', SYSDATE, last_receipt_date),
             machine_code = '*',
             workstage_code = '*',
             line_code = '*',
             rent_supplier_code = :NEW.supplier_code,
             mold_rent_location_code = :NEW.mold_rent_location_code,
             rent_status = :NEW.rent_status
       WHERE mold_code = :NEW.mold_code
         AND mold_version = :NEW.mold_version
         AND mold_set_serial = :NEW.mold_set_serial
         AND organization_id = :NEW.organization_id;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;