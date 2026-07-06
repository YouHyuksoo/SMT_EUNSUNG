FUNCTION "F_GET_SALE_ORDER_UPLOAD2_SQL" (
   p_division   IN   VARCHAR2,
   p_org        IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_sql                       VARCHAR2(2000);
BEGIN
   IF p_division = 'LGERP'
   THEN

      lvs_sql :=
            'SELECT
                NO,
                PART_NO,
                UIT,
                WORK_ORDER,
                REQUEST_DATE,
                PLAN_QTY,
                SUPPLY_SUBINVENTORY,
                SUPPLY_LOCATOR,
                SUPPLY_LINE_CODE,
                FORM_ONHAND_QTY,
                FROM_ONHAND_AVAIL_QTY,
                DEMAND_SUBINVENTORY,
                SUBINVENTORY_DESC,
                DEMAND_LOCATOR,
                DEMAND_LINE_CODE,
                ORIGINAL_REQUEST_QTY,
                ITEM_DESC,
                ITEM_SPEC,
                UPLOAD_YN,
                UPLOAD_DATE,
                CUSTOMER_CODE,
                ORGANIZATION_ID
           FROM IS_PRODUCT_ORDER_UPLOAD2
          WHERE ORGANIZATION_ID ='
            || p_org;
   END IF;

   RETURN lvs_sql;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;