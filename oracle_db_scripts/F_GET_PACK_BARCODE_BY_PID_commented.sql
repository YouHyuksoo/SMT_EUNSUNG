CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_PACK_BARCODE_BY_PID
   * 작성자  : 지성솔루션컨설팅
   * 작성일  : 2026-07-02
   * 수정이력:
   *   2026-07-02 - 지성솔루션컨설팅 - 최초 작성
   *   2026-07-02 - AI(Codex)       - 한글 주석 자동 추가
   * ================================================================
   * [AI 분석] 기능 설명:
   *   입력 파라미터와 기준 테이블을 이용해 업무 코드, 명칭, 수량, 상태 등의 조회 값을 반환한다.
   *   조회 실패 또는 예외 상황에서는 원본 로직에 정의된 기본값/NULL/오류 처리를 따른다.
   * ================================================================
   * [AI 분석] 파라미터:
   *   P_PID  (IN, VARCHAR2) - 제품 식별자
   * ================================================================
   * [AI 분석] 반환값:
   *   VARCHAR2 - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IP_PRODUCT_PACK_SERIAL - 제품 / 시리얼 관련 값 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 1회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_PACK_BARCODE_BY_PID(...) FROM DUAL;
   * ================================================================ */
 "F_GET_PACK_BARCODE_BY_PID" 
(
  P_PID IN VARCHAR2 
) RETURN VARCHAR2 AS 


LVS_PACK_BARCODE VARCHAR2(100) ;
BEGIN

    SELECT PACK_BARCODE 
      INTO LVS_PACK_BARCODE 
      FROM IP_PRODUCT_PACK_SERIAL WHERE BARCODE = P_PID ;
    
  RETURN LVS_PACK_BARCODE;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        RETURN  'NOTFOUND' ;
    WHEN OTHERS THEN 
    
     RAISE_APPLICATION_ERROR( -20003 , SQLERRM ) ;
     RETURN  '*' ;
    
END F_GET_PACK_BARCODE_BY_PID;
