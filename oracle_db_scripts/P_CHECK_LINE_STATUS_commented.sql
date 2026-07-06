CREATE OR REPLACE PROCEDURE "P_CHECK_LINE_STATUS" (
  /* ================================================================
   * 프로시저명  : P_CHECK_LINE_STATUS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-07-30
   * 수정이력:
   *   2020-07-30 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   라인 상태 코드를 갱신하고, 정상 상태 전환 시 NSNP 해제 메시지를 처리한다.
   *   P_REASON이 N이면 라인 상태와 NSNP 상태를 정상/대기 상태로 갱신한다.
   *   그 외 사유이면 라인을 정지 상태로 갱신하고 사유 코드를 LINE_STATUS_CODE에 저장한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE_CODE  (IN, VARCHAR2) - 라인 코드, 앞 2자리 사용
   *   P_REASON     (IN, VARCHAR2) - 라인 상태 사유 코드
   *   P_RETURN     (OUT, VARCHAR2) - 처리 결과, OK 또는 NG 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_LINE - Product Line Master
   * ================================================================
   * [AI 분석] 호출 객체:
   *   P_INTERLOCK_SET_NSNP_TIME_MSG - 정상 상태 전환 시 NSNP 해제 메시지 처리
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - P_RETURN에 NG와 SQLERRM을 설정하고 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: UPDATE 1회
   *   주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_LINE_STATUS('L1', 'N', :P_RETURN)
   * ================================================================ */
   p_line_code   IN     VARCHAR2,
   p_reason      IN     VARCHAR2,
   p_return      OUT    VARCHAR2)
IS


lvs_nsnp_status       VARCHAR2(30) ; -- [AI] 예비 NSNP 상태 변수, 현재 로직에서는 미사용
lvs_nsnp_status_prev  VARCHAR2(30) ; -- [AI] 예비 이전 NSNP 상태 변수, 현재 로직에서는 미사용
lvs_message           VARCHAR2(1000) ; -- [AI] NSNP 해제 처리 메시지
lvs_ng_message        VARCHAR2(1000) ; -- [AI] NSNP 해제 실패 메시지
lvs_ok_message        VARCHAR2(1000) ; -- [AI] NSNP 해제 성공 메시지
LVS_ERROR_MESSAGE     VARCHAR2(2000) ; -- [AI] 예비 오류 메시지 변수, 현재 로직에서는 미사용

BEGIN

   --UPDATE ip_product_line
   --   SET line_status = p_reason
   -- WHERE line_code = SUBSTR (p_line_code, 1, 2);


   --IF p_reason = 'P' -- 계획정지이면 풀체크 안함
   --THEN
   --   UPDATE IB_SMT_FULLCHECK_TIME
   --      SET CHECK_YN = 'Y'
   --    WHERE line_code = SUBSTR (p_line_code, 1, 2);
   --END IF;

   -- p_return := 'OK';
   -- COMMIT;
   -- RETURN;
   
  -- [AI] 라인 상태 사유가 정상(N)인지에 따라 정상 전환 또는 정지 상태로 갱신한다.
  if p_reason = 'N' then 
    
       -- 정상처리로 바꿈
       UPDATE ip_product_line
          SET line_status = 'N'  
             ,line_status_code = 'N' 
             , NSNP_STATUS = 'WAIT' 
        WHERE line_code = SUBSTR (p_line_code, 1, 2);
        -----------------------------------------------------------------------
        --NSNP 해제 
        -----------------------------------------------------------------------
        -- [AI] 정상 상태 전환 시 NSNP 해제 메시지를 처리한다.
        P_INTERLOCK_SET_NSNP_TIME_MSG( 
                                       SUBSTR (p_line_code, 1, 2),
                                       '0' , 
                                       1 , 
                                       p_reason , 
                                       lvs_message , 
                                       lvs_ng_message ,
                                       lvs_ok_message 
                                     ) ;
        
  else
    
       UPDATE ip_product_line
          SET line_status= 'S', 
              line_status_code = p_reason 
        WHERE line_code = SUBSTR (p_line_code, 1, 2);
        
   end if ; 
   
   -- [AI] 라인 상태 변경 결과를 확정하고 정상 결과를 반환한다.
   p_return := 'OK';
   COMMIT;
   RETURN;
   
EXCEPTION
   -- [AI] 오류 발생 시 실패 메시지를 반환한다.
   WHEN OTHERS
   THEN
      p_return := 'NG, [LINE STATUS] ERROR' || SQLERRM;
      RETURN;
            
END;
