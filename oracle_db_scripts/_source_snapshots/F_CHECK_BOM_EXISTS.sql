FUNCTION "F_CHECK_BOM_EXISTS" (
   p_item_code   IN   VARCHAR2,
   p_org         IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvl_cnt                       NUMBER;
BEGIN

/*-------------------------------------------------------
   BEGIN
      SELECT COUNT(*)
      INTO   lvl_cnt
      FROM   id_eng_bom
      WHERE      child_item_code = p_item_code
             AND child_item_code <> '*'
             AND dateset <= TRUNC(SYSDATE)
             AND dateend >= TRUNC(SYSDATE)
             AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;


-------------------------------------------------------
   IF lvl_cnt = 0
   THEN
      BEGIN
         SELECT COUNT(*)
         INTO   lvl_cnt
         FROM   id_eng_bom
         WHERE      child_item_code = p_item_code
                AND child_item_code <> '*'
                AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvl_cnt := 0;
      END;

      IF lvl_cnt = 0
      THEN
         RETURN 'NOTFOUND';
      ELSE
         RETURN 'EXPIRED';
      END IF;
   ELSE
      RETURN 'EXISTS';
   END IF;
*/

-------------------------------------------------------

   BEGIN
      SELECT COUNT(*)
      INTO   lvl_cnt
      FROM   id_eng_bom
      WHERE      parent_item_code = p_item_code
             AND dateset <= TRUNC(SYSDATE)
             AND dateend >= TRUNC(SYSDATE)
             AND parent_item_code <> '*'
             AND organization_id = p_org;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_cnt := 0;
   END;


-------------------------------------------------------
   IF lvl_cnt = 0
   THEN
      BEGIN
         SELECT COUNT(*)
         INTO   lvl_cnt
         FROM   id_eng_bom
         WHERE      parent_item_code = p_item_code
                AND parent_item_code <> '*'
                AND organization_id = p_org;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lvl_cnt := 0;
      END;

      IF lvl_cnt = 0
      THEN
         RETURN 'NOTFOUND';
      ELSE
         RETURN 'EXPIRED';
      END IF;
   ELSE
      RETURN 'EXISTS';
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;