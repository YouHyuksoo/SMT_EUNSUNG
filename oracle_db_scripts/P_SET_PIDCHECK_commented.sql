CREATE OR REPLACE PROCEDURE P_SET_PIDCHECK
(
  /* ================================================================
   * 프로시저명  : P_SET_PIDCHECK
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-02-16
   * 수정이력:
   *   2021-02-16 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   1D/2D PID 검사 결과를 IP_PRODUCT_PIDCHECK_HISTORY에 이력으로 저장한다.
   *   PID1, PID2, 검사 결과, 라인, 설비 정보를 받아 검사일과 등록 정보를 함께 기록한다.
   *   정상 저장 시 OK와 정상 처리 메시지를 반환하고 COMMIT한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PID           (IN, VARCHAR2) - 1D PID 바코드
   *   P2_PID          (IN, VARCHAR2) - 2D PID 바코드
   *   CHECK_RESULT    (IN, VARCHAR2) - PID 검사 결과
   *   P_LINE_CODE     (IN, VARCHAR2) - 라인 코드
   *   P_MACHINE_CODE  (IN, VARCHAR2) - 설비 코드
   *   P_OUT           (OUT, VARCHAR2) - 처리 결과, OK 또는 NG
   *   P_MESSAGE       (OUT, VARCHAR2) - 처리 메시지 또는 오류 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_PIDCHECK_HISTORY - PID 검사 이력 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN OTHERS - P_OUT에 NG, P_MESSAGE에 SQLERRM을 설정하고 종료한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 없음
   *   DML: INSERT 1회
   *   주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_SET_PIDCHECK('PID1', 'PID2', 'OK', 'L1', 'MC01', :P_OUT, :P_MESSAGE)
   * ================================================================ */
  P_PID IN VARCHAR2
, P2_PID IN VARCHAR2
, CHECK_RESULT IN VARCHAR2
, P_LINE_CODE IN VARCHAR2
, P_MACHINE_CODE IN VARCHAR2
, P_OUT OUT VARCHAR2
, P_MESSAGE OUT VARCHAR2
) AS

LVI_COUNT NUMBER ; -- [AI] 예비 카운트 변수, 현재 로직에서는 미사용

BEGIN
  ------------------------------------------
  -- 이력 등록
  -------------------------------------------
      -- [AI] PID 검사 결과를 이력 테이블에 등록한다.
      INSERT
            INTO IP_PRODUCT_PIDCHECK_HISTORY
              (
                PID1,
                PID2,
                CHECK_RESULT,
                CHECK_DATE,
                LINE_CODE,
                MACHINE_CODE,
                ENTER_DATE,
                ENTER_BY,
                LAST_MODIFY_DATE,
                LAST_MODIFY_BY,
                ORGANIZATION_ID
              )
              VALUES
              (
                P_PID,
                P2_PID,
                CHECK_RESULT,
                TRUNC(SYSDATE),
                P_LINE_CODE,
                P_MACHINE_CODE,
                SYSDATE,
                'SCAN',
                SYSDATE,
                'SCAN',
                1
              );

         -- [AI] 정상 처리 결과를 반환하고 검사 이력을 확정한다.
         P_OUT := 'OK' ;
         P_MESSAGE := '정상처리 되었습니다 '||TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') ;
         COMMIT ;
         RETURN ;

EXCEPTION WHEN OTHERS THEN
         -- [AI] 오류 발생 시 실패 코드와 오류 메시지를 반환한다.
         P_OUT := 'NG' ;
         P_MESSAGE := SQLERRM ;
         RETURN ;
END P_SET_PIDCHECK;
