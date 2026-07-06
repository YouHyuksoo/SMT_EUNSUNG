FUNCTION "F_GET_DUAL_LANG_TEXT" (
   p_text   IN   VARCHAR2,
   p_lang   IN   VARCHAR2,
   p_org    IN   NUMBER
)
   RETURN VARCHAR2
IS
   lvs_text                      VARCHAR2(100);
BEGIN
   SELECT DECODE(p_lang, 'E', english_origin_text, 'K', korea_text,
                                                                  local_text)
   INTO   lvs_text
   FROM   isys_dual_language
   WHERE      english_text = UPPER(p_text)
          AND organization_id = p_org;
   RETURN lvs_text;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN p_text;
END;