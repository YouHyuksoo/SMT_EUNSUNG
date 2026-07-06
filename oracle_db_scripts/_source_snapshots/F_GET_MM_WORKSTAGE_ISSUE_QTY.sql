FUNCTION "F_GET_MM_WORKSTAGE_ISSUE_QTY" (
   as_line_code        IN   VARCHAR2,
   as_workstage_code   IN   VARCHAR2,
   as_mfs              IN   VARCHAR2,
   as_material_mfs     IN   VARCHAR2,
   as_item_code        IN   VARCHAR2,
   as_yyyymm           IN   VARCHAR2,
   as_flag             IN   VARCHAR2,
   ai_org              IN   NUMBER
)
   RETURN NUMBER
IS
   al_issue_qty                  NUMBER;
BEGIN
   IF as_flag = 'M'
   THEN
      SELECT SUM(issue_qty)
      INTO   al_issue_qty
      FROM   im_item_workstage_issue
      WHERE  item_code = as_item_code                                            AND
             issue_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) AND
             issue_account = 'M001'                                           AND
             line_code = as_line_code                                            AND
             workstage_code = as_workstage_code                                  AND
             mfs = as_mfs                                                        AND
             material_mfs = as_material_mfs                                      AND
             organization_id = ai_org
--             issue_status = 'N'
             ;
   ELSIF as_flag = 'B'
   THEN
      SELECT SUM(issue_qty)
      INTO   al_issue_qty
      FROM   im_item_workstage_issue
      WHERE  item_code = as_item_code                                            AND
             issue_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) and
             issue_account ='M002'                                           AND
             line_code = as_line_code                                            AND
             workstage_code = as_workstage_code                                  AND
             mfs = as_mfs                                                        AND
             material_mfs = as_material_mfs                                      AND
             organization_id = ai_org
--             issue_status = 'N'
             ;
   ELSIF as_flag = 'F'
   THEN
      SELECT SUM(issue_qty)
      INTO   al_issue_qty
      FROM   im_item_workstage_issue
      WHERE  item_code = as_item_code                                            AND
             issue_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) AND
             issue_account = 'M003'                                           AND
             line_code = as_line_code                                            AND
             workstage_code = as_workstage_code                                  AND
             mfs = as_mfs                                                        AND
             material_mfs = as_material_mfs                                      AND
             organization_id = ai_org
--             issue_status = 'N'
             ;
   ELSIF as_flag = 'E'
   THEN
      SELECT SUM(issue_qty)
      INTO   al_issue_qty
      FROM   im_item_workstage_issue
      WHERE  item_code = as_item_code                                            AND
             issue_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) AND
             issue_account NOT IN ('M001', 'M002', 'M003', 'M004')               AND
             line_code = as_line_code                                            AND
             workstage_code = as_workstage_code                                  AND
             mfs = as_mfs                                                        AND
             material_mfs = as_material_mfs                                      AND
             organization_id = ai_org
--             issue_status = 'N'
              ;
   ELSIF as_flag = 'S'
   THEN
      SELECT SUM(issue_qty)
      INTO   al_issue_qty
      FROM   im_item_workstage_issue
      WHERE  item_code = as_item_code                                            AND
             issue_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) AND
             issue_account = 'M004'                                           AND
             line_code = as_line_code                                            AND
             workstage_code = as_workstage_code                                  AND
             mfs = as_mfs                                                        AND
             material_mfs = as_material_mfs                                      AND
             organization_id = ai_org
--             issue_status = 'N'
             ;
   ELSE
      SELECT SUM(issue_qty)
      INTO   al_issue_qty
      FROM   im_item_workstage_issue
      WHERE  item_code = as_item_code                                            AND
             issue_date BETWEEN F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'START' , organization_id )
			 AND F_GET_INVENTORY_CLOSE_DATE( as_yyyymm , 'END' , organization_id ) AND
             line_code = as_line_code                                            AND
             workstage_code = as_workstage_code                                  AND
             mfs = as_mfs                                                        AND
             material_mfs = as_material_mfs                                      AND
             organization_id = ai_org
--             issue_status = 'N'
             ;
   END IF;

   RETURN NVL(al_issue_qty,0);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error(-20003, SQLERRM);
   WHEN OTHERS
   THEN
      ROLLBACK;
      raise_application_error(-20003, SQLERRM);
END;