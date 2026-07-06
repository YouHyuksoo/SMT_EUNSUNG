FUNCTION "F_GET_BILL_DISBURSE_DATE" (
   p_supplier_code   IN   VARCHAR2,
   p_date                 DATE,
   p_org             IN   NUMBER
)
   RETURN DATE
IS
   lvs_payment_CONDITION              VARCHAR2(10);
   lvs_payment_cycle             VARCHAR2(10);
   lvdt_return_date              DATE;
BEGIN
   SELECT NVL(payment_condition, '0'),
          NVL(payment_cycle, '1')
   INTO   lvs_payment_CONDITION,
          lvs_payment_cycle
   FROM   icom_supplier
   WHERE  supplier_code = p_supplier_code AND
          organization_id = p_org;


-------------------------------------------------
--
-------------------------------------------------
   SELECT TO_DATE(
             SUBSTR(to_char(ADD_MONTHS(p_date, TO_NUMBER(lvs_payment_CONDITION)),'yyyymmdd'), 1, 4)
             ||  SUBSTR(to_char(ADD_MONTHS(p_date, TO_NUMBER(lvs_payment_CONDITION)),'yyyymmdd'), 5, 2)
             || lvs_payment_cycle, 'yyyymmdd'
          )
   INTO   lvdt_return_date
   FROM   DUAL;
   RETURN lvdt_return_date;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN p_date;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;