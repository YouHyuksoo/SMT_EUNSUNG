FUNCTION "F_CHECK_FEEDER_STATUS" (p_barcode IN VARCHAR2)
   RETURN VARCHAR2
IS
-- ---------   ------  -------------------------------------------
   lvs_status              VARCHAR2 (10);
   lvs_mold_group          VARCHAR2 (10);
   lvdt_last_adjust_date   DATE;
BEGIN
   BEGIN
      SELECT mold_group
        INTO lvs_mold_group
        FROM imcn_mold
       WHERE mold_code = (SELECT mold_code
                            FROM imcn_mold_inventory
                           WHERE barcode = p_barcode);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'NotFound';
   END;

   IF lvs_mold_group = 'PD'
   THEN
      SELECT last_adjust_date
        INTO lvdt_last_adjust_date
        FROM imcn_mold_inventory
       WHERE barcode = p_barcode;

      IF NVL (lvdt_last_adjust_date, SYSDATE) < SYSDATE - 60
      THEN
         RETURN 'T';
      ELSE
         SELECT mold_use_status
           INTO lvs_status
           FROM imcn_mold_inventory
          WHERE barcode = p_barcode;

         RETURN lvs_status;
      END IF;
   ELSE
      SELECT CASE
                WHEN NVL (break_value, 200000) - NVL (actual_value, 0) > 0
                   THEN 'U'
                ELSE 'T'
             END
        INTO lvs_status
        FROM imcn_mold_inventory
       WHERE barcode = p_barcode;
   END IF;

   RETURN lvs_status;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'NotFound';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;