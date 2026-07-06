PROCEDURE "P_CHECK_FULL_SAVE" (
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_return          OUT VARCHAR2)
IS

   lvl_seq   NUMBER;
   lvl_count NUMBER;
   
BEGIN
  

   ------------------------------------------------------------
   -- 풀체크 여부확인 
   ------------------------------------------------------------
       
  select count(*)
    into lvl_count
    from ib_product_plandata
   where line_code    =  SUBSTR (p_line_code, 1, 2)    
     AND model_name   =  p_model_name
     AND active_yn    = 'Y';
    
   if ( lvl_count = 0 ) then
     
         p_return := 'NG, No have Full Check item';
         return;
         
   END IF;
   
      
  select count(*)
    into lvl_count
    from ib_product_plandata
   where line_code    =  SUBSTR (p_line_code, 1, 2)    
     AND model_name   =  p_model_name
     AND active_yn    = 'Y'
     AND NVL(full_check_yn, 'N') = 'N'; 
   
   if ( lvl_count > 0 ) then
     
         p_return := 'NG, Not Completed Full Check => ' || TRIM( TO_CHAR (lvl_count) );
         return;
         
   END IF;
   
   ------------------------------------------------------------
   -- 
   ------------------------------------------------------------
   
   lvl_seq := seq_full_check_seq.NEXTVAL;

   ------------------------------------------------------------
   -- 
   ------------------------------------------------------------
   UPDATE ib_product_plandata
      SET full_check_yn = 'N'
    WHERE line_code     = SUBSTR (p_line_code, 1, 2)
       AND model_name   = p_model_name
       AND active_yn    = 'Y';

   UPDATE ib_smt_checkhist
      SET full_check_sequence = lvl_seq
    WHERE line_code           = SUBSTR (p_line_code, 1, 2)
      AND lot_name            = p_model_name
      AND full_check_sequence IS NULL;

   ------------------------------------------------------------
   -- 풀체크 일자 업데이트 
   ------------------------------------------------------------

   UPDATE ip_product_line
      SET full_check_date = SYSDATE
    WHERE line_code       = SUBSTR (p_line_code, 1, 2);
    
-------------------------------------------------------------
-- 풀체크 기록을 초기화 다음에 다시 체크 하도록 
-- 풀체크 시간이 짧아도 20 분정도 소요 되므로 
-- 전체를 미리 해제 시켜 놓아도 이미 체크예정 시간을 
-- 초과 하므로 ...
-- P_CHECK_FULL_SCAN 에서 스캔을 시작하면 전체 시간대를 
-- 전부 체크 중인 상태로 변경해 놓는다 .
-- 체크 중인 상태인경우는 nsnp 동작을 안한다.
-------------------------------------------------------------

   UPDATE IB_SMT_FULLCHECK_TIME
      SET CHECK_YN            = 'N' ,
          CHECK_COMPLETE_DATE = SYSDATE 
    WHERE line_code           = SUBSTR (p_line_code, 1, 2);

   COMMIT;

   p_return := 'OK';


EXCEPTION
   WHEN OTHERS  THEN
        p_return := '[FULL] 저장 ERROR ' || SQLERRM;
        RETURN;
END;                                                              -- Procedure
