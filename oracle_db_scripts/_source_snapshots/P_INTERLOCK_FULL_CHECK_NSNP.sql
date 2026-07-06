PROCEDURE "P_INTERLOCK_FULL_CHECK_NSNP" (
   P_LINE_CODE   IN     VARCHAR2,
   P_OUT            OUT VARCHAR2)
IS
   LVS_TIME_DIVISION   VARCHAR2 (10);
   LVS_CHECK_YN        VARCHAR2 (10);
   LVDT_CHECK_DATE     DATE;
   lvl_time_term       NUMBER := 1000;                                -- 1 SEC
BEGIN
   ---------------------------------------------------------------------------
   --  현재 시간이 풀체크 시간이면서  체크한다.
   --
   ---------------------------------------------------------------------------

   BEGIN
      SELECT TIME_DIVISION, CHECK_YN, CHECK_DATE
        INTO LVS_TIME_DIVISION, LVS_CHECK_YN, LVDT_CHECK_DATE
        FROM IB_SMT_FULLCHECK_TIME
       WHERE LINE_CODE = P_LINE_CODE
         AND CHECK_YN = 'N' 
         AND SYSDATE >= TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || START_TIME,'YYYYMMDDHH24MI')
         AND SYSDATE <= TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || END_TIME  ,'YYYYMMDDHH24MI')
         
         AND CHECK_COMPLETE_DATE < TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || START_TIME,'YYYYMMDDHH24MI')
         AND CHECK_COMPLETE_DATE > TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD') || END_TIME  ,'YYYYMMDDHH24MI')
         
         
         ;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         LVS_TIME_DIVISION := '*';
   END;

   -----------------------------------------------------------------------
   -- 풀체크 시간이 아니면
   -----------------------------------------------------------------------

   IF LVS_TIME_DIVISION = '*'
   THEN
      P_OUT := f_msg('대상 시간이 아직 아닙니다.','C',1);
   
      RETURN;
   END IF;


   --------------------------------------------------------------------
   -- 풀체크 시간인데 아직도 풀체크를 하지 않았음
   --
   --------------------------------------------------------------------

   IF LVS_TIME_DIVISION <> '*' AND LVS_CHECK_YN = 'N'
   THEN
      BEGIN
         --------------------------------------------------------------------------------
         -- NSNP START
         --------------------------------------------------------------------------------
         p_interlock_set_nsnp_time_msg (
            p_line_code,
            1,
            lvl_time_term,
            '*',                                                  --MODEL NAME
            '*',                                                          --공정
            'FULL CHECK',
            p_line_code ||'  '||LVS_TIME_DIVISION||f_msg('  풀체크 시작시간을 넘었습니다.','C',1)
            );
      --------------------------------------------------------------------------------
      -- NSNP END
      --------------------------------------------------------------------------------
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := f_msg('시간설정을 알수 없습니다.','C',1);
   WHEN OTHERS
   THEN
      P_OUT := SQLERRM;
END p_interlock_full_check_nsnp;