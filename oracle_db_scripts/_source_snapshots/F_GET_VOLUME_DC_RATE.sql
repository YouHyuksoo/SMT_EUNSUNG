FUNCTION "F_GET_VOLUME_DC_RATE" (
   p_customer_code   IN   VARCHAR2,
   p_org             IN   NUMBER
)
   RETURN NUMBER
IS
   lvf_rate                      NUMBER;
BEGIN
   SELECT NVL(volume_dc_rate, 0)
     INTO lvf_rate
     FROM icom_customer
    WHERE customer_code = p_customer_code AND
          organization_id = p_org;

   RETURN lvf_rate;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;