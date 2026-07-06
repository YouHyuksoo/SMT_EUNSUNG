CREATE OR REPLACE PROCEDURE P_CHECK_PROFILE_INSPECT (
  /* ================================================================
   * 프로시저명  : P_CHECK_PROFILE_INSPECT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건을 기준으로 상태 또는 기준 데이터의 유효성을 확인한다.
   *   조회 결과와 원본 분기 조건에 따라 OUT 파라미터 또는 관련 상태 값을 설정한다.
   *   호출부가 결과 코드와 메시지로 후속 처리를 판단할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE - 원본 선언부 기준 입력/출력 파라미터
   *   P_RESULT - 원본 선언부 기준 입력/출력 파라미터
   *   P_PASSWORD - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - Product Line Master
   *   ISYS_CONFIG - 원본 로직 참조 테이블
   * ================================================================
   * [AI 분석] 호출 객체:
   *   F_MSG
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_PROFILE_INSPECT(...)
   * ================================================================ */
                                                   p_line_code   IN  VARCHAR2,
                                                   p_result      IN  VARCHAR2,
                                                   p_password    IN  VARCHAR2,
                                                   p_return      OUT VARCHAR2
                                                 )
IS

   lvi_count        NUMBER; -- [AI] 내부 처리용 변수
   phase            VARCHAR2 (10); -- [AI] 내부 처리용 변수
  
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
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
        
          NULL;
           
      ELSE
          
         p_return := 'NG '
                     || f_msg('미확인 결과코드 입니다.','E',1)    -- Check it Result.
                     || ' = '
                     || p_result; 
         RETURN;         
           
      END IF;
      
      ---------------------------------------------
      -- 비밀번호 확인
      ---------------------------------------------
      phase := 20;
      
      lvi_count := 0;
      
      select count(*)
        into lvi_count
        from isys_config
       where config_name  = 'PDA_PROFILE_PASSWORD'
         and config_value = p_password;
         
      IF ( lvi_count = 0 ) THEN
          
         p_return := 'NG '
                     || f_msg('입력된 비밀번호가 다릅니다.','E',1)    -- Check it Result.
                     || ' = '
                     || p_password; 
         RETURN;
         
      ELSE      
        
          UPDATE IP_PRODUCT_LINE
             SET SPEC_CHECK_STATUS   = substr(p_result,1,1) ,
                 SPEC_CHECK_DATE     = sysdate
           WHERE line_code = SUBSTR(p_line_code, 1, 2);         
           
      END IF;      

      COMMIT;
      p_return := 'OK';
      
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
EXCEPTION
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
        rollback;
        p_return := 'NG, [P_CHECK_PROFILE_INSPECT] '
                    || 'Phase=' 
                    || phase
                    || ', '
                    || SQLERRM;
END;
