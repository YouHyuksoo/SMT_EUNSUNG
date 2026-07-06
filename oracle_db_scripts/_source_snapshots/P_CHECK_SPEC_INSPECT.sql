PROCEDURE P_CHECK_SPEC_INSPECT (
                                                   p_line_code   IN  VARCHAR2,
                                                   p_result      IN  VARCHAR2,
                                                   p_return      OUT VARCHAR2
                                                 )
IS

   lvi_count        NUMBER;
   phase            VARCHAR2 (10);
  
BEGIN
  
      ---------------------------------------------
      -- 라인 확인
      ---------------------------------------------
      phase := 10;
      
      BEGIN
        
         SELECT COUNT (*)
           INTO lvi_count
           FROM ip_product_line
          WHERE line_code = SUBSTR (p_line_code, 1, 2);

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
              lvi_count := 0;            
      END;
      
      if ( lvi_count = 0 ) then
        
         p_return := 'NG '
                     || f_msg('미등록 라인 입니다.','K',1) -- Not found line, check it line
                     || ' = '
                     || p_line_code;
         RETURN;
         
      end if;
   
      ---------------------------------------------
      -- 검사결과 확인
      ---------------------------------------------
      phase := 20;
      
      IF ( substr(p_result,1,1) = 'N' or substr(p_result,1,1) = 'P' ) THEN
        
          UPDATE IP_PRODUCT_LINE
             SET SPEC_CHECK_STATUS   = substr(p_result,1,1) ,
                 SPEC_CHECK_DATE     = sysdate
           WHERE line_code = SUBSTR(p_line_code, 1, 2);
           
      ELSE
          
         p_return := 'NG '
                     || f_msg('미확인 결과코드 입니다.','E',1)    -- Check it Result.
                     || ' = '
                     || p_result; 
         RETURN;         
           
      END IF;

      COMMIT;
      p_return := 'OK';
      
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION
   WHEN OTHERS THEN
        rollback;
        p_return := 'NG, [P_CHECK_SPEC_INSPECT] '
                    || 'Phase=' 
                    || phase
                    || ', '
                    || SQLERRM;
END;
