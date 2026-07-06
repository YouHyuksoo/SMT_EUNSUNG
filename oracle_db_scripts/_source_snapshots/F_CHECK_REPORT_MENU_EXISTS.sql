FUNCTION "F_CHECK_REPORT_MENU_EXISTS" (
   p_datawindow_name   IN   VARCHAR2,
   p_org               IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_yn                        VARCHAR2(1);
   lvi_count                     NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO lvi_count
     FROM isys_report_menu
    WHERE datawindow_name = p_datawindow_name AND
          organization_id = p_org;

   IF lvi_count = 0
   THEN
      RETURN 'N';
   ELSE
      RETURN 'Y';
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'N';
   WHEN OTHERS
   THEN
      raise_application_error(-20003, SQLERRM);
END;