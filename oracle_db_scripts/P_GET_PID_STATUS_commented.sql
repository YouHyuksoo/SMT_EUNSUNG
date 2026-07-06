CREATE OR REPLACE PROCEDURE P_GET_PID_STATUS
(
  /* ================================================================
   * 프로시저명  : P_GET_PID_STATUS
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2021-02-15
   * 수정이력:
   *   2021-02-15 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-01 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   PID의 SSCD 데이터 체크 상태를 조회해 Ready/OK/NG 상태 메시지를 반환한다.
   *   IP_PRODUCT_SSCD_DATA_CHECK에 PID가 없으면 NOTREADY를 반환한다.
   *   CHECK_STATUS와 전체/NG 건수를 기준으로 검사 완료 상태를 세분화한다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PID           (IN, VARCHAR2) - 조회할 PID
   *   P_LINE_CODE     (IN, VARCHAR2) - 라인 코드, 현재 로직에서는 미사용
   *   P_MACHINE_CODE  (IN, VARCHAR2) - 설비 코드, 현재 로직에서는 미사용
   *   P_OUT           (OUT, VARCHAR2) - 상태 결과, NOTREADY/READY/OK/NG/NG2/NG3
   *   P_MESSAGE       (OUT, VARCHAR2) - 상태 설명 메시지
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_SSCD_DATA_CHECK - PID별 SSCD 데이터 체크 상태 테이블
   * ================================================================
   * [AI 분석] 예외 처리:
   *   내부 WHEN NO_DATA_FOUND - 카운트를 0으로 설정한다.
   *   외부 WHEN OTHERS - P_OUT에 NG3, P_MESSAGE에 SQLERRM을 설정한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 4회, ELSIF 2회 / 반복문: 없음
   *   DML: SELECT 2회
   * ================================================================
   * 사용 예시:
   *   EXEC P_GET_PID_STATUS('PID01', 'L1', 'MC01', :P_OUT, :P_MESSAGE)
   * ================================================================ */
  P_PID IN VARCHAR2
, P_LINE_CODE IN VARCHAR2
, P_MACHINE_CODE IN VARCHAR2
, P_OUT OUT VARCHAR2
, P_MESSAGE OUT VARCHAR2
) AS

LVI_COUNT NUMBER ; -- [AI] PID 등록 건수
LVI_STATUS integer; -- [AI] PID 체크 상태 코드
LVI_TOTAL  integer; -- [AI] 전체 데이터 건수
LVI_NG     integer; -- [AI] NG 데이터 건수

BEGIN
  ------------------------------------------
  -- 중복 체크
  -------------------------------------------
      BEGIN
      -- [AI] 입력 PID의 체크 데이터 등록 여부를 확인한다.
      SELECT COUNT(*) INTO LVI_COUNT FROM IP_PRODUCT_SSCD_DATA_CHECK
        WHERE PID = P_PID;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        -- [AI] PID 데이터가 없으면 등록 건수를 0으로 처리한다.
        LVI_COUNT := 0 ;
      END ;

      -- [AI] PID가 준비되지 않았으면 NOTREADY 상태를 반환한다.
      IF NVL(LVI_COUNT,0) = 0 THEN

         P_OUT := 'NOTREADY' ;
         P_MESSAGE := P_PID||' : Not Ready 바코드 입니다' ;
         RETURN ;
      END IF ;

      -- [AI] PID의 체크 상태와 검사 건수를 조회한다.
      SELECT CHECK_STATUS, DATA_COUNT, NG_COUNT
        INTO LVI_STATUS, LVI_TOTAL, LVI_NG
        FROM IP_PRODUCT_SSCD_DATA_CHECK
       WHERE PID = P_PID ;

      -- [AI] 체크 상태와 NG 건수 기준으로 호출부 상태 메시지를 반환한다.
      if LVI_STATUS = 1 then
         P_OUT := 'READY' ;
         P_MESSAGE := P_PID||' : Ready 바코드 입니다' ;

      elsif LVI_STATUS = 2 then
      
         if LVI_TOTAL > 0 AND LVI_NG = 0 THEN
            P_OUT := 'OK' ;
            P_MESSAGE := P_PID||' : '||to_char(LVI_NG)||'/'||to_char(LVI_TOTAL)||' OK 데이타 바코드 입니다' ;
         elsif LVI_TOTAL > 0 AND LVI_NG > 0 then
            P_OUT := 'NG' ;
            P_MESSAGE := P_PID||' : '||to_char(LVI_NG)||'/'||to_char(LVI_TOTAL)||' NG 데이타 바코드 입니다' ;
         else
            P_OUT := 'NG2' ;
            P_MESSAGE := P_PID||' : 비정상 데이타 바코드 입니다' ;
         end if;
         
      else
         P_OUT := 'NG2' ;
         P_MESSAGE := P_PID||' : 비정상 데이타 바코드 입니다' ;
      end if;

      RETURN ;

EXCEPTION WHEN OTHERS THEN
         -- [AI] 오류 발생 시 시스템 오류 상태와 메시지를 반환한다.
         P_OUT := 'NG3' ;
         P_MESSAGE := SQLERRM ;
         RETURN ;
END P_GET_PID_STATUS;
