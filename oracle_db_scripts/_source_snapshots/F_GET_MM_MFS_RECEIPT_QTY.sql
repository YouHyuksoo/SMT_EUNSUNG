FUNCTION "F_GET_MM_MFS_RECEIPT_QTY" (as_material_mfs   IN VARCHAR2,
as_location_code   IN VARCHAR2,
                                   as_item_code      IN VARCHAR2,
                                   as_yyyymm         IN VARCHAR2,
                                   as_line_type      IN VARCHAR2,
                                   adt_dateset       IN DATE,
                                   adt_dateend       IN DATE,
                                   p_org             IN NUMBER)
    RETURN NUMBER
IS
    al_receipt_qty     NUMBER;
    lvs_config_value   VARCHAR2 (1);
BEGIN
 /*   ------------------------------------
    -- SYSTEM CONFIG VALUE GET
    -- CURRENT VALUE = Y
    ------------------------------------
    BEGIN
        SELECT   NVL (config_value, 'N')
          INTO   lvs_config_value
          FROM   isys_config
         WHERE       config_name = 'MATERIAL_MFS_REPLACE_LOCATION'
                 AND use_yn = 'Y'
                 AND organization_id = p_org;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            lvs_config_value := 'N';
        WHEN OTHERS
        THEN
            raise_application_error (-20003, SQLERRM);
    END;
*/
   /* IF lvs_config_value = 'N' OR lvs_config_value IS NULL
    THEN
        lvs_config_value := 'N';
    END IF;
*/
    SELECT   SUM (NVL (receipt_qty, 0))
      INTO   al_receipt_qty
      FROM   im_item_receipt
     WHERE    material_mfs=  as_material_mfs
             AND item_code = as_item_code
             AND line_type = as_line_type
             AND location_code = as_location_code
             AND ENTER_DATE BETWEEN adt_dateset AND adt_dateend
             AND organization_id = p_org;

    RETURN NVL (al_receipt_qty, 0);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (-20003, SQLERRM);
    WHEN OTHERS
    THEN
        ROLLBACK;
        raise_application_error (-20003, SQLERRM);
END;