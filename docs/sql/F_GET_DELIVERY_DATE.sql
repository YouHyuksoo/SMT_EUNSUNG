-- Source snapshot fetched via oracle_connector.py --procedure-source (read-only; not executed)
-- Site: ESDBext
-- Object: F_GET_DELIVERY_DATE (FUNCTION)
-- Status at fetch time: INVALID (pre-existing; not caused by this migration)
-- Purpose: read here to confirm it depends on IP_PRODUCT_COMPANY_CALENDAR.HOLIDAY_YN,
-- which is why the 2026-07-14 IP_ calendar migration keeps HOLIDAY_YN instead of dropping it.

CREATE OR REPLACE FUNCTION "F_GET_DELIVERY_DATE" (
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
/
