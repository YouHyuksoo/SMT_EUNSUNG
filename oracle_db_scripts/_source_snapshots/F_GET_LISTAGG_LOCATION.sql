FUNCTION "F_GET_LISTAGG_LOCATION" (
   P_LINE_CODE    IN VARCHAR2,
   p_model_name   IN VARCHAR2,
   p_item_code    IN VARCHAR2,
   p_pcb_item     IN VARCHAR2 )
   RETURN VARCHAR2
IS
   lvs_return      VARCHAR2 (4000);
   lvs_substring   NUMBER;
   i               NUMBER;
BEGIN
   SELECT listagg (NVL (location_info, '*'), ',')
             WITHIN GROUP (ORDER BY child_item_code, location_info)
             AS location_info
     INTO lvs_return
     FROM (SELECT *
             FROM id_eng_bom_smt
            WHERE     PARENT_ITEM_CODE = p_model_name
                  AND CHILD_ITEM_CODE = p_item_code
                  AND pcb_item = p_pcb_item
                  AND line_code = p_line_code

           ORDER BY child_item_code, location_info)
    WHERE     PARENT_ITEM_CODE = p_model_name
          AND CHILD_ITEM_CODE = p_item_code
          AND pcb_item = p_pcb_item
          AND line_code = p_line_code

   GROUP BY CHILD_ITEM_CODE;


   --
   --   LOOP
   --      i := i + 1;
   --
   --      lvs_substring := SUBSTR (lvs_return, 1, INSTR (lvs_return, ',', 1) - 1);
   --
   --
   --
   --   END LOOP;



   RETURN lvs_return;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN '*';
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;