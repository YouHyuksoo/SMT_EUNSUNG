CREATE OR REPLACE PROCEDURE "P_CHECK_FULL_SAVE" (
  /* ================================================================
   * 프로시저명  : P_CHECK_FULL_SAVE
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
   *   P_MODEL_NAME - 원본 선언부 기준 입력/출력 파라미터
   *   P_RETURN - 원본 선언부 기준 입력/출력 파라미터
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IB_PRODUCT_PLANDATA - 원본 로직 참조 테이블
   *   IB_SMT_CHECKHIST - 원본 로직 참조 테이블
   *   IB_SMT_FULLCHECK_TIME - 원본 로직 참조 테이블
   *   IP_PRODUCT_LINE - Product Line Master
   * ================================================================
   * [AI 분석] 예외 처리:
   *   원본 EXCEPTION 절의 반환값, RAISE, COMMIT/ROLLBACK 흐름을 변경하지 않는다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기/반복문/DML은 원본 구현 기준으로 유지되며 주석만 추가했다.
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_FULL_SAVE(...)
   * ================================================================ */
   p_line_code    IN     VARCHAR2,
   p_model_name   IN     VARCHAR2,
   p_return          OUT VARCHAR2)
IS

   lvl_seq   NUMBER; -- [AI] 내부 처리용 변수
   lvl_count NUMBER; -- [AI] 내부 처리용 변수
   
BEGIN
   -- [AI] 주요 업무 처리 로직을 시작한다.
  

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
   -- [AI] 예외 상황을 원본 처리 방식대로 처리한다.
   WHEN OTHERS  THEN
        p_return := '[FULL] 저장 ERROR ' || SQLERRM;
        RETURN;
END;                                                              -- Procedure
