FUNCTION "F_GET_MODEL_NAME" 
  ( p_line_code IN varchar2)
  RETURN  varchar2 IS

    lvs_model_name   VARCHAR2(15);
    lvs_from_date    VARCHAR2(14);
    lvs_to_date      VARCHAR2(14);


    lvd_fdate        DATE;
    lvd_tdate        DATE;


BEGIN

     IF TO_CHAR (SYSDATE, 'HH24MI') < '0820'
     THEN

           --생산실적용 Date
           lvd_fdate     := TO_DATE (TO_CHAR (SYSDATE - 1, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI');
           lvd_tdate     := TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI');

           lvs_from_date := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE - 1, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');
           lvs_to_date   := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');

     ELSE

           --생산실적용 Date
           lvd_fdate     := TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI');
           lvd_tdate     := TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI');

           lvs_from_date := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '0820', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');
           lvs_to_date   := TO_CHAR (TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || '2020', 'YYYYMMDDHH24MI'),'YYYYMMDDHH24MI');

     END IF;

    /* IF p_line_code = '41' OR  p_line_code = '42' OR p_line_code = '43' OR  p_line_code = '44' OR  p_line_code = '45' OR  p_line_code = '46'
     THEN --기판라인
        BEGIN
          SELECT DISTINCT MODEL
            INTO lvs_model_name
            FROM TB_VIS_TSTRSLT
           WHERE ITEM_CODE     IN ( SELECT ITEM_CODE
                                    FROM IP_PRODUCT_MASTER_PLAN
                                   WHERE PLAN_DATE   >= TRUNC(lvd_fdate)
                                     AND PLAN_DATE   <= TRUNC(lvd_tdate)
                                     AND LINE_CODE   = p_line_code )
             AND CREATED_DATE  = ( SELECT MAX(CREATED_DATE)
                                    FROM TB_VIS_TSTRSLT
                                   WHERE ITEM_CODE     IN ( SELECT ITEM_CODE
                                                            FROM IP_PRODUCT_MASTER_PLAN
                                                           WHERE PLAN_DATE   >= TRUNC(lvd_fdate)
                                                             AND PLAN_DATE   <= TRUNC(lvd_tdate)
                                                             AND LINE_CODE   = p_line_code )
                                    AND CREATED_DATE  >= lvs_from_date
                                    AND CREATED_DATE  <= lvs_to_date
                                    AND RESULT         = 'P'
                                    AND OPERATIONNAME = 'PCB2100' )
            AND RESULT         = 'P'
            AND OPERATIONNAME = 'PCB2100'
            and rownum = 1 ;
        EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                     lvs_model_name := '';
        END;
     ELSE*/
         BEGIN

           SELECT MODEL_NAME
             INTO lvs_model_name
             FROM IP_PRODUCT_LINE
            WHERE line_code = p_line_code;

         EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                     lvs_model_name := '';
         END;
    /* END IF;*/


     RETURN lvs_model_name ;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RETURN '';
   WHEN others THEN
       raise_application_error( -20003 , sqlerrm ) ;
END;