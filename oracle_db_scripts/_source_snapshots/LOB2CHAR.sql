FUNCTION "LOB2CHAR" (clob_col CLOB)
   RETURN VARCHAR2
IS
   buffer   VARCHAR2 (4000);
   amt      BINARY_INTEGER  := 4000;
   pos      INTEGER         := 1;
   l        CLOB;
   bfils    BFILE;
   l_var    VARCHAR2 (4000) := '';
BEGIN
   LOOP
      IF DBMS_LOB.getlength (clob_col) <= 4000
      THEN
         BEGIN
            NULL;
            EXIT;
--            DBMS_LOB.READ (clob_col, amt, pos, buffer);
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20003, SQLERRM);
         END;

         l_var := l_var || buffer;
         pos := pos + amt;
      ELSE
         l_var :=
               DBMS_LOB.getlength (clob_col)
            || ' '
            || 'Cannot convert.  Exceeded varchar2 limit';
         EXIT;
      END IF;
   END LOOP;

   RETURN l_var;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN l_var;
   WHEN OTHERS
   THEN
      raise_application_error (-20003, SQLERRM);
END;