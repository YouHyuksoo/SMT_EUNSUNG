CREATE OR REPLACE PROCEDURE p_check_foolproof_state (
  /* ================================================================
   * 프로시저명  : P_CHECK_FOOLPROOF_STATE
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2020-10-05
   * 수정이력:
   *   2020-10-05 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   라인 기준으로 제품 라인 모니터링의 풀프루프 점검 상태를 조회한다.
   *   마스크, 스퀴즈, 솔더, CCS, 풀체크, 마스터, 프로파일 점검 상태와 일자를 조합한다.
   *   조회 결과는 SYS_REFCURSOR로 반환되어 호출 화면에서 상태 목록으로 사용할 수 있다.
   *   조직 파라미터는 현재 SQL 조건에는 사용되지 않는다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_LINE  (IN, VARCHAR2) - 조회할 라인 코드, 앞 2자리만 조건에 사용
   *   P_ORG   (IN, NUMBER) - 조직 ID 입력값, 현재 로직에서는 미사용
   *   P_OUT   (OUT, SYS_REFCURSOR) - 라인별 풀프루프 상태 조회 결과 커서
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IRPT_PRODUCT_LINE_MONITORING - 라인별 제품/점검 상태 모니터링 조회 테이블
   *     조건: LINE_CODE = SUBSTR(P_LINE, 1, 2)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - 발생한 오류 메시지를 ORA-20003 애플리케이션 오류로 재발생시킨다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   EXEC P_CHECK_FOOLPROOF_STATE('L1', 82, :P_OUT)
   * ================================================================ */
   p_line  IN VARCHAR2,
   p_org   IN NUMBER,
   p_out   OUT sys_refcursor
   )
IS
BEGIN

  -- [AI] 라인별 풀프루프 점검 상태와 관련 일자를 커서로 반환한다.
  OPEN p_out FOR select model_name,
                        mask_check||' :' ||mask_check_date          mask,
                        squeeze_check||' :' ||squeeze_check_date    squeeze,
                        solder_check||' :' ||solder_check_val       solder,
                        ccs_check||' :' ||ccs_check_date            ccs ,
                        full_check||' :' ||full_check_date          full,
                        xray_check||' :' ||xray_check_date          master,
                        spec_check||' :' ||spec_check_date          profile
                   from IRPT_PRODUCT_LINE_MONITORING
                  where line_code = substr(p_line,1,2);

EXCEPTION
    -- [AI] 조회 중 발생한 모든 오류를 애플리케이션 오류 코드로 변환한다.
    WHEN OTHERS THEN
         raise_application_error (-20003, SQLERRM);
END;

