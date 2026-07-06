FUNCTION "F_GET_DELIVERY_DATE" (
   p_date   IN   DATE,
   p_org    IN   NUMBER
)
   RETURN DATE
IS
   lvdt_date                     DATE;
-- Declare program variables as shown above
BEGIN
   SELECT MAX(plan_date)
   INTO   lvdt_date
   FROM   ip_product_company_calendar
   WHERE  plan_date = (SELECT MAX(plan_date)
                       FROM   ip_product_company_calendar
                       WHERE  plan_date <= p_date     AND
                              holiday_yn = 'N'        AND
                              organization_id = p_org)    AND
          organization_id = p_org;
   RETURN lvdt_date;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN p_date;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;