FUNCTION "F_GET_MOUNT_TABLE_NO" 
  (
    p_line_code    IN varchar2,
    p_machine_code IN varchar2,
    p_table_code   IN varchar2
  )
  RETURN  varchar2 IS

   ls_return   VARCHAR2(100);

BEGIN

    -- 01 ？？
    IF p_line_code in ('01') THEN

       -- 1？？？
       IF   substr(p_machine_code,-2) = '01' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'A';
          ELSIF p_table_code = '2' THEN
                ls_return := 'B';
          ELSIF p_table_code = '3' THEN
                ls_return := 'C';
          ELSIF p_table_code = '4' THEN
                ls_return := 'D';
          ELSE
                ls_return := p_table_code;
          END IF;

       -- 2？？？
       ELSIF substr(p_machine_code,-2) = '02' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'E';
          ELSIF p_table_code = '2' THEN
                ls_return := 'F';
          ELSIF p_table_code = '3' THEN
                ls_return := 'G';
          ELSIF p_table_code = '4' THEN
                ls_return := 'H';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '03' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'I';
          ELSIF p_table_code = '2' THEN
                ls_return := 'J';
          ELSIF p_table_code = '3' THEN
                ls_return := 'K';
          ELSIF p_table_code = '4' THEN
                ls_return := 'L';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '04' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'N';
          ELSIF p_table_code = '2' THEN
                ls_return := 'M';
          ELSIF p_table_code = '3' THEN
                ls_return := 'O';
          ELSIF p_table_code = '4' THEN
                ls_return := 'P';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '05' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'Q';
          ELSIF p_table_code = '2' THEN
                ls_return := 'R';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSE

          ls_return := p_table_code;

       END IF;

    ELSIF p_line_code in ('05','06','07') THEN

       IF   substr(p_machine_code,-2) = '01' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'A';
          ELSIF p_table_code = '2' THEN
                ls_return := 'B';
          ELSIF p_table_code = '3' THEN
                ls_return := 'C';
          ELSIF p_table_code = '4' THEN
                ls_return := 'D';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '02' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'E';
          ELSIF p_table_code = '2' THEN
                ls_return := 'F';
          ELSIF p_table_code = '3' THEN
                ls_return := 'G';
          ELSIF p_table_code = '4' THEN
                ls_return := 'H';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '03' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'I';
          ELSIF p_table_code = '2' THEN
                ls_return := 'J';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '04' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'K';
          ELSIF p_table_code = '2' THEN
                ls_return := 'L';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSIF substr(p_machine_code,-2) = '05' THEN

          IF    p_table_code = '1' THEN
                ls_return := 'M';
          ELSE
                ls_return := p_table_code;
          END IF;

       ELSE

           ls_return := p_table_code;

       END IF;

    ELSE

       ls_return := p_table_code;

    END IF;

    return ls_return;

EXCEPTION
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;