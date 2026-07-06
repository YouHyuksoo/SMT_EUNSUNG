FUNCTION "F_SET_FEEDER_SHAFT_CHANGE" (
   P_LINE_CODE       IN VARCHAR2,
   P_S_SHAFT         IN VARCHAR2,
   P_D_SHAFT         IN VARCHAR2,
   P_LOCATION_CODE   IN VARCHAR2)
   RETURN VARCHAR2
IS
   LVS_RETURN   VARCHAR2(30);
   LVS_TABLE    VARCHAR2 (10);
   LVS_TRIM1    VARCHAR2 (10);
   LVS_TRIM2    VARCHAR2 (10);
   LVS_TRIM3    VARCHAR2 (10);
   PHASE        VARCHAR2 (10);
BEGIN
   PHASE := '10';
   LVS_TABLE :=
      SUBSTR (P_LOCATION_CODE, 1, INSTR (P_LOCATION_CODE, 'T', 1) - 1);

   IF p_d_shaft IN ('A', 'C', 'E')
   THEN
      LVS_RETURN := p_location_code;
   ELSE
      PHASE := '20';

      -- ？？？？？+ 10

      IF LVS_TABLE IN ('1', '3', '5', '7', '9', '11')
      THEN
         LVS_TRIM1 :=
            SUBSTR (p_location_code, 1, INSTR (p_location_code, 'T', 1));
         PHASE := '30';
         LVS_TRIM2 :=
            TO_CHAR (
               TO_NUMBER (
                  TRIM (
                     SUBSTR (p_location_code,
                             INSTR (p_location_code, 'T', 1) + 1,
                             2)))
               + 10,
               '00');
         PHASE := '40';
         LVS_TRIM3 :=
            SUBSTR (p_location_code, INSTR (p_location_code, 'T', 1) + 3, 1);
         PHASE := '50';
          LVS_RETURN := TRIM(LVS_TRIM1) || TRIM(LVS_TRIM2) || TRIM(LVS_TRIM3);
      ELSIF LVS_TABLE IN ('2', '4', '6', '8', '10', '12') THEN
         PHASE := '60';
         LVS_TRIM1 :=
            SUBSTR (p_location_code, 1, INSTR (p_location_code, 'T', 1));
         PHASE := '70';
         LVS_TRIM2 :=
            TO_CHAR (
               TO_NUMBER (
                  TRIM (
                     SUBSTR (p_location_code,
                             INSTR (p_location_code, 'T', 1) + 1,
                             2)))
               - 10,
               '00');
         PHASE := '80';
         LVS_TRIM3 :=
            SUBSTR (p_location_code, INSTR (p_location_code, 'T', 1) + 3, 1);
         PHASE := '90';
          LVS_RETURN := TRIM(LVS_TRIM1) || TRIM(LVS_TRIM2) || TRIM(LVS_TRIM3);
      ELSE

           LVS_RETURN := p_location_code;

      END IF;


      PHASE := '110';
   END IF;


   PHASE := '120';
   RETURN LVS_RETURN;
   PHASE := '130';
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN p_location_code;
   WHEN OTHERS
   THEN
      RAISE_application_error (
         -20003,
            'PHASE='
         || PHASE
         || ' '
         || 'TABLE='
         || LVS_TABLE
         || ' T1='
         || LVS_TRIM1
         || ' T2='
         || LVS_TRIM2
         || ' T3='
         || LVS_TRIM3
         || ' LOC='
         || p_location_code
         || ' '
         || SQLERRM);
END;