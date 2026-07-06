PROCEDURE "P_INTERLOCK_SET_JIG" (
   p_line_code        IN     VARCHAR2,
   p_workstage_code   IN     VARCHAR2,
   p_machine_code     IN     VARCHAR2,
   p_result              OUT VARCHAR2,
   p_hit_value           OUT VARCHAR2)
IS
   lvl_hit_value        NUMBER;
   lvs_jit_type_param   VARCHAR2 (10);
   LVS_LAST_JIG_LOT_NO   VARCHAR2(100) ;
BEGIN
   ------------------------------------------------------------------------------
   --
   ------------------------------------------------------------------------------
   BEGIN
      IF F_GET_WORKSTAGE_TYPE(p_workstage_code) = 'ICT'                                       --ICT
      THEN
         lvs_jit_type_param := 'T';                                 -- FIXTURE
      ELSE
         lvs_jit_type_param := 'M';                           -- MASK , SQUEZE
      END IF;


   -- 2016011 SHS, hit수량을 1에서 기존 hit 수량에 1을 더한 값을 return 한다

      SELECT hit_value
        INTO lvl_hit_value
        FROM imcn_jig
       WHERE     line_code = p_line_code
         -- AND machine_code = p_machine_code
         AND jig_type = lvs_jit_type_param;
         
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         lvl_hit_value := 0;
   END;

--   -----------------------------------------------------------------------------
--   --  FIXTURE METAL MASK , SQUEZE LIFE CYCLE
--   ------------------------------------------------------------------------------

/*

   IF lvs_jit_type_param = 'T'
   THEN
      UPDATE imcn_jig
         SET hit_value = NVL (hit_value, 0) + 1
       WHERE     line_code = p_line_code
             AND jig_type = 'T';
   ELSE
     
      -------------------------------------------------------------
      -- 해당 라인으로 출고 처리된 마스크 전부
      -------------------------------------------------------------
      UPDATE imcn_jig
         SET hit_value = NVL (hit_value, 0) + 1
       WHERE line_code = p_line_code
          AND jig_type = 'M';
         --   AND jig_type IN ('M' , 'S' );
         
           ------------------------------------------------------------------
           -- 해당 라인으로 출고 처리된 스퀴지 전부
           -------------------------------------------------------------
           BEGIN 
                   SELECT JIG_LOT_NO 
                     INTO LVS_LAST_JIG_LOT_NO
                     FROM IMCN_JIG
                    WHERE LINE_CODE = p_line_code
                      AND NVL(LAST_HIT_YN ,'N') = 'Y'
                      AND jig_type = 'S'
                      AND ROWNUM = 1 ;
                      
             EXCEPTION WHEN OTHERS THEN 
                      LVS_LAST_JIG_LOT_NO := NULL ;
             END ;
             
            IF   LVS_LAST_JIG_LOT_NO IS NULL THEN 
            
              UPDATE imcn_jig SET hit_value = NVL (hit_value, 0) + 1 , LAST_HIT_YN = 'Y'
               WHERE line_code = p_line_code
                 AND jig_type = 'S'
                 AND NVL(LAST_HIT_YN,'N') = 'N'
                 AND JIG_LOT_NO = ( SELECT MIN(JIG_LOT_NO) FROM imcn_jig WHERE  line_code = p_line_code  AND jig_type = 'S' AND NVL( LAST_HIT_YN ,'N')  <> 'Y' )
                 ;     
            ELSE
            
            
               UPDATE imcn_jig SET LAST_HIT_YN = 'N'
               WHERE line_code = p_line_code
                 AND jig_type = 'S'
                 AND NVL(LAST_HIT_YN,'N') = 'Y'
                 AND JIG_LOT_NO = LVS_LAST_JIG_LOT_NO ;
                 
              UPDATE imcn_jig SET hit_value = NVL (hit_value, 0) + 1 , LAST_HIT_YN = 'Y'
               WHERE line_code = p_line_code
                 AND jig_type = 'S'
                 AND JIG_LOT_NO <> LVS_LAST_JIG_LOT_NO ;       
            
            END IF ;        
         
   END IF;
   
*/
      
   ------------------------------------------------------------------
   --
   ------------------------------------------------------------------
   p_result := 'OK';
   p_hit_value := lvl_hit_value + 1 ;
   
   COMMIT;
   RETURN;
   
EXCEPTION
   WHEN OTHERS
   THEN
      p_result := SQLERRM;
      raise_application_error (-20003, SQLERRM);
END;
