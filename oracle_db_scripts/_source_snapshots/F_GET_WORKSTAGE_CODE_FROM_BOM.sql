FUNCTION "F_GET_WORKSTAGE_CODE_FROM_BOM" (
   P_parent_item_code IN VARCHAR2,
   p_item_code   IN   VARCHAR2,
   p_date        IN   DATE,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_workstage_code            VARCHAR2(30);
BEGIN
   SELECT MAX(workstage_code)
   INTO   lvs_workstage_code
   FROM   id_eng_bom
   WHERE  parent_item_code LIKE p_parent_item_code AND
          child_item_code = p_item_code AND
          dateset <= p_date             AND
          dateend >= p_date             AND
          organization_id = p_org;
   RETURN lvs_workstage_code;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '';
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;