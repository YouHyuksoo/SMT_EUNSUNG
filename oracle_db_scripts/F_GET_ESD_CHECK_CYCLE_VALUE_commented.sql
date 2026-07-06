CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_ESD_CHECK_CYCLE_VALUE
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
   *   P_SUPPLIER  (IN, VARCHAR2) - 공급사 관련 값
   *   P_ITEM_CODE  (IN, VARCHAR2) - 품목 코드
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IM_ITEM_MASTER - 품목 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_ESD_CHECK_CYCLE_VALUE(...) FROM DUAL;
   * ================================================================ */
 F_GET_ESD_CHECK_CYCLE_VALUE
(
  P_SUPPLIER IN VARCHAR2 
, P_ITEM_CODE IN VARCHAR2 
, P_ORG IN NUMBER 
) RETURN NUMBER AS 


LVI_VALUE NUMBER ;
BEGIN

 begin 
   
   SELECT NVL(ESD_CHECK_CYCLE_VALUE , 0 ) 
     INTO LVI_VALUE
     FROM IM_ITEM_MASTER 
    WHERE SUPPLIER_CODE = P_SUPPLIER 
      AND ITEM_CODE = P_ITEM_CODE
      AND ORGANIZATION_ID = P_ORG ; 
     
  exception 
       when no_data_found then 
            return 0 ;
  end ;  
  
  return LVI_VALUE;
  
EXCEPTION
  
     WHEN OTHERS THEN 
          RAISE_APPLICATION_ERROR( -20003 , SQLERRM ) ;
          RETURN 0 ;
     
END ;
