CREATE OR REPLACE PROCEDURE P_CHECK_SPEC_INSPECT (
  /* ================================================================
   * 프로시저명  : P_CHECK_SPEC_INSPECT
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   라인 기준으로 모델 스펙 검사 상태를 확인하고 필요 시 상태를 초기화한다.
   *   IP_PRODUCT_LINE에서 대상 라인을 확인한 뒤 스펙 관련 상태를 갱신하는 검사 보조 프로시저이다.
   *   처리 단계별 phase 값을 사용해 오류 위치를 파악할 수 있게 한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE (IN, VARCHAR2) - 검사 대상 라인 코드
   *   P_RESULT (IN, VARCHAR2) - 스펙 검사 결과 값
   *   P_RETURN (OUT, VARCHAR2) - 처리 결과 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - Product Line Master, 라인 및 스펙 검사 상태 관리
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS/NO_DATA_FOUND 등 원본 예외 처리 흐름을 유지한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 로직 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_SPEC_INSPECT('L1', 'OK', :P_RETURN)
   * ================================================================ */
                                                   p_line_code   IN  VARCHAR2, -- [AI] 내부 처리용 변수
                                                   p_result      IN  VARCHAR2, -- [AI] 내부 처리용 변수
                                                   p_return      OUT VARCHAR2 -- [AI] 내부 처리용 변수
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
   -- [AI] 주요 업무 처리 로직을 시작한다.
        
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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS THEN
        rollback;
        p_return := 'NG, [P_CHECK_SPEC_INSPECT] '
                    || 'Phase=' 
                    || phase
                    || ', '
                    || SQLERRM;
END;
