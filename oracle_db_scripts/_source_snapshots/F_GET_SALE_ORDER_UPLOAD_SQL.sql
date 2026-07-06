FUNCTION "F_GET_SALE_ORDER_UPLOAD_SQL" (
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
                   ORDER_TYPE,
                   ORDER_NO,
                   NEED_BY_DATE,
                   ORDER_DATE,
                   MARKET,
                   ITEM_TYPE,
                   ORDER_QTY,
                   REMAINED_QTY,
                   DEPARTURE_QTY,
                   RECEIVING_QTY,
                   CANCELED_FLAG,
                   SUBINVENTORY,
                   LINE_CODE,
                   WORK_ORDER,
                   ITEM_DESC,
                   ITEM_SPEC,
                   ARRIVAL_SUPPLIER_CODE,
                   ARRIVAL_SUPPLIER_NAME,
                   CURR,
                   UNIT_PRICE,
                   PACKING_UNIT,
                   REQUIRED_QTY,
                   QPA,
                   ISSUE_QTY,
                   ASSEMBLY_PART_NO,
                   DELIVERY_TYPE,
                   REQUESTOR_NAME,
                   REQUEST_DEPT_CODE,
                   MIX_INFO,
                   UPLOAD_YN,
                   UPLOAD_DATE,
                   CUSTOMER_CODE,
                   ORGANIZATION_ID
       FROM IS_PRODUCT_ORDER_UPLOAD
     WHERE ORGANIZATION_ID ='
            || p_org;
   END IF;

   RETURN lvs_sql;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;