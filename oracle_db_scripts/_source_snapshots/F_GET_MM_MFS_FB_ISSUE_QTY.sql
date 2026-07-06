FUNCTION "F_GET_MM_MFS_FB_ISSUE_QTY" (
   as_material_mfs   IN   VARCHAR2,
   as_item_code      IN   VARCHAR2,
   as_yyyymm         IN   VARCHAR2,
   as_line_type      IN   VARCHAR2,
   as_flag           IN   VARCHAR2,
   ai_org            IN   NUMBER
)
   RETURN NUMBER
IS
   al_issue_qty                  NUMBER;
BEGIN
   IF as_flag = 'M'
   THEN
      SELECT NVL(SUM(issue_qty), 0)
      INTO   al_issue_qty
      FROM   im_item_fback_issue
      WHERE      item_code = as_item_code
             AND line_type = as_line_type
             AND material_mfs = as_material_mfs
             AND issue_date
                    BETWEEN f_get_inventory_close_date(
                               as_yyyymm, 'START', organization_id
                            )
                        AND f_get_inventory_close_date(
                               as_yyyymm, 'END', organization_id
                            )
             AND issue_account LIKE 'M001'
             AND organization_id = ai_org;

--             issue_status <> 'C';
   ELSIF as_flag = 'B'
   THEN
      SELECT NVL(SUM(issue_qty), 0)
      INTO   al_issue_qty
      FROM   im_item_fback_issue
      WHERE      item_code = as_item_code
             AND line_type = as_line_type
             AND material_mfs = as_material_mfs
             AND issue_date
                    BETWEEN f_get_inventory_close_date(
                               as_yyyymm, 'START', organization_id
                            )
                        AND f_get_inventory_close_date(
                               as_yyyymm, 'END', organization_id
                            )
             AND issue_account LIKE 'M002'
             AND organization_id = ai_org;

--             issue_status <> 'C';
   ELSIF as_flag = 'F'
   THEN
      SELECT NVL(SUM(issue_qty), 0)
      INTO   al_issue_qty
      FROM   im_item_fback_issue
      WHERE      item_code = as_item_code
             AND line_type = as_line_type
             AND material_mfs = as_material_mfs
             AND issue_date
                    BETWEEN f_get_inventory_close_date(
                               as_yyyymm, 'START', organization_id
                            )
                        AND f_get_inventory_close_date(
                               as_yyyymm, 'END', organization_id
                            )
             AND issue_account LIKE 'M003'
             AND organization_id = ai_org;

--             issue_status <> 'C';
   ELSIF as_flag = 'E'
   THEN
      SELECT NVL(SUM(issue_qty), 0)
      INTO   al_issue_qty
      FROM   im_item_fback_issue
      WHERE      item_code = as_item_code
             AND line_type = as_line_type
             AND material_mfs = as_material_mfs
             AND issue_date
                    BETWEEN f_get_inventory_close_date(
                               as_yyyymm, 'START', organization_id
                            )
                        AND f_get_inventory_close_date(
                               as_yyyymm, 'END', organization_id
                            )
             AND issue_account NOT IN ('M001', 'M002', 'M003', 'M004')
             AND organization_id = ai_org;

--             issue_status <> 'C';
   ELSIF as_flag = 'S'
   THEN
      SELECT NVL(SUM(issue_qty), 0)
      INTO   al_issue_qty
      FROM   im_item_fback_issue
      WHERE      item_code = as_item_code
             AND line_type = as_line_type
             AND material_mfs = as_material_mfs
             AND issue_date
                    BETWEEN f_get_inventory_close_date(
                               as_yyyymm, 'START', organization_id
                            )
                        AND f_get_inventory_close_date(
                               as_yyyymm, 'END', organization_id
                            )
             AND issue_account LIKE 'M004'
             AND organization_id = ai_org;

--             issue_status <> 'C';
   ELSE
      SELECT NVL(SUM(issue_qty), 0)
      INTO   al_issue_qty
      FROM   im_item_fback_issue
      WHERE      item_code = as_item_code
             AND line_type = as_line_type
             AND material_mfs = as_material_mfs
             AND issue_date
                    BETWEEN f_get_inventory_close_date(
                               as_yyyymm, 'START', organization_id
                            )
                        AND f_get_inventory_close_date(
                               as_yyyymm, 'END', organization_id
                            )
             AND organization_id = ai_org;

--             issue_status <> 'C';
   END IF;

   RETURN NVL(al_issue_qty, 0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(
         -20003, 'NO DATA FOUND FLAG=' || as_flag || 'YYYYMM=' || as_yyyymm
                 || '  ' || SQLERRM
      );
   WHEN OTHERS
   THEN
      raise_application_error(-20003, 'YYYYMM=' || as_yyyymm || '  ' || SQLERRM);
END;