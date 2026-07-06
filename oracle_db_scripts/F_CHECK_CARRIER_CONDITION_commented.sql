CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_CHECK_CARRIER_CONDITION
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 조건 또는 기준 데이터의 존재/상태를 확인하여 검증 결과를 반환한다.
   *   화면, 설비, 인터락 로직에서 사전 체크용으로 호출되는 함수로 추정된다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_MASTER_PID  (IN, VARCHAR2) - 제품 식별자
   *   P_PID  (IN, VARCHAR2) - 제품 식별자
   *   P_CARRIER_SIZE  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   없음 (순수 연산 함수 또는 원본 소스 기준 명시 테이블 없음)
   * ================================================================
   * [AI 분석] 예외 처리:
   *   명시적 EXCEPTION 블록 없음 - 호출부에서 표준 Oracle 예외를 처리한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 2회 / 반복문: 0회
   *   DML: 없음
   * ================================================================
   * 사용 예시:
   *   SELECT F_CHECK_CARRIER_CONDITION(...) FROM DUAL;
   * ================================================================ */
 F_CHECK_CARRIER_CONDITION 
(
  P_MASTER_PID IN VARCHAR2 
, P_PID IN VARCHAR2 
, P_CARRIER_SIZE IN NUMBER 
) RETURN NUMBER AS 

p_master_min_serial varchar2(10) ;
p_master_max_serial varchar2(10) ;
p_serial varchar2(10) ;

BEGIN

   p_master_min_serial :=  SUBSTR(P_MASTER_PID,9,3) ;
   p_master_max_serial :=  LPAD( TO_CHAR( TO_NUMBER( SUBSTR(P_MASTER_PID,9,3) , 'XXX') + (P_CARRIER_SIZE-1) , 'fmXXX') , 3,0)  ; 
    
   p_serial :=  SUBSTR(P_PID , 9,3) ;
   
   if p_serial >= p_master_min_serial and p_serial <= p_master_max_serial then 
       return 1 ; -- 'OK '||p_master_min_serial||' '||p_serial||' '||p_master_max_serial ;
   else
       return -1 ; --'NG '||p_master_min_serial||' '||p_serial||' '||p_master_max_serial ;
   end if ;
 --  LPAD( TO_CHAR(p_master_serial + ( P_CARRIER_SIZE -1 ) , 'fmXXX')  , 3 , 0 )
   


  RETURN NULL;
END F_CHECK_CARRIER_CONDITION;
