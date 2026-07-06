FUNCTION "F_GET_MM_ISSUE_QTY" (as_item_code   IN VARCHAR2,
/* Formatted on 30-11-2014 14:36:38 (QP5 v5.126) */
                             as_yyyymm      IN VARCHAR2,
                             as_line_type   IN VARCHAR2,
                             as_flag        IN VARCHAR2,
                             adt_dateset In date,
                             adt_dateend in date,
                             ai_org         IN NUMBER)
    RETURN NUMBER
IS
    al_issue_qty   NUMBER;
    lvdt_start     DATE;
    lvdt_end       DATE;

BEGIN


    SELECT   f_get_inventory_close_date (as_yyyymm, 'START', ai_org),
             f_get_inventory_close_date (as_yyyymm, 'END', ai_org)
      INTO   lvdt_start, lvdt_end
      FROM   DUAL;


    IF as_flag = 'M'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE       item_code = as_item_code
         --        AND line_type = as_line_type
                 AND ENTER_DATE BETWEEN lvdt_start AND lvdt_end
                 AND issue_account LIKE 'M001'
                 AND organization_id = ai_org
                 AND issue_status <> 'C';
    ELSIF as_flag = 'B'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE       item_code = as_item_code
                 AND line_type = as_line_type
                AND ENTER_DATE BETWEEN lvdt_start AND lvdt_end
                 AND issue_account LIKE 'M002'
                 AND organization_id = ai_org
                 AND issue_status <> 'C';
    ELSIF as_flag = 'F'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE       item_code = as_item_code
           --      AND line_type = as_line_type
                AND ENTER_DATE BETWEEN lvdt_start AND lvdt_end
                 AND issue_account LIKE 'M003'
                 AND organization_id = ai_org
                 AND issue_status <> 'C';
    ELSIF as_flag = 'E'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE       item_code = as_item_code
           --      AND line_type = as_line_type
                AND ENTER_DATE BETWEEN lvdt_start AND lvdt_end
                 AND issue_account NOT IN ('M001', 'M002', 'M003', 'M004')
                 AND organization_id = ai_org
                 AND issue_status <> 'C';
    ELSIF as_flag = 'S'
    THEN
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE       item_code = as_item_code
           --      AND line_type = as_line_type
                 AND ENTER_DATE BETWEEN lvdt_start AND lvdt_end
                 AND issue_account LIKE 'M004'
                 AND organization_id = ai_org
                 AND issue_status <> 'C';
    ELSE
        SELECT   NVL (SUM (issue_qty), 0)
          INTO   al_issue_qty
          FROM   im_item_issue
         WHERE       item_code = as_item_code
           --      AND line_type = as_line_type
                AND ENTER_DATE BETWEEN lvdt_start AND lvdt_end
                 AND organization_id = ai_org
                 AND issue_status <> 'C';
    END IF;


    RETURN NVL (al_issue_qty, 0);
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        raise_application_error (
            -20003,
               'NO DATA FOUND FLAG='
            || as_flag
            || 'YYYYMM='
            || as_yyyymm
            || '  '
            || SQLERRM);
    WHEN OTHERS
    THEN
        raise_application_error (-20003,
                                 'YYYYMM=' || as_yyyymm || '  ' || SQLERRM);
END;