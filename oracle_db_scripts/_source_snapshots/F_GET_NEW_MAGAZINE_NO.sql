FUNCTION                    "F_GET_NEW_MAGAZINE_NO" 
  ( p_line_code IN varchar2 , p_model_name in varchar2  )
  RETURN  VARCHAR2 IS

   lvs_return     VARCHAR2 (30);
   lvl_sequence   NUMBER;
   pahse          VARCHAR2 (10);
   lvs_ym      VARCHAR2 (1);
LVS_DD VARCHAR2 (1);
BEGIN

----------------------------------------------------------------
-- 홀수 년도 
----------------------------------------------------------------
  if  mod( to_number(to_char(sysdate , 'YYYY')) , 2 ) = 1 then 

         SELECT DECODE (to_char(sysdate , 'MM'),
                      '01', 'A',
                      '02', 'B',
                      '03', 'C',
                      '04', 'D',
                      '05', 'E',
                      '06', 'F',
                      '07', 'G',
                      '08', 'H',
                      '09', 'J',
                      '10', 'K',
                      '11', 'L',
                      '12', 'M',
                      '*' ) 
                      INTO lvs_ym
                   FROM DUAL ;
  else 
  
       SELECT DECODE (to_char(sysdate , 'MM'),
                      '01', 'N',
                      '02', 'O',
                      '03', 'P',
                      '04', 'Q',
                      '05', 'R',
                      '06', 'S',
                      '07', 'T',
                      '08', 'U',
                      '09', 'V',
                      '10', 'W',
                      '11', 'X',
                      '12', 'Y',
                      '*' ) 
                      INTO lvs_ym
                   FROM DUAL ;
  
  end if ;
--------------------------------------------------------------------------
SELECT 
    DECODE (to_char(sysdate , 'DD'),
                      '01', '1',
                      '02', '2',
                      '03', '3',
                      '04', '4',
                      '05', '5',
                      '06', '6',
                      '07', '7',
                      '08', '8',
                      '09', '9',
                      '10', 'A',
                      '11', 'B',
                      '12', 'C',
                      '13', 'D',
                      '14', 'E',
                      '15', 'F',
                      '16', 'G',
                      '17', 'H',
                      '18', 'J',
                      '19', 'K',
                      '20', 'L',
                      '21', 'M',
                      '22', 'N',
                      '23', 'P',
                      '24', 'Q',
                      '25', 'R',
                      '26', 'S',
                      '27', 'T',
                      '28', 'U',
                      '29', 'V',
                      '30', 'X',
                      '31', 'X',
                      '*' )
                   INTO LVS_DD
                  FROM DUAL ;
     
     

    select f_get_line_number( p_line_code)
        || decode( F_GET_WORK_SHIFT_CODE( sysdate) , '1' , 'A' , 'B')
        ||lvs_ym
        ||LVS_DD
        ||SEQ_MAGAZINE_SERIAL3.NEXTVAL
        ||'D'
        ||SUBSTR( p_model_name , -5 ,5 ) 
     INTO LVS_RETURN 
     FROM DUAL ;
             
NULL;

    RETURN lvs_return ;
EXCEPTION
   WHEN others THEN
       RAISE_APPLICATION_ERROR( -20004 , SQLERRM ) ;
END;