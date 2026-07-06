FUNCTION "F_GET_LOCAL_CURRENCY" (p_org IN NUMBER)
   RETURN VARCHAR2
IS
   lvs_local_currency   VARCHAR2 (3);
BEGIN
   SELECT code_name
     INTO lvs_local_currency
     FROM isys_basecode
    WHERE code_type = 'LOCAL CURRENCY'
      AND organization_id = p_org;

   RETURN lvs_local_currency;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 'NOTFOUND';
   WHEN OTHERS THEN
      raise_application_error (-20003, SQLERRM);
END;