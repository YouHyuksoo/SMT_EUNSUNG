FUNCTION "F_BACODE_CODE128" ( p_code_type IN VARCHAR2, p_sourcetext IN VARCHAR2)
  RETURN  NVARCHAR2 IS lvs_return NVARCHAR2(100);
   -- Declare program variables as shown above
   lvi_asc_total    NUMBER;
   lvi_asc_temp     NUMBER;
   lvi_check_digit  NUMBER;
   i                NUMBER;
   lvc_start        NCHAR;
   lvc_stop         NCHAR;
   lvs_check_digit  NVARCHAR2(1);

BEGIN

    CASE p_code_type
    WHEN 'A' THEN
        lvi_asc_total := 104;
        lvc_start := NCHR(209);  --code128B
        lvc_stop  := NCHR(211);

        i :=1;

        WHILE i <= LENGTH(p_sourcetext) loop    --check_code
        lvi_asc_temp := ASCII(SUBSTR(p_sourcetext,i,1));
        if lvi_asc_temp >= 32 then
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp - 32)*i;
        else
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp + 64 )*i;
        end if;
        i := i +1;
        end loop;

        lvi_check_digit :=MOD(lvi_asc_total , 103);
        if lvi_check_digit >= 95 then   --
            lvi_check_digit := lvi_check_digit + 100;
        ELSE
            lvi_check_digit := lvi_check_digit + 32;
        end if;

        lvs_check_digit := nchr(lvi_check_digit);

        lvs_return := lvc_start || p_sourcetext || lvs_check_digit || lvc_stop;
        RETURN lvs_return;
        RETURN lvs_return;
    WHEN 'B' THEN
        lvi_asc_total := 104;
         lvc_start := CHR(204 USING NCHAR_CS) ; -- NCHR(204);  --code128B
        lvc_stop  := CHR(206 USING NCHAR_CS) ; -- NCHR(206);

        i :=1;

        WHILE i <= LENGTH(p_sourcetext) loop    --check_code
        lvi_asc_temp := ASCII(SUBSTR(p_sourcetext,i,1));
        if lvi_asc_temp >= 32 then
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp - 32)*i;
        else
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp + 64 )*i;
        end if;
        i := i +1;
        end loop;

        lvi_check_digit :=MOD(lvi_asc_total , 103);
        if lvi_check_digit >= 95 then   --
            lvi_check_digit := lvi_check_digit + 100;
        ELSE
            lvi_check_digit := lvi_check_digit + 32;
        end if;

        --lvs_check_digit := nchr(lvi_check_digit);
        lvs_check_digit := CHR(lvi_check_digit USING NCHAR_CS);

        lvs_return := lvc_start || p_sourcetext || lvs_check_digit || lvc_stop;
        RETURN lvs_return;
    WHEN 'C' THEN
        lvi_asc_total := 104;
        lvc_start := NCHR(204);  --code128B
        lvc_stop  := NCHR(206);

        i :=1;

        WHILE i <= LENGTH(p_sourcetext) loop    --check_code
        lvi_asc_temp := ASCII(SUBSTR(p_sourcetext,i,1));
        if lvi_asc_temp >= 32 then
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp - 32)*i;
        else
            lvi_asc_total := lvi_asc_total + (lvi_asc_temp + 64 )*i;
        end if;
        i := i +1;
        end loop;

        lvi_check_digit :=MOD(lvi_asc_total , 103);
        if lvi_check_digit >= 95 then   --
            lvi_check_digit := lvi_check_digit + 100;
        ELSE
            lvi_check_digit := lvi_check_digit + 32;
        end if;

        lvs_check_digit := nchr(lvi_check_digit);

        lvs_return := lvc_start || p_sourcetext || lvs_check_digit || lvc_stop;
        RETURN lvs_return;
    ELSE
        RETURN lvc_start ;
    END CASE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;