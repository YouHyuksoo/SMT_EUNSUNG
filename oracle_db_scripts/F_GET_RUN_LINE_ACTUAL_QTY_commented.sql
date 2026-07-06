CREATE OR REPLACE FUNCTION
  /* ================================================================
   * 함수명  : F_GET_RUN_LINE_ACTUAL_QTY
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
   *   P_RUN_NO  (IN, VARCHAR2) - 작업지시/런 번호
   *   P_LINE  (IN, VARCHAR2) - 라인 관련 값
   *   P_ORG  (IN, NUMBER) - 함수 입력값
   * ================================================================
   * [AI 분석] 반환값:
   *   NUMBER - 함수 처리 결과값
   * ================================================================
   * [AI 분석] 참조 테이블:
   *   IQ_MACHINE_INSPECT_DATA_AOI - 검사 관련 값 조회 또는 참조
   *   IP_PRODUCT_2D_BARCODE - 바코드 조회 또는 참조
   * ================================================================
   * [AI 분석] 예외 처리:
   *   WHEN 절 또는 원본 예외 로직 기준으로 기본값 반환/애플리케이션 오류 처리를 수행한다.
   * ================================================================
   * [AI 분석] 복잡도:
   *   조건 분기: IF 0회 / 반복문: 0회
   *   DML: SELECT 4회
   * ================================================================
   * 사용 예시:
   *   SELECT F_GET_RUN_LINE_ACTUAL_QTY(...) FROM DUAL;
   * ================================================================ */
 F_GET_RUN_LINE_ACTUAL_QTY
(
  P_RUN_NO  IN VARCHAR2, 
  P_LINE    IN VARCHAR2,
  P_ORG     IN NUMBER 
) RETURN NUMBER AS 


LVL_RETURN NUMBER ;

BEGIN

  LVL_RETURN := 0;
  
    SELECT COUNT(DISTINCT a.PID) 
        INTO LVL_RETURN
     FROM IQ_MACHINE_INSPECT_DATA_AOI a
    WHERE a.PID IN ( SELECT b.SERIAL_NO FROM IP_PRODUCT_2D_BARCODE b WHERE b.RUN_NO = P_RUN_NO ) ;

--  SELECT SUM(PRODUCT_ACTUAL_QTY)
--        INTO LVL_RETURN
--     FROM IP_PRODUCT_SENSOR_ACTUAL
--    WHERE LINE_CODE = P_LINE 
--      AND RUN_NO = P_RUN_NO ;
  
--  ------------------------------------------------------------
--  -- Route 상 io_type = 'C' 생산완성실적으로 집계
--  ------------------------------------------------------------
--   SELECT NVL(SUM(IO_QTY),0)   --COUNT(*) 
--     INTO LVL_RETURN 
--     FROM IP_PRODUCT_WORKSTAGE_IO
--    WHERE LINE_CODE       = P_LINE
--      AND RUN_NO          = P_RUN_NO 
--      AND WORKSTAGE_CODE  = F_GET_WORKSTAGE_CODE_4_LINE(P_LINE, 'C')
--      AND ORGANIZATION_ID = P_ORG;
   
  RETURN LVL_RETURN;
  
  
EXCEPTION 
   WHEN NO_DATA_FOUND THEN 
        RETURN 0 ;
    
END F_GET_RUN_LINE_ACTUAL_QTY;
