FUNCTION "F_GET_SUPPLIER_CODE_BY_ITEM" (
   p_item_code   IN   VARCHAR2,
   p_line_type   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
-- ---------   ------  -------------------------------------------
   lvs_supplier_code   VARCHAR2 (20);
   lvi_count           NUMBER;
BEGIN
   IF p_line_type = 'F'
   THEN
      BEGIN
         SELECT COUNT (*), MAX (supplier_code)
           INTO lvi_count, lvs_supplier_code
           FROM im_item_unit_price
          WHERE item_code = p_item_code
            AND line_type = p_line_type
            AND dateset <= TRUNC (SYSDATE)
            AND dateend >= TRUNC (SYSDATE)
            AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_count := 0;
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF lvi_count >= 1
      THEN
         RETURN lvs_supplier_code;
      ELSE
         BEGIN
            SELECT supplier_code
              INTO lvs_supplier_code
              FROM id_item
             WHERE item_code = p_item_code
               AND line_type = p_line_type
               AND organization_id = p_org;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RETURN '*';
         END;
      END IF;

      RETURN lvs_supplier_code;
   ELSE
      BEGIN
         SELECT COUNT (*), MAX (supplier_code)
           INTO lvi_count, lvs_supplier_code
           FROM im_item_unit_price
          WHERE item_code = p_item_code
            AND line_type = p_line_type
            AND dateset <= TRUNC (SYSDATE)
            AND dateend >= TRUNC (SYSDATE)
            AND organization_id = p_org
            AND supplier_code IN NVL ((SELECT MAX (supplier_code)
                                         FROM im_item_master
                                        WHERE item_code = p_item_code
                                          AND line_type = p_line_type
                                          AND organization_id = p_org
                                          AND main_vendor_yn = 'Y'),
                                      supplier_code
                                     );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvi_count := 0;
         WHEN OTHERS
         THEN
            raise_application_error (-20003, SQLERRM);
      END;

      IF lvi_count >= 1
      THEN
         RETURN lvs_supplier_code;
      ELSE
         RETURN '*';
      END IF;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'NOTFOUND';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;