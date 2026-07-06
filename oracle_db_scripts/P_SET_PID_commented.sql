CREATE OR REPLACE PROCEDURE P_SET_PID
(
  /* ================================================================
   * 프로시저명  : P_SET_PID
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-02-15
   * 수정이력:
   *   2021-02-15 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   PID 스캔 이력 중복 여부를 확인하고 신규 PID 스캔 이력을 등록한다.
   *   IP_PRODUCT_SCAN_HISTORY에 이미 존재하면 NG2와 중복 메시지를 반환한다.
   *   신규일 경우 스캔 이력을 INSERT하고 OK 메시지와 함께 COMMIT한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PID           (IN, VARCHAR2) - 등록할 PID
   *   P_LINE_CODE     (IN, VARCHAR2) - 라인 코드
   *   P_MACHINE_CODE  (IN, VARCHAR2) - 설비 코드
   *   P_OUT           (OUT, VARCHAR2) - 처리 결과, OK/NG/NG2
   *   P_MESSAGE       (OUT, VARCHAR2) - 처리 메시지 또는 오류 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_SCAN_HISTORY - PID 스캔 이력 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN NO_DATA_FOUND - 카운트를 0으로 설정한다.
   *   외부 WHEN OTHERS - P_OUT에 NG, P_MESSAGE에 SQLERRM을 설정한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 1회 / 반복문: 없음
   *   DML: SELECT 1회, INSERT 1회
   *   주의: COMMIT 포함
   * ================================================================
   * 사용 예시:
   *   EXEC P_SET_PID('PID01', 'L1', 'MC01', :P_OUT, :P_MESSAGE)
   * ================================================================ */
  P_PID IN VARCHAR2 
, P_LINE_CODE IN VARCHAR2 
, P_MACHINE_CODE IN VARCHAR2 
, P_OUT OUT VARCHAR2 
, P_MESSAGE OUT VARCHAR2 
) AS 

LVI_COUNT NUMBER ; -- [AI] PID 스캔 이력 등록 건수

BEGIN
  ------------------------------------------
  -- 중복 체크 
  -------------------------------------------
      BEGIN
      -- [AI] 입력 PID가 이미 스캔 이력에 등록되어 있는지 확인한다.
      SELECT COUNT(*) INTO LVI_COUNT FROM IP_PRODUCT_SCAN_HISTORY
        WHERE PID = P_PID ;
      EXCEPTION WHEN NO_DATA_FOUND THEN 
        -- [AI] 스캔 이력이 없으면 건수를 0으로 처리한다.
        LVI_COUNT := 0 ;
      END ;
  
      -- [AI] 기존 등록 PID이면 중복 결과를 반환하고 종료한다.
      IF NVL(LVI_COUNT,0) > 0 THEN 
         
         P_OUT := 'NG2' ;
         P_MESSAGE := P_PID||' : 이미등록된 바코드 입니다' ;
         RETURN ;
      END IF ;
  ------------------------------------------
  -- 신규일경우 등록 
  -------------------------------------------
      -- [AI] 신규 PID 스캔 이력을 등록한다.
      INSERT
            INTO IP_PRODUCT_SCAN_HISTORY
              (
                PID,
                SCAN_DATE,
                LINE_CODE,
                MACHINE_CODE,
                PRINT_YN,
                ENTER_DATE,
                ENTER_BY,
                LAST_MODIFY_DATE,
                LAST_MODIFY_BY,
                ORGANIZATION_ID
              )
              VALUES
              (
                P_PID,
                SYSDATE,
                P_LINE_CODE,
                P_MACHINE_CODE,
                'N',
                SYSDATE,
                'SCAN',
                SYSDATE,
                'SCAN',
                1
              ); 
              
         -- [AI] 정상 처리 결과를 반환하고 등록 내용을 확정한다.
         P_OUT := 'OK' ;
         P_MESSAGE := '정상처리 되었습니다 '||TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') ;
         COMMIT ;
         RETURN ;             
 
EXCEPTION WHEN OTHERS THEN 
         -- [AI] 오류 발생 시 실패 코드와 오류 메시지를 반환한다.
         P_OUT := 'NG' ;
         P_MESSAGE := SQLERRM ;
         RETURN ;
END P_SET_PID;
