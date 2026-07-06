CREATE OR REPLACE PROCEDURE "P_INTERLOCK_FULL_CHECK_NSNP" (
  /* ================================================================
   * 프로시저명  : P_INTERLOCK_FULL_CHECK_NSNP
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   현재 시간이 풀체크 시간대인지 확인하고 NSNP 풀체크 필요 여부를 반환한다.
   *   IB_SMT_FULLCHECK_TIME에서 라인별 검사 시간과 완료 상태를 조회한다.
   *   조건에 맞는 시간대이면 호출부가 NSNP 인터락 처리를 진행할 수 있는 상태를 반환한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE (IN, VARCHAR2) - 라인 코드
   *   P_OUT (OUT, VARCHAR2) - 풀체크/NSNP 판단 결과
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_SMT_FULLCHECK_TIME - 라인별 풀체크 시간 및 완료 상태 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_INTERLOCK_FULL_CHECK_NSNP('L1', :P_OUT)
   * ================================================================ */
   P_LINE_CODE   IN     VARCHAR2, -- [AI] 내부 처리용 변수
   P_OUT            OUT VARCHAR2) -- [AI] 내부 처리용 변수
IS
   LVS_TIME_DIVISION   VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVS_CHECK_YN        VARCHAR2 (10); -- [AI] 내부 처리용 변수
   LVDT_CHECK_DATE     DATE; -- [AI] 내부 처리용 변수
   lvl_time_term       NUMBER := 1000;                                -- 1 SEC -- [AI] 내부 처리용 변수
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
   ---------------------------------------------------------------------------
   --  현재 시간이 풀체크 시간이면서  체크한다.
   --
   ---------------------------------------------------------------------------

   BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
   -- [AI] 주요 업무 처리 로직을 시작한다.
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
         WHEN OTHERS
         THEN
            NULL;
      END;
   END IF;
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN NO_DATA_FOUND
   THEN
      P_OUT := f_msg('시간설정을 알수 없습니다.','C',1);
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS
   THEN
      P_OUT := SQLERRM;
END p_interlock_full_check_nsnp;